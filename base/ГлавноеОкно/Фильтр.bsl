
Процедура ЗаполнитьЭлементФильтра(ЭлемОткуда, Куда, ТолькоНезаполненные = Ложь)
	// Обновляем всегда, либо только незаполненные
	Если НЕ ТолькоНезаполненные ИЛИ НЕ ЗначениеЗаполнено(Куда[ЭлемОткуда.Ключ]) Тогда
		Если ТипЗнч(Куда[ЭлемОткуда.Ключ]) = Тип("СписокЗначений") Тогда
			Если ТипЗнч(ЭлемОткуда.Значение) = Тип("СписокЗначений") Тогда
				Куда[ЭлемОткуда.Ключ].ЗагрузитьЗначения(ЭлемОткуда.Значение.ВыгрузитьЗначения());
			ИначеЕсли ТипЗнч(ЭлемОткуда.Значение) = Тип("Массив") Тогда
				Куда[ЭлемОткуда.Ключ].ЗагрузитьЗначения(ЭлемОткуда.Значение);
			Иначе
				Куда[ЭлемОткуда.Ключ].Добавить(ЭлемОткуда.Значение);
			КонецЕсли;
		Иначе
			Куда.Вставить(ЭлемОткуда.Ключ, ЭлемОткуда.Значение);
		КонецЕсли;
	КонецЕсли;
КонецПроцедуры

Процедура ЗаполнитьЭлементыФильтра(Откуда, Раздел, Куда, ТолькоНезаполненные = Ложь)
	Если get_prop(Откуда, Раздел) = Неопределено Тогда
		Возврат;
	КонецЕсли;
	Попытка
		Если НЕ ЗначениеЗаполнено(Откуда[Раздел]) Тогда
			Возврат;
		КонецЕсли;
		Для Каждого ЭлемОткуда Из Откуда[Раздел] Цикл
			Если get_prop(Куда, ЭлемОткуда.Ключ) <> Неопределено Тогда
				// Обновляем всегда, либо только незаполненные
				ЗаполнитьЭлементФильтра(ЭлемОткуда, Куда, ТолькоНезаполненные);
			КонецЕсли;
		КонецЦикла;
	Исключение
		Сообщить("Ошибка! Не удалось заполнить элементы фильтра из " + Раздел + ". " + ОписаниеОшибки());
	КонецПопытки;
КонецПроцедуры

Процедура ЗаполнитьФильтр() Экспорт
	НастройкиРеестров = get_prop(context_param, "НастройкиРеестров");
	НастройкиТекущегоРеестра = get_prop(НастройкиРеестров, ТекущийРаздел["Идентификатор"]);
	ДанныеФильтра.Значения = Новый Структура;
	Если НастройкиТекущегоРеестра <> Неопределено Тогда 
		ДанныеФильтра.Значения = НастройкиТекущегоРеестра["Фильтр"];
	КонецЕсли;	
	Для Каждого ЭлемФильтр Из ТекущийРаздел.ПараметрыОтображения["Filter"] Цикл
		Если Не ДанныеФильтра.Значения.Свойство(ЭлемФильтр["Name"]) Тогда	
			ТипПоля = Новый ОписаниеТипов(ЭлемФильтр["ValueType"]);
			ДанныеФильтра.Значения.Вставить(ЭлемФильтр["Name"], ТипПоля.ПривестиЗначение());
		КонецЕсли;
	КонецЦикла;	
	// Постоянный фильтр
	ЗаполнитьЭлементыФильтра(ТекущийРаздел, "CONST_FILTER", ДанныеФильтра.Значения);
	// Значения по-умолчанию
	Если НастройкиТекущегоРеестра = Неопределено Тогда 
		ЗаполнитьЭлементыФильтра(ТекущийРаздел, "FILTER", ДанныеФильтра.Значения);
		Если Найти(ЭтаФорма.ИмяФормы, "ДиалогВыбораИзСписка") > 0 Тогда
			ТекущийРаздел["FILTER"] = Неопределено;
		КонецЕсли;
	КонецЕсли;
КонецПроцедуры

Процедура ПрименитьФильтр() Экспорт
	НастройкиРеестров = get_prop(context_param, "НастройкиРеестров");
	Если НастройкиРеестров = Неопределено Тогда
		context_param.Вставить("НастройкиРеестров", Новый Соответствие());	
	КонецЕсли;
	НастройкиТекущегоРеестра = get_prop(context_param["НастройкиРеестров"],  ТекущийРаздел["Идентификатор"]);
	Если НастройкиТекущегоРеестра = Неопределено Тогда
		НастройкиТекущегоРеестра = Новый Соответствие();	
	КонецЕсли;
	НастройкиТекущегоРеестра.Вставить("Фильтр", ДанныеФильтра.Значения);
	context_param["НастройкиРеестров"].Вставить( ТекущийРаздел["Идентификатор"], НастройкиТекущегоРеестра);
	ПолучитьМодульОбъекта().НастройкиПодключенияЗаписать(context_param );
	ИмяТаблицы = ТекущийРаздел["Шаблон"];
	ЭтаФорма[ИмяТаблицы].Очистить();
	Страница = 0;
	ОбновитьСписок(ДанныеФильтра.Значения);
	ОбновитьПанельФильтра();
КонецПроцедуры

Процедура ОбновитьПанельФильтра() Экспорт
	// Формирует строковое представление по всем установленным параметрам фильтра	
	ТекущееЗначениеФильтра="";
	Если ДанныеФильтра.Значения.Свойство("ФильтрПериод") Тогда
		Если ДанныеФильтра.Значения.ФильтрПериод = "За период" Тогда
			ТекущееЗначениеФильтра = ПериодПрописью(ДанныеФильтра.Значения.ФильтрДатаНач, ДанныеФильтра.Значения.ФильтрДатаКнц);
		ИначеЕсли ДанныеФильтра.Значения.ФильтрПериод <> "За весь период" Тогда
			ТекущееЗначениеФильтра = ДанныеФильтра.Значения.ФильтрПериод;
	    КонецЕсли;
	КонецЕсли;
	Если ТекущееЗначениеФильтра = Неопределено Тогда
		ТекущееЗначениеФильтра = "";
	КонецЕсли;
	Для Каждого ЭлемФильтр Из ДанныеФильтра.Значения Цикл
		Если ЭлемФильтр.Ключ = "ФильтрПериод" Или ЭлемФильтр.Ключ = "ФильтрДатаНач" Или ЭлемФильтр.Ключ = "ФильтрДатаКнц" Тогда
			Продолжить;
		Иначе
			Если ЗначениеЗаполнено(ЭлемФильтр.Значение) Тогда	
				Для Каждого ПараметрОтображения Из ДанныеФильтра.ПараметрыОтображения Цикл
					Если ПараметрОтображения["Name"] = ЭлемФильтр.Ключ Тогда
						ТекущееЗначениеФильтра = ТекущееЗначениеФильтра + ", " + ПараметрОтображения["Title"] + ": " + Строка(ЭлемФильтр.Значение);
						Прервать;
					КонецЕсли;
				КонецЦикла;
			КонецЕсли;
		КонецЕсли;
	КонецЦикла;
	
	Если Лев(ТекущееЗначениеФильтра, 2) = ", " Тогда
		ТекущееЗначениеФильтра = Сред(ТекущееЗначениеФильтра,3);
	КонецЕсли;
	
	ЭлемФормы = ПолучитьЭлементыФормыНаСервере();
	ИмяКнопкиОчисткиФильтра = "КнопкаОчиститьФильтр" + ТекущийРаздел["Шаблон"];
	Если ТекущееЗначениеФильтра="" тогда
		ЭлемФормы[ИмяКнопкиОчисткиФильтра].Видимость = Ложь;		
	иначе
		ЭлемФормы[ИмяКнопкиОчисткиФильтра].Видимость = Истина;		
	КонецЕсли;
КонецПроцедуры

Функция ПериодПрописью(ДатНач, ДатКнц)
	Если Год(ДатНач)<>Год(ДатКнц) Тогда
		Возврат Формат(ДатНач, "ДФ=""д ММММ гггг""") + " - " + Формат(ДатКнц, "ДФ=""д ММММ гггг""");
	Иначе
		Если Месяц(ДатНач)<>Месяц(ДатКнц) Тогда
			Возврат Формат(ДатНач, "ДФ=""д ММММ""") + " - " + Формат(ДатКнц, "ДФ=""д ММММ""") + " " + Формат(Год(ДатКнц),"ЧГ=0");	
		Иначе
			Если ДатНач=ДатКнц Тогда
				Возврат Формат(ДатКнц, "ДФ=""д ММММ гггг""")
			Иначе
				Возврат строка(День(ДатНач)) + " - " + Формат(ДатКнц, "ДФ=""д ММММ""") + " "+ Формат(Год(ДатКнц),"ЧГ=0");	
			КонецЕсли;
		КонецЕсли;
	КонецЕсли;
КонецФункции

&НаКлиенте
Процедура ОчиститьФильтр(Элемент)
	// Устанавливает фильтр по умолчанию для текущего раздела	
	ЗначенияФильтра = Новый Структура();
	Если ДанныеФильтра.Значения.Свойство("ФильтрПериод") Тогда
		ДанныеФильтра.Значения.ФильтрПериод = "За весь период";
	КонецЕсли;
	Для Каждого ЭлемФильтр Из ДанныеФильтра.Значения Цикл
		Если ЭлемФильтр.Ключ = "ФильтрПериод" Тогда
			Продолжить;
		Иначе
			Если ЗначениеЗаполнено(ЭлемФильтр.Значение) Тогда	
				Типы = Новый Массив;
				Типы.Добавить(ТипЗнч(ЭлемФильтр.Значение));
				ОписаниеТипа = Новый ОписаниеТипов(Типы);
				ДанныеФильтра.Значения[ЭлемФильтр.Ключ] = ОписаниеТипа.ПривестиЗначение();
			КонецЕсли;
		КонецЕсли;
	КонецЦикла;
	ПрименитьФильтр();
КонецПроцедуры

&НаКлиенте
Процедура ФильтрОткрыть(Элемент, СтандартнаяОбработка)
	СтандартнаяОбработка=Ложь;
	Форма = ПолучитьФормуОбработки("Фильтр", КэшФорм.ПутьКФормам, , ЭтаФорма);
	Форма.ДанныеФильтра = ДанныеФильтра; 
	Если НЕ Форма.Открыта() Тогда
		Форма.Открыть();
	Иначе
		Форма.Активизировать();	
	КонецЕсли;
КонецПроцедуры



Процедура СоздатьРеквизитыТаблицыФормы(Таблица, ИмяТаблицы, Реквизиты, РеквизитыУдалить)
	ТекущиеРеквизиты = ПолучитьРеквизиты(ИмяТаблицы);
	Для Каждого Рек Из ТекущиеРеквизиты Цикл
		РеквизитыУдалить.Добавить(Рек.Путь+"."+Рек.Имя);
	КонецЦикла;
	КвалификаторыСтроки = Новый КвалификаторыСтроки();
	ОписаниеТипаСтрока = Новый ОписаниеТипов("Строка", ,КвалификаторыСтроки);
	Для Каждого Колонка Из ТекущийРаздел.ПараметрыОтображения["Columns"] Цикл
		ОписаниеТипа = ОписаниеТипаСтрока;
		Тип = get_prop(Колонка, "Type");
		Если Тип <> Неопределено Тогда
			Если Тип = "Соответствие" Тогда
				ОписаниеТипа = Новый ОписаниеТипов();
			Иначе
				ОписаниеТипа = ОписаниеТипаКолонки(Колонка["Type"]);
			КонецЕсли;
		КонецЕсли;
		Рек = Новый РеквизитФормы(Колонка["Name"], ОписаниеТипа, ИмяТаблицы);
		Реквизиты.Добавить(Рек);
		Таблица.Колонки.Добавить(Колонка["Name"], ОписаниеТипа);
		Если get_prop(Колонка, "More") = Истина Тогда
			Рек = Новый РеквизитФормы("ЗагрузитьЕще", ОписаниеТипаСтрока, ИмяТаблицы);
			Реквизиты.Добавить(Рек);
			Таблица.Колонки.Добавить("ЗагрузитьЕще", ОписаниеТипаСтрока);
		КонецЕсли;
	КонецЦикла;
КонецПроцедуры

&НаСервере
Процедура ОбновитьСписок(Фильтр) Экспорт
	ЭлемФормы = ПолучитьЭлементыФормыНаСервере();
	ИмяТаблицы = ТекущийРаздел["Шаблон"];
	
	ТабПоле = ЭлемФормы[ИмяТаблицы];
	Данные = ПолучитьДанныеСписка(Фильтр);
	Если ИмяТаблицы = "ПлоскийСписок" Тогда
		Таблица = ДанныеФормыВЗначение(ЭтаФорма[ИмяТаблицы], Тип("ТаблицаЗначений"));
		ЗаполнитьДанныеПлоскогоСписка(Таблица, Данные);
	Иначе
		Таблица = ДанныеФормыВЗначение(ЭтаФорма[ИмяТаблицы], Тип("ДеревоЗначений"));
		ЗаполнитьДанныеИерархическогоСписка(Таблица, Данные);	
	КонецЕсли;
	ЗначениеВДанныеФормы(Таблица, ЭтаФорма[ИмяТаблицы]);
	ТабПоле.Обновить();
	
КонецПроцедуры

#Область include_core_base_ГлавноеОкно_ПлоскийСписокУФ
#КонецОбласти

#Область include_core_base_ГлавноеОкно_ИерархическийСписокУФ
#КонецОбласти

#Область include_core_base_ГлавноеОкно_Список
#КонецОбласти


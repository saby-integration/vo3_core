
&НаСервере
Процедура ПлоскийСписокПриОткрытии(ПараметрыОтображения)
	Страница = 0;
	ОчиститьПанельОпераций(ТекущийРаздел.ПараметрыОтображения);
	ОчиститьКонтекстноеМеню();
	ТекущийРаздел.Вставить("ПараметрыОтображения", ПараметрыОтображения);
			
	ЗаполнитьФильтр();
	ЗаполнитьКолонкиПлоскогоСписка();
	ЭтаФорма.ФильтрМаска = "";
	ДанныеФильтра.Значения.Вставить("ФильтрМаска", ЭтаФорма.ФильтрМаска);
	ОбновитьСписок(ДанныеФильтра.Значения);
	ДанныеФильтра.ПараметрыОтображения = ПараметрыОтображения["Filter"];
	ОбновитьПанельФильтра();
	ОбновитьПанельОпераций();
	ОбновитьКонтекстноеМеню();
	
	Если ДанныеФильтра.ПараметрыОтображения.Количество() = 0 Тогда
		ЭлемФормы = ПолучитьЭлементыФормыНаСервере();
		ЭлемФормы.ПоказатьПанельФильтраПлоскийСписок.Видимость = Ложь;
	КонецЕсли;
КонецПроцедуры

&НаСервере
Функция ПолучитьДанныеСписка(Фильтр) Экспорт
	МодульОбъекта = ПолучитьМодульОбъекта();
	ПараметрыКоманды = Новый Структура("algorithm, endpoint, Filter, params", ТекущийРаздел["Идентификатор"], "main", Фильтр);
	Pagination = Новый Структура();
	Pagination.Вставить("PageSize", get_prop(ТекущийРаздел["ПараметрыОтображения"], "Limit", 25));
	Pagination.Вставить("Page", Страница);  
	ПараметрыКоманды.Вставить("Pagination", Pagination);
	РезультатИни = МодульОбъекта.LocalCalcIni(ПараметрыКоманды);
	Если РезультатИни["status"] = "error" Тогда
		ВызватьИсключение NewExtExceptionСтрока(, "Ошибка выполнения ini: '" + ПараметрыКоманды["algorithm"]
				+ "', endpoint: '" + ПараметрыКоманды["endpoint"] + "'" + Символы.ПС + РезультатИни.data.message,
			РезультатИни.data.detail, РезультатИни.data.action);
	КонецЕсли;	
	Результат = РезультатИни.data;
	Возврат Результат;
КонецФункции

&НаСервере
Процедура ЗаполнитьДанныеПлоскогоСписка(Таблица, Данные) Экспорт
	МодульОбъекта = ПолучитьМодульОбъекта();
	Список = Данные["Rows"];
	Навигация = Данные["Pagination"];
	
	Для Каждого Стр Из Список Цикл
		СтрТ = Таблица.Добавить();
		Для Каждого Колонка Из ТекущийРаздел.ПараметрыОтображения["Columns"] Цикл
			ПутьКДанным = Колонка["Data"];
			Если ЗначениеЗаполнено(ПутьКДанным) Тогда
				СтрТ[Колонка["Name"]] = МодульОбъекта.block_obj_get_path_value(Стр, ПутьКДанным, "");
			Иначе
				СтрТ[Колонка["Name"]] = "";
			КонецЕсли;
		КонецЦикла;
	КонецЦикла;
	ЕстьЕще = get_prop(Навигация, "HasMore");
	Если ЕстьЕще = Истина Или ЕстьЕще = "Да" Тогда
		СтрТ = Таблица.Добавить();
		СтрТ["ЗагрузитьЕще"] = "Загрузить еще";
	КонецЕсли;
КонецПроцедуры

&НаКлиенте
Процедура ПлоскийСписокВыбор(Элемент, ВыбраннаяСтрока, Колонка, СтандартнаяОбработка)
	Если Колонка.Имя = "ПлоскийСписокЗагрузитьЕще" Тогда
		ПлоскийСписок.Удалить(Элемент.ТекущиеДанные);
		ЗагрузитьЕщеПлоскийСписокНажатие();
		Возврат;	
	КонецЕсли;
	ВыбраннаяСтрокаДанные = Элемент.ТекущиеДанные;
	Попытка
		ИмяФормыДокумента = ВыбраннаяСтрокаДанные["ФормаПросмотра"];
	Исключение
		ИмяФормыДокумента = Неопределено;	
	КонецПопытки;
	ИмяФормыПоУмолчанию = ТекущийРаздел.ПараметрыОтображения.Получить("Form");
	Попытка
		ДокументСБИС = ВыбраннаяСтрокаДанные["ДокументСБИС"];
	Исключение
		ДокументСБИС = Неопределено;
	КонецПопытки;
	Попытка
		ДокументИС = ВыбраннаяСтрокаДанные["ДокументИС"]; 
	Исключение
		ДокументИС = Неопределено;
	КонецПопытки;
	ShowForm(КэшФорм.Формы, КэшФорм.ИменаФорм, КэшФорм.ПутьКФормам, ДокументИС, ДокументСБИС, ИмяФормыДокумента, ИмяФормыПоУмолчанию);
КонецПроцедуры

Процедура ЗагрузитьЕщеПлоскийСписокНажатие()
	Страница = Страница + 1;
	ОбновитьСписок(ДанныеФильтра.Значения);
КонецПроцедуры

&НаКлиенте
Функция СписокОтмеченныхЗаписей(ЭтоСписокСсылок = Ложь)
	СписокОтмеченных = Новый Массив;
	Для Каждого Строка Из ПлоскийСписок Цикл
		Если Строка.Отмечен Тогда
			СписокОтмеченных.Добавить(Строка);	
		КонецЕсли;
	КонецЦикла;
	Если СписокОтмеченных.Количество()=0 Тогда
		ЭлемФормы = ПолучитьЭлементыФормы();
		Если ЭлемФормы.ПлоскийСписок.ТекущаяСтрока<>Неопределено Тогда
			СписокОтмеченных.Добавить(ЭлемФормы.ПлоскийСписок.ТекущиеДанные);
		Конецесли;
	КонецЕсли;
	Возврат СписокОтмеченных;

КонецФункции


&НаКлиенте
Процедура ОтметитьВсеПлоскийСписокНажатие(Элемент)
	ОтмеченыВсе = Не ОтмеченыВсе;
	Для Каждого Строка Из ПлоскийСписок Цикл
		Строка.Отмечен = ОтмеченыВсе;
	КонецЦикла;
КонецПроцедуры


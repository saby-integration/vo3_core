
&НаКлиенте
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
		ЭлемФормы = ПолучитьЭлементыФормы();
		ЭлемФормы.ПоказатьПанельФильтраПлоскийСписок.Видимость = Ложь;
	КонецЕсли;
КонецПроцедуры

&НаКлиенте
Функция ПолучитьДанныеСписка(Фильтр) Экспорт
	ПараметрыКоманды = Новый Структура("algorithm, endpoint, Filter, params", ТекущийРаздел["Идентификатор"], "main", Фильтр);
	Pagination = Новый Структура();
	Pagination.Вставить("PageSize", get_prop(ТекущийРаздел["ПараметрыОтображения"], "Limit", 25));
	Pagination.Вставить("Page", Страница);  
	ПараметрыКоманды.Вставить("Pagination", Pagination);
	РезультатИни = BlocklyExecutor.LocalCalcIni(ПараметрыКоманды);
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
			ПутьКДанным = get_prop(Колонка, "Data", get_prop(Колонка, "PROPERTY"));
			ИмяКолонки = get_prop(Колонка, "Name", get_prop(Колонка, "NAME"));
			Если ЗначениеЗаполнено(ПутьКДанным) Тогда
				СтрТ[ИмяКолонки] = МодульОбъекта.block_obj_get_path_value(Стр, ПутьКДанным, "");
			Иначе
				СтрТ[ИмяКолонки] = "";
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
	Если Элемент.ТекущиеДанные = Неопределено Тогда
		Возврат;
	КонецЕсли;
	Если Колонка.Имя = "ПлоскийСписокЗагрузитьЕще" Тогда
		ПлоскийСписок.Удалить(Элемент.ТекущиеДанные);
		ЗагрузитьЕщеПлоскийСписокНажатие();
		Возврат;	
	КонецЕсли;
	ОткрытьФорму1СПоСтрокеПлоскогоСписка(Элемент);
КонецПроцедуры

&НаКлиенте
Процедура ОткрытьФорму1СПоСтрокеПлоскогоСписка(Элемент)
	
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

&НаКлиенте
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
		КонецЕсли;
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

&НаКлиенте
Процедура ОткрытьФорму1СПлоскогоСписка(Команда) Экспорт
	ЭлемФормы = ПолучитьЭлементыФормы();
	ОткрытьФорму1СПоСтрокеПлоскогоСписка(ЭлемФормы.ПлоскийСписок);		
КонецПроцедуры

&НаКлиенте
Процедура ОткрытьТиповуюФормуОбъекта(Команда) Экспорт
	ЭлемФормы = ПолучитьЭлементыФормы();
	ВыбраннаяСтрокаДанные = ЭлемФормы.ПлоскийСписок.ТекущиеДанные;
	Если ВыбраннаяСтрокаДанные <>Неопределено Тогда 
		Попытка
			ДокументИС = ВыбраннаяСтрокаДанные["ДокументИС"]; 
		Исключение
			ДокументИС = Неопределено;
		КонецПопытки;
		Если НЕ ЗначениеЗаполнено(ДокументИС) Тогда
			Сообщить("Нет связанных документов 1С");
			Возврат;
		КонецЕсли;
		ShowForm(КэшФорм.Формы, , , ДокументИС, , , );
	КонецЕсли;
КонецПроцедуры

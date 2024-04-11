
#Область include_core_base_locale_ЛокализацияНазваниеПродукта
#КонецОбласти

#Область include_core_base_ГлавноеОкно_СписокУФ
#КонецОбласти

#Область include_core_base_ГлавноеОкно_ПанельОперацийУФ
#КонецОбласти

#Область include_core_base_ГлавноеОкно_АвторизацияУФ
#КонецОбласти

#Область include_core_base_Helpers_XDTO
#КонецОбласти

#Область include_core_base_Helpers_РаботаСоСвойствамиСтруктуры
#КонецОбласти

#Область include_core_base_ExtException
#КонецОбласти

Процедура ПолучитьИмяФормы()
	// Заглушка
КонецПроцедуры


&НаКлиенте
Функция ТекущийДокументИС()
	Возврат Элементы.ПлоскийСписок.ТекущиеДанные.ДокументИС;	
КонецФункции

&НаКлиенте
Функция КнопкаВыгрузитьВ1С()
	Возврат Элементы.МенюПриложенияПлоскийСписок.ПодчиненныеЭлементы.Найти("ВыгрузитьВ1С")
КонецФункции

&НаКлиенте
Процедура ПоказатьМенюВыгрузитьВ1С(СписокКнопок)
    ОписаниеОповещения = Новый ОписаниеОповещения("МенюВыгрузитьВ1СОбработкаОповещения", ЭтаФорма);
    ПоказатьВыборИзМеню(ОписаниеОповещения, СписокКнопок, КнопкаВыгрузитьВ1С());
КонецПроцедуры

&НаКлиенте
Функция СформироватьМассивВыгружаемыхДокументов() 
	СписокОтмеченныхЗаписей = СписокОтмеченныхЗаписей(Ложь);
	ВыгружаемыеДокументы = Новый Массив();
	Для Каждого Запись Из СписокОтмеченныхЗаписей Цикл
		ДокументСБИС = Запись["ДокументСБИС"]; 
		Если ДокументСБИС <> Неопределено Тогда
			ИмяСБИС = ДокументСБИС["Тип"];
			ПримечаниеСБИС = ДокументСБИС["Примечание"];
			ИдентификаторДокумента = ДокументСБИС["Идентификатор"];
			ИмяИзСБИСвАПИ3(ИмяСБИС, ПримечаниеСБИС, ИдентификаторДокумента);
			
			API3_ref = Новый Структура; 
			API3_ref.Вставить("SbisId",		ИдентификаторДокумента);
			API3_ref.Вставить("SbisType",	ИмяСБИС);
			API3_ref.Вставить("Type",		ИмяСБИС);
			API3_ref.Вставить("Title",		ДокументСБИС["Название"]);
			ВыгружаемыеДокументы.Добавить(API3_ref);

		КонецЕсли;	
	КонецЦикла;
	Возврат ВыгружаемыеДокументы; 	
КонецФункции

&НаКлиенте
Функция СформироватьМассивВыгружаемыхДокументов1С()
	СписокОтмеченныхЗаписей = СписокОтмеченныхЗаписей(Ложь);
	ВыгружаемыеДокументы = Новый Массив();
	Для Каждого Запись Из СписокОтмеченныхЗаписей Цикл
		Если Не ЗначениеЗаполнено(Запись.ДокументИС) Тогда
			Продолжить; 
		КонецЕсли;
		ДокументИССсылка = Запись.ДокументИС.Ссылка;
		Если Не ЗначениеЗаполнено(ДокументИССсылка) Тогда
			Продолжить; 
		КонецЕсли;
		ВыгружаемыеДокументы.Добавить(ДокументИССсылка);
	КонецЦикла;
	Возврат ВыгружаемыеДокументы;	
КонецФункции


#Область include_core_base_ДлительныеОперации_ПодготовкаФормыОсобенностиПродуктаОбработка
#КонецОбласти

#Область include_core_base_ВстраиваниеВФормы_ОберткаСерверныхКоманд
#КонецОбласти

&НаКлиенте
Процедура ОткрытьВSABYНажатие(Элемент)
	ТекущийДокументСБИС = Элементы.ПлоскийСписок.ТекущиеДанные.ДокументСБИС;
	Если ТекущийДокументСБИС <> Неопределено Тогда
		//ПараметрыФормы = Новый Структура("Заголовок, АдресСтраницы",
		//ТекущийДокументСБИС["Название"],
		//ПолучитьПрямуюССылку(ТекущийДокументСБИС["СсылкаДляНашаОрганизация"]));
		ПерейтиПоНавигационнойСсылке(ПолучитьПрямуюССылку(ТекущийДокументСБИС["СсылкаДляНашаОрганизация"]));
	КонецЕсли
КонецПроцедуры

#Область include_core_base_ДлительныеОперации_ПодготовкаФормыОбщие
#КонецОбласти


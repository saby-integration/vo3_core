
&НаКлиенте
Процедура ПередЗакрытиемГО(Отказ, СтандартнаяОбработка)
	Если ТипЗнч(context_param) = Тип("Структура") И ТекущийРаздел <> Неопределено Тогда
		context_param.Вставить("РазделПоУмолчанию", ТекущийРаздел.Идентификатор);
		ЗаписатьНастройкиНаСервере();
	КонецЕсли;
КонецПроцедуры

#Область include_core_base_ГлавноеОкно_СписокОФ
#КонецОбласти

#Область include_core_base_ГлавноеОкно_ПанельОперацийОФ
#КонецОбласти

#Область include_core_base_ГлавноеОкно_АвторизацияОФ
#КонецОбласти

Процедура ПолучитьИмяФормы()
	ИмяФормы = "ГлавноеОкно";
КонецПроцедуры

&НаКлиенте
Функция ТекущийДокументИС() 
	Возврат ЭлементыФормы.ПлоскийСписок.ТекущиеДанные.ДокументИС;
КонецФункции

Функция КнопкаВыгрузитьВ1С() 
	Возврат ЭлементыФормы["ВыгрузитьВ1С"];
КонецФункции	

Процедура ПоказатьМенюВыгрузитьВ1С(СписокЗначений)
	ЗначениеВыбора = ВыбратьИзМеню(СписокЗначений,КнопкаВыгрузитьВ1С());
	МенюВыгрузитьВ1СОбработкаОповещения(ЗначениеВыбора, Неопределено);
КонецПроцедуры

Процедура ОткрытьВSABYНажатие(Элемент)
	ТекущийДокументСБИС = ЭлементыФормы.ПлоскийСписок.ТекущиеДанные.ДокументСБИС;
	Если ТекущийДокументСБИС <> Неопределено Тогда
		ПараметрыФормы = Новый Структура("Заголовок, АдресСтраницы",
		ТекущийДокументСБИС["Название"],
		ПолучитьПрямуюССылку(ТекущийДокументСБИС["СсылкаДляНашаОрганизация"]));
		Уникальность = Новый УникальныйИдентификатор(ТекущийДокументСБИС["Идентификатор"]);
		ОткрытьФормуОбработки("Browser", ПараметрыФормы, ЭтаФорма, Уникальность);	
	КонецЕсли
КонецПроцедуры

#Область include_core_base_ДлительныеОперации_ПодготовкаФормыОбщиеОФ
#КонецОбласти

#Область include_core_base_ВстраиваниеВФормы_КомандаПоискНачалоВыбораНажатиеОФ
#КонецОбласти


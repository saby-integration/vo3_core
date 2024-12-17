
#Область include_BlocklyExecutor_base_Variables //&НаКлиенте
#КонецОбласти

#Область include_BlocklyExecutor_base_VariableSABYHTTPClient //&НаКлиенте
#КонецОбласти

#Область include_core_base_Helpers_РаботаСоСвойствамиСтруктуры //&НаКлиентеНаСервереБезКонтекста
#КонецОбласти

#Область include_core_base_ExtException
#КонецОбласти

#Область include_core_base_locale_ЛокализацияНазваниеПродукта
#КонецОбласти

#Область include_core_base_Helpers_FormGetters
#КонецОбласти

#Область include_core_base_LocalHelper //&НаКлиенте
#КонецОбласти

#Область include_core_base_ОсобенностиПлатформы_РаботаСоСтроками
#КонецОбласти

#Область include_core_base_Helpers_ОпределениеТиповКонтента
#КонецОбласти

#Область include_BlocklyExecutor_base_Helper //&НаКлиентеНаСервереБезКонтекста
#КонецОбласти

#Область include_BlocklyExecutor_base_Helper_ArrayHelper
#КонецОбласти

#Область include_core_base_ПроверкаВерсии_ПолучитьИмяФайлаИНомерТекущейВерсии
#КонецОбласти

#Область include_base_НазваниеПродукта
#КонецОбласти

#Область include_core_base_Helpers_ОбщиеНастройки
#КонецОбласти

#Область include_core_base_Helpers
#КонецОбласти

#Область include_core_base_Helpers_НастройкиПодключения
#КонецОбласти

#Область include_core_base_Helpers_ПреобразованиеТиповТаблицаМассив
#КонецОбласти

#Область include_base_ОбработчикиСобытий_ПриОбновленииСБИС
#КонецОбласти

#Область include_core_base_СтатусыДокументов_МодульОбработки //&НаКлиенте
#КонецОбласти

#Область include_core_base_Helpers_ПослеАвторизации //&НаКлиенте
#КонецОбласти

#Область include_core_base_Helpers_ПолучитьПодключение //&НаКлиенте
#КонецОбласти

#Область include_core_base_ОбщийМодульКонфигурации
#КонецОбласти

#Область include_core_base_API //&НаКлиенте
#КонецОбласти

#Область include_base_ОбработчикиСобытий_ПриСозданииНовогоПодключения //&НаКлиенте
#КонецОбласти

#Область include_core_base_ПроверкаВерсии_ВМодулеОбъекта //&НаКлиенте
#КонецОбласти

#Область include_core_base_ДлительныеОперации
#КонецОбласти

#Область include_core_base_Транспорт_МетодыВызоваИзФорм //&НаКлиенте
#КонецОбласти

&НаСервере
Функция ВойтиНаСервере(context_param)
	Модуль = ПолучитьМодульОбъекта();
	Модуль.ВойтиНаСервере(context_param);
КонецФункции

//DynamicDirective
Функция ЭтоСервер() Экспорт
	context_params = НастройкиПодключенияПрочитать();
	ВидТранспорта = ВидТранспорта(context_params);
	Если ВидТранспорта = "ExtSdk2" Или ВидТранспорта = "SabyPluginConnector"  Тогда 
		Возврат Ложь;
	КонецЕсли;
	Возврат Истина;
КонецФункции

Процедура СообщитьПрогресс(Знач Процент = Неопределено, Знач Текст = Неопределено, Знач ДополнительныеПараметры = Неопределено) Экспорт
		
	ПередаваемоеЗначение = Новый Структура;
	Если Процент <> Неопределено Тогда
		ПередаваемоеЗначение.Вставить("Процент", Процент);
	КонецЕсли;
	Если Текст <> Неопределено Тогда
		ПередаваемоеЗначение.Вставить("Текст", Текст);
	КонецЕсли;
	Если ДополнительныеПараметры <> Неопределено Тогда
		Если ТипЗнч(ДополнительныеПараметры) = Тип("Структура") ИЛИ ТипЗнч(ДополнительныеПараметры) = Тип("Соответствие") Тогда
			ДополнительныеПараметры.Удалить("variables");
		КонецЕсли;
		ПередаваемоеЗначение.Вставить("ДополнительныеПараметры", ДополнительныеПараметры);
	КонецЕсли;
	
	ПередаваемыйТекст = encode_xdto_xml(ПередаваемоеЗначение);
	
	Текст = ПередаваемыйТекст;
	Сообщение = Новый СообщениеПользователю;
	Сообщение.Текст = Текст;
	Сообщение.Сообщить();	
КонецПроцедуры

Функция ЭтотОбъектНаСервере()
	Возврат ЭтаФорма;
КонецФункции	




#Область include_BlocklyExecutor_base_Variables //&НаКлиенте
#КонецОбласти

#Область include_BlocklyExecutor_base_VariableSABYHTTPClient //&НаКлиенте
#КонецОбласти

#Область include_core_base_locale_ЛокализацияНазваниеПродукта //&НаКлиентеНаСервереБезКонтекста
#КонецОбласти

#Область include_BlocklyExecutor_base_Action //&НаКлиентеНаСервереБезКонтекста
#КонецОбласти

#Область include_BlocklyExecutor_base_Workspace //&НаКлиенте
#КонецОбласти

#Область include_BlocklyExecutor_base_BlockTemplates_SimpleBlock //&НаКлиенте
#КонецОбласти

#Область include_BlocklyExecutor_base_Block //&НаКлиенте
#КонецОбласти

#Область include_BlocklyExecutor_base_Helper //&НаКлиентеНаСервереБезКонтекста
#КонецОбласти

#Область include_BlocklyExecutor_base_Executor //&НаКлиенте
#КонецОбласти
 
#Область include_BlocklyExecutor_base_Helper_ArrayHelper 
#КонецОбласти

#Область include_core_base_Helpers_РаботаСоСвойствамиСтруктуры 
#КонецОбласти     

#Область include_core_base_ExtException 
#КонецОбласти 

#Область include_IntegrationBlockly_base_Blocks //&НаКлиенте
#КонецОбласти

#Область include_BlocklyExecutor_base_Blocks //&НаКлиенте
#КонецОбласти

#Область include_core_base_LocalHelper //&НаКлиенте
#КонецОбласти       

#Область include_BlocklyExecutor_base_Context //&НаКлиенте
#КонецОбласти 

#Область include_core_base_Helpers_ОбновитьСтруктуру
#КонецОбласти

#Область include_core_base_Helpers_ПреобразованиеТиповТаблицаМассив
#КонецОбласти

#Область include_core_base_Helpers
#КонецОбласти

#Область include_BlocklyExecutor_base_ЗагрузитьФайлыНаДиск //&НаКлиенте
#КонецОбласти

#Область include_BlocklyExecutor_base_СконвертироватьВПДФА3 //&НаКлиенте
#КонецОбласти   

#Область include_core_base_ОсобенностиПлатформы_МодульОбъекта
#КонецОбласти

#Область include_core_base_Helpers_ПреобразованиеТипов
#КонецОбласти

#Область include_BlocklyExecutor_base_INIOperation //&НаКлиенте
#КонецОбласти 

#Область include_BlocklyExecutor_base_Report //&НаКлиенте
#КонецОбласти

#Область include_BlocklyExecutor_base_Отладка //&НаКлиенте
#КонецОбласти

#Область include_core_base_Helpers_ПрикрепленныеФайлы
#КонецОбласти

#Область include_core_base_Helpers_ПрикрепленныеФайлыЭДО
#КонецОбласти      

#Область include_core_base_ОбщийМодульКонфигурации
#КонецОбласти  

#Область include_core_base_Helpers_ОпределениеТиповКонтента
#КонецОбласти

#Область include_core_base_Транспорт_SabyHttpsClient_МодульОбъекта //&НаКлиенте
#КонецОбласти

#Область include_core_base_Транспорт_SabyHttpsClient_ПолучениеКомпоненты 
#КонецОбласти 

#Область include_core_base_Helpers_НастройкиПодключения
#КонецОбласти     

#Область include_core_base_ПроверкаВерсии_ПолучитьИмяФайлаИНомерТекущейВерсии
#КонецОбласти

#Область include_base_НазваниеПродукта
#КонецОбласти  

#Область include_core_base_СтатусыДокументов_МодульОбработки //&НаКлиенте
#КонецОбласти

Функция ОбщиеНастройкиПрочитать() Экспорт
	УстановитьПривилегированныйРежим(Истина);
	ИмяПродукта = ПолучитьИмяПродукта();	
	ОбщиеНастройки = ХранилищеОбщихНастроек.Загрузить(ИмяПродукта, "params",,ИмяПродукта);
	Возврат ОбщиеНастройки;
КонецФункции

#Область include_IntegrationBlockly_base_Blocks_Api3Objects //&НаКлиенте
#КонецОбласти

#Область include_core_base_Криптография_БазовыеМеханизмы //&НаКлиенте
#КонецОбласти

#Область include_core_base_Криптография_НаСервере1С   
#КонецОбласти

#Область include_core_base_Криптография_Дистанционная //&НаКлиенте
#КонецОбласти

#Область include_core_base_Криптография_ЛокальнаяНаФорме //&НаКлиенте
#КонецОбласти

#Область include_core_base_ДлительныеОперации
#КонецОбласти

#Область include_BlocklyExecutor_base_APIClient //&НаКлиенте
#КонецОбласти

#Область include_BlocklyExecutor_base_Robots //&НаКлиенте
#КонецОбласти

Функция СформироватьУРЛСТикетом(УрлРесурса, Тикет)
	
	ПосОРГ3 = Найти(УрлРесурса, "&org=3");
	Если ПосОРГ3 > 0 Тогда
		УрлРесурса	= Сред(УрлРесурса, 1, ПосОРГ3 - 1);
	КонецЕсли;				
	
	УрлРесурса = УрлРесурса + ?(ЗначениеЗаполнено(Тикет), "&ticket=" + Тикет, "");
	
	Возврат УрлРесурса;
	
КонецФункции
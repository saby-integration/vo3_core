#Область ОписаниеПеременных

&НаКлиенте
Перем ИнтервалОжидания;
&НаКлиенте
Перем ФормаЗакрывается;
&НаКлиенте
Перем МенеджерыКриптографии;

#КонецОбласти

#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	ЭтаФорма.Заголовок = Параметры.ФоновоеЗаданиеНаименование;
	ТекстСообщения = НСтр("ru = 'Пожалуйста, подождите...'");
	Если Не ПустаяСтрока(Параметры.ТекстСообщения) Тогда
		ТекстСообщения = Параметры.ТекстСообщения + Символы.ПС + ТекстСообщения;
		Элементы.ДекорацияПоясняющийТекстДлительнойОперации.Заголовок = ТекстСообщения;
	КонецЕсли;
	
	Если ЗначениеЗаполнено(Параметры.ИдентификаторЗадания) Тогда
		ИдентификаторЗадания = Параметры.ИдентификаторЗадания;
	Иначе
		ИдентификаторЗадания = Новый УникальныйИдентификатор;
	КонецЕсли;
	Если Параметры.ФоновоеЗаданиеПараметры[0].Свойство("ПараметрыВыполнения") 
		И ТипЗнч(Параметры.ФоновоеЗаданиеПараметры[0].ПараметрыВыполнения) = Тип("Соответствие") Тогда
		ВложенияАдресВХранилище = ПоместитьВоВременноеХранилище("", ЭтаФорма.УникальныйИдентификатор);
		Параметры.ФоновоеЗаданиеПараметры[0].ПараметрыВыполнения.Вставить("ВложенияАдресВХранилище", ВложенияАдресВХранилище);
	КонецЕсли;
	
	ФоновоеЗадание = ФоновыеЗадания.Выполнить(Параметры.ФоновоеЗаданиеИмяМетода, Параметры.ФоновоеЗаданиеПараметры, Строка(ИдентификаторЗадания),Параметры.ФоновоеЗаданиеНаименование);
	ИдентификаторЗадания = ФоновоеЗадание.УникальныйИдентификатор;

КонецПроцедуры

&НаКлиенте
Процедура ПриОткрытии(Отказ)
	
	Если Параметры.ВыводитьОкноОжидания Тогда
		ИнтервалОжидания = ?(Параметры.Интервал <> 0, Параметры.Интервал, 1);
		ПодключитьОбработчикОжидания("Подключаемый_ПроверитьВыполнениеЗадания", ИнтервалОжидания, Истина);
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ПередЗакрытием(Отказ, ЗавершениеРаботы, ТекстПредупреждения, СтандартнаяОбработка)
	
	ОтключитьОбработчикОжидания("Подключаемый_ПроверитьВыполнениеЗадания");
	
	Если Статус <> "Выполняется" Тогда
		Возврат;
	КонецЕсли;
	
	Отказ = Истина;
	Если ЗавершениеРаботы Тогда
		Возврат;
	КонецЕсли;
	
	ПодключитьОбработчикОжидания("Подключаемый_ОтменитьЗадание", 0.1, Истина);
	
КонецПроцедуры

&НаКлиенте
Процедура ПриЗакрытии(ЗавершениеРаботы)
	
	Если ЗавершениеРаботы Тогда
		Возврат;
	КонецЕсли;
	
	Если Статус <> "Выполняется" Тогда
		Возврат;
	КонецЕсли;
	
	ОтменитьВыполнениеЗадания();
	
КонецПроцедуры

#КонецОбласти

#Область include_core_base_ДлительныеОперации_ПроверитьВыполнениеЗадания
#КонецОбласти

#Область include_core_base_ExtException
#КонецОбласти

#Область include_core_base_Helpers_РаботаСоСвойствамиСтруктуры
#КонецОбласти

#Область include_BlocklyExecutor_base_Commands
#КонецОбласти

#Область include_core_base_Криптография_НаКлиенте1С
#КонецОбласти



&НаКлиенте
Процедура ЗапуститьINIФоновымЗаданием(ini_name, ПараметрыВызоваИни, context_params = Неопределено,
	ФормаВладелец = Неопределено, ЗаголовокФормы = "") Экспорт
	
	ОповещениеОЗакрытииФормыФоновогоЗадания = Неопределено;	
	Если context_params <> Неопределено Тогда
		context_params.Свойство("ОповещениеОЗакрытииФормыФоновогоЗадания", ОповещениеОЗакрытииФормыФоновогоЗадания);
		context_params.Удалить("ОповещениеОЗакрытииФормыФоновогоЗадания");
	КонецЕсли;
	
	ПараметрыВызова = ПодготовитьПараметрыЗапускINIФоновымЗаданиемНаСервере(ini_name, ПараметрыВызоваИни, context_params);
	
	ЗаполнитьПутьОбработкиДляВыполненияФоновогоЗадания();
	ПараметрыДлительныеОперации = Новый Структура;
	Если ТипЗнч(ИмяОбработки) = Тип("Строка") Тогда
		ПараметрыДлительныеОперации.Вставить("ИмяОбработки",					ИмяОбработки); 
	Иначе     
		ПараметрыДлительныеОперации.Вставить("ДополнительнаяОбработкаСсылка",	ИмяОбработки); 	
	КонецЕсли;
	ПараметрыДлительныеОперации.Вставить("ИмяМетода",			"API_BLOCKLY_RUN_BACKGROUND");
	ПараметрыДлительныеОперации.Вставить("ПараметрыВыполнения",	ПараметрыВызова);
	ПараметрыДлительныеОперации.Вставить("ЭтоВнешняяОбработка",	ЭтоВнешняяОбработка());
	
	ВыполняемыйМетод = "ДлительныеОперации.ВыполнитьПроцедуруМодуляОбъектаОбработки";
	
	ПараметрыЗадания = Новый Массив;
	ПараметрыЗадания.Добавить(ПараметрыДлительныеОперации);
	ПараметрыЗадания.Добавить("");

	ОткрытьФормуДлительнойОперации(ВыполняемыйМетод,ПараметрыЗадания, ЗаголовокФормы, ФормаВладелец,ОповещениеОЗакрытииФормыФоновогоЗадания); 

КонецПроцедуры

&НаКлиенте
Процедура ОткрытьФормуДлительнойОперации(ФоновоеЗаданиеИмяМетода, ФоновоеЗаданиеПараметры,
		ФоновоеЗаданиеНаименование, Владелец, ОповещениеОЗакрытииФормы = Неопределено) Экспорт
   	Сообщение = Новый Структура("Показать, Пояснение, Текст, НавигационнаяСсылка", Истина, ФоновоеЗаданиеНаименование, "Выполняется...");

	ВладелецИдентификатор = Неопределено;
	Попытка
		ВладелецИдентификатор = Владелец.УникальныйИдентификатор;
	Исключение
		ВладелецИдентификатор = Неопределено;
	КонецПопытки;
	
	ПараметрыФормы = Новый Структура;
	ПараметрыФормы.Вставить("АдресДополнительногоРезультата");
	ПараметрыФормы.Вставить("АдресРезультата");
	ПараметрыФормы.Вставить("ВыводитьОкноОжидания", Истина);
	ПараметрыФормы.Вставить("ВыводитьПрогрессВыполнения", Истина);
	ПараметрыФормы.Вставить("ВыводитьСообщения", Истина);
	ПараметрыФормы.Вставить("ИдентификаторЗадания", Новый УникальныйИдентификатор);
	ПараметрыФормы.Вставить("УникальныйИдентификатор", ВладелецИдентификатор);
	ПараметрыФормы.Вставить("Интервал", 1);
	ПараметрыФормы.Вставить("ОжидатьЗавершение", Ложь);
	ПараметрыФормы.Вставить("ОповещениеПользователя", Сообщение);
	ПараметрыФормы.Вставить("ПолучатьРезультат", Ложь);
	ПараметрыФормы.Вставить("ТекстСообщения", ФоновоеЗаданиеНаименование);
	ПараметрыФормы.Вставить("ФоновоеЗаданиеИмяМетода", ФоновоеЗаданиеИмяМетода);
	ПараметрыФормы.Вставить("ФоновоеЗаданиеПараметры", ФоновоеЗаданиеПараметры);
	ПараметрыФормы.Вставить("ФоновоеЗаданиеНаименование", ФоновоеЗаданиеНаименование);
	ПараметрыФормы.Вставить("ОповещениеОЗакрытииФормы", ОповещениеОЗакрытииФормы); 
	ИмяФормыДлительнойОперации = ТипМетаданныхОбработки()+".SABY.Форма.ДлительнаяОперация";
	
	МодульФоновогоЗаданияКлиент().ЗапуститьФоновоеЗаданиеКлиент(ПараметрыФормы, Владелец);
КонецПроцедуры

#Область include_core_base_ФоновыеЗадания_КлиентИмяОбработчкикаФЗ
#КонецОбласти

#Область include_core_base_ФоновыеЗадания_Клиент
#КонецОбласти

&НаСервере
Функция ПодготовитьПараметрыЗапускINIФоновымЗаданиемНаСервере(ini_name, ПараметрыВызоваИни, context_params = Неопределено)
	МодульОбъекта = МодульОбъекта();
	Возврат МодульОбъекта.ПодготовитьПараметрыЗапускINIФоновымЗаданием(ini_name, ПараметрыВызоваИни, context_params)
КонецФункции

&НаСервере
Процедура ЗапуститьФоновоеЗадание(ПараметрыЗаданияОбработки, ИмяМетода, НаименованиеФоновогоЗадания) 
	ПараметрыЗадания = Новый Структура;
	ПараметрыЗадания.Вставить("ДополнительнаяОбработкаСсылка",	Неопределено); 	
	Если ТипЗнч(ИмяОбработки) = Тип("Строка") Тогда
		ПараметрыЗадания.Вставить("ИмяОбработки",					ИмяОбработки); 
	Иначе     
		ПараметрыЗадания.Вставить("ДополнительнаяОбработкаСсылка",	ИмяОбработки); 	
	КонецЕсли;
	ПараметрыЗадания.Вставить("ИмяМетода",				ИмяМетода);
	ПараметрыЗадания.Вставить("ПараметрыВыполнения",	ПараметрыЗаданияОбработки);
	ПараметрыЗадания.Вставить("ЭтоВнешняяОбработка",	ЭтоВнешняяОбработка());
	
	УникальныйИдентификаторЗадания = Новый УникальныйИдентификатор;
	
	ВыполняемыйМетод = "ДлительныеОперации.ВыполнитьПроцедуруМодуляОбъектаОбработки";
	
	ПараметрыДлительныеОперации = Новый Массив();
	ПараметрыДлительныеОперации.Добавить(ПараметрыЗадания);
	ПараметрыДлительныеОперации.Добавить("");
	
	ФоновоеЗадание = ФоновыеЗадания.Выполнить(ВыполняемыйМетод, ПараметрыДлительныеОперации, Строка(УникальныйИдентификаторЗадания), НаименованиеФоновогоЗадания);
	ИдентификаторЗадания = ФоновоеЗадание.УникальныйИдентификатор;
КонецПроцедуры
	

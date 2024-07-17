Функция ПолучитьСсылкуПоИдИС(знач ИмяИС, ИдИС) Экспорт
	Попытка
		мИмяИС = СтрРазделить82(ИмяИС,".");
		Если мИмяИС[0] = "Документы" Тогда
			УИД = Новый УникальныйИдентификатор(ИдИС);
			МенеджерОбъекта = Документы[мИмяИС[1]];
			Ссылка = МенеджерОбъекта.ПолучитьСсылку(УИД);
		ИначеЕсли мИмяИС[0] = "Справочники" Тогда
			УИД = Новый УникальныйИдентификатор(ИдИС);
			МенеджерОбъекта = Справочники[мИмяИС[1]];
			Ссылка = МенеджерОбъекта.ПолучитьСсылку(УИД);
		ИначеЕсли мИмяИС[0] = "Перечисления" Тогда
			МенеджерОбъекта = Перечисления[мИмяИС[1]];
			Ссылка = МенеджерОбъекта[ИдИС];
		ИначеЕсли мИмяИС[0] = "ПланыВидовРасчета" Тогда
			УИД = Новый УникальныйИдентификатор(ИдИС);
			МенеджерОбъекта = ПланыВидовРасчета[мИмяИС[1]];
			Ссылка = МенеджерОбъекта.ПолучитьСсылку(УИД);
		ИначеЕсли мИмяИС[0] = "ПланыВидовХарактеристик" Тогда
			УИД = Новый УникальныйИдентификатор(ИдИС);
			МенеджерОбъекта = ПланыВидовХарактеристик[мИмяИС[1]];
			Ссылка = МенеджерОбъекта.ПолучитьСсылку(УИД);
		КонецЕсли;
		Если Найти(Строка(Ссылка), "<Объект не найден>") > 0 Тогда
			ВызватьИсключение NewExtExceptionСтрока(,"Объект не найден",ИмяИС+" "+ИдИС,"ПолучитьСсылкуПоИдИС",,"NotFound");
		КонецЕсли;
		Возврат Ссылка;
	Исключение
		ИнфОбОшибке = ИнформацияОбОшибке();
		ВызватьИсключение NewExtExceptionСтрока(ИнфОбОшибке,,,"ПолучитьСсылкуПоИдИС");
	КонецПопытки;
КонецФункции


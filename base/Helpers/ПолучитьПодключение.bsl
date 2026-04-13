
//DynamicDirective    

Процедура ПроверкаExtSysUid(system_info, НоваяИнтеграция, context_param)
	ExtSysUid = get_prop(system_info, "ExtSysUid");
	Если ExtSysUid = Неопределено Тогда 
		ExtSysUid = get_prop(context_param, "ExtSysUid");
		system_info.Вставить("ExtSysUid", ExtSysUid);
	КонецЕсли;	
	Если ExtSysUid = Неопределено И Не НоваяИнтеграция Тогда
		filter = Новый Структура("connection_type,service", "account", get_prop(system_info, "Connector"));
		connection_info = Новый Структура("filter,ini", filter, Неопределено);
		ИнтеграцииПользователя = ТранспортИнтеграции.local_helper_read_connection_list(context_param, connection_info);	
    	Если ИнтеграцииПользователя.Количество() > 0 Тогда 
			ВызватьИсключение NewExtExceptionСтрока(, "ChooseIntegration", , , ИнтеграцииПользователя, "ChooseIntegration"); 
		Иначе
			НоваяИнтеграция = Истина;
		КонецЕсли;	
	КонецЕсли;
	Если НоваяИнтеграция Тогда
		system_info.Вставить("ExtSysUid", Строка(Новый УникальныйИдентификатор));	
	КонецЕсли;	
КонецПроцедуры	

// Возвращает информацию о подключении.
//
// Параметры:
//  context_param - Структура - Контекст.
//	НоваяИнтеграция - Булево - Признак создания новой интеграции
//
// Возвращаемое значение:
//  Структура - Информация о подключении.
//
//DynamicDirective
Функция ПолучитьПодключение(context_param, НоваяИнтеграция = Ложь) Экспорт
	system_info = API_ADDON_READSYSTEMINFO(Неопределено);
	ПроверкаExtSysUid(system_info, НоваяИнтеграция, context_param);	
	Попытка
		connection_info = ТранспортИнтеграции.local_helper_init_connection(context_param, system_info);
		ConnectionStateEvents = get_prop(connection_info, "ConnectionStateEvents", Новый Массив);
		Если ConnectionStateEvents.Найти("NewSystem") <> Неопределено Тогда
			ПриСозданииНовойИнтеграции(connection_info);
		КонецЕсли;
		Если ConnectionStateEvents.Найти("NewServiceVersion") <> Неопределено Тогда
			СброситьКэшНаСервере(); // Сбрасываем кэш инишек при смене версии онлайна
		КонецЕсли;
		context_param.Вставить("Integration", get_prop(connection_info, "Integration"));
		context_param.Вставить("ConnectionId", get_prop(connection_info, "ConnectionId"));
		context_param.Вставить("DemoLicense", get_prop(connection_info, "DemoLicense"));
		Если НоваяИнтеграция Тогда 
			context_param.Вставить("ExtSysUid", get_prop(system_info, "ExtSysUid"));	
		КонецЕсли;
		Возврат connection_info;
	Исключение
		ИнфОбОшибке = ИнформацияОбОшибке();
		context_param.Вставить("Integration", "");
		context_param.Вставить("ConnectionId", "");
		context_param.Вставить("DemoLicense", Неопределено);
		НастройкиПодключенияЗаписать(context_param);
		ВызватьИсключение(NewExtExceptionСтрока(ИнфОбОшибке));
	КонецПопытки;
	
КонецФункции


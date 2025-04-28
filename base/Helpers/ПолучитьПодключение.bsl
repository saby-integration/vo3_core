
// Возвращает информацию о подключении.
//
// Параметры:
//  context_param - Структура - Контекст.
//
// Возвращаемое значение:
//  Структура - Информация о подключении.
//
//DynamicDirective
Функция ПолучитьПодключение(context_param) Экспорт
	system_info = API_ADDON_READSYSTEMINFO(Неопределено);
	connection_info = ТранспортИнтеграции.local_helper_init_connection(context_param, system_info);
	ConnectionStateEvents = get_prop(connection_info, "ConnectionStateEvents", Новый Массив);
	Если ConnectionStateEvents.Найти("NewSystem") <> Неопределено Тогда
		ПриСозданииНовогоПодключения(connection_info);
	КонецЕсли;
	context_param.Вставить("ConnectionId", get_prop(connection_info, "ConnectionId"));
	context_param.Вставить("DemoLicense", get_prop(connection_info, "DemoLicense"));
	context_param.Вставить("ExtSysSettingsId", get_prop(connection_info, "ExtSysSettingsId", "") );
	
	Возврат connection_info;
КонецФункции



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
	Попытка
		connection_info = ТранспортИнтеграции.local_helper_init_connection(context_param, system_info);
		ConnectionStateEvents = get_prop(connection_info, "ConnectionStateEvents", Новый Массив);
		Если ConnectionStateEvents.Найти("NewSystem") <> Неопределено Тогда
			ПриСозданииНовойИнтеграции(connection_info);
		КонецЕсли;
		context_param.Вставить("Integration", get_prop(connection_info, "Integration"));
		context_param.Вставить("ConnectionId", get_prop(connection_info, "ConnectionId"));
		context_param.Вставить("DemoLicense", get_prop(connection_info, "DemoLicense"));
		Возврат connection_info;
	Исключение
		ИнфОбОшибке = ИнформацияОбОшибке();
		context_param.Вставить("Integration", "");
		context_param.Вставить("ConnectionId", "");
		context_param.Вставить("DemoLicense", "");
		НастройкиПодключенияЗаписать(context_param);
		ВызватьИсключение(NewExtExceptionСтрока(ИнфОбОшибке));
	КонецПопытки;
	
КонецФункции


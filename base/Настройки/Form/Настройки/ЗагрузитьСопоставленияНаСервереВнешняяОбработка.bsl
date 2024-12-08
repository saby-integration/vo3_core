
&НаСервере
Процедура ЗагрузитьСопоставленияНаСервере(connection_info)
	//Дополнительная первоначальная ручная инициализация элементов справочника

	Модуль = МодульОбъекта();
	context_param = Модуль.НастройкиПодключенияПрочитать();
	system_info = Модуль.API_ADDON_READSYSTEMINFO(Неопределено);
	system_info.Вставить("ConnectionStateEvents", Новый Массив);
	system_info["ConnectionStateEvents"].Добавить("NewSystem");
	connection_info = Модуль.local_helper_init_connection(context_param, system_info);
	Модуль.ПриСозданииНовогоПодключения(connection_info);
КонецПроцедуры


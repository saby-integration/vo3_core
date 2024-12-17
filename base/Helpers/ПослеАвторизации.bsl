
//DynamicDirective
Функция ПослеАутентификации(context_param) Экспорт
	Попытка
		connection_info = ПолучитьПодключение(context_param);
		ОбщиеНастройки = ОбщиеНастройкиПрочитать();
		ОбщиеНастройки.Вставить("ExtSysSettingsId", get_prop(connection_info, "ExtSysSettingsId", ""));
		context_param.Удалить("ExtSysSettingsId");
		//Установим признак необходимости получения токена
		context_param.Вставить("last_token_time", Неопределено);
		user_info = Транспорт.local_helper_get_user_info(context_param);
		context_param.Вставить("account", user_info["Аккаунт"]["Номер"]);
		fio = user_info["Фамилия"] + " " + user_info["Имя"] + " " + user_info["Отчество"];  
		context_param.Вставить("user_fio", СокрЛП(fio));
		context_param.Вставить("service", СтатусыДокументовСервис(context_param));
		
		ОбщиеНастройкиЗаписать(ОбщиеНастройки);
		СтатусыДокументовИнициализация(context_param);
	Исключение
		ИнфОбОшибке = ИнформацияОбОшибке();
		НастройкиПодключенияЗаписать(context_param);
		ВызватьИсключение(NewExtExceptionСтрока(ИнфОбОшибке));
	КонецПопытки;
	НастройкиПодключенияЗаписать(context_param); 
	ЗаписатьСвойствоParent(context_param, connection_info);
	Возврат connection_info;
КонецФункции

//DynamicDirective
Процедура ЗаписатьСвойствоParent(context_param = Неопределено, connection_info = Неопределено, parent = Неопределено) Экспорт
	ОбщиеНастройки = ОбщиеНастройкиПрочитать();
	Если parent = Неопределено Тогда
		Если ОбщиеНастройки.Свойство("parent") 
			И ЗначениеЗаполнено(ОбщиеНастройки.parent) Тогда
			Возврат;
		КонецЕсли;  
		Версия = ПреобразоватьВерсию(ВерсияМетаданных());
		id = connection_info.Получить("ConnectionId");
		params = Новый Структура("id,Версия",id,Версия);
		Результат = Транспорт.local_helper_read_connection(context_param, params);
		ОбщиеНастройки.Вставить("parent", Результат.Получить("parent")); 
	Иначе  
		ОбщиеНастройки.Вставить("parent", parent); 	
	КонецЕсли;
	ОбщиеНастройкиЗаписать(ОбщиеНастройки);	
КонецПроцедуры


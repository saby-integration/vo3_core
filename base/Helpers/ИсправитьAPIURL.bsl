
//Удалить после 25.3100
Процедура ИсправитьAPIURL() 
	context_params = НастройкиПодключенияПрочитать();
	api_url = get_prop(context_params, "api_url", "");
	Если Найти(api_url, "ie-1c") > 0 Или Найти(api_url, "ieg-1c") > 0 Тогда
		api_url = СтрЗаменить(api_url, "ie-1c", "online");
		api_url = СтрЗаменить(api_url, "ieg-1c", "g");
		context_params.Вставить("api_url", api_url);
		НастройкиПодключенияЗаписать(context_params);
	КонецЕсли;	
КонецПроцедуры	


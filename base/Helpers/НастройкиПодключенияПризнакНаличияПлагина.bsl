
&НаКлиенте
Процедура УстановитьВариантВебИнтерфейса(context_params) Экспорт
	// Пагин остутствует
	web_interface = "BrowserSaby"; 
	Если context_params	= Неопределено Тогда
		context_params	= Новый Структура;
	Иначе
		#Если Не ВебКлиент Тогда 
		Попытка
			// не https, иначе словим исключение - ошибка установки соединения
			local_helper_exec_request_HTTPСоединение("get", "http://localhost:9100/", , , context_params);
			// Пагин присутствует
			web_interface = "BrowserSabyPlugin";
		Исключение
			// Сюда вываливаемся когда плагин не запущен
			web_interface = "BrowserSaby";
		КонецПопытки;
		#КонецЕсли
	КонецЕсли;      
	context_params.Вставить("web_interface",	web_interface);
	НастройкиПодключенияЗаписать(context_params);
КонецПроцедуры


//Выполнение POST/GET запроса
// request_type: get, post, post_binary (в дата лежит имя временного файла)
// response_type: json, text, binary (в ответе будет лежать имя временного файла)

//DynamicDirective
Функция ВидТранспорта(context_params) Экспорт
	Результат = block_obj_get_path_value(context_params, "public.exchange_method", "");
	Возврат Результат;
КонецФункции

//DynamicDirective
Функция local_helper_exec_request(type_request, url, response_type, ПараметрыВыполнения, context_params, timeout = 60) Экспорт
	ВидТранспорта = ВидТранспорта(context_params);
	Если ВидТранспорта = "SabyHttpsClient" Тогда
		code_result = local_helper_exec_request_SabyHttpsClient(type_request, url, response_type, ПараметрыВыполнения, context_params); 
	Иначе 
		code_result = local_helper_exec_request_HTTPСоединение(type_request, url, response_type, ПараметрыВыполнения, context_params);	
	КонецЕсли;
	Возврат code_result;
КонецФункции

//DynamicDirective
Функция local_helper_exec_request_HTTPСоединение_get_response(http_connection, http_request, request_type)
	http_response = Неопределено;
	Если request_type = "post" ИЛИ request_type = "post_binary" Тогда
		Попытка
			http_response	= http_connection.ОтправитьДляОбработки(http_request);
		Исключение
			ИнфОбОшибке = ИнформацияОбОшибке();
			ВызватьИсключение NewExtExceptionСтрока(ИнфОбОшибке, "Ошибка выполнения HTTP запроса");
		КонецПопытки;
	ИначеЕсли request_type = "get" Тогда
		Попытка
			http_response	= http_connection.Получить(http_request);	
		Исключение
			ИнфОбОшибке = ИнформацияОбОшибке();
			ВызватьИсключение NewExtExceptionСтрока(ИнфОбОшибке, "Ошибка выполнения HTTP запроса");
		КонецПопытки;
	Иначе
		ВызватьИсключение NewExtExceptionСтрока(,"Неизвестный тип HTTP запроса", request_type);		
	КонецЕсли;
   	Возврат http_response;
КонецФункции

//DynamicDirective
Функция local_helper_exec_request_HTTPСоединение(request_type, Знач request_url, response_type,
		__kwargs = Неопределено, context_params = Неопределено, Знач НомПереадресации = 0) Экспорт
	Перем ProxyParam, ssl, headers;

	Адрес = РазобратьСтрокуУРЛ(request_url);
		
	kwargs = __kwargs;
	Если kwargs = Неопределено Тогда
		kwargs = Новый Структура;
	КонецЕсли;
	
	Если Адрес.scheme = "https" Тогда
		ssl = Новый ЗащищенноеСоединениеOpenSSL();
	КонецЕсли;
	ProxyParam = get_prop(context_params, "Proxy");
	Если Proxy = Неопределено и ProxyParam <> Неопределено Тогда
		ИспользоватьАутентификациюОС = get_prop(ProxyParam, "ИспользоватьАутентификациюОС", Ложь);
		Proxy = Новый ИнтернетПрокси;
		Proxy.Установить(ProxyParam.Protocol, ProxyParam.Server, Число(ProxyParam.Port), ProxyParam.User, ProxyParam.Password, ИспользоватьАутентификациюОС);
	КонецЕсли;
	
	headers = get_prop(kwargs, "headers", Новый Соответствие);
	
	Попытка
		http_connection = Новый HTTPСоединение(Адрес.host, Адрес.port,,,Proxy,180,ssl);
		http_request	= Новый HTTPЗапрос(Адрес.resource, headers);
		Если request_type = "post" Тогда
			http_request.УстановитьТелоИзСтроки(kwargs.data, "UTF-8", ИспользованиеByteOrderMark.Авто);
		ИначеЕсли request_type = "post_binary" Тогда
			http_request.УстановитьИмяФайлаТела(kwargs.data);	
		КонецЕсли;
	Исключение
		ИнфОбОшибке = ИнформацияОбОшибке();
		ВызватьИсключение NewExtExceptionСтрока(ИнфОбОшибке, "Ошибка создания HTTP запроса");
	КонецПопытки;
	
	http_response = local_helper_exec_request_HTTPСоединение_get_response(http_connection, http_request, request_type);
	
	Если http_response.КодСостояния = 302 И НомПереадресации < 5 Тогда // Обработка переадресации
		Возврат local_helper_exec_request_HTTPСоединение(
					request_type,
					http_response.Заголовки["Location"], // Новое расположение
					response_type,
					__kwargs,
					context_params,
					НомПереадресации + 1);
	КонецЕсли;
	
	Возврат local_helper_exec_request_HTTPСоединение_process_responce(response_type, http_response);		
	
КонецФункции

//DynamicDirective
Функция local_helper_exec_request_HTTPСоединение_process_responce(response_type, http_response)
	
	response = Новый Структура("code, result", http_response.КодСостояния);
	
	content_type = http_response.Headers["Content-Type"];
	Попытка
		Если response.code = 200 Тогда
			Если response_type = "json" Тогда
				response.result = local_helper_json_loads(http_response.ПолучитьТелоКакСтроку());	
			ИначеЕсли response_type = "text" Тогда
				response.result = http_response.ПолучитьТелоКакСтроку();
			ИначеЕсли response_type = "binary" Тогда	
				response.result = http_response.ПолучитьТелоКакДвоичныеДанные();
			КонецЕсли;
		Иначе
			Тело = http_response.ПолучитьТелоКакСтроку();
			
			Если ПустаяСтрока(Тело) Тогда
				response.result = СокрЛП(response.code) + " Неизвестная ошибка";
			Иначе
				Если Найти(content_type, "application/json") > 0 Тогда
					response.result = local_helper_json_loads(Тело);	
				иначе
					response.result = Новый Соответствие();
					response.result.Вставить("error", Новый Структура("message", Тело));
				КонецЕсли;
			КонецЕсли;
		КонецЕсли;
		Возврат response;		
	Исключение
		ИнфОбОшибке = ИнформацияОбОшибке();
		ВызватьИсключение NewExtExceptionСтрока(ИнфОбОшибке, "Ошибка разбора HTTP ответа");
	КонецПопытки;
КонецФункции


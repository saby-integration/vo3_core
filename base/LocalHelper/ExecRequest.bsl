
#Область include_core_base_Транспорт_МодульExtSdk2
#КонецОбласти

#Область include_core_base_Транспорт_МодульSabyPluginConnector
#КонецОбласти

#Область include_core_base_Транспорт_SabyHttpsClient_МодульОбъекта
#КонецОбласти

#Область include_core_base_Транспорт_TransportCallMethodExtSDK2
#КонецОбласти

//Выполнение POST/GET запроса
// request_type: get, post, post_binary (в дата лежит имя временного файла)
// response_type: json, text, binary (в ответе будет лежать имя временного файла)

Функция local_helper_exec_request_HTTPСоединение_server(type_request, url, response_type, ПараметрыВыполнения, context_params) 
	МодульОбъекта = МодульОбъекта();
	Возврат МодульОбъекта.local_helper_exec_request_HTTPСоединение(type_request, url, response_type, ПараметрыВыполнения, context_params);
КонецФункции

// Выполняет запрос своим методом, в зависимости от вида транспорта
//
// Параметры:
//  type_request - Произвольный - тип запроса.
//  url - ссылка - ссылка.
//  response_type - Произвольный - тип ответа.
//  ПараметрыВыполнения - Произвольный - Параметры.
//  context_params - Структура - Контекст.
//  timeout - Число - таймаут.
//
// Возвращаемое значение:
//  Структура - результат выполнения.
//
//DynamicDirective
Функция local_helper_exec_request(type_request, url, response_type, ПараметрыВыполнения, context_params, timeout = 60) Экспорт
	ВидТранспорта = ВидТранспорта(context_params);
	Если ВидТранспорта = "SabyHttpsClient" Тогда
		code_result = local_helper_exec_request_SabyHttpsClient(type_request, url, response_type, ПараметрыВыполнения, context_params); 
	ИначеЕсли ВидТранспорта = "ExtSdk2" Тогда
		code_result = local_helper_exec_request_extsdk2(type_request, url, response_type, ПараметрыВыполнения, context_params); 
	ИначеЕсли ВидТранспорта = "SabyPluginConnector" Тогда
		code_result = local_helper_exec_request_sabypluginconnector(type_request, url, response_type, ПараметрыВыполнения, context_params); 
	Иначе 
		code_result = local_helper_exec_request_HTTPСоединение_server(type_request, url, response_type, ПараметрыВыполнения, context_params);	
	КонецЕсли;
	Возврат code_result;
КонецФункции

// Получает ответ на действие с HTTP-соединением
//
// Параметры:
//  http_connection - HTTPСоединение.
//  http_request - HTTPЗапрос.
//  request_type - Строка - тип запроса.
//
// Возвращаемое значение:
//  HTTPОтвет
//
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

// Выполнить запрос через HTTP-соединение
//
// Параметры:
//  request_type - Строка - тип запроса.
//  request_url - Строка - ссылка.
//  response_type - Строка - тип ответа.
//  __kwargs - Структура - параметры.
//  context_params - Структура - Контекст.
//  НомПереадресации - Число.
//
// Возвращаемое значение:
//  Структура - "code, result"
//
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
	ИспользоватьАутентификациюОС = Ложь;
	Если Proxy = Неопределено и ProxyParam <> Неопределено Тогда
		ИспользоватьАутентификациюОС = get_prop(ProxyParam, "ИспользоватьАутентификациюОС", Ложь);
		Proxy = Новый ИнтернетПрокси;
		Proxy.Установить(ProxyParam.Protocol, ProxyParam.Server, Число(ProxyParam.Port), ProxyParam.User, ProxyParam.Password, ИспользоватьАутентификациюОС);
	КонецЕсли;
	
	headers = get_prop(kwargs, "headers", Новый Соответствие);
	
	Попытка
		http_connection = Новый HTTPСоединение(Адрес.host, Адрес.port,,,Proxy,180,ssl,ИспользоватьАутентификациюОС);
		http_request	= Новый HTTPЗапрос(Адрес.resource, headers);
		Если request_type = "post" Тогда
			#Если Не ВебКлиент Тогда
			http_request.УстановитьТелоИзСтроки(kwargs.data, "UTF-8", ИспользованиеByteOrderMark.Авто);
			#КонецЕсли
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

// Обработать ответ на запрос через HTTP-соединение
//
// Параметры:
//  request_type - Строка - тип запроса.
//  http_response - HTTPОтвет - ответ.
//
// Возвращаемое значение:
//  Структура - "code, result"
//
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

// Заполняет параметры для выполнения метода через ExtSdk2.
//
// Параметры:
//  ПараметрыВыполнения - Структура - параметры.
//  request_url - Строка - ссылка.
//
// Возвращаемое значение:
//  Структура - "MethodName,ПараметрыВызова"
//
//DynamicDirective
Функция local_helper_exec_request_extsdk2_get_parameters(ПараметрыВыполнения, request_url)
	QueryId = Строка(Новый УникальныйИдентификатор); 
	ПараметрыМетода = get_prop(ПараметрыВыполнения, "params", Неопределено);
	Если Найти(request_url,"integration_config") > 0 Тогда
		MethodName = "ExtSdk2.CallIntegrationApi2"; 
	Иначе
		MethodName = "ExtSdk2.CallSabyApi2"; 
	КонецЕсли; 
	ПараметрыCallApi = Новый Массив;
	Если Не ПараметрыМетода = Неопределено Тогда
		Для Каждого КлючИЗначение Из ПараметрыМетода Цикл
			ПараметрыCallApi.Добавить(КлючИЗначение.Значение);
		КонецЦикла;
	КонецЕсли;  
	params = ПараметрыCallApi;
	Если ПараметрыCallApi.Количество() = 0 Тогда
		params = Новый Структура;	
	КонецЕсли;	

	ПараметрыВызова = Новый Соответствие;
	ПараметрыВызова.Вставить("Method", get_prop(ПараметрыВыполнения,"method",""));
	ПараметрыВызова.Вставить("Params", params);
	Возврат Новый Структура("MethodName,ПараметрыВызова", MethodName, ПараметрыВызова);
КонецФункции




Функция local_helper_exec_method_process_responce_error_ТребуетсяПодтверждениеДействия(error, _message)
	Возврат (Найти(get_prop(error, _message, ""), "Для входа введите полученный код подтверждения.") > 0
			ИЛИ Найти(get_prop(error, _message, ""), "Ошибка аутентификации. Пустое значение поля Пароль!") > 0
			ИЛИ Найти(get_prop(error, _message, ""), "Требуется подтверждение действия") > 0)
КонецФункции

// Обработка ошибки выполнения метода
//
// Параметры:
//  code_result - Структура - Результат выполнения.
//  ПараметрыВыполнения - Произвольный - Контекст метода.
//
// Возвращаемое значение:
//  Булево - Ложь, если нет ошибки.
//           При ошибке кидается исключение с подробным описанием.
//
//DynamicDirective
Функция local_helper_exec_method_process_responce_error(code_result, ПараметрыВыполнения)
	Если block_obj_get_path_value(code_result,"result.error", Неопределено) = Неопределено Тогда
		Возврат Ложь;
	КонецЕсли;	
	_message = "message";
	error = code_result.result["error"];
	Если ТипЗнч(error) = Тип("Строка") Тогда
		msg = error;
	Иначе
		Попытка
			msg = error[_message]; 
		Исключение
			msg = "Ошибка";
		КонецПопытки;
	КонецЕсли;
	
	detail = get_prop(error, "details", get_prop(error, "detail"));
	Если (detail <> Неопределено) И (msg = detail) Тогда
		detail = Неопределено;				
	КонецЕсли;
	error_code = get_prop(error, "code", 0);
	Если	(error_code  = -32000 Или error_code  = 303)
		И local_helper_exec_method_process_responce_error_ТребуетсяПодтверждениеДействия(error, _message)
		Тогда  
		detail = get_prop(error, "data", error);
		detail.Вставить("code", 303);
		dump = get_prop(detail, "dump");
		Если dump <> Неопределено  
			И get_prop(detail, "addinfo") = Неопределено Тогда  
			ВставитьСвойствоЕслиНет(dump, "Сообщение", get_prop(dump, "SelectMessage") );
			ВставитьСвойствоЕслиНет(dump, "Телефон", get_prop(dump, "Phone") );
			ВставитьСвойствоЕслиНет(dump, "Идентификатор", get_prop(dump, "ResourceID") );
			ВставитьСвойствоЕслиНет(dump, "ИдентификаторСессии", get_prop(dump, "SessionID") );
			ВставитьСвойствоЕслиНет(dump, "МетодОтправкиКодаПодтверждения", get_prop(dump, "MethodToSend") );
			ВставитьСвойствоЕслиНет(dump, "МетодПроверкиКодаИсключения", get_prop(dump, "MethodToValidate") );
			detail.Вставить("addinfo", dump);
		КонецЕсли;	
	КонецЕсли;
	
	_type = Неопределено;
	Если get_prop(code_result, "code", 0) = 401 Тогда
		_type = "Unauthorized";
	КонецЕсли;
	ВызватьИсключение NewExtExceptionСтрока(, msg, detail, "Ошибка API " + get_prop(ПараметрыВыполнения, "method", ""), , _type);
КонецФункции

// Обработка результата выполнения метода
//
// Параметры:
//  code_result - Структура - Результат выполнения.
//  auto_auth - Булево - автоматически выполняет аутентификацию по логину и паролю.
//  type_request - Произвольный - Тип запроса.
//  url - Строка - Ссылка.
//  response_type - Произвольный - Тип ответа.
//  ПараметрыВыполнения - Произвольный - Контекст метода.
//  context_params - Структура - Контекст.
//
//DynamicDirective
Процедура local_helper_exec_method_process_responce(code_result, auto_auth, type_request, url, response_type, ПараметрыВыполнения, context_params) 
	
	Если code_result.code = 401 Тогда
		AutoAuth = get_prop(context_params, "AutoAuth");
		Если auto_auth И AutoAuth <> Ложь Тогда
			ВойтиТранспорт(context_params);
			local_helper_add_auth_header(context_params, ПараметрыВыполнения.Headers);			
			code_result = local_helper_exec_request(type_request, url, response_type, ПараметрыВыполнения, context_params);
		КонецЕсли;
	КонецЕсли;
	
	Если local_helper_exec_method_process_responce_error(code_result, ПараметрыВыполнения) Тогда
		ВызватьИсключение NewExtExceptionСтрока(,"Ошибка API",,,,"" ); 
	ИначеЕсли code_result.code = 503 или code_result.code = 504 Тогда
		ВызватьИсключение NewExtExceptionСтрока(,"Извините, мы на техническом обслуживании", "Код ошибки: " + code_result.code,,, "ServiceUnavailable");
	ИначеЕсли Не (code_result.code = 200 ИЛИ code_result.code = 201) Тогда
		//TODO Текст ошибки в детаил
		ВызватьИсключение NewExtExceptionСтрока(  ,"Неизвестная ошибка", "Код ошибки: " + code_result.code );
	Иначе
		Возврат;	
	КонецЕсли;
КонецПроцедуры	

// Обработка результата выполнения асинхронного вызова с обработкой ошибок
//
// Параметры:
//  context_param - Структура - Контекст.
//  QueryId - Произвольный - Ключ запроса.
//
// Возвращаемое значение:
//  Структура - Результат ответа на запрос
//
//DynamicDirective
Функция local_helper_exec_method_process_responce_async(context_param, QueryId) Экспорт 
	async_responce = async_responces.Получить(QueryId); 
	responce = local_helper_exec_request_async_process_responce(async_responce, context_param);
	
	ПараметрыЗапроса = get_prop(async_responce,"ПараметрыЗапроса");
	type_request = get_prop(ПараметрыЗапроса,"type_request");
	url = get_prop(ПараметрыЗапроса,"url");
	response_type = get_prop(ПараметрыЗапроса,"response_type");
	ПараметрыВыполнения = get_prop(ПараметрыЗапроса,"ПараметрыВыполнения");
	context_params = get_prop(ПараметрыЗапроса,"context_params");
	auto_auth = get_prop(ПараметрыЗапроса,"auto_auth");
	local_helper_exec_method_process_responce(responce, auto_auth, type_request, url, response_type, ПараметрыВыполнения, context_params); 
	Возврат responce.result;
КонецФункции

// Создаются заголовки для расширенного логирования
//
// Параметры:
//  context_params - Структура - Контекст.
//
// Возвращаемое значение:
//  Соответствие - Заголовки для расширенного логирования
//
//DynamicDirective
Функция local_helper_exec_method_get_headers_for_advanced_log(context_params) Экспорт 
	headers = Новый Соответствие;
	advanced_log_on = get_prop(context_params, "advanced_log", Дата(1, 1, 1));
	Если ТипЗнч(advanced_log_on) = Тип("Булево") Тогда
		advanced_log_on = Дата(1, 1, 1);	
	КонецЕсли;
	// BSLLS:DeprecatedCurrentDate-off
	Если ТекущаяДата() - advanced_log_on < 86400 Тогда   // выключаем логирование, если больше суток прошло
		headers.Вставить("X-LogEntireTask", "true");
	КонецЕсли;
	// BSLLS:DeprecatedCurrentDate-on
	Возврат headers;
КонецФункции

// Заполняем обязательные заголовки для json.rpc в передаваемом по ссылке параметре data.
// data сериализуется в json.
//
// Параметры:
//  request_body_type - Строка - Тип тела запроса. Должен быть "json", иначе исключение.
//  method - Строка - Имя метода.
//  kwargs - Структура - Аргументы.
//  headers - Структура - Заголовки.
//  data - Структура - Данные.
//  params - Структура - Параметры.
//  context_params - Структура - Контекст.
//
//DynamicDirective
Процедура local_helper_exec_method_fill_data_headers_params(request_body_type, method, kwargs, headers, data, Знач params, context_params)
	Если request_body_type <> "json" Тогда 
		ВызватьИсключение NewExtExceptionСтрока( Новый Структура("message, detail", "Неизвестный тип отправки запроса.", request_body_type));			
	КонецЕсли;
	Если ДанныеОВерсииИнтеграции = Неопределено Тогда
		ДанныеОВерсииИнтеграции = ПолучитьИмяФайлаИНомерТекущейВерсии();
	КонецЕсли;	
	ДанныеОВерсии = ДанныеОВерсииИнтеграции;	
	ИдПриложения = "" + ДанныеОВерсии[0] + "/" + ДанныеОВерсии[1];  
	headers.Вставить("User-Agent", ИдПриложения);
	Если headers.Получить("Content-Type") = Неопределено Тогда
		//headers.Вставить("Content-Type", "application/xml");
		headers.Вставить("Content-Type", "application/json; charset=utf-8");
	КонецЕсли;
	Если ЗначениеЗаполнено(method) Тогда
		data = Новый Структура("jsonrpc,	id,	method", "2.0",		1,	method);
		headers.Вставить("Content-Type", "application/json-rpc;charset=utf-8");
		Если ЗначениеЗаполнено(params) Тогда
			data.Вставить("params", params);
		КонецЕсли;
		Если kwargs.Свойство("protocol") Тогда
			data.Вставить("protocol", kwargs.protocol);
		КонецЕсли;
		data = local_helper_json_encode(data);
		params = Новый Структура;
	Иначе
		Если ЗначениеЗаполнено(params) Тогда
			data = local_helper_json_encode(params);
		КонецЕсли;
		Если Не kwargs.Свойство("params", params) Тогда
			params = Новый Структура;
		КонецЕсли;
	КонецЕсли;			
КонецПроцедуры	

// Метод для вызова АПИ БЛ
// Выполненяет метод API БЛ
//
// Параметры:
//  context_params - Структура - Контекст.
//  method - Строка - Имя метода.
//  params_method - Произвольный - Параметры метода.
//  auto_auth - Булево - автоматически выполняет аутентификацию по логину и паролю.
//  __kwargs - Структура - Аргументы.
//  url - Строка - Ссылка.
//
// Возвращаемое значение:
//  Структура - Результат вызова метода БЛ.
//
//DynamicDirective
Функция local_helper_exec_method(context_params, method, params_method, auto_auth = Ложь,__kwargs = Неопределено, Знач url = "") Экспорт
	Перем headers,  response_type, type_request, request_body_type, data;
	kwargs = __kwargs;
	Если kwargs = Неопределено Тогда
		kwargs = Новый Структура;
	КонецЕсли;
	request_body_type 	= get_prop(kwargs, "body_type", "json");
	response_type		= get_prop(kwargs, "response", "json");
	
	Попытка
		AutoAuth = get_prop(context_params, "AutoAuth");
		Если	УИДСессии(context_params) = Неопределено
			И auto_auth И AutoAuth <> Ложь Тогда
			ВойтиТранспорт(context_params);
		КонецЕсли;	
		
		headers 		= get_prop(kwargs, "headers", Новый Соответствие);
		Если url = "" Тогда
			url 			= context_params.ApiUrl + "/service/?srv=1"; 
		КонецЕсли;	
		type_request 	= get_prop(kwargs, "type", "post"); 
		
		local_helper_exec_method_fill_data_headers_params(request_body_type, method, kwargs, headers, data, params_method, context_params);
		local_helper_add_auth_header(context_params, headers);
		ПараметрыВыполнения	=	Новый Структура("params, data, headers", params_method, data, headers);
		Если context_params.Свойство("Proxy") Тогда
			ПараметрыВыполнения.Вставить("Proxy", context_params.Proxy);
		КонецЕсли;
		ПараметрыВыполнения.Вставить("method", 				method);
		ПараметрыВыполнения.Вставить("multithread_mode",	get_prop(kwargs,"multithread_mode", Ложь));
		ПараметрыВыполнения.Вставить("timeout",				get_prop(kwargs,"timeout",60));
		ПараметрыВыполнения.Вставить("auto_auth",auto_auth);
		code_result = local_helper_exec_request(type_request, url, response_type, ПараметрыВыполнения, context_params);
		local_helper_exec_method_process_responce(code_result, auto_auth, type_request, url, response_type, ПараметрыВыполнения, context_params);
	Исключение
		ИнфОбОшибке = ИнформацияОбОшибке();
		ВызватьИсключение ИнфОбОшибке.Описание;		
	КонецПопытки;;
	Возврат code_result.result;
КонецФункции


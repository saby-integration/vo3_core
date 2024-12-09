
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
	Если (code_result.code = 200 
		Или code_result.code = 500
		Или code_result.code = 501
		Или	code_result.code = 404)
		И block_obj_get_path_value (code_result,"result.error", Неопределено) <> Неопределено Тогда
		//ПОЧЕМУ код - 200, при classid = "{00000000-0000-0000-0000-1FA000001002}
		//https://saby.ru/help/integration/api/all_methods/auth_one
		//Требуется подтверждение телефона или подтверждение СМС
		error = code_result.result["error"];
		msg = code_result.result["error"]["message"]; 
		
		detail = get_prop(error, "details");
		Если (detail <> Неопределено) И (msg = detail) Тогда
			detail = Неопределено;				
		КонецЕсли;
		Если	get_prop(error, "code", 0)  = -32000 
			И (Найти(get_prop(error, "message", ""), "Для входа введите полученный код подтверждения.") > 0
			ИЛИ
			Найти(get_prop(error, "message", ""), "Ошибка аутентификации. Пустое значение поля Пароль!") > 0)
			Тогда
			detail = get_prop(error, "data");
		КонецЕСли;
		
		ВызватьИсключение NewExtExceptionСтрока(,msg, detail, "Ошибка API "+get_prop(ПараметрыВыполнения,"method","")); 
	КонецЕсли;
	Возврат ЛОЖЬ;
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
// Возвращаемое значение:
//  Структура - Результат выполнения.
//              При ошибке кидается исключение с описанием.
//
//DynamicDirective
Функция local_helper_exec_method_process_responce(code_result, auto_auth, type_request, url, response_type, ПараметрыВыполнения, context_params) 
	
	Если code_result.code = 401 Тогда
		Если auto_auth Тогда
			local_helper_auth_by_login(context_params);
			local_helper_add_auth_header(context_params, ПараметрыВыполнения.Headers);			
			code_result = local_helper_exec_request(type_request, url, response_type, ПараметрыВыполнения, context_params);
		КонецЕсли;
	КонецЕсли;
	
	Если code_result.code = 401 Тогда
		ВызватьИсключение NewExtExceptionСтрока(,"Не верный логин или пароль",,,,"Unauthorized" );
	ИначеЕсли code_result.code = 403 Тогда	
		ВызватьИсключение NewExtExceptionСтрока(  ,"Доступ к запрошенному ресурсу запрещен", "Код ошибки: " + code_result.code );
	ИначеЕсли code_result.code = 423 Тогда
		ВызватьИсключение NewExtExceptionСтрока(,"PIN locked",,,,"" );
	ИначеЕсли local_helper_exec_method_process_responce_error(code_result, ПараметрыВыполнения) Тогда
		ВызватьИсключение NewExtExceptionСтрока(,"Ошибка API",,,,"" ); 
	ИначеЕсли code_result.code = 503 или code_result.code = 504 Тогда
		ИнфОбОшибке = ИнформацияОбОшибке();
		ВызватьИсключение NewExtExceptionСтрока(,"Извините, мы на техническом обслуживании", "Код ошибки: " + code_result.code );
	ИначеЕсли Не (code_result.code = 200 ИЛИ code_result.code = 201) Тогда
		//TODO Текст ошибки в детаил
		ВызватьИсключение NewExtExceptionСтрока(  ,"Неизвестная ошибка", "Код ошибки: " + code_result.code );
	КонецЕсли;
   	Возврат code_result;
КонецФункции	

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
	responce = local_helper_exec_request_async_process_responce(async_responce);
	
	ПараметрыЗапроса = get_prop(async_responce,"ПараметрыЗапроса");
	type_request = get_prop(ПараметрыЗапроса,"type_request");
	url = get_prop(ПараметрыЗапроса,"url");
	response_type = get_prop(ПараметрыЗапроса,"response_type");
	ПараметрыВыполнения = get_prop(ПараметрыЗапроса,"ПараметрыВыполнения");
	context_params = get_prop(ПараметрыЗапроса,"context_params");
	auto_auth = get_prop(ПараметрыЗапроса,"auto_auth");
	responce = local_helper_exec_method_process_responce(responce, auto_auth, type_request, url, response_type, ПараметрыВыполнения, context_params); 
	Возврат responce.result;
КонецФункции

// Создаются заголовки для расширенного логирования
//
// Параметры:
//  context_param - Структура - Контекст.
//  QueryId - Произвольный - Ключ запроса.
//
// Возвращаемое значение:
//  Соответствие - Заголовки для расширенного логирования
//
//DynamicDirective
Функция local_helper_exec_method_get_headers_for_advanced_log(context_params) Экспорт 
	headers = Новый Соответствие;
	Если get_prop(context_params, "advanced_log",	Ложь) Тогда
		headers.Вставить("X-Method-Cache-Control", "no-cache");
		headers.Вставить("X-LogEntireTask", "true");
	КонецЕсли;
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
//  context_param - Структура - Контекст.
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
	ИдПриложения = "1С8;"+ДанныеОВерсии[0]+ДанныеОВерсии[1];  
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
		data = encode_xdto_json(data);
		params = Новый Структура;
	Иначе
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
Функция local_helper_exec_method(context_params, method, params_method, auto_auth = Ложь,__kwargs = Неопределено, url = "") Экспорт
	Перем headers,  response_type, type_request, request_body_type, data;
	kwargs = __kwargs;
	params = Новый Структура;
	Если kwargs = Неопределено Тогда
		kwargs = Новый Структура;
	КонецЕсли;
	request_body_type 	= get_prop(kwargs, "body_type", "json");
	response_type		= get_prop(kwargs, "response", "json");
	
	Попытка
		Если	Не	context_params.Свойство("session")
			И auto_auth Тогда
			local_helper_auth_by_login(context_params);
		КонецЕсли;	
		
		headers 		= get_prop(kwargs, "headers", Новый Соответствие);
		Если url = "" Тогда
			url 			= context_params.api_url + "/service/?srv=1"; 
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
		code_result = local_helper_exec_method_process_responce(code_result, auto_auth, type_request, url, response_type, ПараметрыВыполнения, context_params);
	Исключение
		ИнфОбОшибке = ИнформацияОбОшибке();
		ВызватьИсключение(NewExtExceptionСтрока(ИнфОбОшибке));		
	КонецПопытки;;
	Возврат code_result.result;
КонецФункции


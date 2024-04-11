	

Функция local_helper_exec_method_process_responce_error(code_result, ПараметрыВыполнения)
	Если (code_result.code = 200 
		Или code_result.code = 500
		Или code_result.code = 501
		Или	code_result.code = 404)
		И code_result.result["error"] <> Неопределено Тогда
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
	ИначеЕсли code_result.code = 423 Тогда
		ВызватьИсключение NewExtExceptionСтрока(,"PIN locked",,,,"" );
	ИначеЕсли local_helper_exec_method_process_responce_error(code_result, ПараметрыВыполнения) Тогда
		ВызватьИсключение NewExtExceptionСтрока(,"Ошибка API",,,,"" ); 
	ИначеЕсли code_result.code = 504 Тогда
		ИнфОбОшибке = ИнформацияОбОшибке();
		ВызватьИсключение NewExtExceptionСтрока(,"Извините, мы на техническом обслуживании", "Код ошибки: " + code_result.code );
	ИначеЕсли Не (code_result.code = 200 ИЛИ code_result.code = 201) Тогда
		//TODO Текст ошибки в детаил
		ВызватьИсключение NewExtExceptionСтрока(  ,"Неизвестная ошибка", "Код ошибки: " + code_result.code );
	КонецЕсли;
   	Возврат code_result;
КонецФункции	

Функция local_helper_exec_method_process_responce_async(context_param, QueryId)  
	async_responce = async_responces.Получить(QueryId); 
	responce = local_helper_exec_request_SabyHttpsClient_process_responce(async_responce);
	
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

Функция local_helper_exec_method_get_headers_for_advanced_log(context_params) Экспорт 
	headers = Новый Соответствие;
	Если get_prop(context_params, "advanced_log",	Ложь) Тогда
		headers.Вставить("X-Method-Cache-Control", "no-cache");
		headers.Вставить("X-LogEntireTask", "true");
	КонецЕсли;
	Возврат headers;
КонецФункции

Процедура local_helper_exec_method_fill_data_headers_params(request_body_type, method, kwargs, headers, data, params, context_params)
	Если request_body_type <> "json" Тогда 
		ВызватьИсключение ЗначениеВСтрокуВнутр(ExtException( Новый Структура("message, detail", "Неизвестный тип отправки запроса.", request_body_type), ));			
	КонецЕсли;	
	ДанныеОВерсии = ПолучитьИмяФайлаИНомерТекущейВерсии();
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


//Метод для вызова АПИ БЛ
//context - структура
//__kwargs - структура
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
		ПараметрыВыполнения	=	Новый Структура("params, data, headers", params, data, headers);
		Если context_params.Свойство("Proxy") Тогда
			ПараметрыВыполнения.Вставить("Proxy", context_params.Proxy);
		КонецЕсли;
		ПараметрыВыполнения.Вставить("method", 				method);
		ПараметрыВыполнения.Вставить("multithread_mode",	get_prop(kwargs,"multithread_mode", Ложь));
		ПараметрыВыполнения.Вставить("timeout",				get_prop(kwargs,"timeout",60));
		local_helper_add_auth_header(context_params, headers);
		ПараметрыВыполнения.Вставить("auto_auth",auto_auth);
		code_result = local_helper_exec_request(type_request, url, response_type, ПараметрыВыполнения, context_params);
		code_result = local_helper_exec_method_process_responce(code_result, auto_auth, type_request, url, response_type, ПараметрыВыполнения, context_params);
	Исключение
		ИнфОбОшибке = ИнформацияОбОшибке();
		ВызватьИсключение(NewExtExceptionСтрока(ИнфОбОшибке));		
	КонецПопытки;;
	Возврат code_result.result;
КонецФункции

Функция local_helper_task_list(context_params, Тип="Мои", СтрокаПоиска=Неопределено, ТолькоПросроченные=Неопределено, Навигация=Неопределено, auto_auth=Истина) Экспорт
	// Тип - Мои/ОтМеня/Нераспределенные/Выполненные
	
	Фильтр = Новый Структура("Тип", Тип);
	Если СтрокаПоиска <> Неопределено Тогда
		Фильтр.Вставить("ФильтрПоМаске", СтрокаПоиска);	
	КонецЕсли;
	Если ТолькоПросроченные <> Неопределено Тогда
		Фильтр.Вставить("Просроченные", ТолькоПросроченные);	
	КонецЕсли;
	Если Навигация <> Неопределено Тогда
		Фильтр.Вставить("Навигация", Навигация);	
	КонецЕсли;
	ПараметрыМетода = Новый Структура("Фильтр", Фильтр);
	Попытка
		РезультатЗапроса =  local_helper_exec_method(context_params,"API3.TaskList", ПараметрыМетода, auto_auth);
	Исключение
		ИнфОбОшибке = ИнформацияОбОшибке();
		ВызватьИсключение(NewExtExceptionСтрока(ИнфОбОшибке));		
	КонецПопытки;	
	Возврат get_prop(РезультатЗапроса, "result");

КонецФункции

Функция local_helper_get_product_version_status(context_params, product, client_version)
	Попытка
		Возврат local_helper_integration_api(context_params, "API3.GetProductVersionStatus", Новый Структура("product, client_version", product, client_version));
	Исключение
		ИнфОбОшибке = ИнформацияОбОшибке();
		ВызватьИсключение(NewExtExceptionСтрока(ИнфОбОшибке));		
	КонецПопытки;	
КонецФункции

Функция local_helper_extsyncdoc_write(context_params, connection_uuid, extsyncdoc, objects)
	Попытка
		params = Новый Структура("param", Новый Структура("ConnectionId, ExtSyncDoc, ExtSyncObj", connection_uuid, extsyncdoc, objects));
		Возврат local_helper_integration_api(context_params, "ExtSyncDoc.Write", params);
	Исключение
		ИнфОбОшибке = ИнформацияОбОшибке();
		ВызватьИсключение(NewExtExceptionСтрока(ИнфОбОшибке));		
	КонецПопытки;
КонецФункции

Функция local_helper_auth_by_login(context_params, __kwargs = Неопределено) Экспорт
	//TODO
	//Прочитать context_param, еще раз, 
	//Проверить session_begin с тем что мы прочитали из настроек.
	//если во входящих парам  время меньше чем в настройках то, в context_params заменяем session_begin и session
	Попытка
		params = Новый Структура("Логин, Пароль", context_params.login, context_params.password);
		url = context_params.api_url + "/auth/service/";
	Исключение
		ИнфОбОшибке = ИнформацияОбОшибке();
		ВызватьИсключение NewExtExceptionСтрока(ИнфОбОшибке,"Не заполнен параметр аутентификации",ИнфОбОшибке.Описание,,,"Unauthorized" );
	КонецПопытки;
	Попытка
		result = local_helper_exec_method(context_params, "СБИС.Аутентифицировать", params, Ложь, ,url);
	Исключение
		ИнфОбОшибке = ИнформацияОбОшибке();
		ВызватьИсключение NewExtExceptionСтрока(ИнфОбОшибке,,,,,"Unauthorized" );
	КонецПопытки;
	session = result.Получить("result");
	context_params.Вставить("session", session );
	context_params.Вставить("session_begin", ТекущаяДата());
	context_params.Вставить("last_token_time", Неопределено);
	НастройкиПодключенияЗаписать(context_params);
	Возврат session;
КонецФункции

Функция local_helper_integration_api(context_params, method, params, auto_auth = Истина) Экспорт
	Попытка
		url = context_params.api_url + "/integration_config/service/?srv=1";
		result = local_helper_exec_method(context_params, method, params, auto_auth, ,url);
	Исключение
		ИнфОбОшибке = ИнформацияОбОшибке();
		ВызватьИсключение(NewExtExceptionСтрока(ИнфОбОшибке,"Ошибка выполнения метода "+method));
	КонецПопытки;
	Возврат result.Получить("result");
КонецФункции

Функция local_helper_exec_integration_list_method(context_params, method, Фильтры = Неопределено, Page = 0, PageSize = 50, ДопПоля = Неопределено,  Сортировка = Неопределено) Экспорт
	params = Новый Структура;
	params.Вставить("ДопПоля", 		ДопПоля);
	params.Вставить("Фильтр", 		Фильтры);
	params.Вставить("Сортировка", 	Сортировка);
	params.Вставить("Навигация", 	Новый Структура("Page,PageSize", Page, PageSize));
	res = local_helper_integration_api(context_params, method, params);
	Возврат res;
КонецФункции

Функция local_helper_api_process_responce(responce)
	Возврат get_prop(responce,"result",responce);	
КонецФункции

Функция local_helper_extsyncdoc_prepare(context, extsyncdoc_uuid, direction)
	Возврат local_helper_integration_api(context, "ExtSyncDoc.Prepare", 
	Новый Структура("SyncDocId, Direction", extsyncdoc_uuid, direction)
	);
КонецФункции

Функция local_helper_extsyncdoc_execute(context, extsyncdoc_uuid, direction)
	Возврат local_helper_integration_api(context, "ExtSyncDoc.Execute",
	Новый Структура("param", Новый Структура("SyncDocId, Direction", extsyncdoc_uuid, direction)));
КонецФункции

Функция local_helper_extsyncdoc_execute_lrs(context, extsyncdoc_uuid, direction)
	Возврат local_helper_integration_api(context, "ExtSyncDoc.ExecuteLRS", Новый Структура("SyncDocId", extsyncdoc_uuid));
КонецФункции

Функция local_helper_extsyncdoc_fillchangedsbisobjects_lrs(context, ConnectionId)
	Попытка
		param = Новый Структура("ConnectionId", ConnectionId);
		Возврат local_helper_integration_api(context, "ExtSyncDoc.FillChangedSbisObjects", Новый Структура("param", param));
	Исключение
		ИнфОбОшибке = ИнформацияОбОшибке();
		ВызватьИсключение(NewExtExceptionСтрока(ИнфОбОшибке));
	КонецПопытки;
КонецФункции

Функция local_helper_extsyncdoc_write_predefined(context_params, ConnectionId, Type, ClientType, Objects)
	
	Попытка
		params = Новый Структура("ConnectionId, Type, ClientType, Objects", ConnectionId, Type, ClientType, Objects);
		Возврат local_helper_integration_api(context_params, "MappingObject.WritePredefined", params);
	Исключение
		ИнфОбОшибке = ИнформацияОбОшибке();
		ВызватьИсключение(NewExtExceptionСтрока(ИнфОбОшибке));		
	КонецПопытки;
	
КонецФункции

Функция local_helper_extsyncdoc_get_obj_for_execute(context, extsyncdoc_uuid, direction)
	Возврат local_helper_integration_api(context, "ExtSyncDoc.GetObjectsForExecute", 
	Новый Структура("SyncDocId, Direction", extsyncdoc_uuid, direction)
	);
КонецФункции

Функция local_helper_extsyncobj_get_obj_for_execute(context, extsyncdoc_uuid, extra_fields, limit)	
	Возврат local_helper_integration_api(context, "ExtSyncObj.GetObjectsForExecute", 
	Новый Структура("Filter, ExtraFields", 
	Новый Структура("SyncDocId, Limit", extsyncdoc_uuid, limit), extra_fields)
	);
КонецФункции

Функция local_helper_extsyncdoc_read(context, extsyncdoc_uuid)
	Возврат local_helper_integration_api(context, "API3.ExtSyncDocRead", Новый Структура("param", Новый Структура("SyncDocId", extsyncdoc_uuid)));
КонецФункции

Функция local_helper_mapping_obj_find_and_update(context, _filter, _data)
	response = local_helper_integration_api(context, "MappingObject.FindAndUpdate", 
	Новый Структура("Filter, Data", _filter, _data)
	);
	Если ЗначениеЗаполнено(response) Тогда
		Возврат response;
	Иначе
		//ВызватьИсключение СокрЛП(response);
		ИнфОбОшибке = ИнформацияОбОшибке();
		ВызватьИсключение NewExtExceptionСтрока(ИнфОбОшибке, СокрЛП(response));
	КонецЕсли;
КонецФункции

Функция local_helper_extsyncdoc_prepare_saby(context, extsyncdoc_uuid)
	Возврат local_helper_integration_api( context, "Connector.Prepare",
	Новый Структура("ConnectorName, SyncDocId","Saby", extsyncdoc_uuid)
	);
КонецФункции

//Выполнение POST/GET запроса
// request_type: get, post, post_binary (в дата лежит имя временного файла)
// response_type: json, text, binary (в ответе будет лежать имя временного файла)

Функция local_helper_exec_request(type_request, url, response_type, ПараметрыВыполнения, context_params, timeout = 60) Экспорт
	Если ТранспортSabyHttpsClient(context_params) Тогда
		code_result = local_helper_exec_request_SabyHttpsClient(type_request, url, response_type, ПараметрыВыполнения, context_params); 
	Иначе 
		code_result = local_helper_exec_request_HTTPСоединение(type_request, url, response_type, ПараметрыВыполнения, context_params);	
	КонецЕсли;
	Возврат code_result;
КонецФункции

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
		Proxy = Новый ИнтернетПрокси;
		Proxy.Установить(ProxyParam.Protocol, ProxyParam.Server, Число(ProxyParam.Port), ProxyParam.User, ProxyParam.Password);
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

Функция local_helper_json_loads(json) Экспорт
	ЧтениеJSON = Новый ЧтениеJSON;
	ЧтениеJSON.УстановитьСтроку(json);
	Попытка
		СтрокаВСоответсвие	= ПрочитатьJSON(ЧтениеJSON, Истина); //Для просмотра в отладке
		Возврат СтрокаВСоответсвие;
	Исключение
		ИнфоОбОшибке = ИнформацияОбОшибке();
		ВызватьИсключение NewExtExceptionСтрока(ИнфоОбОшибке, "Ошибка чтения JSON");
	КонецПопытки;
КонецФункции

Функция local_helper_write_attachment(context, document) Экспорт
	response	=	local_helper_exec_method(context,"СБИС.ЗаписатьВложение", Новый Структура("Документ", document), Истина);
	Результат   = local_helper_api_process_responce(response);
	Возврат Результат;	
КонецФункции

Функция local_helper_prepare_action(context_params, document, multithread_mode = Ложь, timeout = 60) Экспорт
	kwargs = Новый Структура("multithread_mode, timeout", multithread_mode, timeout); 
	headers 		= local_helper_exec_method_get_headers_for_advanced_log(context_params);
	Если  headers <> Неопределено Тогда
		kwargs.Вставить("headers", headers);
	КонецЕсли;
	response = local_helper_exec_method(context_params,"СБИС.ПодготовитьДействие", Новый Структура("Документ", document), Истина, kwargs);
	Результат = local_helper_api_process_responce(response);
	Возврат Результат;	
КонецФункции

Функция local_helper_prepare_action_process_responce(responce)
	result = local_helper_api_process_responce(responce);
	Возврат result;
КонецФункции

Функция local_helper_execute_action(context, document, multithread_mode = Ложь, timeout = 60) Экспорт 
	kwargs = Новый Структура("multithread_mode, timeout", multithread_mode, timeout); 
    headers 		= local_helper_exec_method_get_headers_for_advanced_log(context);
	Если  headers <> Неопределено Тогда
		kwargs.Вставить("headers", headers);
	КонецЕсли;
	response = local_helper_exec_method(context,"СБИС.ВыполнитьДействие", Новый Структура("Документ", document), Истина, kwargs);
	Результат = local_helper_api_process_responce(response);
	Возврат Результат;	
КонецФункции

Функция local_helper_execute_action_process_responce(responce)
	result = local_helper_api_process_responce(responce);
	Возврат result;
КонецФункции

Функция local_helper_delay_service_stage(context, document) Экспорт 
	response = local_helper_exec_method(context,"СБИС.ОтложитьСлужебныйЭтап", Новый Структура("Параметры", Новый Структура("Документ", document)), Истина);
	Результат = local_helper_api_process_responce(response);
	Возврат Результат;	
КонецФункции

Функция local_helper_request_signing(context, params) Экспорт
	response = local_helper_exec_method(context,"EKDAPI.RequestSigning", Новый Структура("Params", params), Истина);
	Результат = local_helper_api_process_responce(response);
	Возврат Результат;		
КонецФункции	

Функция local_helper_find_sbis_object(context, type, filter)
	response = local_helper_exec_method(context,"API3.FindSbisObject", Новый Структура("Type, Filter", type, filter), Истина);
	Результат = local_helper_api_process_responce(response);
	Возврат Результат;
КонецФункции  

Функция local_helper_get_sbis_object(context, type, IdList)
	response = local_helper_exec_method(context,"API3.GetSbisObject", Новый Структура("Type, IdList", type, IdList), Истина);
	Результат = local_helper_api_process_responce(response);
	Возврат Результат;
КонецФункции

Функция local_helper_invite_user_ext(context, params) Экспорт
	response = local_helper_exec_method(context,"Invitation.InviteUserExt", Новый Структура("InputData", params));
	Результат = local_helper_api_process_responce(response);
	Возврат Результат;	
КонецФункции

Функция РазобратьСтрокуУРЛ(СтрокаАдреса, ПротоколПоУмолчанию = "http")
	Адрес = Новый Структура("scheme, host, port, resource");
	Индекс = Найти(СтрокаАдреса, "://");
	ПоложениеРесурса = Найти(СтрокаАдреса, "://");
	Если Индекс > 0 Тогда
		Адрес.scheme = НРег(Лев(СтрокаАдреса, Индекс - 1));
		СтрокаАдреса = Сред(СтрокаАдреса, Индекс + 3);
	Иначе
		Адрес.scheme = НРег(ПротоколПоУмолчанию);
	КонецЕсли;
	Индекс = Найти(СтрокаАдреса, "?");
	Если Индекс > 0 Тогда
		ПараметрыРесурса = Сред(СтрокаАдреса, Индекс );
		СтрокаАдреса = Сред(СтрокаАдреса, 0, Индекс-1);
	Иначе
		ПараметрыРесурса = "";
	КонецЕсли;

	Индекс = Найти(СтрокаАдреса, "/");
	Если Индекс > 0 Тогда
		Адрес.resource = Сред(СтрокаАдреса, Индекс) + ПараметрыРесурса;
		СтрокаАдреса = Сред(СтрокаАдреса, 0, Индекс - 1);
	Иначе
		Адрес.resource = ПараметрыРесурса;
	КонецЕсли;
	
	Индекс = Найти(СтрокаАдреса, ":");
	Если Индекс > 0 Тогда
		Адрес.port = Сред(СтрокаАдреса, Индекс + 1);
		Адрес.host = Лев(СтрокаАдреса, Индекс);
	Иначе
		Адрес.host = СтрокаАдреса;
	КонецЕсли;
	Возврат Адрес;
КонецФункции

//post запрос
//Для 8.2 тут будет падать. Заменить через вычислить
//Начиная с 8.3 HTTPСоединение возвращает ответ сразу, а не кладёт в файл, появляется объект HTTPЗапрос
//Начиная с 8.2.16 появляется ЗащищенноеСоединениеOpenSSL

//Дополняет заголовки сессией
//context - Структура
//headers - Соответствие
Функция local_helper_add_auth_header(context_params, headers)
	Перем session;
	Если Не context_params.Свойство("session", session) Тогда
		session = "";
	КонецЕсли;
	headers.Вставить("X-SBISSessionID", session);
	
КонецФункции

Функция local_helper_read_document(context_params, document, multithread_mode = Ложь, timeout = 60) Экспорт
	kwargs = Новый Структура("multithread_mode, timeout", multithread_mode, timeout); 
    headers 		= local_helper_exec_method_get_headers_for_advanced_log(context_params);
	Если  headers <> Неопределено Тогда
		kwargs.Вставить("headers", headers);
	КонецЕсли;
	response = local_helper_exec_method(context_params,"СБИС.ПрочитатьДокумент", Новый Структура("Документ", document), Истина, kwargs);
	Результат = local_helper_api_process_responce(response);
	Возврат Результат;
КонецФункции

Функция local_helper_read_document_process_responce(responce)
	result = local_helper_api_process_responce(responce);
	Возврат result;
КонецФункции

Функция local_helper_document_list(context_params, filter, multithread_mode = Ложь, timeout = 60) Экспорт
	kwargs = Новый Структура("multithread_mode, timeout", multithread_mode, timeout); 
    headers 		= local_helper_exec_method_get_headers_for_advanced_log(context_params);
	Если  headers <> Неопределено Тогда
		kwargs.Вставить("headers", headers);
	КонецЕсли;
	response = local_helper_exec_method(context_params,"СБИС.СписокДокументов", Новый Структура("Фильтр", filter), Истина, kwargs);
	Результат = local_helper_api_process_responce(response);
	Возврат Результат;
КонецФункции

Функция local_helper_document_list_process_responce(responce)
	result = local_helper_api_process_responce(responce);
	Возврат result;
КонецФункции

Функция local_helper_document_event_list(context_params, filter, multithread_mode = Ложь, timeout = 60) Экспорт
	kwargs = Новый Структура("multithread_mode, timeout", multithread_mode, timeout); 
    headers 		= local_helper_exec_method_get_headers_for_advanced_log(context_params);
	Если  headers <> Неопределено Тогда
		kwargs.Вставить("headers", headers);
	КонецЕсли;
	response = local_helper_exec_method(context_params,"СБИС.СписокДокументовПоСобытиям", Новый Структура("Фильтр", filter), Истина, kwargs);
	Результат = local_helper_api_process_responce(response);
	Возврат Результат;
КонецФункции

Функция local_helper_document_event_list_process_responce(responce)
	result = local_helper_api_process_responce(responce);
	Возврат result;
КонецФункции

Функция local_helper_write_document(context_params, document, multithread_mode = Ложь, timeout = 120) Экспорт 
	kwargs = Новый Структура("multithread_mode, timeout", multithread_mode, timeout); 
	response = local_helper_exec_method(context_params,"СБИС.ЗаписатьДокумент", Новый Структура("Документ", document), Истина, kwargs);
	Результат = local_helper_api_process_responce(response);
	Возврат Результат;	
КонецФункции

Функция local_helper_write_document_process_responce(responce) 
	result = local_helper_api_process_responce(responce);
	Возврат result;
КонецФункции

Функция local_helper_write_kit(context_params, kit) Экспорт
	Массив = Новый Массив;
	Массив.Добавить(kit);
	kwargs	= Неопределено;
	headers 		= local_helper_exec_method_get_headers_for_advanced_log(context_params);
	Если  headers <> Неопределено Тогда
		kwargs	= Новый Структура();
		kwargs.Вставить("headers", headers);
	КонецЕсли;
	response = local_helper_exec_method(context_params,"СБИС.ЗаписатьКомплект", Новый Структура("Документ", Массив), Истина, kwargs);
	Результат = local_helper_api_process_responce(response);
	Возврат Результат;	
КонецФункции

Функция local_helper_get_server_datetime(context_params) Экспорт
	response = local_helper_exec_method(context_params,"СБИС.ИнформацияОВерсии", Новый Структура("Параметр", Новый Структура()), Истина);
	Результат = local_helper_api_process_responce(response);
	Возврат Результат["ВнешнийИнтерфейс"]["ДатаВремяЗапроса"];
КонецФункции

Функция local_helper_read_changes(context_params, _filter) Экспорт
	Результат = Новый Соответствие();
	kwargs	= Новый Структура();
    headers 		= local_helper_exec_method_get_headers_for_advanced_log(context_params);
	kwargs.Вставить("headers", headers);
	response = local_helper_exec_method(context_params,"СБИС.СписокИзменений", Новый Структура("Фильтр", _filter), Истина, kwargs);
	Результат = local_helper_api_process_responce(response);
	Возврат Результат;
КонецФункции

Функция local_helper_read_service_changes(context, _filter) Экспорт
	Результат = Новый Соответствие();
	Попытка
		response = local_helper_exec_method(context,"СБИС.СписокСлужебныхЭтапов", Новый Структура("Фильтр", _filter), Истина);
		Результат = local_helper_api_process_responce(response);
	Исключение
		ИнфОбОшибке = ИнформацияОбОшибке();
		ВызватьИсключение ИнфОбОшибке.Описание;
	КонецПопытки;	
	Возврат Результат;
КонецФункции

Функция local_helper_download_from_link(context_params, link, response_type = "binary") Экспорт
	headers = Новый Соответствие;
	local_helper_add_auth_header(context_params, headers);
	
	Пока Истина Цикл
		
		ПараметрыМетода = Новый Структура();
		ПараметрыМетода.Вставить("headers", headers);
		response = local_helper_exec_request("get", link, response_type, ПараметрыМетода, context_params);
		Если response["code"] = 200 Тогда
			Прервать;
		КонецЕсли;
		Попытка 
			КодОшибки = response["result"]["error"]["data"]["classid"];
		Исключение
			КодОшибки = Неопределено;
		КонецПопытки;
		Если КодОшибки = "{00000000-0000-0000-0000-1aa0000f1002}" Тогда
			local_helper_pause(1);
			Продолжить;
		КонецЕсли;
		Попытка
			message = response["result"]["error"]["message"];
			detail = response["result"]["error"]["message"];
			Если message = detail Тогда
				detail = Неопределено;
			КонецЕсли;
		Исключение
			message = ЗначениеВСтрокуВнутр(response["result"]);
			detail = Неопределено;
		КонецПопытки;
		ВызватьИсключение NewExtExceptionСтрока(,message,detail);
		Прервать;
	КонецЦикла;	
	Результат = response["result"]; 
	Если ТранспортSabyHttpsClient(context_params) Тогда
		Результат = Base64Значение(Результат);
	КонецЕсли;	
	Возврат Результат;
КонецФункции

Функция local_helper_extsyncobj_list(context_params, extra_fields, filter, sorting, pagination) Экспорт
	Если pagination = Неопределено Тогда
		pagination = Новый Структура("PageSize, Page", 50, 0 )
	КонецЕсли;
	
	ПараметрыЗапроса = Новый Структура("ExtraFields,Filter,Sorting,Pagination",
				extra_fields,
		        filter,
		        sorting,
		        pagination
			);
	url = context_params.api_url+"/integration_config/service/?srv=1"; 
	Результат = local_helper_integration_api(context_params, "ExtSyncObj.List", ПараметрыЗапроса, Ложь);  
	Возврат Результат;
КонецФункции

Процедура local_helper_pause(Секунды)
	Если Секунды<> 0 Тогда

        НастройкиProxy = Новый ИнтернетПрокси(Ложь);
        НастройкиProxy.НеИспользоватьПроксиДляЛокальныхАдресов = Истина;
        НастройкиProxy.НеИспользоватьПроксиДляАдресов.Добавить("127.0.0.0");

        Попытка
            СоединениеHTTP = Новый HTTPСоединение("127.0.0.0",,,,НастройкиProxy,Секунды);
            СоединениеHTTP.Получить(Новый HTTPЗапрос());
        Исключение
            Возврат;
        КонецПопытки;

    КонецЕсли;
	
КонецПроцедуры	

//Передача ошибок и статуса выполнения на сервер статистик

Функция local_helper_element_stat(context_params = Неопределено, action_name, action_param, КоличествоОбъектов = 0) Экспорт
    ЭлементСтатистики = Новый Структура();
	ЭлементСтатистики.Вставить("service", "Dom1C");
	ЭлементСтатистики.Вставить("module", ПолучитьНазваниеПродукта());
	ЭлементСтатистики.Вставить("subsystem", get_prop(context_params, "ExtSysSettingsId", ""));
	ЭлементСтатистики.Вставить("action_name", action_name);
	ЭлементСтатистики.Вставить("action_param", action_param);
	ЭлементСтатистики.Вставить("count", КоличествоОбъектов);
	ЭлементСтатистики.Вставить("connection_id", context_params.ConnectionId);
	
	Возврат ЭлементСтатистики;
КонецФункции

Функция local_helper_element_error(context_params = Неопределено, action_name, action_param, error_name, error_detail, data, code, КоличествоОбъектов = 0) Экспорт
    ЭлементСтатистики = Новый Структура();
	ЭлементСтатистики.Вставить("service", "Dom1C");
	ЭлементСтатистики.Вставить("module", ПолучитьНазваниеПродукта());
	ЭлементСтатистики.Вставить("subsystem", get_prop(context_params, "ExtSysSettingsId", ""));
	ЭлементСтатистики.Вставить("action_name", action_name);
	ЭлементСтатистики.Вставить("action_param", action_param);
	ЭлементСтатистики.Вставить("count", КоличествоОбъектов);
	ЭлементСтатистики.Вставить("error_name", error_name);
	ЭлементСтатистики.Вставить("error_detail", error_detail);
	ЭлементСтатистики.Вставить("data", data);
	
	Возврат ЭлементСтатистики;
КонецФункции

Процедура local_helper_write_stat(context_params = Неопределено, action_name, action_param, КоличествоОбъектов = 0) Экспорт
	Если context_params = Неопределено Тогда
		context_params = НастройкиПодключенияПрочитать();
	КонецЕсли;
	
	Если ТипЗнч(action_param) = Тип("Строка") Тогда
		ЭлементСтатистики = local_helper_element_stat(context_params, action_name, action_param, КоличествоОбъектов);
		МассивСтатистики = Новый Массив;
		МассивСтатистики.Добавить(ЭлементСтатистики);
	ИначеЕсли ТипЗнч(action_param) = Тип("Массив") Тогда
		МассивСтатистики = action_param;
	Иначе
		Возврат;
	КонецЕсли;
	ПараметрыМетода = Новый Структура("stat", Новый Структура("batch", МассивСтатистики) );
	
	Попытка
        РезультатПередачи = local_helper_integration_api(context_params, "API3.WriteStat", ПараметрыМетода, Ложь);	
	Исключение
		ИнфОбОшибке = ИнформацияОбОшибке();
	КонецПопытки;
	
КонецПроцедуры

Процедура local_helper_write_error(context_params = Неопределено, action_name, action_param, error_name, error_detail, data, code, КоличествоОбъектов = 0) Экспорт
	Если context_params = Неопределено Тогда
		context_params = НастройкиПодключенияПрочитать();
	КонецЕсли;

	Если ТипЗнч(action_param) = Тип("Строка") Тогда
        ЭлементСтатистики = local_helper_element_error(context_params, action_name, action_param, error_name, error_detail, data, code, КоличествоОбъектов);
		МассивСтатистики = Новый Массив;
		МассивСтатистики.Добавить(ЭлементСтатистики);
	ИначеЕсли ТипЗнч(action_param) = Тип("Массив") Тогда
		МассивСтатистики = action_param;
	Иначе
		Возврат;
	КонецЕсли;
	ПараметрыМетода = Новый Структура("error", Новый Структура("batch", МассивСтатистики) );
	
	Попытка
        РезультатПередачи = local_helper_integration_api(context_params, "API3.WriteError", ПараметрыМетода, Ложь);		
	Исключение
		ИнфОбОшибке = ИнформацияОбОшибке();
	КонецПопытки;
         
КонецПроцедуры

&НаСервере
Функция ПолучитьТикетТекущейСессии( context_params = Неопределено ) Экспорт
	Если context_params = Неопределено Тогда
		context_params = НастройкиПодключенияПрочитать();
	КонецЕсли;
	ТокенSID	= Новый Структура("sid", context_params.session );
	Тикет_ = local_helper_exec_method(context_params,"САП.GetTicketForCurrentSid", ТокенSID, Истина);
	Тикет_ = local_helper_api_process_responce(Тикет_);
	Тикет	= "";
	Если ТипЗнч(Тикет_) = Тип("Строка") Тогда
		Тикет	= Тикет_;
	КонецЕсли;
	Возврат Тикет;
КонецФункции

Функция local_helper_init_connection(context_params, connection_info) Экспорт
	Попытка
		ConnectionStateEvents = get_prop(connection_info, "ConnectionStateEvents", Новый Массив);
		ExtSysSettings	= Новый Структура("Format, Type","Dom1C");
		Если ТипЗнч(ConnectionStateEvents) = Тип("Массив") И ConnectionStateEvents.Найти("NewSystem") <> Неопределено Тогда
			ExtSysSettings.Удалить("Type");
		КонецЕсли;
		Результат = local_helper_integration_api(context_params, "API3.InitConnection", Новый Структура("Params,ExtSysSettings", connection_info, ExtSysSettings));	
	Исключение
		ИнфОбОшибке = ИнформацияОбОшибке();
		ВызватьИсключение(NewExtExceptionСтрока(ИнфОбОшибке, "Не удалось создать подключение"));
	КонецПопытки;	
	Возврат Результат; 
КонецФункции

Функция local_helper_delete_connection(context_params, connection_info) Экспорт
	Попытка
		Результат = local_helper_integration_api(context_params, "IntegrationConnection.DeleteConnection", connection_info);
	Исключение
		ИнфОбОшибке = ИнформацияОбОшибке();
		ВызватьИсключение(NewExtExceptionСтрока(ИнфОбОшибке, "Не удалось удалить подключение"));
	КонецПопытки;
	Возврат Результат;
КонецФункции

Функция local_helper_read_connection(context_param, connection_info) Экспорт
	Попытка
		МассивINI = Неопределено;
		Если connection_info.Свойство("INI")
			И ТипЗнч(connection_info.INI) = Тип("Массив") Тогда
			МассивINI = connection_info.INI;
		КонецЕсли;
		props = Новый Структура;
		props.Вставить("id", 			connection_info.id);
		props.Вставить("version", 		connection_info.Версия);
		props.Вставить("read_config", 	ИСТИНА);
		props.Вставить("new_format",	ИСТИНА);
	
		params = Новый Структура("props,ini",props,МассивINI);
		Результат = local_helper_integration_api(context_param, "IntegrationConnection.ReadConnection", params);
	Исключение
		ИнфОбОшибке = ИнформацияОбОшибке();
		ВызватьИсключение(NewExtExceptionСтрока(ИнфОбОшибке, "Не удалось получить подключение"));
	КонецПопытки;
	Возврат Результат;
КонецФункции

Функция local_helper_read_connection_list(context_params, connection_info) Экспорт
	Попытка
		Результат = local_helper_integration_api(context_params, "IntegrationConnection.ReadConnectionList", connection_info);
	Исключение
		ИнфОбОшибке = ИнформацияОбОшибке();
		ВызватьИсключение(NewExtExceptionСтрока(ИнфОбОшибке, "Не удалось получить список подключений"));
	КонецПопытки;
	Возврат Результат;
КонецФункции

Функция local_helper_write_connection(context_params, connection_info) Экспорт
	Попытка
		Результат = local_helper_integration_api(context_params, "IntegrationConnection.WriteConnection", connection_info);
	Исключение
		ИнфОбОшибке = ИнформацияОбОшибке();
		ВызватьИсключение(NewExtExceptionСтрока(ИнфОбОшибке, "Не удалось записать подключение"));
	КонецПопытки;
	Возврат Результат;
КонецФункции

Функция local_helper_api3_connection_for_run(context_params, Фильтры, ДопПоля, Сортировка, Страница) Экспорт
	Попытка
		Результат = local_helper_exec_integration_list_method(context_params, "API3.ConnectionForRun", Фильтры, Страница, , ДопПоля, Сортировка);
	Исключение
		ИнфОбОшибке = ИнформацияОбОшибке();
		ВызватьИсключение(NewExtExceptionСтрока(ИнфОбОшибке, "Не удалось получить список подключений для автоматического запуска"));
	КонецПопытки;
	Возврат Результат;
КонецФункции


Функция local_helper_api3_connection_list(context_params, Фильтры, ДопПоля, Сортировка, Страница) Экспорт
	Попытка
		Результат = local_helper_exec_integration_list_method(context_params, "API3.ConnectionList", Фильтры, Страница, , ДопПоля, Сортировка);
	Исключение
		ИнфОбОшибке = ИнформацияОбОшибке();
		ВызватьИсключение(NewExtExceptionСтрока(ИнфОбОшибке, "Не удалось получить список подключений"));
	КонецПопытки;
	Возврат Результат;
КонецФункции


Функция local_helper_api3_typesyncobject_list(context_params, Фильтры, ДопПоля, Сортировка, Страница) Экспорт
	Попытка
		Результат = local_helper_exec_integration_list_method(context_params, "API3.TypeSyncObjectList", Фильтры, Страница, 500, ДопПоля, Сортировка);	
	Исключение
		ИнфОбОшибке = ИнформацияОбОшибке();
		ВызватьИсключение(NewExtExceptionСтрока(ИнфОбОшибке, "Не удалось получить список направлений подключения"));
	КонецПопытки;
	Возврат Результат;
КонецФункции

Функция local_helper_api3_typesyncobjectmasssetdirection(context_param, connection_info) Экспорт
	Попытка
		Результат = local_helper_integration_api(context_param, "API3.TypeSyncObjectMassSetDirection", connection_info);
	Исключение
		ИнфОбОшибке = ИнформацияОбОшибке();
		ВызватьИсключение(NewExtExceptionСтрока(ИнфОбОшибке, "Не удалось изменить направления обмена"));
	КонецПопытки;
	Возврат Результат;
КонецФункции

Функция local_helper_api3_extsyncdoc_list(context_params, Фильтры, ДопПоля, Сортировка, Страница) Экспорт
	Попытка
		Результат = local_helper_exec_integration_list_method(context_params, "API3.ExtSyncDocList", Фильтры, Страница, 500, ДопПоля, Сортировка);	
	Исключение
		ИнфОбОшибке = ИнформацияОбОшибке();
		ВызватьИсключение(NewExtExceptionСтрока(ИнфОбОшибке, "Не удалось получить историю синхронизации"));
	КонецПопытки;
	Возврат Результат;
КонецФункции

Функция local_helper_get_accoutslist(context_params) Экспорт
	Если context_params = Неопределено Тогда
		context_params = НастройкиПодключенияПрочитать();
	КонецЕсли;
	Попытка 
		url = context_params.api_url+"/auth/service/";
		result = local_helper_exec_method(context_params, "СБИС.СписокАккаунтов", Новый Структура, Ложь,,url);   
	Исключение
		ИнфОбОшибке = ИнформацияОбОшибке();
		ВызватьИсключение NewExtExceptionСтрока(ИнфОбОшибке,,,,,"Unauthorized" );
	КонецПопытки;
	Возврат get_prop(get_prop(result, "result"), "Список", Новый Массив);
КонецФункции

Функция local_helper_get_account(context_params = Неопределено) Экспорт
	user_info = local_helper_get_user_info(context_params);
	Возврат user_info["Аккаунт"]["Номер"];
КонецФункции

Функция local_helper_get_user_info(context_params = Неопределено) Экспорт
	Если context_params = Неопределено Тогда
		context_params = НастройкиПодключенияПрочитать();
	КонецЕсли;
	Попытка
		param = Новый Структура;
		param.Вставить("ДопПоля", "Аккаунт,ИдПрофиля");
		ПараметрыМетода = Новый Структура("Параметр", param);
		Результат = local_helper_exec_method(context_params, "СБИС.ИнформацияОТекущемПользователе", ПараметрыМетода);
		Возврат Результат["result"]["Пользователь"];
	Исключение
		ИнфОбОшибке = ИнформацияОбОшибке();
		ВызватьИсключение NewExtExceptionСтрока(ИнфОбОшибке,,,,,"Не удалось получить информацию о текущем пользователе");
	КонецПопытки;
КонецФункции

Функция local_helper_switch_account(context_params, account_id) Экспорт
	Если context_params = Неопределено Тогда
		context_params = НастройкиПодключенияПрочитать();
	КонецЕсли;
	Попытка   
		ПараметрыЗапроса = Новый Структура("Параметр", Новый Структура("НомерАккаунта", account_id));
		url = context_params.api_url+"/auth/service/";	
		result = local_helper_exec_method(context_params, "СБИС.ПереключитьАккаунт", ПараметрыЗапроса, Ложь, ,url); 		
	Исключение
		ИнфОбОшибке = ИнформацияОбОшибке();
		ВызватьИсключение NewExtExceptionСтрока(ИнфОбОшибке,,,,,"Unauthorized" );
	КонецПопытки;
	session = result.Получить("result");
	context_params.Вставить("session", session );
	context_params.Вставить("session_begin", ТекущаяДата());
	context_params.Вставить("need_ticket", Неопределено);
	НастройкиПодключенияЗаписать(context_params);
	Возврат session;
КонецФункции

Функция local_helper_init_remote_signing(context_params, data) Экспорт 
	response = local_helper_exec_method(context_params,"API3.InitRemoteSigning", Новый Структура("data", data), Истина);
	Результат = local_helper_api_process_responce(response);
	Возврат Результат;
КонецФункции

Функция local_helper_get_remote_signature(context_params, data) Экспорт
	response = local_helper_exec_method(context_params,"API3.GetRemoteSignature", Новый Структура("operation_uuid", data), Истина);
	Результат = local_helper_api_process_responce(response);
	Возврат Результат;			
КонецФункции

Функция local_helper_fed_convert_obj_to_xml(context, obj, xml_format, xml_version="", pattern="Генератор") Экспорт
	fed_type_subtype = СтрРазделить82(xml_format,"_");
	fed_version_subversion = СтрРазделить82(xml_version,"_");
	Если НЕ ЗначениеЗаполнено(obj) Тогда
		ВызватьИсключение "fed_convert_obj_to_xml:  The obj is undefined";
	ИначеЕсли НЕ ЗначениеЗаполнено(fed_type_subtype) ИЛИ fed_type_subtype.Количество() > 2 Тогда
		ВызватьИсключение "fed_convert_obj_to_xml:  Format defined incorrectly";
	ИначеЕсли НЕ ЗначениеЗаполнено(fed_version_subversion) ИЛИ fed_version_subversion.Количество() > 2 Тогда
		ВызватьИсключение "fed_convert_obj_to_xml: Version defined incorrectly";
	КонецЕсли;
	
	Если fed_type_subtype.Количество() > 1 Тогда
		ФедПодтип = fed_type_subtype[1];
	Иначе
		ФедПодтип = "";
	КонецЕсли;
	
	Если fed_version_subversion.Количество() > 1 Тогда
		ФедПодверсия = fed_version_subversion[1];
	Иначе
		ФедПодверсия = "";
	КонецЕсли; 
	
    params = Новый Структура("ТипДокумента, ПодТипДокумента, ВерсияФормата, ПодВерсияФормата",
	fed_type_subtype[0],
	ФедПодтип,
	fed_version_subversion[0],
	ФедПодверсия);
        response = local_helper_exec_method(context, "Интеграция.ФЭДСгенерировать", Новый Структура("Name,Format,Substitution", pattern, params, obj)); 
		Если get_prop(response, "result") <> Неопределено Тогда
            Возврат response["result"];
        Иначе
            ВызватьИсключение Строка(response);
		КонецЕсли;	
КонецФункции

Функция local_helper_fed_convert_xml_to_obj(context_params, pattern, b64xml) Экспорт
	response = local_helper_exec_method(context_params,"Интеграция.ФЭДПолучитьПодстановку", Новый Структура("Name, Xml", pattern, b64xml));
	Если get_prop(response, "result") <> Неопределено Тогда		
		Возврат response["result"];
	Иначе
		ВызватьИсключение Строка(response);
	КонецЕсли;	
КонецФункции

Функция local_helper_convert_to_pdfa_to_disk3(context_params, СсылкаФайла, СуффиксФайла) Экспорт
	Попытка
		response	= local_helper_exec_method(context_params,"EKDAPI.ConvertToPDFAToDisk",  Новый Структура("Data, Format, CheckEDOMode", СсылкаФайла, СуффиксФайла, Истина), Истина);
		Результат   = local_helper_api_process_responce(response);
	Исключение
		ИнфОбОшибке = ИнформацияОбОшибке();
		ВызватьИсключение NewExtExceptionСтрока(,"Не удалось преобразовать файл формата " + СуффиксФайла, "EKDAPI.ConvertToPDFAToDisk");
	КонецПопытки;
	Возврат Результат;
КонецФункции

Функция local_helper_convert_to_pdfa_to_disk_x(context_params, СсылкаФайла, СуффиксФайла) Экспорт
	Попытка
		response	= local_helper_exec_method(context_params,"EKDAPI.ConvertToPDFAToDiskX",  Новый Структура("Data, Format, CheckEDOMode", СсылкаФайла, СуффиксФайла, Истина), Истина);
		Результат   = local_helper_api_process_responce(response);
	Исключение
		ИнфОбОшибке = ИнформацияОбОшибке();
		ВызватьИсключение NewExtExceptionСтрока(,"Не удалось преобразовать файл формата " + СуффиксФайла, "EKDAPI.ConvertToPDFAToDisk");
	КонецПопытки;
	Возврат Результат; 
КонецФункции

Функция local_helper_convert_to_pdfa_to_disk2(context_params, СсылкаФайла, СуффиксФайла) Экспорт
	Попытка
		response	= local_helper_exec_method(context_params,"EKDAPI.ConvertToPDFAToDisk",  Новый Структура("Data, Format", СсылкаФайла, СуффиксФайла), Истина);
		Результат   = local_helper_api_process_responce(response);
	Исключение
		ИнфОбОшибке = ИнформацияОбОшибке();
		ВызватьИсключение NewExtExceptionСтрока(,"Не удалось преобразовать файл формата " + СуффиксФайла, "EKDAPI.ConvertToPDFAToDisk");
	КонецПопытки;
	Возврат Результат;
КонецФункции

Функция local_helper_convert_to_pdfa(context_params, СсылкаФайла, СуффиксФайла) Экспорт
	Попытка
		response	= local_helper_exec_method(context_params,"EKDAPI.ConvertToPDFA",  Новый Структура("Data, Format", СсылкаФайла, СуффиксФайла), Истина);
		Результат   = local_helper_api_process_responce(response);
	Исключение
		ИнфОбОшибке = ИнформацияОбОшибке();
		ВызватьИсключение NewExtExceptionСтрока(,"Не удалось преобразовать файл формата " + СуффиксФайла, "EKDAPI.ConvertToPDFA");
	КонецПопытки;
	Возврат Результат;
КонецФункции	

Функция local_helper_regl_get_by_types(context_params, ТипыДокументов) Экспорт
	response	= local_helper_exec_method(context_params,"EKDAPI.ReglGetByTypes",  Новый Структура("DocTypes", ТипыДокументов), Истина);
	Результат   = local_helper_api_process_responce(response);
	Возврат Результат;		
КонецФункции	

Функция ПреобразоватьВерсию(ВерсияМетаданных) Экспорт
	Версия = ВерсияМетаданных;
	МассивПодстрок = СтрРазделить82(Версия,".");
	Версия = "";
	Для Каждого Запись ИЗ МассивПодстрок Цикл
		Запись = ПРАВ("0000"+Запись,4);
		Версия = Версия + Запись;
	КонецЦикла;
	Возврат Версия;
КонецФункции

Функция copy_block_context(param, block_context)
	Для каждого Поле из block_context цикл
		Если лев(Поле.Ключ,1) <> "_" и не Поле.Значение = Неопределено Тогда
			param.Вставить(Поле.Ключ, Поле.Значение);
		КонецЕсли;
	КонецЦикла;	
КонецФункции

Функция fill_action(action, status, subtitle)
	elapsedTime = action.end - action.begin;
	action.begin = Формат(Дата(1, 1, 1) + action.begin / 1000, "ДФ='yyyy-MM-dd HH:mm:ss'") + "." + (action.begin%1000);
	action.end = Формат(Дата(1, 1, 1) + action.end / 1000, "ДФ='yyyy-MM-dd HH:mm:ss'") + "." + (action.end%1000);
	action.Вставить("ElapsedTime", elapsedTime);
	action.Вставить("Status", status);
	action.Вставить("Subtitle", subtitle);
	Возврат action
КонецФункции



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
	ИначеЕсли ВидТранспорта = "ExtSdk" Или ВидТранспорта = "ExtSdkCrypto" Тогда
		code_result = local_helper_exec_request_extsdk2(type_request, url, response_type, ПараметрыВыполнения, context_params); 
	ИначеЕсли ВидТранспорта = "SabyPluginConnector" Тогда
		code_result = local_helper_exec_request_sabypluginconnector(type_request, url, response_type, ПараметрыВыполнения, context_params); 
	ИначеЕсли ВидТранспорта = "APIClient" Тогда
		code_result = local_helper_exec_request_HTTPСоединение(type_request, url, response_type, ПараметрыВыполнения, context_params);; 
	Иначе 
		code_result = local_helper_exec_request_HTTPСоединение_server(type_request, url, response_type, ПараметрыВыполнения, context_params);	
	КонецЕсли;
	Возврат code_result;
КонецФункции

//DynamicDirective

Процедура local_helper_exec_request_HTTPСоединение_get_response_error(ИнфОбОшибке)  
	ОшибкаСтруктура = ExtExceptionAnalyse(ИнфОбОшибке);
	Если ОшибкаСтруктура.message = "Ошибка работы с Интернет:  Превышен таймаут" Тогда 
		ВызватьИсключение NewExtExceptionСтрока(ИнфОбОшибке, "Ошибка выполнения HTTP запроса",,,, "TimeOut");
	КонецЕсли;	
	ВызватьИсключение NewExtExceptionСтрока(ИнфОбОшибке, "Ошибка выполнения HTTP запроса");	
КонецПроцедуры

// Получает ответ на действие с HTTP-соединением
//
// Параметры:
//  http_connection - HTTPСоединение - объект соединения.
//  http_request - HTTPЗапрос - объект запроса.
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
			local_helper_exec_request_HTTPСоединение_get_response_error(ИнфОбОшибке);
		КонецПопытки;
	ИначеЕсли request_type = "get" Тогда
		Попытка
			http_response	= http_connection.Получить(http_request);	
		Исключение
		    ИнфОбОшибке = ИнформацияОбОшибке();
			local_helper_exec_request_HTTPСоединение_get_response_error(ИнфОбОшибке);
		КонецПопытки;
	Иначе
		ВызватьИсключение NewExtExceptionСтрока(,"Неизвестный тип HTTP запроса", request_type);		
	КонецЕсли;
   	Возврат http_response;
КонецФункции

#Область include_core_base_Транспорт_LocalHelper_HTTPСоединение
#КонецОбласти

// Обработать ответ на запрос через HTTP-соединение
//
// Параметры:
//  response_type - Строка - тип ответа.
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
				response.result = local_helper_json_decode(http_response.ПолучитьТелоКакСтроку());
			ИначеЕсли response_type = "text" Тогда
				response.result = http_response.ПолучитьТелоКакСтроку();
			ИначеЕсли response_type = "binary" Тогда	
				response.result = http_response.ПолучитьТелоКакДвоичныеДанные();
			Иначе
				Возврат response;
			КонецЕсли;
		Иначе
			Тело = http_response.ПолучитьТелоКакСтроку();
			
			Если ПустаяСтрока(Тело) Тогда
				response.result = СокрЛП(response.code) + " Неизвестная ошибка";
			Иначе
				Если Найти(content_type, "application/json") > 0 Тогда
					response.result = local_helper_json_decode(Тело);	
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
	params = get_prop(ПараметрыВыполнения, "params", Новый Структура);
	Если Найти(request_url,"/integration-sync") > 0 Тогда
		service = "integration-sync"; 
	ИначеЕсли Найти(request_url,"/int-settings") > 0 Тогда
		service = "int-settings";
	ИначеЕсли Найти(request_url,"/auth") > 0 Тогда
		service = "auth";
	ИначеЕсли Найти(request_url,"/hr-api") > 0 Тогда
		service = "hr-api";
	Иначе
		service = "online"; 
	КонецЕсли;
	MethodName = "ExtSdk2.CallSabyApi3";
	
	// Для совместимости с версиями SabyPlugin ниже 25.5200 (Убрать после 26.3100)
	ОграничениеПараметровСоответствия = 2;
	ВозможноПередатьВМассив = (ТипЗнч(params) = Тип("Структура") И params.Количество() > 0) 
		Или (ТипЗнч(params) = Тип("Соответствие") И params.Количество() < ОграничениеПараметровСоответствия);
	Если ВозможноПередатьВМассив Тогда
		ПараметрыCallApi = Новый Массив;
		Для Каждого КлючИЗначение Из params Цикл
			ПараметрыCallApi.Добавить(КлючИЗначение.Значение);
		КонецЦикла;
		params = ПараметрыCallApi;
	КонецЕсли;
	
	ПараметрыВызова = Новый Соответствие;
	ПараметрыВызова.Вставить("Method", get_prop(ПараметрыВыполнения, "method", ""));
	ПараметрыВызова.Вставить("Params", params);
	ПараметрыВызова.Вставить("Service", service);
	Возврат Новый Структура("MethodName,ПараметрыВызова", MethodName, ПараметрыВызова);
КонецФункции


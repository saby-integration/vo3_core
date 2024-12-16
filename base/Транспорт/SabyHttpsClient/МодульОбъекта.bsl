
// Проверка на использование транспорта SabyHttpsClient
//
// Параметры:
//  context_params - Структура - Контекст.
//
// Возвращаемое значение:
//   Булево - Истина, если метод обмена = "SabyHttpsClient", иначе Ложь
//
//DynamicDirective
Функция ТранспортSabyHttpsClient(context_params) Экспорт
	Результат = block_obj_get_path_value(context_params, "public.exchange_method", "");
	Если Результат = "SabyHttpsClient" Тогда
		Возврат Истина;
	КонецЕсли;
	Возврат Ложь;
КонецФункции

//DynamicDirective
Процедура block_multithreadloop_get_async_request()
	Пока Истина Цикл
		Если async_requests.Количество() = 0 Тогда
			Прервать;
		КонецЕсли;
		SabyHttpsClient_get_answer_request();
		Если async_responces.Количество() > 0 Тогда 
			Прервать;	
		КонецЕсли;	
		SabyHttpsClient.Sleep(2000);
	КонецЦикла;	
КонецПроцедуры

// Получить ответ на запрос SabyHttpsClient
//
// Параметры:
//  QueryId - Произвольный - идентификатор запроса.
//
// Возвращаемое значение:
//   Произвольный - ответ
//
//DynamicDirective
Функция SabyHttpsClient_get_answer_request(QueryId = Неопределено) 
	response =  SabyHttpsClient.ReadAllResponse();
	response = decode_xml_xdto(response);
	Результат = response["Response"]; 	   		
	РезультатЗапроса = Неопределено;
	Для Каждого Запись ИЗ Результат Цикл 
		ЗаписьQueryId = Запись["QueryId"]; 
		Если ЗаписьQueryId <> QueryId Тогда
			ПараметрыЗапроса = async_requests.Получить(ЗаписьQueryId);
			Если ПараметрыЗапроса <> Неопределено Тогда 
				async_responce = Новый Структура("ПараметрыЗапроса,РезультатЗапроса", ПараметрыЗапроса, Запись);
				async_responces.Вставить(Запись["QueryId"], async_responce);   
			КонецЕсли;
			async_requests.Удалить(ЗаписьQueryId);
		Иначе
			РезультатЗапроса = Запись;		
		КонецЕсли;	
	КонецЦикла;	
	Возврат РезультатЗапроса;
КонецФункции

// Создает структуру запроса SabyHttpsClient
//
// Параметры:
//  request_url - Строка - ссылка.
//  request_type - Строка - тип запроса.
//  ПараметрыВыполнения - Структура - параметры.
//  QueryId - Произвольный - идентификатор запроса.
//
// Возвращаемое значение:
//   Структура - структура запроса
//
//DynamicDirective
Функция SabyHttpsClient_querycreate(request_url, request_type, ПараметрыВыполнения, QueryId)
	Запрос = Новый Структура;   	
	Запрос.Вставить("Url",request_url);
	Если ПараметрыВыполнения <> Неопределено
		И ПараметрыВыполнения.Свойство("data") Тогда 
		Запрос.Вставить("Body", ПараметрыВыполнения.data);
	КонецЕсли;	
	Запрос.Вставить("Type", 	ВРЕГ(request_type));
	Запрос.Вставить("QueryId", 	QueryId);

	Headers = Новый Массив; 
	Если ПараметрыВыполнения <> Неопределено
		И ПараметрыВыполнения.Свойство("Headers") 
		И ТипЗнч(ПараметрыВыполнения.Headers) = Тип("Соответствие") Тогда		
		Для Каждого Запись ИЗ ПараметрыВыполнения.Headers Цикл 
			Если ЗначениеЗаполнено(Запись.Значение) Тогда 
				СтруктураHeader = Новый Структура; 
				СтруктураHeader.Вставить("name",Запись.Ключ);
				СтруктураHeader.Вставить("value",Запись.Значение);
				Headers.Добавить(СтруктураHeader);
			КонецЕсли;	
		КонецЦикла;	    
	КонецЕсли;
	Запрос.Вставить("Headers", Headers);
	Возврат Запрос;
КонецФункции

Функция local_helper_exec_request_SabyHttpsClient_server(request_type, Знач request_url, response_type, ПараметрыВыполнения, context_params = Неопределено)	Экспорт
	Возврат МодульОбъекта().local_helper_exec_request_SabyHttpsClient(
		request_type,
		request_url,
		response_type,
		ПараметрыВыполнения,
		context_params);	
КонецФункции

// Выполняет запрос SabyHttpsClient
//
// Параметры:
//  request_type - Строка - тип запроса.
//  request_url - Строка - ссылка.
//  response_type - Строка - тип ответа.
//  ПараметрыВыполнения - Структура - параметры.
//  context_params - Структура - контекст.
//
// Возвращаемое значение:
//   Структура - "code","result"
//
//DynamicDirective
Функция local_helper_exec_request_SabyHttpsClient(request_type, Знач request_url, response_type, ПараметрыВыполнения, context_params = Неопределено) Экспорт	
	
	Если ЭтоСервер() Тогда 
		Возврат local_helper_exec_request_SabyHttpsClient_server(request_type, request_url, response_type, ПараметрыВыполнения, context_params);	
	КонецЕсли;
	
	QueryId = Строка(Новый УникальныйИдентификатор);
	
	Запрос = SabyHttpsClient_querycreate(request_url, request_type, ПараметрыВыполнения, QueryId);
	
	Если SabyHttpsClient = Неопределено Тогда
		SabyHttpsClient = ПодключитьКомпонентуSabyHttpsClient(context_params); 
	КонецЕсли;

	XMLСтрокаЗапроса = encode_xdto_xml(Запрос); 	
	res = SabyHttpsClient.Request(XMLСтрокаЗапроса); 
	multithread_mode = block_obj_get_path_value(ПараметрыВыполнения, "multithread_mode", "");
	Если multithread_mode = Истина Тогда 
		Deadline = ТекущаяДата() + get_prop(ПараметрыВыполнения,"timeout",60);
		dump = Новый Структура;
		dump.Вставить("QueryId", 				QueryId);
		dump.Вставить("Deadline", 				Deadline);
		dump.Вставить("request_type", 			request_type);
		dump.Вставить("request_url", 			request_url);
		dump.Вставить("response_type", 			response_type);
		dump.Вставить("ПараметрыВыполнения", 	ПараметрыВыполнения);
		dump.Вставить("context_params", 		context_params);
		ВызватьИсключение NewExtExceptionСтрока(,"AsyncRequest",,,dump,"AsyncRequest");	
	КонецЕсли;  
	
	СчетчикЦиклов = 1;	
	Пока Истина Цикл
		Если СчетчикЦиклов > 1800 Тогда
			ВызватьИсключение "Долгое выполнение запроса "+request_type;	
		КонецЕсли;
		SabyHttpsClient.Sleep(100); 
		РезультатЗапроса = SabyHttpsClient_get_answer_request(QueryId);
		Если РезультатЗапроса <> Неопределено Тогда
			Результат = ОбработкаРезультатаЗапросаSabyHttpsClient(РезультатЗапроса);
			Прервать;
		КонецЕсли;
		СчетчикЦиклов = СчетчикЦиклов + 1;
	КонецЦикла;
	Возврат Результат;		
КонецФункции

// Асинхронный ответ на запрос SabyHttpsClient
//
// Параметры:
//  async_responce - Структура - данные запроса.
//
// Возвращаемое значение:
//   Структура - "code","result"
//
//DynamicDirective
Функция	local_helper_exec_request_async_process_responce(async_responce) 
	РезультатЗапроса = get_prop(async_responce,"РезультатЗапроса");		
	Результат = ОбработкаРезультатаЗапросаSabyHttpsClient(РезультатЗапроса); 
	Возврат Результат;
КонецФункции

Функция ПолучитьПутьКомпонентыSabyHttpsClient(context_params)
	ПутьКомпоненты = get_prop(context_params,"ПутьКомпонентыSabyHttpsClient",Неопределено); 
	Если ПутьКомпоненты <> Неопределено Тогда   
		// BSLLS:MissingTempStorageDeletion-off
		Значение = ПолучитьИзВременногоХранилища(ПутьКомпоненты);
		// BSLLS:MissingTempStorageDeletion-on	
		Если Значение <> Неопределено Тогда
			Возврат ПутьКомпоненты;
		КонецЕсли;	
	КонецЕсли;
	МакетSabyHttpsClient = Метаданные.НайтиПоПолномуИмени("Обработка.SABY.Макет.SabyHttpsClient");	
	Если МакетSabyHttpsClient = Неопределено Тогда 
		МодульОбъекта = МодульОбъекта();
		ПутьКомпоненты = МодульОбъекта.АдресНативнойКомпонентыИзВнешнейОбработки("SABYHttpClient");
	Иначе
		ПутьКомпоненты = "Обработка.SABY.Макет.SabyHttpsClient";		
	КонецЕсли;
	Если context_params <> Неопределено Тогда 
		context_params.Вставить("ПутьКомпонентыSabyHttpsClient", ПутьКомпоненты);
		НастройкиПодключенияЗаписать(context_params); 
		ОбщиеНастройки = ОбщиеНастройкиПрочитать();
		public = get_prop(ОбщиеНастройки,"public");
		context_params.Вставить("public", public);
	КонецЕсли;	
	Возврат ПутьКомпоненты;	
КонецФункции

// Создает объект компоненты SabyHttpsClient
//
// Параметры:
//  context_params - Структура - контекст.
//
// Возвращаемое значение:
//   ВнешняяКомпонента
//
//DynamicDirective
Функция ПодключитьКомпонентуSabyHttpsClient(context_params) Экспорт
	ПутьКомпоненты = ПолучитьПутьКомпонентыSabyHttpsClient(context_params); 
	ПодключениеВыполнено = ПодключитьВнешнююКомпоненту(ПутьКомпоненты, "Community", ТипВнешнейКомпоненты.Native); 
	Компонента = Новый("AddIn.Community.SabyHttpsClient");
	Если Компонента = Неопределено Тогда
		ВызватьИсключение "Не удалось создать объект компоненты";
	КонецЕсли;
	ProxyParam = get_prop(context_params, "Proxy");
	Прокси = Новый Структура;      
	Прокси.Вставить("Type", 	"");
	Если ProxyParam <> Неопределено Тогда 
		Прокси.Вставить("Url",		ProxyParam.Server);
		Прокси.Вставить("Port", 	Формат(ProxyParam.Port,"ЧГ="));     
		Прокси.Вставить("Login", 	ProxyParam.User);
		Прокси.Вставить("Password", ProxyParam.Password);
		Прокси.Вставить("Type", 	"PROXY");
	КонецЕсли;	
	Компонента.SetProxy( encode_xdto_xml(Прокси));	
	Возврат Компонента;

КонецФункции	

// Обрабокта результат запроса SabyHttpsClient
//
// Параметры:
//  РезультатЗапроса - Структура - результат запроса.
//
// Возвращаемое значение:
//   Структура - "code","result"
//
//DynamicDirective
Функция ОбработкаРезультатаЗапросаSabyHttpsClient(РезультатЗапроса)  
	Result = get_prop(РезультатЗапроса,"Result", Неопределено);
	Результат = get_prop(Result,"Data", Неопределено);; 	
	code = get_prop(Result,"Status", Неопределено);	
	Если code = 0 Тогда
		code = 200;
	ИначеЕсли code = 11 ИЛИ code = 26 Тогда	
		code = 401;
	КонецЕсли;
	Result = Новый Структура;
	Result.Вставить("code",code);
	Result.Вставить("result",Результат);
	Возврат Result;
КонецФункции


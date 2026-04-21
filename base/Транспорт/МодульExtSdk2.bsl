
// Вызывается метод через транспорт ExtSdk2
//
// Параметры:
//  request_type - Строка - тип запроса.
//  request_url - Строка - ссылка.
//  response_type - Строка - тип ответа.
//  __kwargs - Структура - параметры.
//  context_params - Структура - контекст.
//  НомПереадресации - Число - номер переадресации.
//
// Возвращаемое значение:
//   Структура - "code","result"
//
//DynamicDirective
Функция local_helper_exec_request_extsdk2(request_type, Знач request_url, response_type,
		__kwargs = Неопределено, context_params = Неопределено, Знач НомПереадресации = 0)
	ПараметрыCallMethod = local_helper_exec_request_extsdk2_get_parameters(__kwargs, request_url);
	MethodName = get_prop(ПараметрыCallMethod, "MethodName");
	ПараметрыВызова = get_prop(ПараметрыCallMethod, "ПараметрыВызова"); 
	multithread_mode = get_prop(__kwargs, "multithread_mode", Ложь);
	Result = CallMethod(MethodName, ПараметрыВызова, context_params, multithread_mode);
	Возврат Result;		
КонецФункции

// Возвращает объект плагина ExtSdk2
//
// Возвращаемое значение:
//   COMОбъект - объект плагина
//
//DynamicDirective
Функция ОбъектПлагинаExtSdk2()
	Если КомпонентаИнтеграции <> Неопределено Тогда
		Возврат КомпонентаИнтеграции;
	КонецЕсли;
	Попытка
		СистемнаяИнформация = Новый СистемнаяИнформация;
		Если Не СистемнаяИнформация.ТипПлатформы = ТипПлатформы.Linux_x86 Или ТипПлатформы.Linux_x86_64 Тогда
			КомпонентаИнтеграции = Новый COMОбъект("Tensor.SbisPluginClientCOM");
		КонецЕсли;
	Исключение
		Возврат Новый Структура("code, message, details", 767, "Ошибка при создании COM-объекта", "Не зарегистрирована компонента Tensor.SbisPluginClientCOM." + ОписаниеОшибки());
	КонецПопытки;
	Возврат КомпонентаИнтеграции;
КонецФункции

// Возвращает результат запроса ExtSdk2
//
// Параметры:
//  ОбъектПлагина - COMОбъект - объект плагина.
//  QueryId - Произвольный - идентификатор запроса.
//  request_type - Строка - тип запроса.
//
// Возвращаемое значение:
//   Произвольный - ответ
//
//DynamicDirective
Функция РезультатЗапросаExtSdk2(ОбъектПлагина, QueryId = Неопределено, request_type = "") 
	ОтветНеПолучен = Истина;
	СчетчикЦиклов = 1;	
	Результат = Неопределено;
	Пока ОтветНеПолучен Цикл	 
		Если СчетчикЦиклов > 1800 Тогда
			ВызватьИсключение "Долгое выполнение запроса "+request_type;	
		КонецЕсли;
		Ответы = local_helper_json_decode(ОбъектПлагина.ReadAllObject());
		Для Каждого Ответ Из Ответы Цикл 
			Если  get_prop(Ответ, "queryID", Ложь) = QueryId Тогда
				ОтветНеПолучен = Ложь;
				Результат = Ответ;
			Иначе 
				ОбработатьОтветExtSDK2(Ответ);	
			КонецЕсли;	
		КонецЦикла;  
		Если QueryId = Неопределено Тогда
			Прервать;	
		КонецЕсли;
		Если ОтветНеПолучен Тогда
			ОбъектПлагина.Sleep(300);
		КонецЕсли;	
		СчетчикЦиклов = СчетчикЦиклов + 1;
	КонецЦикла;
	Возврат Результат; 
КонецФункции

//DynamicDirective

Процедура ОбработатьОтветExtSDK2(Запись)
	Если ТипЗнч(async_responces) <> Тип("Соответствие") Тогда
		Возврат;
	КонецЕсли;	
	Если ТипЗнч(async_requests) <> Тип("Соответствие") Тогда
		Возврат;
	КонецЕсли;	
	ЗаписьQueryId = Запись["queryID"];  
	Результат = ОбработкаСобытияExtSdk2(Запись);
	ПараметрыЗапроса = async_requests.Получить(ЗаписьQueryId);
	Если ПараметрыЗапроса <> Неопределено Тогда 
		async_responce = Новый Структура("ПараметрыЗапроса,РезультатЗапроса", ПараметрыЗапроса, Результат);
		async_responces.Вставить(ЗаписьQueryId, async_responce);   
	КонецЕсли;
	async_requests.Удалить(ЗаписьQueryId);	
КонецПроцедуры

//DynamicDirective

Функция ИдентификаторМодуляКомпонентыИнтеграции(ИмяМодуля)
	Если Не ЗначениеЗаполнено(МодульКомпонентыИнтеграции) Тогда 
		МодульКомпонентыИнтеграции = КомпонентаИнтеграции.GetModule(ИмяМодуля);	
	КонецЕсли;
	Возврат МодульКомпонентыИнтеграции; 
КонецФункции

// Обрабатывает результат запроса
//
// Параметры:
//  РезультатЗапроса - Структура - результат.
//
// Возвращаемое значение:
//   Структура - "code","result"
//
//DynamicDirective
Функция ОбработкаСобытияExtSdk2(РезультатЗапроса)  
	Result = Новый Структура;
	Data = get_prop(РезультатЗапроса, "data", Неопределено);  
	Если get_prop(РезультатЗапроса, "type", "") = "Error" Тогда 
		Результат = get_prop(Data, "Error", Data); 	
		Result.Вставить("code", get_prop(Результат, "code", Неопределено));
		Result.Вставить("result", Новый Структура("error", Результат));	 		
	ИначеЕсли get_prop(РезультатЗапроса, "type", "") = "Message" Тогда	
		Результат = get_prop(Data, "Result", Неопределено);; 	
		code = 200;	
		Result.Вставить("code", code);
		Result.Вставить("result", Новый Структура("result", Результат));
	Иначе
		Result = Новый Структура;	
	КонецЕсли;	
	Возврат Result;
КонецФункции

// Получает список аккаунтов через ExtSdk2
//
// Параметры:
//  context_params - Структура - контекст.
//
// Возвращаемое значение:
//   Структура - "code","result"
//
//DynamicDirective
Функция AccountListExtSDK2(context_params)
	MethodName = "ExtSdk2.AccountList";
	ПараметрыВызова = Новый Структура;
	result = CallMethod(MethodName, ПараметрыВызова, context_params);
	Возврат get_prop(get_prop(result, "result"), "result", Новый Массив);
КонецФункции      

// Переключить аккаунт через ExtSdk2
//
// Параметры:
//  context_params - Структура - контекст.
//  НомерАккаунта - Строка - номер аккаунта.
//
// Возвращаемое значение:
//   Структура - "code","result"
//
//DynamicDirective
Функция SwitchAccountExtSDK2(context_params, НомерАккаунта)
	MethodName = "ExtSdk2.SwitchAccount";
	Param = Новый Структура("НомерАккаунта", НомерАккаунта);
	ПараметрыВызова = Новый Структура("Param ", Param);	
	res = CallMethod(MethodName, ПараметрыВызова, context_params);
	res = get_prop(res,"result");	
	res = get_prop(res,"result");
	Возврат res;	
КонецФункции

// Расширенные действия над документом через ExtSdk2
//
// Параметры:
//  context_params - Структура - параметры соединения.
//  doc - Структура - документ.
//	multithread_mode - Булево - многопоточный режим
//
// Возвращаемое значение:
//   Структура - "result"
//
//DynamicDirective
Функция local_helper_execute_action_ex(context_params, doc, multithread_mode = Ложь) Экспорт 
	MethodName = "ExtSdk2.ExecuteActionEx";
	ПараметрыВызова = Новый Структура;
	ПараметрыВызова.Вставить("Document", doc);	
	res = CallMethod(MethodName, ПараметрыВызова, context_params, multithread_mode);
	res = get_prop(res,"result");	
	res = get_prop(res,"result");
	Возврат res;
КонецФункции	

// Вход через ExtSdk2
//
// Параметры:
//  context_params - Структура - контекст.
//  Кэш - Структура - Кэш.
//
//DynamicDirective
Процедура ВойтиExtSdk2(context_params, Кэш = Неопределено)
	// BSLLS:DuplicateStringLiteral-off
	Call_param = Новый Структура;
	МассивСтатистики = Новый Массив;
	НаименованиеДействия = "Auth";
	AuthType = get_prop(context_params, "AuthType", "Login");
	Если AuthType = "Login" Тогда
		Call_param.Вставить("Login", context_params.login);	
		decrypt_password = РасшифроватьXOR(context_params.password, context_params);
		Call_param.Вставить("Password", decrypt_password);
		MethodName = "ExtSdk2.AuthByPassword";
		КонтекстДействия = "Password";
	ИначеЕсли AuthType = "Certificate" Тогда
		Call_param.Вставить("Imprint", get_prop(context_params, "Certificate", Неопределено));	
		MethodName = "ExtSdk2.AuthByCert"; 
		КонтекстДействия = "Certificate";
	ИначеЕсли AuthType = "User1C" Тогда 
		Токен = ТокенДляТекущегоПользователя(context_params);
		Call_param.Вставить("Token", Токен);	
		MethodName = "ExtSdk2.AuthByToken";	
		КонтекстДействия = "ExternalUser";	
	Иначе
		ВызватьИсключение "Указан неверный вид авторизации";
	КонецЕсли;
	Хост = СтрЗаменить(get_prop(context_params, "ApiUrl",""), "https://", "");
	Хост = СтрЗаменить(Хост, "ie-1c", "online"); 
	ДопПараметры = Новый Структура("БезАвторизации,Хост,ОчиститьПараметры", Истина, Хост, Истина);
	
	data_session = CallMethod(MethodName, Call_param, context_params, , ДопПараметры);
	data_session = get_prop(data_session, "result", Неопределено);	
	session = get_prop(data_session, "result", Неопределено);	
	СтруктураСессии = Новый Структура; 
	СтруктураСессии.Вставить("Session", session);
	ЗаписатьСессию(context_params, СтруктураСессии);

	НастройкиПодключенияЗаписать(context_params);
	
	ЭлементСтатистики	= local_helper_element_action(НаименованиеДействия, КонтекстДействия, Новый Структура(), 1);
	МассивСтатистики.Добавить(ЭлементСтатистики);
	local_helper_register_actions(context_params, МассивСтатистики);
	// BSLLS:DuplicateStringLiteral-on
КонецПроцедуры 

//DynamicDirective

Процедура UploadToSbisDisk(context_params, Вложение, request_url) Экспорт
	Файл = get_prop(Вложение, "Файл"); 
	Base64 = get_prop(Файл, "ДвоичныеДанные");
	
	ДвоичныеДанные = ПолучитьДвоичныеДанные(Файл, Base64);
	Если ДвоичныеДанные = Неопределено Тогда 
		Возврат;
	КонецЕсли;		
	
	// BSLLS:UsingSynchronousCalls-off Для совместимости с платформой 8.2
	#Если ВебКлиент Тогда
		// BSLLS:TempFilesDir-off
		ИмяВременногоФайла = КаталогВременныхФайлов() + "sbis_" + Строка(Новый УникальныйИдентификатор())+".tmp";
		// BSLLS:TempFilesDir-on
	#Иначе
		ИмяВременногоФайла = ПолучитьИмяВременногоФайла();
	#КонецЕсли
	// BSLLS:UsingSynchronousCalls-on
	ДвоичныеДанные.Записать(ИмяВременногоФайла);
	
	MethodName = "ExtSdk2.UploadToSbisDisk";
	ПараметрыМетода = Новый Структура;
	ПараметрыМетода.Вставить("fileName", ИмяВременногоФайла);
	ПараметрыМетода.Вставить("newFileName", get_prop(Файл, "Имя"));
	ПараметрыМетода.Вставить("targetURL", request_url);
	ПараметрыЗагрузки = Новый Структура("Param", ПараметрыМетода);
    Результат = CallMethod(MethodName, ПараметрыЗагрузки, context_params);
	КодОК = 200;
	КодCreated = 201; 
	code = get_prop(Результат, "code");
	Если code = КодОК Или code = КодCreated Тогда
		Ответ = get_prop(Результат, "result");
		Файл.Вставить("Ссылка", get_prop(get_prop(Ответ, "result"), "UploadId"));
	Иначе
		Файл.Вставить("ДвоичныеДанные", Base64);
		NewExtExceptionСтрока(, "Ошибка загрузки на СБИС диск.", 
		code, ,
		Новый Структура("body", get_prop(Результат, "result")));
	КонецЕсли;
	Попытка
		// BSLLS:UsingSynchronousCalls-off Для совместимости со старыми платформами
		УдалитьФайлы(ИмяВременногоФайла);
		// BSLLS:UsingSynchronousCalls-off
	Исключение
		Возврат;
	КонецПопытки;
КонецПроцедуры

// Чтение файла со СБИС диска через ExtSdk2
//
// Параметры:
//  context_params - Структура - контекст.
//  URL - Строка - ссылка.
//
// Возвращаемое значение:
//   ДвоичныеДанные - данные файла
//
//DynamicDirective
Функция LoadDataFromURLToFile(context_params,URL) Экспорт 
	// BSLLS:UsingSynchronousCalls-off
	MethodName = "ExtSdk2.LoadDataFromURLToFile";
	#Если ВебКлиент Тогда
		// BSLLS:TempFilesDir-off
		ИмяВременногоФайла = КаталогВременныхФайлов() + "sbis_" + Строка(Новый УникальныйИдентификатор())+".tmp";
		// BSLLS:TempFilesDir-on
	#Иначе
		ИмяВременногоФайла = ПолучитьИмяВременногоФайла();
	#КонецЕсли
	ПараметрыЗагрузки = Новый Структура;
	ПараметрыЗагрузки.Вставить("Url", URL);
	ПараметрыЗагрузки.Вставить("FileName", ИмяВременногоФайла);
	Результат =  CallMethod(MethodName, ПараметрыЗагрузки, context_params);
	
	res = get_prop(Результат,"result", Неопределено); 
	res = get_prop(res,"result"); 
	Если res = 1 Тогда
		ДвоичныеДанные = Новый ДвоичныеДанные(ИмяВременногоФайла);
		УдалитьФайлы(ИмяВременногоФайла);
		Возврат ДвоичныеДанные; 
	Иначе
		ВызватьИсключение "Не удалось загрузить файл";
	КонецЕсли;
	// BSLLS:UsingSynchronousCalls-on
КонецФункции

//DynamicDirective

Функция ReadCertListForAuthExtSDK2(context_params) Экспорт
	MethodName = "ExtSdk2.ReadCertListForAuth";
	Call_param = Новый Структура("Filter", Новый Структура);;
	
	Хост = СтрЗаменить(get_prop(context_params,"ApiUrl",""), "https://","");
	Хост = СтрЗаменить(Хост, "ie-1c","online"); 
	ДопПараметры = Новый Структура("БезАвторизации,Хост,ОчиститьПараметры", Истина, Хост, Истина);
	res = CallMethod(MethodName, Call_param, context_params, , ДопПараметры);
	res = get_prop(res, "result");
	Возврат get_prop(res, "Result");	
КонецФункции

//DynamicDirective

Функция AuthenticateBySession(context_params, session_id) Экспорт  
	MethodName = "ExtSdk2.AuthenticateBySession";
	Call_param = Новый Структура("Session", session_id);	
	Хост = СтрЗаменить(get_prop(context_params,"ApiUrl",""), "https://","");
	Хост = СтрЗаменить(Хост, "ie-1c","online"); 
	QueryId = Строка(Новый УникальныйИдентификатор);
	ДопПараметры = Новый Структура("БезАвторизации,Хост,ОчиститьПараметры", Истина, Хост, Истина);
	res = CallMethod(MethodName, Call_param, context_params, , ДопПараметры);
	res = get_prop(res, "result");
	Возврат get_prop(res, "Result"); 	
КонецФункции

//DynamicDirective

Функция WriteDocumentExtSdk2(context_params, doc, multithread_mode = Ложь) Экспорт 
	MethodName = "ExtSdk2.WriteDocument";
	ПараметрыЗагрузки = Новый Структура;
	ПараметрыЗагрузки.Вставить("Document", doc);
	Результат =  CallMethod(MethodName, ПараметрыЗагрузки, context_params, multithread_mode);
	
	res = get_prop(Результат, "result", Неопределено); 
	res = get_prop(res, "result"); 
	Возврат res;
КонецФункции

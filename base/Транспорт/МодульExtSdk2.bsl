
//DynamicDirective
Функция local_helper_exec_request_extsdk2(request_type, Знач request_url, response_type,
		__kwargs = Неопределено, context_params = Неопределено, Знач НомПереадресации = 0)
	Компонента = ОбъектПлагинаExtSdk2();	

	ПараметрыCallMethod = local_helper_exec_request_extsdk2_get_parameters(__kwargs, request_url);
	MethodName = get_prop(ПараметрыCallMethod, "MethodName");
	ПараметрыВызова = get_prop(ПараметрыCallMethod, "ПараметрыВызова");
	Result = CallMethodExtSdk2(MethodName, ПараметрыВызова, context_params);
	Возврат Result;		
КонецФункции

//DynamicDirective
Функция CallMethodExtSdk2(MethodName, ПараметрыВызова, context_params)
	QueryId = Строка(Новый УникальныйИдентификатор); 
	Call_param = encode_xdto_json(ПараметрыВызова);
	Sbi3Module_ID = Компонента.GetModule("ExtSdk2");
	Account_ID = get_prop(context_params,"session","");
	Компонента.CallMethod(QueryId, Sbi3Module_ID, MethodName, Call_param, Account_ID);
	
	//  multithread_mode = get_prop(ПараметрыВыполнения, "multithread_mode", "");
	//Если multithread_mode = Истина Тогда 
	//	Deadline = ДатаСеанса() + get_prop(ПараметрыВыполнения,"timeout",60);
	//	dump = Новый Структура;
	//	dump.Вставить("QueryId", 				QueryId);
	//	dump.Вставить("Deadline", 				Deadline);
	//	dump.Вставить("request_type", 			request_type);
	//	dump.Вставить("request_url", 			request_url);
	//	dump.Вставить("response_type", 			response_type);
	//	dump.Вставить("ПараметрыВыполнения", 	ПараметрыВыполнения);
	//	dump.Вставить("context_params", 		context_params);
	//	ВызватьИсключение NewExtExceptionСтрока(,"AsyncRequest",,,dump,"AsyncRequest");	
	//КонецЕсли;  

	
	Результат =  РезультатЗапросаExtSdk2(Компонента, QueryId); 
	Result = ОбработкаРезультатаЗапроса(Результат);
	Возврат Result;	
КонецФункции

//DynamicDirective
Функция CallMethodWithoutAuthExtSdk2(QueryId, Sbi3Module_ID, MethodName, Call_param, Хост)
	Call_param = encode_xdto_json(Call_param);
	Возврат Компонента.CallMethodWithoutAuth(QueryId, Sbi3Module_ID, MethodName, Call_param, Хост);
КонецФункции

//DynamicDirective
Функция ОбъектПлагинаExtSdk2()
	Если Компонента <> Неопределено Тогда
		Возврат Компонента;
	КонецЕсли;
	Попытка
		ОбъектПлагин = Новый COMОбъект("Tensor.SbisPluginClientCOM");
	Исключение
		Отказ = Истина;
		Возврат Новый Структура("code, message, details", 767, "Ошибка при создании COM-объекта", "Не зарегистрирована компонента Tensor.SbisPluginClientCOM." + ОписаниеОшибки());
	КонецПопытки;
	Возврат ОбъектПлагин;
КонецФункции

//DynamicDirective
Функция РезультатЗапросаExtSdk2(ОбъектПлагина, QueryId, request_type = "") 
	ОтветНеПолучен = Истина;
	СчетчикЦиклов = 1;	
	Пока ОтветНеПолучен Цикл	 
		Если СчетчикЦиклов > 1800 Тогда
			ВызватьИсключение "Долгое выполнение запроса "+request_type;	
		КонецЕсли;
		Ответы = local_helper_json_loads(ОбъектПлагина.ReadAllObject());
		Для Каждого Ответ Из Ответы Цикл 
			Если  get_prop(Ответ,"queryID",Неопределено) = QueryId Тогда 
				Возврат Ответ;
			КонецЕсли;	
		КонецЦикла;  
		ОбъектПлагина.Sleep(300);
		СчетчикЦиклов = СчетчикЦиклов + 1;
	КонецЦикла;
	Возврат Неопределено; 
КонецФункции

//DynamicDirective
Функция CallMethodWithoutAuth(QueryId, MethodName, Call_param, Хост, context_params)
	Результат = Неопределено;
	ВидТранспорта = ВидТранспорта(context_params);
	Если ВидТранспорта = "ExtSdk2" Тогда  
		Компонента = ОбъектПлагинаExtSdk2();			
		Sbi3Module_ID = Компонента.GetModule("ExtSdk2"); 
		CallMethodWithoutAuthExtSdk2(QueryId, Sbi3Module_ID, MethodName, Call_param, Хост);
	    Результат = РезультатЗапросаExtSdk2(Компонента, QueryId);
	ИначеЕсли ВидТранспорта = "SabyPluginConnector" Тогда
		Компонента = КомпонентаSABYPluginConnector();			
		Sbi3Module_ID = Компонента.GetModule("ExtSdk2"); 
		CallMethodWithoutAuthSabyPluginConnector(QueryId, Sbi3Module_ID, MethodName, Call_param, Хост);
		Результат = РезультатЗапросаSabyPluginConnector(Компонента, QueryId);
	КонецЕсли;
	Возврат Результат;	
КонецФункции

//DynamicDirective
Функция ОбработкаРезультатаЗапроса(РезультатЗапроса)  
	Data = get_prop(РезультатЗапроса,"data", Неопределено);  
	Если get_prop(РезультатЗапроса,"type","") = "Error" Тогда
		ВызватьИсключение NewExtExceptionСтрока(Неопределено,get_prop(Data,"message",""),get_prop(Data,"detail",""),,get_prop(Data,"dump","")); 
	КонецЕсли;	
	Data = get_prop(РезультатЗапроса,"data", Неопределено);  
	Результат = get_prop(Data,"Result", Неопределено);; 	
	code = 200;	
	Result = Новый Структура;
	Result.Вставить("code",code);
	Result.Вставить("result",Новый Структура("result",Результат));
	Возврат Result;
КонецФункции


//DynamicDirective
Функция CallMethod(MethodName, ПараметрыВызова, context_params)
	Результат = Неопределено;
	ВидТранспорта = ВидТранспорта(context_params);
	Если ВидТранспорта = "ExtSdk2" Тогда  
		Компонента = ОбъектПлагинаExtSdk2();			
		Sbi3Module_ID = Компонента.GetModule("ExtSdk2"); 
		Результат = CallMethodExtSdk2(MethodName, ПараметрыВызова, context_params);
	ИначеЕсли ВидТранспорта = "SabyPluginConnector" Тогда
		Компонента = КомпонентаSABYPluginConnector();			
		Sbi3Module_ID = Компонента.GetModule("ExtSdk2"); 
		Результат = CallMethodSabyPluginConnector(MethodName, ПараметрыВызова, context_params);
	КонецЕсли;
	Возврат Результат;
КонецФункции

//DynamicDirective
Функция AccountListExtSDK2(context_params)
	MethodName = "ExtSdk2.AccountList";
	ПараметрыВызова = Новый Структура;
	res = CallMethod(MethodName, ПараметрыВызова, context_params);
	Возврат res;
КонецФункции      

//DynamicDirective
Функция SwitchAccountExtSDK2(context_params, НомерАккаунта)
	MethodName = "ExtSdk2.SwitchAccount";
	ПараметрыВызова = Новый Структура;
	ПараметрыВызова.Вставить("НомерАккаунта", НомерАккаунта);	
	res = CallMethod(MethodName, ПараметрыВызова, context_params);
	Возврат res;	
КонецФункции

//DynamicDirective
Функция ExecuteActionEx(block_context, context) Экспорт 
	doc1 = get_prop(block_context, "doc1", "");
	MethodName = "ExtSdk2.ExecuteActionEx";
	ПараметрыВызова = Новый Структура;
	ПараметрыВызова.Вставить("Document", doc1);	
	res = CallMethod(MethodName, ПараметрыВызова, context.params);
	res = get_prop(res,"result");	
	res = get_prop(res,"result");
	Возврат res;
КонецФункции	

//DynamicDirective
Процедура ВойтиExtSdk2(context_params, Кэш = Неопределено)
	Call_param = Новый Структура;
	Call_param.Вставить("Login", context_params.login);	
	Call_param.Вставить("Password", context_params.password);
	
	MethodName = "ExtSdk2.AuthByPassword";
	Хост = СтрЗаменить(get_prop(context_params,"api_url",""), "https://","");
	Хост = СтрЗаменить(Хост, "ie-1c","online"); 
	QueryId = Строка(Новый УникальныйИдентификатор);
	
	data_session = CallMethodWithoutAuth(QueryId, MethodName, Call_param, Хост, context_params);
	data_session = get_prop(data_session,"data",Неопределено);	
	session = get_prop(data_session,"Result",Неопределено);	
	context_params.Вставить("session", session );
	context_params.Вставить("session_begin", ТекущаяДата());
	context_params.Вставить("last_token_time", Неопределено);
	НастройкиПодключенияЗаписать(context_params);
КонецПроцедуры 

//DynamicDirective
Функция UploadToSbisDisk(Знач context_params, Знач ДанныеДляЗагрузки) Экспорт
	Возврат ДанныеДляЗагрузки;	
КонецФункции

//DynamicDirective 
Функция LoadDataFromURLToFile(context_params,URL) Экспорт 
		//ПараметрыМетода = get_prop(ПараметрыВыполнения, "params", Неопределено);
	MethodName = "ExtSdk2.LoadDataFromURLToFile";
	ИмяВременногоФайла = ПолучитьИмяВременногоФайла();
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
КонецФункции

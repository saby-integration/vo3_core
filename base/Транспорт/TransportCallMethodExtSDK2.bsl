
//DynamicDirective

Функция ОбработкаРезультатаЗапросаExtSdk2(РезультатЗапроса)
	Возврат РезультатЗапроса;
КонецФункции

//DynamicDirective

Процедура ExtSDK2_get_answer_request(ВидТранспорта)	
	Если ВидТранспорта = "ExtSdk" Тогда 
		РезультатЗапросаExtSdk2(ОбъектПлагинаExtSdk2());
	ИначеЕсли  ВидТранспорта = "SabyPluginConnector" Тогда 
		РезультатЗапросаSabyPluginConnector(КомпонентаSABYPluginConnector());
	Иначе
		Возврат;
	КонецЕсли;
КонецПроцедуры

// Вызывается метод БЛ, в зависимости от вида транспорта
//
// Параметры:
//  MethodName - Строка - имя метода.
//  ПараметрыВызова - Структура - параметры.
//  context_params - Структура - контекст.
//  multithread_mode - Булево - признак мультипоточного выполнения
//	ДопПараметры - Структура - дополнительные параметры
//
// Возвращаемое значение:
//   Структура - "code","result"
//
//DynamicDirective
Функция CallMethod(MethodName, ПараметрыВызова, context_params, multithread_mode = Ложь, ДопПараметры = Неопределено)
	Результат = Неопределено;
	ВидТранспорта = ВидТранспорта(context_params);
	Если ВидТранспорта = "ExtSdk" Тогда
		// BSLLS:UnusedLocalVariable-off Общая переменная модуля
		КомпонентаИнтеграции = ОбъектПлагинаExtSdk2();
		// BSLLS:UnusedLocalVariable-off	
		Результат = CallMethodExtSdk2(MethodName, ПараметрыВызова, context_params, multithread_mode, ДопПараметры);
	ИначеЕсли ВидТранспорта = "SabyPluginConnector" Тогда
		// BSLLS:UnusedLocalVariable-off Общая переменная модуля
		КомпонентаИнтеграции = КомпонентаSABYPluginConnector();				
		// BSLLS:UnusedLocalVariable-off	
		Результат = CallMethodSabyPluginConnector(MethodName, ПараметрыВызова, context_params, multithread_mode, ДопПараметры);
	Иначе
		Возврат Неопределено;
	КонецЕсли;
	Возврат Результат;
КонецФункции


// Вызывает метод ExtSDK2
//
// Параметры:
//  MethodName - Строка - имя метода.
//  ПараметрыВызова - Структура - параметры.
//  context_params - Структура - контекст.
//  multithread_mode - Булево - многопоточный ассинхронный режим.
//	ДопПараметры - Структура - дополнительные параметры
//
// Возвращаемое значение:
//   Структура - "code","result"
//
//DynamicDirective
Функция CallMethodExtSdk2(MethodName, ПараметрыВызова, context_params, multithread_mode = Ложь, ДопПараметры = Неопределено)
	QueryId = Строка(Новый УникальныйИдентификатор); 
	Call_param = local_helper_json_encode(ПараметрыВызова);
	Sbi3Module_ID = ИдентификаторМодуляКомпонентыИнтеграции("ExtSdk2");
	БезАвторизации = get_prop(ДопПараметры, "БезАвторизации");
	Если БезАвторизации = Истина Тогда
		Хост = get_prop(ДопПараметры, "Хост");
		КомпонентаИнтеграции.CallMethodWithoutAuth(QueryId, Sbi3Module_ID, MethodName, Call_param, Хост);	
	Иначе	
		Account_ID = УИДСессии(context_params);
		КомпонентаИнтеграции.CallMethod(QueryId, Sbi3Module_ID, MethodName, Call_param, Account_ID);
	КонецЕсли;
	
	Если multithread_mode = Истина Тогда 
		// BSLLS:DeprecatedCurrentDate-off Используем на клиенте
		Deadline = ТекущаяДата() + get_prop(ПараметрыВызова, "timeout", 60);
		// BSLLS:DeprecatedCurrentDate-on
		dump = Новый Структура;
		dump.Вставить("QueryId", 				QueryId);
		dump.Вставить("Deadline", 				Deadline);
		ВызватьИсключение NewExtExceptionСтрока(, "AsyncRequest", , , dump, "AsyncRequest");	
	КонецЕсли;  

	
	Результат =  РезультатЗапросаExtSdk2(КомпонентаИнтеграции, QueryId); 
	Result = ОбработкаСобытияExtSdk2(Результат);
	local_helper_exec_method_process_responce_error(Result, Неопределено);
	Возврат Result;	
КонецФункции

// Вызывает метод SabyPluginConnector
//
// Параметры:
//  MethodName - Строка - имя метода.
//  ПараметрыВызова - Структура - параметры.
//  context_params - Структура - контекст.
//  multithread_mode - Булево - многопоточный ассинхронный режим.
//	ДопПараметры - Структура - дополнительные параметры
//
// Возвращаемое значение:
//   Структура - "code","result"
//
//DynamicDirective
Функция CallMethodSabyPluginConnector(MethodName, ПараметрыВызова, context_params, multithread_mode = Ложь, ДопПараметры = Неопределено)
	QueryId = Строка(Новый УникальныйИдентификатор); 
	Call_param = encode_xdto_xml(ПараметрыВызова);
	Sbi3Module_ID = ИдентификаторМодуляКомпонентыИнтеграции("ExtSdk2");
	БезАвторизации = get_prop(ДопПараметры, "БезАвторизации");
	Если БезАвторизации = Истина Тогда
		Хост = get_prop(ДопПараметры, "Хост");
		КомпонентаИнтеграции.CallMethodWithoutAuth(Sbi3Module_ID, MethodName, Call_param, Хост, Ложь, "", QueryId);	
	Иначе	
		Account_ID = УИДСессии(context_params);
		КомпонентаИнтеграции.CallMethod(Sbi3Module_ID, MethodName, Call_param, Account_ID, Ложь, "", QueryId);
	КонецЕсли;	
	Если multithread_mode = Истина Тогда 
		// BSLLS:DeprecatedCurrentDate-off Используем на клиенте
		Deadline = ТекущаяДата() + get_prop(ПараметрыВызова, "timeout", 60);
		// BSLLS:DeprecatedCurrentDate-on
		dump = Новый Структура;
		dump.Вставить("QueryId", 				QueryId);
		dump.Вставить("Deadline", 				Deadline);
		ВызватьИсключение NewExtExceptionСтрока(, "AsyncRequest", , , dump, "AsyncRequest");	
	КонецЕсли;    

	Результат =  РезультатЗапросаSabyPluginConnector(КомпонентаИнтеграции, QueryId); 
	Result = ОбработкаСобытияExtSdk2(Результат);
	local_helper_exec_method_process_responce_error(Result, Неопределено);
	Возврат Result;	
КонецФункции


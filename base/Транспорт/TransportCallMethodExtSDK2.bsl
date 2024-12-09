
// Вызывается метод БЛ, в зависимости от вида транспорта
//
// Параметры:
//  MethodName - Строка - имя метода.
//  ПараметрыВызова - Структура - параметры.
//  context_params - Структура - контекст.
//
// Возвращаемое значение:
//   Структура - "code","result"
//
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

// Вызывает метод ExtSDK2
//
// Параметры:
//  MethodName - Строка - имя метода.
//  ПараметрыВызова - Структура - параметры.
//  context_params - Структура - контекст.
//
// Возвращаемое значение:
//   Структура - "code","result"
//
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

// Вызывает метод SabyPluginConnector
//
// Параметры:
//  MethodName - Строка - имя метода.
//  ПараметрыВызова - Структура - параметры.
//  context_params - Структура - контекст.
//
// Возвращаемое значение:
//   Структура - "code","result"
//
//DynamicDirective
Функция CallMethodSabyPluginConnector(MethodName, ПараметрыВызова, context_params)
	QueryId = Строка(Новый УникальныйИдентификатор); 
	Call_param = encode_xdto_xml(ПараметрыВызова);
	Sbi3Module_ID = Компонента.GetModule("ExtSdk2");
	Account_ID = get_prop(context_params,"session","");
	Компонента.CallMethod(Sbi3Module_ID, MethodName, Call_param, Account_ID, Истина, "", QueryId);
	
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

	
	Результат =  РезультатЗапросаSabyPluginConnector(Компонента, QueryId); 
	Result = ОбработкаРезультатаЗапроса(Результат);
	Возврат Result;	
КонецФункции



//DynamicDirective
Функция local_helper_exec_request_sabypluginconnector(request_type, Знач request_url, response_type,
		__kwargs = Неопределено, context_params = Неопределено, Знач НомПереадресации = 0)
	Компонента = КомпонентаSABYPluginConnector();	
	ПараметрыCallMethod = local_helper_exec_request_extsdk2_get_parameters(__kwargs, request_url);
	MethodName = get_prop(ПараметрыCallMethod, "MethodName");
	ПараметрыВызова = get_prop(ПараметрыCallMethod, "ПараметрыВызова");
	Result = CallMethodSabyPluginConnector(MethodName, ПараметрыВызова, context_params);
	Возврат Result;		
КонецФункции		

//DynamicDirective
Функция КомпонентаSABYPluginConnector() Экспорт
	Если Компонента <> Неопределено Тогда
		Возврат Компонента;
	КонецЕсли;
	ПутьКомпоненты = ПолучитьПутьКомпонентыSABYPluginConnector(); 
	ПодключениеВыполнено = ПодключитьВнешнююКомпоненту(ПутьКомпоненты, "Community", ТипВнешнейКомпоненты.Native); 
	Компонента = Новый("AddIn.Community.SabyPluginConnector");
	Если Компонента = Неопределено Тогда
		ВызватьИсключение "Не удалось создать объект компоненты";
	КонецЕсли;
	Возврат Компонента;

КонецФункции

Функция ПолучитьПутьКомпонентыSABYPluginConnector()
	МакетSABYPluginConnector = Метаданные.НайтиПоПолномуИмени("Обработка.SABY.Макет.SABYPluginConnector");	
	Если МакетSABYPluginConnector = Неопределено Тогда 
		ПутьКомпоненты = ПутьИзВнешнейОбработкиSABYPluginConnector();
	Иначе
		ПутьКомпоненты = "Обработка.SABY.Макет.SABYPluginConnector";		
	КонецЕсли;	
	Возврат ПутьКомпоненты;	
КонецФункции

Функция ПутьИзВнешнейОбработкиSABYPluginConnector()
	СправочникДополнительныеОтчетыИОбработки = Метаданные.Справочники.Найти("ДополнительныеОтчетыИОбработки");
	ДополнительнаяОбработка = Неопределено;
	МодульДополнительныеОтчетыИОбработки = Неопределено;
	Если СправочникДополнительныеОтчетыИОбработки <> Неопределено Тогда
		МодульДополнительныеОтчетыИОбработки = ОбщийМодульКонфигурации("ДополнительныеОтчетыИОбработки");
		ДополнительнаяОбработка = Справочники["ДополнительныеОтчетыИОбработки"].НайтиПоНаименованию("SabyPluginConnector");
	КонецЕсли;	
	Если ЗначениеЗаполнено(ДополнительнаяОбработка) Тогда   
		ИмяОбработки = МодульДополнительныеОтчетыИОбработки.ПодключитьВнешнююОбработку(ДополнительнаяОбработка); 
		ОбъектОбработкиSabyPluginConnector = 	ВнешниеОбработки.Создать(ИмяОбработки);
		макет = ОбъектОбработкиSabyPluginConnector.ПолучитьМакетSABYPluginConnector();
		ПутьКомпоненты = ПоместитьВоВременноеХранилище(макет, Новый УникальныйИдентификатор);
	Иначе
		ВызватьИсключение "Не удалось найти компоненту. Установите внешнюю обработку SabyPluginConnector.epf";
	КонецЕсли;

	Возврат ПутьКомпоненты;
КонецФункции

//DynamicDirective
Функция CallMethodWithoutAuthSabyPluginConnector(QueryId, Sbi3Module_ID, MethodName, Call_param, Хост)
	Call_param = encode_xdto_xml(Call_param);
	Возврат Компонента.CallMethodWithoutAuth(Sbi3Module_ID, MethodName, Call_param, Хост, Истина, "", QueryId);
КонецФункции

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

//DynamicDirective
Функция РезультатЗапросаSabyPluginConnector(ОбъектПлагина, QueryId, request_type = "") 
	ОтветНеПолучен = Истина;
	СчетчикЦиклов = 1;	
	Пока ОтветНеПолучен Цикл	 
		Если СчетчикЦиклов > 1800 Тогда
			ВызватьИсключение "Долгое выполнение запроса "+request_type;	
		КонецЕсли;
		Ответы = decode_xml_xdto(ОбъектПлагина.ReadEvents());
		Ответы = get_prop(Ответы,"Response", Новый Массив);
		Для Каждого Ответ Из Ответы Цикл 
			Если  get_prop(Ответ,"QueryId",Неопределено) = QueryId Тогда 
				Возврат Ответ;
			КонецЕсли;	
		КонецЦикла;  
		ОбъектПлагина.Sleep(300);
		СчетчикЦиклов = СчетчикЦиклов + 1;
	КонецЦикла;
	Возврат Неопределено; 
КонецФункции


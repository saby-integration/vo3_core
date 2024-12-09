
// Вызывается метод через транспорт SabyPluginConnector
//
// Параметры:
//  request_type - Строка - тип запроса.
//  request_url - Строка - ссылка.
//  response_type - Строка - тип ответа.
//  __kwargs - Структура - параметры.
//  context_params - Структура - контекст.
//  НомПереадресации - Число.
//
// Возвращаемое значение:
//   Структура - "code","result"
//
//DynamicDirective
Функция local_helper_exec_request_sabypluginconnector(request_type, Знач request_url, response_type,
		__kwargs = Неопределено, context_params = Неопределено, Знач НомПереадресации = 0)
	ПараметрыCallMethod = local_helper_exec_request_extsdk2_get_parameters(__kwargs, request_url);
	MethodName = get_prop(ПараметрыCallMethod, "MethodName");
	ПараметрыВызова = get_prop(ПараметрыCallMethod, "ПараметрыВызова");
	Result = CallMethod(MethodName, ПараметрыВызова, context_params);
	Возврат Result;		
КонецФункции		

// Возвращает компоненту SabyPluginConnector
//
// Возвращаемое значение:
//   Произвольный - компонента
//
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
		МодульОбъекта = МодульОбъекта();
		ПутьКомпоненты = МодульОбъекта.АдресНативнойКомпонентыИзВнешнейОбработки("SabyPluginConnector");
	Иначе
		ПутьКомпоненты = "Обработка.SABY.Макет.SABYPluginConnector";		
	КонецЕсли;	
	Возврат ПутьКомпоненты;	
КонецФункции

// Вызывается метод через транспорт SabyPluginConnector без аутентификации
//
// Параметры:
//  QueryId - Произвольный - идентификатор запроса.
//  Sbi3Module_ID - Произвольный - ид модуля.
//  MethodName - Строка - имя метода.
//  Call_param - Произвольный - параметры.
//  Хост - Произвольный - хост.
//
// Возвращаемое значение:
//   Произвольный - "code","result"
//
//DynamicDirective
Функция CallMethodWithoutAuthSabyPluginConnector(QueryId, Sbi3Module_ID, MethodName, Call_param, Хост)
	Call_param = encode_xdto_xml(Call_param);
	Возврат Компонента.CallMethodWithoutAuth(Sbi3Module_ID, MethodName, Call_param, Хост, Истина, "", QueryId);
КонецФункции

// Возвращает результат запроса через транспорт SabyPluginConnector
//
// Параметры:
//  ОбъектПлагина - Произвольный - объект плагина.
//  QueryId - Произвольный - идентификатор запроса.
//  request_type - Строка - тип запроса.
//
// Возвращаемое значение:
//   Произвольный - ответ
//
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


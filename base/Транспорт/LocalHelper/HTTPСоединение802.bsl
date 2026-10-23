
// BSLLS:CognitiveComplexity-off

// Выполнить запрос через HTTP-соединение
//
// Параметры:
//  request_type - Строка - тип запроса.
//  request_url - Строка - ссылка.
//  response_type - Строка - тип ответа.
//  __kwargs - Структура - параметры.
//  context_params - Структура - Контекст.
//  НомПереадресации - Число - номер переадресации.
//
// Возвращаемое значение:
//  Структура - "code, result"
//
//DynamicDirective
Функция local_helper_exec_request_HTTPСоединение(request_type, Знач request_url, response_type,
		__kwargs = Неопределено, context_params = Неопределено, Знач НомПереадресации = 0) Экспорт
	Перем ProxyParam, headers;

	Адрес = РазобратьСтрокуУРЛ(request_url);
		
	kwargs = __kwargs;
	Если kwargs = Неопределено Тогда
		kwargs = Новый Структура;
	КонецЕсли;
	Если ГлобальныйКэш = Неопределено Тогда
		ГлобальныйКэшПрочитать();
	КонецЕсли;
	// BSLLS:UnusedLocalVariable-off
	Если Адрес.scheme = "https" Тогда
		Если ГлобальныйКэш.СовместимостьМетодов.HTTPСоединение.OpenSSL Тогда
			ssl = Вычислить("Новый ЗащищенноеСоединениеOpenSSL()");
		Иначе
			ssl = Истина;
		КонецЕсли;
	КонецЕсли;
	// BSLLS:UnusedLocalVariable-on
	ProxyParam = get_prop(context_params, "Proxy");
	ИспользоватьАутентификациюОС = Ложь;
	Если Proxy = Неопределено и ProxyParam <> Неопределено Тогда
		Proxy = Новый ИнтернетПрокси;
		ИспользоватьАутентификациюОС = get_prop(ProxyParam, "UseOSAuthentication", Ложь);
		Если ИспользоватьАутентификациюОС Тогда
			ИспользоватьАутентификациюОС = get_prop(ProxyParam, "ИспользоватьАутентификациюОС", Ложь);
			Proxy.Установить(ProxyParam.Protocol, ProxyParam.Server, Число(ProxyParam.Port), ProxyParam.User, ProxyParam.Password, ИспользоватьАутентификациюОС);
		Иначе
			Proxy.Установить(ProxyParam.Protocol, ProxyParam.Server, Число(ProxyParam.Port), ProxyParam.User, ProxyParam.Password);
		КонецЕсли;
	КонецЕсли;
	
	headers = get_prop(kwargs, "headers", Новый Соответствие);
	
	Если ГлобальныйКэш <> Неопределено И НЕ ГлобальныйКэш.СовместимостьМетодов.HTTPСоединение.ФункцияПолучить Тогда
		Возврат local_helper_exec_request_HTTPСоединение82(kwargs, Адрес, ssl, headers);
	КонецЕсли;
	
	Попытка
		Если ИспользоватьАутентификациюОС Тогда
			http_connection = Вычислить("Новый HTTPСоединение(Адрес.host, Адрес.port,,,Proxy,180,ssl,ИспользоватьАутентификациюОС)");
		Иначе
			http_connection = Вычислить("Новый HTTPСоединение(Адрес.host, Адрес.port,,,Proxy,180,ssl)");
		КонецЕсли;
		http_request	= Вычислить("Новый HTTPЗапрос(Адрес.resource, headers)");
		Если request_type = "post" Тогда
			http_request.УстановитьТелоИзСтроки(kwargs.data, "UTF-8", Вычислить("ИспользованиеByteOrderMark.Авто"));
		КонецЕсли;	
		Если request_type = "post_binary" Тогда
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
// BSLLS:CognitiveComplexity-on

// Выполнить запрос через HTTP-соединение на платформе 8.2
//
// Параметры:
//  kwargs - Структура - параметры.
//  address - Структура - параметры УРЛ.
//  ssl - Произвольный - ЗащищенноеСоединениеOpenSSL.
//  headers - Структура - заголовки.
//
// Возвращаемое значение:
//  Структура - "code, result"
//
//DynamicDirective
Функция local_helper_exec_request_HTTPСоединение82(kwargs, address, ssl, headers) Экспорт
		
	Результат = Новый Структура("code, result", 200);
	
	Попытка
		//Формируем параметры к отправке
		ИмяФайлаЗапрос = ПолучитьИмяВременногоФайла("txt");
		ИмяФайлаОтвет = ПолучитьИмяВременногоФайла("txt");
		POSTПараметры = Новый ЗаписьТекста(ИмяФайлаЗапрос, КодировкаТекста.UTF8,, Истина, Символы.ПС);  
		POSTПараметры.Записать(kwargs.data);
		POSTПараметры.Закрыть();			
		Соединение = Новый HTTPСоединение(address.host, address.port, , , Proxy, 180, ssl);
		Соединение.ОтправитьДляОбработки(ИмяФайлаЗапрос, address.resource, ИмяФайлаОтвет, headers);
		//Читаем ответ
		ЧтениеОтвета = Новый ЧтениеТекста(ИмяФайлаОтвет, КодировкаТекста.UTF8, Символы.ПС);
		Ответ = ЧтениеОтвета.Прочитать();
		ЧтениеОтвета.Закрыть();
		// BSLLS:UsingSynchronousCalls-off - для совместимости со старыми платформами
		УдалитьФайлы(ИмяФайлаЗапрос);
		УдалитьФайлы(ИмяФайлаОтвет);
		// BSLLS:UsingSynchronousCalls-on
		Результат.result = Ответ;
	Исключение
		ИнфОбОшибке = ИнформацияОбОшибке();
		ВызватьИсключение NewExtExceptionСтрока(ИнфОбОшибке, "Ошибка создания HTTP запроса");
	КонецПопытки;
	
	Возврат Результат;
	
КонецФункции



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
	ИспользоватьАутентификациюОС = Ложь;
	Если Proxy = Неопределено и ProxyParam <> Неопределено Тогда
		ИспользоватьАутентификациюОС = get_prop(ProxyParam, "ИспользоватьАутентификациюОС", Ложь);
		Proxy = Новый ИнтернетПрокси;
		Proxy.Установить(ProxyParam.Protocol, ProxyParam.Server, Число(ProxyParam.Port), ProxyParam.User, ProxyParam.Password, ИспользоватьАутентификациюОС);
	КонецЕсли;
	
	headers = get_prop(kwargs, "headers", Новый Соответствие);
	
	Попытка
		http_connection = Новый HTTPСоединение(Адрес.host, Адрес.port,,,Proxy,180,ssl,ИспользоватьАутентификациюОС);
		http_request	= Новый HTTPЗапрос(Адрес.resource, headers);
		Если request_type = "post" Тогда
			#Если Не ВебКлиент Тогда
			http_request.УстановитьТелоИзСтроки(kwargs.data, "UTF-8", ИспользованиеByteOrderMark.Авто);
			#КонецЕсли
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

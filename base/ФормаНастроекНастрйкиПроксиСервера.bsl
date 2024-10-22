
&НаКлиенте
Процедура ПроверитьПодключение(Команда)
	context_params	= НастройкиПодключенияПрочитатьНаСервере();
	Если context_params = Неопределено Тогда
		context_params =Новый Структура();
	КонецЕсли;
	link			= api_url + "/!ping/";
	context_params.Вставить("password",	password);
	context_params.Вставить("login",	login);
	context_params.Вставить("api_url",	api_url);

	context_params.Удалить("Proxy");
	Если Не ПустаяСтрока(ProxyProtocol) И Не ПустаяСтрока(ProxyServer) И (ProxyPort > 0 И ProxyPort <= 65535) Тогда
		Proxy = Новый Структура;
		Proxy.Вставить("Protocol", ProxyProtocol);
		Proxy.Вставить("Server", ProxyServer);
		Proxy.Вставить("Port", ProxyPort);
		Proxy.Вставить("User", ProxyLogin);
		Proxy.Вставить("Password", ProxyPassword);
		Proxy.Вставить("ИспользоватьАутентификациюОС", ИспользоватьАутентификациюОС);
		context_params.Вставить("Proxy", Proxy);
	КонецЕсли;
	
	Попытка
		КартинкаУспешно = БиблиотекаКартинок[ЛокализацияНазваниеПродукта()+"_Успешно32"];
	Исключение
		КартинкаУспешно = Неопределено;
	КонецПопытки;
	Если КартинкаУспешно = Неопределено Тогда
		Попытка
			КартинкаУспешно = БиблиотекаКартинок.Успешно32;
		Исключение
			КартинкаУспешно = Новый Картинка; // Если нет нужных картинок, то пустая
		КонецПопытки;
	КонецЕсли;
	Попытка
		КартинкаОшибка = БиблиотекаКартинок[ЛокализацияНазваниеПродукта()+"_Ошибка32"];
	Исключение
		КартинкаОшибка = Неопределено;
	КонецПопытки;
	Если КартинкаОшибка = Неопределено Тогда
		Попытка
			КартинкаОшибка = БиблиотекаКартинок.Ошибка32;
		Исключение
			КартинкаОшибка = Новый Картинка; // Если нет нужных картинок, то пустая
		КонецПопытки;
	КонецЕсли;
	
	ОтветСервера = Неопределено;
	Попытка
		ОтветСервера = ПроверитьПодключениеНаСервере(context_params, link);
	Исключение
		ИнфОбОшибке = ИнформацияОбОшибке();
		СтруктураОшибки = ExtExceptionAnalyse(ИнфОбОшибке);
		ПоказатьОповещениеПользователя(
			"Ошибка",,СтруктураОшибки.message,
			КартинкаОшибка,
			СтатусОповещенияПользователя.Важное);
		Возврат;
	КонецПопытки;

	Если ОтветСервера <> Неопределено Тогда
		// Обработываетя корень домена, т.ч. ни каких ошибок быть не может
		// только 307, редирект на авторизацию
		Если ОтветСервера.code = 200 Тогда
			ПоказатьОповещениеПользователя(
				"Проверка сервисов",,"Проверка доступа к "+ЛокализацияНазваниеПродукта()+" прошла успешно.",
				КартинкаУспешно,
				СтатусОповещенияПользователя.Важное);
		Иначе
			ПоказатьОповещениеПользователя(
				"Проверка сервисов",,"Проверка доступа к "+ЛокализацияНазваниеПродукта()+" завершилась с ошибкой. Error code - " + Формат(ОтветСервера.code),
				КартинкаОшибка,
				СтатусОповещенияПользователя.Важное);
		КонецЕсли;
	КонецЕсли;
КонецПроцедуры

&НаСервере
Функция НастройкиПодключенияПрочитатьНаСервере()
	Модуль = ПолучитьМодульОбъекта();
	context_params = Модуль.НастройкиПодключенияПрочитать();
	Возврат context_params;
КонецФункции

&НаСервере
Функция ПроверитьПодключениеНаСервере(context_params = Неопределено, link)
	Модуль = ПолучитьМодульОбъекта();
	Если context_params = Неопределено Тогда
		context_params = Модуль.НастройкиПодключенияПрочитать();
	КонецЕсли;
	response = Модуль.local_helper_exec_request("get", link, "text", Неопределено, context_params);
	Возврат response;
КонецФункции

&НаСервере
Процедура ПеречитатьНастройкиПроксиСервераНаСервере()
	Модуль	= ПолучитьМодульОбъекта();
	context_params	= Модуль.НастройкиПодключенияПрочитать();
	proxy			= get_prop(context_params, "Proxy");
	ProxyProtocol	= get_prop(proxy, "Protocol", "");
	ProxyServer		= get_prop(proxy, "Server", "");
	ProxyPort		= get_prop(proxy, "Port", 0);
	ProxyLogin		= get_prop(proxy, "User", "");
	ProxyPassword	= get_prop(proxy, "Password", "");
	ИспользоватьАутентификациюОС = get_prop(proxy, "ИспользоватьАутентификациюОС", Ложь);
КонецПроцедуры

&НаКлиенте
Процедура ПрочитатьНастройкиПроксиСервера(Команда)
	ПеречитатьНастройкиПроксиСервераНаСервере();
КонецПроцедуры


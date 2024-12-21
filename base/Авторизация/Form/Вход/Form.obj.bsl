&НаКлиенте
Перем ТранспортИнтеграции, BlocklyExecutor  Экспорт;

&НаКлиенте
Процедура ОбновитьЗаголовок()
	ЭлементыФормочки = ПолучитьЭлементыФормы();
	ЭтаФорма.Заголовок = "Вход в " + ЭлементыФормочки.Сервер.СписокВыбора.НайтиПоЗначению(api_url);
КонецПроцедуры

&НаСервере
Процедура ПрочитатьНастройки() 
	Модуль = МодульОбъекта();
	context_param = Модуль.НастройкиПодключенияПрочитать();
	
	Если context_param <> Неопределено Тогда
		// Заполним элементы формы данными из настроек
		context_param.Свойство("password", password);
		context_param.Свойство("login", login);
		context_param.Свойство("api_url", api_url);
		context_param.Свойство("ConnectionId", ConnectionId);
		
		proxy			= get_prop(context_param, "Proxy");
		ProxyProtocol	= get_prop(proxy, "Protocol", "");
		ProxyServer		= get_prop(proxy, "Server", "");
		ProxyPort		= get_prop(proxy, "Port", 0);
		ProxyLogin		= get_prop(proxy, "User", "");
		ProxyPassword	= get_prop(proxy, "Password", "");
		ИспользоватьАутентификациюОС	= get_prop(proxy, "ИспользоватьАутентификациюОС", Ложь);
	Иначе
		context_param = Новый Структура();
	КонецЕсли;
	
	ЭлементыФормочки = ПолучитьЭлементыФормыНаСервере();
	Если ЭлементыФормочки.Сервер.СписокВыбора.НайтиПоЗначению(api_url) = Неопределено Тогда
		api_url = ЭлементыФормочки.Сервер.СписокВыбора.Получить(0).Значение;
	КонецЕсли;
КонецПроцедуры

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	Модуль = МодульОбъекта();
	context_param = Модуль.НастройкиПодключенияПрочитать();
	
	Если context_param <> Неопределено Тогда
		// Сброс сесии при открытии формы входа. 
		// т.к. текущая форма открывается не только с формы настроек
		context_param.Вставить("session", Неопределено);
		context_param.Вставить("password", Неопределено);
	КонецЕсли;
	Модуль.НастройкиПодключенияЗаписать(context_param);
	
	ТранспортSabyHttpsClient = (Модуль.ВидТранспорта(context_param) = "SabyHttpsClient");
	ЭлементыФормочки = ПолучитьЭлементыФормыНаСервере();
	ЭлементыФормочки.Сервер.СписокВыбора.Очистить();
	ЭтаФорма.Заголовок = "Вход в "+ЛокализацияНазваниеПродукта();
	ЭлементыФормочки.Предупреждение.Заголовок =  СтрЗаменить(ЭлементыФормочки.Предупреждение.Заголовок, "%PRODUCTNAME%", ЛокализацияНазваниеПродукта());
	Для Каждого ЗаписьСервер Из Модуль.СписокСерверовSaby(ТранспортSabyHttpsClient) Цикл
		ЭлементыФормочки.Сервер.СписокВыбора.Добавить("https://" + ЗаписьСервер.Значение, ЗаписьСервер.Представление);
	КонецЦикла;
КонецПроцедуры

&НаКлиенте
Процедура ПриОткрытии(Отказ)
	ТранспортИнтеграции = ПолучитьФормуТранспорта(context_param);
	BlocklyExecutor = ПолучитьФормуBlockly();
	
	АвторизацияУспешна	= Ложь;
	ПрочитатьНастройки();
	ОбновитьЗаголовок();
	ЭлементыФормочки = ПолучитьЭлементыФормы();
	ЭлементыФормочки.Ошибка.Заголовок = "";
КонецПроцедуры

&НаКлиенте
Процедура ОтправитьКодАвторизации(ДополнительныеПараметры)
	// Первая стадия двухфакторной авторизации
	ПараметрыМетода	= Новый Структура("Идентификатор", ДополнительныеПараметры.Идентификатор);
	res = ТранспортИнтеграции.local_helper_exec_method(context_param, ДополнительныеПараметры.МетодОтправкиКодаПодтверждения, ПараметрыМетода,,, context_param.api_url + "/auth/service/");
КонецПроцедуры

&НаКлиенте
Процедура ВходПроверкаКодаСМС(ДополнительныеПараметры, Код)
	// Вторая стадия двухфакторной авторизации
	ПараметрыМетода	= Новый Структура("Идентификатор, Код", ДополнительныеПараметры.Идентификатор, Код);
	res = ТранспортИнтеграции.local_helper_exec_method(context_param, ДополнительныеПараметры.МетодПроверкиКодаИсключения, ПараметрыМетода,,, context_param.api_url + "/auth/service/");
	
	context_param.Вставить("session", res["result"]);
	context_param.Вставить("session_begin", ТекущаяДата());
	context_param.Вставить("last_token_time", Неопределено);
	ЗаписатьНастройкиНаСервере();

	ТранспортИнтеграции.ПослеАутентификации(context_param);
	ТранспортИнтеграции.ПолучитьСтатусВерсии(Истина);
КонецПроцедуры

&НаКлиенте
Процедура СменитьАккаунтНажатие()
	ЭлементыФормочки = ПолучитьЭлементыФормы();
	ЗакрытьСПередачейПараметров = Ложь;
	СменитьАккаунтВВыпадающемСписке(ЭлементыФормочки.Логин, Истина);
КонецПроцедуры

&НаКлиенте
Процедура ОбработатьОшибкуАвторизации(ОшибкаСтруктура) 
	ЭлементыФормочки = ПолучитьЭлементыФормы();
	ExtExceptionToJournal(ОшибкаСтруктура);
	
	ДеталиОшибки = get_prop(ОшибкаСтруктура, "detail");
	Если ТипЗнч(ДеталиОшибки) = Тип("Соответствие") Тогда
		Если	(Врег(ДеталиОшибки["classid"]) = "{00000000-0000-0000-0000-1FA000001002}")
			И ТипЗнч(ДеталиОшибки["addinfo"]) <> Неопределено Тогда
			ПарметрыФормыВводаСМС = Новый Структура;
			Для Каждого КлЗнч Из ДеталиОшибки["addinfo"] Цикл
				ПарметрыФормыВводаСМС.Вставить(КлЗнч.Ключ, КлЗнч.Значение);
			КонецЦикла;
			ОшибкаСтруктура.Вставить("detail", "");
			ОшибкаСтруктура.Вставить("message", "");
			Попытка
				context_param.Вставить("session", ПарметрыФормыВводаСМС.ИдентификаторСессии);
				ОтправитьКодАвторизации(ПарметрыФормыВводаСМС);
				
				ПодсказкаЧ1 = "";
				ПарметрыФормыВводаСМС.Свойство("Сообщение", ПодсказкаЧ1);
				ПодсказкаЧ2 = "";
				ПарметрыФормыВводаСМС.Свойство("Телефон", ПодсказкаЧ2);
				ЭлементыФормочки.ИнформацияПользователю.Заголовок = ПодсказкаЧ1 + " " + ПодсказкаЧ2;
				
				ЭлементыФормочки.ГруппаВводаЛогинаИПароля.Видимость			= Ложь;
				ЭлементыФормочки.ПодтверждениеКода.Видимость				= Истина;
				ЭлементыФормочки.ОтменитьПодтверждение.КнопкаПоУмолчанию	= Истина;
			Исключение
				context_param.Вставить("session", "");
				ИнфОбОшибке = ИнформацияОбОшибке();
				ОшибкаСтруктура = ExtExceptionAnalyse(ИнфОбОшибке);
			КонецПопытки;
		КонецЕсли;
	ИначеЕсли ТипЗнч(ДеталиОшибки) = Тип("Строка") И Найти(ДеталиОшибки, "Система не поддерживается") Тогда
		ВыйтиНаСервере();
		ПоказатьОповещениеПользователя(
		"Ошибка",,
		"Система не поддерживается",
		БиблиотекаКартинок["Ошибка32"],
		СтатусОповещенияПользователя.Важное,
		Новый УникальныйИдентификатор
		);
		Оповестить("SabySignOut");
		Закрыть(Неопределено);
	КонецЕсли;
	ЭлементыФормочки.Ошибка.Заголовок = ExtExceptionToMessage(ОшибкаСтруктура);
КонецПроцедуры	

&НаКлиенте
Процедура Войти(Команда)
	АвторизацияУспешна = Ложь;
	ЭлементыФормочки = ПолучитьЭлементыФормы();
	Если НЕ ЗначениеЗаполнено(login) ИЛИ НЕ ЗначениеЗаполнено(password) Тогда
		ЭлементыФормочки.Ошибка.Заголовок = "Не указан логин или пароль";
		Возврат;
	КонецЕсли;
	context_param.Вставить("login", login);
	context_param.Вставить("password", password);
	context_param.Вставить("api_url", api_url);
	context_param.Вставить("ConnectionId", ConnectionId);
	context_param.Удалить("Proxy");
	Если Не ПустаяСтрока(ProxyProtocol) И Не ПустаяСтрока(ProxyServer) И (ProxyPort > 0 И ProxyPort <= 65535) Тогда
		Proxy = Новый Структура;
		Proxy.Вставить("Protocol", ProxyProtocol);
		Proxy.Вставить("Server", ProxyServer);
		Proxy.Вставить("Port", ProxyPort);
		Proxy.Вставить("User", ProxyLogin);
		Proxy.Вставить("Password", ProxyPassword);
		Proxy.Вставить("ИспользоватьАутентификациюОС", ИспользоватьАутентификациюОС);
		context_param.Вставить("Proxy", Proxy);
	КонецЕсли;
	Попытка
		ТранспортИнтеграции.ВойтиТранспорт(context_param);
		BlocklyExecutor.ПослеАутентификации(context_param);
		BlocklyExecutor.ПолучитьСтатусВерсии(Истина);
		АвторизацияУспешна = Истина;
		СменитьАккаунтНажатие();
	Исключение
		ИнфОбОшибке = ИнформацияОбОшибке();
		ОшибкаСтруктура = ExtExceptionAnalyse(ИнфОбОшибке);
		ОбработатьОшибкуАвторизации(ОшибкаСтруктура);
	КонецПопытки;
КонецПроцедуры

&НаКлиенте
Процедура ВойтиЧерезБраузерЗавершение(Результат, Парметры) Экспорт
	Если Результат = Неопределено Тогда
		Возврат;
	КонецЕсли;
	ВойтиЧерезБраузерЗавершениеПеречитптьНастройки();
	СменитьАккаунтНажатие();
КонецПроцедуры

&НаСервере
Процедура ВойтиЧерезБраузерЗавершениеПеречитптьНастройки()
	Модуль = МодульОбъекта();
	context_param = Модуль.НастройкиПодключенияПрочитать();
КонецПроцедуры

&НаКлиенте
Процедура ВойтиЧерезБраузер(Команда)
	АдресСтраницы = api_url+"/auth/";

	context_param.Вставить("login", login);
	context_param.Вставить("password", password);
	context_param.Вставить("api_url", api_url);
	context_param.Вставить("ConnectionId", ConnectionId);
	context_param.Удалить("Proxy");
	ПараметрыФормы = Новый Структура();
	ПараметрыФормы.Вставить("Заголовок", "Авторизация");
	ПараметрыФормы.Вставить("АвтоЗакрытиеФормы", Истина);
	ПараметрыФормы.Вставить("АдресСтраницы", АдресСтраницы);
	ПараметрыФормы.Вставить("context_param", context_param);

	ОповещениеОЗарытитииФормыАвторизацииВЕБ = Новый ОписаниеОповещения("ВойтиЧерезБраузерЗавершение", ЭтаФорма, ПараметрыФормы);
	ОткрытьФормуОбработки("Browser", ПараметрыФормы,,"Авторизация", ОповещениеОЗарытитииФормыАвторизацииВЕБ,РежимОткрытияОкнаФормы.БлокироватьОкноВладельца);
КонецПроцедуры

&НаКлиенте
Процедура ПодтвердитьКод(Команда)
	ЭлементыФормочки = ПолучитьЭлементыФормы();
	Попытка
		ВходПроверкаКодаСМС(ПарметрыФормыВводаСМС, code_sms);
		code_sms = "";
		ЭлементыФормочки.ГруппаВводаЛогинаИПароля.Видимость	= Истина;
		ЭлементыФормочки.ПодтверждениеКода.Видимость		= Ложь;
		ЭлементыФормочки.Войти.КнопкаПоУмолчанию			= Истина;
		СменитьАккаунтНажатие();
	Исключение
		code_sms = "";
		ИнфОбОшибке = ИнформацияОбОшибке();
		ОшибкаСтруктура = ExtExceptionAnalyse(ИнфОбОшибке);
		ЭлементыФормочки.Ошибка.Заголовок = ExtExceptionToMessage(ОшибкаСтруктура);
	КонецПопытки;
КонецПроцедуры

&НаКлиенте
Процедура ОтменитьПодтверждение(Команда)
	code_sms = "";
	ПарметрыФормыВводаСМС = Неопределено;
	ЭлементыФормочки = ПолучитьЭлементыФормы();
	ЭлементыФормочки.ГруппаВводаЛогинаИПароля.Видимость	= Истина;
	ЭлементыФормочки.ПодтверждениеКода.Видимость		= Ложь;
	ЭлементыФормочки.Войти.КнопкаПоУмолчанию			= Истина;
КонецПроцедуры

&НаКлиенте
Процедура СерверПриИзменении(Элемент)
	ОбновитьЗаголовок();
КонецПроцедуры

#Область include_core_base_Настройки_ЗаписатьНастройки
#КонецОбласти

#Область include_core_base_Helpers_НастройкиПодключенияНаСервере
#КонецОбласти

#Область include_core_base_Helpers_Картинки
#КонецОбласти

#Область include_core_base_Авторизация_Выход
#КонецОбласти

&НаКлиенте
Процедура ПолучитьАктуальностьВерсии()
// Заглушка
КонецПроцедуры

&НаКлиенте
Процедура УстановитьЗаголовокПодсказкуКнопкиВыйти()
// Заглушка
КонецПроцедуры

#Область include_core_base_Авторизация_СменаАккаунта
#КонецОбласти

#Область include_core_base_ОсобенностиПлатформы_РаботаСЭлементамиФормы
#КонецОбласти

#Область include_core_base_Helpers_FormGetters
#КонецОбласти

#Область include_core_base_ФормаНастроекНастрйкиПроксиСервера
#КонецОбласти

#Область include_core_base_ФормаНастроекНастрйкиПроксиСервераВзятьПроксиИз1С
#КонецОбласти

#Область include_core_base_Авторизация_Form_Вход_ОсобенностиПриложения
#КонецОбласти


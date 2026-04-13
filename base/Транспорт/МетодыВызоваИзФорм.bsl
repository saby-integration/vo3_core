
#Область include_core_base_Авторизация_ПоТокену 
#КонецОбласти

#Область include_core_base_Авторизация_ПоСертификату 
#КонецОбласти

// Вход, в зависимости от вида транспорта
//
// Параметры:
//  context_params - Структура - контекст.
//  Кэш - Структура - Кэш.
//
//DynamicDirective
Процедура ВойтиТранспорт(context_params, Кэш = Неопределено) Экспорт
	ВидТранспорта = ВидТранспорта(context_params);
	Если ВидТранспорта = "ExtSdk2" Или ВидТранспорта = "SabyPluginConnector"  Тогда 
		ВойтиExtSdk2(context_params, Кэш);
	Иначе
		ВойтиAPI(context_params);
	КонецЕсли;	
КонецПроцедуры 

//DynamicDirective

Процедура ВойтиAPI(context_params) 
	МассивСтатистики = Новый Массив;
	НаименованиеДействия = "Auth";
	AuthType = get_prop(context_params, "AuthType", "Login"); 
	Если AuthType = "Login" Тогда
		session = local_helper_auth_by_login(context_params, Неопределено );
		КонтекстДействия = "Password";
	ИначеЕсли AuthType = "Certificate" Тогда   
		session = local_helper_auth_by_certificate(context_params); 
		КонтекстДействия = "Certificate";
	ИначеЕсли AuthType = "User1C" Тогда
		result = local_helper_auth_by_token(context_params);
		session = result.Получить("result");
		КонтекстДействия = "ExternalUser";
	Иначе
		ВызватьИсключение NewExtExceptionСтрока(,"Указан неизвестный вид авторизации", , , ,"Unauthorized"); 
	КонецЕсли;	
	СтруктураСессии = Новый Структура;
	СтруктураСессии.Вставить("session", session);
	// BSLLS:DeprecatedCurrentDate-off
	СтруктураСессии.Вставить("session_begin", ТекущаяДата());
	// BSLLS:DeprecatedCurrentDate-on
	ЗаписатьСессию(context_params, СтруктураСессии);
	НастройкиПодключенияЗаписать(context_params);

	ЭлементСтатистики	= local_helper_element_action(НаименованиеДействия, КонтекстДействия, Новый Структура(), 1);
	МассивСтатистики.Добавить(ЭлементСтатистики);
	local_helper_register_actions(context_params, МассивСтатистики);
КонецПроцедуры


// Возвращает список аккаунтов
//
// Возвращаемое значение:
//   СписокЗначений - список номеров аккаунтов
//
//DynamicDirective
Функция ПолучитьСписокАккаунтов() Экспорт
	context_params = НастройкиПодключенияПрочитать();
	ВидТранспорта = ВидТранспорта(context_params);
	Если ВидТранспорта = "ExtSdk2" Или ВидТранспорта = "SabyPluginConnector"  Тогда 
		Результат = AccountListExtSDK2(context_params); 
	Иначе     
		Результат = local_helper_get_accoutslist(context_params);	
	КонецЕсли;	
	СписокАккаунтов	= Новый СписокЗначений;
	Если ТипЗнч(Результат) = Тип("Массив") Тогда
		Для Каждого ЭлементАккаунт Из Результат Цикл
			НазваниеАккаунта = get_prop(ЭлементАккаунт, "НазваниеАккаунта");
			Если Не (НазваниеАккаунта = "Физики" Или НазваниеАккаунта = "Личный аккаунт") Тогда
				СписокАккаунтов.Добавить(get_prop(ЭлементАккаунт, "НомерАккаунта"),
					НазваниеАккаунта); 
			КонецЕсли;		
		КонецЦикла;
	КонецЕсли;
	Возврат СписокАккаунтов;
КонецФункции

// Переключает аккаунт
//
// Параметры:
//  НомерАккаунта - Строка - нмоер аккаунта.
//
// Возвращаемое значение:
//   Строка - идентификатор сессии
//
//DynamicDirective
Функция ПереключитьАккаунт(НомерАккаунта) Экспорт
	context_params = НастройкиПодключенияПрочитать();
	ВидТранспорта = ВидТранспорта(context_params);
	Если ВидТранспорта = "ExtSdk2" Или ВидТранспорта = "SabyPluginConnector"  Тогда 
		Результат = SwitchAccountExtSDK2(context_params, НомерАккаунта); 
	Иначе     
		Результат = local_helper_switch_account(context_params, НомерАккаунта);	
	КонецЕсли;
	СтруктураСессии = Новый Структура;
	СтруктураСессии.Вставить("session", Результат );
	// BSLLS:DeprecatedCurrentDate-off
	СтруктураСессии.Вставить("session_begin", ТекущаяДата());
	// BSLLS:DeprecatedCurrentDate-on
	ЗаписатьСессию(context_params, СтруктураСессии);
	НастройкиПодключенияЗаписать(context_params);	
	Возврат Результат;
КонецФункции

//DynamicDirective

Функция СписокСертификатовДляАутентификации(Сертификаты, context_params = Неопределено) Экспорт
	Если context_params = Неопределено Тогда
		context_params = НастройкиПодключенияПрочитать();
	КонецЕсли;
	ВидТранспорта = ВидТранспорта(context_params);
	Если ВидТранспорта = "ExtSdk2" Или ВидТранспорта = "SabyPluginConnector"  Тогда 
		Результат = ReadCertListForAuthExtSDK2(context_params); 
	Иначе     
		Результат = local_helper_get_sertlist_for_auth(context_params, Сертификаты);	
	КонецЕсли;
	Возврат Результат;
КонецФункции

//DynamicDirective

Процедура block_multithreadloop_get_async_request(context_params) Экспорт
	ВидТранспорта = ВидТранспорта(context_params);
	Пока Истина Цикл
		Если async_requests.Количество() = 0 Тогда
			Прервать;
		КонецЕсли;
		Если ВидТранспорта = "ExtSdk2" Или ВидТранспорта = "SabyPluginConnector" Тогда 
			ExtSDK2_get_answer_request(ВидТранспорта);    
			Если async_responces.Количество() > 0 Тогда 
				Прервать;	
			КонецЕсли;
#Область include_core_base_Транспорт_АсинхронноеВыполнениеAPI 
#КонецОбласти
		Иначе	
			SabyHttpsClient_get_answer_request();
			Если async_responces.Количество() > 0 Тогда 
				Прервать;	
			КонецЕсли;	
			SabyHttpsClient.Sleep(2000);  
		КонецЕсли;	
	КонецЦикла;	
КонецПроцедуры

// Асинхронный ответ на запрос
//
// Параметры:
//  async_responce - Структура - данные запроса.
//	context_params - Структура - параметры подключения
//
// Возвращаемое значение:
//   Структура - "code","result"
//
//DynamicDirective
Функция	local_helper_exec_request_async_process_responce(async_responce, context_params) 
	РезультатЗапроса = get_prop(async_responce, "РезультатЗапроса");	
	ВидТранспорта = ВидТранспорта(context_params);
	Если ВидТранспорта = "ExtSdk2" Или ВидТранспорта = "SabyPluginConnector"  Тогда 
		Результат = ОбработкаРезультатаЗапросаExtSdk2(РезультатЗапроса);		
	Иначе	
		Результат = ОбработкаРезультатаЗапросаSabyHttpsClient(РезультатЗапроса);
	КонецЕсли;	
	Возврат Результат;
КонецФункции

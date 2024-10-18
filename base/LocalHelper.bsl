
#Область include_core_base_LocalHelper_ExecMethod
#КонецОбласти

#Область include_core_base_LocalHelper_ExecRequest
#КонецОбласти

#Область include_core_base_LocalHelper_ElementActionError
#КонецОбласти
	
//DynamicDirective
Функция local_helper_task_list(context_params, Тип="Мои", СтрокаПоиска=Неопределено, ТолькоПросроченные=Неопределено, Навигация=Неопределено, auto_auth=Истина) Экспорт
	// Тип - Мои/ОтМеня/Нераспределенные/Выполненные
	
	Фильтр = Новый Структура("Тип", Тип);
	Если СтрокаПоиска <> Неопределено Тогда
		Фильтр.Вставить("ФильтрПоМаске", СтрокаПоиска);	
	КонецЕсли;
	Если ТолькоПросроченные <> Неопределено Тогда
		Фильтр.Вставить("Просроченные", ТолькоПросроченные);	
	КонецЕсли;
	Если Навигация <> Неопределено Тогда
		Фильтр.Вставить("Навигация", Навигация);	
	КонецЕсли;
	ПараметрыМетода = Новый Структура("Фильтр", Фильтр);
	Попытка
		РезультатЗапроса =  local_helper_exec_method(context_params,"API3.TaskList", ПараметрыМетода, auto_auth);
	Исключение
		ИнфОбОшибке = ИнформацияОбОшибке();
		ВызватьИсключение(NewExtExceptionСтрока(ИнфОбОшибке));		
	КонецПопытки;	
	Возврат get_prop(РезультатЗапроса, "result");

КонецФункции

//DynamicDirective
Функция local_helper_get_product_version_status(context_params, product, client_version) Экспорт
	Попытка
		Возврат local_helper_integration_api(context_params, "API3.GetProductVersionStatus", Новый Структура("product, client_version", product, client_version));
	Исключение
		ИнфОбОшибке = ИнформацияОбОшибке();
		ВызватьИсключение(NewExtExceptionСтрока(ИнфОбОшибке));		
	КонецПопытки;	
КонецФункции

//DynamicDirective
Функция local_helper_extsyncdoc_write(context_params, connection_uuid, extsyncdoc, objects) Экспорт
	Попытка
		params = Новый Структура("param", Новый Структура("ConnectionId, ExtSyncDoc, ExtSyncObj", connection_uuid, extsyncdoc, objects));
		Возврат local_helper_integration_api(context_params, "ExtSyncDoc.Write", params);
	Исключение
		ИнфОбОшибке = ИнформацияОбОшибке();
		ВызватьИсключение(NewExtExceptionСтрока(ИнфОбОшибке));		
	КонецПопытки;
КонецФункции

//DynamicDirective
Функция local_helper_auth_by_login(context_params, __kwargs = Неопределено) Экспорт
	//TODO
	//Прочитать context_param, еще раз, 
	//Проверить session_begin с тем что мы прочитали из настроек.
	//если во входящих парам  время меньше чем в настройках то, в context_params заменяем session_begin и session
	Попытка
		params = Новый Структура("Логин, Пароль", context_params.login, context_params.password);
		url = context_params.api_url + "/auth/service/";
	Исключение
		ИнфОбОшибке = ИнформацияОбОшибке();
		ВызватьИсключение NewExtExceptionСтрока(ИнфОбОшибке,"Не заполнен параметр аутентификации",ИнфОбОшибке.Описание,,,"Unauthorized" );
	КонецПопытки;
	Попытка
		result = local_helper_exec_method(context_params, "СБИС.Аутентифицировать", params, Ложь, ,url);
	Исключение
		ИнфОбОшибке = ИнформацияОбОшибке();
		ВызватьИсключение NewExtExceptionСтрока(ИнфОбОшибке,,,,,"Unauthorized" );
	КонецПопытки;
	session = result.Получить("result");
	context_params.Вставить("session", session );
	context_params.Вставить("session_begin", ТекущаяДата());
	context_params.Вставить("last_token_time", Неопределено);
	НастройкиПодключенияЗаписать(context_params);
	Возврат session;
КонецФункции

//DynamicDirective
Функция local_helper_integration_api(context_params, method, params, auto_auth = Истина) Экспорт
	Попытка
		url = context_params.api_url + "/integration_config/service/?srv=1";
		result = local_helper_exec_method(context_params, method, params, auto_auth, ,url);
	Исключение
		ИнфОбОшибке = ИнформацияОбОшибке();
		ОшибкаСтруктура = NewExtExceptionСтруктура(ИнфОбОшибке);
		Если ОшибкаСтруктура.type = "AddonRequest" Тогда  
			ВызватьИсключение NewExtExceptionСтрока(,"AddonRequest",,,ОшибкаСтруктура.dump, "AddonRequest");;
		КонецЕсли;
		ВызватьИсключение(NewExtExceptionСтрока(ИнфОбОшибке,"Ошибка выполнения метода "+method));
	КонецПопытки;
	Возврат get_prop(result,"result", Неопределено);
КонецФункции

//DynamicDirective
Функция local_helper_exec_integration_list_method(context_params, method, Фильтры = Неопределено, Page = 0, PageSize = 50, ДопПоля = Неопределено,  Сортировка = Неопределено) Экспорт
	params = Новый Структура;
	params.Вставить("ДопПоля", 		ДопПоля);
	params.Вставить("Фильтр", 		Фильтры);
	params.Вставить("Сортировка", 	Сортировка);
	params.Вставить("Навигация", 	Новый Структура("Page,PageSize", Page, PageSize));
	res = local_helper_integration_api(context_params, method, params);
	Возврат res;
КонецФункции

//DynamicDirective
Функция local_helper_api_process_responce(responce) Экспорт
	Возврат get_prop(responce,"result",responce);	
КонецФункции

//DynamicDirective
Функция local_helper_extsyncdoc_prepare(context, extsyncdoc_uuid, direction) Экспорт
	Возврат local_helper_integration_api(context, "ExtSyncDoc.Prepare", 
	Новый Структура("SyncDocId, Direction", extsyncdoc_uuid, direction)
	);
КонецФункции

//DynamicDirective
Функция local_helper_extsyncdoc_execute(context, extsyncdoc_uuid, direction) Экспорт
	Возврат local_helper_integration_api(context, "ExtSyncDoc.Execute",
	Новый Структура("param", Новый Структура("SyncDocId, Direction", extsyncdoc_uuid, direction)));
КонецФункции

//DynamicDirective
Функция local_helper_extsyncdoc_execute_lrs(context, extsyncdoc_uuid, direction) Экспорт
	Возврат local_helper_integration_api(context, "ExtSyncDoc.ExecuteLRS", Новый Структура("SyncDocId", extsyncdoc_uuid));
КонецФункции

//DynamicDirective
Функция local_helper_extsyncdoc_fillchangedsbisobjects_lrs(context, ConnectionId) Экспорт
	Попытка
		param = Новый Структура("ConnectionId", ConnectionId);
		Возврат local_helper_integration_api(context, "ExtSyncDoc.FillChangedSbisObjects", Новый Структура("param", param));
	Исключение
		ИнфОбОшибке = ИнформацияОбОшибке();
		ВызватьИсключение(NewExtExceptionСтрока(ИнфОбОшибке));
	КонецПопытки;
КонецФункции

//DynamicDirective
Функция local_helper_extsyncdoc_write_predefined(context_params, ConnectionId, Type, ClientType, Objects) Экспорт
	
	Попытка
		params = Новый Структура("ConnectionId, Type, ClientType, Objects", ConnectionId, Type, ClientType, Objects);
		Возврат local_helper_integration_api(context_params, "MappingObject.WritePredefined", params);
	Исключение
		ИнфОбОшибке = ИнформацияОбОшибке();
		ВызватьИсключение(NewExtExceptionСтрока(ИнфОбОшибке));		
	КонецПопытки;
	
КонецФункции

//DynamicDirective
Функция local_helper_extsyncdoc_get_obj_for_execute(context, extsyncdoc_uuid, direction)
	Возврат local_helper_integration_api(context, "ExtSyncDoc.GetObjectsForExecute", 
	Новый Структура("SyncDocId, Direction", extsyncdoc_uuid, direction)
	);
КонецФункции

//DynamicDirective
Функция local_helper_extsyncobj_get_obj_for_execute(context, extsyncdoc_uuid, extra_fields, limit)	Экспорт
	Возврат local_helper_integration_api(context, "ExtSyncObj.GetObjectsForExecute", 
	Новый Структура("Filter, ExtraFields", 
	Новый Структура("SyncDocId, Limit", extsyncdoc_uuid, limit), extra_fields)
	);
КонецФункции

//DynamicDirective
Функция local_helper_extsyncdoc_read(context, extsyncdoc_uuid) Экспорт
	Возврат local_helper_integration_api(context, "API3.ExtSyncDocRead", Новый Структура("param", Новый Структура("SyncDocId", extsyncdoc_uuid)));
КонецФункции

//DynamicDirective
Функция local_helper_mapping_obj_find_and_update(context, _filter, _data) Экспорт
	response = local_helper_integration_api(context, "MappingObject.FindAndUpdate", 
	Новый Структура("Filter, Data", _filter, _data)
	);
	Если ЗначениеЗаполнено(response) Тогда
		Возврат response;
	Иначе
		//ВызватьИсключение СокрЛП(response);
		//ИнфОбОшибке = ИнформацияОбОшибке();
		//ВызватьИсключение NewExtExceptionСтрока(ИнфОбОшибке, СокрЛП(get_prop(_data,"Status_msg", "Загрузка " + get_prop(_data, "ClientParam_ObjectName") + " завершена с ошибкой")));
	КонецЕсли;
КонецФункции

//DynamicDirective
Функция local_helper_extsyncdoc_prepare_saby(context, extsyncdoc_uuid) Экспорт
	Возврат local_helper_integration_api( context, "Connector.Prepare",
	Новый Структура("ConnectorName, SyncDocId","Saby", extsyncdoc_uuid)
	);
КонецФункции

//DynamicDirective
Функция local_helper_json_loads(json) Экспорт
	ЧтениеJSON = Новый ЧтениеJSON;
	ЧтениеJSON.УстановитьСтроку(json);
	Попытка
		СтрокаВСоответсвие	= ПрочитатьJSON(ЧтениеJSON, Истина); //Для просмотра в отладке
		Возврат СтрокаВСоответсвие;
	Исключение
		ИнфоОбОшибке = ИнформацияОбОшибке();
		ВызватьИсключение NewExtExceptionСтрока(ИнфоОбОшибке, "Ошибка чтения JSON");
	КонецПопытки;
КонецФункции


//DynamicDirective
Функция local_helper_write_attachment(context, document) Экспорт
	response	=	local_helper_exec_method(context,"СБИС.ЗаписатьВложение", Новый Структура("Документ", document), Истина);
	Результат   = local_helper_api_process_responce(response);
	Возврат Результат;	
КонецФункции

//DynamicDirective
Функция local_helper_prepare_action(context_params, document, multithread_mode = Ложь, timeout = 60) Экспорт
	kwargs = Новый Структура("multithread_mode, timeout", multithread_mode, timeout); 
	headers 		= local_helper_exec_method_get_headers_for_advanced_log(context_params);
	Если  headers <> Неопределено Тогда
		kwargs.Вставить("headers", headers);
	КонецЕсли;
	response = local_helper_exec_method(context_params,"СБИС.ПодготовитьДействие", Новый Структура("Документ", document), Истина, kwargs);
	Результат = local_helper_api_process_responce(response);
	Возврат Результат;	
КонецФункции

//DynamicDirective
Функция local_helper_prepare_action_process_responce(responce)
	result = local_helper_api_process_responce(responce);
	Возврат result;
КонецФункции

//DynamicDirective
Функция local_helper_execute_action(context, document, multithread_mode = Ложь, timeout = 60) Экспорт 
	kwargs = Новый Структура("multithread_mode, timeout", multithread_mode, timeout); 
    headers 		= local_helper_exec_method_get_headers_for_advanced_log(context);
	Если  headers <> Неопределено Тогда
		kwargs.Вставить("headers", headers);
	КонецЕсли;
	response = local_helper_exec_method(context,"СБИС.ВыполнитьДействие", Новый Структура("Документ", document), Истина, kwargs);
	Результат = local_helper_api_process_responce(response);
	Возврат Результат;	
КонецФункции

//DynamicDirective
Функция local_helper_execute_action_process_responce(responce)
	result = local_helper_api_process_responce(responce);
	Возврат result;
КонецФункции

//DynamicDirective
Функция local_helper_delay_service_stage(context, document) Экспорт 
	response = local_helper_exec_method(context,"СБИС.ОтложитьСлужебныйЭтап", Новый Структура("Параметры", Новый Структура("Документ", document)), Истина);
	Результат = local_helper_api_process_responce(response);
	Возврат Результат;	
КонецФункции

//DynamicDirective
Функция local_helper_request_signing(context, params) Экспорт
	response = local_helper_exec_method(context,"EKDAPI.RequestSigning", Новый Структура("Params", params), Истина);
	Результат = local_helper_api_process_responce(response);
	Возврат Результат;		
КонецФункции	

//DynamicDirective
Функция local_helper_find_sbis_object(context, type, filter)
	response = local_helper_exec_method(context,"API3.FindSbisObject", Новый Структура("Type, Filter", type, filter), Истина);
	Результат = local_helper_api_process_responce(response);
	Возврат Результат;
КонецФункции  

//DynamicDirective
Функция local_helper_get_sbis_object(context, type, IdList) Экспорт
	response = local_helper_exec_method(context,"API3.GetSbisObject", Новый Структура("Type, IdList", type, IdList), Истина);
	Результат = local_helper_api_process_responce(response);
	Возврат Результат;
КонецФункции

//DynamicDirective
Функция local_helper_invite_user_ext(context, params) Экспорт
	response = local_helper_exec_method(context,"Invitation.InviteUserExt", Новый Структура("InputData", params));
	Результат = local_helper_api_process_responce(response);
	Возврат Результат;	
КонецФункции


//post запрос
//Для 8.2 тут будет падать. Заменить через вычислить
//Начиная с 8.3 HTTPСоединение возвращает ответ сразу, а не кладёт в файл, появляется объект HTTPЗапрос
//Начиная с 8.2.16 появляется ЗащищенноеСоединениеOpenSSL

//Дополняет заголовки сессией
//context - Структура
//headers - Соответствие
Функция local_helper_add_auth_header(context_params, headers)
	Перем session;
	Если Не context_params.Свойство("session", session) Тогда
		session = "";
	КонецЕсли;
	headers.Вставить("X-SBISSessionID", session);
	
КонецФункции

//DynamicDirective
Функция local_helper_read_document(context_params, document, multithread_mode = Ложь, timeout = 60) Экспорт
	kwargs = Новый Структура("multithread_mode, timeout", multithread_mode, timeout); 
    headers 		= local_helper_exec_method_get_headers_for_advanced_log(context_params);
	Если  headers <> Неопределено Тогда
		kwargs.Вставить("headers", headers);
	КонецЕсли;
	response = local_helper_exec_method(context_params,"СБИС.ПрочитатьДокумент", Новый Структура("Документ", document), Истина, kwargs);
	Результат = local_helper_api_process_responce(response);
	Возврат Результат;
КонецФункции

//DynamicDirective
Функция local_helper_read_document_process_responce(responce)
	result = local_helper_api_process_responce(responce);
	Возврат result;
КонецФункции

//DynamicDirective
Функция local_helper_document_list(context_params, filter, multithread_mode = Ложь, timeout = 60) Экспорт
	kwargs = Новый Структура("multithread_mode, timeout", multithread_mode, timeout); 
    headers 		= local_helper_exec_method_get_headers_for_advanced_log(context_params);
	Если  headers <> Неопределено Тогда
		kwargs.Вставить("headers", headers);
	КонецЕсли;
	response = local_helper_exec_method(context_params,"СБИС.СписокДокументов", Новый Структура("Фильтр", filter), Истина, kwargs);
	Результат = local_helper_api_process_responce(response);
	Возврат Результат;
КонецФункции

//DynamicDirective
Функция local_helper_document_list_process_responce(responce)
	result = local_helper_api_process_responce(responce);
	Возврат result;
КонецФункции

//DynamicDirective
Функция local_helper_document_event_list(context_params, filter, multithread_mode = Ложь, timeout = 60) Экспорт
	kwargs = Новый Структура("multithread_mode, timeout", multithread_mode, timeout); 
    headers 		= local_helper_exec_method_get_headers_for_advanced_log(context_params);
	Если  headers <> Неопределено Тогда
		kwargs.Вставить("headers", headers);
	КонецЕсли;
	response = local_helper_exec_method(context_params,"СБИС.СписокДокументовПоСобытиям", Новый Структура("Фильтр", filter), Истина, kwargs);
	Результат = local_helper_api_process_responce(response);
	Возврат Результат;
КонецФункции

//DynamicDirective
Функция local_helper_document_event_list_process_responce(responce)
	result = local_helper_api_process_responce(responce);
	Возврат result;
КонецФункции

//DynamicDirective
Функция local_helper_write_document(context_params, document, multithread_mode = Ложь, timeout = 120) Экспорт 
	kwargs = Новый Структура("multithread_mode, timeout", multithread_mode, timeout); 
	response = local_helper_exec_method(context_params,"СБИС.ЗаписатьДокумент", Новый Структура("Документ", document), Истина, kwargs);
	Результат = local_helper_api_process_responce(response);
	Возврат Результат;	
КонецФункции

//DynamicDirective
Функция local_helper_write_document_process_responce(responce) 
	result = local_helper_api_process_responce(responce);
	Возврат result;
КонецФункции

//DynamicDirective
Функция local_helper_write_kit(context_params, kit) Экспорт
	Массив = Новый Массив;
	Массив.Добавить(kit);
	kwargs	= Неопределено;
	headers 		= local_helper_exec_method_get_headers_for_advanced_log(context_params);
	Если  headers <> Неопределено Тогда
		kwargs	= Новый Структура();
		kwargs.Вставить("headers", headers);
	КонецЕсли;
	response = local_helper_exec_method(context_params,"СБИС.ЗаписатьКомплект", Новый Структура("Документ", Массив), Истина, kwargs);
	Результат = local_helper_api_process_responce(response);
	Возврат Результат;	
КонецФункции

//DynamicDirective
Функция local_helper_get_server_datetime(context_params) Экспорт
	response = local_helper_exec_method(context_params,"СБИС.ИнформацияОВерсии", Новый Структура("Параметр", Новый Структура()), Истина);
	Результат = local_helper_api_process_responce(response);
	Возврат Результат["ВнешнийИнтерфейс"]["ДатаВремяЗапроса"];
КонецФункции

//DynamicDirective
Функция local_helper_read_changes(context_params, _filter) Экспорт
	Результат = Новый Соответствие();
	kwargs	= Новый Структура();
    headers 		= local_helper_exec_method_get_headers_for_advanced_log(context_params);
	kwargs.Вставить("headers", headers);
	response = local_helper_exec_method(context_params,"СБИС.СписокИзменений", Новый Структура("Фильтр", _filter), Истина, kwargs);
	Результат = local_helper_api_process_responce(response);
	Возврат Результат;
КонецФункции

//DynamicDirective
Функция local_helper_read_service_changes(context, _filter) Экспорт
	Результат = Новый Соответствие();
	Попытка
		response = local_helper_exec_method(context,"СБИС.СписокСлужебныхЭтапов", Новый Структура("Фильтр", _filter), Истина);
		Результат = local_helper_api_process_responce(response);
	Исключение
		ИнфОбОшибке = ИнформацияОбОшибке();
		ВызватьИсключение ИнфОбОшибке.Описание;
	КонецПопытки;	
	Возврат Результат;
КонецФункции

&НаСервере
Функция ЗначениеВСтрокуВнутрСервер(Значение)
	Возврат ЗначениеВСтрокуВнутр(Значение);
КонецФункции

//DynamicDirective
Функция local_helper_download_from_link(context_params, link, response_type = "binary") Экспорт
	headers = Новый Соответствие;
	ВидТранспорта = ВидТранспорта(context_params);
	Если ВидТранспорта="ExtSdk2" Или ВидТранспорта = "SabyPluginConnector" Тогда
		Возврат LoadDataFromURLToFile(context_params,link);
	КонецЕсли;
	
	local_helper_add_auth_header(context_params, headers);
	
	Пока Истина Цикл
		
		ПараметрыМетода = Новый Структура();
		ПараметрыМетода.Вставить("headers", headers);
		response = local_helper_exec_request("get", link, response_type, ПараметрыМетода, context_params);
		Если response["code"] = 200 Тогда
			Прервать;
		КонецЕсли;
		Попытка 
			КодОшибки = response["result"]["error"]["data"]["classid"];
		Исключение
			КодОшибки = Неопределено;
		КонецПопытки;
		Если КодОшибки = "{00000000-0000-0000-0000-1aa0000f1002}" Тогда
			local_helper_pause(1);
			Продолжить;
		КонецЕсли;
		Попытка
			message = response["result"]["error"]["message"];
			detail = response["result"]["error"]["message"];
			Если message = detail Тогда
				detail = Неопределено;
			КонецЕсли;
		Исключение
			message = ЗначениеВСтрокуВнутрСервер(response["result"]);
			detail = Неопределено;
		КонецПопытки;
		ВызватьИсключение NewExtExceptionСтрока(,message,detail);
		Прервать;
	КонецЦикла;	
	Результат = response["result"]; 
	Если ВидТранспорта(context_params)="SabyHttpsClient" Тогда
		Результат = Base64Значение(Результат);
	КонецЕсли;	
	Возврат Результат;
КонецФункции

//DynamicDirective
Функция local_helper_extsyncobj_list(context_params, extra_fields, filter, sorting, pagination) Экспорт
	Если pagination = Неопределено Тогда
		pagination = Новый Структура("PageSize, Page", 15, 0 )
	КонецЕсли;
	
	ПараметрыЗапроса = Новый Структура("ExtraFields,Filter,Sorting,Pagination",
				extra_fields,
		        filter,
		        sorting,
		        pagination
			);
	url = context_params.api_url+"/integration_config/service/?srv=1"; 
	Результат = local_helper_integration_api(context_params, "ExtSyncObj.List", ПараметрыЗапроса, Ложь);  
	Возврат Результат;
КонецФункции

//DynamicDirective
Процедура local_helper_pause(Секунды) Экспорт
	Если Секунды<> 0 Тогда

        НастройкиProxy = Новый ИнтернетПрокси(Ложь);
        НастройкиProxy.НеИспользоватьПроксиДляЛокальныхАдресов = Истина;
        НастройкиProxy.НеИспользоватьПроксиДляАдресов.Добавить("127.0.0.0");

        Попытка
            СоединениеHTTP = Новый HTTPСоединение("127.0.0.0",,,,НастройкиProxy,Секунды);
            СоединениеHTTP.Получить(Новый HTTPЗапрос());
        Исключение
            Возврат;
        КонецПопытки;

    КонецЕсли;
	
КонецПроцедуры	

//Передача ошибок и статуса выполнения на сервер статистик

//DynamicDirective
Процедура local_helper_register_actions(context_params, actions) Экспорт

	SystemInfo = local_helper_system_info();

	ПараметрыМетода = Новый Структура("SystemInfo, Actions", SystemInfo, actions);
	
	Попытка
        РезультатПередачи = local_helper_integration_api(context_params, "IntegrationStat.RegisterActions2", ПараметрыМетода, Ложь);	
	Исключение
		ИнфОбОшибке = ИнформацияОбОшибке();
		ОшибкаСтруктура = NewExtExceptionСтруктура(ИнфОбОшибке);
		Если ОшибкаСтруктура.type = "AddonRequest" Тогда  
			ВызватьИсключение NewExtExceptionСтрока(,"AddonRequest",,,ОшибкаСтруктура.dump, "AddonRequest");;
		КонецЕсли;
		СтруктураОшибки = ExtExceptionAnalyse(ИнфОбОшибке);
	КонецПопытки;
	
КонецПроцедуры

//DynamicDirective
Процедура local_helper_register_errors(context_params, errors) Экспорт

	SystemInfo = local_helper_system_info();

	ПараметрыМетода = Новый Структура("SystemInfo, Errors", SystemInfo, errors);
	
	Попытка
        РезультатПередачи = local_helper_integration_api(context_params, "IntegrationStat.RegisterErrors2", ПараметрыМетода, Ложь);	
	Исключение
		ИнфОбОшибке = ИнформацияОбОшибке();
	КонецПопытки;
	
КонецПроцедуры

//DynamicDirective
Функция local_helper_system_info() Экспорт
	ОбщиеПараметры = ОбщиеНастройкиПрочитать();
	ExtSysUid = get_prop(ОбщиеПараметры, "ExtSysUid", Неопределено);
	
	Connector = "1c-http";
	Если get_prop(get_prop(ОбщиеПараметры,"public", Новый Структура),"exchange_method") = "SabyHttpsClient" Тогда
		Connector = "1c-native-http";
	КонецЕсли;
	Data = Новый Структура();
	Data.Вставить("Connector",Connector);
	Data.Вставить("ExtSysUid",ExtSysUid);
	Data.Вставить("ExtSysType","1C");
	Data.Вставить("ExtSysSubtype",get_prop(ОбщиеПараметры,"ExtSysSettingsId"));
	Data.Вставить("ExtSysVersion",ВерсияМетаданных());
	Data.Вставить("Product",ПолучитьНазваниеПродукта());
	Data.Вставить("ProductVersion",ПолучитьИмяФайлаИНомерТекущейВерсии()[1]);
	Data.Вставить("CustomizationType","blockly");
	Data.Вставить("ApiType","sync");
	Возврат Data;
КонецФункции

//DynamicDirective
Функция ПолучитьТикетТекущейСессии( context_params = Неопределено ) Экспорт
	Если context_params = Неопределено Тогда
		context_params = НастройкиПодключенияПрочитать();
	КонецЕсли;
	ТокенSID	= Новый Структура("sid", context_params.session );
	Тикет_ = local_helper_exec_method(context_params,"САП.GetTicketForCurrentSid", ТокенSID, Истина);
	Тикет_ = local_helper_api_process_responce(Тикет_);
	Тикет	= "";
	Если ТипЗнч(Тикет_) = Тип("Строка") Тогда
		Тикет	= Тикет_;
	КонецЕсли;
	Возврат Тикет;
КонецФункции

//DynamicDirective
Функция local_helper_init_connection(context_params, connection_info) Экспорт
	Попытка
		ConnectionStateEvents = get_prop(connection_info, "ConnectionStateEvents", Новый Массив);
		ExtSysSettings	= Новый Структура("Format, Type","Dom1C");
		Если ТипЗнч(ConnectionStateEvents) = Тип("Массив") И ConnectionStateEvents.Найти("NewSystem") <> Неопределено Тогда
			ExtSysSettings.Удалить("Type");
		КонецЕсли;
		Результат = local_helper_integration_api(context_params, "API3.InitConnection", Новый Структура("Params,ExtSysSettings", connection_info, ExtSysSettings));	
	Исключение
		ИнфОбОшибке = ИнформацияОбОшибке();
		ВызватьИсключение(NewExtExceptionСтрока(ИнфОбОшибке, "Не удалось создать подключение"));
	КонецПопытки;	
	Возврат Результат; 
КонецФункции

//DynamicDirective
Функция local_helper_delete_connection(context_params, connection_info) Экспорт
	Попытка
		Результат = local_helper_integration_api(context_params, "IntegrationConnection.DeleteConnection", connection_info);
	Исключение
		ИнфОбОшибке = ИнформацияОбОшибке();
		ВызватьИсключение(NewExtExceptionСтрока(ИнфОбОшибке, "Не удалось удалить подключение"));
	КонецПопытки;
	Возврат Результат;
КонецФункции

//DynamicDirective
Функция local_helper_read_connection(context_param, connection_info) Экспорт
	Попытка
		МассивINI = Неопределено;
		Если connection_info.Свойство("INI")
			И ТипЗнч(connection_info.INI) = Тип("Массив") Тогда
			МассивINI = connection_info.INI;
		КонецЕсли;
		props = Новый Структура;
		props.Вставить("id", 			connection_info.id);
		props.Вставить("version", 		connection_info.Версия);
		props.Вставить("read_config", 	ИСТИНА);
		props.Вставить("new_format",	ИСТИНА);
	
		params = Новый Структура("props,ini",props,МассивINI);
		Результат = local_helper_integration_api(context_param, "IntegrationConnection.ReadConnection", params);
	Исключение
		ИнфОбОшибке = ИнформацияОбОшибке();
		ВызватьИсключение(NewExtExceptionСтрока(ИнфОбОшибке, "Не удалось получить подключение"));
	КонецПопытки;
	Возврат Результат;
КонецФункции

//DynamicDirective
Функция local_helper_read_connection_list(context_params, connection_info) Экспорт
	Попытка
		Результат = local_helper_integration_api(context_params, "IntegrationConnection.ReadConnectionList", connection_info);
	Исключение
		ИнфОбОшибке = ИнформацияОбОшибке();
		ВызватьИсключение(NewExtExceptionСтрока(ИнфОбОшибке, "Не удалось получить список подключений"));
	КонецПопытки;
	Возврат Результат;
КонецФункции

//DynamicDirective
Функция local_helper_write_connection(context_params, connection_info) Экспорт
	Попытка
		Результат = local_helper_integration_api(context_params, "IntegrationConnection.WriteConnection", connection_info);
	Исключение
		ИнфОбОшибке = ИнформацияОбОшибке();
		ВызватьИсключение(NewExtExceptionСтрока(ИнфОбОшибке, "Не удалось записать подключение"));
	КонецПопытки;
	Возврат Результат;
КонецФункции

//DynamicDirective
Функция local_helper_api3_connection_for_run(context_params, Фильтры, ДопПоля, Сортировка, Страница) Экспорт
	Попытка
		Результат = local_helper_exec_integration_list_method(context_params, "API3.ConnectionForRun", Фильтры, Страница, , ДопПоля, Сортировка);
	Исключение
		ИнфОбОшибке = ИнформацияОбОшибке();
		ВызватьИсключение(NewExtExceptionСтрока(ИнфОбОшибке, "Не удалось получить список подключений для автоматического запуска"));
	КонецПопытки;
	Возврат Результат;
КонецФункции

//DynamicDirective
Функция local_helper_api3_connection_list(context_params, Фильтры, ДопПоля, Сортировка, Страница) Экспорт
	Попытка
		Результат = local_helper_exec_integration_list_method(context_params, "API3.ConnectionList", Фильтры, Страница, , ДопПоля, Сортировка);
	Исключение
		ИнфОбОшибке = ИнформацияОбОшибке();
		ВызватьИсключение(NewExtExceptionСтрока(ИнфОбОшибке, "Не удалось получить список подключений"));
	КонецПопытки;
	Возврат Результат;
КонецФункции

//DynamicDirective
Функция local_helper_api3_typesyncobject_list(context_params, Фильтры, ДопПоля, Сортировка, Страница) Экспорт
	Попытка
		Результат = local_helper_exec_integration_list_method(context_params, "API3.TypeSyncObjectList", Фильтры, Страница, 500, ДопПоля, Сортировка);	
	Исключение
		ИнфОбОшибке = ИнформацияОбОшибке();
		ВызватьИсключение(NewExtExceptionСтрока(ИнфОбОшибке, "Не удалось получить список направлений подключения"));
	КонецПопытки;
	Возврат Результат;
КонецФункции

//DynamicDirective
Функция local_helper_api3_typesyncobjectmasssetdirection(context_param, connection_info) Экспорт
	Попытка
		Результат = local_helper_integration_api(context_param, "API3.TypeSyncObjectMassSetDirection", connection_info);
	Исключение
		ИнфОбОшибке = ИнформацияОбОшибке();
		ВызватьИсключение(NewExtExceptionСтрока(ИнфОбОшибке, "Не удалось изменить направления обмена"));
	КонецПопытки;
	Возврат Результат;
КонецФункции

//DynamicDirective
Функция local_helper_api3_extsyncdoc_list(context_params, Фильтры, ДопПоля, Сортировка, Страница) Экспорт
	Попытка
		Результат = local_helper_exec_integration_list_method(context_params, "API3.ExtSyncDocList", Фильтры, Страница, 500, ДопПоля, Сортировка);	
	Исключение
		ИнфОбОшибке = ИнформацияОбОшибке();
		ВызватьИсключение(NewExtExceptionСтрока(ИнфОбОшибке, "Не удалось получить историю синхронизации"));
	КонецПопытки;
	Возврат Результат;
КонецФункции

//DynamicDirective
Функция local_helper_get_accoutslist(context_params) Экспорт
	Если context_params = Неопределено Тогда
		context_params = НастройкиПодключенияПрочитать();
	КонецЕсли;
	Попытка 
		url = context_params.api_url+"/auth/service/";
		result = local_helper_exec_method(context_params, "СБИС.СписокАккаунтов", Новый Структура, Ложь,,url);   
	Исключение
		ИнфОбОшибке = ИнформацияОбОшибке();
		ВызватьИсключение NewExtExceptionСтрока(ИнфОбОшибке,,,,,"Unauthorized" );
	КонецПопытки;
	Возврат get_prop(get_prop(result, "result"), "Список", Новый Массив);
КонецФункции

//DynamicDirective
Функция local_helper_get_account(context_params = Неопределено) Экспорт
	user_info = local_helper_get_user_info(context_params);
	Возврат user_info["Аккаунт"]["Номер"];
КонецФункции

//DynamicDirective
Функция local_helper_get_user_info(context_params = Неопределено) Экспорт
	Если context_params = Неопределено Тогда
		context_params = НастройкиПодключенияПрочитать();
	КонецЕсли;
	Попытка
		param = Новый Структура;
		param.Вставить("ДопПоля", "Аккаунт,ИдПрофиля");
		ПараметрыМетода = Новый Структура("Параметр", param);
		Результат = local_helper_exec_method(context_params, "СБИС.ИнформацияОТекущемПользователе", ПараметрыМетода);
		Возврат Результат["result"]["Пользователь"];
	Исключение
		ИнфОбОшибке = ИнформацияОбОшибке();
		ВызватьИсключение NewExtExceptionСтрока(ИнфОбОшибке,,,,,"Не удалось получить информацию о текущем пользователе");
	КонецПопытки;
КонецФункции

//DynamicDirective
Функция local_helper_switch_account(context_params, account_id) Экспорт
	Если context_params = Неопределено Тогда
		context_params = НастройкиПодключенияПрочитать();
	КонецЕсли;
	Попытка   
		ПараметрыЗапроса = Новый Структура("Параметр", Новый Структура("НомерАккаунта", account_id));
		url = context_params.api_url+"/auth/service/";	
		result = local_helper_exec_method(context_params, "СБИС.ПереключитьАккаунт", ПараметрыЗапроса, Ложь, ,url); 		
	Исключение
		ИнфОбОшибке = ИнформацияОбОшибке();
		ВызватьИсключение NewExtExceptionСтрока(ИнфОбОшибке,,,,,"Unauthorized" );
	КонецПопытки;
	session = result.Получить("result");
	context_params.Вставить("session", session );
	context_params.Вставить("session_begin", ТекущаяДата());
	context_params.Вставить("need_ticket", Неопределено);
	НастройкиПодключенияЗаписать(context_params);
	Возврат session;
КонецФункции

//DynamicDirective
Функция local_helper_init_remote_signing(context_params, data) Экспорт 
	response = local_helper_exec_method(context_params,"API3.InitRemoteSigning", Новый Структура("data", data), Истина);
	Результат = local_helper_api_process_responce(response);
	Возврат Результат;
КонецФункции

//DynamicDirective
Функция local_helper_get_remote_signature(context_params, data) Экспорт
	response = local_helper_exec_method(context_params,"API3.GetRemoteSignature", Новый Структура("operation_uuid", data), Истина);
	Результат = local_helper_api_process_responce(response);
	Возврат Результат;			
КонецФункции

//DynamicDirective
Функция local_helper_fed_convert_obj_to_xml(context, obj, xml_format, xml_version="", pattern="Генератор") Экспорт
	fed_type_subtype = СтрРазделить82(xml_format,"_");
	fed_version_subversion = СтрРазделить82(xml_version,"_");
	Если НЕ ЗначениеЗаполнено(obj) Тогда
		ВызватьИсключение "fed_convert_obj_to_xml:  The obj is undefined";
	ИначеЕсли НЕ ЗначениеЗаполнено(fed_type_subtype) ИЛИ fed_type_subtype.Количество() > 2 Тогда
		ВызватьИсключение "fed_convert_obj_to_xml:  Format defined incorrectly";
	ИначеЕсли НЕ ЗначениеЗаполнено(fed_version_subversion) ИЛИ fed_version_subversion.Количество() > 2 Тогда
		ВызватьИсключение "fed_convert_obj_to_xml: Version defined incorrectly";
	КонецЕсли;
	
	Если fed_type_subtype.Количество() > 1 Тогда
		ФедПодтип = fed_type_subtype[1];
	Иначе
		ФедПодтип = "";
	КонецЕсли;
	
	Если fed_version_subversion.Количество() > 1 Тогда
		ФедПодверсия = fed_version_subversion[1];
	Иначе
		ФедПодверсия = "";
	КонецЕсли; 
	
    params = Новый Структура("ТипДокумента, ПодТипДокумента, ВерсияФормата, ПодВерсияФормата",
	fed_type_subtype[0],
	ФедПодтип,
	fed_version_subversion[0],
	ФедПодверсия);
        response = local_helper_exec_method(context, "Интеграция.ФЭДСгенерировать", Новый Структура("Name,Format,Substitution", pattern, params, obj)); 
		Если get_prop(response, "result") <> Неопределено Тогда
            Возврат response["result"];
        Иначе
            ВызватьИсключение Строка(response);
		КонецЕсли;	
КонецФункции

//DynamicDirective
Функция local_helper_fed_convert_xml_to_obj(context_params, pattern, b64xml) Экспорт
	response = local_helper_exec_method(context_params,"Интеграция.ФЭДПолучитьПодстановку", Новый Структура("Name, Xml", pattern, b64xml));
	Если get_prop(response, "result") <> Неопределено Тогда		
		Возврат response["result"];
	Иначе
		ВызватьИсключение Строка(response);
	КонецЕсли;	
КонецФункции

//DynamicDirective
Функция local_helper_convert_to_pdfa_to_disk3(context_params, СсылкаФайла, СуффиксФайла) Экспорт
	Попытка
		response	= local_helper_exec_method(context_params,"EKDAPI.ConvertToPDFAToDisk",  Новый Структура("Data, Format, CheckEDOMode", СсылкаФайла, СуффиксФайла, Истина), Истина);
		Результат   = local_helper_api_process_responce(response);
	Исключение
		ИнфОбОшибке = ИнформацияОбОшибке();
		ВызватьИсключение NewExtExceptionСтрока(,"Не удалось преобразовать файл формата " + СуффиксФайла, "EKDAPI.ConvertToPDFAToDisk");
	КонецПопытки;
	Возврат Результат;
КонецФункции

//DynamicDirective
Функция local_helper_convert_to_pdfa_to_disk_x(context_params, СсылкаФайла, СуффиксФайла) Экспорт
	Попытка
		response	= local_helper_exec_method(context_params,"EKDAPI.ConvertToPDFAToDiskX",  Новый Структура("Data, Format, CheckEDOMode", СсылкаФайла, СуффиксФайла, Истина), Истина);
		Результат   = local_helper_api_process_responce(response);
	Исключение
		ИнфОбОшибке = ИнформацияОбОшибке();
		ВызватьИсключение NewExtExceptionСтрока(,"Не удалось преобразовать файл формата " + СуффиксФайла, "EKDAPI.ConvertToPDFAToDisk");
	КонецПопытки;
	Возврат Результат; 
КонецФункции

//DynamicDirective
Функция local_helper_convert_to_pdfa_to_disk2(context_params, СсылкаФайла, СуффиксФайла) Экспорт
	Попытка
		response	= local_helper_exec_method(context_params,"EKDAPI.ConvertToPDFAToDisk",  Новый Структура("Data, Format", СсылкаФайла, СуффиксФайла), Истина);
		Результат   = local_helper_api_process_responce(response);
	Исключение
		ИнфОбОшибке = ИнформацияОбОшибке();
		ВызватьИсключение NewExtExceptionСтрока(,"Не удалось преобразовать файл формата " + СуффиксФайла, "EKDAPI.ConvertToPDFAToDisk");
	КонецПопытки;
	Возврат Результат;
КонецФункции

//DynamicDirective
Функция local_helper_convert_to_pdfa(context_params, СсылкаФайла, СуффиксФайла) Экспорт
	Попытка
		response	= local_helper_exec_method(context_params,"EKDAPI.ConvertToPDFA",  Новый Структура("Data, Format", СсылкаФайла, СуффиксФайла), Истина);
		Результат   = local_helper_api_process_responce(response);
	Исключение
		ИнфОбОшибке = ИнформацияОбОшибке();
		ВызватьИсключение NewExtExceptionСтрока(,"Не удалось преобразовать файл формата " + СуффиксФайла, "EKDAPI.ConvertToPDFA");
	КонецПопытки;
	Возврат Результат;
КонецФункции	

//DynamicDirective
Функция local_helper_regl_get_by_types(context_params, ТипыДокументов) Экспорт
	response	= local_helper_exec_method(context_params,"EKDAPI.ReglGetByTypes",  Новый Структура("DocTypes", ТипыДокументов), Истина);
	Результат   = local_helper_api_process_responce(response);
	Возврат Результат;		
КонецФункции	

//DynamicDirective
Функция local_helper_get_data_document(context_params, guid, ido, ВИИд, ТипДок, ПодТипДок) Экспорт
	kwargs	= Неопределено;   	
	headers 		= local_helper_exec_method_get_headers_for_advanced_log(context_params);
	Если  headers <> Неопределено Тогда
		kwargs	= Новый Структура();
		kwargs.Вставить("headers", headers);
	КонецЕсли; 
	ПараметрыЗапроса = Новый Структура;
	ПараметрыЗапроса.Вставить("guid", 		guid);	
	ПараметрыЗапроса.Вставить("ido", 		ido);	
	ПараметрыЗапроса.Вставить("ВИИд", 		ВИИд);	
	ПараметрыЗапроса.Вставить("ТипДок", 	ТипДок);	
	ПараметрыЗапроса.Вставить("ПодТипДок", 	ПодТипДок);	
	response = local_helper_exec_method(context_params,"Документ.ПолучитьДанныеОДокументе", ПараметрыЗапроса, Истина, kwargs);
	Результат = local_helper_api_process_responce(response);
	Возврат Результат;	
КонецФункции


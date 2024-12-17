
Функция API_ADDON_READSYSTEMINFO(ПараметрыВызова) Экспорт
	ОбщиеПараметры = ОбщиеНастройкиПрочитать();
	ExtSysUid = get_prop(ОбщиеПараметры, "ExtSysUid", Неопределено);
	
//	Инишки = Новый Массив();
//	Инишки.Добавить("Аккордион");                
	//Инишки.Добавить("ПараметрыСистемы");
	//Инишки.Добавить("ПараметрыПодключения");
	Результат = Новый Структура("ExtSysType, ExtSysSubtype, ExtSysSubtypeVersion, Connector, ProductId, ProductVersion, ExtSysUid", //ConnectionId",//, ExtSysSettings",
		"1С",
		Метаданные.Имя,
		Метаданные.Версия,
		"Dom1C",
		ПолучитьНазваниеПродукта(),
		ПолучитьИмяФайлаИНомерТекущейВерсии()[1],		
		ExtSysUid,
//		"", //get_prop(params, "ConnectionId", Неопределено),
		//Новый Структура("Format, Type, Id",
		//	"Dom1C",
		//	"Система",
		//	Инишки,
		//)
	);
	Возврат Результат;	
КонецФункции

//DynamicDirective
Функция API_ADDON_ONAUTH(ПараметрыВызова, context_param = Неопределено) Экспорт
	Если context_param = Неопределено Тогда
		ИмяНастроек = ПолучитьИмяПродукта();
		context_param	= ПрочитатьИзХранилища(ИмяНастроек, "params",,);
		Если context_param = Неопределено Тогда
			context_param = новый Структура;
		КонецЕсли;
	КонецЕсли;
	url = get_prop(ПараметрыВызова,"url", Неопределено);
	Если ЗначениеЗаполнено(url) Тогда 
		url = РазобратьСтрокуУРЛ(url);
		context_param.Вставить("api_url", url.scheme +"://"+ url.host);
   	КонецЕсли;
	context_param.Вставить("session", ПараметрыВызова["sessionId"] );
	context_param.Вставить("session_begin", ТекущаяДата());
	context_param.Вставить("last_token_time", Неопределено);
	ПослеАутентификации(context_param);	
КонецФункции



&НаКлиенте
Процедура ПриОткрытииПереопределяемый()
	ЭлементыФормочки = ПолучитьЭлементыФормы();
	ExtSdkCrypto = ЭлементыФормочки.exchange_method.СписокВыбора.НайтиПоЗначению("ExtSdkCrypto");
	Если ExtSdkCrypto <> Неопределено Тогда
		ЭлементыФормочки.exchange_method.СписокВыбора.Удалить(ExtSdkCrypto);
	КонецЕсли;	
	SabyConnect = ЭлементыФормочки.exchange_method.СписокВыбора.НайтиПоЗначению("SabyConnect");
	Если SabyConnect <> Неопределено Тогда
		ЭлементыФормочки.exchange_method.СписокВыбора.Удалить(SabyConnect);
	КонецЕсли;
	APIClient = ЭлементыФормочки.exchange_method.СписокВыбора.НайтиПоЗначению("APIClient");
	Если APIClient <> Неопределено Тогда
		ЭлементыФормочки.exchange_method.СписокВыбора.Удалить(APIClient);
	КонецЕсли;
	ЭлементыФормочки.AdvancedLog.Видимость = Ложь;
	#Если ВебКлиент Тогда
		ExtSdk = ЭлементыФормочки.exchange_method.СписокВыбора.НайтиПоЗначению("ExtSdk");
		Если ExtSdk <> Неопределено Тогда
			ЭлементыФормочки.exchange_method.СписокВыбора.Удалить(ExtSdk);
		КонецЕсли;
		SabyPluginConnector = ЭлементыФормочки.exchange_method.СписокВыбора.НайтиПоЗначению("SabyPluginConnector");
		Если SabyPluginConnector <> Неопределено Тогда
			ЭлементыФормочки.exchange_method.СписокВыбора.Удалить(SabyPluginConnector);
		КонецЕсли;
	#КонецЕсли	
	СкрытьНастройкиЭЦПAPI();
	СкрытьНастройкиХраненияНастроек();
КонецПроцедуры

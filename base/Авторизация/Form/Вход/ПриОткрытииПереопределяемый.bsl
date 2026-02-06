
&НаКлиенте
Процедура ПриОткрытииПереопределяемый()
	ЭлементыФормочки = ПолучитьЭлементыФормы();
	ExtSdkCrypto = ЭлементыФормочки.exchange_method.СписокВыбора.НайтиПоЗначению("ExtSdkCrypto");
	ЭлементыФормочки.exchange_method.СписокВыбора.Удалить(ExtSdkCrypto);
	SabyConnect = ЭлементыФормочки.exchange_method.СписокВыбора.НайтиПоЗначению("SabyConnect");
	ЭлементыФормочки.exchange_method.СписокВыбора.Удалить(SabyConnect);	
	#Если ВебКлиент Тогда
		ExtSdk2 = ЭлементыФормочки.exchange_method.СписокВыбора.НайтиПоЗначению("ExtSdk2");
		ЭлементыФормочки.exchange_method.СписокВыбора.Удалить(ExtSdk2);
		SabyPluginConnector = ЭлементыФормочки.exchange_method.СписокВыбора.НайтиПоЗначению("SabyPluginConnector");
		ЭлементыФормочки.exchange_method.СписокВыбора.Удалить(SabyPluginConnector);	
	#КонецЕсли	
КонецПроцедуры

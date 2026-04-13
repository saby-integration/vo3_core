
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
	#Если ВебКлиент Тогда
		ExtSdk2 = ЭлементыФормочки.exchange_method.СписокВыбора.НайтиПоЗначению("ExtSdk2");
		Если ExtSdk2 <> Неопределено Тогда
			ЭлементыФормочки.exchange_method.СписокВыбора.Удалить(ExtSdk2);
		КонецЕсли;
		SabyPluginConnector = ЭлементыФормочки.exchange_method.СписокВыбора.НайтиПоЗначению("SabyPluginConnector");
		Если SabyPluginConnector <> Неопределено Тогда
			ЭлементыФормочки.exchange_method.СписокВыбора.Удалить(SabyPluginConnector);
		КонецЕсли;
	#КонецЕсли	
КонецПроцедуры

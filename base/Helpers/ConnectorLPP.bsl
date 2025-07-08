
Функция КоннекторLPP(context_params)
	web_interface = get_prop(get_prop(context_params, "public"), "web_interface");
	Если web_interface = "BrowserSabyPlugin" Тогда
		connector = "Lpp1C2";
	Иначе //web_interface = "BrowserSaby"
		connector = "1c-lppbl";
	КонецЕсли;
	Возврат connector;
КонецФункции

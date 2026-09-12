
Функция КоннекторLPP(context_params)
	web_interface = get_prop(context_params, "web_interface");
	Если web_interface = "BrowserSabyPlugin" Тогда
		connector = "1c-lpp";
	Иначе //web_interface = "BrowserSaby"
		connector = "1c-lppbl";
	КонецЕсли;
	Возврат connector;
КонецФункции

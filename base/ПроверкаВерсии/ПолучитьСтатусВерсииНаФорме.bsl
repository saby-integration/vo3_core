
&НаКлиенте
Функция ПолучитьСтатусВерсииНаФорме(Принудительно = Ложь, СтатусВерсии = Неопределено) Экспорт
	СтатусВерсии	= Неопределено;
	//	Попытка
	context_params_tmp	= ПроверитьНаличиеПараметровПодключенияНаСервере();
	Если context_params_tmp = Неопределено Тогда
		Возврат СтатусВерсии;
	КонецЕсли;
	СтатусВерсии	= ТранспортИнтеграции.ПолучитьСтатусВерсии(Принудительно, СтатусВерсии);
	Возврат СтатусВерсии;

	//	Исключение
	//		ИнфОбОшибке = ИнформацияОбОшибке();
	//		Ошибка = ExtExceptionAnalyse(ИнфОбОшибке);
	//		Сообщить("Ошибка получения информации о версии: " + ExtExceptionToMessage(Ошибка));
	//		Возврат Неопределено;
	//	КонецПопытки;
КонецФункции


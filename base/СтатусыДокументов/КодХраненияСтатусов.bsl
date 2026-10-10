
// Возвращает префикс названия записи в плане видов характеристик, где хранятся названия дополнительных свойств
//
// Параметры:
//  context_params - Структура - Контекст.
//
// Возвращаемое значение:
//  Строка - префикс = имя сервиса
//
Функция КодХраненияСтатусов(context_params)
	Contour = get_prop(context_params, "Contour");
	Если Contour = Неопределено Тогда
		ЗаполнитьПараметрыПодключенияПоУРЛ(context_params);
		Contour = get_prop(context_params, "Contour", "");
	КонецЕсли;
	Domain = get_prop(context_params, "Domain", "");
	
	Префикс = Contour;
	
	Если Domain = "sabytest" Тогда
		Префикс = Префикс + "-stest";
	КонецЕсли;
	
	Возврат Префикс;
КонецФункции

Процедура ЗаполнитьПараметрыПодключенияПоУРЛ(context_params)  Экспорт
	ИмяСервераСтр = get_prop(context_params, "ApiUrl", "");
	Если Найти(ИмяСервераСтр, "pre-test-") > 0 Тогда
		Contour = "pre-test";
	ИначеЕсли Найти(ИмяСервераСтр, "test-") > 0 Тогда
		Contour = "test";
	ИначеЕсли Найти(ИмяСервераСтр, "fix-") > 0 Тогда
		Contour = "fix";
	Иначе
		Contour = "";
	КонецЕсли;
	Если Найти(ИмяСервераСтр, ".ru") > 0 Тогда
		Country = "RU";
	Иначе
		Country = "KZ";
	КонецЕсли;
	Если Найти(ИмяСервераСтр, ".setty") > 0 Тогда
		Domain = "Setty";
	Иначе
		Domain = "Saby";
	КонецЕсли;
	context_params.Вставить("Country", Country);
	context_params.Вставить("Domain", Domain);
	context_params.Вставить("Contour", Contour);
КонецПроцедуры


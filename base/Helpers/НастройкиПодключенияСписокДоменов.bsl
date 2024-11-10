
Функция СписокСерверовSaby(ОтображатьГОСТСервера = Истина) Экспорт
	СписокСрв = Новый Массив();
	ДобавитьСервер(СписокСрв, "ie-1c.saby.ru", 			"online.saby.ru");
	ДобавитьСервер(СписокСрв, "fix-ie-1c.saby.ru", 		"fix-online.saby.ru");
	ДобавитьСервер(СписокСрв, "test-ie-1c.saby.ru", 	"test-online.saby.ru");
	ДобавитьСервер(СписокСрв, "pre-test-ie-1c.saby.ru", "pre-test-online.saby.ru");
    Если ОтображатьГОСТСервера Тогда
		ДобавитьСервер(СписокСрв, "ieg-1c.sbis.ru", 	"g.sbis.ru");
		ДобавитьСервер(СписокСрв, "fix-ieg-1c.sbis.ru","fix-g.sbis.ru");
		ДобавитьСервер(СписокСрв, "test-ieg-1c.sbis.ru","test-g.sbis.ru");
	КонецЕсли;
	ДобавитьСервер(СписокСрв, "online.sabytest.ru",         "online.sabytest.ru");
	Возврат СписокСрв;
КонецФункции

Процедура ДобавитьСервер(СписокСерверов, Адрес, Представление, Индекс = Неопределено)
	Сервер = Новый Структура;
	Сервер.Вставить("Значение", Адрес);
	Сервер.Вставить("Представление", Представление);
	Если Индекс <> Неопределено Тогда
		СписокСерверов.Вставить(Индекс, Сервер);
	Иначе	
		СписокСерверов.Добавить(Сервер);
	КонецЕсли;		
КонецПроцедуры 



Функция СписокСерверовSaby(ОтображатьГОСТСервера = Истина) Экспорт
	СписокСрв = Новый Массив();
	ДобавитьСервер(СписокСрв, "ie-1c.setty.kz", 		"ie-1c.setty.kz");
	ДобавитьСервер(СписокСрв, "fix-ie-1c.setty.kz", 	"fix-ie-1c.setty.kz");
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


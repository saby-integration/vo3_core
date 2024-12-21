
Функция ПолучитьПрямуюССылку(ЗадачаСсылка)
	ЗадачаСсылка = СтрЗаменить(ЗадачаСсылка, "://ie-1c.", "://web1c.");
	ЗадачаСсылка = СтрЗаменить(ЗадачаСсылка, "://fix-ie-1c.", "://fix-web1c.");
	ЗадачаСсылка = СтрЗаменить(ЗадачаСсылка, "://test-ie-1c.", "://test-web1c.");
	ЗадачаСсылка = СтрЗаменить(ЗадачаСсылка, "://pre-test-ie-1c.", "://pre-test-web1c.");
	Возврат ЗадачаСсылка;
КонецФункции

Процедура УстановитьРежимWebInWeb()
    Обработка = МодульОбъекта();
	WebInWebHtml = Обработка.ПолучитьМакет("WebInWeb").ПолучитьТекст();
	АдресСтраницыССлужебнымиПараметрами = ПолучитьПрямуюССылку(АдресСтраницыССлужебнымиПараметрами);
	АдресСтраницыССлужебнымиПараметрами = СтрЗаменить(WebInWebHtml, "%URL%", АдресСтраницыССлужебнымиПараметрами);
КонецПроцедуры


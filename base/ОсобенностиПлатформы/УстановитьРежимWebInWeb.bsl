
Процедура УстановитьРежимWebInWeb()
    Обработка = МодульОбъекта();
	WebInWebHtml = Обработка.ПолучитьМакет("WebInWeb").ПолучитьТекст();
	АдресСтраницыССлужебнымиПараметрами = СтрЗаменить(АдресСтраницыССлужебнымиПараметрами, "1c.", "web1c.");
	АдресСтраницыССлужебнымиПараметрами = СтрЗаменить(WebInWebHtml, "%URL%", АдресСтраницыССлужебнымиПараметрами);
КонецПроцедуры


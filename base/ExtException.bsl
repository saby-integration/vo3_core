
Функция ExtException(parent = Неопределено, message = Неопределено, detail = Неопределено, action = Неопределено, dump = Неопределено, type = "ExtExpception") Экспорт
	
	error = Новый Структура("type, message, detail, action, dump, stack", ?(type=Неопределено,"ExtExpception",type), message, detail, action, dump, Новый Массив);
	
	Если parent <> Неопределено Тогда
		CurrentStack = Новый Структура("type, message, detail, action, dump, traceback");
		ЗаполнитьЗначенияСвойств(CurrentStack, parent);
		Если НЕ ЗначениеЗаполнено(message) Тогда
			error.message = get_prop(parent, "message");
		КонецЕсли;
		Если НЕ ЗначениеЗаполнено(detail) Тогда
			Если parent.type = "Exception" и ЗначениеЗаполнено(message) Тогда
				error.detail = get_prop(parent, "message") + " " + get_prop(parent, "detail");
			иначе
				error.detail = get_prop(parent, "detail");
			КонецЕсли
		КонецЕсли;
		Если НЕ ЗначениеЗаполнено(type) Тогда
			error.type = get_prop(parent, "type");
		КонецЕсли;
		
		Если parent.Свойство("stack") И ТипЗнч(parent.stack) = Тип("Массив") Тогда
			error.stack = parent.stack;
		КонецЕсли;
		Если ЗначениеЗаполнено(message) 
			ИЛИ ЗначениеЗаполнено(action) 
			ИЛИ ЗначениеЗаполнено(dump) 
			ИЛИ ЗначениеЗаполнено(detail) Тогда
			
			error.stack.Добавить(CurrentStack);
		Иначе
			Если НЕ ЗначениеЗаполнено(dump) Тогда
				error.dump = get_prop(parent, "dump"); 
			КонецЕсли;
			Если НЕ ЗначениеЗаполнено(action) Тогда
				error.action = get_prop(parent, "action");
			КонецЕсли;
		КонецЕсли;
	КонецЕсли;
	
	Возврат error;
	
КонецФункции

Функция ExtExceptGetReason(reason)
	Если reason.Причина = Неопределено Тогда
		Возврат reason;
	Иначе
		Возврат ExtExceptGetReason(reason.Причина);
	КонецЕсли;
КонецФункции

Функция ExtExceptionAnalyse(parent) Экспорт
	
	Если parent = Неопределено Тогда
		Возврат Неопределено;
	КонецЕсли;
	
	Попытка
		//Попробуем из строки получить вложеный объек
		Возврат	ЗначениеИзСтрокиВнутр(parent.Описание);
	Исключение
		
		Попытка
			Причина	= ExtExceptGetReason(parent);
			message	= Причина.Описание;
			
			Возврат Новый Структура(
			"type, message, detail, action, dump, stack, traceback",
			"Exception",
			message,
			,,,
			parent.ИмяМодуля +" "+ parent.НомерСтроки
			);
		Исключение
			Возврат Новый Структура("message, dump", "Некорректный вызов исключения", parent);
		КонецПопытки;
	КонецПопытки;
	
КонецФункции

//Функция проброски ExtException с разбором переданного
Функция NewExtExceptionСтруктура(parent = Неопределено, message = Неопределено, detail = Неопределено, action = Неопределено, dump = Неопределено, type = Неопределено) Экспорт
	parentStruct = ExtExceptionAnalyse(parent);
	ОшибкаСтруктура = ExtException(parentStruct, message, detail, action, dump, type);
	Возврат ОшибкаСтруктура;
КонецФункции

Функция NewExtExceptionСтрока(parent = Неопределено, message = Неопределено, detail = Неопределено, action = Неопределено, dump = Неопределено, type = Неопределено) Экспорт
	ОшибкаСтруктура = NewExtExceptionСтруктура(parent, message, detail, action, dump, type);
	Возврат ЗначениеВСтрокуВнутр(ОшибкаСтруктура);
КонецФункции

Функция ExtExceptionToMessage(error) Экспорт
	ДеталиСообщения = get_prop(error, "detail", "");
	
	//Получим описание ошибки из структуры еррор
	Если ТипЗнч(ДеталиСообщения) = Тип("Структура") или ТипЗнч(ДеталиСообщения) = Тип("Соответствие") Тогда
        ОшибкаСообщения = get_prop(ДеталиСообщения, "error", "");
        Если ТипЗнч(ОшибкаСообщения) = Тип("Структура") или ТипЗнч(ОшибкаСообщения) = Тип("Соответствие") Тогда
            ДеталиСообщения = get_prop(ОшибкаСообщения, "message", "");
        КонецЕсли;
    КонецЕсли;
	
	//убедимся, что ДеталиСообщения - строка
	Если ТипЗнч(ДеталиСообщения) <> Тип("Строка") Тогда
		ДеталиСообщения = "";
	КонецЕсли;
	Если error.message = ДеталиСообщения Тогда
		ДеталиСообщения = "";
	КонецЕсли;
	
	Возврат error.message +" "+ ДеталиСообщения;
КонецФункции

Процедура ExtExceptionToJournal(Знач ExceptionСтруктура) Экспорт
	ИмяСобытия = ЛокализацияНазваниеПродукта()+" Ошибка " + ExceptionСтруктура.message;
	
	ЗаписьXML = Новый ЗаписьXML;
	ЗаписьXML.УстановитьСтроку();
	СериализаторXDTO.ЗаписатьXML(ЗаписьXML, ExceptionСтруктура.detail, НазначениеТипаXML.Явное);
	Комментарий = ЗаписьXML.Закрыть();
	
	ЗаписьXML.УстановитьСтроку();
	СериализаторXDTO.ЗаписатьXML(ЗаписьXML, ExceptionСтруктура, НазначениеТипаXML.Явное);
	Данные = ЗаписьXML.Закрыть();
	
	ЗаписьЖурналаРегистрации(
		ИмяСобытия,
		УровеньЖурналаРегистрации.Ошибка,
		,//ОбъектМетаданных - ссылка на элемент справичника или документ
		Данные,
		Комментарий,
    	РежимТранзакцииЗаписиЖурналаРегистрации .Независимая
	);
КонецПроцедуры


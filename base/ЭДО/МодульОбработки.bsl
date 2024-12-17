
//DynamicDirective
Функция ПолучитьДействияДляОбъекта(СсылкаНаОбъект, context_params) Экспорт
	
	МОбъектов = Новый Массив();
	МОбъектов.Добавить(СсылкаНаОбъект);

	РезультатПоиска = СтатусыДокументовОтобратьПоСпискуОбъектов(МОбъектов);
	
	Результат		= Неопределено;
	Для Каждого СтрокаРезультат Из РезультатПоиска Цикл
		
		Попытка
			Если Не ЗначениеЗаполнено(СтрокаРезультат.UID) Тогда
				Продолжить;
			КонецЕсли;	
			result 			= Транспорт.local_helper_read_document(context_params, Новый Структура("Идентификатор",СтрокаРезультат.UID));
			РезультатЭтап	= get_prop(result, "Этап");
			Если ТипЗнч(РезультатЭтап) = Тип("Массив") И РезультатЭтап.Количество() > 0 Тогда
				Результат	= get_prop(РезультатЭтап[0], "Действие", Новый Массив);
			КонецЕсли; 
			
		Исключение 
			
			ИнфоОбОшибке = ИнформацияОбОшибке();
			СтруктураОшибки = ExtExceptionAnalyse(ИнфоОбОшибке);
			Если СтруктураОшибки.type = "Unauthorized" Тогда
 				ВызватьИсключение NewExtExceptionСтрока(ИнфоОбОшибке);
			КонецЕсли;
			СтруктураОшибкиДетали 		= get_prop(СтруктураОшибки, "detail");
			СтруктураОшибкиСообщение	= get_prop(СтруктураОшибки, "message");
			Результат	= Новый Структура("status, detail, message", "error",СтруктураОшибкиДетали, СтруктураОшибкиСообщение);
			
			НужноУдалитьЗапись = Ложь;
			Если ТипЗнч(СтруктураОшибкиСообщение) = Тип("Строка") И Найти(СтруктураОшибкиСообщение,  "Не найден документ с идентификатором") > 0 Тогда
				Результат.Вставить("message2user","Документ был удалён в "+ЛокализацияНазваниеПродукта());
				НужноУдалитьЗапись = Истина;
			КонецЕсли;
			Если Не НужноУдалитьЗапись И ТипЗнч(СтруктураОшибкиДетали) = Тип("Структура") Или ТипЗнч(СтруктураОшибкиДетали) = Тип("Соответствие") Тогда
				СтруктураОшибкиДеталиОшибка = get_prop(СтруктураОшибкиДетали, "error");
				Если Найти(get_prop(СтруктураОшибкиДеталиОшибка, "details"),  "Не найден документ с идентификатором") > 0 Тогда
					Результат.Вставить("message2user","Документ был удалён в "+ЛокализацияНазваниеПродукта());
					НужноУдалитьЗапись = Истина;
				КонецЕсли;
			КонецЕсли;
			Если НужноУдалитьЗапись Тогда
				Результат.Вставить("ПереотправитьОбъект",Истина);
				СтатусыДокументовУдалить(СсылкаНаОбъект);
			КонецЕсли;
			
		КонецПопытки;
		
		Прервать;
	КонецЦикла;
	
	Возврат Результат;
	
КонецФункции



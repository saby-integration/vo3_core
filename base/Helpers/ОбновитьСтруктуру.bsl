Функция ОбновитьСтруктуру(Приёмник, Передатчик)
			
	Если НЕ (ТипЗнч(Передатчик) = Тип("Структура") или ТипЗнч(Передатчик) = Тип("Соответствие")) Тогда
		Возврат Приёмник;
	КонецЕсли;

	Для Каждого ЗнчПередатчик Из Передатчик Цикл
		Приёмник.Вставить(ЗнчПередатчик["Ключ"], ЗнчПередатчик["Значение"]);
		Если ЗнчПередатчик["Ключ"] = "object" Тогда
			Для Каждого ЗнчОбъект Из ЗнчПередатчик["Значение"] Цикл
				Приёмник.Вставить(ЗнчОбъект["Ключ"], ЗнчОбъект["Значение"]);
			КонецЦикла;
		КонецЕсли;
	КонецЦикла;
	Возврат Приёмник;
КонецФункции

Функция ОбновитьСтруктуруРекурсивно(Приёмник, Источник)
			
	Если НЕ (ТипЗнч(Источник) = Тип("Структура") или ТипЗнч(Источник) = Тип("Соответствие")) Тогда
		Возврат Приёмник;
	КонецЕсли;

	Для Каждого ЗнчИсточник Из Источник Цикл
		Ключ = ЗнчИсточник["Ключ"];
		ЗначениеВИсточнике = ЗнчИсточник["Значение"];
		ЗначениеВПриёмнике = get_prop(Приёмник, ЗнчИсточник["Ключ"]);
		Если (ТипЗнч(ЗначениеВПриёмнике) = Тип("Структура") Или ТипЗнч(ЗначениеВПриёмнике) = Тип("Соответствие"))
			И (ТипЗнч(ЗначениеВИсточнике) = Тип("Структура") Или ТипЗнч(ЗначениеВИсточнике) = Тип("Соответствие")) Тогда
			ОбновитьСтруктуруРекурсивно(ЗначениеВПриёмнике, ЗначениеВИсточнике)			
		Иначе
			Приёмник.Вставить(Ключ, ЗначениеВИсточнике);
		КонецЕсли;
	КонецЦикла;
	Возврат Приёмник;
КонецФункции

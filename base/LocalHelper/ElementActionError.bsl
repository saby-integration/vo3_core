
//DynamicDirective
Функция local_helper_element_action(action_name, action_context, action_param, action_count) Экспорт
    ЭлементСтатистики = Новый Структура();
	ЭлементСтатистики.Вставить("ActionName", action_name);
	ЭлементСтатистики.Вставить("ActionContext", action_context);
	ЭлементСтатистики.Вставить("ActionData", action_param);
	ЭлементСтатистики.Вставить("ActionCount", action_count);
	Возврат ЭлементСтатистики;
КонецФункции

//DynamicDirective
Функция local_helper_element_err(action_name, action_context, error_message, error_detail, error_data, error_code, error_count) Экспорт
    ЭлементСтатистики = Новый Структура();
	ЭлементСтатистики.Вставить("ActionName", action_name);
	ЭлементСтатистики.Вставить("ActionContext", action_context);
	ЭлементСтатистики.Вставить("ErrorMessage", error_message);
	ЭлементСтатистики.Вставить("ErrorDetail", error_detail);
	ЭлементСтатистики.Вставить("ErrorCode", error_code);
	ЭлементСтатистики.Вставить("ErrorData", error_data);
	ЭлементСтатистики.Вставить("ErrorCount", error_count);
	Возврат ЭлементСтатистики;
КонецФункции

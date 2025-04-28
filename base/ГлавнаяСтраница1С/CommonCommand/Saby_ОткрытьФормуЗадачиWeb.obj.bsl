&НаКлиенте
Процедура ОбработкаКоманды(ПараметрКоманды, ПараметрыВыполненияКоманды)
	context_params = Saby_Core.ПроверитьНаличиеПараметровПодключения();
	Если Saby_Core.get_prop(context_params, "session") <> Неопределено Тогда
		АдресСтраницы = context_params.api_url+"/page/tasks-in-work"; //integration-tasks?connector=1C
	ИначеЕсли Saby_Core.get_prop(context_params, "api_url") <> Неопределено Тогда
		АдресСтраницы = context_params.api_url+"/auth/";
	Иначе
		АдресСтраницы = "https://ie-1c.saby.ru/auth/";	
	КонецЕсли;	
	ПараметрыФормы = Новый Структура();
	ПараметрыФормы.Вставить("Заголовок", "Задачи");
	ПараметрыФормы.Вставить("АдресСтраницы", АдресСтраницы);
	ПараметрыФормы.Вставить("context_param", context_params);
	ОткрытьФорму("Обработка.SABY.Форма.Browser", ПараметрыФормы,,"Задачи");
КонецПроцедуры
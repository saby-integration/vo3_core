
&НаСервере
Процедура ЗаполнитьСпискиВыбораРеквизитов()
	ЭлементыФормочки = ПолучитьЭлементыФормыНаСервере();
	
#Область include_core_base_Настройки_Form_Настройки_ВариантыДоставкиПриглашения
#КонецОбласти
	
	ЭлементыФормочки.send_type.СписокВыбора.Очистить();
	ЭлементыФормочки.send_type.СписокВыбора.Добавить("Email", "Email");
	ЭлементыФормочки.send_type.СписокВыбора.Добавить("SMS", "SMS");
	//ЭлементыФормочки.send_type.СписокВыбора.Добавить("WhatsApp", "WhatsApp");
	//ЭлементыФормочки.send_type.СписокВыбора.Добавить("Telegram", "Telegram");	
КонецПроцедуры

&НаСервере
Процедура ЗаполнитьРеквизитыИзПубличныхНастроек()
	МодульОбъекта	= МодульОбъекта();
	ОбщиеНастройки	= МодульОбъекта.ОбщиеНастройкиПрочитать();
	ПубличныеОбщиеНастройки	= get_prop(ОбщиеНастройки, "public");
	
	ЭтаФорма.download_attachments_on_complete = get_prop(ПубличныеОбщиеНастройки, "download_attachments_on_complete", Ложь);
	ЭтаФорма.download_attachments_on_update   = get_prop(ПубличныеОбщиеНастройки, "download_attachments_on_update",   Ложь);
	ЭтаФорма.РеквизитВыгружатьВложения = ЭтаФорма.download_attachments_on_complete Или ЭтаФорма.download_attachments_on_update;
	ЭтаФорма.refresh_statuses                 = get_prop(ПубличныеОбщиеНастройки, "refresh_statuses",                 Ложь);
	ЭтаФорма.send_invitations                 = get_prop(ПубличныеОбщиеНастройки, "send_invitations",                 Ложь);
	ЭтаФорма.send_type                        = get_prop(ПубличныеОбщиеНастройки, "send_type",                        "Email");
	ЭтаФорма.run_docflow                      = Истина; // Всегда запускать документооборот
	ЭтаФорма.kedo_mark                        = get_prop(ПубличныеОбщиеНастройки, "kedo_mark",                        Ложь);
	ЭтаФорма.send_completed_documents         = get_prop(ПубличныеОбщиеНастройки, "send_completed_documents",         Истина);
	
	ЭтаФорма.pdf_attachments	= get_prop(ПубличныеОбщиеНастройки, "pdf_attachments", Ложь);
 	ЭтаФорма.auto_update = get_prop(ПубличныеОбщиеНастройки, "auto_update", Ложь);	
	AlgorithmsStorage = get_prop(ПубличныеОбщиеНастройки, "AlgorithmsStorage", Неопределено);	
	Если ЗначениеЗаполнено(AlgorithmsStorage) Тогда
		ЭтаФорма.ПИМИспользоватьКопиюИзКаталога = Истина;
		ЭтаФорма.ПИМПутьККаталогу = get_prop(AlgorithmsStorage, "Repository", "");	
	КонецЕсли;
	
	РеквизитВыгружатьВложенияПриИзмененииНаСервере();
КонецПроцедуры

&НаСервере
Процедура ЗаполнитьРеквизитыИзНастроекПодключения()
	context_params	= МодульОбъекта().НастройкиПодключенияПрочитать();
	ЭтаФорма.Тема	= get_prop(context_params, "Тема");
	Если НЕ ЗначениеЗаполнено(ЭтаФорма.Тема) Тогда
		ЭтаФорма.Тема = "1С";
	КонецЕсли;
	advanced_log_on = get_prop(context_params, "advanced_log", Дата(1, 1, 1));
	Если ТипЗнч(advanced_log_on) = Тип("Булево") Тогда
		advanced_log_on = Дата(1, 1, 1);	
	КонецЕсли;
	Если ТекущаяДатаСеанса() - advanced_log_on >= 86400 Тогда    // выключаем логирование, если больше суток прошло
		ЭтаФорма.advanced_log	= Ложь;
	Иначе
		ЭтаФорма.advanced_log	= Истина;
	КонецЕсли;
	ЭтаФорма.DisableCustomAlgorithms = get_prop(context_params, "DisableCustomAlgorithms", Ложь);
	ЭтаФорма.exchange_method	= get_prop(context_params, ИмяСвойстваТранспорта(), "API");
	ЭтаФорма.SendDocNumberDeleteBasePrefix = get_prop(context_params, "SendDocNumberDeleteBasePrefix", Ложь);
	ЭтаФорма.SendDocNumberDeleteUserPrefix = get_prop(context_params, "SendDocNumberDeleteUserPrefix", Ложь);	
КонецПроцедуры

&НаКлиенте
Процедура ЗаполнитьДатуСобытияОбновленияСтатусов(context_param)
	connection_uuid = get_prop(context_param, "ConnectionUuid", "");
	Если connection_uuid = "" Тогда
		Возврат;
	КонецЕсли;
	params = Новый Структура("id", connection_uuid);
	connection_info = ТранспортИнтеграции.local_helper_read_connection(context_params, params);
	ЭтаФорма.ИнфоСистема		= get_prop(connection_info, "service", "");
	ЭтаФорма.ИнфоПодсистема		= get_prop(connection_info, "subsystem", "");
	ЭтаФорма.ИнфоВерсия			= get_prop(connection_info, "version", "");
	public_params = connection_info["Data"]["public_params"];
	last_event = get_prop(public_params, "last_event");
	LastEventEdo = get_prop(last_event, "LastEventEdo"); 
	ДатаСобытияСтрокой =  get_prop(LastEventEdo, "datetime");
	
	Если ДатаСобытияСтрокой = Неопределено Тогда
		BrokerMarkEdo = get_prop(last_event, "BrokerMarkEdo");
		edo = get_prop(BrokerMarkEdo, "edo");
		ДатаСобытияСтрокой =  get_prop(edo, "datetime");
	КонецЕсли;	
	Если ДатаСобытияСтрокой = Неопределено Тогда
		ПоследнееСобытие = get_prop(context_param, "last_event");
		ДатаСобытияСтрокой =  get_prop(ПоследнееСобытие, "date", "01.01.0001 00.00.00");
	КонецЕсли;

	
	Если Не ПустаяСтрока(ДатаСобытияСтрокой) Тогда
		ЭлементыДатыСобытия = СтрРазделить82(СтрЗаменить(ДатаСобытияСтрокой, " ", "."), ".");
		//В ином случае нам тут делать нечего, скорее всего будет произвольный набор данных
		//на коротый мы не расчитывали
		Если ЭлементыДатыСобытия.Количество() = 6 Тогда
			Попытка
				ЭтаФорма.ДатаВремяУказателяСтатуса = Дата(
					ЭлементыДатыСобытия[2],
					ЭлементыДатыСобытия[1],
					ЭлементыДатыСобытия[0],
					ЭлементыДатыСобытия[3],
					ЭлементыДатыСобытия[4],
					ЭлементыДатыСобытия[5]);
				Исключение
					Возврат;
			КонецПопытки;
		КонецЕсли;
	КонецЕсли;
КонецПроцедуры


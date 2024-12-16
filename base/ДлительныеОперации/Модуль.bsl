
Функция ПодготовитьПараметрыЗапускINIФоновымЗаданием(ini_name, ПараметрыВызоваИни, context_params = Неопределено) Экспорт
	Если context_params = Неопределено Тогда
		context_params	= ПроверитьНаличиеПараметровПодключения();
	КонецЕсли;
	Если context_params <> Неопределено Тогда
		context_params.Удалить("ФоновоеЗаданиеНачало");
	КонецЕсли;
	
	ПараметрыВызова	= Новый Соответствие();
	ПараметрыВызова.Вставить("params", context_params );
	ПараметрыВызова.Вставить("commands_result",Новый Массив);
	ПараметрыВызова.Вставить("endpoint","");
	ПараметрыВызова.Вставить("operation_uuid", СокрЛП(Новый УникальныйИдентификатор));
	ПараметрыВызова.Вставить("algorithm",ini_name);
	ConnectionId	= Неопределено;
	context_params.Свойство("ConnectionId", ConnectionId);
	ПараметрыВызова.Вставить("connection_uuid", ConnectionId);
	ПараметрыВызова.Вставить("object",Новый Соответствие());
	
	Если ini_name = "ОбновитьСтатусы_send" Тогда
		ПараметрыВызова["object"].Вставить("object", Новый Соответствие());
	ИначеЕсли ini_name = "ЗагрузитьВложения_1" Тогда
		ПараметрыВызова["object"].Вставить("МассивСсылок", ПараметрыВызоваИни);
	ИначеЕсли ini_name = "Документы_send" Тогда
		ПараметрыВызова["object"].Вставить("list_doc_ref", ПараметрыВызоваИни["МассивОбъектов"]); 
		ПараметрыВызова["object"].Вставить("ПростойЗапросПодписи", ПараметрыВызоваИни["ПростойЗапросПодписи"]);
		ПараметрыВызова["object"].Вставить("Исполнители", ПараметрыВызоваИни["Исполнители"]);
		ПараметрыВызова["object"].Вставить("КаналИнформации", ПараметрыВызоваИни["КаналИнформации"]);
		ПараметрыВызова["object"].Вставить("МаршрутОзнакомления", ПараметрыВызоваИни["МаршрутОзнакомления"]);
		context_params.public.Вставить("ПростойЗапросПодписи", ПараметрыВызоваИни["ПростойЗапросПодписи"]);
	ИначеЕсли ini_name = "Blockly_Taxmon_robot" ИЛИ ini_name = "Blockly_TaxmonUpdateScans_robot" Тогда
		Для Каждого ПараметрВызоваИни Из ПараметрыВызоваИни Цикл
			ПараметрыВызова.Вставить(ПараметрВызоваИни.Ключ, ПараметрВызоваИни.Значение);
		КонецЦикла;
	Иначе
		ПараметрыВызова["object"].Вставить("list_doc_ref", ПараметрыВызоваИни); 
	КонецЕсли;
	Возврат ПараметрыВызова;
КонецФункции 

Функция ЭтоФоновоеЗадание() Экспорт
	Возврат ПолучитьТекущийСеансИнформационнойБазы().ПолучитьФоновоеЗадание() <> Неопределено;
КонецФункции

Процедура СообщитьПрогресс(Знач Процент = Неопределено, Знач Текст = Неопределено, Знач ДополнительныеПараметры = Неопределено) Экспорт
	
	Если Не ЭтоФоновоеЗадание() Тогда
		Возврат;
	КонецЕсли;
	
	ПередаваемоеЗначение = Новый Структура;
	Если Процент <> Неопределено Тогда
		ПередаваемоеЗначение.Вставить("Процент", Процент);
	КонецЕсли;
	Если Текст <> Неопределено Тогда
		ПередаваемоеЗначение.Вставить("Текст", Текст);
	КонецЕсли;
	Если ДополнительныеПараметры <> Неопределено Тогда
		Если ТипЗнч(ДополнительныеПараметры) = Тип("Структура") ИЛИ ТипЗнч(ДополнительныеПараметры) = Тип("Соответствие") Тогда
			ДополнительныеПараметры.Удалить("variables");
		КонецЕсли;
		ПередаваемоеЗначение.Вставить("ДополнительныеПараметры", ДополнительныеПараметры);
	КонецЕсли;
	
	ПередаваемыйТекст = encode_xdto_xml(ПередаваемоеЗначение);
	
	Текст = "{" + СообщениеПрогресса() + "}" + ПередаваемыйТекст;
	Сообщение = Новый СообщениеПользователю;
	Сообщение.Текст = Текст;
	Сообщение.Сообщить();	
КонецПроцедуры


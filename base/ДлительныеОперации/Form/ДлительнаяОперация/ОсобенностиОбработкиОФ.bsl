Процедура ПриОткрытии()
	ПодключитьОбработчикОжидания("ПослеОткрытия", 0.1, Истина);
КонецПроцедуры

&НаКлиенте
Процедура ЗаполнитьOperationUuid(Источник) 
	Если Источник["operation_uuid"] <> Неопределено Тогда
		Команда.Вставить("operation_uuid",Источник["operation_uuid"]); 
		Возврат;
	КонецЕсли; 
	Если block_obj_get_path_value(Источник, "result.Uuid",Неопределено) <> Неопределено Тогда
		Команда.Вставить("operation_uuid",Источник["result"]["Uuid"]); 
		Возврат;	
	КонецЕсли;	
КонецПроцедуры


&НаКлиенте
Процедура ПослеОткрытия()
	ТекстСообщенияПоУмолчанию = "Операция выполняется";
	ТекстСообщения = "Операция выполняется";
	ПараметрыКоманды = Команда;
	ПараметрыКоманды.Вставить("ДлительнаяОперация", Новый Структура);
	
	ПараметрыКоманды["ДлительнаяОперация"].Вставить("form", ЭтаФорма);
    Результат = ПолучитьМодульОбъекта().API_BLOCKLY_RUN_CLIENT(ПараметрыКоманды);
	
	КартинкаОповещения = КартинкаОшибка();
	Если Результат.Свойство("status") И Результат.status = "complete" Тогда
		КартинкаОповещения = КартинкаУспешно();
		Результатdata = Результат.data; 
		Если ТипЗнч(Результатdata) = Тип("Соответствие") Тогда
			ЗаполнитьOperationUuid(Результатdata);
			Если Результатdata["CountErrors"]<> Неопределено И Результатdata["CountErrors"] > 0 Тогда
				КартинкаОповещения = КартинкаОшибка();
			Иначе
				ОшибкаAddon = block_obj_get_path_value(Результатdata,"result.CountErrors",0);
				Если ОшибкаAddon <> Неопределено И ОшибкаAddon > 0 Тогда
					КартинкаОповещения = КартинкаОшибка();
				КонецЕсли;	
			КонецЕсли;
		КонецЕсли;
		Если ТекстСообщения = ТекстСообщенияПоУмолчанию Тогда
			ТекстОповещения = "Операция выполнена";
		Иначе
			ТекстОповещения = ТекстСообщения; 
		КонецЕсли;
	ИначеЕсли Результат.Свойство("status") И Результат.status = "error" Тогда
		РезультатData = get_prop(Результат, "data");
		ТекстОповещения	= get_prop(РезультатData, "message") +" "+ get_prop(РезультатData, "detail");
	Иначе
		ТекстОповещения	= "Неизвестная ошибка выполнения";	
	КонецЕсли;
	ТекстСообщения = ТекстОповещения;
	
	ЭлементыФормы.КартинкаСостояния.Картинка = КартинкаОповещения;
//	НавигационнаяСсылкаОповещения = Новый ОписаниеОповещения("ОткрытьФормуОтчетаОЗагрузке", ЭтаФорма, ПараметрыКоманды);  
	//НавигационнаяСсылкаОповещения = "e1cib/list/РегистрСведений.МойРегистрСведений";
//	ПоказатьОповещениеПользователя(ТекстОповещения,НавигационнаяСсылкаОповещения,,КартинкаОповещения);
	Оповестить("Saby_ЗавершениеДлительнойОперации", Результат);

	ЭлементыФормы.ТекстСообщения.Гиперссылка = ИСТИНА;
	ЭлементыФормы.ТекстСообщения.УстановитьДействие("Нажатие", Новый Действие("ОткрытьФормуОтчетаОЗагрузке"));
	
	
	//Попытка
	//	ЭтаФорма.Закрыть(); // Закрываем, если в ПослеВыполненияДействия() вызвывающей формы нет закрытия
	//Исключение
	//КонецПопытки;
КонецПроцедуры



Процедура ОткрытьФормуОтчетаОЗагрузке(Элемент) Экспорт
	context_param = НастройкиПодключенияПрочитать();
	URL = get_prop(context_param,"api_url","");
	АдресСтраницы = ПолучитьАдресСтраницыОтчетОЗагрузке(URL, Команда["operation_uuid"]); 
	ПараметрыФормы = Новый Структура( "Заголовок, АдресСтраницы", АдресСтраницы, АдресСтраницы);
	ОткрытьФормуОбработки("Browser", ПараметрыФормы);
КонецПроцедуры


#Область include_core_base_Helpers_Картинки
#КонецОбласти


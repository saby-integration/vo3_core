
//DynamicDirective

Функция ПрочитатьВстраиваемыеОбъекты() Экспорт
	Данные = ПрочитатьИзХранилища(ИмяПродукта(), "InjectObject");
	Возврат Данные;
КонецФункции

//DynamicDirective

Процедура ОбновитьВстраиваемыеОбъекты(context_params) Экспорт
	ConnectionId = get_prop(context_params, "ConnectionUuid");
	Если ЗначениеЗаполнено(ConnectionId) Тогда 
		ОбъектыСинхBlockly = ПолучитьФормуBlockly().ОбъектыСинхBlockly(context_params, ConnectionId); 
		InjectObject = get_prop(ОбъектыСинхBlockly, "ОбъектыИС");
		ЗаписатьВХранилище(ИмяПродукта(), "InjectObject", InjectObject);
	КонецЕсли;		
КонецПроцедуры	

//DynamicDirective

Процедура ПроверитьВстраиваемыеОбъекты(context_params) Экспорт
	Данные = ПрочитатьВстраиваемыеОбъекты();
	Если Данные = Неопределено Тогда
		ОбновитьВстраиваемыеОбъекты(context_params);	
	КонецЕсли;	
КонецПроцедуры

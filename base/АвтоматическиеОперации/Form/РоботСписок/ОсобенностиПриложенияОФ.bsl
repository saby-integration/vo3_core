
Процедура ОбновитьТаблицуАвтоматическиеОперации() 
	ТаблицаПодключений.Очистить();	
	АвтоматическиеОперации = ПолучитьАвтоматическиеОперации(context_param);
	ЗаполнитьОперации(АвтоматическиеОперации);
	
КонецПроцедуры


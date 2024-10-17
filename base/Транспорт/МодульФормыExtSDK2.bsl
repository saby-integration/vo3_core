
//DynamicDirective
Функция ЗагрузитьВременныеФайлыНаДискСБИС(Знач context_params, Знач ДанныеДляЗагрузки) Экспорт
	Возврат UploadToSbisDisk(context_params, ДанныеДляЗагрузки);	
КонецФункции

//DynamicDirective
Функция ПрочитатьДокумент(context_params, Документ) Экспорт
	Возврат local_helper_read_document(context_params, Документ);	
КонецФункции


#Область include_core_base_Helpers_НастройкиПодключенияСписокДоменов
#КонецОбласти

Функция НастройкиПодключенияПрочитать() Экспорт
	ОбщиеНастройки	= ОбщиеНастройкиПрочитать();
	ОбщиеПараметры	= get_prop(ОбщиеНастройки, "public", Новый Структура);
	ИмяПродукта = ПолучитьИмяПродукта();	
	НастройкиПользователя = ХранилищеОбщихНастроек.Загрузить(ИмяПродукта, "params",,);
	Если ТипЗнч(НастройкиПользователя) = Тип("Структура") ТОгда
		Если get_prop(НастройкиПользователя,"exchange_method",Неопределено) = Неопределено Тогда
			НастройкиПользователя.Вставить("exchange_method",get_prop(ОбщиеНастройки,"exchange_method","API"));	
		КонецЕсли;
		НастройкиПользователя.Вставить("ExtSysSettingsId", get_prop(ОбщиеНастройки, "ExtSysSettingsId", ""));
		НастройкиПользователя.Вставить("public", ОбщиеПараметры);
	КонецЕсли;
	Возврат НастройкиПользователя;
КонецФункции

Функция НастройкиПодключенияЗаписать(НастройкиПодключения ) Экспорт
	ИмяПродукта = ПолучитьИмяПродукта();	
	Если ТипЗнч(НастройкиПодключения) = Тип("Структура") ТОгда
		НастройкиПодключения.Удалить("public");
	КонецЕсли;
	ХранилищеОбщихНастроек.Сохранить(ИмяПродукта, "params", НастройкиПодключения,,);
КонецФункции

Функция ПроверитьНаличиеПараметровПодключения() Экспорт
	param = НастройкиПодключенияПрочитать();
	Если param = Неопределено Тогда 
		Возврат Неопределено;
	КонецЕсли;
	Если НЕ has_prop(param, "session") Тогда
		Возврат Неопределено;
	КонецЕсли;
	Возврат param;
КонецФункции



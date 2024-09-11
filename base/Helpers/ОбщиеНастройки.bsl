
Функция ОбщиеНастройкиПрочитать() Экспорт
	УстановитьПривилегированныйРежим(Истина);
	ИмяПродукта = ПолучитьИмяПродукта();	
	ОбщиеНастройки = ХранилищеОбщихНастроек.Загрузить(ИмяПродукта, "params",,ИмяПродукта);
	Если ТипЗнч(ОбщиеНастройки) <> Тип("Структура") Тогда
		ОбщиеНастройки = ПриПервомЗапуске();
	КонецЕсли;
	Возврат ОбщиеНастройки;
КонецФункции

Функция ОбщиеНастройкиЗаписать(ОбщиеНастройки) Экспорт
	УстановитьПривилегированныйРежим(Истина);
	ИмяПродукта = ПолучитьИмяПродукта();	
	ХранилищеОбщихНастроек.Сохранить(ИмяПродукта, "params", ОбщиеНастройки,,ИмяПродукта);
КонецФункции


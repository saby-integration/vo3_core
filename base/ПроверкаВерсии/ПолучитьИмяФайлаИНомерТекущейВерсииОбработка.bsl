
Функция ПолучитьИмяФайлаИНомерТекущейВерсии() Экспорт
	МодульОбъекта = МодульОбъекта();
	Результат = Новый Массив(2);
	Комментарий = СтрРазделить82(МодульОбъекта.Метаданные().Комментарий, ";");
	РазмерКомментария = Комментарий.Количество();
	Если  РазмерКомментария > 2 Тогда
		Результат[0] = Комментарий[РазмерКомментария - 2];
		Результат[1] = Комментарий[РазмерКомментария - 1];
	Иначе
		Результат[0] = "";
		Результат[1] = "00.0000.0";
	КонецЕсли;
	Возврат Результат;	
КонецФункции

Функция ПолучитьТипМетаданныхОбработки()
	Возврат "ВнешняяОбработка";
КонецФункции

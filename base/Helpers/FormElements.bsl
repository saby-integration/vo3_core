
&НаКлиенте
Функция ПолучитьЭлементыФормы()
	Возврат Элементы;
КонецФункции

Функция ПолучитьЭлементыФормыНаСервере()
	Возврат Элементы;
КонецФункции

Функция ПолучитьЗначениеЭлемента(ИмяЭлемента)
	Возврат ЭтаФорма[ИмяЭлемента];
КонецФункции

&НаКлиенте
Функция СтрокаТаблицыФормы(Таблица, ИндексСтроки)
	Возврат Таблица.Получить(ИндексСтроки).ПолучитьИдентификатор();	
КонецФункции


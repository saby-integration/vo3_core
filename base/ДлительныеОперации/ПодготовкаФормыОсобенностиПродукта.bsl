
&НаКлиенте
Функция ТипМетаданныхОбработки() 
	Возврат "Обработка";	
КонецФункции

&НаКлиенте
Процедура ЗаполнитьПутьОбработкиДляВыполненияФоновогоЗадания()
	ИмяОбработки = ИмяОбработки();
КонецПроцедуры

&НаСервере
Функция ЭтоВнешняяОбработка()
	Возврат ЛОЖЬ;	
КонецФункции


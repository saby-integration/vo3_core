
&НаКлиенте
Функция ТипМетаданныхОбработки() 
	Возврат "Обработка";	
КонецФункции

&НаКлиенте
Функция ЗаполнитьПутьОбработкиДляВыполненияФоновогоЗадания()
	ИмяОбработки = ИмяОбработки();
КонецФункции

&НаСервере
Функция ЭтоВнешняяОбработка()
	Возврат ЛОЖЬ;	
КонецФункции



&НаКлиенте
Процедура ОбработкаКоманды(ПараметрКоманды, ПараметрыВыполненияКоманды)
	
	ПараметрыФормы = Новый Структура(); 
	
	ОткрытьФорму("Обработка.SABY.Форма.ДокументыКЭДО", 
		ПараметрыФормы, ПараметрыВыполненияКоманды.Источник, 
		ПараметрыВыполненияКоманды.Уникальность, 
		ПараметрыВыполненияКоманды.Окно, 
		ПараметрыВыполненияКоманды.НавигационнаяСсылка, , 
		РежимОткрытияОкнаФормы.Независимый);
	
КонецПроцедуры

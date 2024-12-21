

&НаСервере
Функция СтруктураВыгрузкиДокумента(Документ1С)
	Возврат Новый Структура("Ссылка,UID,ТипМетаданных,ТипОбъекта,ИмяИни", 
							Документ1С.Ссылка,
							Неопределено,
							Документ1С.Ссылка.Метаданные().Имя,
							Неопределено,
							Неопределено); 	
КонецФункции	

&НаКлиенте
Процедура ОбновитьВСБИСНажатие(Команда)
	Документ1С = ТекущийДокументИС();
	Если Не ЗначениеЗаполнено(Документ1С) Тогда 
		ПоказатьОповещениеПользователя(
			"Ошибка",,
			"Невозможно обновить документ SABY, так как он не был выгружен в 1С",
			БиблиотекаКартинок["Ошибка32"],
			СтатусОповещенияПользователя.Важное, Новый УникальныйИдентификатор);
		Возврат; 
	КонецЕсли;
	
	ДокументПереотправить = Новый Массив();
	ДокументПереотправить.Добавить(СтруктураВыгрузкиДокумента(Документ1С));
	ПараметрыВФорму = Новый Структура("Источник", ДокументПереотправить);
	ОткрытьФормуОбработки("ЗагрузкаДокументов",ПараметрыВФорму,ЭтаФорма.ВладелецФормы, Новый УникальныйИдентификатор());
КонецПроцедуры



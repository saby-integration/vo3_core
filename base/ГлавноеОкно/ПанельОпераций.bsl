
Процедура ОчиститьПанельОпераций(ПараметрыОтображения) Экспорт
	Если ПараметрыОтображения <> Неопределено Тогда
		СкрытьКомандыПанели(ПараметрыОтображения["Toolbar"])
	КонецЕсли;
КонецПроцедуры

Процедура СкрытьКомандыПанели(КомандыПанели) Экспорт
	ЭлемФормы = ПолучитьЭлементыФормыНаСервере();
	Для Каждого Команда Из КомандыПанели Цикл
		Элем = ЭлемФормы.Найти(Команда["Name"]);
		Если Элем <> Неопределено Тогда
			Элем.Видимость = Ложь;	
		КонецЕсли;
	КонецЦикла;
	// Элемент поиска
	Элем = ЭлемФормы.Найти("ФильтрМаска");
	Если Элем <> Неопределено Тогда
		Элем.Видимость = Ложь;	
	КонецЕсли;
КонецПроцедуры

&НаКлиенте
Функция ПолучитьСписокСсылокНаОбъектыКоманды( ПараметрКоманды ) Экспорт
	
	Результат = Новый Структура("Источник", Новый Массив());
	Если ТипЗнч(ПараметрКоманды) = Тип("Массив") Тогда
 		Результат.Источник = ПараметрКоманды;
		Возврат Результат;
	КонецЕсли; 
	
	Если Не ПараметрКоманды.Свойство("Источник") Тогда
		Возврат Результат;
	КонецЕсли; 
	
	Если ТипЗнч(ПараметрКоманды.Источник) = Тип("ТаблицаФормы") ТОгда
		//Форма исписка
		Результат.Источник = ПараметрКоманды.Источник.ВыделенныеСтроки;
	ИначеЕсли ТипЗнч(ПараметрКоманды.Источник) = Тип("Массив") ТОгда
		Результат.Источник = ПараметрКоманды.Источник;
	ИначеЕсли ТипЗнч(ПараметрКоманды.Источник) = Тип("ДанныеФормыСтруктура") ТОгда
		//Форма документа
		мДокументов = Новый Массив();
		мДокументов.Добавить(ПараметрКоманды.Источник.Ссылка);
		Результат.Источник = мДокументов;
	КонецЕсли;  
	
	Возврат Результат;
	
КонецФункции


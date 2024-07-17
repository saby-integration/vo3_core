
&НаКлиенте
Функция ТребуетсяАутентификация(context_param, Команда, ПараметрКоманды)
	
	РезультатПроверки = (context_param = Неопределено);
	Если РезультатПроверки Тогда
		ВходяшиеПараметры	= Новый Структура("Команда, ПараметрКоманды",Команда,ПараметрКоманды);
		ПроверкаВведенныхДанныхАутентификации = Новый ОписаниеОповещения("_ПослеАутентификации", ЭтаФорма, ВходяшиеПараметры);
		ОткрытьФормуОбработки("Вход",,,,, ПроверкаВведенныхДанныхАутентификации);
	КонецЕсли;   
	
	Возврат РезультатПроверки;
	
КонецФункции

&НаКлиенте
Процедура _ПослеАутентификации( Результат, Параметры ) Экспорт 
	
	Если Результат = Неопределено Тогда
		Возврат;
	КонецЕсли;
	
	ИмяКоманды = Параметры.ПараметрКоманды.ОписаниеКоманды.Представление;
	Если ИмяКоманды = "Загрузить в SABY" Тогда
		ЗагрузитьВСБИС( Параметры.Команда, Параметры.ПараметрКоманды )
	ИначеЕсли ИмяКоманды = "Открыть в SABY" Тогда
		ПриНажатииОткрытьВСБИСПолучитьUID( Параметры.Команда, Параметры.ПараметрКоманды )
	ИначеЕсли ИмяКоманды = "Выгрузить вложения из SABY" Тогда
		ПриНажатииВыгрузитьВложенияИзСБИС( Параметры.Команда, Параметры.ПараметрКоманды )
	//ИначеЕсли ИмяКоманды = "Подписать документ" Тогда
	//	ОтправитьНаПодпись( Параметры.Команда, Параметры.ПараметрКоманды )
	ИначеЕсли ИмяКоманды = "Обновить статусы" Тогда
		ПриНажатииОбновитьСтатусы( Параметры.Команда, Параметры.ПараметрКоманды )
	//Запуск через другую функцию, в которой тоже есть проверка
	//ИначеЕсли ИмяКоманды = "Задачи" Тогда
		//Задачи( Параметры.Команда, Параметры.ПараметрКоманды )
	//ИначеЕсли ИмяКоманды = "Кадровые документы" Тогда
		//КадровыеДокументы( Параметры.Команда, Параметры.ПараметрКоманды )
	КонецЕсли; 
	
КонецПроцедуры


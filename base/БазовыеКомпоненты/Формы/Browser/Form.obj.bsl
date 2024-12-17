&НаКлиенте
Перем Транспорт,BlocklyExecutor Экспорт;

#Область include_core_base_Helpers_Константы
#КонецОбласти

&НаКлиенте
Процедура АвтоматическиеОперации(Команда) 
	ОткрытьФормуОбработки("РоботСписок",, ЭтаФорма);	
КонецПроцедуры

&НаКлиенте
Процедура ПриОткрытии(Отказ)
	Транспорт = ПолучитьФормуТранспорта(context_param);
	BlocklyExecutor = ПолучитьФормуBlockly();

	ПодключитьОбработчикОжидания("ПриОткрытииПродолжение", 2, Истина);	
КонецПроцедуры

&НаКлиенте
Процедура ПриОткрытииПродолжение() Экспорт
	//60 секнд * 30 минут
	ПериодМеждуЗапрсамиТокенов = 60*15;
	
	//Проверить открытые окна, если они есть то и тикет получать не нужно
	Если context_param <> Неопределено Тогда
		ВремяПредыдущегоЗапросаТокена = get_prop(context_param, "last_token_time");
		Если ВремяПредыдущегоЗапросаТокена = Неопределено Тогда
			ВремяПредыдущегоЗапросаТокена = ТекущаяДата();
		КонецЕсли;
		Если НЕ ПроверитьЕстьЛиЕщеОткрытыеОкнаБраузера() И ТекущаяДата() - ВремяПредыдущегоЗапросаТокена >= ПериодМеждуЗапрсамиТокенов Тогда
			//Если Нет открытых окнон и прошло более 30 минут с момента открытия окна браузера
			context_param.Вставить("last_token_time", Неопределено);
		КонецЕсли;
	КонецЕсли;
	
	//1. Вначале это код исполняется!!!.
	
	// TODO в обработках делается по команде SETCONNECTIONINFO
	СтатусВерсии = ПолучитьИнформациюОВерсииПоУмолчанию();
	СтатусВерсии = ПолучитьСтатусВерсииНаФорме(Ложь, СтатусВерсии);
	ОбновитьИнформациюОВерсии(СтатусВерсии);
	
	//2. Затем этот. Хватит затирать.
	Если НЕ ПустаяСтрока(АдресСтраницы) Тогда
		СформироватьАдресСоСлужебнымиПараметрами()
	Иначе
		СформироватьАдресАддона();
	КонецЕсли;

	#Если ВебКлиент Тогда
		УстановитьРежимWebInWeb();
	#КонецЕсли
	
	#Если ТолстыйКлиентОбычноеПриложение Тогда
		ЭлементыФормы.ПолеHTMLДокумента.Перейти(АдресСтраницыССлужебнымиПараметрами);	
	#КонецЕсли 
КонецПроцедуры

&НаКлиенте
Функция ПроверитьЕстьЛиЕщеОткрытыеОкнаБраузера()
	ФормаНайдена = Ложь;

	//В режиме запуска ОбычноеПриложение возвращает Неопределено.
	ОкнаПриложения		= ПолучитьОкна();
	Если ОкнаПриложения <> Неопределено Тогда 
		Для каждого ОкноПриложения Из ОкнаПриложения Цикл
			//При открытии формы окна в ПолучитьОкна
			Для Каждого ФормаОкна Из ОкноПриложения.Содержимое Цикл
				Попытка 
					//Пока тут только выбранная итератором форма - форма, но воизбежание в дальнейшем ошибок
					//обернём в исключением. Мы же не знаем, что туда может 1ц положить
					ФормаНайдена = Найти(ФормаОкна.ИмяФормы, ".Browser") > 0;
					Если ФормаНайдена Тогда Прервать; КонецЕсли;
				Исключение
				КонецПопытки;
			КонецЦикла;
			Если ФормаНайдена Тогда Прервать; КонецЕсли;
		КонецЦикла;
	КонецЕсли;
	
	Возврат ФормаНайдена;
КонецФункции

#Область include_core_base_ОсобенностиПлатформы_УстановитьРежимWebInWeb
#КонецОбласти

#Область include_core_base_БазовыеКомпоненты_Формы_Browser_ОсобенностиПродукта
#КонецОбласти

&НаКлиенте
Процедура ПоказатьЛог(Команда)
	ЭлементыФормочки = ПолучитьЭлементыФормы();
	ЭлементыФормочки.Лог.Видимость = НЕ ЭлементыФормочки.Лог.Видимость;
КонецПроцедуры

&НаКлиенте
Процедура СкопироватьВБуфферОбмена(Данные)
	ЭлементыФормочки = ПолучитьЭлементыФормы();
	Окно = ЭлементыФормочки.Поле_HTML_Документа.Документ.ParentWindow;
	Окно.ClipboardData.SetData("Text", Данные);
КонецПроцедуры

&НаКлиенте
Процедура ОчиститьЛог(Команда)
	Лог.Очистить();
КонецПроцедуры

&НаКлиенте
Процедура ПерейтиКСправке(Команда)
	// Вставить содержимое обработчика.
КонецПроцедуры

#Область include_core_base_Helpers_XDTO
#КонецОбласти

#Область include_core_base_БазовыеКомпоненты_Формы_Browser_FormEventsHandler
#КонецОбласти

#Область include_core_base_БазовыеКомпоненты_Формы_Browser_ProductEventsHandler
#КонецОбласти

#Область include_core_base_БазовыеКомпоненты_Формы_Browser_BrowserEventsHandler
#КонецОбласти

#Область include_core_base_ПроверкаВерсии_НаФорме
#КонецОбласти

#Область include_core_base_БазовыеКомпоненты_Формы_Browser_ОсобенностиПлатформы
#КонецОбласти

#Область include_core_base_Helpers_FormGetters
#КонецОбласти

#Область include_core_base_ОсобенностиПлатформы_МодульФормы
#КонецОбласти

&НаКлиенте
Процедура ОткрытьФормуНастроек(Элемент) Экспорт    
	
	ЗаписатьНастройкиНаСервере();
	Форма = ПолучитьФормуОбработки("Настройки", ПутьКФормамОбработки(),,ЭтаФорма);
	Форма.Открыть();
	
КонецПроцедуры

&НаСервере
Процедура ЗаписатьНастройкиНаСервере()
	ПолучитьМодульОбъекта().НастройкиПодключенияЗаписать(context_param);
КонецПроцедуры

#Область include_core_base_ФоновыеЗадания_МодульФоновогоЗаданияКлиент
#КонецОбласти


&НаКлиенте
Процедура ПодключитьРасширениеРаботыСКриптографиейНаВебКлиенте(ОбработчикРезультата) Экспорт
	
	Контекст = Новый Структура;
	Контекст.Вставить("УстановитьРасширенияРаботыСКриптографиейЕслиНеПодключено", Истина);
	Контекст.Вставить("ОбработчикРезультата", ОбработчикРезультата);
	
	Если МенеджерыКриптографииПрочитать() = Неопределено Тогда
		ПодключитьРасширениеРаботыСКриптографиейНаВебКлиентеНачатьПодключение(Контекст);
	Иначе
		ВыполнитьОбработкуОповещения(ОбработчикРезультата, Истина);
	КонецЕсли;
	
КонецПроцедуры  

&НаКлиенте 
Процедура ПодключитьРасширениеРаботыСКриптографиейНаВебКлиентеНачатьПодключение(Контекст) Экспорт
	
    НачатьПодключениеРасширенияРаботыСКриптографией(
        Новый ОписаниеОповещения(
			"ПодключитьРасширениеРаботыСКриптографиейНаВебКлиентеПослеПодключенияРасширения", МодульФоновогоЗаданияКлиент(), Контекст));
	
КонецПроцедуры

&НаКлиенте
Процедура ПодключитьРасширениеРаботыСКриптографиейНаВебКлиентеПослеПодключенияРасширения(Подключено,
		Контекст) Экспорт
	
	Если Подключено Тогда
		
		//Сообщить("Расширение работы с криптографией подключено.");
		ВыполнитьОбработкуОповещения(Контекст.ОбработчикРезультата, Истина);
		
	ИначеЕсли Контекст.УстановитьРасширенияРаботыСКриптографиейЕслиНеПодключено Тогда
		
		//Сообщить("Начали установку расширения работы с криптографией.");
		Контекст.УстановитьРасширенияРаботыСКриптографиейЕслиНеПодключено = Ложь;
        НачатьУстановкуРасширенияРаботыСКриптографией(
            Новый ОписаниеОповещения(
				"ПодключитьРасширениеРаботыСКриптографиейНаВебКлиентеНачатьПодключение", МодульФоновогоЗаданияКлиент(), Контекст));
		
	Иначе
		
		//Сообщить("Не удалось установить или подключить расширение работы с криптографией!");
		ВыполнитьОбработкуОповещения(Контекст.ОбработчикРезультата, Ложь);
		
	КонецЕсли;
	
КонецПроцедуры


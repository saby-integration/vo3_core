
#Область ОписаниеПеременных

#КонецОбласти

#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка) 
	Если Параметры.Свойство("context_param") Тогда
		context_param = Параметры.context_param;	
	КонецЕсли;
	
	Если Параметры.Свойство("dataСтрокой") Тогда 
		dataСтрокой = Параметры.dataСтрокой;
		ЗаполнитьФильтры();		
	КонецЕсли;		
КонецПроцедуры

&НаКлиенте
Процедура ОбработкаОповещения(ИмяСобытия, Параметр, Источник)
	Если ИмяСобытия = "SabySignOut" Тогда
		Закрыть();	
	КонецЕсли;	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийЭлементовШапкиФормы

#КонецОбласти

#Область ОбработчикиСобытийЭлементовТаблицыФормыТаблицаАлгоритмов


#КонецОбласти

#Область ОбработчикиКомандФормы

&НаКлиенте
Процедура СохранитьФильтры(Команда)
	СохранитьФильтрыНаСервере();
	Закрыть(dataСтрокой);
КонецПроцедуры  

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

&НаСервере
Функция ФильтрыПодключения(context_param) Экспорт
	МассивФильтров = Новый Массив;
	Фильтр = Новый Соответствие;
	Фильтр.Вставить("Название","Организация");
	Фильтр.Вставить("ТипИС","Справочники");
	Фильтр.Вставить("ИмяИС","Организации");
	Фильтр.Вставить("Представление","Организация");
	МассивФильтров.Добавить(Фильтр);
	Возврат МассивФильтров; 
КонецФункции

&НаСервере
Процедура ЗаполнитьФильтры()
	МодульОбъекта = МодульОбъекта(); 
	Data = МодульОбъекта.local_helper_json_loads(dataСтрокой);  
	МассивФильтров = ФильтрыПодключения(context_param);
	ФильтрЗначения = Data.Получить("Filter");
	ТаблицаФильтров = МодульОбъекта.МассивФильтровПодключения(ФильтрЗначения);
	СчетчикФильтра = 1;
	Для Каждого Фильтр ИЗ МассивФильтров Цикл
		ДобавляемыеРеквизиты = Новый Массив;
		ТипИС = Фильтр.Получить("ТипИС");
		ИмяИС = Фильтр.Получить("ИмяИС");
		Если ТипИС = "Справочники" Тогда
			ТипЗначенияФильтра = "СправочникСсылка."+ИмяИС;
		Иначе
			Продолжить;
		КонецЕсли;
		НазваниеФильтра = Фильтр.Получить("Название");
		ПредставлениеФильтра = Фильтр.Получить("Представление");
		НайденноеЗначениеФильтра = Неопределено;
		Для Каждого Запись Из ТаблицаФильтров Цикл
			Если Запись.Название = НазваниеФильтра Тогда
				НайденноеЗначениеФильтра = Запись.Значение; 
			КонецЕсли;	
		КонецЦикла;
		ЗначениеФильтра = НайденноеЗначениеФильтра; 		
		СоздатьЭлементФормы(НазваниеФильтра, ТипЗначенияФильтра, СчетчикФильтра, ЗначениеФильтра, ПредставлениеФильтра);		
		СчетчикФильтра = СчетчикФильтра + 1;
	КонецЦикла;	

КонецПроцедуры

&НаСервере
Процедура СохранитьФильтрыНаСервере()
	МодульОбъекта = МодульОбъекта(); 
	Data = МодульОбъекта.local_helper_json_loads(dataСтрокой);
	Фильтр = Data.Получить("Filter");
	Если Фильтр = Неопределено Тогда
		Фильтр = Новый Соответствие;
	КонецЕсли;
	ПредставлениеФильтра = "";
	СобратьФильтры(Фильтр, ПредставлениеФильтра);
	Фильтр.Вставить("description", ПредставлениеФильтра); 
    Data.Вставить("Filter", Фильтр); 
	dataСтрокой = МодульОбъекта.encode_xdto_json(Data);
КонецПроцедуры

#Область include_core_base_Helpers_FormGetters
#КонецОбласти

#Область include_core_base_АвтоматическиеОперации_Form_РоботПарамФильтрОбъектовСинх_ОсобенностиПриложения
#КонецОбласти

#КонецОбласти

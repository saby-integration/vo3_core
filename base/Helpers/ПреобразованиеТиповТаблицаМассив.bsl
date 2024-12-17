Функция СтрокаТаблицыЗначенийВСтруктуру(СтрокаТаблицыЗначений) Экспорт
	
	Структура = Новый Структура;
	Для каждого Колонка Из СтрокаТаблицыЗначений.Владелец().Колонки Цикл
		Значение = СтрокаТаблицыЗначений[Колонка.Имя];
		Если ТипЗнч(Значение) = Тип("ТаблицаЗначений") Тогда  
			Значение = ТаблицаЗначенийВМассив(Значение);
		КонецЕсли;	
		Структура.Вставить(Колонка.Имя, Значение);
	КонецЦикла;
	
	Возврат Структура;
	
КонецФункции

Функция МассивВТаблицуЗначений(Массив) Экспорт
	
	Результат = Новый ТаблицаЗначений;
	
	Если Массив.Количество() = 0 Тогда
		Возврат Результат;
	КонецЕсли;
	
	Элемент = Массив[0];
	ТипЭлемента = ТипЗнч(Элемент);
	
	Если ТипЭлемента = Тип("Структура") Или ТипЭлемента = Тип("ФиксированнаяСтруктура") Тогда
		Для Каждого ЭлементСтруктуры Из Элемент Цикл
			Если ТипЗнч(ЭлементСтруктуры.Значение) = Тип("Неопределено") Тогда
				Продолжить;
			КонецЕсли;
			МассивТипов = Новый Массив;
			МассивТипов.Добавить(ТипЗнч(ЭлементСтруктуры.Значение));
			//ОписаниеТипов = Новый ОписаниеТипов("Число");
			Результат.Колонки.Добавить(ЭлементСтруктуры.Ключ, Новый ОписаниеТипов(МассивТипов));
		КонецЦикла;
		Для Каждого Элемент Из Массив Цикл
			Если ТипЗнч(Элемент) = Тип("Неопределено") Тогда
				Продолжить;
			КонецЕсли;	
			ЗаполнитьЗначенияСвойств(Результат.Добавить(), Элемент);
		КонецЦикла;  
	ИначеЕсли ТипЭлемента = Тип("Соответствие") Тогда
		Для Каждого Запись ИЗ Массив Цикл
			НоваяСтрока = Результат.Добавить(); 
			Для Каждого РеквизитЗаписи ИЗ Запись Цикл
				НазваниеКолонки = РеквизитЗаписи.Ключ;
				НазваниеКолонки = СтрЗаменить(НазваниеКолонки,"@","_");
				Если Результат.Колонки.Найти(НазваниеКолонки) = Неопределено Тогда 
					Результат.Колонки.Добавить(НазваниеКолонки);	
				КонецЕсли;
				НоваяСтрока[НазваниеКолонки] = РеквизитЗаписи.Значение;	
			КонецЦикла;	
		КонецЦикла;
	
	КонецЕсли;
	
	Возврат Результат;
	
КонецФункции

Функция ТаблицаЗначенийВМассив(Таблица) Экспорт
	
	Результат = Новый Массив;
	
	Если ТипЗнч(Таблица) = Тип("ТаблицаЗначений") Тогда
		СтруктураСтрокой = "";
		Для Каждого Колонка Из Таблица.Колонки Цикл
			СтруктураСтрокой = СтруктураСтрокой + Колонка.Имя + ",";
		КонецЦикла;
		Если СтруктураСтрокой <> "" Тогда
			СтруктураСтрокой = Лев(СтруктураСтрокой, СтрДлина(СтруктураСтрокой)-1); 
		КонецЕсли;
		Для Каждого Строка Из Таблица Цикл
			НоваяСтрока = Новый Структура(СтруктураСтрокой);
			ЗаполнитьЗначенияСвойств(НоваяСтрока, Строка);
			Результат.Добавить(НоваяСтрока);
		КонецЦикла;
	КонецЕсли;
	
	Возврат Результат;
	
КонецФункции


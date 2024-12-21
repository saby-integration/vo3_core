
// Выполняем функцию ДвоичныеДанныеФайла() из общего модуля БСП
//
// Параметры:
//  ИмяОбщегоМодуля - Строка - Имя общего модуля.
//  ПрикрепленныйФайл - СправочникСсылка - ссылка на элемент справочника с файлом.
//
// Возвращаемое значение:
//  ДвоичныеДанные, Неопределено - двоичные данные присоединенного файла.
//
Функция ПоОбщемуМодулю_ДвоичныеДанныеФайла(ИмяОбщегоМодуля, ПрикрепленныйФайл)
	
	Перем ДвоичныеДанныеФайла;
	
	ДвоичныеДанныеФайла = Неопределено;
	
	Попытка
		ВызываемыйОбщийМодуль = ОбщийМодульКонфигурации(ИмяОбщегоМодуля);
		Если ВызываемыйОбщийМодуль <> Неопределено Тогда
			ДвоичныеДанныеФайла = ВызываемыйОбщийМодуль.ДвоичныеДанныеФайла(ПрикрепленныйФайл);
		КонецЕсли;
	Исключение
		ДвоичныеДанныеФайла = Неопределено;
	КонецПопытки;
	
	Возврат ДвоичныеДанныеФайла;
	
КонецФункции

// Выполняем ПолучитьДвоичныеДанныеФайла() из общего модуля БСП
//
// Параметры:
//  ИмяОбщегоМодуля - Строка - Имя общего модуля.
//  ПрикрепленныйФайл - СправочникСсылка - ссылка на элемент справочника с файлом.
//
// Возвращаемое значение:
//  ДвоичныеДанные, Неопределено - двоичные данные присоединенного файла.
//
Функция ПоОбщемуМодулю_ПолучитьДвоичныеДанныеФайла(ИмяОбщегоМодуля, ПрикрепленныйФайл)
	
	Перем ДвоичныеДанныеФайла;
	
	ДвоичныеДанныеФайла = Неопределено;
	
	Попытка
		ВызываемыйОбщийМодуль = ОбщийМодульКонфигурации(ИмяОбщегоМодуля);
		Если ВызываемыйОбщийМодуль <> Неопределено Тогда
			ДвоичныеДанныеФайла = ВызываемыйОбщийМодуль.ПолучитьДвоичныеДанныеФайла(ПрикрепленныйФайл);
		КонецЕсли;
	Исключение
		ДвоичныеДанныеФайла = Неопределено;
	КонецПопытки;
	
	Возврат ДвоичныеДанныеФайла;
	
КонецФункции

// Выполняем ПолучитьДанныеФайлаИДвоичныеДанные() из общего модуля БСП
//
// Параметры:
//  ИмяОбщегоМодуля - Строка - Имя общего модуля.
//  ПрикрепленныйФайл - СправочникСсылка - ссылка на элемент справочника с файлом.
//
// Возвращаемое значение:
//  ДвоичныеДанные, Неопределено - двоичные данные присоединенного файла.
//
Функция ПоОбщемуМодулю_ПолучитьДанныеФайлаИДвоичныеДанные(ИмяОбщегоМодуля, ПрикрепленныйФайл)
	
	Перем ДвоичныеДанныеФайла;
	
	ДвоичныеДанныеФайла = Неопределено;
	
	Попытка
		ВызываемыйОбщийМодуль = ОбщийМодульКонфигурации(ИмяОбщегоМодуля);
		Если ВызываемыйОбщийМодуль <> Неопределено Тогда
			СтруктураВозврата = ВызываемыйОбщийМодуль.ПолучитьДанныеФайлаИДвоичныеДанные(ПрикрепленныйФайл);
			ДвоичныеДанныеФайла = СтруктураВозврата.ДвоичныеДанные;
		КонецЕсли;
	Исключение
		ДвоичныеДанныеФайла = Неопределено;
	КонецПопытки;
	
	Возврат ДвоичныеДанныеФайла;
	
КонецФункции

// Выполняем ДанныеФайлаИДвоичныеДанные() из общего модуля БСП
//
// Параметры:
//  ИмяОбщегоМодуля - Строка - Имя общего модуля.
//  ПрикрепленныйФайл - СправочникСсылка - ссылка на элемент справочника с файлом.
//
// Возвращаемое значение:
//  ДвоичныеДанные, Неопределено - двоичные данные присоединенного файла.
//
Функция ПоОбщемуМодулю_ДанныеФайлаИДвоичныеДанные(ИмяОбщегоМодуля, ПрикрепленныйФайл)
	
	Перем ДвоичныеДанныеФайла;
	
	ДвоичныеДанныеФайла = Неопределено;
	
	Попытка
		ВызываемыйОбщийМодуль = ОбщийМодульКонфигурации(ИмяОбщегоМодуля);
		Если ВызываемыйОбщийМодуль <> Неопределено Тогда
			СтруктураВозврата = ВызываемыйОбщийМодуль.ДанныеФайлаИДвоичныеДанные(ПрикрепленныйФайл);
			ДвоичныеДанныеФайла = СтруктураВозврата.ДвоичныеДанные;
		КонецЕсли;
	Исключение
		ДвоичныеДанныеФайла = Неопределено;
	КонецПопытки;
	
	Возврат ДвоичныеДанныеФайла;
	
КонецФункции

// Получение двоичных данных прикрепленного файла по старым БСП
//
// Параметры:
//  ПрикрепленныйФайл - СправочникСсылка - ссылка на элемент справочника с файлом.
//
// Возвращаемое значение:
//  ДвоичныеДанные, Неопределено - двоичные данные присоединенного файла.
//
Функция ПолучитьДвоичныеДанныеПоСтарымБСП(ПрикрепленныйФайл)
	
	ДвоичныеДанныеФайла = Неопределено;
	
	// Получим 2-ым стандартным способом, на старых конфигурациях
	Если ДвоичныеДанныеФайла = Неопределено Тогда
		ДвоичныеДанныеФайла = ПоОбщемуМодулю_ПолучитьДвоичныеДанныеФайла("РаботаСФайламиВызовСервера", ПрикрепленныйФайл);
	КонецЕсли;
	
	// Получим 3-им стандартным способом, на старых конфигурациях
	Если ДвоичныеДанныеФайла = Неопределено Тогда
		ДвоичныеДанныеФайла = ПоОбщемуМодулю_ПолучитьДанныеФайлаИДвоичныеДанные("РаботаСФайламиВызовСервера", ПрикрепленныйФайл);
	КонецЕсли;
	
	// Получим 4-им стандартным способом, на старых конфигурациях
	Если ДвоичныеДанныеФайла = Неопределено Тогда
		ДвоичныеДанныеФайла = ПоОбщемуМодулю_ДанныеФайлаИДвоичныеДанные("РаботаСФайламиВызовСервера", ПрикрепленныйФайл);
	КонецЕсли;
	
	// Получим 5-им стандартным способом, на старых конфигурациях
	Если ДвоичныеДанныеФайла = Неопределено Тогда
		ДвоичныеДанныеФайла = ПоОбщемуМодулю_ПолучитьДанныеФайлаИДвоичныеДанные("РаботаСФайламиСлужебныйВызовСервера", ПрикрепленныйФайл);
	КонецЕсли;
	
	// Получим 6-им стандартным способом, на старых конфигурациях
	Если ДвоичныеДанныеФайла = Неопределено Тогда
		ДвоичныеДанныеФайла = ПоОбщемуМодулю_ДанныеФайлаИДвоичныеДанные("РаботаСФайламиСлужебныйВызовСервера", ПрикрепленныйФайл);
	КонецЕсли;
	
	Возврат ДвоичныеДанныеФайла;
	
КонецФункции

// Получение двоичных данных прикрепленного файла по справочнику ХранилищеДополнительнойИнформации.
// Там штатно хранятся прикрепленные файлы в конфигурациях УПП 1.3, ЗУП 2.5, но без даты создания/изменения
//
// Параметры:
//  ПрикрепленныйФайл - СправочникСсылка - ссылка на элемент справочника с файлом.
//
// Возвращаемое значение:
//  ДвоичныеДанные, Неопределено - двоичные данные присоединенного файла.
//
Функция ПолучитьДвоичныеДанныеПоСправочникуХранилищеДополнительнойИнформации(ПрикрепленныйФайл)
	
	Перем ИмяСправочника;
	
	ИмяСправочника = "ХранилищеДополнительнойИнформации";
	
	Попытка
		Если Метаданные.Справочники.Найти(ИмяСправочника) = Неопределено
		 ИЛИ Метаданные.Справочники[ИмяСправочника].Реквизиты.Найти("Хранилище") = Неопределено Тогда
			Возврат Неопределено;
		Иначе
			Возврат ПрикрепленныйФайл.Хранилище.Получить();
		КонецЕсли;
	Исключение
		Возврат Неопределено;
	КонецПопытки;
	
КонецФункции

Функция ПолучитьДвоичныеДанныеПрикрепленногоФайлаВЗависимостиОтТипа(ПрикрепленныйФайл)
	
	Перем Результат;
	
	Результат = Неопределено;
	
	Попытка
		
		// Тип 1 = Справочник.ХранилищеДополнительнойИнформации (УПП 1.3, ЗУП 2.5 - штатное хранение)
		Результат = ПолучитьДвоичныеДанныеПоСправочникуХранилищеДополнительнойИнформации(ПрикрепленныйФайл);
		Если Результат <> Неопределено Тогда
			Возврат Результат;
		КонецЕсли;
		
		// Следующие типы, точечно, если понадобятся
		//...
		
	Исключение
		
		Возврат Неопределено;
		//Сообщить(ОписаниеОшибки());
		
	КонецПопытки;
	
	Возврат Результат;
	
КонецФункции

// Общая функция получения двоичных данных прикрепленного файла
//
// Параметры:
//  ПрикрепленныйФайл - СправочникСсылка - ссылка на элемент справочника с файлом.
//
// Возвращаемое значение:
//  ДвоичныеДанные, Неопределено - двоичные данные присоединенного файла.
//
Функция ПолучитьДвоичныеДанныеПрикрепленногоФайла(ПрикрепленныйФайл)
	
	ТекВерсия = ВерсияБСП();
	
	// Для неизвестной конфигурации
	Если ТекВерсия = "0" Тогда
		Возврат Неопределено;
	КонецЕсли;
	
	ОбщийМодульСравненияВерсий = ОбщийМодульКонфигурации("ОбщегоНазначенияКлиентСервер");
	
	ДвоичныеДанныеФайла = Неопределено;
	
	// Получим 1-ым стандартным способом
	Попытка
		Если ОбщийМодульСравненияВерсий.СравнитьВерсии(ТекВерсия, "2.4.1.80") >= 0 Тогда
			ДвоичныеДанныеФайла = ПоОбщемуМодулю_ДвоичныеДанныеФайла("РаботаСФайлами", ПрикрепленныйФайл);
		ИначеЕсли ОбщийМодульСравненияВерсий.СравнитьВерсии(ТекВерсия, "1.2.1.15") >= 0 Тогда
			ДвоичныеДанныеФайла = ПоОбщемуМодулю_ПолучитьДвоичныеДанныеФайла("ПрисоединенныеФайлы", ПрикрепленныйФайл);
		КонецЕсли;
	Исключение
		ДвоичныеДанныеФайла = Неопределено;
	КонецПопытки;
	
	// Если не получили 1-ым способом, то получим другим стандартным способом, на старых конфигурациях БСП
	Попытка
		Если ДвоичныеДанныеФайла = Неопределено Тогда
			Если ОбщийМодульСравненияВерсий.СравнитьВерсии(ТекВерсия, "2.4.1.80") >= 0 Тогда
			ИначеЕсли ОбщийМодульСравненияВерсий.СравнитьВерсии(ТекВерсия, "1.2.1.15") >= 0 Тогда
				ДвоичныеДанныеФайла = ПолучитьДвоичныеДанныеПоСтарымБСП(ПрикрепленныйФайл);
			КонецЕсли;
		КонецЕсли;
	Исключение
		ДвоичныеДанныеФайла = Неопределено;
	КонецПопытки;
	
	Попытка
		// Получим оставшимся методом, если не получили стандартным
		Если ДвоичныеДанныеФайла = Неопределено Тогда
			ДвоичныеДанныеФайла = ПолучитьДвоичныеДанныеПрикрепленногоФайлаВЗависимостиОтТипа(ПрикрепленныйФайл);
		КонецЕсли;
	Исключение
		ДвоичныеДанныеФайла = Неопределено;
	КонецПопытки;
	
	Возврат ДвоичныеДанныеФайла;
	
КонецФункции


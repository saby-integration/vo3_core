
Процедура ПрисоеденитьФайлНаСервере(ДокументССылка, ДвоичныеДанные, Название, Тип) Экспорт
КонецПроцедуры

Процедура ЗагрузитьВложение(ДокументССылка, Файл, Название, context = Неопределено, block_context = Неопределено)  Экспорт
КонецПроцедуры	

Функция ПолучитьПечатныеФормы(Знач СсылкаНаОбъект, Вложения = Неопределено, БезСодержимого = Ложь) Экспорт
	Если ТипЗнч(Вложения) <> Тип("Массив") Тогда
		Возврат Неопределено;
	КонецЕсли;
	
	Если СсылкаНаОбъект = Неопределено Тогда
		Возврат Вложения;
	КонецЕсли;
	
	МодульУниверсальныеМеханизмы = ОбщийМодульКонфигурации("УниверсальныеМеханизмы");
	Если МодульУниверсальныеМеханизмы = Неопределено Тогда
		Возврат Неопределено;
	КонецЕсли;
		
	Попытка
		ОбъектПередачи = СсылкаНаОбъект.ПолучитьОбъект();
		мДеревоМакетов = МодульУниверсальныеМеханизмы.ПолучитьДеревоМакетовПечати(СсылкаНаОбъект, ОбъектПередачи.ПолучитьСтруктуруПечатныхФорм());
	Исключение
		//У объекта в менеджере объекта отсутствует процедура - ДобавитьКомандыПечати  
		Возврат Вложения;
	КонецПопытки;
	
	//Прикреплённые файлы
	//ТаблицаПрикреплённыхФайловОбъекта = РаботаСФайламиСлужебный.ВсеПодчиненныеФайлы(СсылкаНаОбъект);
	//ТаблицаПрикреплённыхФайловОбъекта = РаботаСФайламиСлужебный.ПолучитьВсеПодчиненныеФайлы(СсылкаНаОбъект);
	//^--- Дают пустой массив, поэтому укрдем функцию из обработки - РаботаСФайлами
	ТаблицаПрикреплённыхФайловОбъекта = ПолучитьСписокПрикреплёныхФайлов(СсылкаНаОбъект);
	//Прикреплённые файлы
	
	Отбор = Новый Структура("ТипКнопки", ТипКнопкиКоманднойПанели.Действие);
	КомандыПФ = мДеревоМакетов.Строки.НайтиСтроки(Отбор);
	
	Если БезСодержимого = Истина Тогда
		Для Каждого Запись Из КомандыПФ Цикл  
			Файл = Новый Структура("ПечатнаяФормаДокумента", Истина);
			Вложения.Добавить(Новый Структура("Название,Идентификатор,Файл", Запись.Представление, Запись.Идентификатор, Файл));	
		КонецЦикла;	
		Возврат Вложения;
	КонецЕсли;

	ИндексВложения = -1;
	Для Каждого Вложение Из Вложения Цикл
		ИндексВложения = ИндексВложения + 1;
		Если	(Вложение["Файл"] = Неопределено ИЛИ get_prop(Вложение["Файл"], "ПечатнаяФормаДокумента") = Неопределено)
				И
				(get_prop(Вложение["Файл"], "ПрисоединенныйФайл") <> Истина) Тогда
			Продолжить;
		КонецЕсли;
		
		Если get_prop(Вложение["Файл"], "ПрисоединенныйФайл", Ложь) = Истина Тогда
		  ////Прикреплённый файл
		  // При необходимости взять из обработки УФ, и доработать
		  ////Прикреплённый файл
		Иначе
			
			//Печатная форма
			ДобавленныеПФ = Новый Соответствие();

			ЭтаФорма = Неопределено;
			мКомандыПечатиФормы = мДеревоМакетов.Строки.НайтиСтроки( Новый Структура("Текст", Вложение["Название"]) );
			Для Каждого Команда Из мКомандыПечатиФормы Цикл
				
				ПечатныеФормы = Новый Массив;
				ТабличныйДокументПФ = ПолучитьТабличныйДокументПечатнойФормы(ОбъектПередачи, Команда.Имя);
				ПечатныеФормы.Добавить(ТабличныйДокументПФ);
				
				ТабличныйДокумент = Новый ТабличныйДокумент;
				Для Каждого ПечатнаяФорма Из ПечатныеФормы Цикл
					Попытка
						НазваниеПФ = Команда.Текст;
						Вложение["Название"] = ПривестиСтрокуКВалидномуИмениФайла(НазваниеПФ);
						Вложение["Файл"].Удалить("ПечатнаяФормаДокумента");
						
						ПотокВПамяти = Новый ПотокВПамяти;
						ПечатнаяФорма.Записать(ПотокВПамяти, ТипФайлаТабличногоДокумента.PDF);
						ФайлBase64 = Base64Строка(ПотокВПамяти.ЗакрытьИПолучитьДвоичныеДанные());
						
						ВставитьСвойствоЕслиНет(Вложение["Файл"], "Имя", НазваниеПФ+".pdf");
						ВставитьСвойствоЕслиНет(Вложение["Файл"], "ДвоичныеДанные", ФайлBase64);
						ВставитьСвойствоЕслиНет(Вложение["Файл"], "ContentType", "application/pdf");;
					Исключение
						ИнфОбОшибке = ИнформацияОбОшибке();
						ВызватьИсключение NewExtExceptionСтрока(ИнфОбОшибке,"Не удалось сформировать печатную форму", Команда.Представление+" ("+ИнфОбОшибке.Описание+")");
					КонецПопытки;
					Прервать;
				КонецЦикла;
			КонецЦикла;
			
		КонецЕсли; //Обычна печатная форма
	КонецЦикла;
	Возврат Вложения;
КонецФункции

Функция ПолучитьТабличныйДокументПечатнойФормы(Объект, ИмяМакетаПечати)
	
	ЭтоДокумент = Метаданные.Документы.Содержит(Объект.Метаданные());
	Попытка
		СтруктураВнутреннихПечатныхФорм = Объект.ПолучитьСтруктуруПечатныхФорм()
	Исключение
		СтруктураВнутреннихПечатныхФорм = Новый Структура;
	КонецПопытки;

	МодульУниверсальныеМеханизмы = ОбщийМодульКонфигурации("УниверсальныеМеханизмы");
	Если МодульУниверсальныеМеханизмы = Неопределено Тогда
		ВызватьИсключение NewExtExceptionСтрока(,"Не удалось сформировать печатную форму.");
	КонецЕсли;
	
	ДеревоМакетовПечати = МодульУниверсальныеМеханизмы.ПолучитьДеревоМакетовПечати(Объект.Ссылка, СтруктураВнутреннихПечатныхФорм);
	СтрокаКнопки = ДеревоМакетовПечати.Строки.Найти(ИмяМакетаПечати,"Имя");
	Если СтрокаКнопки = Неопределено Тогда
		ВызватьИсключение NewExtExceptionСтрока(,"Не удалось сформировать печатную форму.");
	КонецЕсли;
	
	Расшифровка = СтрокаКнопки.Расшифровка;
	Если ТипЗнч(Расшифровка) = Тип("Структура") Тогда
		РезультаВыполнения = МодульУниверсальныеМеханизмы.НапечататьВнешнююФорму(Объект.Ссылка, Расшифровка);
	Иначе
		РезультаВыполнения = Объект.Печать(СтрокаКнопки.Имя, 0);
	КонецЕсли;

	ТабДокумент = Неопределено;
	Если ТипЗнч(РезультаВыполнения) = Тип("ТабличныйДокумент") Тогда
		ТабДокумент = РезультаВыполнения;
		// все хорошо
	ИначеЕсли ТипЗнч(РезультаВыполнения) = Тип("Форма") Тогда
		//Найдем среди элементов Табличный документ, Форма обычного приложения
		Для Каждого ЭлементФормы Из РезультаВыполнения.ЭлементыФормы Цикл
			Если ТипЗнч(ЭлементФормы) = Тип("ПолеТабличногоДокумента") Тогда
				ТабДокумент = Новый ТабличныйДокумент;
				ТабДокумент.Вывести(ЭлементФормы);
				Прервать;
			КонецЕсли;
		КонецЦикла;
		РезультаВыполнения.Закрыть();
	Иначе
		Если ТипЗнч(РезультаВыполнения) = Тип("ФормаКлиентскогоПриложения") Тогда
			// Форма управляемого приложения... Как??? 8-О
			// Но такой вариант развития событий существует, и код тут для него
			// невозможно обойти реквизиты формы. обращаемся по имени. считаем , что оно всегда такое
			ТабДокумент = Новый ТабличныйДокумент;
			ТабДокумент.Вывести(РезультаВыполнения.ПечатныйДокумент);
			РезультаВыполнения.Закрыть();
		КонецЕсли;
	КонецЕсли;
	Если ТабДокумент = Неопределено Тогда
		ВызватьИсключение NewExtExceptionСтрока(,"Не удалось получить печатную форму.");
	КонецЕсли;
	
	Возврат ТабДокумент;
КонецФункции

Процедура ИнициализацияНедостающихКонстант()  Экспорт
	НаправлениеПоиска = Новый Структура("СНачала, СКонца", "СНачала", "СКонца");
КонецПроцедуры

Функция ПолучитьДанныеПрисоединенногоФайла(ПечатнаяФормаДокументаКомандаСсылка)
	Возврат Неопределено;
КонецФункции

Функция ПолучитьСписокПрикреплёныхФайлов(ВладелецФайлов)
	Возврат Неопределено;	
КонецФункции

#Область include_core_base_ОсобенностиПлатформы_РаботаСоСтроками
#КонецОбласти


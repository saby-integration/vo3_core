
#Область include_core_base_locale_ЛокализацияНазваниеПродукта
#КонецОбласти

#Область include_core_base_Helpers_РаботаСоСвойствамиСтруктуры
#КонецОбласти

#Область include_core_base_ExtException
#КонецОбласти

&НаКлиенте
Процедура ДобавитьВложение(Команда)
	СтандартнаяОбработка = Ложь;
	Диалог = Новый ДиалогВыбораФайла(РежимДиалогаВыбораФайла.Открытие);
	Диалог.Фильтр = НСтр("ru=’Любой файл (*.*)|*.*'");
	Диалог.Заголовок = НСтр("ru=’Выберите файл'");
	Диалог.МножественныйВыбор = Истина;
	ОбработкаОкончанияЗагрузки = Новый ОписаниеОповещения("ВыборФайлаЗавершение", ЭтаФорма, Диалог);
	НачатьПомещениеФайлов(ОбработкаОкончанияЗагрузки, , Диалог, Истина, УникальныйИдентификатор);
КонецПроцедуры

&НаСервере
Процедура УдалитьСтрокуВыбранногоОбъекта(ИдентификаторыСтрок)
	Для Каждого ИдентификаторСтроки Из ИдентификаторыСтрок Цикл
		СтрокаТЧ = Объекты.НайтиПоИдентификатору(ИдентификаторСтроки);
		Объекты.Удалить(СтрокаТЧ);
	КонецЦикла;
КонецПроцедуры

&НаСервере
Функция ТаблицаМетаданныхПоТаблицеДокументов()
	Если ТипЗнч(Объекты) = Тип("ДанныеФормыКоллекция") Тогда
		ВремТаблМД = Объекты.Выгрузить(, "Объект");
	ИначеЕсли ТипЗнч(Объекты) = Тип("ТаблицаЗначений") Тогда
		ВремТаблМД = Объекты.Скопировать(, "Объект");
	Иначе
		ВремТаблМД = Объекты;
	КонецЕсли;
	ВремТаблМД.Колонки.Добавить("ОбъектМД");
	Для Каждого СтрДокум Из ВремТаблМД Цикл
		СтрДокум.ОбъектМД = СтрДокум.Объект.Метаданные();
	КонецЦикла;
	ВремТаблМД.Свернуть("ОбъектМД");
	Возврат ВремТаблМД;
КонецФункции

&НаСервере
Функция ЗаполнитьСписокПФПоТблДокументов()
	ВремТаблМД = ТаблицаМетаданныхПоТаблицеДокументов();
	Для Каждого СтрДокум Из ВремТаблМД Цикл
		Попытка
			КомандыПечатиФормыВр = УправлениеПечатью.КомандыПечатиОбъекта(СтрДокум.ОбъектМД);
		Исключение
			//У объекта в менеджере объекта отсутствует процедура - ДобавитьКомандыПечати
			Продолжить;
		КонецПопытки;

		ДобавленныеПФ = Новый Соответствие();
		//Общие ПФ формы
		ИспКомандыПФ = КомандыПечатиФормыВр.НайтиСтроки(
			Новый Структура("Отключена, СкрытаФункциональнымиОпциями", Ложь, Ложь));
		Для Каждого КомандаПечати Из ИспКомандыПФ Цикл
			//Отключим дублирование ПФ, используются при включении ФО - "Работа в россии"
			Если Найти(КомандаПечати.Обработчик, "КадровыйЭДОКлиент") > 0 Тогда
				Продолжить;
			КонецЕсли;
			Если НЕ (ПустаяСтрока(КомандаПечати.СписокФорм)
				ИЛИ Найти(КомандаПечати.СписокФорм,"ФормаДокумента") > 0
				ИЛИ Найти(КомандаПечати.СписокФорм,"ФормаЭлемента") > 0
				ИЛИ Найти(КомандаПечати.СписокФорм,"ФормаСписка") > 0) Тогда
				Продолжить;
			КонецЕсли;
			ДобавленныеПФ.Вставить(КомандаПечати.Представление, Истина);

			КомандаП = Новый Структура("Обработчик, ДополнительныеПараметры, МенеджерПечати,
				|Идентификатор, Представление, ПроверкаПроведенияПередПечатью,
				|ПроверкаПроведенияПередПечатью, ФункциональныеОпции",);

			ЗаполнитьЗначенияСвойств(КомандаП, КомандаПечати);
			НоваяПФ = ВложенияПоТипамОбъектов1С.Добавить();
			НоваяПФ.Представление = КомандаПечати.Представление;
			НоваяПФ.ТипВложения = "ПечатнаяФорма";
			НоваяПФ.ИндексКартинки = 0;
			НоваяПФ.ВидОбъекта = СтрДокум.ОбъектМД.Имя;
			НоваяПФ.Команда = КомандаП;
		КонецЦикла;
	КонецЦикла;
	Возврат Неопределено;
КонецФункции

&НаКлиенте
Процедура УдалитьВложениеНаСервере(ИмяТаблицы, ВидОбъекта, ТипВложения, Представление)
	мСтрокКУдалению = ЭтотОбъект[ИмяТаблицы].НайтиСтроки(
		Новый Структура("ВидОбъекта, ТипВложения, Представление", ВидОбъекта, ТипВложения, Представление));
	Если мСтрокКУдалению.Количество() > 0 Тогда
		//удаляем обратным перебором, т.к. индекс строк меняется
		ВсегоСтрок = мСтрокКУдалению.Количество() - 1;
		Для СчетСтрок = 0 По ВсегоСтрок Цикл
			СтрокаКУдалению = мСтрокКУдалению[ВсегоСтрок - СчетСтрок];
			СтрокаКУдалению = ЭтаФорма[ИмяТаблицы].НайтиПоИдентификатору(СтрокаКУдалению.ПолучитьИдентификатор());
			ЭтаФорма[ИмяТаблицы].Удалить(СтрокаКУдалению);
		КонецЦикла;
	КонецЕсли;
КонецПроцедуры



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

#Область ТаблицаПечатныхФормИФормированиеПредпросмотра

&НаСервере
Функция СформироватьПФНаСервере(КомандаПечати, ВыбранныйДокумент)

	ПараметрыПечати = Новый Структура("ДополнитьКомплектВнешнимиПечатнымиФормами", Ложь);
	ОбъектыПечати = Новый Массив;
	ОбъектыПечати.Добавить(ВыбранныйДокумент);

	ВзТабличныйДокумент = "";
	// Формирование табличных документов.
	Если Найти(КомандаПечати.Менеджерпечати, "ДополнительныеОтчетыИОбработки") > 0 Тогда
		ВзТабличныйДокумент = СформироватьПФНаСервереМенеджерПечатиДополнительныеОтчетыИОбработки(
									КомандаПечати, ОбъектыПечати);
	Иначе
		Попытка
			ПечатныеФормы = УправлениеПечатью.СформироватьПечатныеФормы(КомандаПечати.МенеджерПечати,
				КомандаПечати.Идентификатор, ОбъектыПечати, ПараметрыПечати);
		Исключение
			ПечатныеФормы = Неопределено;
		КонецПопытки;

		Если ТипЗнч(ПечатныеФормы) = Тип("Структура") И ПечатныеФормы.Свойство("КоллекцияПечатныхФорм") Тогда
			Для Каждого ПФ Из ПечатныеФормы.КоллекцияПечатныхФорм Цикл
				ВзТабличныйДокумент = ПоместитьВоВременноеХранилище(ПФ.ТабличныйДокумент, Новый УникальныйИдентификатор);
				Прервать;
			КонецЦикла;
		КонецЕсли;
	КонецЕсли;

	Возврат ВзТабличныйДокумент;

КонецФункции

&НаСервере
Функция СформироватьПФНаСервереМенеджерПечатиДополнительныеОтчетыИОбработки(КомандаПечати, ОбъектыПечати)
	ВзТабличныйДокумент = "";

	СсылкаНаПечатнуюФорму	= КомандаПечати.ДополнительныеПараметры.Ссылка;
	Если СсылкаНаПечатнуюФорму.Пустая() Тогда
		ВызватьИсключение("Отсутствует внешняя печатная форма.");
	КонецЕсли;
	ПараметрыВызова	= Новый Структура("ИдентификаторКоманды, ОбъектыНазначения",
								КомандаПечати.Идентификатор, ОбъектыПечати);
	ПечатныеФормы	= Неопределено;
	ОбъектыПечати	= Новый СписокЗначений;
	ПараметрыВывода	= Неопределено;
	Попытка
		УправлениеПечатью.ПечатьПоВнешнемуИсточнику(
			СсылкаНаПечатнуюФорму,
			ПараметрыВызова,
			ПечатныеФормы,
			ОбъектыПечати,
			ПараметрыВывода);
	Исключение
		ПечатныеФормы = Новый Массив;
	КонецПопытки;
	Для Каждого ПФ Из ПечатныеФормы Цикл
		ВзТабличныйДокумент = ПоместитьВоВременноеХранилище(ПФ.ТабличныйДокумент, Новый УникальныйИдентификатор);
		Прервать;
	КонецЦикла;

	Возврат ВзТабличныйДокумент;
КонецФункции

&НаСервере
Функция ОтобразитьПФ(АдресТД)
	ТабДокПредпросмотр = ТабличныйДокументПоИмениЭлементаФормыТабличноеПоле("Предпросмотр");
	ТабДокПредпросмотр.Очистить();
	Если НЕ ПустаяСтрока(АдресТД) Тогда
		ВрТабличныйДок = ПолучитьИзВременногоХранилища(АдресТД);
		Если ТипЗнч(ВрТабличныйДок) = Тип("ТабличныйДокумент") Тогда
			ТабДокПредпросмотр.Вывести(ВрТабличныйДок);
		КонецЕсли;
	КонецЕсли;
КонецФункции

&НаКлиенте
Процедура СформироватьПФ()
	//А нужно ли это условие???
	ЭлементыФормочки = ПолучитьЭлементыФормы();
	ТД = ЭлементыФормочки.ВложенияТипаДокумента.ТекущиеДанные;
	Если Объекты.Количество() = 1 Тогда
		ТД.АдресПревьюВХранилище = СформироватьПФНаСервере(ТД.Команда, Объекты[0].Объект);
	Иначе
		ТД.АдресПревьюВХранилище = СформироватьПФНаСервере(ТД.Команда,
										ЭлементыФормочки.Объекты.ТекущиеДанные.Объект);
	КонецЕсли;
КонецПроцедуры

&НаКлиенте
Процедура ТаблицаВложенийОтметкаПриИзменении(Элемент)
	ЭлементыФормочки = ПолучитьЭлементыФормы();
	ТД = ЭлементыФормочки.ВложенияТипаДокумента.ТекущиеДанные;
	//ОтобразитьПФ( ?(ТД.ОтметкаВыбора, ТД.ПФ, "") );
	//ЗаполнитьКоментарииДокументовКОтправке();
	Если Объекты.Количество() = 1 Тогда
		ЗаписатьВыборПФДляВидаДокумента(Объекты[0].ВидОбъекта);
	Иначе
		ЗаписатьВыборПФДляВидаДокумента(ЭлементыФормочки.Объекты.ТекущиеДанные.ВидОбъекта);
	КонецЕсли;
КонецПроцедуры

&НаКлиенте
Процедура ТаблицаВложенийПриАктивизацииСтроки(Элемент)
	ЭлементыФормочки = ПолучитьЭлементыФормы();
	ТД = ЭлементыФормочки.ВложенияТипаДокумента.ТекущиеДанные;
	Если ТД = Неопределено ИЛИ ТД.ТипВложения <> "ПечатнаяФорма" Тогда
		Возврат;
	КонецЕсли;
	//Пока печать только по двойному клику на строчке печатной формы

	//Если ДокументыКОтправке.Количество() = 1 Тогда
	//	ТД.ПФ = СформироватьПФНаСервере(ТД.Команда, ДокументыКОтправке[0].Документ);
	//Иначе
	//	ТД.ПФ = СформироватьПФНаСервере(ТД.Команда, Элементы.ДокументыКОтправке.ТекущиеДанные.Документ);
	//КонецЕсли;
	//ЗаполнитьКоментарииДокументовКОтправке();
	ОтобразитьПФ(ТД.АдресПревьюВХранилище);
КонецПроцедуры

&НаКлиенте
Процедура ТаблицаВложенийВыбор(Элемент, ВыбраннаяСтрока, Поле, СтандартнаяОбработка)
	ЭлементыФормочки = ПолучитьЭлементыФормы();
	ТД = ЭлементыФормочки.ВложенияТипаДокумента.ТекущиеДанные;
	Если ТД = Неопределено ИЛИ ТД.ТипВложения <> "ПечатнаяФорма"  Тогда Возврат; КонецЕсли;
	СформироватьПФ();
	ОтобразитьПФ(ТД.АдресПревьюВХранилище);
КонецПроцедуры

#КонецОбласти



// Возвращает список ссылок на присоединенные файлы и электронные документы с параметрами по объектам.
// 
// Параметры:
//  Объект                - объект или Массив из ОпределяемыйТип.ОснованияЭлектронныхДокументовЭДО
//  ИменаФайлов           - Неопределено - не учитывается дата изменений файлов.
//                        - Массив - массив строк с именами файлов, которые нужно получить.
//  ИзмененныеПосле       - Неопределено - не учитывается дата изменений файлов.
//                        - Дата - берутся только файлы с датой больше указанной.
//
// Возвращаемое значение:
//  Массив структур:
//   * Ссылка - СправочникСсылка.СообщениеЭДОПрисоединенныеФайлы - ссылка на присоединенный файл.
//   * ОбъектСсылка - ОпределяемыйТип.ОснованияЭлектронныхДокументовЭДО - ссылка на объект.
//   * ЭлектронныйДокумент - ДокументСсылка.СообщениеЭДО - Электронный документ.
//   * Актуальный - Булево - признак актуальности электронного документа.
//   * СпособОбработки - Строка - способ обработки.
//   * НаправлениеЭДО - ПеречислениеСсылка.НаправленияЭДО - направление ЭДО.
//   * СостояниеЭДО - ПеречислениеСсылка.СостоянияСообщенийЭДО - состояние сообщения ЭДО.
//   * СтатусЭДО - ПеречислениеСсылка.СтатусыСообщенийЭДО - статус сообщения ЭДО.
//   * ДатаИзмененияСтатуса - Дата - дата изменения статуса сообщения ЭДО.
//
Функция ПрикрепленныеФайлыЭДОКОбъекту(Объект, ИменаФайлов = Неопределено, ИзмененныеПосле = Неопределено) Экспорт
	
	Запрос = Новый Запрос;
	Запрос.Текст =
		"ВЫБРАТЬ
		|	ОбъектыУчетаДокументовЭДО.ЭлектронныйДокумент,
		|	ОбъектыУчетаДокументовЭДО.ОбъектУчета,
		|	ОбъектыУчетаДокументовЭДО.СпособОбработки,
		|	ОбъектыУчетаДокументовЭДО.Актуальный
		|ПОМЕСТИТь тОбъектыУчетаДокументовЭДО
		|ИЗ
		|	РегистрСведений.ОбъектыУчетаДокументовЭДО КАК ОбъектыУчетаДокументовЭДО
		|ГДЕ 
		|	ОбъектыУчетаДокументовЭДО.ОбъектУчета В (&ОбъектыУчета)
		|;
		|
		|////////////////////////////////////////////////////////////////////////////////
		|ВЫБРАТь
		|	СообщениеЭДОПрисоединенныеФайлы.Ссылка,
		|	тОбъектыУчетаДокументовЭДО.ОбъектУчета КАК ОбъектСсылка,
		|	СообщениеЭДО.Ссылка КАК ЭлектронныйДокумент,
		|	тОбъектыУчетаДокументовЭДО.Актуальный КАК Актуальный,
		|	тОбъектыУчетаДокументовЭДО.СпособОбработки КАК СпособОбработки,
		|	СообщениеЭДО.Направление КАК НаправлениеЭДО,
		|	СообщениеЭДО.Состояние КАК СостояниеЭДО,
		|	СообщениеЭДО.Статус КАК СтатусЭДО,
		|	СообщениеЭДО.ДатаИзмененияСтатуса КАК ДатаИзмененияСтатусаЭДО
		|ИЗ
		|	Документ.СообщениеЭДО КАК СообщениеЭДО
		|		ВНУТРЕННЕЕ СОЕДИНЕНИЕ тОбъектыУчетаДокументовЭДО КАК тОбъектыУчетаДокументовЭДО
		|		ПО СообщениеЭДО.ЭлектронныйДокумент = тОбъектыУчетаДокументовЭДО.ЭлектронныйДокумент
		|			ВНУТРЕННЕЕ СОЕДИНЕНИЕ Справочник.СообщениеЭДОПрисоединенныеФайлы КАК СообщениеЭДОПрисоединенныеФайлы
		|			ПО СообщениеЭДО.ОсновнойФайл = СообщениеЭДОПрисоединенныеФайлы.Ссылка
		|ГДЕ
		|	СообщениеЭДО.ЭлектронныйДокумент В (ВЫБРАТЬ ЭлектронныйДокумент ИЗ тОбъектыУчетаДокументовЭДО)";
	
	Если ЗначениеЗаполнено(ИзмененныеПосле) Тогда
		Запрос.Текст = Запрос.Текст + "
		|	И (СообщениеЭДОПрисоединенныеФайлы.ДатаМодификацииУниверсальная > &ИзмененныеПосле
		|	ИЛИ СообщениеЭДОПрисоединенныеФайлы.ДатаСоздания > &ИзмененныеПосле)";
	КонецЕсли;
	Если ЗначениеЗаполнено(ИменаФайлов) Тогда
		Запрос.Текст = Запрос.Текст + Символы.ПС + " И (
			|	ВЫБОР
			|		КОГДА СообщениеЭДОПрисоединенныеФайлы.Расширение = """"
			|			ТОГДА СообщениеЭДОПрисоединенныеФайлы.Наименование В (&ИменаФайлов)
			|		ИНАЧЕ
			|			СообщениеЭДОПрисоединенныеФайлы.Наименование + "".""
			|			+ СообщениеЭДОПрисоединенныеФайлы.Расширение В (&ИменаФайлов)
			|	КОНЕЦ ) ";
	КонецЕсли;
	
	Если ТипЗнч(Объект) = Тип("Массив") Тогда
		ОбъектыУчета = Объект;
	Иначе
		ОбъектыУчета = Новый Массив;
		ОбъектыУчета.Добавить(Объект);
	КонецЕсли;
	
	Попытка
		Запрос.Параметры.Вставить("ОбъектыУчета", ОбъектыУчета);
		Если ЗначениеЗаполнено(ИзмененныеПосле) Тогда
			Запрос.УстановитьПараметр("ИзмененныеПосле", ИзмененныеПосле);
		КонецЕсли;
		Если ЗначениеЗаполнено(ИменаФайлов) Тогда
			Запрос.УстановитьПараметр("ИменаФайлов", ИменаФайлов);
		КонецЕсли;
		Возврат ТаблицаЗначенийВМассив(Запрос.Выполнить().Выгрузить());
	Исключение
		ВызватьИсключение("Ошибка получения прикрепленных файлов ЭДО. Не удалось выполнить запрос.");
	КонецПопытки
	
КонецФункции


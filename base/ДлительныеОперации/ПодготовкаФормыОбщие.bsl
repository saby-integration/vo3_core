
&НаКлиенте
Процедура ЗапуститьINIФоновымЗаданием(ini_name, ПараметрыВызоваИни, context_params = Неопределено,
		ФормаВладелец = Неопределено, ЗаголовокФормы = "") Экспорт
	
//	МодульОбъекта = ПолучитьМодульОбъекта();
	
	ПараметрыВызова = ПодготовитьПараметрыЗапускINIФоновымЗаданиемНаСервере(ini_name, ПараметрыВызоваИни, context_params);
	
	ОповещениеОЗакрытииФормыФоновогоЗадания = Неопределено;	
	Если context_params <> Неопределено Тогда
		context_params.Свойство("ОповещениеОЗакрытииФормыФоновогоЗадания", ОповещениеОЗакрытииФормыФоновогоЗадания);
		context_params.Удалить("ОповещениеОЗакрытииФормыФоновогоЗадания");
	КонецЕсли;
	
	ЗаполнитьПутьОбработкиДляВыполненияФоновогоЗадания();
	ПараметрыДлительныеОперации = Новый Структура;
	ПараметрыДлительныеОперации.Вставить("ИмяОбработки",		ИмяОбработки);
	ПараметрыДлительныеОперации.Вставить("ИмяМетода",			"API_BLOCKLY_RUN_BACKGROUND");
	ПараметрыДлительныеОперации.Вставить("ПараметрыВыполнения",	ПараметрыВызова);
	ПараметрыДлительныеОперации.Вставить("ЭтоВнешняяОбработка",	ЭтоВнешняяОбработка());
	
	ВыполняемыйМетод = "ДлительныеОперации.ВыполнитьПроцедуруМодуляОбъектаОбработки";
	
	ПараметрыЗадания = Новый Массив;
	ПараметрыЗадания.Добавить(ПараметрыДлительныеОперации);
	ПараметрыЗадания.Добавить("");

	ОткрытьФормуДлительнойОперации(ВыполняемыйМетод,ПараметрыЗадания, ЗаголовокФормы, ФормаВладелец,ОповещениеОЗакрытииФормыФоновогоЗадания); 


КонецПроцедуры

&НаКлиенте
Процедура ОткрытьФормуДлительнойОперации(ФоновоеЗаданиеИмяМетода, ФоновоеЗаданиеПараметры,
		ФоновоеЗаданиеНаименование, Владелец, ОповещениеОЗакрытииФормы = Неопределено) Экспорт
   	Сообщение = Новый Структура("Показать, Пояснение, Текст, НавигационнаяСсылка", Истина, ФоновоеЗаданиеНаименование, "Выполняется...");

	ПараметрыФормы = Новый Структура;
	ПараметрыФормы.Вставить("АдресДополнительногоРезультата");
	ПараметрыФормы.Вставить("АдресРезультата");
	ПараметрыФормы.Вставить("ВыводитьОкноОжидания", Истина);
	ПараметрыФормы.Вставить("ВыводитьПрогрессВыполнения", Истина);
	ПараметрыФормы.Вставить("ВыводитьСообщения", Истина);
	ПараметрыФормы.Вставить("ИдентификаторЗадания", Новый УникальныйИдентификатор);
	ПараметрыФормы.Вставить("Интервал", 1);
	ПараметрыФормы.Вставить("ОжидатьЗавершение", Ложь);
	ПараметрыФормы.Вставить("ОповещениеПользователя", Сообщение);
	ПараметрыФормы.Вставить("ПолучатьРезультат", Ложь);
	ПараметрыФормы.Вставить("ТекстСообщения", ФоновоеЗаданиеНаименование);
	ПараметрыФормы.Вставить("ФоновоеЗаданиеИмяМетода", ФоновоеЗаданиеИмяМетода);
	ПараметрыФормы.Вставить("ФоновоеЗаданиеПараметры", ФоновоеЗаданиеПараметры);
	ПараметрыФормы.Вставить("ФоновоеЗаданиеНаименование", ФоновоеЗаданиеНаименование);
	ИмяФормыДлительнойОперации = ТипМетаданныхОбработки()+".SABY.Форма.ДлительнаяОперация";
		
	ОткрытьФорму(ИмяФормыДлительнойОперации, 
		ПараметрыФормы,
		Владелец,
		Новый УникальныйИдентификатор(),
		,
		,
		ОповещениеОЗакрытииФормы, 
		РежимОткрытияОкнаФормы.Независимый);

КонецПроцедуры

&НаСервере
Функция ПодготовитьПараметрыЗапускINIФоновымЗаданиемНаСервере(ini_name, ПараметрыВызоваИни, context_params = Неопределено)
	МодульОбъекта = ПолучитьМодульОбъекта();
	Возврат МодульОбъекта.ПодготовитьПараметрыЗапускINIФоновымЗаданием(ini_name, ПараметрыВызоваИни, context_params)
КонецФункции

&НаСервере
Функция ИмяФайлаОбработки()
	Возврат РеквизитФормыВЗначение("Объект").ИспользуемоеИмяФайла;	
КонецФункции 

&НаСервереБезКонтекста
Функция КопияОбработкиНаСервере(Хранение)
	Результат = ПолучитьИмяВременногоФайла();
	ДвоичныеДанные = ПолучитьИзВременногоХранилища(Хранение);
	ДвоичныеДанные.Записать(Результат);	
	Возврат Результат;
КонецФункции

&НаСервере
Функция ИмяОбработки()
	Возврат РеквизитФормыВЗначение("Объект").Метаданные().Имя; 
КонецФункции

&НаСервере
Функция ЗапуститьФоновоеЗадание(ПараметрыЗаданияОбработки, ИмяМетода, НаименованиеФоновогоЗадания) 
	ПараметрыЗадания = Новый Структура;
	ПараметрыЗадания.Вставить("ИмяОбработки",			ИмяОбработки);
	ПараметрыЗадания.Вставить("ИмяМетода",				ИмяМетода);
	ПараметрыЗадания.Вставить("ПараметрыВыполнения",	ПараметрыЗаданияОбработки);
	ПараметрыЗадания.Вставить("ЭтоВнешняяОбработка",	ЭтоВнешняяОбработка());
	
	УникальныйИдентификаторЗадания = Новый УникальныйИдентификатор;
	
	ВыполняемыйМетод = "ДлительныеОперации.ВыполнитьПроцедуруМодуляОбъектаОбработки";
	
	ПараметрыДлительныеОперации = Новый Массив();
	ПараметрыДлительныеОперации.Добавить(ПараметрыЗадания);
	ПараметрыДлительныеОперации.Добавить("");
	
	ФоновоеЗадание = ФоновыеЗадания.Выполнить(ВыполняемыйМетод, ПараметрыДлительныеОперации, Строка(УникальныйИдентификаторЗадания), НаименованиеФоновогоЗадания);
	ИдентификаторЗадания = ФоновоеЗадание.УникальныйИдентификатор;
КонецФункции
	

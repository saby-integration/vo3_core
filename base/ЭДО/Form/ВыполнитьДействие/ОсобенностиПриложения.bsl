
#Область include_core_base_locale_ЛокализацияНазваниеПродукта
#КонецОбласти

#Область include_core_base_Helpers_РаботаСоСвойствамиСтруктуры
#КонецОбласти

#Область include_core_base_ExtException
#КонецОбласти

&НаСервере
Процедура ДобавитьДействияНаФорму(СписокДействий)

	Если СписокДействий = Неопределено Тогда
		Возврат;
	КонецЕсли;

	ПараметрыДействий			= Новый Структура();
	ГруппаДействийДокумента   	= Элементы.Найти("ГруппаДействийДокумента");
	ГруппаПереотправка        	= Элементы.Найти("ГруппаПереотправка");
	ЭлементРазделитель			= Элементы.Найти("Разделитель");

	ДействиеПоУмолчанию       = Неопределено;
	ТребуетсяВыборИсполнителя = Ложь;
	ТребуетсяКомментарий = Ложь;

	СчётКоманд	= 0;
	Для Каждого Действие Из СписокДействий Цикл
		СчётКоманд	= СчётКоманд + 1;
		ИмяДействия = "Действие_" + Формат(СчётКоманд, "ЧГ=0");
		ПараметрыДействий.Вставить(ИмяДействия, Действие);

		НоваяКоманда          = ЭтаФорма.Команды.Добавить(ИмяДействия);
		НоваяКоманда.Действие = "КомандаВыполнитьДействие";

		КнопкаДействие = Элементы.Вставить("Кнопка_" + ИмяДействия, Тип("КнопкаФормы"), ГруппаДействийДокумента, ЭлементРазделитель);

		КнопкаДействие.Заголовок  = Действие["Название"]; ;
		КнопкаДействие.ИмяКоманды = НоваяКоманда.Имя;

		КнопкаДействие.Отображение = ОтображениеКнопки.КартинкаИТекст;
		Если ДействиеПоУмолчанию = Неопределено Тогда
			КнопкаДействие.КнопкаПоУмолчанию = Истина;
			ДействиеПоУмолчанию = ИмяДействия;
		КонецЕсли;

		КнопкаДействие.Картинка		= БиблиотекаКартинок.Saby_Отступ;
		Если ВРег(Действие["ТребуетИсполнителя"]) = "ДА" Тогда
			ТребуетсяВыборИсполнителя = Истина;
			КнопкаДействие.Отображение	= ОтображениеКнопки.КартинкаИТекст;
			КнопкаДействие.Картинка		= БиблиотекаКартинок.Saby_ТребуетсяИсполнитель;
		КонецЕсли;
		Если ВРег(Действие["ТребуетКомментария"]) = "ДА" Тогда	
			ТребуетсяКомментарий = Ложь;
			КнопкаДействие.Отображение	= ОтображениеКнопки.КартинкаИТекст;
			КнопкаДействие.Картинка		= БиблиотекаКартинок.Saby_ТребуетсяКомментарий;
		КонецЕсли;
		Если ТребуетсяВыборИсполнителя И ТребуетсяКомментарий Тогда	
			КнопкаДействие.Отображение	= ОтображениеКнопки.КартинкаИТекст;
			КнопкаДействие.Картинка		= БиблиотекаКартинок.Saby_ТребуетсяКомментарийИИсполнителя;
		КонецЕсли;

		Если ВРег(Действие["ТребуетПодписания"]) = "ДА" Тогда
			Попытка
				КнопкаДействие.Картинка	= БиблиотекаКартинок["Saby_SignBlue"];
			Исключение
				КнопкаДействие.Картинка	= БиблиотекаКартинок.ЭлектронноЦифроваяПодпись;
			КонецПопытки
		КонецЕсли;
		КнопкаДействие.РастягиватьПоГоризонтали	= Истина;

	КонецЦикла;

	Если Не ТребуетсяВыборИсполнителя Тогда
		Элементы.EmployeeCmd.Видимость = Ложь;
		Элементы.СписокИсполнителей.Видимость = Ложь;
	КонецЕсли;

КонецПроцедуры

//Одна процедура для всех команд
&НаКлиенте
Процедура КомандаВыполнитьДействие(Команда)

	ИмяДействия	= Команда.Имя;
	ПараметрыДействия = ПараметрыДействий[ИмяДействия];
	НазваниеДействия = ПараметрыДействия["Название"];
	Элементы.Комментарий.ОтметкаНезаполненного = Ложь;
	Элементы.СписокИсполнителей.ОтметкаНезаполненного = Ложь;
	Действие = Новый Структура("Название, Комментарий, Исполнители", НазваниеДействия, Комментарий, Новый Массив);

	Если ВРег(ПараметрыДействия["ТребуетКомментария"]) = "ДА" Тогда
		Если Не ЗначениеЗаполнено(Комментарий) Тогда
			Элементы.Комментарий.ОтметкаНезаполненного = Истина;
		КонецЕсли;
	КонецЕсли;

	Если ВРег(ПараметрыДействия["ТребуетИсполнителя"]) = "ДА" Тогда
		Если СписокИсполнителей.Количество() = 0 Тогда
			Элементы.СписокИсполнителей.ОтметкаНезаполненного = Истина;
		Иначе
			мИсполнителей = Новый Массив;
			Для Каждого ВыбранныйСотрудник Из СписокИсполнителей Цикл
				Если ЗначениеЗаполнено(ВыбранныйСотрудник.Сотрудник) Тогда
					мИсполнителей.Добавить(СокрЛП(ВыбранныйСотрудник.Сотрудник));
				КонецЕсли;
			КонецЦикла;
			Если мИсполнителей.Количество() = 0 Тогда
				Элементы.Комментарий.ОтметкаНезаполненного = Истина;
			Иначе
				Действие.Вставить("Исполнители", мИсполнителей);
			КонецЕсли;
		КонецЕсли;
	КонецЕсли;

	Если Элементы.Комментарий.ОтметкаНезаполненного
		Или Элементы.СписокИсполнителей.ОтметкаНезаполненного Тогда
		Возврат;
	КонецЕсли;

	ПараметрыВызова["Действие"] = ПараметрыДействия;
	ПараметрыВызова["Действие"]["Название"] = Действие["Название"];
	ПараметрыВызова["Действие"]["Комментарий"] = Действие["Комментарий"];
	ПараметрыВызова["Действие"]["Исполнители"] = Действие["Исполнители"];

	Контекст = Новый Структура;
	Контекст.Вставить("context_params", context_params);
	Контекст.Вставить("ПараметрыДействия", ПараметрыДействия);
	ОбработчикРезультата = Новый ОписаниеОповещения(
		"КомандаВыполнитьДействиеПослеОбновленияКэшаЛокальныхСертификатов", ЭтотОбъект, Контекст);

	ОбновитьКэшЛокальныхСертификатов(ОбработчикРезультата);

КонецПроцедуры

&НаКлиенте
Процедура ДобавитьВложениеСДиска(Команда)
	СтандартнаяОбработка = Ложь;
	Диалог = Новый ДиалогВыбораФайла(РежимДиалогаВыбораФайла.Открытие);
	Диалог.Фильтр = НСтр("ru=’Любой файл (*.*)|*.*'");
	Диалог.Заголовок = НСтр("ru=’Выберите файл'");
	Диалог.МножественныйВыбор = Истина;
	ОбработкаОкончанияЗагрузки = Новый ОписаниеОповещения("ВыборФайлаЗавершение", ЭтаФорма, Диалог);
	НачатьПомещениеФайлов(ОбработкаОкончанияЗагрузки, , Диалог, Истина, УникальныйИдентификатор);
КонецПроцедуры


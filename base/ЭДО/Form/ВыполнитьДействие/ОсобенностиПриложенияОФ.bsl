
Процедура ПередОткрытием(Отказ, СтандартнаяОбработка)
	ВложенияПоТипамОбъектов1С.Колонки.Добавить("Представление");
	ВложенияПоТипамОбъектов1С.Колонки.Добавить("ОтметкаВыбора");
	ВложенияПоТипамОбъектов1С.Колонки.Добавить("ИндексКартинки");
	ВложенияПоТипамОбъектов1С.Колонки.Добавить("Команда");
	// На форме обычного приложения "Команда" имеет тип - Строка и назначить ей тип - Струкртура невозможно
	// поэтому для удаления вложений доболнительно будет колонка с полныи именем файла
	ВложенияПоТипамОбъектов1С.Колонки.Добавить("ПолноеИмяФайла");
	ВложенияПоТипамОбъектов1С.Колонки.Добавить("ТипВложения");
	ВложенияПоТипамОбъектов1С.Колонки.Добавить("ВидОбъекта");
	ВложенияПоТипамОбъектов1С.Колонки.Добавить("СсылкаНаПрисоединенныйФайл");
	
	ПриСозданииНаСервере(Отказ, СтандартнаяОбработка);
	// для ОФ делаем проверку перед открытием, т.к. в ПриОткрытии уже не работает Отказ = Истина и Закрыть()
	Если Не ЗначениеЗаполнено(СписокДействийКоличество)
		И Не ПолучитьЭлементыФормы().ГруппаПереотправка.Видимость Тогда
		
		КартинкаСообщения = БиблиотекаКартинок["Ошибка32"];
				
		ПоказатьОповещениеПользователя(
			"Нет доступных действий",
			,
			"",
			КартинкаСообщения,
			СтатусОповещенияПользователя.Важное,
			Новый УникальныйИдентификатор);
			
		Отказ = Истина;
		Возврат;
			
	КонецЕсли;
КонецПроцедуры

&НаСервере
Процедура ДобавитьДействияНаФорму(СписокДействий)
	
	Если СписокДействий = Неопределено Тогда
		Возврат;
	КонецЕсли;
	
	ЭлемФормы = ПолучитьЭлементыФормыНаСервере();
	
	ПараметрыДействий			= Новый Структура();
	ГруппаДействийДокумента   	= ЭлемФормы.Найти("ГруппаДействийДокумента");
	ГруппаПереотправка        	= ЭлемФормы.Найти("ГруппаПереотправка");
	ЭлементРазделитель			= ЭлемФормы.Найти("Разделитель");
	
	ДействиеПоУмолчанию       = Неопределено;
	ТребуетсяВыборИсполнителя = Ложь;
	
	СчётКоманд	= 0;
	Верх = 1;
	Для Каждого Действие Из СписокДействий Цикл
		СчётКоманд	= СчётКоманд + 1;
		ИмяДействия = "Действие_" + Формат(СчётКоманд, "ЧГ=0");
		ПараметрыДействий.Вставить(ИмяДействия, Действие);

		//НоваяКоманда          = ЭтаФорма.Команды.Добавить(ИмяДействия);
		//НоваяКоманда.Действие = "КомандаВыполнитьДействие";
		
		//Если ГруппаПереотправка.Видимость Тогда 
		//	КнопкаДействие = ЭлемФормы.Вставить("Кнопка_" + ИмяДействия, Тип("КнопкаФормы"), ГруппаПереотправка, ЭлементРазделитель); 
		//Иначе 
		//	КнопкаДействие = ЭлемФормы.Вставить("Кнопка_" + ИмяДействия, Тип("КнопкаФормы"), ГруппаДействийДокумента);
		//КонецЕсли;
		КнопкаДействие = ЭлемФормы.Добавить(Тип("Кнопка"), ИмяДействия, Истина, ГруппаДействийДокумента);
		
		КнопкаДействие.Заголовок  = Действие["Название"]; 
		УстановитьДействиеНаЭлемент(КнопкаДействие, "Нажатие", "КомандаВыполнитьДействие");
		//КнопкаДействие.ИмяКоманды = НоваяКоманда.Имя;
		
		//КнопкаДействие.Отображение = ОтображениеКнопки.КартинкаИТекст;
		Если ДействиеПоУмолчанию = Неопределено Тогда
			КнопкаДействие.КнопкаПоУмолчанию = Истина;
			ДействиеПоУмолчанию = ИмяДействия;
			КнопкаДействие.ЦветФонаКнопки = Новый Цвет(255, 112, 51);
			КнопкаДействие.ЦветТекстаКнопки = Новый Цвет(255, 255, 255);
			КнопкаДействие.ЦветРамки = Новый Цвет(255, 112, 51);	
			КнопкаДействие.Шрифт = Новый Шрифт("Tahoma", 10);
		Иначе
			КнопкаДействие.ЦветФонаКнопки = Новый Цвет(255, 255, 255);
			КнопкаДействие.ЦветТекстаКнопки = Новый Цвет(0, 0, 0);
			КнопкаДействие.ЦветРамки = Новый Цвет(188, 188, 188);
		КонецЕсли;
		
		Если ВРег(Действие["ТребуетПодписания"]) = "ДА" Тогда 
			КнопкаДействие.Картинка	= БиблиотекаКартинок.ЭлектронноЦифроваяПодпись;
		КонецЕсли;
		
		Если ВРег(Действие["ТребуетИсполнителя"]) = "ДА" Тогда
			ТребуетсяВыборИсполнителя = Истина;	
		КонецЕсли;
		
		КнопкаДействие.Лево = 5;
		КнопкаДействие.Верх = Верх;
		КнопкаДействие.Высота = 25;
		КнопкаДействие.Ширина = 375;
		Верх = Верх + 30
		//КнопкаДействие.РастягиватьПоГоризонтали	= Истина; 
		
	КонецЦикла;  
	
	Если Не ТребуетсяВыборИсполнителя Тогда
		ЭлемФормы.EmployeeCmd.Видимость = Ложь;
		ЭлемФормы.СписокИсполнителей.Видимость = Ложь;
	КонецЕсли; 
	
	СтараяВысотаПанели = ГруппаДействийДокумента.Высота;
	НоваяВысотаПанели = Макс(СтараяВысотаПанели, Верх + ГруппаПереотправка.Высота + 10);
	Дельта = НоваяВысотаПанели - СтараяВысотаПанели;
	ЭтаФорма.Высота = ЭтаФорма.Высота + Дельта;
	ГруппаДействийДокумента.Высота = НоваяВысотаПанели;
	ГруппаПереотправка.Верх = Верх;
	
	// Для программного сброса отображения формы. Замена действия: Окно - Восстановить положение окна
	КлючСохраненияПоложенияОкна = Новый УникальныйИдентификатор; 
	
КонецПроцедуры

// Одна процедура для всех команд
//
// Параметры:
//  Команда - Команда.
//
&НаКлиенте
Процедура КомандаВыполнитьДействие(Команда)
	
	ИмяДействия	= Команда.Имя;
	ПараметрыДействия	= ПараметрыДействий[ИмяДействия];
	НазваниеДействия = ПараметрыДействия["Название"];
	ЭлемФормы = ПолучитьЭлементыФормы();
	ЭлемФормы.Комментарий.ОтметкаНезаполненного = Ложь;
	//ЭлемФормы.СписокИсполнителей.ОтметкаНезаполненного = Ложь;
	Действие = Новый Структура("Название, Комментарий, Исполнители", НазваниеДействия, Комментарий, Новый Массив);
	
	Если ВРег(ПараметрыДействия["ТребуетКомментария"]) = "ДА" Тогда
		Если Не ЗначениеЗаполнено(Комментарий) Тогда
			ЭлемФормы.Комментарий.ОтметкаНезаполненного = Истина;
		КонецЕсли;
	КонецЕсли;

	Если ВРег(ПараметрыДействия["ТребуетИсполнителя"]) = "ДА" Тогда 			
		мИсполнителей = Новый Массив;
		Для Каждого ВыбранныйСотрудник Из СписокИсполнителей Цикл
			Если ЗначениеЗаполнено(ВыбранныйСотрудник.Сотрудник) Тогда
				мИсполнителей.Добавить(СокрЛП(ВыбранныйСотрудник.Сотрудник));
			КонецЕсли;
		КонецЦикла;
		Если мИсполнителей.Количество() = 0 Тогда
			ЭлемФормы.Комментарий.ОтметкаНезаполненного = Истина;
		Иначе
			Действие.Вставить("Исполнители", мИсполнителей);
		КонецЕсли;
	КонецЕсли;

	//Если ЭлемФормы.Комментарий.ОтметкаНезаполненного
	//	Или ЭлемФормы.СписокИсполнителей.ОтметкаНезаполненного Тогда
	//	Возврат;
	//КонецЕсли;
	
	ПараметрыВызова["Действие"] = ПараметрыДействия;
	ПараметрыВызова["Действие"]["Название"] = Действие["Название"];
	ПараметрыВызова["Действие"]["Комментарий"] = Действие["Комментарий"];
	ПараметрыВызова["Действие"]["Исполнители"] = Действие["Исполнители"];
	
	Контекст = Новый Структура;
	Контекст.Вставить("context_params", context_params);
	Контекст.Вставить("ПараметрыДействия", ПараметрыДействия);
	ОбработчикРезультата = Новый ОписаниеОповещения(
		"КомандаВыполнитьДействиеПослеОбновленияКэшаЛокальныхСертификатов", ЭтаФорма, Контекст);
	
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
	НачатьПомещениеФайлов(ОбработкаОкончанияЗагрузки, , Диалог, Истина);
КонецПроцедуры

&НаКлиенте
Процедура ВложенияТипаДокументаПриИзменении(Элемент)
КонецПроцедуры

Процедура ВложенияТипаДокументаПередУдалением(Элемент, Отказ)
	ЭлементыФормочки = ПолучитьЭлементыФормы();
	ДанныеСтроки = ЭлементыФормочки.ВложенияТипаДокумента.ТекущиеДанные;
	Если ДанныеСтроки = Неопределено ИЛИ ДанныеСтроки.ТипВложения = "ПечатнаяФорма" Тогда
		Отказ = Истина;
		Возврат;
	КонецЕсли;
	//Удаление из общей таблицы
	УдалитьВложениеИзТаблицы("ВложенияПоТипамОбъектов1С", ДанныеСтроки);
	//Удаление из таблицы на форме
	УдалитьВложениеИзТаблицы("ВложенияТекущегоТипаОбъекта1С", ДанныеСтроки);
КонецПроцедуры


#Область include_core_base_ОбщийМодульКонфигурации
#КонецОбласти

&НаКлиенте
Процедура УдалитьВложениеИзТаблицы(ИмяТаблицы, ДанныеУдаления)
	ОтборСтрок = Новый Структура("ТипВложения, Представление, ПолноеИмяФайла",
		"ФайлСДиска",
		ДанныеУдаления.Представление,
		ДанныеУдаления.ПолноеИмяФайла);
	мСтрокКУдалению = ЭтаФорма[ИмяТаблицы].НайтиСтроки(ОтборСтрок);
	Если мСтрокКУдалению.Количество() > 0 Тогда
		//удаляем обратным перебором, т.к. индекс строк меняется
		ВсегоСтрок = мСтрокКУдалению.Количество() - 1;
		Для СчетСтрок = 0 По ВсегоСтрок Цикл
			СтрокаКУдалению = мСтрокКУдалению[ВсегоСтрок - СчетСтрок];
			ЭтаФорма[ИмяТаблицы].Удалить(СтрокаКУдалению);
		КонецЦикла;
	КонецЕсли;
КонецПроцедуры	

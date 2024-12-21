
Процедура ДобавитьКомандыНаПанельОпераций(ЭлемПанельОпераций, КомандыПанели)
	Для Каждого Команда Из КомандыПанели Цикл
		// Поле поиска
		Если Команда["Type"] = "Search" Тогда
			ДобавитьПолеПоискаНаПанельОпераций(ЭлемПанельОпераций, Команда);
			Продолжить;
		// Выпадающее меню	
		ИначеЕсли Команда["Type"] = "Menu" Тогда
			ДобавитьМенюНаПанельОпераций(ЭлемПанельОпераций, Команда);
			Продолжить;
		// Кнопка с командой	
		Иначе
			ДобавитьКнопкаСКомандойНаПанельОпераций(Команда, ЭлемПанельОпераций);	
		КонецЕсли;
	КонецЦикла
КонецПроцедуры

Процедура ДобавитьПолеПоискаНаПанельОпераций(ЭлемПанельОпераций, Команда) 
	ЭлемФормы = ПолучитьЭлементыФормыНаСервере();
	
	Если НЕ Найти(ЭтаФорма.ИмяФормы, "ГлавноеОкно") И НЕ Найти(ЭтаФорма.ИмяФормы, "ДиалогВыбораИзСписка") Тогда
		Возврат;
	КонецЕсли;
	Элем = ЭлемФормы.Найти("ФильтрМаска");
	Если Элем = Неопределено Тогда
		Элем = ДобавитьЭлементФормы("ФильтрМаска", Тип("ПолеФормы"), ЭлемПанельОпераций, Истина);
		Элем.Вид = ВидПоляФормы.ПолеВвода;
		УстановитьДействиеНаЭлемент(Элем, "ПриИзменении", "ПоискНажатие");
		УстановитьДействиеНаЭлемент(Элем, "НачалоВыбора", "ПоискНачалоВыбораНажатие");
		Элем.КнопкаОчистки = Истина;
		Элем.Ширина = 15;
		Элем.КартинкаКнопкиВыбора = ЭлемФормы["Поиск"].Картинка;
		Элем.ВертикальноеПоложение = ВертикальноеПоложениеЭлемента.Центр;
		Элем.ПутьКДанным = "ФильтрМаска";
		Элем.ПоложениеЗаголовка = ПоложениеЗаголовкаЭлементаФормы.Нет;
		Элем.РастягиватьПоГоризонтали = Ложь;				
		Элем.КнопкаВыбора = Истина;
		Элем.Подсказка = "Введите текст для поиска";
		Элем.ПодсказкаВвода = "Поиск";
	КонецЕсли;
	Элем.Видимость = Истина;
КонецПроцедуры

Процедура ДобавитьМенюНаПанельОпераций(ЭлемПанельОпераций, Команда) 
	ЭлемФормы = ПолучитьЭлементыФормыНаСервере();
	
	Элем = ЭлемФормы.Найти(Команда["Name"]);
	Если Элем = Неопределено Тогда
		Элем = ДобавитьЭлементФормы(Команда["Name"], Тип("ГруппаФормы"), ЭлемПанельОпераций, Истина);
		Элем.Вид = ВидГруппыФормы.Подменю;
	КонецЕсли;
	Элем.Заголовок = Команда["Title"];
	Элем.Видимость = Истина;
	Элем.ЦветФона = Новый Цвет(255, 255, 255);
	Элем.ЦветТекстаЗаголовка = Новый Цвет(0, 0, 0);
	Элем.ЦветРамки = Новый Цвет(188, 188, 188);
	Элем.Ширина = Макс(СтрДлина(Команда["Title"]), 10);
		
	Для Каждого ВложеннаяКоманда Из Команда["Commands"] Цикл
		ПунктМеню = ЭлемФормы.Найти(ВложеннаяКоманда["Name"]);
		Если ПунктМеню = Неопределено Тогда
			ПунктМеню = ДобавитьЭлементФормы(ВложеннаяКоманда["Name"], Тип("КнопкаФормы"), Элем, Истина);
			КомандаКнопки = Команды.Найти(ВложеннаяКоманда["Name"]);
			Если КомандаКнопки = Неопределено Тогда
				КомандаКнопки = Команды.Добавить(ВложеннаяКоманда["Name"]);
				КомандаКнопки.Заголовок = ВложеннаяКоманда["Title"];
				КомандаКнопки.Действие  = ВложеннаяКоманда["Action"];
			КонецЕсли;
		КонецЕсли;
		ПунктМеню.ИмяКоманды = КомандаКнопки["Имя"];
		КартинкаПуть = get_prop(ВложеннаяКоманда, "Icon");
		Если КартинкаПуть <> Неопределено Тогда
			УстановитьКартинку(ПунктМеню, КартинкаПуть);
		Иначе
			ПунктМеню.Картинка = Новый Картинка();
		Конецесли;
	КонецЦикла;
КонецПроцедуры

Процедура ДобавитьКнопкаСКомандойНаПанельОпераций(Команда, ЭлемПанельОпераций)
	ЭлемФормы = ПолучитьЭлементыФормыНаСервере();
	Элем = ЭлемФормы.Найти(Команда["Name"]);
	Если Элем = Неопределено Тогда
		Элем = ДобавитьЭлементФормы(Команда["Name"], Тип("КнопкаФормы"), ЭлемПанельОпераций, Истина);
		КомандаКнопки = Команды.Найти(Команда["Name"]);
		Если КомандаКнопки = Неопределено Тогда
			КомандаКнопки = Команды.Добавить(Команда["Name"]);
			КомандаКнопки.Заголовок = Команда["Title"];
			КомандаКнопки.Действие  = Команда["Action"];
		КонецЕсли;
		Элем.ИмяКоманды = КомандаКнопки["Имя"];
	КонецЕсли;
	Элем.Заголовок = Команда["Title"];
	Элем.Видимость = Истина;
	Если Команда["DefaultButton"] = "TRUE" Тогда
		Элем.ЦветФона = Новый Цвет(255, 112, 51);
		Элем.ЦветТекста = Новый Цвет(255, 255, 255);
		Элем.ЦветРамки = Новый Цвет(255, 112, 51);	
		Элем.Шрифт = Новый Шрифт("Tahoma", 10);
	Иначе
		Элем.ЦветФона = Новый Цвет(255, 255, 255);
		Элем.ЦветТекста = Новый Цвет(0, 0, 0);
		Элем.ЦветРамки = Новый Цвет(188, 188, 188);
	КонецЕсли;
	Элем.Ширина = Макс(СтрДлина(Команда["Title"]), 10);
	КартинкаПуть = get_prop(Команда, "Icon");
	Если КартинкаПуть <> Неопределено Тогда
		УстановитьКартинку(Элем, КартинкаПуть);
		УстановитьОтображение(Элем, Команда["Title"]);
		Если СтрДлина(Команда["Title"]) = 0 Тогда 
			Элем.Ширина = 3;
		Иначе 
			Элем.Ширина = Элем.Ширина + 3;
		КонецЕсли;	
	Иначе
		Элем.Картинка = Новый Картинка();
	КонецЕсли;
	Если get_prop(Команда, "Properties") <> Неопределено Тогда
		Для Каждого СвойствоПоля Из Команда["Properties"] Цикл
			Элем[СвойствоПоля.Ключ] = СвойствоПоля.Значение;
		КонецЦикла;
	КонецЕсли;	
КонецПроцедуры

&НаСервере
Процедура УстановитьОтображение(Элем, Название)
	Если ЗначениеЗаполнено(Название) Тогда
		Элем.Отображение = ОтображениеКнопки.КартинкаИТекст;
	Иначе
		Элем.Отображение = ОтображениеКнопки.Картинка;
	КонецЕсли;
КонецПроцедуры


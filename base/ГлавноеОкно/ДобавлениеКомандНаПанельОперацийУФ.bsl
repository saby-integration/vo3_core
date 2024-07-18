Процедура ДобавитьКомандыНаПанельОпераций(ЭлемПанельОпераций, КомандыПанели)
	ЭлемФормы = ПолучитьЭлементыФормыНаСервере();
	Для Каждого Команда Из КомандыПанели Цикл
		// Элементы поиска
		Если Команда["Type"] = "Search" Тогда
			Если НЕ Найти(ЭтаФорма.ИмяФормы, "ГлавноеОкно") И НЕ Найти(ЭтаФорма.ИмяФормы, "ДиалогВыбораИзСписка") Тогда
				Продолжить;
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
			Продолжить;
		КонецЕсли;
		// Элементы команды
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
			Элем.Ширина = Элем.Ширина + 5;
		Иначе
			Элем.Картинка = Новый Картинка();
		Конецесли;
		Если get_prop(Команда, "Properties") <> Неопределено Тогда
			Для Каждого СвойствоПоля Из Команда["Properties"] Цикл
				Элем[СвойствоПоля.Ключ] = СвойствоПоля.Значение;
			КонецЦикла;
		КонецЕсли;
	КонецЦикла
КонецПроцедуры

&НаСервере
Процедура УстановитьОтображение(Элем, Название)
	Если ЗначениеЗаполнено(Название) Тогда
		Элем.Отображение = ОтображениеКнопки.КартинкаИТекст;
	Иначе
		Элем.Отображение = ОтображениеКнопки.Картинка;
	КонецЕсли;
КонецПроцедуры


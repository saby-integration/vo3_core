
Процедура ДобавитьКомандыНаПанельОпераций(ЭлемПанельОпераций, КомандыПанели, Лево) 
	Для Каждого Команда Из КомандыПанели Цикл
		// Поле поиска
		Если Команда["Type"] = "Search" Тогда
			ДобавитьПолеПоискаНаПанельОпераций(ЭлемПанельОпераций, Команда, Лево);
			Продолжить;
		// Выпадающее меню	
		ИначеЕсли Команда["Type"] = "Menu" Тогда
			ДобавитьПодменюНаПанельОпераций(ЭлемПанельОпераций, Команда, Лево);
			Продолжить;
		// Кнопка с командой	
		Иначе
			ДобавитьКнопкаСКомандойНаПанельОпераций(Команда, ЭлемПанельОпераций, Лево);	
		КонецЕсли;
	КонецЦикла;
КонецПроцедуры


Процедура ДобавитьПолеПоискаНаПанельОпераций(ЭлемПанельОпераций, Команда, Лево) 
	ЭлемФормы = ПолучитьЭлементыФормыНаСервере();
	
	Если ИмяФормы <> "ГлавноеОкно" И ИмяФормы <> "ДиалогВыбораИзСписка" Тогда
		Возврат;
	КонецЕсли;
	Элем = ЭлемФормы.Найти("ФильтрМаска");
	Если Элем = Неопределено Тогда
		Элем = ЭлемФормы.Добавить(Тип("ПолеВвода"), "ФильтрМаска", Истина, ЭлемПанельОпераций);
		УстановитьДействиеНаЭлемент(Элем, "ПриИзменении", "ПоискНажатие");
		Элем.Лево = Лево;
		Элем.Верх = 2;
		Элем.Высота = 25;
		Элем.Ширина = 200;
		Элем.КартинкаКнопкиВыбора = ЭлемФормы["Поиск"].Картинка;
		УстановитьДействиеНаЭлемент(Элем, "НачалоВыбора", "ПоискНачалоВыбораНажатие");
		Элем.ВертикальноеПоложение = ВертикальноеПоложение.Центр;
		Элем.Данные = "ФильтрМаска";
		Элем.КнопкаОчистки = Истина;
		Элем.КнопкаВыбора = Истина;
		Элем.Подсказка = "Введите текст для поиска";
	КонецЕсли;
	Лево = Лево + Элем.Ширина + 5;
	Элем.Видимость = Истина;
КонецПроцедуры

Процедура ДобавитьПодменюНаПанельОпераций(ЭлемПанельОпераций, Команда, Лево) 
	ЭлемФормы = ПолучитьЭлементыФормыНаСервере();
	
	ЭлемМеню = ЭлемФормы.Найти(Команда["Name"]);
	Если ЭлемМеню = Неопределено Тогда
		ЭлемМеню = ЭлемФормы.Добавить(Тип("Кнопка"), Команда["Name"], Истина, ЭлемПанельОпераций);	
	КонецЕсли;
	ЭлемМеню.РежимМеню = ИспользованиеРежимаМеню.Использовать;
	
	ЭлемМеню.Заголовок = Команда["Title"];
	ЭлемМеню.Видимость = Истина;
	ЭлемМеню.Шрифт = Новый Шрифт("Tahoma", 10);
	ЭлемМеню.ЦветФонаКнопки = Новый Цвет(255, 255, 255);
	ЭлемМеню.ЦветТекстаКнопки = Новый Цвет(0, 0, 0);
	ЭлемМеню.ЦветРамки = Новый Цвет(188, 188, 188);
	ЭлемМеню.Лево = Лево;
	ЭлемМеню.Верх = 2;
	ЭлемМеню.Высота = 25;
	ЭлемМеню.Ширина = Макс(СтрДлина(Команда["Title"])*7, 33);
	Лево = Лево + ЭлемМеню.Ширина + 5;
	
	ЭлемМеню.Кнопки.Очистить();
	Для Каждого ВложеннаяКоманда Из Команда["Commands"] Цикл
		ПунктМеню = ЭлемМеню.Кнопки.Добавить(ВложеннаяКоманда["Name"], ТипКнопкиКоманднойПанели.Действие, ВложеннаяКоманда["Title"], Новый Действие(ВложеннаяКоманда["Action"]));
		КартинкаПуть = get_prop(ВложеннаяКоманда, "Icon");
		Если КартинкаПуть <> Неопределено Тогда
			УстановитьКартинку(ПунктМеню, КартинкаПуть);
		Конецесли;
	КонецЦикла;
			
КонецПроцедуры

Процедура ДобавитьКнопкаСКомандойНаПанельОпераций(Команда, ЭлемПанельОпераций, Лево)
	ЭлемФормы = ПолучитьЭлементыФормыНаСервере();
	Элем = ЭлемФормы.Найти(Команда["Name"]);
	Если Элем = Неопределено Тогда
		Элем = ЭлемФормы.Добавить(Тип("Кнопка"), Команда["Name"], Истина, ЭлемПанельОпераций);	
	КонецЕсли;
	УстановитьДействиеНаЭлемент(Элем, "Нажатие", Команда["Action"]);
	Элем.Заголовок = Команда["Title"];
	Элем.Видимость = Истина;
	Элем.Шрифт = Новый Шрифт("Tahoma", 10);
	Если Команда["DefaultButton"] = "TRUE" Тогда
		Элем.ЦветФонаКнопки = Новый Цвет(255, 112, 51);
		Элем.ЦветТекстаКнопки = Новый Цвет(255, 255, 255);
		Элем.ЦветРамки = Новый Цвет(255, 112, 51);	
	Иначе
		Элем.ЦветФонаКнопки = Новый Цвет(255, 255, 255);
		Элем.ЦветТекстаКнопки = Новый Цвет(0, 0, 0);
		Элем.ЦветРамки = Новый Цвет(188, 188, 188);
	КонецЕсли;
	Элем.Лево = Лево;
	Элем.Верх = 2;
	Элем.Высота = 25;
	Элем.Ширина = Макс(СтрДлина(Команда["Title"])*7, 33);
	КартинкаПуть = get_prop(Команда, "Icon");
	Если КартинкаПуть <> Неопределено Тогда
		УстановитьКартинку(Элем, КартинкаПуть);
		Элем.Ширина = Элем.Ширина + 37;
	Конецесли;
	Лево = Лево + Элем.Ширина + 5;
	Если get_prop(Команда, "Properties") <> Неопределено Тогда
		Для Каждого СвойствоПоля Из Команда["Properties"] Цикл
			Элем[СвойствоПоля.Ключ] = СвойствоПоля.Значение;
		КонецЦикла;
	КонецЕсли;
КонецПроцедуры

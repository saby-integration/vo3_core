
&НаСервере
Процедура ЗаполнитьКолонкиПлоскогоСписка() Экспорт
	ЭлемФормы = ПолучитьЭлементыФормыНаСервере();
	ИмяТаблицы = ТекущийРаздел["template"]; 
	
	ТабПоле = ЭлемФормы[ИмяТаблицы];
	ТабПоле.Значение.Очистить();
	ТабПоле.Колонки.Очистить();
	ТабПоле.Значение.Колонки.Очистить();
	Поле = ТабПоле.Колонки.Добавить(ИмяТаблицы + "Отмечен", "V");
	ТабПоле.Значение.Колонки.Добавить("Отмечен", Новый ОписаниеТипов("Булево"));
	Поле.УстановитьЭлементУправления(Тип("Флажок"));
	Поле.ДанныеФлажка = "Отмечен";
	Поле.РежимРедактирования = РежимРедактированияКолонки.Непосредственно;
	Поле.Ширина = 4;
	Поле.ИзменениеРазмера = ИзменениеРазмераКолонки.НеИзменять;
	Поле.ОтображатьИерархию = Истина;
	
	ЭлемФормы.ПлоскийСписок.РежимВыделения = РежимВыделенияТабличногоПоля.Одиночный;
	Если get_prop(ТекущийРаздел, "МножественныйВыбор") <> Истина Тогда
		Поле.Видимость = Ложь;
		ЭлемФормы.ОтметитьВсеПлоскийСписок.Видимость = Ложь;
		ЭлемФормы.ОтметитьВсеПлоскийСписок.Доступность = Ложь;
	КонецЕсли;
	
	КвалификаторыСтроки = Новый КвалификаторыСтроки();
	ОписаниеТипаСтрока = Новый ОписаниеТипов("Строка", ,КвалификаторыСтроки);
	Для Каждого Колонка Из ТекущийРаздел.ПараметрыОтображения["Columns"] Цикл
		ОписаниеТипа = ОписаниеТипаСтрока;
		Если get_prop(Колонка, "Type") <> Неопределено Тогда
			ОписаниеТипа = Новый ОписаниеТипов(Колонка["Type"]);
		КонецЕсли;
		Если get_prop(Колонка, "Visibility") = Истина Тогда
			Поле = ТабПоле.Колонки.Добавить(ИмяТаблицы + Колонка["Name"], Колонка["Title"]);
			Поле.Данные = Колонка["Name"];
			Если get_prop(Колонка, "Properties") <> Неопределено Тогда
				Для Каждого СвойствоПоля Из Колонка["Properties"] Цикл
					Поле[СвойствоПоля.Ключ] = СвойствоПоля.Значение;
				КонецЦикла;
			КонецЕсли;
			Если get_prop(Колонка, "More") = Истина Тогда
				Поле = ТабПоле.Колонки.Добавить(ИмяТаблицы + "ЗагрузитьЕще", "Загрузить еще");
				Поле.Данные = "ЗагрузитьЕще";
				Поле.Положение = ПоложениеКолонки.НаСледующейСтроке;
				Поле.Гиперссылка = Истина;
				Поле.ОтображатьВШапке = Ложь;
				Поле.ЦветТекстаПоля = Новый Цвет(0, 85, 187);
				ТабПоле.Значение.Колонки.Добавить("ЗагрузитьЕще", ОписаниеТипа);
			КонецЕсли;
			Картинка = get_prop(Колонка, "RowIcon");
			Если Картинка <> Неопределено Тогда
				//Поле.КартинкиСтрок = Новый Картинка(ПолучитьМодульОбъекта().ПолучитьМакет(Картинка), Истина);
				Поле.КартинкиСтрок = ЭлемФормы[Картинка].Картинка;
				Поле.ЭлементУправления.ТипЗначения = ОписаниеТипа;
			Конецесли;
		КонецЕсли;
		ТабПоле.Значение.Колонки.Добавить(Колонка["Name"], ОписаниеТипа);
	КонецЦикла;
КонецПроцедуры

Процедура ПлоскийСписокПриВыводеСтроки(Элемент, ОформлениеСтроки, ДанныеСтроки)
	Если ДанныеСтроки.ЗагрузитьЕще = "" Тогда
		ОформлениеСтроки.Ячейки.ПлоскийСписокЗагрузитьЕще.Видимость = Ложь;
		Попытка
			Если ОформлениеСтроки.Ячейки.Найти("ПлоскийСписокСтатусСБИС") <> Неопределено Тогда
				Если ДанныеСтроки.СтатусСБИС >= 0 Тогда
					ОформлениеСтроки.Ячейки.ПлоскийСписокСтатусСБИС.ОтображатьКартинку = Истина;
					ОформлениеСтроки.Ячейки.ПлоскийСписокСтатусСБИС.ИндексКартинки = ДанныеСтроки.СтатусСБИС;
				КонецЕсли;
				ОформлениеСтроки.Ячейки.ПлоскийСписокСтатусСБИС.ОтображатьТекст = Ложь;
			КонецЕсли;
		Исключение
		КонецПопытки;
	Иначе
		Для Каждого Ячейка Из ОформлениеСтроки.Ячейки Цикл
			Если Ячейка.Имя <> "ПлоскийСписокЗагрузитьЕще" Тогда
				Ячейка.Видимость = Ложь;	
			КонецЕсли;
		КонецЦикла;
	КонецЕсли;
КонецПроцедуры


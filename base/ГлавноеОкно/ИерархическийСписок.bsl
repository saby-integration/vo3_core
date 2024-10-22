
&НаСервере
Процедура ИерархическийСписокПриОткрытии(ПараметрыОтображения)
	Страница = 0;
	ОчиститьПанельОпераций(ТекущийРаздел.ПараметрыОтображения);
	ОчиститьКонтекстноеМеню();
	ТекущийРаздел.Вставить("ПараметрыОтображения", ПараметрыОтображения);
			
	ЗаполнитьФильтр();
	ЗаполнитьКолонкиИерархическогоСписка();
	ОбновитьСписок(ДанныеФильтра.Значения);
	ДанныеФильтра.ПараметрыОтображения = ПараметрыОтображения["Filter"];
	ОбновитьПанельФильтра();
	ОбновитьПанельОпераций();
	ОбновитьКонтекстноеМеню();
КонецПроцедуры

&НаСервере
Процедура ЗаполнитьДанныеИерархическогоСписка(Таблица, Данные) Экспорт
	МодульОбъекта = ПолучитьМодульОбъекта();
	Список = Данные["Rows"];
	
	Для Каждого Стр Из Список Цикл
		СтрТ = Таблица.Строки.Добавить();
		Для Каждого Колонка Из ТекущийРаздел.ПараметрыОтображения["Columns"] Цикл
			ПутьКДанным = Колонка["Data"];
			СтрТ[Колонка["Name"]] = МодульОбъекта.block_obj_get_path_value(Стр,ПутьКДанным,"");
		КонецЦикла;
		Если СтрТ.Родитель <> Неопределено Тогда
			СтрТ.Отмечен = СтрТ.Родитель.Отмечен;	
		КонецЕсли;
		// Если полученная строка является группой, то создаем 
        // фиктивную подчиненную строку.
        Если Стр.ЭтоГруппа Тогда
            ПерваяКолонка = ТекущийРаздел.ПараметрыОтображения["Columns"][0]["Name"];
            ПодстрокаДерева = СтрТ.Строки.Добавить();
            ПодстрокаДерева[ПерваяКолонка] = "Нет подчиненных";

        КонецЕсли;
	КонецЦикла;
КонецПроцедуры

&НаКлиенте
Процедура ИерархическийСписокПриИзмененииФлажка(Элемент, Колонка) Экспорт
	// Отмечает вложенные записи дерева значений при отметке группы
	ТекущиеДанные = ПолучитьЭлементыФормы().ИерархическийСписок.ТекущиеДанные;
	Если ТекущиеДанные.Отмечен = 2 Тогда
        ТекущиеДанные.Отмечен = 0;
    КонецЕсли;
	ПроставитьПометкиВниз(ТекущиеДанные);
	Родитель = РодительЭлементаДерева(ТекущиеДанные);
    Пока Родитель <> Неопределено Цикл
        Родитель.Отмечен = ?(УстановленноДляВсех(ТекущиеДанные),
            ТекущиеДанные.Отмечен, 2);
        ТекущиеДанные = Родитель;
        Родитель = РодительЭлементаДерева(Родитель);
    КонецЦикла;
КонецПроцедуры

&НаКлиенте
Процедура ПроставитьПометкиВниз(ТекущиеДанные)
	// Отмечает вложенные записи дерева значений при отметке группы
	Потомки = СтрокиЭлементаДереваНаКлиенте(ТекущиеДанные);
	Значение = ТекущиеДанные.Отмечен;
	Для каждого Потомок из Потомки Цикл
		Потомок.Отмечен = Значение;
		ПроставитьПометкиВниз(Потомок);
	КонецЦикла;
КонецПроцедуры

&НаКлиенте
Функция УстановленноДляВсех(ЭлементКоллекции)

    СоседниеЭлементы =
        СтрокиЭлементаДереваНаКлиенте(РодительЭлементаДерева(ЭлементКоллекции));
    Для Каждого ТекЭлемент Из СоседниеЭлементы Цикл
        Если ТекЭлемент.Отмечен <> ЭлементКоллекции.Отмечен Тогда
            Возврат Ложь;
        КонецЕсли;
    КонецЦикла;
    Возврат Истина;

КонецФункции

Функция СписокОтмеченныхЗаписейИерархическийСписок()
	СписокОтмеченных = Новый Массив;
	Отмеченные = Новый Массив;
	ОбходДерева(ИерархическийСписок, Отмеченные);
	Фильтр = ДанныеФильтра.Значения;
	Фильтр.Вставить("Родители", Отмеченные);
	Данные = ПолучитьДанныеСписка(Фильтр);
	Фильтр.Удалить("Родители");
	Возврат СписокОтмеченных;
КонецФункции

&НаСервере
Процедура ОбходДерева(Дерево, Отмеченные)
	Строки = СтрокиЭлементаДерева(Дерево);
	Для Каждого тСтр Из Строки Цикл
		Если тСтр.Отмечен = 0 Тогда
			Продолжить;
		КонецЕсли;
		Если тСтр.Отмечен = 1 Тогда
			Отмеченные.Добавить(тСтр.Ссылка);
			Продолжить;
		КонецЕсли;
		
		Если СтрокиЭлементаДерева(тСтр).Количество()>0 Тогда
			ОбходДерева(тСтр, Отмеченные);
		КонецЕсли;
	КонецЦикла;
КонецПроцедуры

&НаКлиенте
Процедура ОтметитьВсеИерархическийСписокНажатие(Элемент)
	ОтмеченыВсе = Не ОтмеченыВсе;
	Потомки = СтрокиЭлементаДереваНаКлиенте(ИерархическийСписок);
	Для Каждого Потомок Из Потомки Цикл
		Потомок.Отмечен = ОтмеченыВсе;
		ПроставитьПометкиВниз(Потомок);
	КонецЦикла;
КонецПроцедуры


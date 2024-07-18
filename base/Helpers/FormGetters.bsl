
Функция ПолучитьМодульОбъекта()
	Возврат РеквизитФормыВЗначение("Объект");
КонецФункции

&НаКлиенте
Функция ПолучитьЭлементыФормы()
	Возврат Элементы;
КонецФункции

Функция ПолучитьЭлементыФормыНаСервере()
	Возврат Элементы;
КонецФункции

Функция ПолучитьЗначениеЭлемента(ИмяЭлемента)
	Возврат ЭтаФорма[ИмяЭлемента];
КонецФункции

&НаКлиенте
Функция ПутьКФормамОбработки()
	СбисИмяФормы = СтрЗаменить(ЭтаФорма.ИмяФормы, ".", Символы.ПС);
	ПутьКФормам = "";
	Для Счетчик = 1 По СтрЧислоСтрок(СбисИмяФормы)-1 Цикл
	    ПутьКФормам = ПутьКФормам + СтрПолучитьСтроку(СбисИмяФормы, Счетчик) + ".";
	КонецЦикла;
	Возврат ПутьКФормам;
КонецФункции

// BSLLS-off
&НаКлиенте
Функция ПолучитьФормуОбработки(ИмяФормыОбработки, ПутьКФормам, ПараметрыФормы = Неопределено, ВладелецФормы = Неопределено)
	Возврат ПолучитьФорму(ПутьКФормам + ИмяФормыОбработки, ПараметрыФормы, ВладелецФормы);
КонецФункции
// BSLLS-on

Функция ПолучитьСтраницу(Элемент, ИмяСтраницы)
	Возврат Элемент.ПодчиненныеЭлементы[ИмяСтраницы];
КонецФункции

&НаКлиенте
Процедура ОткрытьФормуОбработки(ИмяФормы, ПараметрыФормы = Неопределено, ВладелецФормы = Неопределено, Уникальность=Неопределено, ОписаниеОповещения = Неопределено, РежимОткрытияОкна= Неопределено)
	ОткрытьФорму(ПутьКФормамОбработки() + ИмяФормы, ПараметрыФормы, ВладелецФормы,Уникальность,,,ОписаниеОповещения,РежимОткрытияОкна);
КонецПроцедуры

&НаКлиенте
Функция ЭтотМодуль()
	Возврат ЭтотОбъект;
КонецФункции





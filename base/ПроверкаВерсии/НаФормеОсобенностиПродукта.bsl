
&НаСервере
Процедура ОбновитьИнформациюОбновленияНаСервере(СтатусВерсии)
	ЭлементыФормочки = ПолучитьЭлементыФормыНаСервере();
	ЭлементАктуальнаяВерсия = ЭлементыФормочки.АктуальнаяВерсия;
	Если СтатусВерсии <> Неопределено и ЗначениеЗаполнено(СтатусВерсии.СсылкаДляСкачивания) Тогда
		ЭлементАктуальнаяВерсия.Гиперссылка = Истина;
		ЭлементАктуальнаяВерсия.Подсказка = СтатусВерсии.СсылкаДляСкачивания;
		УстановитьДействиеНаЭлемент(ЭлементАктуальнаяВерсия, "Нажатие", "СкачатьАктуальнуюВерсию");
		ЭлементТекущаяВерсия = ЭлементыФормочки.ТекущаяВерсия;
		ЭлементТекущаяВерсия.Гиперссылка = Истина;
		ЭлементТекущаяВерсия.Подсказка = СтатусВерсии.СсылкаДляСкачивания;
		УстановитьДействиеНаЭлемент(ЭлементТекущаяВерсия, "Нажатие", "СкачатьАктуальнуюВерсию");
	ИначеЕсли СтатусВерсии <> Неопределено и Не ЗначениеЗаполнено(СтатусВерсии.СсылкаДляСкачивания) Тогда
		ЭлементАктуальнаяВерсия.Видимость = Истина;
		ЭлементАктуальнаяВерсия.Подсказка = "";
		ЭлементАктуальнаяВерсия.Гиперссылка = Ложь;
	Иначе
		ЭлементАктуальнаяВерсия.Заголовок = "";
		ЭлементАктуальнаяВерсия.Видимость = Ложь;
		ЭлементАктуальнаяВерсия.Гиперссылка = Ложь;
	КонецЕсли;
КонецПроцедуры


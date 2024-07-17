
Функция ДобавитьЭлементФормы(Имя, Тип, Родитель, Видимость = Истина)
	Возврат Элементы.Добавить(Имя, Тип, Родитель);
КонецФункции

Функция УстановитьДействиеНаЭлемент(Элемент, ИмяДействия, ИмяПроцедуры)
	Элемент.УстановитьДействие(ИмяДействия, ИмяПроцедуры);	
КонецФункции	

Процедура УстановитьHTML(ПолеHTML, ТекстHTML)
	ЭтаФорма[ПолеHTML] = ТекстHTML;
КонецПроцедуры

&НаКлиенте
Процедура ОткрытьВыборИзСписка(СписокВыбора, ОписаниеОповещения, ЭлементФормы = Неопределено)
	ПоказатьВыборИзСписка(ОписаниеОповещения, СписокВыбора, ЭлементФормы);
КонецПроцедуры

&НаКлиенте
Процедура ОбновитьДанныеНаФорме(Форма)
	Форма.ОбновитьОтображениеДанных();
КонецПроцедуры

&НаСервере
Функция ТабличныйДокументПоИмениЭлементаФормыТабличноеПоле(ИмяЭлементаФормы)
	Возврат ЭтотОбъект[ИмяЭлементаФормы];
КонецФункции


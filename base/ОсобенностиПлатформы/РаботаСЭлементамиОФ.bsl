
Функция УстановитьДействиеНаЭлемент(Элемент, ИмяДействия, ИмяПроцедуры)
	Элемент.УстановитьДействие(ИмяДействия, Новый Действие(ИмяПроцедуры));	
КонецФункции	

Процедура УстановитьHTML(ПолеHTML, ТекстHTML)
	ПолучитьЭлементыФормы()[ПолеHTML].УстановитьТекст(ТекстHTML);
КонецПроцедуры

Процедура ОткрытьВыборИзСписка(СписокВыбора, ОписаниеОповещения, ЭлементФормы = Неопределено)
	ВыбранныйЭлемент = ВыбратьИзСписка(СписокВыбора, ЭлементФормы); 
	ВыполнитьОбработкуОповещения(ОписаниеОповещения, ВыбранныйЭлемент);
КонецПроцедуры

Процедура ОбновитьДанныеНаФорме(Форма)
	Форма.Обновить();
КонецПроцедуры



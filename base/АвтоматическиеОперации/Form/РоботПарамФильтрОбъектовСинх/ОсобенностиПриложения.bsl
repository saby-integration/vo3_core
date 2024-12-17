
&НаСервере
Процедура СоздатьЭлементФормы(Название, ТипЗначения, Счетчик = 0, Значение, Представление)
	ДобавляемыеРеквизиты = Новый Массив;
	МассивТипов = Новый Массив;
	МассивТипов.Добавить(Тип(ТипЗначения)); 
	ОписаниеПоля = Новый ОписаниеТипов(МассивТипов);
	НовыйРеквизит = Новый РеквизитФормы(Название,ОписаниеПоля,,Представление); 
	ДобавляемыеРеквизиты.Добавить(НовыйРеквизит); 
	ЭтаФорма.ИзменитьРеквизиты(ДобавляемыеРеквизиты);
	
	НовыйЭлемент = ЭтаФорма.Элементы.Добавить(Название, Тип("ПолеФормы"),Элементы.ГруппаФильтры);
	НовыйЭлемент.Вид = ВидПоляФормы.ПолеВвода;
	НовыйЭлемент.ПутьКДанным = Название;
		
	ЭтаФорма[НовыйРеквизит.Имя] = Значение; 
КонецПроцедуры

&НаСервере
Процедура СобратьФильтры(Фильтр, ПредставлениеФильтра) 
	МодульОбъекта = ПолучитьМодульОбъекта(); 
	Для Каждого Элемент Из Элементы.ГруппаФильтры.ПодчиненныеЭлементы Цикл
		НазваниеФильтра = Элемент.Имя;
		ЗначениеФильтра = ЭтаФорма[НазваниеФильтра];
		Если ЗначениеЗаполнено(ЗначениеФильтра) Тогда
			ПредставлениеФильтра = ПредставлениеФильтра +НазваниеФильтра+": "+ Строка(ЗначениеФильтра)+"; ";
			Api3Object = МодульОбъекта.Api3Object(ЗначениеФильтра,Неопределено,ИСТИНА);	
			Если Фильтр.Получить(НазваниеФильтра) = Неопределено Тогда
				Фильтр.Вставить(НазваниеФильтра, Новый Соответствие);
			КонецЕсли;  
			Фильтр[НазваниеФильтра].Вставить("Api3Link",Api3Object);
		Иначе 	
			Фильтр.Удалить(НазваниеФильтра);	
		КонецЕсли;	
	КонецЦикла;
КонецПроцедуры

#Область include_core_base_Helpers_РаботаСоСвойствамиСтруктуры
#КонецОбласти

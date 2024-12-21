
&НаСервере
Процедура СоздатьТаблицуРезультатыЗапросаАддон() 

	ОписаниеТипа = Новый ОписаниеТипов("ТаблицаЗначений");
	
	ОписаниеСтроки = Новый ОписаниеТипов("Строка");
	ОписаниеДаты = Новый ОписаниеТипов("Дата"); 
	ОписаниеБулево = Новый ОписаниеТипов("Булево");
		
	МассивРеквизитовФормы = Новый Массив;
    МассивРеквизитовФормы.Добавить(Новый РеквизитФормы("РезультатыЗапросаАддон", ОписаниеТипа, "", "РезультатыЗапросаАддон"));
	МассивРеквизитовФормы.Добавить(Новый РеквизитФормы("QueryId", ОписаниеСтроки, "РезультатыЗапросаАддон", "QueryId"));
	МассивРеквизитовФормы.Добавить(Новый РеквизитФормы("ИмяЗапроса", ОписаниеСтроки, "РезультатыЗапросаАддон", "ИмяЗапроса"));
	МассивРеквизитовФормы.Добавить(Новый РеквизитФормы("АдресХранилищаРезультата", ОписаниеСтроки, "РезультатыЗапросаАддон", "АдресХранилищаРезультата"));
	МассивРеквизитовФормы.Добавить(Новый РеквизитФормы("Получено", ОписаниеБулево, "РезультатыЗапросаАддон", "Получено"));
	МассивРеквизитовФормы.Добавить(Новый РеквизитФормы("ФункцияВызова", ОписаниеСтроки, "РезультатыЗапросаАддон", "ФункцияВызова"));
	МассивРеквизитовФормы.Добавить(Новый РеквизитФормы("ПараметрыФункции", ОписаниеСтроки, "РезультатыЗапросаАддон", "ПараметрыФункции"));
	МассивРеквизитовФормы.Добавить(Новый РеквизитФормы("СрокОкончанияЗапроса", ОписаниеДаты, "РезультатыЗапросаАддон", "СрокОкончанияЗапроса"));
	
	ИзменитьРеквизиты(МассивРеквизитовФормы);
КонецПроцедуры

&НаСервере
Функция РезультатПоИмениЗапроса(ИмяЗапроса)  
	Отбор = Новый Структура("ИмяЗапроса,Получено", ИмяЗапроса, Истина);
	СтрокиЗапроса = ЭтотОбъект.РезультатыЗапросаАддон.НайтиСтроки(Отбор);
	Если СтрокиЗапроса.Количество() > 0 Тогда
		Возврат Новый Структура("Ответ", decode_xml_xdto(СтрокиЗапроса[0].АдресХранилищаРезультата));
	КонецЕсли;
	Возврат Неопределено;
КонецФункции	

&НаКлиенте
Функция ВыполнитьЗапросВAddon(ПараметрыЗапроса, ВидЗапроса, ИмяФункции, ПараметрыФункции)
	ТекстЗапроса = ПараметрыЗапроса.ТекстЗапроса;
	QueryId = ПараметрыЗапроса.QueryId;
	ФормаAddon = ПолучитьФормуОбработки("Browser",ПутьКФормамОбработки());
	Если ФормаAddon.Открыта() = Ложь Тогда 
		ФормаAddon.Открыть();
		Возврат ЛОЖЬ;
	КонецЕсли;	
	ФормаAddon.ОтправитьЗапрос(QueryId, ВидЗапроса, ТекстЗапроса);
	НоваяСтрока = ЭтотОбъект.РезультатыЗапросаАддон.Добавить();
	НоваяСтрока.QueryId = QueryId; 
	НоваяСтрока.ИмяЗапроса = ПараметрыЗапроса.ИмяЗапроса; 
	НоваяСтрока.ФункцияВызова = ИмяФункции;
	НоваяСтрока.ПараметрыФункции = ПараметрыФункции; 
	НоваяСтрока.СрокОкончанияЗапроса = ТекущаяДата() + 3*59;
	ПодключитьОбработчикОжидания("ПроверкаВыполненияЗапросов",180,Ложь);
КонецФункции	

&НаКлиенте
Процедура ПроверкаВыполненияЗапросов()
	Отбор = Новый Структура("Получено",  Ложь);
	СтрокиЗапроса = ЭтотОбъект.РезультатыЗапросаАддон.НайтиСтроки(Отбор);
	Проблема = Ложь;
	Если СтрокиЗапроса.Количество() = 0 Тогда
		ОтключитьОбработчикОжидания("ПроверкаВыполненияЗапросов");
		Возврат;
	КонецЕсли;	
	Для Каждого Запись ИЗ СтрокиЗапроса Цикл
		Если Запись.СрокОкончанияЗапроса < ТекущаяДата() Тогда 
			Проблема = Истина;
			Элементы.Страницы.ТекущаяСтраница = Элементы.Страницы.ПодчиненныеЭлементы.ОбновлениеФормы;
			Элементы.Декорация1.Картинка = КартинкаОшибка();
			Элементы.Декорация2.Заголовок = "Проблема выполнения действия. Проверьте настройки addon и повторите операцию";
		КонецЕсли;	
	КонецЦикла;	
КонецПроцедуры

&НаСервере
Функция ОбработатьРезультатЗапроса(РезультатЗапроса)  
	result = get_prop(РезультатЗапроса,"result",Неопределено);;
	АдресРезультата = encode_xdto_xml(result); 
	Возврат АдресРезультата;	
КонецФункции 

&НаКлиенте
Функция ОбработатьРезультатСобытия(Параметры) 
	QueryId = get_prop(Параметры,"uid",Неопределено);
	Если QueryId = Неопределено Тогда
		Возврат Ложь;
	КонецЕсли;
	Отбор = Новый Структура("QueryId", QueryId); 
	
	СтрокиЗапроса = ЭтотОбъект.РезультатыЗапросаАддон.НайтиСтроки(Отбор);
	Если СтрокиЗапроса.Количество() = 0 Тогда
		Возврат Ложь;
	КонецЕсли; 
	result = get_prop(Параметры,"result",Неопределено);
	Если result = Неопределено Тогда
		Возврат Ложь;
	КонецЕсли;	
	ВидЗапроса = get_prop(Параметры,"action","");
	СтрокаЗапроса = СтрокиЗапроса.Получить(0);
	Если ВидЗапроса = "CalcIni" Тогда 
		ОбработкаСобытияВыполненияINI(Параметры);
	Иначе	
		АдресРезультата = ОбработатьРезультатЗапроса(result);
		СтрокаЗапроса.Получено = Истина;
		СтрокаЗапроса.АдресХранилищаРезультата = АдресРезультата;
	КонецЕсли;	
	ИмяФункции = СтрокаЗапроса.ФункцияВызова;
	Если ИмяФункции = "" Тогда 
		Возврат Ложь;
	КонецЕсли; 
	ПараметрыФункции = СтрокаЗапроса.ПараметрыФункции;
	ВыполнитьОтложенныеФункции(ИмяФункции,ПараметрыФункции);	
КонецФункции

&НаСервере
Процедура УдалитьЗаписьПоИмени(ИмяЗапроса)
	Отбор = Новый Структура("ИмяЗапроса,Получено", ИмяЗапроса, Истина);
	МассивСтрок = ЭтотОбъект.РезультатыЗапросаАддон.НайтиСтроки(Отбор);
	Для Каждого ЭлементМассив Из МассивСтрок Цикл
		ЭтотОбъект.РезультатыЗапросаАддон.Удалить(ЭлементМассив); //удаляем строки
	КонецЦикла;
КонецПроцедуры

#Область include_BlocklyExecutor_base_Helper_DecodeEncode
#КонецОбласти


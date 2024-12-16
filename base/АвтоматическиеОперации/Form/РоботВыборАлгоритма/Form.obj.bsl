
#Область ОписаниеПеременных

#КонецОбласти

#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	Если Параметры <> Неопределено Тогда
		Идентификатор = ?(Параметры.Свойство("Идентификатор"),	Параметры.Идентификатор,	""); 
		Версия = ?(Параметры.Свойство("Версия"),			Параметры.Версия,			""); 
	 	context_param = ?(Параметры.Свойство("context_param"),	Параметры.context_param,	""); 
	КонецЕсли;	
	ОбновитьАлгоритмы();
КонецПроцедуры

&НаКлиенте
Процедура ОбработкаОповещения(ИмяСобытия, Параметр, Источник)
	Если ИмяСобытия = "SabySignOut" Тогда
		Закрыть();	
	КонецЕсли;	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийЭлементовШапкиФормы

#КонецОбласти

#Область ОбработчикиСобытийЭлементовТаблицыФормыТаблицаАлгоритмов

&НаКлиенте
Процедура Изменить(Команда)
	ЭлемФормы = ПолучитьЭлементыФормы();
	ТекущиеДанные = ЭлемФормы.ТаблицаАлгоритмов.ТекущиеДанные;
	Если ТекущиеДанные <> Неопределено Тогда   
		ОткрытьФормуРедактора(ТекущиеДанные.Алгоритм)
	КонецЕсли;	
КонецПроцедуры

&НаКлиенте
Процедура Добавить(Команда)
	ОткрытьФормуРедактора();	
КонецПроцедуры

&НаКлиенте
Процедура ТаблицаАлгоритмовВыбор(Элемент, ВыбраннаяСтрока, Поле, СтандартнаяОбработка)
	СтандартнаяОбработка = ЛОЖЬ;
	ЭлемФормы = ПолучитьЭлементыФормы();
	ТекущиеДанные = ЭлемФормы.ТаблицаАлгоритмов.ТекущиеДанные;
	Если ТекущиеДанные <> Неопределено Тогда   
		Закрыть(ТекущиеДанные.Алгоритм); 
	КонецЕсли;	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиКомандФормы
// Код процедур и функций
#КонецОбласти

#Область СлужебныеПроцедурыИФункции

&НаСервере
Процедура ОбновитьАлгоритмы()  
	ТаблицаАлгоритмов.Очистить();
	СписокИНИ = СписокИниБлокли();
	Для Каждого Запись ИЗ СписокИНИ Цикл  
		Если ПРАВ(Запись.Ключ,6) <> "_robot" Тогда 
			Продолжить;
		КонецЕсли;	
		НоваяСтрока = ТаблицаАлгоритмов.Добавить();
		НоваяСтрока.Алгоритм = Запись.Ключ;
		Если ТипЗнч(Запись.Значение) = Тип("Соответствие") И Запись.Значение.Получить("custom") = 1 Тогда
			НоваяСтрока.Пользовательский = Истина;
		КонецЕсли;						
	КонецЦикла;				
	ТаблицаАлгоритмов.Сортировать("Алгоритм");	
КонецПроцедуры

&НаСервереБезКонтекста
Функция КодироватьСтрокуНаСервере(НазваниеАлгоритма) 
	Возврат КодироватьСтроку(НазваниеАлгоритма,СпособКодированияСтроки.КодировкаURL); 
КонецФункции	

&НаСервере 
Функция	СписокИниБлокли() 
	МодульОбъекта = МодульОбъекта();
    МассивИНИ = Новый Массив();
	МассивИНИ.Добавить(Новый Структура("type","Blockly"));
	ПараметрыОперации = Новый Структура("id,Версия,INI",Идентификатор,Версия,МассивИНИ);
 	АвтоматическаяОперация = МодульОбъекта.local_helper_read_connection(context_param, ПараметрыОперации); 
	СписокБлокли = МодульОбъекта.local_helper_json_loads(АвтоматическаяОперация["Inis"]);
	Возврат СписокБлокли;
КонецФункции

&НаКлиенте
Процедура ПослеЗакрытияРедактораФормы(Результат, ДополнительныеПараметры) Экспорт
	ОбновитьАлгоритмы();	
КонецПроцедуры

&НаКлиенте
Процедура ОткрытьФормуРедактора(Алгоритм = Неопределено)
	ДополнениеАдресаСтраницы = "";
	Если ЗначениеЗаполнено(Алгоритм) Тогда
		НазваниеАлгоритма = КодироватьСтрокуНаСервере(Алгоритм);
		ДополнениеАдресаСтраницы = "&endpoint=&algorithm="+НазваниеАлгоритма;
	КонецЕсли;	
	АдресСтраницы = context_param.api_url+"/blockly_editor_1c/page/?connection_id="+Идентификатор+"&connector=1C&command=1C"+ДополнениеАдресаСтраницы;	
	ПараметрыФормы = Новый Структура;
	ПараметрыФормы.Вставить("Заголовок", "Редактор файлов настроек");
	ПараметрыФормы.Вставить("АдресСтраницы", АдресСтраницы);
	ОповещениеПослеЗакрытияРедактора = Новый ОписаниеОповещения("ПослеЗакрытияРедактораФормы", ЭтаФорма);
	ОткрытьФормуОбработки("Browser",ПараметрыФормы,,,ОповещениеПослеЗакрытияРедактора);
КонецПроцедуры	

#Область include_core_base_Helpers_FormGetters
#КонецОбласти

#КонецОбласти


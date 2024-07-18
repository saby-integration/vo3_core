#Область include_core_base_locale_ЛокализацияНазваниеПродукта
#КонецОбласти

#Область include_core_base_Helpers_РаботаСоСвойствамиСтруктуры
#КонецОбласти

#Область include_core_base_ExtException
#КонецОбласти

&НаКлиенте
Процедура ДобавитьВложение(Команда)
	СтандартнаяОбработка = Ложь;
	Диалог = Новый ДиалогВыбораФайла(РежимДиалогаВыбораФайла.Открытие);
	Диалог.Фильтр = НСтр("ru=’Любой файл (*.*)|*.*'");
	Диалог.Заголовок = НСтр("ru=’Выберите файл'");
	Диалог.МножественныйВыбор = Истина;
	ОбработкаОкончанияЗагрузки = Новый ОписаниеОповещения("ВыборФайлаЗавершение", ЭтаФорма, Диалог);
	НачатьПомещениеФайлов(ОбработкаОкончанияЗагрузки, , Диалог, Истина, УникальныйИдентификатор);
КонецПроцедуры

&НаСервере
Процедура УдалитьСтрокуВыбранногоОбъекта(ИдентификаторыСтрок)
	Для Каждого ИдентификаторСтроки Из ИдентификаторыСтрок Цикл
		СтрокаТЧ = Объекты.НайтиПоИдентификатору(ИдентификаторСтроки);
		Объекты.Удалить(СтрокаТЧ);
	КонецЦикла;
КонецПроцедуры


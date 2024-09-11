
&НаКлиенте
Процедура ЗапуститьФоновоеЗаданиеКлиент(Параметры, Владелец) Экспорт
	Параметры.Вставить("УникальныйИдентификатор", Новый УникальныйИдентификатор);
	ИдентификаторЗадания = МодульФоновогоЗаданияСервер().ЗапуститьФоновоеЗаданиеСервер(Параметры);
	Если Параметры.ВыводитьОкноОжидания Тогда
		ИнтервалОжидания = ?(Параметры.Интервал <> 0, Параметры.Интервал, 0.5);
		// Т.К. модуль ***_ФоновыеЗаданияГлобальный глобальный, то и название методу нужно дать более чем уникальное, для исключения пересечений наименований
		ПодключитьОбработчикОжидания("РасширениеКЭДОПроверитьСостояниеФоновогоЗаданияКлиент", ИнтервалОжидания, Истина);
	КонецЕсли;
КонецПроцедуры


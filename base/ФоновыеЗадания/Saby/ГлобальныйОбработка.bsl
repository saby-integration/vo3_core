
#Область include_core_base_ФоновыеЗадания_Saby_ГлобальныйМодульЯдра
#КонецОбласти

Функция ПолучитьПрогресс(Параметры)
	Прогресс = МодульЯдра().get_prop(Параметры, "ДополнительныеПараметры");
	Прогресс = МодульЯдра().get_prop(Прогресс, "Прогресс", 0); 
	Возврат Прогресс;
КонецФункции

&НаКлиенте
Процедура ОбработкаПроверитьСостояниеФоновогоЗаданияКлиент() Экспорт
	// Значения до обращения к БЛ
	ПараметрыСеансаРасш = МодульФоновогоЗаданияСервер().ПрогрессФЗПрочитатьЗначения();
	_Параметры			= ПараметрыСеансаРасш.Параметры;
	ТекстОповещения		= ПараметрыСеансаРасш.ТекстОповещения;
	Прогресс			= ПолучитьПрогресс(ПараметрыСеансаРасш);
	// Сообщим
	Состояние(_Параметры.ФоновоеЗаданиеНаименование, Прогресс, ТекстОповещения);

	МодульФоновогоЗаданияКлиент().Подключаемый_ПроверитьВыполнениеЗадания();
	
	// Значения после обращения к БЛ
	ПараметрыСеансаРасш = МодульФоновогоЗаданияСервер().ПрогрессФЗПрочитатьЗначения();
	ТекстОповещения = ПараметрыСеансаРасш.ТекстОповещения;
	Прогресс = ПолучитьПрогресс(ПараметрыСеансаРасш);
	// Сообщим
	Состояние(_Параметры.ФоновоеЗаданиеНаименование, Прогресс, ТекстОповещения);
КонецПроцедуры


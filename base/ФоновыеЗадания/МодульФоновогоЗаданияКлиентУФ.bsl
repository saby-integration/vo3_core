
&НаКлиенте
Функция МодульФоновогоЗаданияКлиент()
	ВЛФормы = ЭтаФорма; 
	ОткрытыеОкна = ПолучитьОкна();
	Для Каждого Запись ИЗ ОткрытыеОкна Цикл 
		Если Запись.Содержимое.Количество() = 0 Тогда
			Продолжить;
		КонецЕсли;
		Для Каждого Содержимое Из Запись.Содержимое Цикл
			Если ТипЗнч(Содержимое) <> Тип("ФормаКлиентскогоПриложения") Тогда 
				Продолжить;
			КонецЕсли;	   
			Если Найти(Содержимое.ИмяФормы,ЛокализацияНазваниеПродукта()+".Форма.ГлавноеОкно") > 0 Тогда
				ВЛФормы = Содержимое;
				Прервать;
			ИначеЕсли Найти(Содержимое.ИмяФормы,"Форма.ФормаГлавноеОкно") > 0 Тогда
				ВЛФормы = Содержимое;
				Прервать;	
			КонецЕсли;	
		КонецЦикла;	
	КонецЦикла;	
	Возврат ВЛФормы;
КонецФункции	


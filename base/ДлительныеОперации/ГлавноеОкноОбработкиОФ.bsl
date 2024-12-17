
// Преобразует (сериализует) любое значение в XML-строку.
// Преобразованы в могут быть только те объекты, для которых в синтакс-помощнике указано, что они сериализуются.
// См. также ЗначениеИзСтрокиXML.
//
// Параметры:
//  Значение - Произвольный - значение, которое необходимо сериализовать в XML-строку.
//
// Возвращаемое значение:
//  Строка - XML-строка.
//
Функция ЗначениеВСтрокуXML(Значение) Экспорт
	
	ЗаписьXML = Новый ЗаписьXML;
	ЗаписьXML.УстановитьСтроку();
	СериализаторXDTO.ЗаписатьXML(ЗаписьXML, Значение, НазначениеТипаXML.Явное);
	
	Возврат ЗаписьXML.Закрыть();
КонецФункции

// Выполняет преобразование (десериализацию) XML-строки в значение.
// См. также ЗначениеВСтрокуXML.
//
// Параметры:
//  СтрокаXML - Строка - XML-строка, с сериализованным объектом..
//
// Возвращаемое значение:
//  Произвольный - значение, полученное из переданной XML-строки.
//
Функция ЗначениеИзСтрокиXML(СтрокаXML) Экспорт
	
	ЧтениеXML = Новый ЧтениеXML;
	ЧтениеXML.УстановитьСтроку(СтрокаXML);
	
	Возврат СериализаторXDTO.ПрочитатьXML(ЧтениеXML);
КонецФункции

// Считывает информацию о ходе выполнения фонового задания и сообщения, которые в нем были сформированы.
//
// Параметры:
//   ИдентификаторЗадания - УникальныйИдентификатор - идентификатор фонового задания.
//   Режим                - Строка - "ПрогрессИСообщения", "Прогресс" или "Сообщения".
//
// Возвращаемое значение:
//   Структура:
//    * Прогресс  - Неопределено
//                - Структура - информация о ходе выполнения фонового задания, записанная процедурой СообщитьПрогресс:
//     ** Процент                 - Число  - необязательный. Процент выполнения.
//     ** Текст                   - Строка - необязательный. Информация о текущей операции.
//     ** ДополнительныеПараметры - Произвольный - необязательный. Любая дополнительная информация.
//    * Сообщения - ФиксированныйМассив - массив объектов СообщениеПользователю, которые были сформированы в фоновом задании.
//
Функция ПрочитатьПрогрессИСообщения(Знач ИдентификаторЗадания, Знач Режим = "ПрогрессИСообщения")
	
	Сообщения = Новый ФиксированныйМассив(Новый Массив);
	Результат = Новый Структура("Сообщения, Прогресс", Сообщения, Неопределено);
	
	Задание = НайтиЗаданиеПоИдентификатору(ИдентификаторЗадания);
	Если Задание = Неопределено Тогда
		Возврат Результат;
	КонецЕсли;
	
	МассивСообщений = Задание.ПолучитьСообщенияПользователю(Истина);
	Если МассивСообщений = Неопределено Тогда
		Возврат Результат;
	КонецЕсли;
	
	Количество = МассивСообщений.Количество();
	Сообщения = Новый Массив;
	ЧитатьСообщения = (Режим = "ПрогрессИСообщения" Или Режим = "Сообщения"); 
	ЧитатьПрогресс  = (Режим = "ПрогрессИСообщения" Или Режим = "Прогресс"); 
	
	Если ЧитатьСообщения И Не ЧитатьПрогресс Тогда
		Результат.Сообщения = Новый ФиксированныйМассив(МассивСообщений);
		Возврат Результат;
	КонецЕсли;
	
	Для Номер = 0 По Количество - 1 Цикл
		Сообщение = МассивСообщений[Номер];
		
		Если ЧитатьПрогресс И Найти(Сообщение.Текст, "{") Тогда
			Позиция = Найти(Сообщение.Текст, "}");
			Если Позиция > 2 Тогда
				ИдентификаторМеханизма = Сред(Сообщение.Текст, 2, Позиция - 2);
				Если ИдентификаторМеханизма = СообщениеПрогресса() Тогда
					ПолученныйТекст = Сред(Сообщение.Текст, Позиция + 1);
					Результат.Прогресс = ЗначениеИзСтрокиXML(ПолученныйТекст);
					Продолжить;
				КонецЕсли;
			КонецЕсли;
		КонецЕсли;
		Если ЧитатьСообщения Тогда
			Сообщения.Добавить(Сообщение);
		КонецЕсли;
	КонецЦикла;
	
	Результат.Сообщения = Новый ФиксированныйМассив(Сообщения);
	Возврат Результат;
	
КонецФункции

Функция НайтиЗаданиеПоИдентификатору(Знач ИдентификаторЗадания) Экспорт
	
	Если ТипЗнч(ИдентификаторЗадания) = Тип("Строка") Тогда
		ИдентификаторЗадания = Новый УникальныйИдентификатор(ИдентификаторЗадания);
	КонецЕсли;
	
	Задание = ФоновыеЗадания.НайтиПоУникальномуИдентификатору(ИдентификаторЗадания);
	Возврат Задание;
	
КонецФункции

Функция ОперацияВыполнена(Знач ИдентификаторЗадания, Знач ИсключениеПриОшибке = Ложь, Знач ВыводитьПрогрессВыполнения = Ложь, 
	Знач ВыводитьСообщения = Ложь) Экспорт
	
	Результат = Новый Структура;
	Результат.Вставить("Статус", "Выполняется");
	Результат.Вставить("КраткоеПредставлениеОшибки", Неопределено);
	Результат.Вставить("ПодробноеПредставлениеОшибки", Неопределено);
	Результат.Вставить("Прогресс", Неопределено);
	Результат.Вставить("Сообщения", Неопределено);
	Результат.Вставить("Наименование", Неопределено);
	
	Задание = НайтиЗаданиеПоИдентификатору(ИдентификаторЗадания);
	Если Задание = Неопределено Тогда
		Пояснение = НСтр("ru = 'Операция не выполнена из-за аварийного завершения фонового задания.
			|Фоновое задание не существует'") + ": " + Строка(ИдентификаторЗадания);
		ЗаписьЖурналаРегистрации(НСтр("ru = 'Длительные операции.Ошибка выполнения'", ОбщегоНазначения.КодОсновногоЯзыка()),
			УровеньЖурналаРегистрации.Ошибка, , , Пояснение);
		Если ИсключениеПриОшибке Тогда
			ВызватьИсключение(НСтр("ru = 'Не удалось выполнить данную операцию.'"));
		КонецЕсли;
		Результат.Статус = "Ошибка";
		Результат.КраткоеПредставлениеОшибки = НСтр("ru = 'Операция не выполнена из-за аварийного завершения фонового задания.'");
		Возврат Результат;
	КонецЕсли;
	
	Результат.Наименование	= Задание.Наименование;
	Если ВыводитьПрогрессВыполнения Тогда
		ПрогрессИСообщения = ПрочитатьПрогрессИСообщения(ИдентификаторЗадания, ?(ВыводитьСообщения, "ПрогрессИСообщения", "Прогресс"));
		Результат.Прогресс = ПрогрессИСообщения.Прогресс;
		Если ВыводитьСообщения Тогда
			Результат.Сообщения = ПрогрессИСообщения.Сообщения;
		КонецЕсли;
	ИначеЕсли ВыводитьСообщения Тогда
		Результат.Сообщения = Задание.ПолучитьСообщенияПользователю(Истина);
	КонецЕсли;
	
	Если Задание.Состояние = СостояниеФоновогоЗадания.Активно Тогда
		Возврат Результат;
	КонецЕсли;
	
	Если Задание.Состояние = СостояниеФоновогоЗадания.Отменено Тогда
		//УстановитьПривилегированныйРежим(Истина);
		//Если ПараметрыФЗ.ОтмененныеДлительныеОперации.Найти(ИдентификаторЗадания) = Неопределено Тогда
		//	Результат.Статус = "Ошибка";
		//	Если Задание.ИнформацияОбОшибке <> Неопределено Тогда
		//		Результат.КраткоеПредставлениеОшибки   = НСтр("ru = 'Операция отменена администратором.'");
		//		Результат.ПодробноеПредставлениеОшибки = Результат.КраткоеПредставлениеОшибки;
		//	КонецЕсли;
		//	Если ИсключениеПриОшибке Тогда
		//		Если Не ПустаяСтрока(Результат.КраткоеПредставлениеОшибки) Тогда
		//			ТекстСообщения = Результат.КраткоеПредставлениеОшибки;
		//		Иначе
		//			ТекстСообщения = НСтр("ru = 'Не удалось выполнить данную операцию.'");
		//		КонецЕсли;
		//		ВызватьИсключение ТекстСообщения;
		//	КонецЕсли;
		//Иначе
			Результат.Статус = "Отменено";
		//КонецЕсли;
		//УстановитьПривилегированныйРежим(Ложь);
		Возврат Результат;
	КонецЕсли;
	
	Если Задание.Состояние = СостояниеФоновогоЗадания.ЗавершеноАварийно 
		Или Задание.Состояние = СостояниеФоновогоЗадания.Отменено Тогда
		
		Результат.Статус = "Ошибка";
		Если Задание.ИнформацияОбОшибке <> Неопределено Тогда
			Результат.КраткоеПредставлениеОшибки   = КраткоеПредставлениеОшибки(Задание.ИнформацияОбОшибке);
			Результат.ПодробноеПредставлениеОшибки = ПодробноеПредставлениеОшибки(Задание.ИнформацияОбОшибке);
		КонецЕсли;
		Если ИсключениеПриОшибке Тогда
			Если Не ПустаяСтрока(Результат.КраткоеПредставлениеОшибки) Тогда
				ТекстСообщения = Результат.КраткоеПредставлениеОшибки;
			Иначе
				ТекстСообщения = НСтр("ru = 'Не удалось выполнить данную операцию.'");
			КонецЕсли;
			ВызватьИсключение ТекстСообщения;
		КонецЕсли;
		Возврат Результат;
	КонецЕсли;
	
	Результат.Статус = "Выполнено";
	Возврат Результат;
	
КонецФункции

#Область include_core_base_ФоновыеЗаданияСервер_ПараметрыСеанса
#КонецОбласти

#Область Saby_ФоновыеЗаданияСервер

&НаСервере
Процедура ПерезапуститьФоновоеЗадание() Экспорт
	ПараметрыСеансаРасш		= ПрогрессФЗПрочитатьЗначения();
	_Параметры				= ПараметрыСеансаРасш.Параметры;
	ИдентификаторЗадания	= ПараметрыСеансаРасш.ИдентификаторЗадания;
	Задание					= НайтиЗаданиеПоИдентификатору(ИдентификаторЗадания);
	ФоновоеЗадание			= ФоновыеЗадания.Выполнить(_Параметры.ФоновоеЗаданиеИмяМетода, _Параметры.ФоновоеЗаданиеПараметры, Задание.Ключ, _Параметры.ФоновоеЗаданиеНаименование);	
	ИдентификаторЗадания	= ФоновоеЗадание.УникальныйИдентификатор;
	
	ПрогрессФЗУстановитьИдентификаторЗадания(ИдентификаторЗадания);
КонецПроцедуры

&НаСервере
Функция ПроверитьЗаданиеВыполнено(ФормаЗакрывается = Ложь) Экспорт
	ПараметрыФЗ				= ПрогрессФЗПрочитатьЗначения();
	ИдентификаторЗадания	= ПараметрыФЗ.ИдентификаторЗадания;
	_Параметры				= ПараметрыФЗ.Параметры;
	
	Задание = ОперацияВыполнена(ИдентификаторЗадания, Ложь, _Параметры.ВыводитьПрогрессВыполнения,
		_Параметры.ВыводитьСообщения);
	
	Если _Параметры.ПолучатьРезультат Тогда
		Если Задание.Статус = "Выполнено" Тогда
			Задание.Вставить("Результат", ПолучитьИзВременногоХранилища(_Параметры.АдресРезультата));
		Иначе
			Задание.Вставить("Результат", Неопределено);
		КонецЕсли;
	КонецЕсли;
	
	//Если ФормаЗакрывается = Истина Тогда
	//	ОтменитьВыполнениеЗадания();
	//	Задание.Статус = "Отменено";
	//КонецЕсли;	
	//
	Возврат Задание;
	
КонецФункции

#КонецОбласти

#Область include_core_base_ФоновыеЗадания_Сервер
#КонецОбласти

#Область include_core_base_ФоновыеЗадания_Saby_Глобальный
#КонецОбласти

#Область include_base_CommonModule_ИмяМодуляCore
#КонецОбласти

#Область Подключаемый_ПроверитьВыполнениеЗадания

&НаКлиенте
Функция ПрогрессСтрокой(Прогресс)
	
	Результат = "";
	Если Прогресс = Неопределено Тогда
		Возврат Результат;
	КонецЕсли;
	
	Процент = 0;
	Если Прогресс.Свойство("Процент", Процент) Тогда
		Результат = Строка(Процент) + "%";
	КонецЕсли;
	Текст = 0;
	Если Прогресс.Свойство("Текст", Текст) Тогда
		Если Не ПустаяСтрока(Результат) Тогда
			Результат = Результат + " (" + Текст + ")";
		Иначе
			Результат = Текст;
		КонецЕсли;
	КонецЕсли;

	Возврат Результат;
	
КонецФункции

&НаКлиенте
Функция ВозвращатьРезультатВОбработкуВыбора()
	Возврат Ложь;
	//Возврат ОписаниеОповещенияОЗакрытии = Неопределено
	//	И Параметры.ПолучатьРезультат
	//	И ТипЗнч(ВладелецФормы) = Тип("ФормаКлиентскогоПриложения");
КонецФункции

&НаКлиенте
Процедура Подключаемый_ПроверитьВыполнениеЗадания(ФормаЗакрывается = Ложь) Экспорт
	
	ПараметрыСеансаРасширения = МодульФоновогоЗаданияСервер().ПрогрессФЗПрочитатьЗначения();
	_Параметры				= ПараметрыСеансаРасширения.Параметры;
	ДополнительныеПараметры	= ПараметрыСеансаРасширения.ДополнительныеПараметры;
	ИнтервалОжидания		= ПараметрыСеансаРасширения.ИнтервалОжидания;
	КартинкаОповещения		= ПараметрыСеансаРасширения.КартинкаОповещения;
	ТекстОповещения			= ПараметрыСеансаРасширения.ТекстОповещения;
	
	Задание = МодульФоновогоЗаданияСервер().ПроверитьЗаданиеВыполнено(ФормаЗакрывается);
	Статус = Задание.Статус;
	МодульФоновогоЗаданияСервер().ПрогрессФЗУстановитьСтатус(Статус);
	
	ДополнительныеПараметры_ = get_prop(Задание.Прогресс, "ДополнительныеПараметры");
	Если ТипЗнч(ДополнительныеПараметры) <> Тип("Структура") Тогда
		ДополнительныеПараметры = Новый Структура();
	КонецЕсли;
	
	Если Задание.Прогресс <> Неопределено Тогда
		Если ТипЗнч(ДополнительныеПараметры_) = Тип("Структура") Тогда
			Для Каждого ЗнчКлюч Из ДополнительныеПараметры_ Цикл
				ДополнительныеПараметры.Вставить(ЗнчКлюч.Ключ, ЗнчКлюч.Значение);
			КонецЦикла;
		КонецЕсли;
		ПрогрессСтрокой = ПрогрессСтрокой(Задание.Прогресс);
		Если Не ПустаяСтрока(ПрогрессСтрокой) Тогда
			//Элементы.ДекорацияПоясняющийТекстДлительнойОперации.Заголовок = ТекстСообщения + Символы.ПС + ПрогрессСтрокой;
			ТекстОповещения = Задание.Прогресс.Текст;
		КонецЕсли;
	КонецЕсли;
	МодульФоновогоЗаданияСервер().ПрогрессФЗУстановитьДополнительныеПараметры(ДополнительныеПараметры);
	
	//// Формы нет
	//Если Задание.Сообщения <> Неопределено И ВладелецФормы <> Неопределено Тогда
	//	ИдентификаторНазначения = ВладелецФормы.УникальныйИдентификатор;
	//	Для каждого СообщениеПользователю Из Задание.Сообщения Цикл
	//		СообщениеПользователю.ИдентификаторНазначения = ИдентификаторНазначения;
	//		СообщениеПользователю.Сообщить();
	//	КонецЦикла;
	//	Задание.Сообщения = Новый ФиксированныйМассив(Новый Массив);
	//КонецЕсли;
	
	Если Статус = "Выполнено" Тогда
		СтатусВыполнения = get_prop(ДополнительныеПараметры, "status");
		СообщитьПрогрессОперации(,,Новый Структура("Прогресс", 100));
		
		Если СтатусВыполнения = "run" Тогда
			// Выполняем команду через оповещение
			Контекст = Новый Структура;
			Контекст.Вставить("step", ДополнительныеПараметры.step);
			
			ВыполнитьКоманды_Клиент(
				Новый ОписаниеОповещения("Подключаемый_ПроверитьВыполнениеЗаданияПослеВыполненияКоманды", ЭтотОбъект, Контекст),
				ДополнительныеПараметры.commands,
				ДополнительныеПараметры.commands_data);
				
			Возврат;

		ИначеЕсли СтатусВыполнения = "error" Тогда
			//TODO отвратительно
			РезультатВыгрузки = ДополнительныеПараметры.data;
			КартинкаОповещения = "Ошибка32";

			Если ТипЗнч(РезультатВыгрузки.detail) = Тип("Строка") Тогда
				ТекстОповещения = СокрЛП(РезультатВыгрузки.message) + ". " +  СокрЛП(РезультатВыгрузки.detail);
			Иначе	
				ТекстОповещения = СокрЛП(РезультатВыгрузки.message) + ". ";
			КонецЕсли;
			// 
			МодульCore().ExtExceptionToJournal(РезультатВыгрузки);
		ИначеЕсли СтатусВыполнения = "complete" Тогда
			Если Не ЗначениеЗаполнено(ТекстОповещения) Тогда
				ТекстОповещения = "Выполнено";
			КонецЕсли;
			
			ДопПараметрыДата = get_prop(ДополнительныеПараметры, "data");
			КартинкаИмя = get_prop(ДопПараметрыДата, "Картинка");
			Если Не ПустаяСтрока(КартинкаИмя) Тогда
				КартинкаОповещения = КартинкаИмя;
			Иначе
				КартинкаОповещения = "ЗеленаяГалка";
			КонецЕсли;
			КоличествоОбработано	= get_prop(ДопПараметрыДата, "CountConfirmed", 0);
			ВсегоОбъектов			= get_prop(ДопПараметрыДата, "CountObjects", 0);
			КоличествоОшибок		= get_prop(ДопПараметрыДата, "CountErrors", 0);
			Если	КоличествоОшибок > 0
					ИЛИ КоличествоОшибок + КоличествоОбработано <> ВсегоОбъектов Тогда
				СтатусВыполнения = "error";
				КартинкаОповещения = ЛокализацияНазваниеПродукта()+"_Ошибка32";
			КонецЕсли;
			
		КонецЕсли;
		
		МодульФоновогоЗаданияСервер().ПрогрессФЗУстановитьКартинкуОповещения(КартинкаОповещения);
		//Сообщений об ошибке может быть несколько
		СообщенияДата = get_prop(ДополнительныеПараметры, "data");
		мСообщений = Неопределено;
		Если ТипЗнч(СообщенияДата) = Тип("Структура") или ТипЗнч(СообщенияДата) = Тип("Соответствие") Тогда
			мСообщений = get_prop(СообщенияДата, "detail");
		КонецЕсли;
		Если ТипЗнч(мСообщений) = Тип("Массив") Тогда
			ТекстОповещения_ = ТекстОповещения;
			Для Каждого ДанныеСообщения Из мСообщений Цикл
				ТекстОповещения		= get_prop(ДанныеСообщения, "message") +" "+ get_prop(ДанныеСообщения, "detail");
				ПоказатьОповещение();
			КонецЦикла;
			ТекстОповещения = ТекстОповещения_;
			ДополнительныеПараметры.data.Вставить("detail", "");
			МодульФоновогоЗаданияСервер().ПрогрессФЗУстановитьДополнительныеПараметры(ДополнительныеПараметры);
		КонецЕсли;
		МодульФоновогоЗаданияСервер().ПрогрессФЗУстановитьТекстОповещения(ТекстОповещения);
		//Итоговое
		ПоказатьОповещение();

		Если ВозвращатьРезультатВОбработкуВыбора() Тогда
			//ОповеститьОВыборе(Задание.Результат);
			Возврат;
		КонецЕсли;
		//Закрыть(РезультатВыполнения(Задание));
		Возврат;
		
	ИначеЕсли Статус = "Ошибка" Тогда
		
		// Как передавать параметр обратно???
		//Закрыть(РезультатВыполнения(Задание));
		Если ВозвращатьРезультатВОбработкуВыбора() Тогда
			ВызватьИсключение Задание.КраткоеПредставлениеОшибки;
		КонецЕсли;
		Возврат;
		
	КонецЕсли;
	
	МодульФоновогоЗаданияСервер().ПрогрессФЗУстановитьТекстОповещения(ТекстОповещения);
	Если _Параметры.ВыводитьОкноОжидания Тогда
		Если _Параметры.Интервал = 0 Тогда
			ИнтервалОжидания = ИнтервалОжидания * 1.4;
			Если ИнтервалОжидания > 15 Тогда
				ИнтервалОжидания = 15;
			КонецЕсли;
			МодульФоновогоЗаданияСервер().ПрогрессФЗУстановитьИнтервалОжидания(ИнтервалОжидания);
		КонецЕсли;
		ПодключитьОбработчикОжидания("РасширениеПроверитьСостояниеФоновогоЗаданияКлиент", ИнтервалОжидания, Истина);
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура Подключаемый_ПроверитьВыполнениеЗаданияПослеВыполненияКоманды(commands_result, Контекст) Экспорт
	
	Параметры = МодульФоновогоЗаданияСервер().ПараметрыСеансаРасширения().Параметры;
	
	Параметры.ФоновоеЗаданиеПараметры[0].ПараметрыВыполнения["commands_result"] = commands_result;
	Параметры.ФоновоеЗаданиеПараметры[0].ПараметрыВыполнения.Вставить("step", Контекст.step);
	МодульФоновогоЗаданияСервер().ПрогрессФЗУстановитьПараметры(Параметры);
	
	МодульФоновогоЗаданияСервер().ПерезапуститьФоновоеЗадание();
	Если Параметры.ВыводитьОкноОжидания Тогда
		ИнтервалОжидания = Параметры.Интервал;
		Если Параметры.Интервал = 0 Тогда
			ИнтервалОжидания = ИнтервалОжидания * 1.4;
			Если ИнтервалОжидания > 15 Тогда
				ИнтервалОжидания = 15;
			КонецЕсли;
		КонецЕсли;
		ПодключитьОбработчикОжидания("РасширениеПроверитьСостояниеФоновогоЗаданияКлиент", ИнтервалОжидания, Истина);
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ПоказатьОповещение()
	
	ПараметрыСеансаРасширения = МодульФоновогоЗаданияСервер().ПрогрессФЗПрочитатьЗначения();
	_Параметры	= ПараметрыСеансаРасширения.Параметры;
	
	Если _Параметры.ОповещениеПользователя = Неопределено Или Не _Параметры.ОповещениеПользователя.Показать Тогда
		Возврат;
	КонецЕсли;
	
	Оповещение = _Параметры.ОповещениеПользователя;
	
	НавигационнаяСсылкаОповещения = Оповещение.НавигационнаяСсылка;
	ВладелецФормы = Неопределено; // В контексте формы, в модуле отсутствует
	Если НавигационнаяСсылкаОповещения = Неопределено И ВладелецФормы <> Неопределено И ВладелецФормы.Окно <> Неопределено Тогда
		НавигационнаяСсылкаОповещения = ВладелецФормы.Окно.ПолучитьНавигационнуюСсылку();
	КонецЕсли;
	ПояснениеОповещения = Оповещение.Пояснение;
	Если ПояснениеОповещения = Неопределено И ВладелецФормы <> Неопределено И ВладелецФормы.Окно <> Неопределено Тогда
		ПояснениеОповещения = ВладелецФормы.Окно.Заголовок;
	КонецЕсли;
	
	Если 	_Параметры.ФоновоеЗаданиеНаименование = "Отправка в "+ЛокализацияНазваниеПродукта() //команда - "Отправка в СБИС"
				или 
			_Параметры.ФоновоеЗаданиеНаименование = "Выгрузка в 1С"  //Действие -"Выгрузка в 1С" с формы задач
				Тогда
		ПараметрыЗагрузки = get_prop(_Параметры.ФоновоеЗаданиеПараметры[0],"ПараметрыВыполнения",Неопределено);
		НавигационнаяСсылкаОповещения = ПолучитьАдресСтраницыОтчетОЗагрузке(ПараметрыЗагрузки["params"]["api_url"],ПараметрыЗагрузки["operation_uuid"]);


	КонецЕсли;
	Оповестить("Saby_ЗавершениеДлительнойОперации");
	ПоказатьОповещениеПользователя(ПояснениеОповещения,НавигационнаяСсылкаОповещения, 
		?(НЕ ПустаяСтрока(ПараметрыСеансаРасширения.ТекстОповещения),ПараметрыСеансаРасширения.ТекстОповещения, ?(Оповещение.Текст <> Неопределено, Оповещение.Текст, НСтр("ru = 'Действие выполнено'")))
		,БиблиотекаКартинок[ПараметрыСеансаРасширения.КартинкаОповещения]
		,СтатусОповещенияПользователя.Важное,);

КонецПроцедуры


&НаКлиенте
Функция ПолучитьАдресСтраницыОтчетОЗагрузке(URL, extSyncDocId) 
	Возврат URL+"/ext-sync-doc/page/?extSyncDocId="+extSyncDocId; 	 	
КонецФункции	


#КонецОбласти

#Область include_core_base_ДлительныеОперацииКлиент
#КонецОбласти

#Область include_BlocklyExecutor_base_Commands
#КонецОбласти

#Область include_core_base_Криптография_НаКлиенте1С
#КонецОбласти


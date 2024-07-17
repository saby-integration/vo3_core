
#Область include_core_base_locale_ЛокализацияНазваниеПродукта
#КонецОбласти

&НаСервере
Функция НайтиЗаданиеПоИдентификатору(Знач ИдентификаторЗадания) Экспорт
	
	Если ТипЗнч(ИдентификаторЗадания) = Тип("Строка") Тогда
		ИдентификаторЗадания = Новый УникальныйИдентификатор(ИдентификаторЗадания);
	КонецЕсли;
	
	Задание = ФоновыеЗадания.НайтиПоУникальномуИдентификатору(ИдентификаторЗадания);
	Возврат Задание;
	
КонецФункции

&НаСервере
Процедура ПерезапуститьФоновоеЗадание()
	Задание = НайтиЗаданиеПоИдентификатору(ИдентификаторЗадания);
	ФоновоеЗадание = ФоновыеЗадания.Выполнить(Параметры.ФоновоеЗаданиеИмяМетода, Параметры.ФоновоеЗаданиеПараметры, Задание.Ключ,Параметры.ФоновоеЗаданиеНаименование);	
	ИдентификаторЗадания = ФоновоеЗадание.УникальныйИдентификатор;
КонецПроцедуры

#Область Подключаемый_ПроверитьВыполнениеЗадания

&НаКлиенте
Процедура Подключаемый_ПроверитьВыполнениеЗадания()
	
	Задание = ПроверитьЗаданиеВыполнено(ФормаЗакрывается);
	Статус = Задание.Статус;
	
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
			Элементы.ДекорацияПоясняющийТекстДлительнойОперации.Заголовок = ТекстСообщения + Символы.ПС + ПрогрессСтрокой;
			ТекстОповещения = Задание.Прогресс.Текст;
		КонецЕсли;
	КонецЕсли;
	Если Задание.Сообщения <> Неопределено И ВладелецФормы <> Неопределено Тогда
		ИдентификаторНазначения = ВладелецФормы.УникальныйИдентификатор;
		Для каждого СообщениеПользователю Из Задание.Сообщения Цикл
			СообщениеПользователю.ИдентификаторНазначения = ИдентификаторНазначения;
			СообщениеПользователю.Сообщить();
		КонецЦикла;
		Задание.Сообщения = Новый ФиксированныйМассив(Новый Массив);
	КонецЕсли;
	
	Если Статус = "Выполнено" Тогда
		СтатусВыполнения = get_prop(ДополнительныеПараметры, "status");
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
			КартинкаОповещения = БиблиотекаКартинок["Ошибка32"];

			Если ТипЗнч(РезультатВыгрузки.detail) = Тип("Строка") Тогда
				ТекстОповещения = СокрЛП(РезультатВыгрузки.message) + ". " +  СокрЛП(РезультатВыгрузки.detail);
			Иначе	
				ТекстОповещения = СокрЛП(РезультатВыгрузки.message) + ". ";
			КонецЕсли;
			ExtExceptionToJournal(РезультатВыгрузки);
		ИначеЕсли СтатусВыполнения = "complete" Тогда
			Если Не ЗначениеЗаполнено(ТекстОповещения) Тогда
				ТекстОповещения = "Выполнено";
			КонецЕсли;
			
			ДопПараметрыДата = get_prop(ДополнительныеПараметры, "data");
			КартинкаИмя = get_prop(ДопПараметрыДата, "Картинка");
			Если Не ПустаяСтрока(КартинкаИмя) Тогда
				КартинкаОповещения = БиблиотекаКартинок[КартинкаИмя];
			Иначе
				КартинкаОповещения = БиблиотекаКартинок["ЗеленаяГалка"];
			КонецЕсли;
			КоличествоОбработано	= get_prop(ДопПараметрыДата, "CountConfirmed", 0);
			ВсегоОбъектов			= get_prop(ДопПараметрыДата, "CountObjects", 0);
			КоличествоОшибок		= get_prop(ДопПараметрыДата, "CountErrors", 0);
			Если	КоличествоОшибок > 0
					ИЛИ КоличествоОшибок + КоличествоОбработано <> ВсегоОбъектов Тогда
				СтатусВыполнения = "error";
				КартинкаОповещения = БиблиотекаКартинок[ЛокализацияНазваниеПродукта()+"_Ошибка32"];
			КонецЕсли;
			
		КонецЕсли;
		
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
		КонецЕсли;
		//Итоговое
		ПоказатьОповещение();

		Если ВозвращатьРезультатВОбработкуВыбора() Тогда
			ОповеститьОВыборе(Задание.Результат);
			Возврат;
		КонецЕсли;
		Закрыть(РезультатВыполнения(Задание));
		Возврат;
		
	ИначеЕсли Статус = "Ошибка" Тогда
		
		Закрыть(РезультатВыполнения(Задание));
		Если ВозвращатьРезультатВОбработкуВыбора() Тогда
			ВызватьИсключение Задание.КраткоеПредставлениеОшибки;
		КонецЕсли;
		Возврат;
		
	КонецЕсли;
	
	Если Параметры.ВыводитьОкноОжидания Тогда
		Если Параметры.Интервал = 0 Тогда
			ИнтервалОжидания = ИнтервалОжидания * 1.4;
			Если ИнтервалОжидания > 15 Тогда
				ИнтервалОжидания = 15;
			КонецЕсли;
		КонецЕсли;
		ПодключитьОбработчикОжидания("Подключаемый_ПроверитьВыполнениеЗадания", ИнтервалОжидания, Истина);
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура Подключаемый_ПроверитьВыполнениеЗаданияПослеВыполненияКоманды(commands_result, Контекст) Экспорт
	
	Параметры.ФоновоеЗаданиеПараметры[0].ПараметрыВыполнения["commands_result"] = commands_result;
	Параметры.ФоновоеЗаданиеПараметры[0].ПараметрыВыполнения.Вставить("step", Контекст.step);
	
	ПерезапуститьФоновоеЗадание();
	Если Параметры.ВыводитьОкноОжидания Тогда
		Если Параметры.Интервал = 0 Тогда
			ИнтервалОжидания = ИнтервалОжидания * 1.4;
			Если ИнтервалОжидания > 15 Тогда
				ИнтервалОжидания = 15;
			КонецЕсли;
		КонецЕсли;
		ПодключитьОбработчикОжидания("Подключаемый_ПроверитьВыполнениеЗадания", ИнтервалОжидания, Истина);
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти

&НаКлиенте
Процедура Подключаемый_ОтменитьЗадание()
	
	ФормаЗакрывается = Истина;
	Подключаемый_ПроверитьВыполнениеЗадания(); // а вдруг задание уже выполнилось.
	Если Статус = "Отменено" Тогда
		Статус = Неопределено;
		Если Открыта() Тогда
			Закрыть(РезультатВыполнения(Неопределено));
		КонецЕсли;
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ПоказатьОповещение()
	
	Если Параметры.ОповещениеПользователя = Неопределено Или Не Параметры.ОповещениеПользователя.Показать Тогда
		Возврат;
	КонецЕсли;
	
	Оповещение = Параметры.ОповещениеПользователя;
	
	НавигационнаяСсылкаОповещения = Оповещение.НавигационнаяСсылка;
	Если НавигационнаяСсылкаОповещения = Неопределено И ВладелецФормы <> Неопределено И ВладелецФормы.Окно <> Неопределено Тогда
		НавигационнаяСсылкаОповещения = ВладелецФормы.Окно.ПолучитьНавигационнуюСсылку();
	КонецЕсли;
	ПояснениеОповещения = Оповещение.Пояснение;
	Если ПояснениеОповещения = Неопределено И ВладелецФормы <> Неопределено И ВладелецФормы.Окно <> Неопределено Тогда
		ПояснениеОповещения = ВладелецФормы.Окно.Заголовок;
	КонецЕсли;
	
	Если 	Параметры.ФоновоеЗаданиеНаименование = "Отправка в "+ЛокализацияНазваниеПродукта() //команда - "Отправка в СБИС"
				или 
			Параметры.ФоновоеЗаданиеНаименование = "Выгрузка в 1С"  //Действие -"Выгрузка в 1С" с формы задач
				Тогда
		ПараметрыЗагрузки = get_prop(Параметры.ФоновоеЗаданиеПараметры[0],"ПараметрыВыполнения",Неопределено);
		НавигационнаяСсылкаОповещения = ПолучитьАдресСтраницыОтчетОЗагрузке(ПараметрыЗагрузки["params"]["api_url"],ПараметрыЗагрузки["operation_uuid"]);


	КонецЕсли;
	Оповестить("Saby_ЗавершениеДлительнойОперации");
	ПоказатьОповещениеПользователя(ПояснениеОповещения,НавигационнаяСсылкаОповещения, 
		?(НЕ ПустаяСтрока(ТекстОповещения),ТекстОповещения, ?(Оповещение.Текст <> Неопределено, Оповещение.Текст, НСтр("ru = 'Действие выполнено'")))
		,КартинкаОповещения
		,СтатусОповещенияПользователя.Важное,);

КонецПроцедуры

&НаСервере
Функция ПроверитьЗаданиеВыполнено(ФормаЗакрывается)
	
	Задание = ОперацияВыполнена(ИдентификаторЗадания, Ложь, Параметры.ВыводитьПрогрессВыполнения,
		Параметры.ВыводитьСообщения);
	
	Если Параметры.ПолучатьРезультат Тогда
		Если Задание.Статус = "Выполнено" Тогда
			Задание.Вставить("Результат", ПолучитьИзВременногоХранилища(Параметры.АдресРезультата));
		Иначе
			Задание.Вставить("Результат", Неопределено);
		КонецЕсли;
	КонецЕсли;
	
	Если ФормаЗакрывается = Истина Тогда
		ОтменитьВыполнениеЗадания();
		Задание.Статус = "Отменено";
	КонецЕсли;	
	
	Возврат Задание;
	
КонецФункции

&НаСервере
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
		//Если ПараметрыСеанса.ОтмененныеДлительныеОперации.Найти(ИдентификаторЗадания) = Неопределено Тогда
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

Функция СообщениеПрогресса() Экспорт
	Возврат "СтандартныеПодсистемы.ДлительныеОперации";
КонецФункции

&НаСервере
Функция ПрочитатьПрогрессИСообщения(Знач ИдентификаторЗадания, Знач Режим = "ПрогрессИСообщения")
	
	МодульОбъекта = ПолучитьМодульОбъекта();
	Сообщения = Новый ФиксированныйМассив(Новый Массив);
	Результат = Новый Структура("Сообщения, Прогресс", Сообщения, Неопределено);
	
	Задание = ФоновыеЗадания.НайтиПоУникальномуИдентификатору(ИдентификаторЗадания);
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
		
		Если ЧитатьПрогресс И СтрНачинаетсяС(Сообщение.Текст, "{") Тогда
			Позиция = СтрНайти(Сообщение.Текст, "}");
			Если Позиция > 2 Тогда
				ИдентификаторМеханизма = Сред(Сообщение.Текст, 2, Позиция - 2);
				Если ИдентификаторМеханизма = СообщениеПрогресса() Тогда
					ПолученныйТекст = Сред(Сообщение.Текст, Позиция + 1);
					Результат.Прогресс = МодульОбъекта.decode_xml_xdto(ПолученныйТекст);
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
Функция РезультатВыполнения(Задание)
	
	Если Задание = Неопределено Тогда
		Возврат Неопределено;
	КонецЕсли;
	
	Результат = Новый Структура;
	Результат.Вставить("Статус", Задание.Статус);
	Результат.Вставить("АдресРезультата", Параметры.АдресРезультата);
	Результат.Вставить("АдресДополнительногоРезультата", Параметры.АдресДополнительногоРезультата);
	Результат.Вставить("КраткоеПредставлениеОшибки", Задание.КраткоеПредставлениеОшибки);
	Результат.Вставить("ПодробноеПредставлениеОшибки", Задание.ПодробноеПредставлениеОшибки);
	Результат.Вставить("Сообщения", Задание.Сообщения);
	
	Если Параметры.ПолучатьРезультат Тогда
		Результат.Вставить("Результат", Задание.Результат);
	КонецЕсли;
	
	Возврат Результат;
	
КонецФункции

&НаКлиенте
Функция ВозвращатьРезультатВОбработкуВыбора()
	Возврат ОписаниеОповещенияОЗакрытии = Неопределено
		И Параметры.ПолучатьРезультат
		И ТипЗнч(ВладелецФормы) = Тип("ФормаКлиентскогоПриложения");
КонецФункции

&НаСервере
Процедура ОтменитьВыполнениеЗадания()
	
	ДлительныеОперации.ОтменитьВыполнениеЗадания(ИдентификаторЗадания);
	
КонецПроцедуры



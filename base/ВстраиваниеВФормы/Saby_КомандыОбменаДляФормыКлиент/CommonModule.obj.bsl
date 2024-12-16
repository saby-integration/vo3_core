
#Область include_core_base_Helpers_РаботаСоСвойствамиСтруктуры
#КонецОбласти

#Область include_core_base_locale_ЛокализацияНазваниеПродукта
#КонецОбласти

#Область include_base_CommonModule_ИмяМодуляCore
#КонецОбласти

#Область include_base_CommonModule_ИмяМодуляКомандыОбменаДляФормыКлиент
#КонецОбласти

#Область include_base_CommonModule_ИмяМодуляВстраиваниеВСтандартныеФормы
#КонецОбласти

#Область include_base_ИмяОбработки
#КонецОбласти

&НаКлиенте
Функция ПолучитьСписокСсылокНаОбъектыКоманды( ПараметрКоманды ) Экспорт
	
	Результат = Новый Структура("Источник", Новый Массив());
	Если ТипЗнч(ПараметрКоманды) = Тип("Массив") Тогда
 		Результат.Источник = ПараметрКоманды;
		Возврат Результат;
	КонецЕсли; 
	
	Если Не ПараметрКоманды.Свойство("Источник") Тогда
		Возврат Результат;
	КонецЕсли; 
	
	Если ТипЗнч(ПараметрКоманды.Источник) = Тип("ТаблицаФормы") ТОгда
		//Форма исписка
		Результат.Источник = ПараметрКоманды.Источник.ВыделенныеСтроки;
	ИначеЕсли ТипЗнч(ПараметрКоманды.Источник) = Тип("Массив") ТОгда
		Результат.Источник = ПараметрКоманды.Источник;
	ИначеЕсли ТипЗнч(ПараметрКоманды.Источник) = Тип("ДанныеФормыСтруктура") ТОгда
		//Форма документа
		мДокументов = Новый Массив();
		мДокументов.Добавить(ПараметрКоманды.Источник.Ссылка);
		Результат.Источник = мДокументов;
	КонецЕсли;  
	
	Результат.Источник = МодульCore().ПривестиДанныеКССылочномуВиду(Результат.Источник);
	Возврат Результат;
КонецФункции

&НаКлиенте
Функция ТребуетсяАутентификация(context_param, Команда, ПараметрКоманды)
	
	РезультатПроверки = (context_param = Неопределено);
	Если РезультатПроверки Тогда
		ВходяшиеПараметры	= Новый Структура("Команда, ПараметрКоманды",Команда,ПараметрКоманды);
		ПроверкаВведенныхДанныхАутентификации = Новый ОписаниеОповещения("_ПослеАутентификации", МодульКомандыОбменаДляФормыКлиент(), ВходяшиеПараметры);
		ОткрытьФормуОбработки("Вход",,,, ПроверкаВведенныхДанныхАутентификации);
	КонецЕсли;   
	
	Возврат РезультатПроверки;
	
КонецФункции

&НаКлиенте
Процедура _ПослеАутентификации( Результат, Параметры ) Экспорт 
	
	Если Результат = Неопределено Тогда
		Возврат;
	КонецЕсли;
	
	ИмяКоманды = Параметры.ПараметрКоманды.ОписаниеКоманды.Представление;
	Если ИмяКоманды = "Загрузить в "+ЛокализацияНазваниеПродукта() Тогда
		ЗагрузитьВСБИС( Параметры.Команда, Параметры.ПараметрКоманды )
	ИначеЕсли ИмяКоманды = "Открыть в "+ЛокализацияНазваниеПродукта() Тогда
		ПриНажатииОткрытьВСБИСПолучитьUID( Параметры.Команда, Параметры.ПараметрКоманды )
	ИначеЕсли ИмяКоманды = "Выгрузить вложения из "+ЛокализацияНазваниеПродукта() Тогда
		ПриНажатииВыгрузитьВложенияИзСБИС( Параметры.Команда, Параметры.ПараметрКоманды )
	//ИначеЕсли ИмяКоманды = "Подписать документ" Тогда
	//	ОтправитьНаПодпись( Параметры.Команда, Параметры.ПараметрКоманды )
	ИначеЕсли ИмяКоманды = "Обновить статусы" Тогда
		ПриНажатииОбновитьСтатусы( Параметры.Команда, Параметры.ПараметрКоманды )
	//Запуск через другую функцию, в которой тоже есть проверка
	//ИначеЕсли ИмяКоманды = "Задачи" Тогда
		//Задачи( Параметры.Команда, Параметры.ПараметрКоманды )
	//ИначеЕсли ИмяКоманды = "Кадровые документы" Тогда
		//КадровыеДокументы( Параметры.Команда, Параметры.ПараметрКоманды )
	КонецЕсли; 
	
КонецПроцедуры

&НаКлиенте
Функция ПолучитьОповещениеОбновлнияТаблицыФормы( Команда, ПараметрКоманды ) Экспорт 
	
	ДопПараметры = Новый Структура("ПараметрКоманды", ПараметрКоманды);
    ОповешениеОЗакрытии = Новый ОписаниеОповещения("ОбновитьТабличнуюЧастьФормы", МодульКомандыОбменаДляФормыКлиент(), ДопПараметры);
    Возврат ОповешениеОЗакрытии; 
	
КонецФункции

&НаКлиенте
Процедура ОбновитьТабличнуюЧастьФормы( Действие, ДополнительныеПараметры ) Экспорт 
	
	ПараметрКоманды    = ДополнительныеПараметры.ПараметрКоманды;
    Если ТипЗнч(ПараметрКоманды.Источник) = Тип("ТаблицаФормы") Тогда
        ТблСписок = ПараметрКоманды.Форма.Элементы.Найти(ПараметрКоманды.Источник.Имя);
        ТблСписок.Обновить();    
	КонецЕсли;
	
КонецПроцедуры

#Область include_core_base_ВстраиваниеВФормы_КомандаВыгрузитьВложенияИзСБИС
#КонецОбласти
 
 
Функция ПроверитьНаличиеПараметровПодключенияНаСервере() Экспорт
	Возврат МодульCore().ПроверитьНаличиеПараметровПодключения();
КонецФункции

Функция ПроисходилЛиОбменДокументов(Источник, ДопПараметры=Неопределено) Экспорт
	Возврат МодульВстраиваниеВСтандартныеФормы().ПроисходилЛиОбменДокументов(Источник, ДопПараметры);
КонецФункции

Функция ПолучитьСсылкиНаДокументыВИнтеграции(Источник, ПолучитьТикет = Ложь) Экспорт
	Возврат МодульВстраиваниеВСтандартныеФормы().ПолучитьСсылкиНаДокументыВИнтеграции(Источник, ПолучитьТикет);
КонецФункции

Функция ПолучитьДействияДляОбъекта(СсылкаНаОбъект, context_params) Экспорт
	Возврат МодульВстраиваниеВСтандартныеФормы().ПолучитьДействияДляОбъекта(СсылкаНаОбъект, context_params);
КонецФункции

Процедура ЗапуститьINIФоновымЗаданием(ini_name, ПараметрыВызоваИни, context_params = Неопределено, ФормаВладелец = Неопределено, ЗаголовокФормы="") Экспорт
	МодульФоновогоЗаданияКлиент().ЗапуститьINIФоновымЗаданием(
			ini_name, 
			ПараметрыВызоваИни, 
			context_params, 
			ФормаВладелец, 
			ЗаголовокФормы);
КонецПроцедуры

Функция ExtExceptionAnalyse(parent)
	Возврат МодульCore().ExtExceptionAnalyse(parent);
КонецФункции

Функция NewExtExceptionСтрока(parent = Неопределено, message = Неопределено, detail = Неопределено, action = Неопределено, dump = Неопределено, type = Неопределено) Экспорт
	Возврат МодульCore().NewExtExceptionСтрока(parent, message, detail, action, dump, type);
КонецФункции

Функция ExtExceptionToMessage(error) Экспорт 
	Возврат МодульCore().ExtExceptionToMessage(error);
КонецФункции


#Область include_core_base_ВстраиваниеВФормы_КомандаОткрытьСБИС
#КонецОбласти

&НаКлиенте
Процедура ПослеОтправитьВСБИС( Действие, ДополнительныеПараметры ) Экспорт 
	
	ПараметрКоманды	= ДополнительныеПараметры.ПараметрКоманды;
	Если ТипЗнч(ПараметрКоманды.Источник) = Тип("ТаблицаФормы") Тогда
		ТблСписок = ПараметрКоманды.Форма.Элементы.Найти(ПараметрКоманды.Источник.Имя);
		ТблСписок.Обновить();
	КонецЕсли;  
	
КонецПроцедуры

#Область include_core_base_Авторизация_Form_Вход_НеобходимоВвестиКодПодтверждения
#КонецОбласти

#Область include_core_base_ВстраиваниеВФормы_КомандаЗагрузитьВСБИС
#КонецОбласти


&НаКлиенте
Процедура ПереоткрытиеФормыОтправки( Результат, Параметры ) Экспорт
	Если Результат = Неопределено Тогда
		Возврат;
	КонецЕсли;
	
	мСсылок = ПолучитьСписокСсылокНаОбъектыКоманды( Параметры.ОбъектыОтправки );
	ПроверкаОбмена = МодульВстраиваниеВСтандартныеФормы().ПроисходилЛиОбменДокументов(мСсылок.Источник);
	Для Каждого СтрокаДанных Из ПроверкаОбмена.ОбменаНебыло Цикл
		ПроверкаОбмена.БылОбмен.Добавить(СтрокаДанных);
	КонецЦикла;
	Параметры.Вставить("ПараметрКоманды", Новый Структура("Источник", ПроверкаОбмена.БылОбмен));
	ОповешениеОЗакрытии = Новый ОписаниеОповещения("ПослеОтправитьВСБИС", МодульКомандыОбменаДляФормыКлиент(), Параметры);
	ПараметрыВФорму = Новый Структура("Источник", ПроверкаОбмена.БылОбмен);
	ОткрытьФормуОбработки("ЗагрузкаДокументов",ПараметрыВФорму,Параметры.ВладелецФормы, Новый УникальныйИдентификатор(),ОповешениеОЗакрытии);
КонецПроцедуры

#Область include_core_base_ВстраиваниеВФормы_КомандаОбновитьСтатусы
#КонецОбласти

&НаКлиенте
Процедура ПриНажатииЗадачи( Команда, ПараметрКоманды ) Экспорт
	ЗапуститьОповещениеПриНаличииСессии(МодульКомандыОбменаДляФормыКлиент(), "ОткрытьЗадачи", Новый Структура());
КонецПроцедуры

&НаКлиенте
Процедура ПриНажатииКадровыеДокументы( Команда, ПараметрКоманды ) Экспорт 
	ЗапуститьОповещениеПриНаличииСессии(МодульКомандыОбменаДляФормыКлиент(), "ОткрытьКадровыеДокументы", Новый Структура());
КонецПроцедуры

&НаКлиенте
Процедура ПриНажатииОтпуска( Команда, ПараметрКоманды ) Экспорт 
	ЗапуститьОповещениеПриНаличииСессии(МодульКомандыОбменаДляФормыКлиент(), "ОткрытьОтпуска", Новый Структура());
КонецПроцедуры

&НаКлиенте
Процедура ПриНажатииБольничные( Команда, ПараметрКоманды ) Экспорт 
	ЗапуститьОповещениеПриНаличииСессии(МодульКомандыОбменаДляФормыКлиент(), "ОткрытьБольничные", Новый Структура());
КонецПроцедуры

&НаКлиенте
Процедура ОткрытьОтчетОЗагрузке(context_param, ПараметрыФормы) Экспорт
	АдресСтраницы = context_param.api_url+"/integration_config/ext-sync-doc-list/page/?extSyncDocId="+ПараметрыФормы.extSyncDocId;
	ПараметрыФормы.Вставить("Заголовок", "Отчет об отправке");
	ПараметрыФормы.Вставить("АдресСтраницы", АдресСтраницы);
	ПараметрыФормы.Вставить("context_param", context_param);
	ОткрытьФормуОбработки("Browser", ПараметрыФормы,,"Отчет об отправке");
КонецПроцедуры

&НаКлиенте
Процедура ОткрытьИсториюОбмена(context_param, ПараметрыФормы) Экспорт
	АдресСтраницы = context_param.api_url+"/integration_config/ext-sync-doc-list/page/?connectionId="+context_param.ConnectionId;
	ПараметрыФормы.Вставить("Заголовок", "История обмена");
	ПараметрыФормы.Вставить("АдресСтраницы", АдресСтраницы);
	ПараметрыФормы.Вставить("context_param", context_param);
	ОткрытьФормуОбработки("Browser", ПараметрыФормы,,"История обмена");
КонецПроцедуры

&НаКлиенте
Процедура ОткрытьОтпуска(context_param, ПараметрыФормы) Экспорт
	АдресСтраницы = context_param.api_url+"/page/holidays?";
	ПараметрыФормы.Вставить("Заголовок", "Отпуска");
	ПараметрыФормы.Вставить("АдресСтраницы", АдресСтраницы);
	ПараметрыФормы.Вставить("context_param", context_param);
	ОткрытьФормуОбработки("Browser", ПараметрыФормы,,"Отпуска");
КонецПроцедуры

&НаКлиенте
Процедура ОткрытьБольничные(context_param, ПараметрыФормы) Экспорт
	АдресСтраницы = context_param.api_url+"/page/allowance?";
	ПараметрыФормы.Вставить("Заголовок", "Больничные");
	ПараметрыФормы.Вставить("АдресСтраницы", АдресСтраницы);
	ПараметрыФормы.Вставить("context_param", context_param);
	ОткрытьФормуОбработки("Browser", ПараметрыФормы,,"Больничные");
КонецПроцедуры

&НаКлиенте
Процедура ЗапуститьОповещениеПриНаличииСессии_ПослеАутентификации(Результат, Параметры) Экспорт
	Если Результат <> Неопределено Тогда
		ЗапуститьОповещениеПриНаличииСессии(Параметры.ОбъектОповещения, Параметры.ИмяОповещения, Параметры.ПараметрыОповещения);
	КонецЕсли;
КонецПроцедуры

&НаКлиенте
Функция ЗапуститьОповещениеПриНаличииСессии(ОбъектОповещения, ИмяОповещения, Параметры) Экспорт
	
	context_param = МодульCore().ПроверитьНаличиеПараметровПодключения();
	Если context_param = Неопределено Тогда
		
		ПараметрыОбратногоВызова	= Новый Структура("ОбъектОповещения, ИмяОповещения, ПараметрыОповещения", ОбъектОповещения, ИмяОповещения, Параметры);
		Оповещение = Новый ОписаниеОповещения(
			"ЗапуститьОповещениеПриНаличииСессии_ПослеАутентификации", 
			Saby_КомандыОбменаДляФормыКлиент, 
			ПараметрыОбратногоВызова);
			
		ОткрытьФормуОбработки("Вход",,,, Оповещение);
		Возврат Неопределено; 
		
	КонецЕсли;
		
	Оповещение = Новый ОписаниеОповещения(ИмяОповещения, ОбъектОповещения, Параметры);
	ВыполнитьОбработкуОповещения(Оповещение, context_param);
	
КонецФункции

&НаКлиенте
Процедура ОткрытьЗадачи(Параметр, ДопПараметры) Экспорт
	context_param	= Saby_Core.НастройкиПодключенияПрочитать();
	Если get_prop(context_param, "session") <> Неопределено Тогда
		АдресСтраницы = context_param.api_url+"/page/tasks-in-work"; //integration-tasks?connector=1C
	ИначеЕсли get_prop(context_param, "api_url") <> Неопределено Тогда
		АдресСтраницы = context_param.api_url+"/auth/";
	Иначе
		АдресСтраницы = "https://ie-1c.saby.ru/auth/";	
	КонецЕсли;	
	ПараметрыФормы = Новый Структура();
	ПараметрыФормы.Вставить("Заголовок", "Задачи");
	ПараметрыФормы.Вставить("АдресСтраницы", АдресСтраницы);
	ПараметрыФормы.Вставить("context_param", context_param);
	ОткрытьФормуОбработки("Browser", ПараметрыФормы,,"Задачи");
КонецПроцедуры

&НаКлиенте
Процедура ОткрытьКадровыеДокументы(Параметр, ДопПараметры) Экспорт
	context_param	= Saby_Core.НастройкиПодключенияПрочитать();
	Если get_prop(context_param, "session") <> Неопределено Тогда
		АдресСтраницы = context_param.api_url+"/page/tasks-in-work"; //integration-tasks?connector=1C
	ИначеЕсли get_prop(context_param, "api_url") <> Неопределено Тогда
		АдресСтраницы = context_param.api_url+"/auth/";
	Иначе
		АдресСтраницы = "https://ie-1c.saby.ru/auth/";	
	КонецЕсли;	
	ПараметрыФормы = Новый Структура();
	ПараметрыФормы.Вставить("Заголовок", "Задачи");
	ПараметрыФормы.Вставить("АдресСтраницы", АдресСтраницы);
	ПараметрыФормы.Вставить("context_param", context_param);
	ОткрытьФормуОбработки("Browser", ПараметрыФормы,,"Кадровые документы");
КонецПроцедуры

&НаКлиенте
Процедура ОткрытьФормуБраузера(Заголовок, АдресСтраницы, Уникальность=Неопределено) Экспорт
	ПараметрыФормы = Новый Структура( "Заголовок, АдресСтраницы",Заголовок, АдресСтраницы);
	ОткрытьФормуОбработки("Browser", ПараметрыФормы,,Уникальность );
КонецПроцедуры

&НаКлиенте
Процедура ОткрытьФормуОтчетаОЗагрузке(ПараметрыЗагрузки) Экспорт
	АдресСтраницы = ПараметрыЗагрузки["params"]["api_url"]+
	"/ext-sync-doc/page/?extSyncDocId="+
	ПараметрыЗагрузки["operation_uuid"];
	ОткрытьФормуБраузера("Отчет об отправке", АдресСтраницы, АдресСтраницы);
КонецПроцедуры

&НаКлиенте
Процедура ОтправитьРасчетныйЛистокВСБИС(ПараметрыВызова, context_params) Экспорт	
	МодульФоновогоЗаданияКлиент().ЗапуститьINIФоновымЗаданием("РасчетныйЛисток_send", ПараметрыВызова, context_params, Неопределено, "Отправка в "+ЛокализацияНазваниеПродукта());	
КонецПроцедуры 

&НаКлиенте
Процедура ВыполнитьПроизвольныйИНИ(ИмяИНИФайла, ПараметрыВызова) Экспорт	
	МодульФоновогоЗаданияКлиент().ЗапуститьINIФоновымЗаданием(ИмяИНИФайла, ПараметрыВызова, Неопределено, Неопределено, "Отправка в "+ЛокализацияНазваниеПродукта());	
КонецПроцедуры 

&НаКлиенте
Функция ПроверитьПолнотуДанныхОтбораДляВызоваИНИ(ПараметрыВызова)
	Если ПараметрыВызова.Количество() = 0 Тогда
		ПоказатьОповещениеПользователя(
		"Нет данных для отбора по расчётным листкам.",,
		"Ошибка подготовки данных"
		,БиблиотекаКартинок["Ошибка32"]
		,СтатусОповещенияПользователя.Важное);
		Возврат Ложь;
	КонецЕсли;
	Возврат Истина;
КонецФункции

&НаКлиенте
Процедура ОтправитьСокращенныйРасчетныйЛистокВСБИС(ПараметрыВызова, context_params) Экспорт
	ПараметрыВызова = Saby_ВстраиваниеВСтандартныеФормы.ПодготовитьДанныеПрочийКадровыйРасчетныйЛисток(ПараметрыВызова);
	Если  НЕ ПроверитьПолнотуДанныхОтбораДляВызоваИНИ(ПараметрыВызова) Тогда
		Возврат;
	КонецЕсли;
	МодульФоновогоЗаданияКлиент().ЗапуститьINIФоновымЗаданием("СокращенныйРасчетныйЛисток_send", ПараметрыВызова, context_params, Неопределено, "Отправка в "+ЛокализацияНазваниеПродукта());
КонецПроцедуры

&НаКлиенте
Процедура ОтправитьПрочийКадровыйРасчетныйЛистокВСБИС(ПараметрыВызова) Экспорт
	ПараметрыВызова = Saby_ВстраиваниеВСтандартныеФормы.ПодготовитьДанныеПрочийКадровыйРасчетныйЛисток(ПараметрыВызова);
	Если  НЕ ПроверитьПолнотуДанныхОтбораДляВызоваИНИ(ПараметрыВызова) Тогда
		Возврат;
	КонецЕсли;
	МодульФоновогоЗаданияКлиент().ЗапуститьINIФоновымЗаданием("ПрочийКадровыйРасчетныйЛисток_send", ПараметрыВызова, Неопределено, Неопределено, "Отправка в "+ЛокализацияНазваниеПродукта());
КонецПроцедуры


#Область include_core_base_ФоновыеЗадания_МодульФоновогоЗаданияКлиент
#КонецОбласти

&НаКлиенте
Процедура УстановитьПризнакУчаствуетВКЭДО(Команда, ПараметрКоманды ) Экспорт
	мСсылок = ПолучитьСписокСсылокНаОбъектыКоманды( ПараметрКоманды );
	Для Каждого СсылкаСотрудник Из мСсылок.Источник Цикл
		ПредЗначение = Saby_Core.ПолучитьЗначениеСвойства(СсылкаСотрудник, "КЭДО", Ложь);
		Saby_Core.УстановитьЗначениеСвойства(СсылкаСотрудник, "КЭДО", НЕ ПредЗначение);
	КонецЦикла;

	Если ТипЗнч(ПараметрКоманды.Источник) = Тип("ТаблицаФормы") Тогда
		ТблСписок = ПараметрКоманды.Форма.Элементы.Найти(ПараметрКоманды.Источник.Имя);
		ТблСписок.Обновить();
	КонецЕсли;  
КонецПроцедуры

&НаКлиенте
Процедура ПолучитьПризнакУчаствуетВКЭДО(Команда, ПараметрКоманды ) Экспорт
	мСсылок = ПолучитьСписокСсылокНаОбъектыКоманды( ПараметрКоманды );
	
	Для Каждого СсылкаСотрудник Из мСсылок.Источник Цикл
		ПредЗначение = Saby_Core.ПолучитьДанныеПоСотруднику(СсылкаСотрудник);
		Если Тип("Булево") = ТипЗнч(ПредЗначение) Тогда
			Saby_Core.УстановитьЗначениеСвойства(СсылкаСотрудник, "КЭДО", ПредЗначение);
		КонецЕсли;
	КонецЦикла;
	
	Если ТипЗнч(ПараметрКоманды.Источник) = Тип("ТаблицаФормы") Тогда
		ТблСписок = ПараметрКоманды.Форма.Элементы.Найти(ПараметрКоманды.Источник.Имя);
		ТблСписок.Обновить();
	КонецЕсли;
КонецПроцедуры

&НаКлиенте
Процедура ОткрытьЖурналДокументовКЭДОСФильтромПоОбъектам(Команда, ПараметрКоманды ) Экспорт
	мСсылок = ПолучитьСписокСсылокНаОбъектыКоманды( ПараметрКоманды );
	
	ФильтрСписка	= Новый Массив;
	ФильтрСписка.Добавить( 
		Новый Структура(
			"Поле, ПравоеЗначение, ВидСравнения",
			"Сотрудник",
			мСсылок.Источник,
			ВидСравненияКомпоновкиДанных.ВСписке)
	);

	ДопПараметры	= Новый Структура();
	ДопПараметры.Вставить("Фильтр", ФильтрСписка);

	ФормыИсключенияСервисаАккаунта = Новый Массив;
	ФормыИсключенияСервисаАккаунта.Добавить("Обработка.СписокСотрудников.Форма.ФормаСпискаСотрудников"); // КОРП
	ФормыИсключенияСервисаАккаунта.Добавить("Справочник.Сотрудники.Форма.ФормаСписка"); // ПРОФ
	ФормыИсключенияСервисаАккаунта.Добавить("Справочник.Сотрудники.Форма.ФормаСпискаРасширенная"); // КАМИН
	ФормыИсключенияСервисаАккаунта.Добавить("Справочник.Сотрудники.Форма.ФормаЭлемента"); // Общая
	Если ФормыИсключенияСервисаАккаунта.Найти(ПараметрКоманды.Форма.ИмяФормы) <> Неопределено Тогда
		//На формах исключения не должно быть авто фильтра по сервису и аккаунту
		context_param = Новый Структура();
		ДопПараметры.Вставить("context_param", context_param);
	КонецЕсли;
	ОткрытьФормуОбработки("ДокументыКЭДО", ДопПараметры, ПараметрКоманды.Форма, "ДокументыКЭДО"); 
КонецПроцедуры

&НаКлиенте
Функция ПутьКФормамОбработки()
	ИмяОбработки = ИмяОбработки();
 	ПутьКФормам = "Обработка."+ИмяОбработки+".Форма.";
	Возврат ПутьКФормам;
КонецФункции     

&НаКлиенте
Процедура ОткрытьФормуОбработки(ИмяФормы, ПараметрыФормы = Неопределено, ВладелецФормы = Неопределено, Уникальность=Неопределено, ОписаниеОповещения = Неопределено, РежимОткрытияОкна= Неопределено)
	ОткрытьФорму(ПутьКФормамОбработки() + ИмяФормы, ПараметрыФормы, ВладелецФормы, Уникальность,,, ОписаниеОповещения, РежимОткрытияОкна);
КонецПроцедуры

&НаКлиенте
Функция ЭтотМодуль()
	Возврат МодульКомандыОбменаДляФормыКлиент();
КонецФункции

#Область include_core_base_Helpers_ПолучитьРеквизитГлавнойФормыОбщийМодуль
#КонецОбласти

#Область include_core_base_ОсобенностиПлатформы_РаботаСоСтроками
#КонецОбласти

#Область include_core_base_Helpers_ПолучитьРегламенты
#КонецОбласти

#Область include_core_base_Helpers_ПолучитьФункциональныеФормы
#КонецОбласти

#Область include_core_base_Helpers_ПолучитьФормуОбработки
#КонецОбласти

#Область include_core_base_Helpers_КартинкиУспешноОшибка
#КонецОбласти

#Область include_core_base_Helpers_ПолучитьПрямуюСсылку
#КонецОбласти

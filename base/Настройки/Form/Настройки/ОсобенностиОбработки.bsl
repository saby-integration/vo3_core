
Процедура ПослеОткрытияДляВнешнейОбработки()
	exchange_method = "API";
	ЭлементыФормочки = ПолучитьЭлементыФормыНаСервере();
	ЭлементыФормочки.грПриглашение.Видимость			= Истина; 
	ЭлементыФормочки.run_docflow.Видимость				= Истина;
	ЭлементыФормочки.kedo_mark.Видимость				= Истина;
	ЭлементыФормочки.Вложения.Видимость					= Истина; 
	ЭлементыФормочки.ОткрытьКадровыеДокументы.Видимость	= Ложь; 
	ЭлементыФормочки.ДекорацияЗадачиНативные.Видимость	= Ложь; 
	ЭлементыФормочки.ОткрытьЗадачи.Видимость			= Истина; 
	ЭлементыФормочки.ОткрытьИсториюОбмена.Видимость		= Истина;
	ЭлементыФормочки.Обновление.Видимость				= Истина;
	ЭлементыФормочки.грТема.Видимость					= Истина;
КонецПроцедуры

&НаКлиенте
Функция ЗапуститьОповещениеПриНаличииСессии(ИмяОповещения, ОбъектОповещения = Неопределено) Экспорт
	
	ПараметрыОповещения = Новый Структура;
	Если ОбъектОповещения = Неопределено Тогда
		ОбъектОповещения = ЭтаФорма;
	КонецЕсли;
	
	context_param = ПроверитьНаличиеПараметровПодключенияНаСервере();
	Если context_param = Неопределено Тогда
		
		ПараметрыОбратногоВызова = Новый Структура("ОбъектОповещения, ИмяОповещения, ПараметрыОповещения",
			ОбъектОповещения, ИмяОповещения, ПараметрыОповещения);
			
		Оповещение = Новый ОписаниеОповещения(
			"ЗапуститьОповещениеПриНаличииСессии_ПослеАутентификации", 
			ЭтаФорма, 
			ПараметрыОбратногоВызова);
			
		ОткрытьФормуОбработки("Вход",, ЭтаФорма,, Оповещение);
		
		Возврат Неопределено; 
		
	КонецЕсли;
		
	Оповещение = Новый ОписаниеОповещения(ИмяОповещения, ОбъектОповещения, ПараметрыОповещения);
	ВыполнитьОбработкуОповещения(Оповещение, context_param);
	
КонецФункции

&НаКлиенте
Процедура ЗапуститьОповещениеПриНаличииСессии_ПослеАутентификации(Результат, ПереданныеПараметры) Экспорт
	Если Результат <> Неопределено Тогда
		ЗапуститьОповещениеПриНаличииСессии(ПереданныеПараметры.ИмяОповещения, ПереданныеПараметры.ОбъектОповещения);
	КонецЕсли;
КонецПроцедуры

&НаКлиенте
Процедура ОткрытьРедакторФайловНастроек(context_param, ПараметрыФормы) Экспорт
	АдресСтраницы = context_param.api_url
					+ "/blockly_editor/page/?id=" + context_param.ConnectionId + "&connector=1C&command=1C";
	ОткрываемаяФорма = ПолучитьФормуОбработки("Browser", ПутьКФормамОбработки(), , ЭтаФорма);
	ОткрываемаяФорма.КлючУникальности = Новый УникальныйИдентификатор;
	ОткрываемаяФорма.Заголовок = "Редактор файлов настроек";
	ОткрываемаяФорма.АдресСтраницы = АдресСтраницы;
	ОткрываемаяФорма.Открыть();
КонецПроцедуры

&НаКлиенте
Процедура ОткрытьЗадачи(context_param, ПараметрыФормы) Экспорт
	АдресСтраницы = context_param.api_url + "/page/tasks-in-work";
	ОткрываемаяФорма = ПолучитьФормуОбработки("Browser", ПутьКФормамОбработки(), , ЭтаФорма);
	ОткрываемаяФорма.КлючУникальности = Новый УникальныйИдентификатор;
	ОткрываемаяФорма.Заголовок = "Задачи";
	ОткрываемаяФорма.АдресСтраницы = АдресСтраницы;
	ОткрываемаяФорма.context_param = context_param;
	ОткрываемаяФорма.Открыть();
КонецПроцедуры

&НаКлиенте
Процедура ОткрытьКадровыеДокументы(context_param, ПараметрыФормы) Экспорт
	АдресСтраницы = context_param.api_url + "/page/cadres?";
	ОткрываемаяФорма = ПолучитьФормуОбработки("Browser", ПутьКФормамОбработки(), , ЭтаФорма);
	ОткрываемаяФорма.КлючУникальности = Новый УникальныйИдентификатор;
	ОткрываемаяФорма.Заголовок = "Кадровые документы";
	ОткрываемаяФорма.АдресСтраницы = АдресСтраницы;
	ОткрываемаяФорма.context_param = context_param;
	ОткрываемаяФорма.Открыть();
КонецПроцедуры

&НаКлиенте
Процедура ОткрытьИсториюОбмена(context_param, ПараметрыФормы) Экспорт
	АдресСтраницы = context_param.api_url + "/ext-sync-doc-list/page/?connectionId="
					+ context_param.ConnectionId;
	ОткрываемаяФорма = ПолучитьФормуОбработки("Browser", ПутьКФормамОбработки(), , ЭтаФорма);
	ОткрываемаяФорма.КлючУникальности = Новый УникальныйИдентификатор;
	ОткрываемаяФорма.Заголовок = "История обмена";
	ОткрываемаяФорма.АдресСтраницы = АдресСтраницы;
	ОткрываемаяФорма.context_param = context_param;
	ОткрываемаяФорма.Открыть();
КонецПроцедуры

&НаСервере
Процедура НачальнаяИнициализацияСправочников()
	//Заглушка
КонецПроцедуры


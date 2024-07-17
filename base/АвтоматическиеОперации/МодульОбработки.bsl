
Функция ФильтрыРоботаПоУмолчанию() Экспорт 
	Фильтры = Новый Структура;	
	ОбщиеПараметры = ОбщиеНастройкиПрочитать();
	ExtSysUid = get_prop(ОбщиеПараметры, "ExtSysUid", Неопределено);
   	parent = get_prop(ОбщиеПараметры, "parent", Неопределено);
    Фильтры.Вставить("Parent", parent); 
    Фильтры.Вставить("Connector", "Robot1C"); 
    Возврат Фильтры; 
КонецФункции	

Функция ДополнительныеПоляРоботаПоУмолчанию() Экспорт
	ДопПоля = Новый Массив;	
	ДопПоля.Добавить("Format"); 
	ДопПоля.Добавить("Title"); 
	ДопПоля.Добавить("json_connection"); 
    ДопПоля.Добавить("ConfigId"); 
    ДопПоля.Добавить("SubsystemVersion"); 
    ДопПоля.Добавить("SystemId"); 
    ДопПоля.Добавить("NextRun"); 
    ДопПоля.Добавить("LastRun"); 
    ДопПоля.Добавить("Sync"); 
    ДопПоля.Добавить("StatusID"); 
	ДопПоля.Добавить("Data"); 
    Возврат ДопПоля; 	
КонецФункции

Функция ДатаСледующегоЗапускаАлгоритмаПоПараметрам(Параметры) Экспорт
	Периодичность = 0; ВремяНачалаСекунды = 0; ВремяОкончанияСекунды = 0; ПериодичностьДня = 0; ВремяНачала = 0; ВремяОкончания = 0; 
	ДатаСледующегоВыполнения = "";
	Если ТипЗнч(Параметры) = Тип("Структура") Тогда
		Периодичность = ?(Параметры.Свойство("Периодичность"), Параметры.Периодичность, Периодичность);
		ПериодичностьДня = ?(Параметры.Свойство("ПериодичностьДня"), Параметры.ПериодичностьДня, ПериодичностьДня);
		ВремяНачала = ?(Параметры.Свойство("ВремяНачала"), Параметры.ВремяНачала, ВремяНачала);
		ВремяОкончания = ?(Параметры.Свойство("ВремяОкончания"), Параметры.ВремяОкончания, ВремяОкончания);
		МассивПоДнямНедели = ?(Параметры.Свойство("МассивПоДнямНедели"), Параметры.МассивПоДнямНедели, Новый Массив); 
		Если СтрДлина(ВремяНачала) = 5 Тогда 
			ВремяНачалаСекунды = Число(ЛЕВ(ВремяНачала,2))*3600 + Число(ПРАВ(ВремяНачала,2))*60;
		КонецЕсли;	
		Если СтрДлина(ВремяОкончания) = 5 Тогда 
			ВремяОкончанияСекунды = Число(ЛЕВ(ВремяОкончания,2))*3600 + Число(ПРАВ(ВремяОкончания,2))*60;
		КонецЕсли;
		
		ДниНедели = Новый Массив; 
		Для Сч = 1 По 7 Цикл
			ДниНедели.Добавить(Периодичность = 1);
		КонецЦикла;	
		
		Если Периодичность = 2 Тогда  
			Если ТипЗНч(МассивПоДнямНедели) = Тип("Массив") Тогда
				Если МассивПоДнямНедели.Количество() = 0 Тогда
					Возврат "";
				КонецЕсли;				
				Для Каждого Запись ИЗ МассивПоДнямНедели Цикл 
					Попытка
						ДниНедели.Вставить(Число(Запись)-1, ИСТИНА);
					Исключение
					КонецПопытки;	
				КонецЦикла;			
			КонецЕсли;
		КонецЕсли;  
		
		//Определим Время выполнения
		Если ПериодичностьДня = "00:30" Тогда Шаг = 0.5
		ИначеЕсли ПериодичностьДня = "01:00" Тогда Шаг = 1
		ИначеЕсли ПериодичностьДня = "02:00" Тогда Шаг = 2
		ИначеЕсли ПериодичностьДня = "03:00" Тогда Шаг = 3
		ИначеЕсли ПериодичностьДня = "04:00" Тогда Шаг = 4
		ИначеЕсли ПериодичностьДня = "24:00" Тогда Шаг = 24
		Иначе Шаг = 1000 
		КонецЕсли;
		ТекущееВремяСекунды = ТекущаяДата() - НачалоДня(ТекущаяДата());
		ВремяСледующегоВыполнения = ВремяНачалаСекунды;
		ВремяСч = ВремяНачалаСекунды;
		Пока ВремяОкончанияСекунды > ВремяСч 
			И ВремяСч < 24 * 3600 Цикл
			Если ТекущееВремяСекунды < ВремяСч Тогда
				ВремяСледующегоВыполнения = ВремяСч;
				Прервать;
			КонецЕсли;	
			ВремяСч = ВремяСч + Шаг * 60*60; 
		КонецЦикла;	
		
		//Определим дату выполнения  
		ДатаСледующегоВыполнения = НачалоДня(ТекущаяДата());
		Если ВремяСледующегоВыполнения < ТекущееВремяСекунды Тогда
			ДатаСледующегоВыполнения = ДатаСледующегоВыполнения + 24*60*60; //добавляем сутки,т.к. дата выполнения переносится на следующий день
			ВремяСледующегоВыполнения = ВремяНачалаСекунды;	
		КонецЕсли;
		ДеньНеделиДатыВыполнения = ДеньНедели(ДатаСледующегоВыполнения);
		//Запускаем цикл до воскресенья
		Для Счетчик = ДеньНеделиДатыВыполнения По 7 Цикл  
			ИндексМассива = Счетчик-1;
			Если ДниНедели.Получить(ИндексМассива) = ИСТИНА Тогда 
				ДатаСледующегоВыполнения = ДатаСледующегоВыполнения + (Счетчик - ДеньНеделиДатыВыполнения) * 24*60*60;
				Если НачалоДня(ДатаСледующегоВыполнения) > НачалоДня(ТекущаяДата()) Тогда
					ВремяСледующегоВыполнения = ВремяНачалаСекунды;
				КонецЕсли;	
				Возврат ДатаСледующегоВыполнения + ВремяСледующегоВыполнения;
			КонецЕсли;	
		КонецЦикла;
		
		//Запускаем цикл с понедельника
		Для Счетчик = 1 По ДеньНеделиДатыВыполнения - 1 Цикл  
			ИндексМассива = Счетчик-1;
			Если ДниНедели.Получить(ИндексМассива) = ИСТИНА Тогда 
				ДатаСледующегоВыполнения = ДатаСледующегоВыполнения + (7 - ДеньНеделиДатыВыполнения + Счетчик) * 24*60*60;
				Если НачалоДня(ДатаСледующегоВыполнения) > НачалоДня(ТекущаяДата()) Тогда
					ВремяСледующегоВыполнения = ВремяНачалаСекунды;
				КонецЕсли;
				Возврат ДатаСледующегоВыполнения + ВремяСледующегоВыполнения;
			КонецЕсли;
		КонецЦикла;		
    	
	КонецЕсли;
	Возврат ДатаСледующегоВыполнения;
КонецФункции	

Функция ДатаСледующегоЗапускаАлгоритмаПоData(Data) Экспорт  
	connectionParam = Data.Получить("connectionParam"); 
	СледующаяДатаВыполнения = "";
	Если ТипЗнч(connectionParam) = Тип("Соответствие") Тогда  
		ПараметрыВыполнения = Новый Структура;
		Если connectionParam.Получить("PeriodicityType") <> Неопределено Тогда
			Периодичность = connectionParam["PeriodicityType"];
			ПараметрыВыполнения.Вставить("Периодичность", Периодичность);
		КонецЕсли; 
		Если connectionParam.Получить("RepeatTime") <> Неопределено Тогда
			ПериодичностьДня = connectionParam["RepeatTime"];
			ПараметрыВыполнения.Вставить("ПериодичностьДня", ПериодичностьДня);
		КонецЕсли;
		Если connectionParam.Получить("StartTime") <> Неопределено Тогда  
			ВремяНачала = connectionParam["StartTime"];
			ПараметрыВыполнения.Вставить("ВремяНачала", ВремяНачала);
		КонецЕсли;
		Если connectionParam.Получить("EndTime") <> Неопределено Тогда
			ВремяОкончания = connectionParam["EndTime"];
			ПараметрыВыполнения.Вставить("ВремяОкончания", ВремяОкончания);
		КонецЕсли; 
		Если connectionParam.Получить("DaysSelect") <> Неопределено Тогда
			МассивПоДнямНедели = connectionParam.Получить("DaysSelect");
			ПараметрыВыполнения.Вставить("МассивПоДнямНедели", МассивПоДнямНедели);
		КонецЕсли;
		СледующаяДатаВыполнения = ДатаСледующегоЗапускаАлгоритмаПоПараметрам(ПараметрыВыполнения);
	КонецЕсли;
	Возврат СледующаяДатаВыполнения;
КонецФункции

Процедура ПолучитьАвтоматическиеОперацииФоновыеЗадания(ПараметрыВыполнения, АдресРезультата) Экспорт 
 	Попытка
		Результат = ПолучитьАвтоматическиеОперации(ПараметрыВыполнения.context_param); 
	Исключение 
		Ошибка = ИнформацияОбОшибке();
		Результат = Ошибка;	
	КонецПопытки;	
	ПоместитьВоВременноеХранилище(Результат, ПараметрыВыполнения.АдресРезультата); 
КонецПроцедуры 

Функция ЗапуститьАвтоматическуюОперацию(ПараметрыВыполнения, АдресРезультата) Экспорт 
	Операция = ПараметрыВыполнения.Получить(0); 
	context_param = ПараметрыВыполнения.Получить(1);	
	ИдентификаторОперации = Операция.Получить("Uuid");
	Если Операция.Получить("Data") = Неопределено Тогда
		Если Операция.Получить("dataСтрокой") <> Неопределено Тогда
			Операция.Вставить("Data", local_helper_json_loads(Операция["dataСтрокой"]));	
		Иначе
			Ошибка = "Не передан параметр Data";
			Результат = Новый структура("data, status", Ошибка, "error");		
		КонецЕсли;
	КонецЕсли;	
	
	Data = Операция.Получить("Data");  

	OperationType = Data.Получить("OperationType");
	Если OperationType = "Blockly" Тогда
		СтруктураСоединения = Новый Структура;
		СтруктураСоединения.Вставить("connection_uuid", ИдентификаторОперации);
 		СтруктураСоединения.Вставить("operation_uuid",  Неопределено);
    	context_param.Вставить("operation", СтруктураСоединения);
	
		ПараметрыВызова	= Новый Соответствие(); 
		ПараметрыВызова.Вставить("operation_uuid", 	Неопределено);
		ПараметрыВызова.Вставить("connection_uuid", ИдентификаторОперации);
		ПараметрыВызова.Вставить("params", 			context_param );
		ПараметрыВызова.Вставить("commands_result",	Новый Массив);
		ПараметрыВызова.Вставить("endpoint",		"");
		ПараметрыВызова.Вставить("ini_name",		Data.Получить("OperationId"));
		ПараметрыВызова.Вставить("object",			Новый Структура());
		ПараметрыВызова.Вставить("isRobot", 		ИСТИНА);
		ПараметрыВызова.Вставить("Data", 			Data);
		
		Попытка
			XMLИниФайл	= Load_ini( ПараметрыВызова["ini_name"], ПараметрыВызова );
			Если ТипЗнч(XMLИниФайл) = Тип("Строка") И Врег(Лев(XMLИниФайл,4)) = "<XML"  Тогда
				Результат = Новый Структура("status, data, LoadIni", "complete", Новый Структура("detail, message", ПараметрыВызова["ini_name"], "ИНИ успешно получен"));
				//результат пердачи объектов, только в случае успешного получения ини файла
				Результат = API_BLOCKLY_RUN(ПараметрыВызова);
			Иначе
				Результат = Новый Структура("status, data, LoadIni", "error", Новый Структура("detail, message", ПараметрыВызова["ini_name"], XMLИниФайл));
			КонецЕсли;
		Исключение
			ИнфОбОшибке = ИнформацияОбОшибке();
			Ошибка = ExtExceptionAnalyse(ИнфОбОшибке);
			Результат = Новый структура("data, status", Ошибка, "error");		
		КонецПопытки;
		Если ПараметрыВызова.Получить("isRobot") = ИСТИНА Тогда
			ОбновитьСостояниеРобота(ПараметрыВызова, Результат);
		 КонецЕсли;
		СообщитьПрогресс(,,Результат); 
	КонецЕсли;
	Возврат Неопределено;
КонецФункции

Процедура ОбновитьСостояниеРобота(ПараметрыВызова, РезультатВыполненияАлгоритма) 
	СледующийЗапуск = ДатаСледующегоЗапускаАлгоритмаПоData(ПараметрыВызова["Data"]);
	
	StatusID = 100;	
	StatusMsg = "";	
	
	Если РезультатВыполненияАлгоритма.status = "error" Тогда
		StatusID = 101;
	ИначеЕсли РезультатВыполненияАлгоритма.Свойство("data") Тогда 
		data = РезультатВыполненияАлгоритма.data;  
		CountError = data.Получить(CountError);
		Если CountError<> Неопределено 
			И CountError <> 0 Тогда
			StatusID = 101;	
		КонецЕсли;	
	КонецЕсли;
		
	props = Новый Структура;
	props.Вставить("id",		ПараметрыВызова.Получить("connection_uuid"));
	props.Вставить("NextRun",	СледующийЗапуск);
	props.Вставить("LastRun",	ТекущаяДата());
	props.Вставить("StatusID",	StatusID);
	МассивINI = Новый Массив;
	params = Новый Структура("props,ini", Props, МассивINI);
	
	context_param = ПараметрыВызова.Получить("params");
	res = local_helper_integration_api(context_param, "IntegrationConnection.WriteConnection", params);
КонецПроцедуры	

Функция ПолучитьАвтоматическиеОперации(context_param) Экспорт	
	Фильтры = ФильтрыРоботаПоУмолчанию(); 
    ДопПоля = ДополнительныеПоляРоботаПоУмолчанию();
	СчетчикСтраниц = 0;
	ИтоговыйМассив = Новый Массив;
	Пока ИСТИНА Цикл  
		res = local_helper_api3_connection_list(context_param, Фильтры, ДопПоля,Неопределено, СчетчикСтраниц); 	
		Результат = res.Получить("Result");
		Если ТипЗнч(Результат) = Тип("Массив") Тогда
			Для Каждого ЗаписьОперация ИЗ Результат Цикл
	            ИтоговыйМассив.Добавить(ЗаписьОперация);
			КонецЦикла;
		КонецЕсли;
		
		Если res.Получить("Navigation") <> Неопределено
			И res["Navigation"].Получить("HasMore") = ИСТИНА Тогда
			СчетчикСтраниц = СчетчикСтраниц + 1;
		Иначе
			Прервать;
		КонецЕсли;

	КонецЦикла;	
	Возврат ИтоговыйМассив;
КонецФункции


Функция СообщениеПрогресса() Экспорт
	Возврат "СтандартныеПодсистемы.ДлительныеОперации";
КонецФункции

Функция ОпределитьУзелПланаОбменаПоИдентификатору(ИдентификаторУзлаПланОбмена) Экспорт
	Для Каждого План Из ПланыОбмена Цикл
       Выборка = План.Выбрать();
	   Пока Выборка.Следующий() Цикл  
		   
           Если СокрЛП(Выборка.Ссылка.УникальныйИдентификатор()) = ИдентификаторУзлаПланОбмена Тогда
               Возврат Выборка.Ссылка;
           КонецЕсли;
       КонецЦикла;
   КонецЦикла; 	
   Возврат Неопределено;
КонецФункции

Функция АктивироватьРегламентноеЗаданиеАвтоматическихОпераций() Экспорт 
	ИмяПродукта = ПолучитьИмяПродукта(); 
	КлючЗадания = ИмяПродукта+"_ЗапускАвтоматическихОпераций";
	Отбор = Новый Структура("Ключ", КлючЗадания);
	НайденныеРегЗадания = РегламентныеЗадания.ПолучитьРегламентныеЗадания(Отбор);
	Если НайденныеРегЗадания.Количество() > 0 Тогда 
		РегЗадание = НайденныеРегЗадания.Получить(0);
		Если РегЗадание.Использование = Ложь Тогда
			РасписаниеЗадания = Новый РасписаниеРегламентногоЗадания;
			РасписаниеЗадания.ПериодПовтораДней = 1;
			РасписаниеЗадания.ПериодПовтораВТечениеДня = 3600; //Раз в час
			РегЗадание.Расписание = РасписаниеЗадания;
			РегЗадание.Использование = Истина;  
			Если НЕ ЗначениеЗаполнено(РегЗадание.ИмяПользователя) Тогда 
				РегЗадание.ИмяПользователя = ИмяПользователя();
			КонецЕсли;	
			РегЗадание.Записать();
        КонецЕсли;
	КонецЕсли;	
КонецФункции


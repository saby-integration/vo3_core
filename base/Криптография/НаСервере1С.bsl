Функция ПодписатьНаСервере(context, attachmentList, cert) Экспорт
	Попытка
		МенеджерКриптографии = НайтиМенеджерКриптографии(cert.Алгоритм); 
		ХранилищеСертификатовКриптографии = МенеджерКриптографии.ПолучитьХранилищеСертификатов();
		Серт = ХранилищеСертификатовКриптографии.НайтиПоОтпечатку(cert.Отпечаток);
		Для каждого attach из attachmentList Цикл
			ДвоичныеДанные = local_helper_download_from_link(context.params, attach["Файл"]["Ссылка"]); 
			Подпись = МенеджерКриптографии.Подписать(ДвоичныеДанные, Серт);
			Файлы = Новый Структура("Файл", Новый Структура("ДвоичныеДанные", СтрЗаменить(СтрЗаменить(Base64Строка(Подпись),Символы.ПС,""),Символы.ВК,"")));
			мФайлы = Новый Массив;
			мФайлы.Добавить(Файлы);
			attach.Вставить("Подпись", мФайлы);
		КонецЦикла
	Исключение
		ИнфОбОшибке = ИнформацияОбОшибке();
		Возврат Новый Массив;
	КонецПопытки;	
КонецФункции

Функция сбисСоздатьМенеджерКриптографииНаСервере(ОписанияПрограмм, Алгоритм = Неопределено) Экспорт
	
	Менеджер = Неопределено;
	Для Каждого СвойстваПрограммы Из ОписанияПрограмм Цикл
		
		Попытка
			ИнформацияМодуля = СредстваКриптографии.ПолучитьИнформациюМодуляКриптографии(
				СвойстваПрограммы.ИмяПрограммы,
				СвойстваПрограммы.ПутьКПрограмме,
				СвойстваПрограммы.ТипПрограммы);
		Исключение
			Продолжить;
		КонецПопытки;
		
		Если ИнформацияМодуля = Неопределено Тогда
			Менеджер = Неопределено;
			Продолжить;
		КонецЕсли;
		
		Попытка
			Менеджер = Новый МенеджерКриптографии(
				СвойстваПрограммы.ИмяПрограммы,
				СвойстваПрограммы.ПутьКПрограмме,
				СвойстваПрограммы.ТипПрограммы);
		Исключение
			Продолжить;
		КонецПопытки;

		Если Алгоритм<>Неопределено Тогда
			Если Алгоритм.Найти(Менеджер.АлгоритмПодписи) = Неопределено Тогда
				Менеджер = Неопределено;
				Продолжить;
			КонецЕсли;
		КонецЕсли;
		
		Прервать; // Требуемый менеджер криптографии получен.
	КонецЦикла;  
	Если Менеджер = Неопределено Тогда
		ВызватьИсключение("Не удалось создать менеджер криптографии. Возможно в настройках неверно указана программа электронной подписи.");		
	КонецЕсли;
	Возврат Менеджер;
	
КонецФункции 

Функция НайтиМенеджерКриптографии(Алгоритм = Неопределено)
	Если МенеджерыКриптографии = Неопределено Тогда
		Менеджеры = СоздатьМенеджерыКриптографииНаСервере(сбисПрограммыКриптографии());
		МенеджерыКриптографии = Новый Соответствие; 
		Для Каждого Менеджер Из Менеджеры Цикл
			МенеджерыКриптографии.Вставить(Менеджер.АлгоритмПодписи, Менеджер);
		КонецЦикла;
	КонецЕсли;
	Если Алгоритм = Неопределено Тогда
		Для Каждого Элем Из МенеджерыКриптографии Цикл
			Возврат Элем.Значение;
		КонецЦикла
	Иначе
		Возврат get_prop(МенеджерыКриптографии, Алгоритм);
	КонецЕсли
КонецФункции


Функция СоздатьМенеджерыКриптографииНаСервере(ПрограммыКриптографии, Алгоритм = Неопределено)
	Менеджеры = Новый Массив;
	Для Каждого СвойстваПрограммы Из ПрограммыКриптографии Цикл
		
		Попытка
			ИнформацияМодуля = СредстваКриптографии.ПолучитьИнформациюМодуляКриптографии(
				СвойстваПрограммы.ИмяПрограммы,
				СвойстваПрограммы.ПутьКПрограмме,
				СвойстваПрограммы.ТипПрограммы);
		Исключение
			Продолжить;
		КонецПопытки;
		
		Если ИнформацияМодуля = Неопределено Тогда
			Продолжить;
		КонецЕсли;
		
		Попытка
			Менеджер = Новый МенеджерКриптографии(СвойстваПрограммы.ИмяПрограммы, СвойстваПрограммы.ПутьКПрограмме, СвойстваПрограммы.ТипПрограммы);
		Исключение
			Продолжить;
		КонецПопытки;

		Если Алгоритм<>Неопределено Тогда
			Если Менеджер.АлгоритмПодписи <> Алгоритм Тогда
				Менеджер = Неопределено;
				Продолжить;
			КонецЕсли;
		КонецЕсли;
		
        Менеджеры.Добавить(Менеджер);
	КонецЦикла;
	Возврат Менеджеры;
	
КонецФункции

Функция сбисСписокЛокальныхСертификатовНаСервере() Экспорт
	ЛокальныеСертификатыНаСервере = Новый Структура("Отпечатки, Алгоритмы",Новый Массив(), Новый Соответствие());
	МенеджерКриптографии = НайтиМенеджерКриптографии();
	Если МенеджерКриптографии = Неопределено Тогда
		Возврат ЛокальныеСертификатыНаСервере;
	КонецЕсли;
	ХранилищеСертификатовКриптографии = МенеджерКриптографии.ПолучитьХранилищеСертификатов();
	Сертификаты = ХранилищеСертификатовКриптографии.ПолучитьВсе();
	Для Каждого Серт из Сертификаты Цикл
		ЛокальныеСертификатыНаСервере["Отпечатки"].Добавить(Серт.Отпечаток);
	КонецЦикла; 
	Для Каждого Менеджер Из МенеджерыКриптографии Цикл
		ЛокальныеСертификатыНаСервере["Алгоритмы"].Вставить(Менеджер.Ключ);
	КонецЦикла; 
	
	Возврат ЛокальныеСертификатыНаСервере;

КонецФункции

Функция сбисСписокСертификатовДляАвторизацииНаСервере(ОписанияПрограмм, ТекстОшибки) Экспорт
	СертификатыДляАвторизации = Новый Массив();
	Попытка
		МенеджерКриптографии = сбисСоздатьМенеджерКриптографииНаСервере(ОписанияПрограмм);
	Исключение    
		ТекстОшибки = ИнформацияОбОшибке().Описание;
		Возврат СертификатыДляАвторизации;
	КонецПопытки;
	
	ХранилищеСертификатовКриптографии = МенеджерКриптографии.ПолучитьХранилищеСертификатов();
	ЛокальныеСертификатыНаСервере = ХранилищеСертификатовКриптографии.ПолучитьВсе(); 
	Для Каждого Серт из ЛокальныеСертификатыНаСервере Цикл
		Попытка
			СертДвоичныеДанные = СтрЗаменить(СтрЗаменить(Base64Строка(Серт.Выгрузить()),Символы.ПС,""),Символы.ВК,"");
			СертОтпечаток = СтрЗаменить(Строка(Серт.Отпечаток), " ", "");
			СертификатыДляАвторизации.Добавить(Новый Структура("ДвоичныеДанные,Отпечаток,Название,ФИО,Должность,ДействителенПо",СертДвоичныеДанные, СертОтпечаток,Серт.Субъект.CN, Серт.Субъект.SN+" "+Серт.Субъект.GN,Серт.Субъект.T,Серт.ДатаОкончания));
		Исключение
		КонецПопытки;
	КонецЦикла;
	Возврат СертификатыДляАвторизации;

КонецФункции

Функция сбисДвоичныеДанныеСертификатаПоОтпечаткуНаСервере(ОписанияПрограмм, Отпечаток) Экспорт
	Попытка
		МенеджерКриптографии = сбисСоздатьМенеджерКриптографииНаСервере(ОписанияПрограмм);
	Исключение    
		Возврат Ложь;
	КонецПопытки;
	ХранилищеСертификатовКриптографии = МенеджерКриптографии.ПолучитьХранилищеСертификатов();
	Сертификаты = ХранилищеСертификатовКриптографии.ПолучитьВсе(); 
	Для Каждого Серт из Сертификаты Цикл
		Если СтрЗаменить(Строка(Серт.Отпечаток), " ", "") = Отпечаток Тогда
			Возврат СтрЗаменить(СтрЗаменить(Base64Строка(Серт.Выгрузить()),Символы.ПС,""),Символы.ВК,"");
		КонецЕсли;
	КонецЦикла;
КонецФункции

Функция сбисПодписатьФайлНаСервере(ОписанияПрограмм, ДвоичныеДанные, Сертификат, Алгоритм, ТекстОшибки) Экспорт
	Попытка
		МенеджерКриптографии = сбисСоздатьМенеджерКриптографииНаСервере(ОписанияПрограмм, Алгоритм);
	Исключение    
		ТекстОшибки = ИнформацияОбОшибке().Описание;
		Возврат Ложь;
	КонецПопытки;
	Серт = Новый СертификатКриптографии(Base64Значение(Сертификат));
	Подпись = МенеджерКриптографии.Подписать(Base64Значение(ДвоичныеДанные), Серт);
	Возврат СтрЗаменить(СтрЗаменить(Base64Строка(Подпись),Символы.ПС,""),Символы.ВК,"");
КонецФункции

Функция сбисРасшифроватьНаСервере(ОписанияПрограмм, ДвоичныеДанные) Экспорт
	МенеджерКриптографии = сбисСоздатьМенеджерКриптографииНаСервере(ОписанияПрограмм);
	ДвоичныеДанныеРашифрованные = МенеджерКриптографии.Расшифровать(Base64Значение(ДвоичныеДанные));
	НедопустимыеСимволы = Новый Массив;
	НедопустимыеСимволы.Добавить(Символы.ПС);
	НедопустимыеСимволы.Добавить(Символы.ВК);
	ДанныеВозврат = Base64Строка(ДвоичныеДанныеРашифрованные);
	Для Каждого НедопустимыйСимвол Из НедопустимыеСимволы Цикл
		ДанныеВозврат = СтрЗаменить(ДанныеВозврат, НедопустимыйСимвол, "");
	КонецЦикла;
	Возврат ДанныеВозврат;
КонецФункции  

Функция сбисВыбратьНаборАлгоритмовДляСозданияПодписи(Алгоритм) Экспорт
	
	Алгоритмы = сбисИменаАлгоритмовПодписиГОСТ_34_10_2012_256();
	Если Алгоритмы.Найти(Алгоритм)<>Неопределено Тогда
		Возврат Алгоритмы;
	КонецЕсли; 
	Алгоритмы = сбисИменаАлгоритмовПодписиГОСТ_34_10_2012_512();
	Если Алгоритмы.Найти(Алгоритм)<>Неопределено Тогда
		Возврат Алгоритмы;
	КонецЕсли;
	Алгоритмы = сбисИменаАлгоритмовПодписиГОСТ_34_10_2001();
	Если Алгоритмы.Найти(Алгоритм)<>Неопределено Тогда
		Возврат Алгоритмы;
	КонецЕсли;
	Алгоритмы = сбисИменаАлгоритмовПодписиГОСТ_34_10_94();
	Если Алгоритмы.Найти(Алгоритм)<>Неопределено Тогда
		Возврат Алгоритмы;
	КонецЕсли;
	Алгоритмы = Новый Массив;
	Алгоритмы.Добавить("RSA_SIGN");
	Алгоритмы.Добавить("SHA1RSA");     // приходит от СБИС
	Алгоритмы.Добавить("SHA1WithRSASignature");    // приходит от СБИС
	Алгоритмы.Добавить("SHA256RS");   // приходит от СБИС
	Если Алгоритмы.Найти(Алгоритм)<>Неопределено Тогда
		Возврат Алгоритмы;
	КонецЕсли;
	
	Возврат сбисИменаАлгоритмовПодписиГОСТ_34_10_2012_256();
	
КонецФункции

Функция сбисИменаАлгоритмовПодписиГОСТ_34_10_94()
	
	Имена = Новый Массив;
	Имена.Добавить("ГОСТ 34.10-94"); // Представление.
	Имена.Добавить("GOST R 34.10-94");
	
	Возврат Имена;
	
КонецФункции

Функция сбисИменаАлгоритмовПодписиГОСТ_34_10_2001()
	
	Имена = Новый Массив;
	Имена.Добавить("ГОСТ 34.10-2001"); // Представление.
	Имена.Добавить("ГОСТ Р 34.10-2001");  // приходит от СБИС
	Имена.Добавить("GOST R 34.10-2001");
	Имена.Добавить("ECR3410-CP");
	
	Возврат Имена;
	
КонецФункции

Функция сбисИменаАлгоритмовПодписиГОСТ_34_10_2012_256()
	
	Имена = Новый Массив;
	Имена.Добавить("ГОСТ 34.10-2012 256"); // Представление.
	Имена.Добавить("ГОСТ Р 34.10-2012 256");   // приходит от СБИС
	Имена.Добавить("GR 34.10-2012 256");
	Имена.Добавить("GOST 34.10-2012 256");
	Имена.Добавить("GOST R 34.10-12 256");
	Имена.Добавить("GOST3410-12-256");
	
	Возврат Имена;
	
КонецФункции

Функция сбисИменаАлгоритмовПодписиГОСТ_34_10_2012_512()
	
	Имена = Новый Массив;
	Имена.Добавить("ГОСТ 34.10-2012 512"); // Представление. 
	Имена.Добавить("ГОСТ Р 34.10-2012 512");   // приходит от СБИС
	Имена.Добавить("GR 34.10-2012 512");
	Имена.Добавить("GOST 34.10-2012 512");
	
	Возврат Имена;
	
КонецФункции

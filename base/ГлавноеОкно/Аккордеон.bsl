
&НаСервере
Процедура ПостроитьАккордеон(ДопПараметры = Неопределено)
	МодульОбъекта = ПолучитьМодульОбъекта();
	ДанныеАккордеона = get_prop(ДопПараметры, "СтруктураАккордеона");
	ini_name = get_prop(ДанныеАккордеона, "Ини", "Accordion");
	accordion = get_prop(ДанныеАккордеона, "Пункты");
	ИмяМакета = get_prop(ДанныеАккордеона, "ИмяМакета", "Аккордеон");
	ИдРаздела = get_prop(ДанныеАккордеона, "ВыбранныйРаздел");
			
	ПараметрыКоманды = Новый Структура("algorithm, endpoint, params, AccordionEDO", ini_name, , , accordion);
	Попытка
		РезультатИни = МодульОбъекта.LocalCalcIni(ПараметрыКоманды);
		Если РезультатИни["status"] = "error" Тогда
			ВызватьИсключение NewExtExceptionСтрока(, "Ошибка выполнения ini: '" + ПараметрыКоманды["algorithm"]
					+ "', endpoint: '" + ПараметрыКоманды["endpoint"] + "'" + Символы.ПС + РезультатИни.data.message,
				РезультатИни.data.detail, РезультатИни.data.action);
		КонецЕсли;
	Исключение
		Ошибка = ОписаниеОшибки();
		ТекущийРаздел.Вставить("Шаблон", "СтраницаЗаглушка");
		Возврат;
	КонецПопытки;
	Попытка
		СтруктураАккордеона = РезультатИни.data;
		Если ИдРаздела = Неопределено Тогда
		    ИдРаздела = get_prop(context_param, "РазделПоУмолчанию");
		КонецЕсли;
		Если ИдРаздела = Неопределено Тогда
			Для Каждого ПунктАккордеона Из СтруктураАккордеона Цикл
				Если ПунктАккордеона["action"] = Истина Тогда
					ИдРаздела = ПунктАккордеона["id"];
					Прервать;
				КонецЕсли;
			КонецЦикла;
		КонецЕсли;
	
		МодульОбъекта = ПолучитьМодульОбъекта();
		АккордеонJSON = МодульОбъекта.encode_xdto_json(СтруктураАккордеона);
		АккордеонJSON = "{""accordion"":" + АккордеонJSON;
		АккордеонJSON = АккордеонJSON + ", ""selectedItem"":"""+ИдРаздела+"""";
		АккордеонJSON = АккордеонJSON + ", ""marginTop"":""26px""}";      //высота блока с птичкой
		ТекстHTML = ПолучитьМодульОбъекта().ПолучитьМакет(ИмяМакета).ПолучитьТекст(); 
		ТекстHTML = СтрЗаменить(ТекстHTML, "%accordion%", АккордеонJSON);
		УстановитьHTML("АккордеонHTML", ТекстHTML);
	
		ТекущийРаздел.Вставить("Идентификатор", ИдРаздела);
		ТекущийРаздел.Вставить("МножественныйВыбор", Истина); // Тут всегда множественный выбор
	Исключение
		Ошибка = ОписаниеОшибки();
		ВызватьИсключение "Ошибка: " + Символы.ПС + Ошибка;
	КонецПопытки;
КонецПроцедуры

&НаКлиенте
Процедура АккордеонOnClick(Элемент, ДанныеСобытия)
	#Если ТолстыйКлиентОбычноеПриложение Тогда
		ЭлементСобытия = ДанныеСобытия.srcElement;
	#Иначе
		ЭлементСобытия = ДанныеСобытия.Element;
	#КонецЕсли
	Если ЭлементСобытия["id"] = "toExtSys" Тогда
		Попытка
			ИмяДействия	= ЭлементСобытия.getAttribute("action");
			Параметр	= ЭлементСобытия.textContext; //Иногда можно брать из ЭлементСобытия.innerHTML;
			Результат = ОбработатьДействиеНаКлиенте(ИмяДействия, Параметр);
			//ВернутьРезультат(Результат);
		Исключение
			ИнфоОбОшибке = ИнформацияОбОшибке();
		КонецПопытки;
	КонецЕсли;
КонецПроцедуры

&НаКлиенте
Процедура АккордеонОбновитьИнформациюОВерсии() Экспорт
	ЭлементыФормочки = ПолучитьЭлементыФормы();
	Попытка
		ЭлементыФормочки.АккордеонHTML.Документ[РеквизитОбъектаДокумента].updateFooter(ПолучитьИнформациюОВерсии());	
	Исключение
		Ошибка = ОписаниеОшибки();
	КонецПопытки;
КонецПроцедуры

&НаСервере
Функция ПолучитьИнформациюОВерсии()
	МодульОбъекта = ПолучитьМодульОбъекта();
	СтатусВерсии = МодульОбъекта.ПолучитьСтатусВерсии(Истина);
	СтатусВерсииПользователя = "";
	ВерсияПользователя = "";
	//СтатусВерсии = 5; //IE не воспринимает "0", поэтому нулевой статус, когда версия актуальна, заменяю на "5"
	Если СтатусВерсии.Шаблон = 1 Тогда
		СтатусВерсииПользователя = "Доступно обновление";
	ИначеЕсли СтатусВерсии.Шаблон = 2 Тогда
		СтатусВерсииПользователя = "Версия устарела";
	ИначеЕсли СтатусВерсии.Шаблон = 3 Или СтатусВерсии.Шаблон = 4 Тогда
		СтатусВерсииПользователя = "Версия сильно устарела!";
	КонецЕсли;	
	ВерсияПользователя = "v. " + СтатусВерсии.НомерТекущейВерсии;
	Возврат СтатусВерсииПользователя+";"+ВерсияПользователя+";"+Строка(СтатусВерсии.Шаблон);	
КонецФункции



&НаСервере
Функция СоответствиеТиповОбъектов()
	СоответствиеТипов = Новый СписокЗначений;
	
	СоответствиеТипов.Добавить("СлужЗап", "Задача");
	СоответствиеТипов.Добавить("АвансОтчёт", "Авансовый отчёт");
	СоответствиеТипов.Добавить("ВнутрПрм", "Внутреннее перемещение");
	СоответствиеТипов.Добавить("PayoutDoc", "Выдача зарплаты");
	СоответствиеТипов.Добавить("ДоговорДок", "Договор");
	СоответствиеТипов.Добавить("PriceChange", "Изменение цен");
	СоответствиеТипов.Добавить("Allowance", "Больничный");
	СоответствиеТипов.Добавить("Номенклатура", "Показатель остаток на складе");
	СоответствиеТипов.Добавить("ДокОтгрВх", "Поступление");
	СоответствиеТипов.Добавить("Прайсы", "Прайс");
	СоответствиеТипов.Добавить("ДокОтгрИсх", "Реализация");
	СоответствиеТипов.Добавить("СчетИсх", "Счет на оплату");
	СоответствиеТипов.Добавить("УдержанияПоЗарплате", "Удержание по зарплате");
	СоответствиеТипов.Добавить("ШтатнаяДолжность", "Штатное расписание");
	СоответствиеТипов.Добавить("Согласование", "График отпусков");
	СоответствиеТипов.Добавить("CadresOther", "Прочий кадровый документ");
	СоответствиеТипов.Добавить("НачисленияПоЗарплате", "Начисление по зарплате");
	СоответствиеТипов.Добавить("PlanVacationScheduleChange", "Перенос отпусков");
	СоответствиеТипов.Добавить("ТабельДокумент", "Табель");
	СоответствиеТипов.Добавить("ИзмененияОклада", "Изменение условий оплаты");
	СоответствиеТипов.Добавить("Indexation", "Индексация заработка");
	СоответствиеТипов.Добавить("GphAct", "Акт приемки");
	СоответствиеТипов.Добавить("CombinationPositions", "Совмещение должностей");
	СоответствиеТипов.Добавить("BusinessTrip", "Списочная Командировка");
	СоответствиеТипов.Добавить("GphContract", "Прием на работу ГПХ");
	СоответствиеТипов.Добавить("CombinationCancel", "Отмена совмещения должностей");
	СоответствиеТипов.Добавить("BTCorrection", "Корректировка списочной командировки");
	СоответствиеТипов.Добавить("TimesheetCorrection", "Корректировка табеля");
	СоответствиеТипов.Добавить("РеалВх", "Поступление");
	СоответствиеТипов.Добавить("StaffStatements", "Заявление");
	СоответствиеТипов.Добавить("ПриемНаРаботу", "Прием на работу");
	СоответствиеТипов.Добавить("ИзмененияДолжности", "Кадровый перевод");
	СоответствиеТипов.Добавить("ПриказНаУвольнение", "Приказ на увольнение");
	СоответствиеТипов.Добавить("Отпуск", "Отпуск");
	СоответствиеТипов.Добавить("InstructionDoc", "Инструкция");
	СоответствиеТипов.Добавить("Поощрение", "Премия");
	СоответствиеТипов.Добавить("Переработка", "Переработка");
	СоответствиеТипов.Добавить("Прогул", "Прогул неявка");
	СоответствиеТипов.Добавить("Отгул", "Отгул");
	СоответствиеТипов.Добавить("Простой", "Простой сотрудников");

	Возврат СоответствиеТипов;
КонецФункции

&НаСервере
Функция ТипБЛПоТипу1С(Тип1С)
	Тип1СВрег = ВРег(Тип1С);
	НайденныйТип = Неопределено;
	СоотвТипов = СоответствиеТиповОбъектов();
	СоотвТипов.СортироватьПоПредставлению();
	Для Каждого КлЗнч Из СоотвТипов Цикл
		Если ВРег(КлЗнч.Представление) = Тип1СВрег Тогда
			НайденныйТип = КлЗнч.Значение;
			Прервать;
		КонецЕсли;;
	КонецЦикла;
	Возврат НайденныйТип;
КонецФункции

&НаСервере
Функция Тип1СПоТипуБЛ(ТипБЛ, ПримечаниеТипа="")
	СоотвТипов = СоответствиеТиповОбъектов();
	НайденныйТип = СоотвТипов.НайтиПоЗначению(ТипБЛ);
	Если ТипБЛ = "Allowance" И 
		(Найти(ПримечаниеТипа, " уход") > 0
		ИЛИ 
		Найти(ПримечаниеТипа, "пособие") > 0) Тогда
		НайденныйТип = "Отпуск по уходу";
	КонецЕсли;
	Если НайденныйТип = Неопределено Тогда
		// Отобразим тип БЛ
		НайденныйТип = ТипБЛ;
	КонецЕсли;
	Возврат НайденныйТип;
КонецФункции


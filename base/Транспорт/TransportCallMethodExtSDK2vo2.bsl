
// Вызывается метод ExtSdk2
//
// Параметры:
//  MethodName - Строка - имя метода.
//  ПараметрыВызова - Структура - параметры.
//  context_params - Структура - контекст.
//
// Возвращаемое значение:
//   Структура - "code","result"
//
//DynamicDirective
Функция CallMethod(MethodName, ПараметрыВызова, context_params)
	Result = Неопределено;
	Если ЛЕВ(MethodName,8) = "ExtSdk2." Тогда
		MethodName = СтрЗаменить(MethodName,"ExtSdk2.","");
	КонецЕсли;
	ПараметрыКоманды = Новый Структура;
	ПараметрыКоманды.Вставить("ВерсияФорматаОтвета", 3); 
	ПараметрыКоманды.Вставить("СообщатьПриОшибке", Ложь);
	Отказ = Ложь;
	Результат = ТранспортИнтеграции.ВладелецФормы.Кэш.СБИС.ДанныеИнтеграции.Объекты.Форма_ExtSDK.СбисОтправитьИОбработатьКоманду(ТранспортИнтеграции.ВладелецФормы.Кэш, MethodName, ПараметрыВызова, ПараметрыКоманды, Отказ);
	Если Отказ = Истина Тогда 
		message = get_prop(Результат,"message");
		details = get_prop(Результат,"details");
		ВызватьИсключение NewExtExceptionСтрока(Неопределено,message,details,,);
	КонецЕсли;	
	code = 200;	
	Result = Новый Структура;
	Result.Вставить("code",code);
	Result.Вставить("result",Новый Структура("result",Результат));
	Возврат Result;
КонецФункции


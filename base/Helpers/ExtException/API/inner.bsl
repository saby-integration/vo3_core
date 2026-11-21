
// BSLLS-off

// Область частично дублирует include_core2_base_Helpers_ExtException_API_inner и его АПИ. Свести в 1
// Нужно чтобы методы, которые используют исключение могли работать.

//DynamicDirective
Функция NewExtException(	HandledException = Неопределено, Parent	= Неопределено,
							Type = Неопределено, Message = Неопределено, Details = Неопределено, Data = Неопределено)
							
	// В этой реализации parent = строка для проброса ошибки в стек.
	// Type = code и в вашем варианте не используется.
							
	Возврат NewExtExceptionСтруктура(HandledException, Message, Details, Parent, Data);						
							
КонецФункции

// Функция - Dump метод для исключений
//
// Параметры:
//  ExtException	 - ExtException				 - текущая ошибка
//  Scenario		 - Строка					 - ключ, как надо выгрузить нашу ошибку
//	AddParam		 - Неопределено, Структура	 - расширение
// 
// Возвращаемое значение:
//  Произвольный - значение по ключу
//
//DynamicDirective
Функция ExtException_Dump(ExtException, Scenario = "Строка", AddParam = Неопределено) 
	
	// Тут не делал реализацию всех вариантов. Только приведение к строке.
	Возврат Saby_ЗначениеВСтрокуВнутрНаСервере(ExtException);
	
КонецФункции


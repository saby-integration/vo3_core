
//DynamicDirective
//Убрать после 24.2100 
// Возвращает реквизит ИдСБИС по идентификатору документа
//
// Параметры:
//  ИдентификаторДокумента - Строка - идентификатор документа.
//
// Возвращаемое значение:
//  Строка - если нашли
//  Неопределено - если не нашли
//
Функция ПолучитьИдСбисИзИдентификатора(ИдентификаторДокумента)
	Результат = ТранспортИнтеграции.local_helper_get_data_document(context_param, "", "", ИдентификаторДокумента, "", "");
	res = get_prop(Результат,"d", Неопределено);
	Возврат get_prop(res,"@Документ", Неопределено);			
КонецФункции
//---


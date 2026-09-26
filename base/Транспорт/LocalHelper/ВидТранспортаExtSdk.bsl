
// Получаем признак транспорта ExtSdk
//
// Параметры:
//  context_params - Структура - Контекст.
//
// Возвращаемое значение:
//  Булево - признак транспорта ExtSdk
//
//DynamicDirective
Функция  ЭтоВидТранспортаExtSdk(context_params)
	ВидТранспорта = ВидТранспорта(context_params);
	Возврат ВидТранспорта = "ExtSdk" Или ВидТранспорта = "ExtSdkCrypto" Или ВидТранспорта = "SabyPluginConnector";
КонецФункции

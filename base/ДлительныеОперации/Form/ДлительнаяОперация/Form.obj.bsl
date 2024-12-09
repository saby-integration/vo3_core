
#Область include_core_base_ДлительныеОперации_Form_ДлительнаяОперация_ОсобенностиОбработки
#КонецОбласти

#Область include_core_base_Helpers_FormGetters
#КонецОбласти

#Область include_core_base_ФоновыеЗадания_МодульФоновогоЗаданияСервер
#КонецОбласти

#Область include_core_base_ФоновыеЗадания_МодульФоновогоЗаданияКлиент
#КонецОбласти


&НаКлиенте
Функция ПолучитьАдресСтраницыОтчетОЗагрузке(URL, extSyncDocId) 
	Возврат URL+"/ext-sync-doc/page/?extSyncDocId="+extSyncDocId; 	 	
КонецФункции	


#Область include_core_base_Helpers_ПолучитьПрямуюСсылку
#КонецОбласти


&НаКлиенте
Процедура СоздатьМенеджерыКриптографииНачатьИнициализацию(Контекст)
	
	СвойстваПрограммы = Контекст.ПрограммыКриптографии[Контекст.ТекущийИндексПрограммыКриптографии];
	
    Криптография = Новый МенеджерКриптографии;
    Криптография.НачатьИнициализацию(
        Новый ОписаниеОповещения(
            "СоздатьМенеджерыКриптографииПослеИнициализацииМенеджераКриптографии", МодульФоновогоЗаданияКлиент(), Контекст,
            "СоздатьМенеджерыКриптографииПослеОшибкиИнициализацииМенеджераКриптографии", МодульФоновогоЗаданияКлиент()),
		СвойстваПрограммы.ИмяПрограммы, СвойстваПрограммы.ПутьКПрограмме, СвойстваПрограммы.ТипПрограммы);
		
КонецПроцедуры
	

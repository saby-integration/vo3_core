
Функция ПодписатьНаКлиенте(context, attachmentList, ДанныеДляПодписания, block_context) Экспорт
	Если get_prop(block_context, "__deferred") = Неопределено Тогда
		Для каждого attach из attachmentList Цикл
			ДвоичныеДанные = local_helper_download_from_link(context.params, attach["Файл"]["Ссылка"]); 
			attach["Файл"].Вставить("ДвоичныеДанные", Base64Строка(ДвоичныеДанные));
		КонецЦикла;
		//__deferred = ПоместитьВоВременноеХранилище(attachmentList, get_prop(context.variables, "ВложенияАдресВХранилище", Новый УникальныйИдентификатор())); //по этому уиду кладем файлы для подписания во временное хранилище
		__deferred = Новый УникальныйИдентификатор(); 
		block_context.Вставить("__deferred", Строка(__deferred)); //кладем новый уид в   __deferred
		command = Новый Структура("name, params, uuid, data", "Подписать", ДанныеДляПодписания, block_context["__deferred"], attachmentList); //формируем структуру command, в которую кладем "name, params, uid"
		context.commands.Добавить(command);
		Currentblock_context = block_context;
		ВызватьИсключение NewExtExceptionСтрока(,"DeferredOperation",,,Новый Структура("context, block_context", context, block_context),"DeferredOperation");
	Иначе
		command_result = get_prop(context.command_result, block_context.__deferred);
		Если command_result.status = "complete" Тогда
			Для каждого attach из attachmentList Цикл
				Файлы = Новый Структура("Файл", Новый Структура("ДвоичныеДанные", command_result.result[attach["Идентификатор"]]));
				мФайлы = Новый Массив;
				мФайлы.Добавить(Файлы);
				attach.Вставить("Подпись", мФайлы);
			КонецЦикла		
		ИначеЕсли command_result.status = "error" Тогда	
			ВызватьИсключение NewExtExceptionСтрока(command_result.result,,,"ПодписатьНаКлиенте");	
		КонецЕсли;
	КонецЕсли;
КонецФункции


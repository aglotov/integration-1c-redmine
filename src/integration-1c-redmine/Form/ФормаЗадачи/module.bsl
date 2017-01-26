﻿Перем СтруктураЗадачи Экспорт;
Перем НоваяЗадача Экспорт;
Перем СвойстваЗадачи Экспорт;

Перем мРедактироватьОписание;

////////////////////////////////////////////////////////////////////////////////
// ПРОЦЕДУРЫ - ОБРАБОТЧИКИ ДЕЙСТВИЙ КОМАНДНЫХ ПАНЕЛЕЙ

Процедура КоманднаяПанель1ПрикрепитьФайлы(Кнопка)
	
	ДиалогВыбора = Новый ДиалогВыбораФайла(РежимДиалогаВыбораФайла.Открытие);
	ДиалогВыбора.МножественныйВыбор = Истина;
	ДиалогВыбора.Заголовок = "Выберите файлы которые хотите прикрепить к задаче.";
	Если ДиалогВыбора.Выбрать() Тогда
		мФайлов = ДиалогВыбора.ВыбранныеФайлы;
		
		Для Каждого Эл Из мФайлов Цикл
			Файл = Новый Файл(Эл);
			
			ФайлДобавлен = Вложения.Найти(Файл.ПолноеИмя, "ПолноеимяФайла");
			Если ФайлДобавлен <> Неопределено Тогда
				Продолжить;
			КонецЕсли;
			
			Если Файл.Расширение = ".exe" Или Файл.Расширение = ".bat" Или Файл.Расширение = ".cmd" Тогда
				Сообщить("Файлы с расширением " + Файл.Расширение + " не могут быть привязаны к задаче.");	
				Продолжить;	
			КонецЕсли;
			
			нСтрока					= ТаблицаВложений.Добавить();
			нСтрока.ИмяФайла		= Файл.Имя;
			нСтрока.ПолноеИмяФайла	= Файл.ПолноеИмя;
			нСтрока.Расширение		= Файл.Расширение;
			нСтрока.Пометка			= Истина;
		КонецЦикла;
		
		ЗагрузитьВТаблицуЗначений(ТаблицаВложений, Вложения);	
		
	КонецЕсли;
	
КонецПроцедуры

Процедура КоманднаяПанель1УдалитьФайл(Кнопка)
	
	ТекСтрока = ЭлементыФормы.Вложения.ТекущиеДанные;
	Вложения.Удалить(ТекСтрока);
	
КонецПроцедуры


Процедура ОсновныеДействияФормыОсновныеДействияФормыВыполнить(Кнопка)
	
	ЗаполнитьРеквизитыЗадачиДаннымиИзФормы();
	
	Если НЕ ВсеРеквизитыЗаполнены(Новый Структура("ЗадачаТрекер, ЗадачаСтатус, ЗадачаПриоритет, ЗадачаТема, ЗадачаПроект"), Кнопка.Пояснение) Тогда
		Возврат;
	КонецЕсли;
	
	Если НоваяЗадача Тогда
		Результат = СоздатьЗадачуВТрекере();
	Иначе
		Результат = ОбновитьЗадачуВТрекере();
	КонецЕсли;	
	
	Если ОтчетОВыполнении.ЕстьОшибки Тогда
		Сообщить(ОтчетОВыполнении.ТекстОшибки);
		Возврат;
	КонецЕсли;
	
	//Если НоваяЗадача Тогда
	//	ЗадачаНомер = Результат.issue.id;
	//	ЭтаФорма.Заголовок = ЗадачаПроект + ":" + ЗадачаТрекер + "#" + Формат(ЗадачаНомер , "ЧГ=0") + " - задача была успешно создана!";
	//Иначе
	//	ЭтаФорма.Заголовок =  ЭтаФорма.Заголовок + " - задача была успешно обновлена!";	
	//КонецЕсли;
	//
	//ЭтаФорма.ТолькоПросмотр = Истина;
	//
	//УстановитьВидимость();
	//УстановитьДоступность();
	
	Оповестить("Обновить список задач", ЗадачаНомер, "ФормаЗадачи");
	
	Закрыть();
	
КонецПроцедуры


////////////////////////////////////////////////////////////////////////////////
// ПРОЦЕДУРЫ И ФУНКЦИИ ОБЩЕГО НАЗАНАЧЕНИЯ


// Проверка заполнения элементов формы по переданной структуре элементов
Функция ВсеПоляЗаполнены(СтруктураПолей, ИмяДействия = "", Сообщать = Истина)
	
	ВсеЗаполнены = Истина;
	Для каждого Поле из СтруктураПолей Цикл
		Если НЕ ЗначениеЗаполнено(ЭтотОбъект[Поле.Ключ]) Тогда
			Если Сообщать Тогда 
				Сообщить("Для выполнения функции: " + ИмяДействия + " - необходимо заполнить поле: " + Поле.Ключ);
			КонецЕсли;
			ВсеЗаполнены = Ложь;
		КонецЕсли;
	КонецЦикла;
	
	Возврат ВсеЗаполнены;	
КонецФункции

////////////////////////////////////////////////////////////////////////////////
// ПРОЦЕДУРЫ - ОБРАБОТЧИКИ СОБЫТИЙ ФОРМЫ

Процедура ПриОткрытии()
	
	//Элементы = ПолучитьСтруктуруИзменяемыхЭлементовФормы();
	//Для каждого Элемент Из Элементы Цикл
	//	Если ЭлементыФормы[Элемент.Ключ].ИзменяетДанные И ЭлементыФормы[Элемент.Ключ].Видимость Тогда 
	//		ПодключитьОбработчикИзмененияДанных(Элемент.Ключ, "ДействияПриИзмененииЭлементовФормы");	
	//	КонецЕсли;
	//КонецЦикла;
	
	Если НоваяЗадача Тогда
		ЗаполняемСвойстваЗадачи();
		УстановитьПоляЗадачиПоУмолчанию();
		ЗаполнитьСписокНаблюдателейПроекта();
	Иначе
		Если ТипЗнч(СтруктураЗадачи) = Тип("Структура") Тогда
			ЗаполнитьФормуИзСтруктуры();	
		КонецЕсли;
	КонецЕсли;
	
	мРедактироватьОписание = НоваяЗадача;
	
	ЗаполнитьСпискиВыбораПолей();
	
	УстановитьВидимость();
	УстановитьЗаголовки();
	
	ЭлементыФормы.ОписаниеЗадачиHTML.УстановитьТекст(ПолучитьТекстИнициализацииКовертераВПолеHTML());
	
	ПодключитьОбработчикОжидания("КонвертироватьОписаниеЗадачиВHTML", 0.1, Истина);
	
КонецПроцедуры

Процедура ЗаполняемСвойстваЗадачи()
	
	// Заполняем переданные свойства
	Если СвойстваЗадачи <> Неопределено Тогда
		Для Каждого Свойство Из СвойстваЗадачи Цикл
			Если Свойство.Ключ = "НастраиваемыеПоля" Тогда
				мНастраиваемыеПоля = Свойство.Значение;
			Иначе
				ЭлементыФормы[Свойство.Ключ].Значение = Свойство.Значение; 
			КонецЕсли;
		КонецЦикла;
	КонецЕсли;

КонецПроцедуры

Процедура КонвертироватьОписаниеЗадачиВHTML()
	
	Если Не мРедактироватьОписание Тогда
		Попытка
			ЭлементыФормы.ОписаниеЗадачиHTML.Документ.getElementById("txt").innerHTML = Описание;
			
			// Посылаем сообщение невидимой кнопке, чтобы выполнить команду JS
			лКоманда = ЭлементыФормы.ОписаниеЗадачиHTML.Документ.getElementById ("SendEvent");    
			лКоманда.click("onclick");
		Исключение
			мРедактироватьОписание = Не  мРедактироватьОписание;
			УстановитьВидимость();
		КонецПопытки;
	КонецЕсли;
	
КонецПроцедуры


Процедура ЗаполнитьРеквизитыЗадачиДаннымиИзФормы()
	
	Для Каждого Реквизит Из Метаданные().Реквизиты Цикл
		Если Найти(Реквизит.Имя, "Задача") = 1 Тогда
			ЭтотОбъект[Реквизит.Имя] = ЭлементыФормы[Прав(Реквизит.Имя, СтрДлина(Реквизит.Имя) - 6)].Значение;
		КонецЕсли;
	КонецЦикла;
	
	Наблюдатели.Очистить();
	ЗагрузитьВТаблицуЗначений(мНаблюдатели, Наблюдатели);
	
	НастраиваемыеПоля.Очистить();
	ПреобразоватьСсылочныеТипы1СвСтроку();
	ЗагрузитьВТаблицуЗначений(мНастраиваемыеПоля, НастраиваемыеПоля);
	
КонецПроцедуры


Процедура ЗаполнитьФормуИзСтруктуры()
	
	Номер				= СтруктураЗадачи.id;
	Проект				= СтруктураЗадачи.project.name;
	Приоритет			= СтруктураЗадачи.priority.name;
	Статус				= СтруктураЗадачи.status.name;
	Трекер				= СтруктураЗадачи.tracker.name;
	НачалоВыполнения	= ?(СтруктураЗадачи.Свойство("start_date"), Дата(СтрЗаменить(СтруктураЗадачи.start_date, "-", "")), '0001-01-01');
	КонецВыполнения		= ?(СтруктураЗадачи.Свойство("due_date"), Дата(СтрЗаменить(СтруктураЗадачи.due_date, "-", "")), '0001-01-01');
	Описание			= ?(СтруктураЗадачи.Свойство("description"), СтруктураЗадачи.description, "");
	Тема				= СтруктураЗадачи.subject;
	
	Если СтруктураЗадачи.Свойство("spent_hours") Тогда
		УжеЗатрачено			= "Уже затрачено: "+Формат(СтруктураЗадачи.spent_hours, "ЧЦ=10; ЧДЦ=2; ЧГ=0")+" час(ов)";
	КонецЕсли;
	Деятельность		= "Development";
	
	Если СтруктураЗадачи.Свойство("estimated_hours") Тогда
		ОценкаВремени		= СтруктураЗадачи.estimated_hours;
	КонецЕсли;
	Если СтруктураЗадачи.Свойство("assigned_to") Тогда
		Исполнитель		= СтруктураЗадачи.assigned_to.name;
	КонецЕсли;
	Если СтруктураЗадачи.Свойство("done_ratio") Тогда
		Индикатор = СтруктураЗадачи.done_ratio;	
	КонецЕсли;
	Если СтруктураЗадачи.Свойство("parent") Тогда
		НомерРродительскойЗадачи = СтруктураЗадачи.parent.id;
	КонецЕсли;
	
	мНастраиваемыеПоля.Очистить();
	Если СтруктураЗадачи.Свойство("custom_fields") Тогда
		Для Каждого Поле Из СтруктураЗадачи.custom_fields Цикл
			
			нСтрока = мНастраиваемыеПоля.Добавить();
			нСтрока.Идентификатор	= Поле.id;
			нСтрока.Имя				= Поле.name;
					
			Если Поле.Свойство("value") И Поле["value"] <> "" Тогда
				нСтрока.Пометка			= ЗначениеЗаполнено(Поле.value);
				нСтрока.Значение		= ?(нСтрока.Имя = ПолеСсылкаНаОбъект1С, ПеобразоватьВСсылочныйТип1С(Поле["value"]), Поле["value"]);
			КонецЕсли;
		КонецЦикла;
	КонецЕсли;
	
	мНаблюдатели.Очистить();
	Если СтруктураЗадачи.Свойство("watchers") Тогда
		Для Каждого Поле Из СтруктураЗадачи.watchers Цикл
			нСтрока = мНаблюдатели.Добавить();
			
			нСтрока.Пометка			= Истина;
			нСтрока.Идентификатор	= Поле.id;
			нСтрока.Имя				= Поле.name;
		КонецЦикла;
	КонецЕсли;
	// Дополним возможными наблюдателями
	ЗаполнитьСписокНаблюдателейПроекта();
	
	Если СтруктураЗадачи.Свойство("attachments") Тогда
		Для Каждого Поле Из СтруктураЗадачи.attachments Цикл
			нСтрока = ТаблицаВложений.Добавить();
			
			нСтрока.ИмяФайла	= Поле.filename;
			
			Слеш = Найти(Поле.filename, "/");
			нСтрока.Расширение	= "." + Прав(Поле.filename, СтрДлина(Поле.filename) - Слеш);
		КонецЦикла;
	КонецЕсли;
	ЗагрузитьВТаблицуЗначений(ТаблицаВложений, Вложения);
	
	Если СтруктураЗадачи.Свойство("children") Тогда
		
		ЗаполнитьДеревоПодзадач(СтруктураЗадачи, ДеревоПодзадач.Строки);
		
		ЭлементыФормы.Приоритет.Доступность			= Ложь;
		ЭлементыФормы.НачалоВыполнения.Доступность	= Ложь;
		ЭлементыФормы.КонецВыполнения.Доступность	= Ложь;
		ЭлементыФормы.ОценкаВремени.Доступность		= Ложь;
	КонецЕсли;
	
КонецПроцедуры

Функция ПеобразоватьВСсылочныйТип1С(Значение)
	
	Попытка
		Сериализатор = Новый СериализаторXDTO(ФабрикаXDTO);
		
		ЧтениеJSON = Новый ЧтениеJSON;
		ЧтениеJSON.УстановитьСтроку(Значение);
		
		Ссылка = Сериализатор.ПрочитатьJSON(ЧтениеJSON);
	Исключение
		Ссылка = Значение;
	КонецПопытки;

	Возврат Ссылка;
КонецФункции

Процедура ПреобразоватьСсылочныеТипы1СвСтроку()
	Сериализатор = Новый СериализаторXDTO(ФабрикаXDTO);
	Для Каждого Поле Из мНастраиваемыеПоля Цикл
		Если Поле.Имя = ПолеСсылкаНаОбъект1С И Поле.Пометка Тогда
			
			Попытка
				ЗаписьJSON = Новый ЗаписьJSON;
				ЗаписьJSON.УстановитьСтроку();
				
				Сериализатор.ЗаписатьJSON(ЗаписьJSON, Поле.Значение, НазначениеТипаXML.Явное);
				
				Поле.Значение = ЗаписьJSON.Закрыть();	
			Исключение	
			КонецПопытки;
		КонецЕсли;
	КонецЦикла;	
КонецПроцедуры




Процедура ЗаполнитьДеревоПодзадач(СтруктураЗадачи, СтрокиДерева)
	
	Для Каждого Подзадача Из СтруктураЗадачи.children Цикл
		
		нСтрока = СтрокиДерева.Добавить();
		
		нСтрока.Идентификатор = Подзадача.id;
		нСтрока.Задача	= Подзадача.tracker.name + " #" + Формат(Подзадача.id, "ЧГ=0") + ": " + Подзадача.subject;
		
		Если Подзадача.Свойство("children") Тогда
			ЗаполнитьДеревоПодзадач(Подзадача, нСтрока.Строки)	
		КонецЕсли;
		
	КонецЦикла;
	
КонецПроцедуры


Процедура ПриЗакрытии()
	

КонецПроцедуры

Процедура ЗаполнитьСпискиВыбораПолей()
	
	ЗаполнитьСписокВыбораПроекта();
	ЗаполнитьСписокВыбораИсполнителей();
	
КонецПроцедуры

Процедура ЗаполнитьСписокВыбораПроекта()
	
	Если Не ВсеПоляЗаполнены(Новый Структура("APIkey")) Тогда
		Возврат;
	КонецЕсли;
	
	//: ЗагруженныеДанные = Новый Соответствие
	Данные = ЗагруженныеДанные.Получить("projects");
	
	Если Данные = Неопределено Тогда
		Данные = ПолучитьДанныеРесурсаИзТрекера("projects");
		
		Если ОтчетОВыполнении.ЕстьОшибки Тогда
			Сообщить(ОтчетОВыполнении.ТекстОшибки);
			Возврат;
		КонецЕсли;
		
		ЗагруженныеДанные.Вставить("projects", Данные);
	КонецЕсли;
	
	мСписокПроектов = Новый СписокЗначений;
	Для Каждого ДанныеПроекта Из Данные["projects"] Цикл
		 мСписокПроектов.Добавить(ДанныеПроекта.name);
	КонецЦикла;
	
	ЭлементыФормы.Проект.СписокВыбора				= мСписокПроектов;
	
КонецПроцедуры

Процедура ЗаполнитьСписокВыбораИсполнителей()
	
	//: ЗагруженныеДанные = Новый Соответствие
	Если Не ВсеРеквизитыЗаполнены(Новый Структура("Проект"), "Сформировать список выбора исполнителей", Истина, ЭтаФорма) Тогда
		Возврат;
	КонецЕсли;

	мПроект = ПолучитьИдентификаторПараметра(Проект, "projects");
	
	Ресурс = "projects/"+мПроект+"/memberships";
	
	Данные = ЗагруженныеДанные.Получить(СтрЗаменить(Ресурс, "/", "-"));
	
	Если Данные = Неопределено Тогда
		Данные = ПолучитьДанныеРесурсаИзТрекера(Ресурс);
		
		Если ОтчетОВыполнении.ЕстьОшибки Тогда
			Сообщить(ОтчетОВыполнении.ТекстОшибки);
			Возврат;
		КонецЕсли;
		
		ЗагруженныеДанные.Вставить(СтрЗаменить(Ресурс, "-", "/"), Данные);
	КонецЕсли;
	
	СписокИсполнителей = Новый СписокЗначений;
	СписокИсполнителей.Добавить("<>");
	Для Каждого Структура Из Данные["memberships"] Цикл
		 СписокИсполнителей.Добавить(Структура.user.name);
	КонецЦикла;
	
	ЭлементыФормы.Исполнитель.СписокВыбора	= СписокИсполнителей;
	
КонецПроцедуры

Процедура ЗаполнитьСписокДопПолейЗадачи(ТекЗадача, ЗаполнятьЗначение = Ложь)
	
	НастраиваемыеПоля.Очистить();
	
	Для Каждого ДопПоле Из ТекЗадача.ДополнительныеПоля Цикл
		нСтрока = НастраиваемыеПоля.Добавить();
		
		нСтрока.Идентификатор = ДопПоле.id;
		нСтрока.Имя = ДопПоле.name;
		
		Если ЗаполнятьЗначение Тогда
			нСтрока.Значение = ДопПоле.value;
			нСтрока.Пометка = Истина;
		Иначе
			
		КонецЕсли;
	КонецЦикла;
	
КонецПроцедуры

Процедура ЗаполнитьСписокНаблюдателейПроекта()
	
	Если Не ВсеПоляЗаполнены(Новый Структура("APIkey", "Проект")) Тогда
		Возврат;
	КонецЕсли;

	мПроект = ПолучитьИдентификаторПараметра(Проект, "projects");
	Если Не ЗначениеЗаполнено(мПроект) Тогда
		Возврат;
	КонецЕсли;
	
	//: ЗагруженныеДанные = Новый Соответствие
	Данные = ЗагруженныеДанные.Получить("memberships");
	
	Если Данные = Неопределено Тогда
		
		Данные = ПолучитьДанныеРесурсаИзТрекера("projects/"+мПроект+"/memberships", ОтчетОВыполнении);
		
		Если ОтчетОВыполнении.ЕстьОшибки Тогда
			Сообщить(ОтчетОВыполнении.ТекстОшибки);
			Возврат;
		КонецЕсли;
		
		ЗагруженныеДанные.Вставить("memberships", Данные);
	КонецЕсли;
	
	Для Каждого Структура Из Данные["memberships"] Цикл
		Если мНаблюдатели.Найти(Структура.user.id, "Идентификатор") = Неопределено Тогда
			нСтрока					= мНаблюдатели.Добавить();
			
			нСтрока.Идентификатор	= Структура.user.id;
			нСтрока.Имя				= Структура.user.name;
		КонецЕсли;
	КонецЦикла;
	
КонецПроцедуры


////////////////////////////////////////////////////////////////////////////////
// ПОВТОРЯЮЩИЕСЯ ДЕЙСТВИЯ ПРИ ИЗМЕНЕНИИ РАЗНЫХ РЕКВИЗИТОВ

Процедура УстановитьВидимость()
	
	ЭлементыФормы.ПанельСвойств.Страницы.ЗатраченноеВремя.Видимость	= Не НоваяЗадача;
	ЭлементыФормы.ПанельСвойств.Страницы.Примечания.Видимость		= Не НоваяЗадача;
	
	ЭлементыФормы.ОписаниеЗадачиHTML.Видимость						= Не мРедактироватьОписание;
	ЭлементыФормы.Описание.Видимость								= мРедактироватьОписание;
	
КонецПроцедуры

Процедура УстановитьЗаголовки()
	
	ЭлементыФормы.ОсновныеДействияФормы.Кнопки.ОсновныеДействияФормыВыполнить.Текст = ?(НоваяЗадача, "Создать", "Редактировать"); 	
	ЭтаФорма.Заголовок = ?(НоваяЗадача, "Новая задача", Проект + ": " + Трекер + " #" + Формат(Номер, "ЧГ=0"));
	
КонецПроцедуры

Процедура УстановитьДоступность()
	
	
КонецПроцедуры

Функция ФорматированиеСтроки(Знач Строка)
	Строка = СокрЛП(Строка);
	Строка = СтрЗаменить(Строка, "-", "");
	
	Возврат ?(Строка="","00010101", Строка);
КонецФункции

////////////////////////////////////////////////////////////////////////////////
// ОБРАБОТЧИКИ СОБЫТИЙ ТАБЛИЧНЫХ ПОЛЕЙ 

Процедура ТаблицаВложенийПриПолученииДанных(Элемент, ОформленияСтрок)
	
	Для каждого ОформлениеСтроки Из ОформленияСтрок Цикл
		
		ДанныеСтроки = ОформлениеСтроки.ДанныеСтроки;
		Ячейки = ОформлениеСтроки.Ячейки;
		
		ЯчейкаСКартинкой = Ячейки["Картинка"];
		ЯчейкаСКартинкой.ОтображатьКартинку = Истина;
		
		Если ДанныеСтроки["Расширение"] = ".xls" Или ДанныеСтроки["Расширение"] = ".xlsx" Тогда
			ЯчейкаСКартинкой.Картинка = БиблиотекаКартинок.ПиктограммаФайла_Excel;
		ИначеЕсли ДанныеСтроки["Расширение"] = ".epf" Тогда
			ЯчейкаСКартинкой.Картинка = БиблиотекаКартинок.ПиктограммаФайла_EPF;
		ИначеЕсли ДанныеСтроки["Расширение"] = ".txt" Или ДанныеСтроки["Расширение"] = ".ini" Тогда
			ЯчейкаСКартинкой.Картинка = БиблиотекаКартинок.ПиктограммаФайла_TXT;
		ИначеЕсли ДанныеСтроки["Расширение"] = ".cf" Или ДанныеСтроки["Расширение"] = ".dt" Тогда
			ЯчейкаСКартинкой.Картинка = БиблиотекаКартинок.ПиктограммаФайла_1С;
		ИначеЕсли ДанныеСтроки["Расширение"] = ".doc" Тогда
			ЯчейкаСКартинкой.Картинка = БиблиотекаКартинок.ПиктограммаФайла_Word;
		ИначеЕсли ДанныеСтроки["Расширение"] = ".xml" Тогда
			ЯчейкаСКартинкой.Картинка = БиблиотекаКартинок.ПиктограммаФайла_XML;
		Иначе
			ЯчейкаСКартинкой.Картинка = БиблиотекаКартинок.ПиктограммаФайла_TXT;
		КонецЕсли;
			
	КонецЦикла;
	
КонецПроцедуры

Процедура ТаблицаВложенийПередНачаломДобавления(Элемент, Отказ, Копирование)
	Отказ = Истина;
КонецПроцедуры


Процедура ЗадачиПриПолученииДанных(Элемент, ОформленияСтрок)
	
	Для Каждого ОформлениеСтроки Из ОформленияСтрок Цикл
		Если ОформлениеСтроки.ДанныеСтроки.ИдентификаторПроекта > 0 Тогда
			ОформлениеСтроки.Шрифт = Новый Шрифт(,, Истина,);		
		КонецЕсли;
	КонецЦикла;
	
КонецПроцедуры

Процедура ЗадачиПриАктивизацииСтроки(Элемент)
	
	ТекСтрокаДерева = ЭлементыФормы.СписокЗадач.ТекущиеДанные;
	Если ТекСтрокаДерева.Идентификатор > 0 Тогда
		//ЭлементыФормы.НадписьОписаниеЗадачи.Заголовок = ТекСтрокаДерева.Описание;
		//ЭлементыФормы.ПолеHTMLДокумента.УстановитьТекст(ТекСтрокаДерева.Описание);
	КонецЕсли;
	
КонецПроцедуры


Процедура НаблюдателиПередНачаломДобавления(Элемент, Отказ, Копирование)
	Отказ = Истина;
КонецПроцедуры

Процедура ДопПоляПередНачаломДобавления(Элемент, Отказ, Копирование)
	Отказ = Истина;
КонецПроцедуры


Процедура ДеревоПодзадачПередНачаломДобавления(Элемент, Отказ, Копирование, Родитель)
	Отказ = Истина;
КонецПроцедуры

Процедура ДеревоПодзадачВыбор(Элемент, ВыбраннаяСтрока, Колонка, СтандартнаяОбработка)
	
	СтандартнаяОбработка = Ложь;
	
	Если ВыбраннаяСтрока.Идентификатор <> 0 Тогда
		ЭтаФорма.ВладелецФормы.ОткрытьФормуЗадачиДляРедактирования(ВыбраннаяСтрока.Идентификатор);
	КонецЕсли;

КонецПроцедуры


////////////////////////////////////////////////////////////////////////////////
// ОБРАБОТЧИКИ СОБЫТИЙ ИЗМЕНЕНИЯ РЕКВИЗИТОВ

Процедура ЗадачаПроектПриИзменении(Элемент)
	
	ЗаполнитьСписокВыбораИсполнителей();
	
	УстановитьЗаголовки();

КонецПроцедуры


Процедура ПроектНачалоВыбораИзСписка(Элемент, СтандартнаяОбработка)
	ЗаполнитьСписокВыбораПроекта();
КонецПроцедуры

Процедура ТрекерНачалоВыбораИзСписка(Элемент, СтандартнаяОбработка)
	ЗаполнитьСписокВыбораЭлементаФормы(ЭтаФорма, Элемент.Имя, "trackers");
КонецПроцедуры

Процедура СтатусНачалоВыбораИзСписка(Элемент, СтандартнаяОбработка)
	ЗаполнитьСписокВыбораЭлементаФормы(ЭтаФорма, Элемент.Имя, "issue_statuses");
КонецПроцедуры

Процедура ПриоритетНачалоВыбораИзСписка(Элемент, СтандартнаяОбработка)
	ЗаполнитьСписокВыбораЭлементаФормы(ЭтаФорма, Элемент.Имя, "enumerations/issue_priorities", "issue_priorities");
КонецПроцедуры

Процедура ИсполнительНачалоВыбораИзСписка(Элемент, СтандартнаяОбработка)
	ЗаполнитьСписокВыбораИсполнителей();
КонецПроцедуры

Процедура ДеятельностьИмяНачалоВыбораИзСписка(Элемент, СтандартнаяОбработка)
	ЗаполнитьСписокВыбораЭлементаФормы(ЭтаФорма, Элемент.Имя, "enumerations/time_entry_activities", "time_entry_activities");
КонецПроцедуры


Процедура ИзменитьОписаниеНажатие(Элемент)
	
	мРедактироватьОписание = Не мРедактироватьОписание;
	
	УстановитьВидимость();
	
	КонвертироватьОписаниеЗадачиВHTML();
	
КонецПроцедуры

Процедура ДопПоляЗначениеПриИзменении(Элемент)
	
	ТекСтрока = ЭлементыФормы.НастраиваемыеПоля.ТекущиеДанные;
	Если ТекСтрока <> Неопределено Тогда
		ТекСтрока.Пометка = ЗначениеЗаполнено(ТекСтрока.Значение);		
	КонецЕсли;
	
КонецПроцедуры

Процедура ОсновныеДействияФормыДействие(Кнопка)
	ЗаполнитьРеквизитыЗадачиДаннымиИзФормы();
КонецПроцедуры

Процедура ДеревоПодзадачПриПолученииДанных(Элемент, ОформленияСтрок)
	Для Каждого ОформлениеСтроки Из ОформленияСтрок  Цикл
		НайденСтрока = СписокЗадач.Найти(ОформлениеСтроки.ДанныеСтроки.Идентификатор, "Идентификатор");
		Если НайденСтрока <> Неопределено Тогда
			Если НайденСтрока.Статус = "Closed" Тогда
				ОформлениеСтроки.ДанныеСтроки.Закрыта = Истина;	
			Иначе
				ОформлениеСтроки.Шрифт = Новый Шрифт("Авто",, Истина)	
			КонецЕсли;
		Иначе
			ОформлениеСтроки.ДанныеСтроки.Закрыта = Истина;	
		КонецЕсли;
	КонецЦикла;
КонецПроцедуры

Процедура ПроектПриИзменении(Элемент)
	ЗаполнитьСписокВыбораИсполнителей();
КонецПроцедуры



мРедактироватьОписание = Ложь;
НоваяЗадача = ?(НоваяЗадача=Неопределено, Ложь, Истина);
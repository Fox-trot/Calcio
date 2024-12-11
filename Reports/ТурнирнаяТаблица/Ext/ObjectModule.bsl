﻿
Функция ОтчетСформировать() Экспорт
	ТабДокумент = Новый ТабличныйДокумент;
	
	Лига	= Чемпионат.Владелец;
	Выборка = ТурнирнаяТаблица();
	
	ТабДокумент.Вывести(ЗаголовокПолучить(Лига));
	
	Макет  = ПолучитьОбщийМакет("ТурнирнаяТаблица");
	//ТабДокумент.ФиксацияСлева	= 10;
	
	НомерСтроки	= 0;
	Если ТурнирнаяТаблицаКакНаBBC() Тогда
		ТабДокумент.Вывести(Макет.ПолучитьОбласть("Шапка1"));
		//ТабДокумент.ФиксацияСверху	= 2 + Выборка.Количество();
		Пока Выборка.Следующий() Цикл
			НомерСтроки	= НомерСтроки + 1;
			ОбластьМакета = Макет.ПолучитьОбласть("Детали1|Начало");
			ОбластьМакета.Параметры.Заполнить(Выборка);
			ОбластьМакета.Параметры.Место	= НомерСтроки;
			ТабДокумент.Вывести(ОбластьМакета);
			
			Пятерка		= 1;
			Матчи = МатчиПоследние5(Выборка.Команда);
			Для Каждого Детали Из Матчи Цикл
				ОбластьМакета = Макет.ПолучитьОбласть("Детали1|" + Детали.Результат);
				ОбластьМакета.Параметры.Заполнить(Детали);
				ТабДокумент.Присоединить(ОбластьМакета);
				Пятерка		= Пятерка + 1;
			КонецЦикла;
			Для Шаг = Пятерка По 5 Цикл
				ОбластьМакета = Макет.ПолучитьОбласть("Детали1|NN");
				ТабДокумент.Присоединить(ОбластьМакета);
			КонецЦикла;
		КонецЦикла;
	Иначе
		ТабДокумент.Вывести(Макет.ПолучитьОбласть("Шапка"));
		Если Лига.ОлимпийскаяСистема Тогда
			НаВылет			= Выборка.Количество();
			Пятерка			= -1;
		Иначе
			НаВылет			= Выборка.Количество() - Лига.КоличествоРотация;
			Пятерка			= 0;
		КонецЕсли;
		Пока Выборка.Следующий() Цикл
			НомерСтроки	= НомерСтроки + 1;
			
			Если НомерСтроки > Лига.Квалификация Тогда
				Если НомерСтроки > НаВылет Тогда
					ОбластьМакета = ПолучитьОбласть(Макет, 5);
					
				ИначеЕсли Пятерка = Выборка.КоличествоОчков Тогда
					ОбластьМакета = ПолучитьОбласть(Макет, 5);

				Иначе
					ОбластьМакета = ПолучитьОбласть(Макет);
				КонецЕсли;
				
			Иначе
				ОбластьМакета = ПолучитьОбласть(Макет, 5);
				Если Пятерка >= 0 Тогда
					Пятерка = Выборка.КоличествоОчков;
				КонецЕсли;
			КонецЕсли;
			ОбластьМакета.Параметры.Заполнить(Выборка);
			ОбластьМакета.Параметры.Место	= НомерСтроки;
			Если НЕ ПоказыватьРазницуМячей Тогда
				ОбластьМакета.Параметры.Разница	= Строка(Выборка.Забито) + "-" + Строка(Выборка.Пропущено);
			КонецЕсли;
			
			ТабДокумент.Вывести(ОбластьМакета);
		КонецЦикла;
		
		ОбластьМакета = Макет.ПолучитьОбласть("Комментарий");
		Выборка = КомментарииПолучить();
		Пока Выборка.Следующий() Цикл
			ОбластьМакета.Параметры.Заполнить(Выборка);
			ТабДокумент.Вывести(ОбластьМакета);
		КонецЦикла;
	КонецЕсли;
	Возврат ТабДокумент;
КонецФункции

Функция ПолучитьОбласть(Макет, Параметр=0)
	Возврат Макет.ПолучитьОбласть(?(Параметр = 0, "Детали", "Пятерка"));
КонецФункции

Функция ЗаголовокПолучить(Лига)
	Возврат СерверныйФункции.ЗаголовокПолучить(Новый Структура("Лига,Чемпионат", Лига, Чемпионат));
КонецФункции

Функция КомментарииПолучить()
	Возврат СерверныйФункции.КомментарииПолучить(Чемпионат);
КонецФункции

Функция МатчиПоследние5(Команда)
	Возврат СерверныйФункции.МатчиПоследние5(Команда, Чемпионат);
КонецФункции

Функция ТурнирнаяТаблица()
	Возврат СерверныйФункции.ТурнирнаяТаблица(Чемпионат);
КонецФункции

Функция ТурнирнаяТаблицаКакНаBBC()
	Возврат СерверныйФункции.ТурнирнаяТаблицаКакНаBBC();
КонецФункции

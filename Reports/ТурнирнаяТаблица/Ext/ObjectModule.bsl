﻿
Функция ОтчетСформировать() Экспорт
	ТабДокумент = Новый ТабличныйДокумент;
	
	Регистраторы.Очистить();
	
	Лига	= Чемпионат.Владелец;
	Тур		= ?(СерверныйФункции.ВыводитьТурВместоЧемпионата(), СерверныйФункции.ТурНеПоследний(Чемпионат), Неопределено);
	Выборка = СерверныйФункции.ТурнирнаяТаблица(Чемпионат);
	
	Макет  = ПолучитьОбщийМакет("ТурнирнаяТаблица");
	ОбластьМакета = Макет.ПолучитьОбласть("Заголовок");
	ОбластьМакета.Параметры.Заполнить(Новый Структура("Чемпионат,Лига", ?(ЗначениеЗаполнено(Тур), Тур, Чемпионат), Лига));
	СерверныйФункции.ИзображениеУстановить(ОбластьМакета, Лига);
	ТабДокумент.Вывести(ОбластьМакета);
	ТабДокумент.ФиксацияСлева	= 10;
	
	НомерСтроки	= 0;
	Если СерверныйФункции.ТурнирнаяТаблицаКакНаBBC() Тогда
		ТабДокумент.Вывести(Макет.ПолучитьОбласть("Шапка1"));
		//ТабДокумент.ФиксацияСверху	= 2 + Выборка.Количество();
		Пока Выборка.Следующий() Цикл
			НомерСтроки	= НомерСтроки + 1;
			ОбластьМакета = Макет.ПолучитьОбласть("Детали1|Начало");
			ОбластьМакета.Параметры.Заполнить(Выборка);
			ОбластьМакета.Параметры.Место	= НомерСтроки;
			ТабДокумент.Вывести(ОбластьМакета);
			
			Пятерка		= 1;
			Матчи = СерверныйФункции.МатчиПоследние5(Выборка.Команда, Чемпионат);
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
		
		НаВылет		= Выборка.Количество() - Лига.КоличествоРотация;
		Пятерка		= 0;
		Пока Выборка.Следующий() Цикл
			НомерСтроки	= НомерСтроки + 1;
			
			Если НомерСтроки > Лига.КвалификацияВЛигуЧемпионовУЕФА Тогда
				Если НомерСтроки > НаВылет Тогда
					ОбластьМакета = ПолучитьОбласть(Макет, 5);
					
				ИначеЕсли Пятерка = Выборка.КоличествоОчков Тогда
					ОбластьМакета = ПолучитьОбласть(Макет, 5);
					//ТабДокумент.ФиксацияСверху = 2 + НомерСтроки;

				Иначе
					ОбластьМакета = ПолучитьОбласть(Макет);
				КонецЕсли;
				
			Иначе
				ОбластьМакета = ПолучитьОбласть(Макет, 5);
				//ТабДокумент.ФиксацияСверху = 2 + НомерСтроки;

				Пятерка = Выборка.КоличествоОчков;
			КонецЕсли;
			ОбластьМакета.Параметры.Заполнить(Выборка);
			ОбластьМакета.Параметры.Место	= НомерСтроки;
			Если НЕ ПоказыватьРазницуМячей Тогда
				ОбластьМакета.Параметры.Разница	= Строка(Выборка.Забито) + "-" + Строка(Выборка.Пропущено);
			КонецЕсли;
			
			ТабДокумент.Вывести(ОбластьМакета);
			
			//Регистраторы.Добавить(Выборка.Команда);
		КонецЦикла;
		Регистраторы.Добавить(Чемпионат);
		
		ОбластьМакета = Макет.ПолучитьОбласть("Комментарий");
		Выборка = СерверныйФункции.КомментарииПолучить(Чемпионат);
		Пока Выборка.Следующий() Цикл
			ОбластьМакета.Параметры.Заполнить(Выборка);
			ТабДокумент.Вывести(ОбластьМакета);
			
			Регистраторы.Добавить(Выборка.Регистратор);
		КонецЦикла;
	КонецЕсли;
	Возврат ТабДокумент;
КонецФункции

Функция ПолучитьОбласть(Макет, Параметр=0)
	Если Параметр = 0 Тогда
		ОбластьМакета = Макет.ПолучитьОбласть("Детали");
	Иначе
		ОбластьМакета = Макет.ПолучитьОбласть("Пятерка");
	КонецЕсли;
	Возврат ОбластьМакета;
КонецФункции

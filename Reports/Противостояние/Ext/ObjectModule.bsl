﻿
Функция ОтчетСформировать() Экспорт
	ТабДокумент = Новый ТабличныйДокумент;
	
	Лига	= Чемпионат.Владелец;
	Запрос	= Новый Запрос("ВЫБРАТЬ РАЗЛИЧНЫЕ
	      	               |	МатчКоманды.Ссылка КАК Ссылка,
	      	               |	МатчКоманды.КоличествоГолов КАК КоличествоГолов
	      	               |ПОМЕСТИТЬ Матчи
	      	               |ИЗ
	      	               |	Документ.Матч.Команды КАК МатчКоманды
	      	               |		ВНУТРЕННЕЕ СОЕДИНЕНИЕ РегистрНакопления.ТурнирнаяТаблица КАК ТурнирнаяТаблица
	      	               |			ВНУТРЕННЕЕ СОЕДИНЕНИЕ Справочник.Туры КАК Туры
	      	               |			ПО ТурнирнаяТаблица.Тур = Туры.Ссылка
	      	               |		ПО МатчКоманды.Ссылка = ТурнирнаяТаблица.Регистратор
	      	               |ГДЕ
	      	               |	МатчКоманды.Команда = &Команда
	      	               |	И Туры.Владелец = &Чемпионат
	      	               |;
	      	               |
	      	               |////////////////////////////////////////////////////////////////////////////////
	      	               |ВЫБРАТЬ
	      	               |	ЧемпионатыКоманды.Команда КАК Команда,
	      	               |	МАКСИМУМ(ВЫБОР
	      	               |			КОГДА ТурнирнаяТаблица.НомерСтроки = 2
	      	               |					И ТурнирнаяТаблица.КоличествоОчков = 0
	      	               |				ТОГДА 3
	      	               |			КОГДА ТурнирнаяТаблица.НомерСтроки = 2
	      	               |					И ТурнирнаяТаблица.КоличествоОчков = 1
	      	               |				ТОГДА 1
	      	               |			КОГДА ТурнирнаяТаблица.НомерСтроки = 2
	      	               |					И ТурнирнаяТаблица.КоличествоОчков > 1
	      	               |				ТОГДА 0
	      	               |			ИНАЧЕ -1
	      	               |		КОНЕЦ) КАК Дома,
	      	               |	МАКСИМУМ(ВЫБОР
	      	               |			КОГДА ТурнирнаяТаблица.НомерСтроки = 1
	      	               |					И ТурнирнаяТаблица.КоличествоОчков = 0
	      	               |				ТОГДА 3
	      	               |			КОГДА ТурнирнаяТаблица.НомерСтроки = 1
	      	               |					И ТурнирнаяТаблица.КоличествоОчков = 1
	      	               |				ТОГДА 1
	      	               |			КОГДА ТурнирнаяТаблица.НомерСтроки = 1
	      	               |					И ТурнирнаяТаблица.КоличествоОчков > 1
	      	               |				ТОГДА 0
	      	               |			ИНАЧЕ -1
	      	               |		КОНЕЦ) КАК Выезд,
	      	               |	СУММА(ЕСТЬNULL(Матчи.КоличествоГолов, 0)) КАК КоличествоГолов,
	      	               |	СУММА(ВЫБОР
	      	               |			КОГДА ТурнирнаяТаблица.КоличествоОчков = 0
	      	               |				ТОГДА 3
	      	               |			КОГДА ТурнирнаяТаблица.КоличествоОчков = 1
	      	               |				ТОГДА 1
	      	               |			ИНАЧЕ 0
	      	               |		КОНЕЦ) КАК КоличествоОчков,
	      	               |	КОЛИЧЕСТВО(РАЗЛИЧНЫЕ ТурнирнаяТаблица.Регистратор) КАК КоличествоИгр
	      	               |ИЗ
	      	               |	Справочник.Чемпионаты.Команды КАК ЧемпионатыКоманды
	      	               |		ЛЕВОЕ СОЕДИНЕНИЕ РегистрНакопления.ТурнирнаяТаблица КАК ТурнирнаяТаблица
	      	               |			ВНУТРЕННЕЕ СОЕДИНЕНИЕ Матчи КАК Матчи
	      	               |			ПО ТурнирнаяТаблица.Регистратор = Матчи.Ссылка
	      	               |		ПО ЧемпионатыКоманды.Команда = ТурнирнаяТаблица.Команда
	      	               |ГДЕ
	      	               |	ЧемпионатыКоманды.Ссылка = &Чемпионат
	      	               |	И ЧемпионатыКоманды.Команда <> &Команда
	      	               |
	      	               |СГРУППИРОВАТЬ ПО
	      	               |	ЧемпионатыКоманды.Команда
	      	               |
	      	               |УПОРЯДОЧИТЬ ПО
	      	               |	КоличествоОчков УБЫВ,
	      	               |	КоличествоИгр,
	      	               |	КоличествоГолов УБЫВ,
	      	               |	Дома");
	Запрос.УстановитьПараметр("Чемпионат",				Чемпионат);
	Запрос.УстановитьПараметр("Команда",				Команда);
	Выборка = Запрос.Выполнить().Выбрать();
	
	Макет  = ПолучитьМакет("Макет");
	ОбластьМакета = Макет.ПолучитьОбласть("Заголовок");
	ОбластьМакета.Параметры.Заполнить(Новый Структура("Команда,Чемпионат,Лига", Команда, Чемпионат, Лига));
	СерверныйФункции.ИзображениеУстановить(ОбластьМакета, Лига);
	ТабДокумент.Вывести(ОбластьМакета);
	
	ТабДокумент.Вывести(Макет.ПолучитьОбласть("Шапка"));
	//ТабДокумент.ФиксацияСверху	= 4 + Выборка.Количество();
	ТабДокумент.ФиксацияСлева	= 8;
	
	Итого	= Новый Структура("Дома,Выезд,КоличествоГолов,КоличествоИгр,КоличествоОчков", 0, 0, 0, 0, 0);
	Пока Выборка.Следующий() Цикл
		ОбластьМакета = Макет.ПолучитьОбласть("Детали|Начало");
		ОбластьМакета.Параметры.Заполнить(Выборка);
		ТабДокумент.Вывести(ОбластьМакета);
		Присоединить(ТабДокумент, Макет, Выборка.Дома);
		Присоединить(ТабДокумент, Макет, Выборка.Выезд);
		ОбластьМакета = Макет.ПолучитьОбласть("Детали|Конец");
		ОбластьМакета.Параметры.Заполнить(Выборка);
		ТабДокумент.Присоединить(ОбластьМакета);
		Если Выборка.Дома > 0 Тогда
			Итого.Дома	= Итого.Дома + Выборка.Дома;
		КонецЕсли;
		Если Выборка.Выезд > 0 Тогда
			Итого.Выезд	= Итого.Выезд + Выборка.Выезд;
		КонецЕсли;
		Итого.КоличествоГолов	= Итого.КоличествоГолов + Выборка.КоличествоГолов;
		Итого.КоличествоИгр	 	= Итого.КоличествоИгр + Выборка.КоличествоИгр;
		Итого.КоличествоОчков	= Итого.КоличествоОчков + Выборка.КоличествоОчков;
	КонецЦикла;
	
	Выборка	= СерверныйФункции.КомментарииПолучить(Чемпионат);
	Пока Выборка.Следующий() Цикл
		Если Выборка.Команда = Команда Тогда
			Итого.КоличествоОчков	= Итого.КоличествоОчков + Выборка.КоличествоОчков;
		КонецЕсли;
	КонецЦикла;
	ОбластьМакета = Макет.ПолучитьОбласть("Итого");
	ОбластьМакета.Параметры.Заполнить(Итого);
	ТабДокумент.Вывести(ОбластьМакета);
	
	Выборка.Сбросить();
	ОбластьМакета = Макет.ПолучитьОбласть("Комментарий");
	Пока Выборка.Следующий() Цикл
		Если Выборка.Команда = Команда Тогда
			ОбластьМакета.Параметры.Заполнить(Выборка);
			ТабДокумент.Вывести(ОбластьМакета);
		КонецЕсли;
	КонецЦикла;
	
	Возврат ТабДокумент;
КонецФункции

Процедура Присоединить(ТабДокумент, Макет, Данные)
	ОбластьМакета = Макет.ПолучитьОбласть("Детали|" + ?(Данные=0, "LL", ?(Данные=1, "DD", ?(Данные=3, "WW", "NN"))));
	ТабДокумент.Присоединить(ОбластьМакета);
КонецПроцедуры

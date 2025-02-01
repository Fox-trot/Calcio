﻿
Функция ОтчетСформировать() Экспорт
	ТабДокумент = Новый ТабличныйДокумент;
	
	Лига	= Чемпионат.Владелец;
	Запрос	= Новый Запрос("ВЫБРАТЬ
	      	               |	ЧемпионатыКоманды.Команда КАК Команда,
	      	               |	МАКСИМУМ(ВЫБОР
	      	               |			КОГДА ТурнирнаяТаблица.НомерСтроки = 2
	      	               |				ТОГДА ТурнирнаяТаблица.Регистратор
	      	               |			ИНАЧЕ NULL
	      	               |		КОНЕЦ) КАК МатчД,
	      	               |	МАКСИМУМ(ВЫБОР
	      	               |			КОГДА ТурнирнаяТаблица.НомерСтроки = 2
	      	               |					И ТурнирнаяТаблица.КоличествоОчков = 0
	      	               |				ТОГДА 3
	      	               |			КОГДА ТурнирнаяТаблица.НомерСтроки = 2
	      	               |					И ТурнирнаяТаблица.КоличествоОчков = 1
	      	               |				ТОГДА 1
	      	               |			КОГДА ТурнирнаяТаблица.НомерСтроки = 2
	      	               |					И ТурнирнаяТаблица.КоличествоОчков >= 2
	      	               |				ТОГДА 0
	      	               |			ИНАЧЕ -1
	      	               |		КОНЕЦ) КАК Дома,
	      	               |	МАКСИМУМ(ВЫБОР
	      	               |			КОГДА ТурнирнаяТаблица.НомерСтроки = 1
	      	               |				ТОГДА ТурнирнаяТаблица.Регистратор
	      	               |			ИНАЧЕ NULL
	      	               |		КОНЕЦ) КАК МатчВ,
	      	               |	МАКСИМУМ(ВЫБОР
	      	               |			КОГДА ТурнирнаяТаблица.НомерСтроки = 1
	      	               |					И ТурнирнаяТаблица.КоличествоОчков = 0
	      	               |				ТОГДА 3
	      	               |			КОГДА ТурнирнаяТаблица.НомерСтроки = 1
	      	               |					И ТурнирнаяТаблица.КоличествоОчков = 1
	      	               |				ТОГДА 1
	      	               |			КОГДА ТурнирнаяТаблица.НомерСтроки = 1
	      	               |					И ТурнирнаяТаблица.КоличествоОчков >= 2
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
	      	               |			ВНУТРЕННЕЕ СОЕДИНЕНИЕ (ВЫБРАТЬ РАЗЛИЧНЫЕ
	      	               |				МатчКоманды.Регистратор КАК Ссылка,
	      	               |				МатчКоманды.КоличествоГолов КАК КоличествоГолов
	      	               |			ИЗ
	      	               |				РегистрНакопления.ТурнирнаяТаблица КАК МатчКоманды
	      	               |					ВНУТРЕННЕЕ СОЕДИНЕНИЕ РегистрНакопления.ТурнирнаяТаблица КАК ТурнирнаяТаблица
	      	               |						ВНУТРЕННЕЕ СОЕДИНЕНИЕ Справочник.Туры КАК Туры
	      	               |						ПО ТурнирнаяТаблица.Тур = Туры.Ссылка
	      	               |					ПО МатчКоманды.Регистратор = ТурнирнаяТаблица.Регистратор
	      	               |			ГДЕ
	      	               |				МатчКоманды.Команда = &Команда
	      	               |				И Туры.Владелец = &Чемпионат
	      	               |				И ТИПЗНАЧЕНИЯ(ТурнирнаяТаблица.Регистратор) = ТИП(Документ.Матч)) КАК Матчи
	      	               |			ПО ТурнирнаяТаблица.Регистратор = Матчи.Ссылка
	      	               |		ПО ЧемпионатыКоманды.Команда = ТурнирнаяТаблица.Команда
	      	               |			И (ТИПЗНАЧЕНИЯ(ТурнирнаяТаблица.Регистратор) = ТИП(Документ.Матч))
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
	      	               |	Дома УБЫВ,
	      	               |	Команда
	      	               |АВТОУПОРЯДОЧИВАНИЕ");
	Запрос.УстановитьПараметр("Чемпионат",				Чемпионат);
	Запрос.УстановитьПараметр("Команда",				Команда);
	Выборка = Запрос.Выполнить().Выбрать();
	
	ТабДокумент.Вывести(ЗаголовокПолучить(Лига));
	
	Макет  = ПолучитьМакет("Макет");
	ТабДокумент.Вывести(Макет.ПолучитьОбласть("Шапка"));
	//ТабДокумент.ФиксацияСверху	= 4 + Выборка.Количество();
	//ТабДокумент.ФиксацияСлева	= 8;
	
	Итого	= Новый Структура("НомерСтроки,Дома,Выезд,КоличествоГолов,КоличествоИгр,КоличествоОчков", 0, 0, 0, 0, 0, 0);
	Пока Выборка.Следующий() Цикл
		Итого.НомерСтроки	= Итого.НомерСтроки + 1;
		ОбластьМакета = Макет.ПолучитьОбласть("Детали|Начало");
		ОбластьМакета.Параметры.Заполнить(Выборка);
		ОбластьМакета.Параметры.Место	= Итого.НомерСтроки;
		ТабДокумент.Вывести(ОбластьМакета);
		Присоединить(ТабДокумент, Макет, Выборка.Дома, Выборка.МатчД);
		Присоединить(ТабДокумент, Макет, Выборка.Выезд, Выборка.МатчВ);
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
	
	Выборка	= КомментарииПолучить();
	Пока Выборка.Следующий() Цикл
		Итого.КоличествоОчков	= Итого.КоличествоОчков + Выборка.КоличествоОчков;
	КонецЦикла;
	ОбластьМакета = Макет.ПолучитьОбласть("Итого");
	ОбластьМакета.Параметры.Заполнить(Итого);
	ТабДокумент.Вывести(ОбластьМакета);
	
	Выборка.Сбросить();
	ОбластьМакета = Макет.ПолучитьОбласть("Комментарий");
	Пока Выборка.Следующий() Цикл
		ОбластьМакета.Параметры.Заполнить(Выборка);
		ТабДокумент.Вывести(ОбластьМакета);
	КонецЦикла;
	
	Возврат ТабДокумент;
КонецФункции

Процедура Присоединить(ТабДокумент, Макет, Данные, Регистратор)
	ОбластьМакета = Макет.ПолучитьОбласть("Детали|" + ?(Данные=0, "LL", ?(Данные=1, "DD", ?(Данные=3, "WW", "NN"))));
	Если ЗначениеЗаполнено(Регистратор) Тогда
		ОбластьМакета.Параметры.Регистратор	= Регистратор;
	КонецЕсли;
	ТабДокумент.Присоединить(ОбластьМакета);
КонецПроцедуры

Функция ЗаголовокПолучить(Лига)
	Возврат СерверныйФункции.ЗаголовокПолучить(Новый Структура("Лига,Чемпионат,Команда", Лига, Чемпионат, Команда));
КонецФункции

Функция КомментарииПолучить()
	Возврат СерверныйФункции.КомментарииПолучить(Чемпионат, Команда);
КонецФункции

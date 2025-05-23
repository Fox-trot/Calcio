﻿
Функция ОтчетСформировать(Объект) Экспорт
	ТабДокумент = Новый ТабличныйДокумент;
	Объект.Данные.Очистить();
	
	Лига		= Чемпионат.Владелец;
	
	Запрос = Новый Запрос("ВЫБРАТЬ РАЗЛИЧНЫЕ
	                      |	ЛигаКоманды.Команда КАК Команда
	                      |ПОМЕСТИТЬ Команды
	                      |ИЗ
	                      |	Справочник.Лига.Команды КАК ЛигаКоманды
	                      |		ВНУТРЕННЕЕ СОЕДИНЕНИЕ Справочник.Чемпионаты КАК Чемпионаты
	                      |		ПО ЛигаКоманды.Ссылка = Чемпионаты.Владелец
	                      |ГДЕ
	                      |	Чемпионаты.Ссылка = &Чемпионат
	                      |;
	                      |
	                      |////////////////////////////////////////////////////////////////////////////////
	                      |ВЫБРАТЬ
	                      |	ТурнирнаяТаблица.Регистратор КАК Регистратор,
	                      |	ТурнирнаяТаблица.НомерСтроки КАК НомерСтроки,
	                      |	ТурнирнаяТаблица.Команда КАК Команда,
	                      |	ТурнирнаяТаблица.КоличествоГолов КАК КоличествоГолов,
	                      |	ТурнирнаяТаблица.КоличествоОчков КАК КоличествоОчков
	                      |ПОМЕСТИТЬ ТурнирнаяТаблица
	                      |ИЗ
	                      |	РегистрНакопления.ТурнирнаяТаблица КАК ТурнирнаяТаблица
	                      |		ВНУТРЕННЕЕ СОЕДИНЕНИЕ РегистрНакопления.ТурнирнаяТаблица КАК Противник
	                      |		ПО ТурнирнаяТаблица.Регистратор = Противник.Регистратор
	                      |ГДЕ
	                      |	ТурнирнаяТаблица.Тур.Владелец = &Чемпионат
	                      |	И ТурнирнаяТаблица.Регистратор ССЫЛКА Документ.Матч
	                      |	И ТурнирнаяТаблица.Команда В
	                      |			(ВЫБРАТЬ
	                      |				Команды.Команда
	                      |			ИЗ
	                      |				Команды)
	                      |	И Противник.Команда В
	                      |			(ВЫБРАТЬ
	                      |				Команды.Команда
	                      |			ИЗ
	                      |				Команды)
	                      |	И ТурнирнаяТаблица.НомерСтроки <> Противник.НомерСтроки
	                      |;
	                      |
	                      |////////////////////////////////////////////////////////////////////////////////
	                      |ВЫБРАТЬ
	                      |	Команды.Команда КАК Команда,
	                      |	СУММА(ВЫБОР
	                      |			КОГДА ТурнирнаяТаблица.Регистратор ЕСТЬ NULL
	                      |				ТОГДА 0
	                      |			ИНАЧЕ 1
	                      |		КОНЕЦ) КАК КоличествоИгр,
	                      |	ЕСТЬNULL(СУММА(ТурнирнаяТаблица.КоличествоГолов), 0) КАК КоличествоЗабито,
	                      |	ЕСТЬNULL(СУММА(ТурнирнаяТаблица.КоличествоОчков), 0) КАК КоличествоОчков,
	                      |	СУММА(ВЫБОР
	                      |			КОГДА ТурнирнаяТаблица.КоличествоОчков > Противник.КоличествоОчков
	                      |				ТОГДА 1
	                      |			ИНАЧЕ 0
	                      |		КОНЕЦ) КАК Выигрыш,
	                      |	СУММА(ВЫБОР
	                      |			КОГДА ТурнирнаяТаблица.КоличествоОчков = Противник.КоличествоОчков
	                      |				ТОГДА 1
	                      |			ИНАЧЕ 0
	                      |		КОНЕЦ) КАК Ничья,
	                      |	СУММА(ВЫБОР
	                      |			КОГДА ТурнирнаяТаблица.КоличествоОчков < Противник.КоличествоОчков
	                      |				ТОГДА 1
	                      |			ИНАЧЕ 0
	                      |		КОНЕЦ) КАК Проигрыш,
	                      |	ЕСТЬNULL(СУММА(Противник.КоличествоГолов), 0) КАК Пропущено,
	                      |	ЕСТЬNULL(СУММА(ТурнирнаяТаблица.КоличествоГолов) - СУММА(Противник.КоличествоГолов), 0) КАК Разница
	                      |ИЗ
	                      |	Команды КАК Команды
	                      |		ЛЕВОЕ СОЕДИНЕНИЕ ТурнирнаяТаблица КАК ТурнирнаяТаблица
	                      |			ВНУТРЕННЕЕ СОЕДИНЕНИЕ ТурнирнаяТаблица КАК Противник
	                      |			ПО ТурнирнаяТаблица.Регистратор = Противник.Регистратор
	                      |				И ТурнирнаяТаблица.НомерСтроки <> Противник.НомерСтроки
	                      |		ПО Команды.Команда = ТурнирнаяТаблица.Команда
	                      |
	                      |СГРУППИРОВАТЬ ПО
	                      |	Команды.Команда
	                      |
	                      |УПОРЯДОЧИТЬ ПО
	                      |	КоличествоОчков УБЫВ,
	                      |	КоличествоИгр,
	                      |	Разница УБЫВ,
	                      |	КоличествоЗабито УБЫВ,
	                      |	Команда
	                      |АВТОУПОРЯДОЧИВАНИЕ");
	Запрос.УстановитьПараметр("Чемпионат",		Чемпионат);
	Выборка = Запрос.Выполнить().Выбрать();
	
	ТабДокумент.Вывести(ЗаголовокПолучить(Лига, Чемпионат));
	
	Макет  = ПолучитьОбщийМакет("ТурнирнаяТаблица");
	ТабДокумент.Вывести(Макет.ПолучитьОбласть("Шапка"));
	//ТабДокумент.ФиксацияСверху	= 2 + Выборка.Количество();
	//ТабДокумент.ФиксацияСлева	= 9;
	
	Хозяева		= Неопределено;
	МояКоманда	= МояКомандаПолучить();
	Пока НЕ ЗначениеЗаполнено(Хозяева) И Выборка.Следующий() Цикл
		Если Выборка.Команда = МояКоманда Тогда
			Хозяева = Выборка.Команда;
		КонецЕсли;
	КонецЦикла;
	Выборка.Сбросить();
	
	НомерСтроки	= 0;
	Команды		= Новый Массив;
	Пока Выборка.Следующий() Цикл
		Если НомерСтроки = 0 И НЕ ЗначениеЗаполнено(Хозяева) Тогда
			Хозяева = Выборка.Команда;
		КонецЕсли;
		НомерСтроки	= НомерСтроки + 1;
		
		ОбластьМакета = Макет.ПолучитьОбласть("Детали");
		ОбластьМакета.Параметры.Заполнить(Выборка);
		ОбластьМакета.Параметры.Место	= НомерСтроки;
		ТабДокумент.Вывести(ОбластьМакета);
		
		ЗаполнитьЗначенияСвойств(Объект.Данные.Добавить(), Выборка);
		
		Команды.Добавить(Выборка.Команда);
	КонецЦикла;
	Запрос.УстановитьПараметр("Команды",		Команды);
	
	Запрос.Текст = "ВЫБРАТЬ
	               |	Матч.Дата КАК Дата,
	               |	Матч.Счет КАК Счет,
	               |	Матч.Ссылка КАК Матч,
	               |	ТурнирнаяТаблица.Команда = &Хозяева
	               |		ИЛИ МатчКоманды.Команда = &Хозяева КАК Хозяева
	               |ИЗ
	               |	Документ.Матч КАК Матч
	               |		ВНУТРЕННЕЕ СОЕДИНЕНИЕ РегистрНакопления.ТурнирнаяТаблица КАК ТурнирнаяТаблица
	               |		ПО Матч.Ссылка = ТурнирнаяТаблица.Регистратор
	               |		ВНУТРЕННЕЕ СОЕДИНЕНИЕ РегистрНакопления.ТурнирнаяТаблица КАК МатчКоманды
	               |		ПО Матч.Ссылка = МатчКоманды.Регистратор
	               |ГДЕ
	               |	МатчКоманды.Команда В(&Команды)
	               |	И МатчКоманды.НомерСтроки = 2
	               |	И Матч.Тур.Владелец = &Чемпионат
	               |	И ТурнирнаяТаблица.Команда В(&Команды)
	               |	И ТурнирнаяТаблица.НомерСтроки = 1
	               |
	               |УПОРЯДОЧИТЬ ПО
	               |	Дата УБЫВ,
	               |	Счет";
	Запрос.УстановитьПараметр("Хозяева",		Хозяева);
	Выборка = Запрос.Выполнить().Выбрать();
	ТабДокумент.Вывести(Макет.ПолучитьОбласть("Пробел"));
	Пока Выборка.Следующий() Цикл
		Область = Макет.ПолучитьОбласть(?(Выборка.Хозяева, "Хозяева", "Матчи"));
		Область.Параметры.Заполнить(Выборка);
		ТабДокумент.Вывести(Область);
	КонецЦикла;
	
	Возврат ТабДокумент;
КонецФункции

Функция МояКомандаПолучить()
	Возврат СерверныйФункции.МояКомандаПолучить();
КонецФункции

Функция ЗаголовокПолучить(Лига, Чемп) Экспорт
	Возврат СерверныйФункции.ЗаголовокПолучить(Новый Структура("Лига,Чемпионат", Лига, Чемп));
КонецФункции

Функция МакетПолучить() Экспорт
	Возврат ПолучитьМакет("Хронология");
КонецФункции

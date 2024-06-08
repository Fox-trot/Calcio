﻿
Функция ОтчетСформировать() Экспорт
	ТабДокумент = Новый ТабличныйДокумент;
	
	Лига	= Чемпионат.Владелец;
	Тур		= ?(СерверныйФункции.ВыводитьТурВместоЧемпионата(), СерверныйФункции.ТурНеПоследний(Чемпионат), Неопределено);
	
	Запрос = Новый Запрос(
	"ВЫБРАТЬ
	|	ТурнирнаяТаблица.Регистратор КАК Регистратор,
	|	ТурнирнаяТаблица.НомерСтроки КАК НомерСтроки,
	|	ТурнирнаяТаблица.Команда КАК Команда,
	|	ТурнирнаяТаблица.КоличествоГолов КАК КоличествоГолов,
	|	ТурнирнаяТаблица.КоличествоОчков КАК КоличествоОчков
	|ПОМЕСТИТЬ ТурнирнаяТаблица
	|ИЗ
	|	РегистрНакопления.ТурнирнаяТаблица КАК ТурнирнаяТаблица
	|		ВНУТРЕННЕЕ СОЕДИНЕНИЕ Справочник.Туры КАК Туры
	|		ПО ТурнирнаяТаблица.Тур = Туры.Ссылка
	|		ВНУТРЕННЕЕ СОЕДИНЕНИЕ РегистрНакопления.ТурнирнаяТаблица КАК Матчи
	|		ПО ТурнирнаяТаблица.Регистратор = Матчи.Регистратор
	|			И ТурнирнаяТаблица.НомерСтроки <> Матчи.НомерСтроки
	|ГДЕ
	|	Туры.Владелец = &Чемпионат
	|	И ТИПЗНАЧЕНИЯ(ТурнирнаяТаблица.Регистратор) = ТИП(Документ.Матч)
	|	И ТурнирнаяТаблица.Команда В(&Команды)
	|	И Матчи.Команда В(&Команды)
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
	|	ЕСТЬNULL(СУММА(ТурнирнаяТаблица.КоличествоГолов), 0) КАК Забито,
	|	ЕСТЬNULL(СУММА(ТурнирнаяТаблица.КоличествоОчков), 0) КАК КоличествоОчков,
	|	СУММА(ВЫБОР
	|			КОГДА ТурнирнаяТаблица.КоличествоОчков > Игра.КоличествоОчков
	|				ТОГДА 1
	|			ИНАЧЕ 0
	|		КОНЕЦ) КАК Выигрыш,
	|	СУММА(ВЫБОР
	|			КОГДА ТурнирнаяТаблица.КоличествоОчков = Игра.КоличествоОчков
	|				ТОГДА 1
	|			ИНАЧЕ 0
	|		КОНЕЦ) КАК Ничья,
	|	СУММА(ВЫБОР
	|			КОГДА ТурнирнаяТаблица.КоличествоОчков < Игра.КоличествоОчков
	|				ТОГДА 1
	|			ИНАЧЕ 0
	|		КОНЕЦ) КАК Проигрыш,
	|	ЕСТЬNULL(СУММА(Игра.КоличествоГолов), 0) КАК Пропущено,
	|	ЕСТЬNULL(СУММА(ТурнирнаяТаблица.КоличествоГолов) - СУММА(Игра.КоличествоГолов), 0) КАК Разница
	|ИЗ
	|	Справочник.Чемпионаты.Команды КАК Команды
	|		ЛЕВОЕ СОЕДИНЕНИЕ ТурнирнаяТаблица КАК ТурнирнаяТаблица
	|		ПО Команды.Команда = ТурнирнаяТаблица.Команда
	|		ЛЕВОЕ СОЕДИНЕНИЕ ТурнирнаяТаблица КАК Игра
	|		ПО (ТурнирнаяТаблица.Регистратор = Игра.Регистратор)
	|			И (ТурнирнаяТаблица.НомерСтроки <> Игра.НомерСтроки)
	|ГДЕ
	|	Команды.Ссылка = &Чемпионат
	|	И Команды.Команда В(&Команды)
	|
	|СГРУППИРОВАТЬ ПО
	|	Команды.Команда
	|
	|УПОРЯДОЧИТЬ ПО
	|	КоличествоОчков УБЫВ,
	|	КоличествоИгр,
	|	Разница УБЫВ,
	|	Забито УБЫВ,
	|	Команда
	|АВТОУПОРЯДОЧИВАНИЕ");
	Запрос.УстановитьПараметр("Чемпионат",		Чемпионат);
	Запрос.УстановитьПараметр("Команды",		СерверныйФункции.КомандыЛиги(Лига, Истина));
	Выборка = Запрос.Выполнить().Выбрать();
	
	Макет  = ПолучитьОбщийМакет("ТурнирнаяТаблица");
	ОбластьМакета = Макет.ПолучитьОбласть("Заголовок");
	ОбластьМакета.Параметры.Заполнить(Новый Структура("Чемпионат,Лига", ?(ЗначениеЗаполнено(Тур), Тур, Чемпионат), Лига));
	СерверныйФункции.ИзображениеУстановить(ОбластьМакета, Лига);
	ТабДокумент.Вывести(ОбластьМакета);
	ТабДокумент.Вывести(Макет.ПолучитьОбласть("Шапка"));
	//ТабДокумент.ФиксацияСверху	= 2 + Выборка.Количество();
	ТабДокумент.ФиксацияСлева	= 9;
	
	Хозяева		= Неопределено;
	НомерСтроки	= 0;
	Пока Выборка.Следующий() Цикл
		Если НомерСтроки = 0 Тогда
			Хозяева = Выборка.Команда;
		КонецЕсли;
		НомерСтроки	= НомерСтроки + 1;
		
		ОбластьМакета = Макет.ПолучитьОбласть("Детали");
		ОбластьМакета.Параметры.Заполнить(Выборка);
		ОбластьМакета.Параметры.Место	= НомерСтроки;
		ТабДокумент.Вывести(ОбластьМакета);
	КонецЦикла;
	
	Запрос.Текст = "ВЫБРАТЬ
	               |	Матч.Дата КАК Дата,
	               |	Матч.Счет КАК Счет,
	               |	Матч.Ссылка КАК Матч,
	               |	ТурнирнаяТаблица.Команда = &Хозяева
	               |		ИЛИ МатчКоманды.Команда = &Хозяева КАК Хозяева
	               |ИЗ
	               |	Документ.Матч КАК Матч
	               |		ВНУТРЕННЕЕ СОЕДИНЕНИЕ РегистрНакопления.ТурнирнаяТаблица КАК ТурнирнаяТаблица
	               |			ВНУТРЕННЕЕ СОЕДИНЕНИЕ РегистрНакопления.ТурнирнаяТаблица КАК МатчКоманды
	               |			ПО ТурнирнаяТаблица.Регистратор = МатчКоманды.Регистратор
	               |				И ТурнирнаяТаблица.НомерСтроки > МатчКоманды.НомерСтроки
	               |		ПО Матч.Ссылка = ТурнирнаяТаблица.Регистратор
	               |		ВНУТРЕННЕЕ СОЕДИНЕНИЕ Справочник.Туры КАК Туры
	               |		ПО Матч.Тур = Туры.Ссылка
	               |ГДЕ
	               |	Туры.Владелец = &Чемпионат
	               |	И ТурнирнаяТаблица.Команда В(&Команды)
	               |	И МатчКоманды.Команда В(&Команды)
	               |
	               |УПОРЯДОЧИТЬ ПО
	               |	Дата,
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

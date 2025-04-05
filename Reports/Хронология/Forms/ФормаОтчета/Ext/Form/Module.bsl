﻿
&НаСервере
Процедура ГрафикОбновитьНаСервере()
	Отчет.Данные.Очистить();
	
	Запрос = Новый Запрос;
	Запрос.УстановитьПараметр("Команда",		Отчет.Команда);
	Запрос.УстановитьПараметр("Чемпионат",		Отчет.Чемпионат);
	Если ЗначениеЗаполнено(Отчет.Команда) Тогда
		Если ТипГрафика = 7 Тогда
			Запрос.Текст = 
			"ВЫБРАТЬ
			|	ТурнирнаяТаблица.Период КАК Период,
			|	ТурнирнаяТаблица.Регистратор КАК Матч,
			|	Матч.Представление КАК Подсказка,
			|	ВЫБОР
			|		КОГДА ТурнирнаяТаблица1.КоличествоГолов = 0
			|			ТОГДА ТурнирнаяТаблица.КоличествоГолов
			|		ИНАЧЕ 0
			|	КОНЕЦ КАК КоличествоЗабито,
			|	0 - ТурнирнаяТаблица1.КоличествоГолов КАК КоличествоПропущено
			|ИЗ
			|	РегистрНакопления.ТурнирнаяТаблица КАК ТурнирнаяТаблица
			|		ВНУТРЕННЕЕ СОЕДИНЕНИЕ Документ.Матч КАК Матч
			|		ПО ТурнирнаяТаблица.Регистратор = Матч.Ссылка
			|		ВНУТРЕННЕЕ СОЕДИНЕНИЕ РегистрНакопления.ТурнирнаяТаблица КАК ТурнирнаяТаблица1
			|		ПО ТурнирнаяТаблица.Регистратор = ТурнирнаяТаблица1.Регистратор
			|ГДЕ
			|	ТурнирнаяТаблица.Команда = &Команда
			|	И ТурнирнаяТаблица.КоличествоОчков >= 2
			|	И ТурнирнаяТаблица.Тур.Владелец = &Чемпионат
			|	И ТурнирнаяТаблица1.Команда <> &Команда
			|
			|УПОРЯДОЧИТЬ ПО
			|	Период";
		ИначеЕсли ТипГрафика = 6 Тогда
			Запрос.Текст = 
			"ВЫБРАТЬ
			|	ТурнирнаяТаблица.Период КАК Период,
			|	ТурнирнаяТаблица.Регистратор КАК Матч,
			|	Матч.Представление КАК Подсказка,
			|	ВЫБОР
			|		КОГДА ТурнирнаяТаблица1.КоличествоГолов = 0
			|			ТОГДА ТурнирнаяТаблица.КоличествоГолов
			|		ИНАЧЕ 0
			|	КОНЕЦ КАК КоличествоЗабито,
			|	0 - ТурнирнаяТаблица1.КоличествоГолов КАК КоличествоПропущено
			|ИЗ
			|	РегистрНакопления.ТурнирнаяТаблица КАК ТурнирнаяТаблица
			|		ВНУТРЕННЕЕ СОЕДИНЕНИЕ Документ.Матч КАК Матч
			|		ПО ТурнирнаяТаблица.Регистратор = Матч.Ссылка
			|		ВНУТРЕННЕЕ СОЕДИНЕНИЕ РегистрНакопления.ТурнирнаяТаблица КАК ТурнирнаяТаблица1
			|		ПО ТурнирнаяТаблица.Регистратор = ТурнирнаяТаблица1.Регистратор
			|ГДЕ
			|	ТурнирнаяТаблица.Команда = &Команда
			|	И ТурнирнаяТаблица.Тур.Владелец = &Чемпионат
			|	И ТурнирнаяТаблица1.Команда <> &Команда
			|
			|УПОРЯДОЧИТЬ ПО
			|	Период";
		ИначеЕсли ТипГрафика = 5 Тогда
			Запрос.Текст = 
			"ВЫБРАТЬ
			|	ТурнирнаяТаблица.Период КАК Период,
			|	ТурнирнаяТаблица.КоличествоОчков КАК КоличествоОчков,
			|	ТурнирнаяТаблица1.КоличествоГолов КАК КоличествоГолов
			|ПОМЕСТИТЬ ТурнирнаяТаблица
			|ИЗ
			|	РегистрНакопления.ТурнирнаяТаблица КАК ТурнирнаяТаблица
			|		ВНУТРЕННЕЕ СОЕДИНЕНИЕ РегистрНакопления.ТурнирнаяТаблица КАК ТурнирнаяТаблица1
			|		ПО ТурнирнаяТаблица.Регистратор = ТурнирнаяТаблица1.Регистратор
			|ГДЕ
			|	ТурнирнаяТаблица.Команда = &Команда
			|	И ТурнирнаяТаблица.Тур.Владелец = &Чемпионат
			|	И ТурнирнаяТаблица1.Команда <> &Команда
			|;
			|
			|////////////////////////////////////////////////////////////////////////////////
			|ВЫБРАТЬ РАЗЛИЧНЫЕ
			|	ТурнирнаяТаблица.Период КАК Период,
			|	ЕСТЬNULL(ТурнирнаяТаблица1.Период, ТурнирнаяТаблица.Период) КАК Период1
			|ПОМЕСТИТЬ Комбинации
			|ИЗ
			|	ТурнирнаяТаблица КАК ТурнирнаяТаблица
			|		ЛЕВОЕ СОЕДИНЕНИЕ ТурнирнаяТаблица КАК ТурнирнаяТаблица1
			|		ПО ТурнирнаяТаблица.Период >= ТурнирнаяТаблица1.Период
			|			И ТурнирнаяТаблица1.КоличествоГолов = 0
			|ГДЕ
			|	ТурнирнаяТаблица.КоличествоОчков >= 1
			|;
			|
			|////////////////////////////////////////////////////////////////////////////////
			|ВЫБРАТЬ
			|	Комбинации.Период1 КАК Период1,
			|	МАКСИМУМ(Комбинации.Период) КАК Период
			|ПОМЕСТИТЬ Окна
			|ИЗ
			|	Комбинации КАК Комбинации
			|		ЛЕВОЕ СОЕДИНЕНИЕ ТурнирнаяТаблица КАК ТурнирнаяТаблица
			|		ПО (ТурнирнаяТаблица.Период МЕЖДУ Комбинации.Период1 И Комбинации.Период)
			|			И (ТурнирнаяТаблица.КоличествоГолов >= 1)
			|ГДЕ
			|	ВЫБОР
			|			КОГДА Комбинации.Период = Комбинации.Период1
			|				ТОГДА ИСТИНА
			|			ИНАЧЕ ТурнирнаяТаблица.Период ЕСТЬ NULL
			|		КОНЕЦ
			|
			|СГРУППИРОВАТЬ ПО
			|	Комбинации.Период1
			|;
			|
			|////////////////////////////////////////////////////////////////////////////////
			|ВЫБРАТЬ
			|	Окна.Период КАК Период,
			|	КОЛИЧЕСТВО(РАЗЛИЧНЫЕ Окна.Период1) КАК Количество
			|ПОМЕСТИТЬ Макси
			|ИЗ
			|	Окна КАК Окна
			|		ВНУТРЕННЕЕ СОЕДИНЕНИЕ РегистрНакопления.ТурнирнаяТаблица КАК ТурнирнаяТаблица
			|		ПО (ТурнирнаяТаблица.Период МЕЖДУ Окна.Период1 И Окна.Период)
			|
			|СГРУППИРОВАТЬ ПО
			|	Окна.Период
			|
			|ИМЕЮЩИЕ
			|	КОЛИЧЕСТВО(РАЗЛИЧНЫЕ Окна.Период1) >= 3
			|;
			|
			|////////////////////////////////////////////////////////////////////////////////
			|ВЫБРАТЬ РАЗЛИЧНЫЕ
			|	Окна.Период КАК Период,
			|	Макси.Количество КАК КоличествоЗабито
			|ИЗ
			|	Окна КАК Окна
			|		ВНУТРЕННЕЕ СОЕДИНЕНИЕ Макси КАК Макси
			|		ПО Окна.Период = Макси.Период
			|		ЛЕВОЕ СОЕДИНЕНИЕ РегистрНакопления.ТурнирнаяТаблица КАК ТурнирнаяТаблица
			|		ПО (ТурнирнаяТаблица.Период МЕЖДУ Окна.Период И Окна.Период1)
			|ГДЕ
			|	ВЫБОР
			|			КОГДА Окна.Период = Окна.Период1
			|				ТОГДА ИСТИНА
			|			ИНАЧЕ ТурнирнаяТаблица.Период ЕСТЬ NULL
			|		КОНЕЦ
			|
			|УПОРЯДОЧИТЬ ПО
			|	Период";
		ИначеЕсли ТипГрафика = 4 Тогда
			Запрос.Текст = 
			"ВЫБРАТЬ
			|	ТурнирнаяТаблица.Период КАК Период,
			|	ТурнирнаяТаблица.КоличествоОчков КАК КоличествоОчков
			|ПОМЕСТИТЬ ТурнирнаяТаблица
			|ИЗ
			|	РегистрНакопления.ТурнирнаяТаблица КАК ТурнирнаяТаблица
			|ГДЕ
			|	ТурнирнаяТаблица.Команда = &Команда
			|	И ТурнирнаяТаблица.Регистратор ССЫЛКА Документ.Матч
			|	И ТурнирнаяТаблица.Тур.Владелец = &Чемпионат
			|;
			|
			|////////////////////////////////////////////////////////////////////////////////
			|ВЫБРАТЬ РАЗЛИЧНЫЕ
			|	ТурнирнаяТаблица.Период КАК Период,
			|	ЕСТЬNULL(ТурнирнаяТаблица1.Период, ТурнирнаяТаблица.Период) КАК Период1
			|ПОМЕСТИТЬ Комбинации
			|ИЗ
			|	ТурнирнаяТаблица КАК ТурнирнаяТаблица
			|		ЛЕВОЕ СОЕДИНЕНИЕ ТурнирнаяТаблица КАК ТурнирнаяТаблица1
			|		ПО ТурнирнаяТаблица.Период >= ТурнирнаяТаблица1.Период
			|			И (ТурнирнаяТаблица1.КоличествоОчков >= 2)
			|ГДЕ
			|	ТурнирнаяТаблица.КоличествоОчков >= 2
			|;
			|
			|////////////////////////////////////////////////////////////////////////////////
			|ВЫБРАТЬ
			|	Комбинации.Период1 КАК Период1,
			|	МАКСИМУМ(Комбинации.Период) КАК Период
			|ПОМЕСТИТЬ Окна
			|ИЗ
			|	Комбинации КАК Комбинации
			|		ЛЕВОЕ СОЕДИНЕНИЕ ТурнирнаяТаблица КАК ТурнирнаяТаблица
			|		ПО (ТурнирнаяТаблица.Период МЕЖДУ Комбинации.Период1 И Комбинации.Период)
			|			И (ТурнирнаяТаблица.КоличествоОчков <= 2)
			|ГДЕ
			|	ВЫБОР
			|			КОГДА Комбинации.Период = Комбинации.Период1
			|				ТОГДА ИСТИНА
			|			ИНАЧЕ ТурнирнаяТаблица.Период ЕСТЬ NULL
			|		КОНЕЦ
			|
			|СГРУППИРОВАТЬ ПО
			|	Комбинации.Период1
			|;
			|
			|////////////////////////////////////////////////////////////////////////////////
			|ВЫБРАТЬ
			|	Окна.Период КАК Период,
			|	КОЛИЧЕСТВО(РАЗЛИЧНЫЕ Окна.Период1) КАК Количество
			|ПОМЕСТИТЬ Макси
			|ИЗ
			|	Окна КАК Окна
			|		ВНУТРЕННЕЕ СОЕДИНЕНИЕ РегистрНакопления.ТурнирнаяТаблица КАК ТурнирнаяТаблица
			|		ПО (ТурнирнаяТаблица.Период МЕЖДУ Окна.Период1 И Окна.Период)
			|
			|СГРУППИРОВАТЬ ПО
			|	Окна.Период
			|
			|ИМЕЮЩИЕ
			|	КОЛИЧЕСТВО(РАЗЛИЧНЫЕ Окна.Период1) >= 4
			|;
			|
			|////////////////////////////////////////////////////////////////////////////////
			|ВЫБРАТЬ РАЗЛИЧНЫЕ
			|	Окна.Период КАК Период,
			|	Макси.Количество КАК КоличествоЗабито
			|ИЗ
			|	Окна КАК Окна
			|		ВНУТРЕННЕЕ СОЕДИНЕНИЕ Макси КАК Макси
			|		ПО Окна.Период = Макси.Период
			|		ЛЕВОЕ СОЕДИНЕНИЕ РегистрНакопления.ТурнирнаяТаблица КАК ТурнирнаяТаблица
			|		ПО (ТурнирнаяТаблица.Период МЕЖДУ Окна.Период И Окна.Период1)
			|ГДЕ
			|	ВЫБОР
			|			КОГДА Окна.Период = Окна.Период1
			|				ТОГДА ИСТИНА
			|			ИНАЧЕ ТурнирнаяТаблица.Период ЕСТЬ NULL
			|		КОНЕЦ
			|
			|УПОРЯДОЧИТЬ ПО
			|	Период";
		ИначеЕсли ТипГрафика = 3 Тогда
			Запрос.Текст = 
			"ВЫБРАТЬ
			|	ТурнирнаяТаблица.Период КАК Период,
			|	ТурнирнаяТаблица.КоличествоОчков КАК КоличествоОчков
			|ПОМЕСТИТЬ ТурнирнаяТаблица
			|ИЗ
			|	РегистрНакопления.ТурнирнаяТаблица КАК ТурнирнаяТаблица
			|ГДЕ
			|	ТурнирнаяТаблица.Команда = &Команда
			|	И ТурнирнаяТаблица.Регистратор ССЫЛКА Документ.Матч
			|	И ТурнирнаяТаблица.Тур.Владелец = &Чемпионат
			|;
			|
			|////////////////////////////////////////////////////////////////////////////////
			|ВЫБРАТЬ РАЗЛИЧНЫЕ
			|	ТурнирнаяТаблица.Период КАК Период,
			|	ЕСТЬNULL(ТурнирнаяТаблица1.Период, ТурнирнаяТаблица.Период) КАК Период1
			|ПОМЕСТИТЬ Комбинации
			|ИЗ
			|	ТурнирнаяТаблица КАК ТурнирнаяТаблица
			|		ЛЕВОЕ СОЕДИНЕНИЕ ТурнирнаяТаблица КАК ТурнирнаяТаблица1
			|		ПО ТурнирнаяТаблица.Период >= ТурнирнаяТаблица1.Период
			|			И (ТурнирнаяТаблица1.КоличествоОчков >= 1)
			|ГДЕ
			|	ТурнирнаяТаблица.КоличествоОчков >= 1
			|;
			|
			|////////////////////////////////////////////////////////////////////////////////
			|ВЫБРАТЬ
			|	Комбинации.Период1 КАК Период1,
			|	МАКСИМУМ(Комбинации.Период) КАК Период
			|ПОМЕСТИТЬ Окна
			|ИЗ
			|	Комбинации КАК Комбинации
			|		ЛЕВОЕ СОЕДИНЕНИЕ ТурнирнаяТаблица КАК ТурнирнаяТаблица
			|		ПО (ТурнирнаяТаблица.КоличествоОчков = 0)
			|			И (ТурнирнаяТаблица.Период МЕЖДУ Комбинации.Период1 И Комбинации.Период)
			|ГДЕ
			|	ВЫБОР
			|			КОГДА Комбинации.Период = Комбинации.Период1
			|				ТОГДА ИСТИНА
			|			ИНАЧЕ ТурнирнаяТаблица.Период ЕСТЬ NULL
			|		КОНЕЦ
			|
			|СГРУППИРОВАТЬ ПО
			|	Комбинации.Период1
			|;
			|
			|////////////////////////////////////////////////////////////////////////////////
			|ВЫБРАТЬ
			|	Окна.Период КАК Период,
			|	КОЛИЧЕСТВО(РАЗЛИЧНЫЕ Окна.Период1) КАК Количество
			|ПОМЕСТИТЬ Макси
			|ИЗ
			|	Окна КАК Окна
			|		ВНУТРЕННЕЕ СОЕДИНЕНИЕ РегистрНакопления.ТурнирнаяТаблица КАК ТурнирнаяТаблица
			|		ПО (ТурнирнаяТаблица.Период МЕЖДУ Окна.Период1 И Окна.Период)
			|
			|СГРУППИРОВАТЬ ПО
			|	Окна.Период
			|
			|ИМЕЮЩИЕ
			|	КОЛИЧЕСТВО(РАЗЛИЧНЫЕ Окна.Период1) >= 4
			|;
			|
			|////////////////////////////////////////////////////////////////////////////////
			|ВЫБРАТЬ РАЗЛИЧНЫЕ
			|	Окна.Период КАК Период,
			|	Макси.Количество КАК КоличествоЗабито
			|ИЗ
			|	Окна КАК Окна
			|		ВНУТРЕННЕЕ СОЕДИНЕНИЕ Макси КАК Макси
			|		ПО Окна.Период = Макси.Период
			|		ЛЕВОЕ СОЕДИНЕНИЕ РегистрНакопления.ТурнирнаяТаблица КАК ТурнирнаяТаблица
			|		ПО (ТурнирнаяТаблица.Период МЕЖДУ Окна.Период И Окна.Период1)
			|ГДЕ
			|	ВЫБОР
			|			КОГДА Окна.Период = Окна.Период1
			|				ТОГДА ИСТИНА
			|			ИНАЧЕ ТурнирнаяТаблица.Период ЕСТЬ NULL
			|		КОНЕЦ
			|
			|УПОРЯДОЧИТЬ ПО
			|	Период";
			
		ИначеЕсли ТипГрафика = 0 Тогда
			Запрос.Текст = 
			"ВЫБРАТЬ
			|	ТурнирнаяТаблица.Период КАК Период,
			|	Туры.Код КАК Код,
			|	ВЫБОР
			|		КОГДА ЦЕЛ(Туры.Код / 10) * 10 = Туры.Код
			|			ТОГДА Туры.Наименование
			|		КОГДА Туры.Код = 1
			|			ТОГДА Туры.Наименование
			|		ИНАЧЕ Туры.Код
			|	КОНЕЦ КАК Подсказка,
			|	ТурнирнаяТаблица.КоличествоОчков КАК КоличествоЗабито,
			|	ТурнирнаяТаблица.КоличествоОчков - 3 КАК КоличествоПропущено,
			|	ТурнирнаяТаблица.Регистратор КАК Матч
			|ИЗ
			|	РегистрНакопления.ТурнирнаяТаблица КАК ТурнирнаяТаблица
			|		ВНУТРЕННЕЕ СОЕДИНЕНИЕ Справочник.Туры КАК Туры
			|		ПО ТурнирнаяТаблица.Тур = Туры.Ссылка
			|ГДЕ
			|	ТурнирнаяТаблица.Команда = &Команда
			|	И Туры.Владелец = &Чемпионат
			|
			|УПОРЯДОЧИТЬ ПО
			|	Код";
			
		Иначе
			Запрос.Текст = 
			"ВЫБРАТЬ
			|	ТурнирнаяТаблица.Период КАК Период,
			|	Туры.Код КАК Код,
			|	ВЫБОР
			|		КОГДА ЦЕЛ(Туры.Код / 10) * 10 = Туры.Код
			|			ТОГДА Туры.Наименование
			|		КОГДА Туры.Код = 1
			|			ТОГДА Туры.Наименование
			|		ИНАЧЕ Туры.Код
			|	КОНЕЦ КАК Подсказка,
			|	ТурнирнаяТаблица.Регистратор КАК Матч,
			|	ТурнирнаяТаблица.КоличествоГолов КАК КоличествоЗабито,
			|	Противник.КоличествоГолов КАК КоличествоПропущено
			|ИЗ
			|	РегистрНакопления.ТурнирнаяТаблица КАК ТурнирнаяТаблица
			|		ВНУТРЕННЕЕ СОЕДИНЕНИЕ РегистрНакопления.ТурнирнаяТаблица КАК Противник
			|		ПО ТурнирнаяТаблица.Регистратор = Противник.Регистратор
			|		ВНУТРЕННЕЕ СОЕДИНЕНИЕ Справочник.Туры КАК Туры
			|		ПО ТурнирнаяТаблица.Тур = Туры.Ссылка
			|ГДЕ
			|	ТурнирнаяТаблица.Команда = &Команда
			|	И Туры.Владелец = &Чемпионат
			|	И Противник.Команда <> &Команда
			|
			|УПОРЯДОЧИТЬ ПО
			|	Код";
		КонецЕсли;

	ИначеЕсли ТипГрафика = 7 Тогда
			Запрос.Текст = 
			"ВЫБРАТЬ
			|	ТурнирнаяТаблица.Команда КАК Команда,
			|	СУММА(1) КАК КоличествоЗабито
			|ИЗ
			|	РегистрНакопления.ТурнирнаяТаблица КАК ТурнирнаяТаблица
			|		ВНУТРЕННЕЕ СОЕДИНЕНИЕ РегистрНакопления.ТурнирнаяТаблица КАК ТурнирнаяТаблица1
			|		ПО ТурнирнаяТаблица.Регистратор = ТурнирнаяТаблица1.Регистратор
			|			И ТурнирнаяТаблица.Команда <> ТурнирнаяТаблица1.Команда
			|ГДЕ
			|	ТурнирнаяТаблица.Тур.Владелец = &Чемпионат
			|	И ТурнирнаяТаблица1.КоличествоГолов = 0
			|	И ТурнирнаяТаблица.КоличествоОчков >= 2
			|
			|СГРУППИРОВАТЬ ПО
			|	ТурнирнаяТаблица.Команда
			|
			|УПОРЯДОЧИТЬ ПО
			|	КоличествоЗабито УБЫВ,
			|	Команда
			|АВТОУПОРЯДОЧИВАНИЕ";
	ИначеЕсли ТипГрафика = 6 Тогда
			Запрос.Текст = 
			"ВЫБРАТЬ
			|	ТурнирнаяТаблица.Команда КАК Команда,
			|	СУММА(1) КАК КоличествоЗабито
			|ИЗ
			|	РегистрНакопления.ТурнирнаяТаблица КАК ТурнирнаяТаблица
			|		ВНУТРЕННЕЕ СОЕДИНЕНИЕ РегистрНакопления.ТурнирнаяТаблица КАК ТурнирнаяТаблица1
			|		ПО ТурнирнаяТаблица.Регистратор = ТурнирнаяТаблица1.Регистратор
			|			И ТурнирнаяТаблица.Команда <> ТурнирнаяТаблица1.Команда
			|ГДЕ
			|	ТурнирнаяТаблица.Тур.Владелец = &Чемпионат
			|	И ТурнирнаяТаблица1.КоличествоГолов = 0
			|
			|СГРУППИРОВАТЬ ПО
			|	ТурнирнаяТаблица.Команда
			|
			|УПОРЯДОЧИТЬ ПО
			|	КоличествоЗабито УБЫВ,
			|	Команда
			|АВТОУПОРЯДОЧИВАНИЕ";
	ИначеЕсли ТипГрафика = 5 Тогда
		Запрос.Текст = 
			"ВЫБРАТЬ
			|	ТурнирнаяТаблица.Период КАК Период,
			|	ТурнирнаяТаблица.Команда КАК Команда,
			|	ТурнирнаяТаблица.КоличествоОчков КАК КоличествоОчков,
			|	ТурнирнаяТаблица1.КоличествоГолов КАК КоличествоГолов
			|ПОМЕСТИТЬ ТурнирнаяТаблица
			|ИЗ
			|	РегистрНакопления.ТурнирнаяТаблица КАК ТурнирнаяТаблица
			|		ВНУТРЕННЕЕ СОЕДИНЕНИЕ РегистрНакопления.ТурнирнаяТаблица КАК ТурнирнаяТаблица1
			|		ПО ТурнирнаяТаблица.Регистратор = ТурнирнаяТаблица1.Регистратор
			|			И ТурнирнаяТаблица.Команда <> ТурнирнаяТаблица1.Команда
			|ГДЕ
			|	ТурнирнаяТаблица.Тур.Владелец = &Чемпионат
			|;
			|
			|////////////////////////////////////////////////////////////////////////////////
			|ВЫБРАТЬ РАЗЛИЧНЫЕ
			|	ТурнирнаяТаблица.Период КАК Период,
			|	ЕСТЬNULL(ТурнирнаяТаблица1.Период, ТурнирнаяТаблица.Период) КАК Период1,
			|	ТурнирнаяТаблица.Команда КАК Команда
			|ПОМЕСТИТЬ Комбинации
			|ИЗ
			|	ТурнирнаяТаблица КАК ТурнирнаяТаблица
			|		ЛЕВОЕ СОЕДИНЕНИЕ ТурнирнаяТаблица КАК ТурнирнаяТаблица1
			|		ПО ТурнирнаяТаблица.Команда = ТурнирнаяТаблица1.Команда
			|			И ТурнирнаяТаблица.Период >= ТурнирнаяТаблица1.Период
			|			И (ТурнирнаяТаблица1.КоличествоГолов = 0)
			|ГДЕ
			|	ТурнирнаяТаблица.КоличествоОчков >= 1
			|;
			|
			|////////////////////////////////////////////////////////////////////////////////
			|ВЫБРАТЬ
			|	Комбинации.Команда КАК Команда,
			|	Комбинации.Период1 КАК Период1,
			|	МАКСИМУМ(Комбинации.Период) КАК Период
			|ПОМЕСТИТЬ Окна
			|ИЗ
			|	Комбинации КАК Комбинации
			|		ЛЕВОЕ СОЕДИНЕНИЕ ТурнирнаяТаблица КАК ТурнирнаяТаблица
			|		ПО Комбинации.Команда = ТурнирнаяТаблица.Команда
			|			И (ТурнирнаяТаблица.Период МЕЖДУ Комбинации.Период1 И Комбинации.Период)
			|			И (ТурнирнаяТаблица.КоличествоГолов >= 1)
			|ГДЕ
			|	ВЫБОР
			|			КОГДА Комбинации.Период = Комбинации.Период1
			|				ТОГДА ИСТИНА
			|			ИНАЧЕ ТурнирнаяТаблица.Период ЕСТЬ NULL
			|		КОНЕЦ
			|
			|СГРУППИРОВАТЬ ПО
			|	Комбинации.Команда,
			|	Комбинации.Период1
			|;
			|
			|////////////////////////////////////////////////////////////////////////////////
			|ВЫБРАТЬ
			|	Окна.Период КАК Период,
			|	КОЛИЧЕСТВО(РАЗЛИЧНЫЕ Окна.Период1) КАК Количество,
			|	Окна.Команда КАК Команда
			|ПОМЕСТИТЬ Макси
			|ИЗ
			|	Окна КАК Окна
			|		ВНУТРЕННЕЕ СОЕДИНЕНИЕ ТурнирнаяТаблица КАК ТурнирнаяТаблица
			|		ПО Окна.Команда = ТурнирнаяТаблица.Команда
			|			И (ТурнирнаяТаблица.Период МЕЖДУ Окна.Период1 И Окна.Период)
			|
			|СГРУППИРОВАТЬ ПО
			|	Окна.Период,
			|	Окна.Команда
			|
			|ИМЕЮЩИЕ
			|	КОЛИЧЕСТВО(РАЗЛИЧНЫЕ Окна.Период1) >= 3
			|;
			|
			|////////////////////////////////////////////////////////////////////////////////
			|ВЫБРАТЬ
			|	МАКСИМУМ(Макси.Количество) КАК КоличествоЗабито,
			|	МАКСИМУМ(Окна.Период) КАК Период,
			|	Окна.Команда КАК Команда
			|ИЗ
			|	Окна КАК Окна
			|		ВНУТРЕННЕЕ СОЕДИНЕНИЕ Макси КАК Макси
			|		ПО Окна.Период = Макси.Период
			|			И Окна.Команда = Макси.Команда
			|		ЛЕВОЕ СОЕДИНЕНИЕ ТурнирнаяТаблица КАК ТурнирнаяТаблица
			|		ПО Окна.Команда = ТурнирнаяТаблица.Команда
			|			И (ТурнирнаяТаблица.Период МЕЖДУ Окна.Период И Окна.Период1)
			|ГДЕ
			|	ВЫБОР
			|			КОГДА Окна.Период = Окна.Период1
			|				ТОГДА ИСТИНА
			|			ИНАЧЕ ТурнирнаяТаблица.Период ЕСТЬ NULL
			|		КОНЕЦ
			|
			|СГРУППИРОВАТЬ ПО
			|	Окна.Команда
			|
			|УПОРЯДОЧИТЬ ПО
			|	КоличествоЗабито УБЫВ,
			|	Команда
			|АВТОУПОРЯДОЧИВАНИЕ";
	ИначеЕсли ТипГрафика = 4 Тогда
		Запрос.Текст = 
			"ВЫБРАТЬ
			|	ТурнирнаяТаблица.Период КАК Период,
			|	ТурнирнаяТаблица.Команда КАК Команда,
			|	ТурнирнаяТаблица.КоличествоОчков КАК КоличествоОчков
			|ПОМЕСТИТЬ ТурнирнаяТаблица
			|ИЗ
			|	РегистрНакопления.ТурнирнаяТаблица КАК ТурнирнаяТаблица
			|ГДЕ
			|	ТурнирнаяТаблица.Тур.Владелец = &Чемпионат
			|	И ТурнирнаяТаблица.Регистратор ССЫЛКА Документ.Матч
			|;
			|
			|////////////////////////////////////////////////////////////////////////////////
			|ВЫБРАТЬ РАЗЛИЧНЫЕ
			|	ТурнирнаяТаблица.Период КАК Период,
			|	ЕСТЬNULL(ТурнирнаяТаблица1.Период, ТурнирнаяТаблица.Период) КАК Период1,
			|	ТурнирнаяТаблица.Команда КАК Команда
			|ПОМЕСТИТЬ Комбинации
			|ИЗ
			|	ТурнирнаяТаблица КАК ТурнирнаяТаблица
			|		ЛЕВОЕ СОЕДИНЕНИЕ ТурнирнаяТаблица КАК ТурнирнаяТаблица1
			|		ПО ТурнирнаяТаблица.Команда = ТурнирнаяТаблица1.Команда
			|			И ТурнирнаяТаблица.Период >= ТурнирнаяТаблица1.Период
			|			И (ТурнирнаяТаблица1.КоличествоОчков >= 2)
			|ГДЕ
			|	ТурнирнаяТаблица.КоличествоОчков >= 2
			|;
			|
			|////////////////////////////////////////////////////////////////////////////////
			|ВЫБРАТЬ
			|	Комбинации.Команда КАК Команда,
			|	Комбинации.Период1 КАК Период1,
			|	МАКСИМУМ(Комбинации.Период) КАК Период
			|ПОМЕСТИТЬ Окна
			|ИЗ
			|	Комбинации КАК Комбинации
			|		ЛЕВОЕ СОЕДИНЕНИЕ ТурнирнаяТаблица КАК ТурнирнаяТаблица
			|		ПО Комбинации.Команда = ТурнирнаяТаблица.Команда
			|			И (ТурнирнаяТаблица.Период МЕЖДУ Комбинации.Период1 И Комбинации.Период)
			|			И (ТурнирнаяТаблица.КоличествоОчков <= 2)
			|ГДЕ
			|	ВЫБОР
			|			КОГДА Комбинации.Период = Комбинации.Период1
			|				ТОГДА ИСТИНА
			|			ИНАЧЕ ТурнирнаяТаблица.Период ЕСТЬ NULL
			|		КОНЕЦ
			|
			|СГРУППИРОВАТЬ ПО
			|	Комбинации.Команда,
			|	Комбинации.Период1
			|;
			|
			|////////////////////////////////////////////////////////////////////////////////
			|ВЫБРАТЬ
			|	Окна.Период КАК Период,
			|	КОЛИЧЕСТВО(РАЗЛИЧНЫЕ Окна.Период1) КАК Количество,
			|	Окна.Команда КАК Команда
			|ПОМЕСТИТЬ Макси
			|ИЗ
			|	Окна КАК Окна
			|		ВНУТРЕННЕЕ СОЕДИНЕНИЕ ТурнирнаяТаблица КАК ТурнирнаяТаблица
			|		ПО Окна.Команда = ТурнирнаяТаблица.Команда
			|			И (ТурнирнаяТаблица.Период МЕЖДУ Окна.Период1 И Окна.Период)
			|
			|СГРУППИРОВАТЬ ПО
			|	Окна.Период,
			|	Окна.Команда
			|
			|ИМЕЮЩИЕ
			|	КОЛИЧЕСТВО(РАЗЛИЧНЫЕ Окна.Период1) >= 4
			|;
			|
			|////////////////////////////////////////////////////////////////////////////////
			|ВЫБРАТЬ
			|	МАКСИМУМ(Макси.Количество) КАК КоличествоЗабито,
			|	МАКСИМУМ(Окна.Период) КАК Период,
			|	Окна.Команда КАК Команда
			|ИЗ
			|	Окна КАК Окна
			|		ВНУТРЕННЕЕ СОЕДИНЕНИЕ Макси КАК Макси
			|		ПО Окна.Период = Макси.Период
			|			И Окна.Команда = Макси.Команда
			|		ЛЕВОЕ СОЕДИНЕНИЕ ТурнирнаяТаблица КАК ТурнирнаяТаблица
			|		ПО Окна.Команда = ТурнирнаяТаблица.Команда
			|			И (ТурнирнаяТаблица.Период МЕЖДУ Окна.Период И Окна.Период1)
			|ГДЕ
			|	ВЫБОР
			|			КОГДА Окна.Период = Окна.Период1
			|				ТОГДА ИСТИНА
			|			ИНАЧЕ ТурнирнаяТаблица.Период ЕСТЬ NULL
			|		КОНЕЦ
			|
			|СГРУППИРОВАТЬ ПО
			|	Окна.Команда
			|
			|УПОРЯДОЧИТЬ ПО
			|	КоличествоЗабито УБЫВ,
			|	Команда
			|АВТОУПОРЯДОЧИВАНИЕ";
	ИначеЕсли ТипГрафика = 3 Тогда
		Запрос.Текст = 
			"ВЫБРАТЬ
			|	ТурнирнаяТаблица.Период КАК Период,
			|	ТурнирнаяТаблица.Команда КАК Команда,
			|	ТурнирнаяТаблица.КоличествоОчков КАК КоличествоОчков
			|ПОМЕСТИТЬ ТурнирнаяТаблица
			|ИЗ
			|	РегистрНакопления.ТурнирнаяТаблица КАК ТурнирнаяТаблица
			|ГДЕ
			|	ТурнирнаяТаблица.Тур.Владелец = &Чемпионат
			|	И ТурнирнаяТаблица.Регистратор ССЫЛКА Документ.Матч
			|;
			|
			|////////////////////////////////////////////////////////////////////////////////
			|ВЫБРАТЬ РАЗЛИЧНЫЕ
			|	ТурнирнаяТаблица.Период КАК Период,
			|	ЕСТЬNULL(ТурнирнаяТаблица1.Период, ТурнирнаяТаблица.Период) КАК Период1,
			|	ТурнирнаяТаблица.Команда КАК Команда
			|ПОМЕСТИТЬ Комбинации
			|ИЗ
			|	ТурнирнаяТаблица КАК ТурнирнаяТаблица
			|		ЛЕВОЕ СОЕДИНЕНИЕ ТурнирнаяТаблица КАК ТурнирнаяТаблица1
			|		ПО ТурнирнаяТаблица.Команда = ТурнирнаяТаблица1.Команда
			|			И ТурнирнаяТаблица.Период >= ТурнирнаяТаблица1.Период
			|			И (ТурнирнаяТаблица1.КоличествоОчков >= 1)
			|ГДЕ
			|	ТурнирнаяТаблица.КоличествоОчков >= 1
			|;
			|
			|////////////////////////////////////////////////////////////////////////////////
			|ВЫБРАТЬ
			|	Комбинации.Команда КАК Команда,
			|	Комбинации.Период1 КАК Период1,
			|	МАКСИМУМ(Комбинации.Период) КАК Период
			|ПОМЕСТИТЬ Окна
			|ИЗ
			|	Комбинации КАК Комбинации
			|		ЛЕВОЕ СОЕДИНЕНИЕ ТурнирнаяТаблица КАК ТурнирнаяТаблица
			|		ПО Комбинации.Команда = ТурнирнаяТаблица.Команда
			|			И (ТурнирнаяТаблица.КоличествоОчков = 0)
			|			И (ТурнирнаяТаблица.Период МЕЖДУ Комбинации.Период1 И Комбинации.Период)
			|ГДЕ
			|	ВЫБОР
			|			КОГДА Комбинации.Период = Комбинации.Период1
			|				ТОГДА ИСТИНА
			|			ИНАЧЕ ТурнирнаяТаблица.Период ЕСТЬ NULL
			|		КОНЕЦ
			|
			|СГРУППИРОВАТЬ ПО
			|	Комбинации.Команда,
			|	Комбинации.Период1
			|;
			|
			|////////////////////////////////////////////////////////////////////////////////
			|ВЫБРАТЬ
			|	Окна.Период КАК Период,
			|	КОЛИЧЕСТВО(РАЗЛИЧНЫЕ Окна.Период1) КАК Количество,
			|	Окна.Команда КАК Команда
			|ПОМЕСТИТЬ Макси
			|ИЗ
			|	Окна КАК Окна
			|		ВНУТРЕННЕЕ СОЕДИНЕНИЕ ТурнирнаяТаблица КАК ТурнирнаяТаблица
			|		ПО Окна.Команда = ТурнирнаяТаблица.Команда
			|			И (ТурнирнаяТаблица.Период МЕЖДУ Окна.Период1 И Окна.Период)
			|
			|СГРУППИРОВАТЬ ПО
			|	Окна.Период,
			|	Окна.Команда
			|
			|ИМЕЮЩИЕ
			|	КОЛИЧЕСТВО(РАЗЛИЧНЫЕ Окна.Период1) >= 4
			|;
			|
			|////////////////////////////////////////////////////////////////////////////////
			|ВЫБРАТЬ
			|	МАКСИМУМ(Окна.Период) КАК Период,
			|	МАКСИМУМ(Макси.Количество) КАК КоличествоЗабито,
			|	Окна.Команда КАК Команда
			|ИЗ
			|	Окна КАК Окна
			|		ВНУТРЕННЕЕ СОЕДИНЕНИЕ Макси КАК Макси
			|		ПО Окна.Период = Макси.Период
			|			И Окна.Команда = Макси.Команда
			|		ЛЕВОЕ СОЕДИНЕНИЕ ТурнирнаяТаблица КАК ТурнирнаяТаблица
			|		ПО Окна.Команда = ТурнирнаяТаблица.Команда
			|			И (ТурнирнаяТаблица.Период МЕЖДУ Окна.Период И Окна.Период1)
			|ГДЕ
			|	ВЫБОР
			|			КОГДА Окна.Период = Окна.Период1
			|				ТОГДА ИСТИНА
			|			ИНАЧЕ ТурнирнаяТаблица.Период ЕСТЬ NULL
			|		КОНЕЦ
			|
			|СГРУППИРОВАТЬ ПО
			|	Окна.Команда
			|
			|УПОРЯДОЧИТЬ ПО
			|	КоличествоЗабито УБЫВ,
			|	Команда
			|АВТОУПОРЯДОЧИВАНИЕ";
	ИначеЕсли ТипГрафика = 2 Тогда
		Запрос.Текст = 
			"ВЫБРАТЬ
			|	Туры.Код КАК Код,
			|	ВЫБОР
			|		КОГДА ЦЕЛ(Туры.Код / 10) * 10 = Туры.Код
			|			ТОГДА Туры.Наименование
			|		КОГДА Туры.Код = 1
			|			ТОГДА Туры.Наименование
			|		ИНАЧЕ Туры.Код
			|	КОНЕЦ КАК Подсказка,
			|	СУММА(ТурнирнаяТаблица.КоличествоГолов) КАК КоличествоЗабито,
			|	КОЛИЧЕСТВО(РАЗЛИЧНЫЕ ТурнирнаяТаблица.Регистратор) КАК КоличествоПропущено
			|ИЗ
			|	РегистрНакопления.ТурнирнаяТаблица КАК ТурнирнаяТаблица
			|		ВНУТРЕННЕЕ СОЕДИНЕНИЕ Справочник.Туры КАК Туры
			|		ПО ТурнирнаяТаблица.Тур = Туры.Ссылка
			|ГДЕ
			|	Туры.Владелец = &Чемпионат
			|	И ТурнирнаяТаблица.Регистратор ССЫЛКА Документ.Матч
			|
			|СГРУППИРОВАТЬ ПО
			|	Туры.Код,
			|	ВЫБОР
			|		КОГДА ЦЕЛ(Туры.Код / 10) * 10 = Туры.Код
			|			ТОГДА Туры.Наименование
			|		КОГДА Туры.Код = 1
			|			ТОГДА Туры.Наименование
			|		ИНАЧЕ Туры.Код
			|	КОНЕЦ
			|
			|УПОРЯДОЧИТЬ ПО
			|	Код";
	Иначе
		Запрос.Текст = 
			"ВЫБРАТЬ ПЕРВЫЕ 5
			|	ТурнирнаяТаблица.Команда КАК Команда,
			|	АВТОНОМЕРЗАПИСИ() КАК Порядок
			|ПОМЕСТИТЬ Топ5
			|ИЗ
			|	РегистрНакопления.ТурнирнаяТаблица КАК ТурнирнаяТаблица
			|ГДЕ
			|	ТурнирнаяТаблица.Тур.Владелец = &Чемпионат
			|
			|СГРУППИРОВАТЬ ПО
			|	ТурнирнаяТаблица.Команда
			|
			|УПОРЯДОЧИТЬ ПО
			|	СУММА(ТурнирнаяТаблица.КоличествоОчков) УБЫВ,
			|	СУММА(ТурнирнаяТаблица.КоличествоГолов) УБЫВ
			|;
			|
			|////////////////////////////////////////////////////////////////////////////////
			|ВЫБРАТЬ
			|	ТТ.Команда КАК Команда,
			|	ТТ.КоличествоОчков КАК КоличествоПропущено,
			|	ТТ.КоличествоГолов КАК КоличествоЗабито,
			|	ТТ.Регистратор КАК Матч,
			|	Туры.Код КАК Код,
			|	ВЫБОР
			|		КОГДА ЦЕЛ(Туры.Код / 10) * 10 = Туры.Код
			|			ТОГДА Туры.Наименование
			|		КОГДА Туры.Код = 1
			|			ТОГДА Туры.Наименование
			|		ИНАЧЕ Туры.Код
			|	КОНЕЦ КАК Подсказка
			|ИЗ
			|	РегистрНакопления.ТурнирнаяТаблица КАК ТТ
			|		ВНУТРЕННЕЕ СОЕДИНЕНИЕ Справочник.Туры КАК Туры
			|		ПО ТТ.Тур = Туры.Ссылка
			|		ВНУТРЕННЕЕ СОЕДИНЕНИЕ Топ5 КАК Топ5
			|		ПО ТТ.Команда = Топ5.Команда
			|ГДЕ
			|	Туры.Владелец = &Чемпионат
			|	И ТТ.Регистратор Ссылка Документ.Матч
			|
			|УПОРЯДОЧИТЬ ПО
			|	Код,
			|	Топ5.Порядок
			|ИТОГИ ПО
			|	Команда";
	КонецЕсли;
	
	Детали	= Запрос.Выполнить().Выбрать();
	Пока Детали.Следующий() Цикл
		ЗаполнитьЗначенияСвойств(Отчет.Данные.Добавить(), Детали);
	КонецЦикла;
КонецПроцедуры

&НаСервере
Процедура ГрафикОбновить()
	ГрафикОбновитьНаСервере();
	
	График.Очистить();
	График.ТипДиаграммы	= ?(ТипГрафика > 2, ТипДиаграммы.Гистограмма, ТипДиаграммы.График);
	Если ЗначениеЗаполнено(Отчет.Команда) Тогда
		Если ТипГрафика = 6 Тогда
			СерияЗабито		= График.УстановитьСерию("Забито");
			СерияПропущено	= График.УстановитьСерию("Пропущено");
			Для Каждого Детали Из Отчет.Данные Цикл
				Точка			= УстановитьТочку(Детали.Период);
				График.УстановитьЗначение(Точка, СерияЗабито, Детали.КоличествоЗабито, Детали.Матч, Детали.Подсказка);
				График.УстановитьЗначение(Точка, СерияПропущено, Детали.КоличествоПропущено, Детали.Матч, Детали.Подсказка);
			КонецЦикла;
			
		ИначеЕсли ТипГрафика = 2 Тогда
			СерияЗабито		= График.УстановитьСерию("Забито");
			СерияПропущено	= График.УстановитьСерию("Пропущено");
			Забито	= 0;
			Пропущено=0;
			Для Каждого Детали Из Отчет.Данные Цикл
				Забито		= Забито + Детали.КоличествоЗабито;
				Пропущено	= Пропущено + Детали.КоличествоПропущено;
				Если Детали.НомерСтроки > 1 Тогда
					Точка	= УстановитьТочку(Детали.Подсказка, Детали.Матч);
					График.УстановитьЗначение(Точка, СерияЗабито, Окр(Забито / Детали.НомерСтроки, 1), Детали.Матч);
					График.УстановитьЗначение(Точка, СерияПропущено, Окр(Пропущено / Детали.НомерСтроки, 1), Детали.Матч);
				КонецЕсли;
			КонецЦикла;
			
		ИначеЕсли ТипГрафика = 1 Тогда
			Для Итератор = 0 По 1 Цикл
				Итого	= 0;
				Если Итератор = 0 Тогда
					Серия	= УстановитьСерию(Отчет.Команда);
					Серия.Текст = "Забито";
				Иначе
					Серия	= График.УстановитьСерию("Пропущено");
				КонецЕсли;
				Для Каждого Детали Из Отчет.Данные Цикл
					Точка	= УстановитьТочку(Детали.Подсказка, Детали.Матч);
					Итого = Итого + ?(Итератор = 0, Детали.КоличествоЗабито, Детали.КоличествоПропущено);
					Если ?(Итератор = 0, Детали.КоличествоЗабито = 0, Детали.КоличествоПропущено = 0) Тогда
						График.УстановитьЗначение(Точка, Серия, Итого, Детали.Матч);
					Иначе
						График.УстановитьЗначение(Точка, Серия, Итого, Детали.Матч);
					КонецЕсли;
				КонецЦикла;
			КонецЦикла;
			
		ИначеЕсли ТипГрафика = 0 Тогда
			Итого	= Новый Структура("КоличествоЗабито,КоличествоПропущено", 0, 0);
			Серия	= УстановитьСерию(Отчет.Команда);
			Серия.Текст = "Набрано";
			Для Каждого Детали Из Отчет.Данные Цикл
				Точка	= УстановитьТочку(Детали.Подсказка, Детали.Матч);
				Итого.КоличествоЗабито		= Итого.КоличествоЗабито + Детали.КоличествоЗабито;
				Итого.КоличествоПропущено	= Итого.КоличествоПропущено + Детали.КоличествоПропущено;
				График.УстановитьЗначение(Точка, Серия, Итого.КоличествоЗабито, Детали.Матч);
				График.УстановитьЗначение(Точка, График.УстановитьСерию("Упущено"), Итого.КоличествоПропущено, Детали.Матч);
				//График.УстановитьЗначение(Точка, График.УстановитьСерию("В среднем"), Окр(Итого.КоличествоЗабито / График.КоличествоТочек, 1), Детали.Матч);
			КонецЦикла;
			
		Иначе
			Серия	= УстановитьСерию(Отчет.Команда);
			Для Каждого Детали Из Отчет.Данные Цикл
				Точка				= УстановитьТочку(Детали.Период, Детали.Матч);
				График.УстановитьЗначение(Точка, Серия, Детали.КоличествоЗабито, Детали.Матч);
			КонецЦикла;
		КонецЕсли;
		
	ИначеЕсли ТипГрафика > 2 Тогда
		Для Каждого Детали Из Отчет.Данные Цикл
			График.УстановитьЗначение(УстановитьТочку(Детали.КоличествоЗабито), УстановитьСерию(Детали.Команда), Детали.КоличествоЗабито);
		КонецЦикла;
		
	ИначеЕсли ТипГрафика = 2 Тогда
		СерияЗабито	= График.УстановитьСерию("Забито");
		СерияСредняя= График.УстановитьСерию("Средняя результативность");
		Для Каждого Детали Из Отчет.Данные Цикл
			Точка	= УстановитьТочку(Детали.Подсказка);
			График.УстановитьЗначение(Точка, СерияЗабито, Детали.КоличествоЗабито);
			График.УстановитьЗначение(Точка, СерияСредняя, ?(Детали.КоличествоПропущено=0, 0, Окр(Детали.КоличествоЗабито / Детали.КоличествоПропущено, 1)));
		КонецЦикла;
		
	Иначе
		Итого	= 0;
		Для Каждого Детали Из Отчет.Данные Цикл
			Если ЗначениеЗаполнено(Детали.Подсказка) Тогда
				Итого = Итого + ?(ТипГрафика = 0, Детали.КоличествоПропущено, Детали.КоличествоЗабито);
				Точка			= УстановитьТочку(Детали.Подсказка);
				График.УстановитьЗначение(Точка, Серия, Итого, Детали.Матч);
			Иначе
				Серия	= УстановитьСерию(Детали.Команда);
				Итого	= 0;
			КонецЕсли;
		КонецЦикла;
	КонецЕсли;
	График.ОбластьЛегенды.Расположение	= ?(График.Серии.Количество() = 1 И ЗначениеЗаполнено(Отчет.Команда), РасположениеЛегендыДиаграммы.Нет, РасположениеЛегендыДиаграммы.Авто);
КонецПроцедуры

&НаСервере
Функция УстановитьТочку(Значение, Расшифровка=Неопределено)
	Если ТипЗнч(Значение) = Тип("Дата") Тогда
		Точка			= График.УстановитьТочку(ФорматД(Значение));
	Иначе
		Точка			= График.УстановитьТочку(Значение);
	КонецЕсли;
	Если ЗначениеЗаполнено(Расшифровка) Тогда
		Точка.Расшифровка	= Расшифровка;
	КонецЕсли;
	Возврат Точка;
КонецФункции

&НаСервере
Функция УстановитьСерию(Команда)
	Серия	= График.УстановитьСерию(Команда);
	Цвет	= Цвет(Команда);
	Если ЗначениеЗаполнено(Цвет) Тогда
		Серия.Цвет			= Цвет;
	КонецЕсли;
	Возврат Серия;
КонецФункции

&НаСервереБезКонтекста
Функция Цвет(Команда)
	Возврат СерверныйФункции.ЦветКоманды(Команда);
КонецФункции

&НаСервере
Функция КомандыЧемпионата()
	Возврат СерверныйФункции.КомандыЧемпионата(Отчет.Чемпионат);
КонецФункции

&НаСервере
Процедура ЧемпионатПриИзмененииНаСервере()
	Элементы.Команда.СписокВыбора.ЗагрузитьЗначения(КомандыЧемпионата());
	Если ЗначениеЗаполнено(Отчет.Команда) Тогда
		Если Элементы.Команда.СписокВыбора.НайтиПоЗначению(Отчет.Команда) = Неопределено Тогда
			Отчет.Команда	= Неопределено;
		КонецЕсли;
	КонецЕсли;
	ГрафикОбновить();
КонецПроцедуры

&НаКлиенте
Процедура ЧемпионатПриИзменении(Элемент)
	ГрафикОбновить();
КонецПроцедуры

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	Если Параметры.Свойство("Чемпионат") Тогда
		Отчет.Чемпионат	= Параметры.Чемпионат;
		ОбщегоНазначения.ЗаголовокСкрыть(ЭтаФорма, Элементы.Чемпионат);
	
	ИначеЕсли Параметры.Свойство("Команда") Тогда
		Отчет.Команда	= Параметры.Команда;
		Если НЕ ЗначениеЗаполнено(Отчет.Чемпионат) Тогда
			Отчет.Чемпионат = СерверныйФункции.ЧемпионатПолучитьПоследнее(Отчет.Команда);
		КонецЕсли;
		ОбщегоНазначения.ЗаголовокСкрыть(ЭтаФорма, Элементы.Команда);
	КонецЕсли;
КонецПроцедуры

&НаКлиенте
Процедура ПриОткрытии(Отказ)
	ГрафикОбновить();
КонецПроцедуры

&НаКлиенте
Процедура ГрафикВыбор(Элемент, ЗначениеДиаграммы, СтандартнаяОбработка)
	Если ТипЗнч(ЗначениеДиаграммы.Значение) = Тип("СправочникСсылка.Команды") Тогда
		Если НЕ ЗначениеЗаполнено(Отчет.Команда) Тогда
			СтандартнаяОбработка	= Ложь;
			Отчет.Команда	= ЗначениеДиаграммы.Значение;
			ГрафикОбновить();
		КонецЕсли;
	ИначеЕсли ТипЗнч(ЗначениеДиаграммы) = Тип("ЗначениеДиаграммы") Тогда
		Если СтрНайти("3,4,5", ФорматЧГ(ТипГрафика)) > 0 Тогда
			Матчи	= МатчиПолучить(Новый Структура("Топ5,Период,Команда", ЗначениеДиаграммы.Значение, ЗначениеДиаграммы.Точка.Значение, ?(ЗначениеЗаполнено(Отчет.Команда), Отчет.Команда, ЗначениеДиаграммы.Серия.Значение)));
			Если Матчи.Количество() > 0 Тогда
				СтандартнаяОбработка	= Ложь;
				ПоказатьВыборИзСписка(Новый ОписаниеОповещения("ПослеВыбораМатча", ЭтотОбъект), Матчи);
			КонецЕсли;
		КонецЕсли;
	КонецЕсли;
КонецПроцедуры

&НаКлиенте
Процедура ПослеВыбораМатча(Элемент, ПараметрКоманды) Экспорт
	Если ТипЗнч(Элемент) = Тип("ЭлементСпискаЗначений") Тогда
		НаКлиенте.Показать(Элемент.Значение);
	КонецЕсли;
КонецПроцедуры

&НаКлиенте
Процедура ОбработкаОповещения(ИмяСобытия, Параметр, Источник)
	Если ТипЗнч(Параметр) = Тип("СправочникСсылка.Чемпионаты") И Параметр = Отчет.Чемпионат Тогда
		ГрафикОбновить();
	КонецЕсли;
КонецПроцедуры

&НаСервере
Функция МатчиПолучить(Отбор)
	Ответ	= Новый СписокЗначений;
	Если ТипЗнч(Отбор.Период) = Тип("Дата") Тогда
		Запрос	= Новый Запрос("ВЫБРАТЬ ПЕРВЫЕ 5
		      	               |	ТурнирнаяТаблица.Регистратор КАК Значение,
		      	               |	Матч.Счет КАК Представление
		      	               |ИЗ
		      	               |	РегистрНакопления.ТурнирнаяТаблица КАК ТурнирнаяТаблица
		      	               |		ВНУТРЕННЕЕ СОЕДИНЕНИЕ Документ.Матч КАК Матч
		      	               |		ПО ТурнирнаяТаблица.Регистратор = Матч.Ссылка
		      	               |ГДЕ
		      	               |	ТурнирнаяТаблица.Команда = &Команда
		      	               |	И ТурнирнаяТаблица.Период <= &Период
		      	               |	И ТурнирнаяТаблица.Тур.Владелец = &Чемпионат
		      	               |
		      	               |УПОРЯДОЧИТЬ ПО
		      	               |	ТурнирнаяТаблица.Период УБЫВ");
		Запрос.УстановитьПараметр("Период",				КонецДня(Отбор.Период));
		Запрос.УстановитьПараметр("Чемпионат",			Отчет.Чемпионат);
		Запрос.УстановитьПараметр("Команда",			Отбор.Команда);
		Запрос.Текст	= СтрЗаменить(Запрос.Текст, "5", ФорматЧГ(Отбор.Топ5));
		Ответ	= СерверныйФункции.Выборка2СписокЗначений(Запрос.Выполнить().Выбрать());
	Иначе
		Данные	= Отчет.Данные.НайтиСтроки(Новый Структура("Команда,КоличествоЗабито", Отбор.Команда, Отбор.Период));
		Для Каждого Детали Из Данные Цикл
			Если ЗначениеЗаполнено(Детали.Период) Тогда
				Отбор.Вставить("Период", Детали.Период);
				Ответ	= МатчиПолучить(Отбор);
			КонецЕсли;
		КонецЦикла;
	КонецЕсли;
	Возврат Ответ;
КонецФункции

&НаКлиенте
Процедура ТипГрафикаПриИзменении(Элемент)
	ГрафикОбновить();
КонецПроцедуры

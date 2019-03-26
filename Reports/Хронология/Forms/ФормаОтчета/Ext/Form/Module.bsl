﻿
&НаСервере
Процедура ГрафикОбновить()
	График.Очистить();
	График.ТипДиаграммы	= ?(ТипГрафика = 2, ТипДиаграммы.Гистограмма, ТипДиаграммы.График);
	
	Запрос = Новый Запрос;
	Запрос.УстановитьПараметр("Команда",		Отчет.Команда);
	Запрос.УстановитьПараметр("Чемпионат",		Отчет.Чемпионат);
	Запрос.УстановитьПараметр("Лига",			?(ТипГрафика = 2, СерверныйФункции.Лига(Отчет.Чемпионат), Неопределено));
	Если ЗначениеЗаполнено(Отчет.Команда) Тогда
		Если ТипГрафика = 2 Тогда
			Запрос.Текст = "ВЫБРАТЬ РАЗЛИЧНЫЕ
			               |	ТурнирнаяТаблица.Период КАК Период,
			               |	ЕСТЬNULL(ТурнирнаяТаблица1.Период, ТурнирнаяТаблица.Период) КАК Период1,
			               |	ТурнирнаяТаблица.Команда КАК Команда
			               |ПОМЕСТИТЬ Комбинации
			               |ИЗ
			               |	РегистрНакопления.ТурнирнаяТаблица КАК ТурнирнаяТаблица
			               |		ЛЕВОЕ СОЕДИНЕНИЕ РегистрНакопления.ТурнирнаяТаблица КАК ТурнирнаяТаблица1
			               |		ПО ТурнирнаяТаблица.Команда = ТурнирнаяТаблица1.Команда
			               |			И ТурнирнаяТаблица.Период >= ТурнирнаяТаблица1.Период
			               |			И (ТурнирнаяТаблица1.КоличествоОчков > 0)
			               |ГДЕ
			               |	ТурнирнаяТаблица.Команда = &Команда
			               |	И ТурнирнаяТаблица.КоличествоОчков > 0
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
			               |		ЛЕВОЕ СОЕДИНЕНИЕ РегистрНакопления.ТурнирнаяТаблица КАК ТурнирнаяТаблица
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
			               |		ВНУТРЕННЕЕ СОЕДИНЕНИЕ РегистрНакопления.ТурнирнаяТаблица КАК ТурнирнаяТаблица
			               |		ПО Окна.Команда = ТурнирнаяТаблица.Команда
			               |			И (ТурнирнаяТаблица.Период МЕЖДУ Окна.Период1 И Окна.Период)
			               |
			               |СГРУППИРОВАТЬ ПО
			               |	Окна.Период,
			               |	Окна.Команда
			               |
			               |ИМЕЮЩИЕ
			               |	КОЛИЧЕСТВО(РАЗЛИЧНЫЕ Окна.Период1) > 3
			               |;
			               |
			               |////////////////////////////////////////////////////////////////////////////////
			               |ВЫБРАТЬ РАЗЛИЧНЫЕ
			               |	Окна.Период КАК Период,
			               |	Макси.Количество КАК Количество
			               |ИЗ
			               |	Окна КАК Окна
			               |		ВНУТРЕННЕЕ СОЕДИНЕНИЕ Макси КАК Макси
			               |		ПО Окна.Период = Макси.Период
			               |			И Окна.Команда = Макси.Команда
			               |		ЛЕВОЕ СОЕДИНЕНИЕ РегистрНакопления.ТурнирнаяТаблица КАК ТурнирнаяТаблица
			               |		ПО Окна.Команда = ТурнирнаяТаблица.Команда
			               |			И (ТурнирнаяТаблица.Период МЕЖДУ Окна.Период И Окна.Период1)
			               |ГДЕ
			               |	ВЫБОР
			               |			КОГДА Окна.Период = Окна.Период1
			               |				ТОГДА ИСТИНА
			               |			ИНАЧЕ ТурнирнаяТаблица.Период ЕСТЬ NULL
			               |		КОНЕЦ
			               |
			               |УПОРЯДОЧИТЬ ПО
			               |	Период";
			Детали	= Запрос.Выполнить().Выбрать();
			Серия	= График.УстановитьСерию(Отчет.Команда);
			Пока Детали.Следующий() Цикл
				График.УстановитьЗначение(График.УстановитьТочку(Формат(Детали.Период, "ДФ=dd.MM")), Серия, Детали.Количество);
			КонецЦикла;
			
		ИначеЕсли ТипГрафика = 1 Тогда
			Запрос.Текст = "ВЫБРАТЬ
			               |	ТурнирнаяТаблица.Тур КАК Тур,
			               |	ТурнирнаяТаблица.КоличествоГолов КАК КоличествоЗабито,
			               |	Противник.КоличествоГолов КАК КоличествоПропущено
			               |ИЗ
			               |	РегистрНакопления.ТурнирнаяТаблица КАК ТурнирнаяТаблица
			               |		ВНУТРЕННЕЕ СОЕДИНЕНИЕ РегистрНакопления.ТурнирнаяТаблица КАК Противник
			               |		ПО ТурнирнаяТаблица.Регистратор = Противник.Регистратор
			               |ГДЕ
			               |	ТурнирнаяТаблица.Команда = &Команда
			               |	И ТурнирнаяТаблица.Тур.Владелец = &Чемпионат
			               |	И Противник.Команда <> &Команда
			               |
			               |УПОРЯДОЧИТЬ ПО
			               |	ТурнирнаяТаблица.Период";
			Детали	= Запрос.Выполнить().Выбрать();
			Для Итератор = 0 По 1 Цикл
				Итого	= 0;
				Серия	= График.УстановитьСерию(?(Итератор = 0, "Забито", "Пропущено"));
				Детали.Сбросить();
				Пока Детали.Следующий() Цикл
					Итого = Итого + ?(Итератор = 0, Детали.КоличествоЗабито, Детали.КоличествоПропущено);
					График.УстановитьЗначение(График.УстановитьТочку(Детали.Тур), Серия, Итого);
				КонецЦикла;
			КонецЦикла;
			
		Иначе
			Запрос.Текст = "ВЫБРАТЬ
			               |	ТурнирнаяТаблица.Тур КАК Тур,
			               |	ТурнирнаяТаблица.КоличествоОчков КАК КоличествоОчков
			               |ИЗ
			               |	РегистрНакопления.ТурнирнаяТаблица КАК ТурнирнаяТаблица
			               |ГДЕ
			               |	ТурнирнаяТаблица.Команда = &Команда
			               |	И ТурнирнаяТаблица.Тур.Владелец = &Чемпионат
			               |
			               |УПОРЯДОЧИТЬ ПО
			               |	ТурнирнаяТаблица.Период";
			Детали	= Запрос.Выполнить().Выбрать();
			Для Итератор = 0 По 1 Цикл
				Итого	= 0;
				Серия	= График.УстановитьСерию(?(Итератор = 0, "Набрано", "Упущено"));
				Детали.Сбросить();
				Пока Детали.Следующий() Цикл
					Итого = Итого + ?(Итератор = 0, Детали.КоличествоОчков, 3 - Детали.КоличествоОчков);
					График.УстановитьЗначение(График.УстановитьТочку(Детали.Тур), Серия, Итого);
				КонецЦикла;
			КонецЦикла;
		КонецЕсли;

	Иначе
		Если ТипГрафика = 2 Тогда
			Запрос.Текст = "ВЫБРАТЬ РАЗЛИЧНЫЕ
			               |	ТурнирнаяТаблица.Период КАК Период,
			               |	ЕСТЬNULL(ТурнирнаяТаблица1.Период, ТурнирнаяТаблица.Период) КАК Период1,
			               |	ТурнирнаяТаблица.Команда КАК Команда
			               |ПОМЕСТИТЬ Комбинации
			               |ИЗ
			               |	РегистрНакопления.ТурнирнаяТаблица КАК ТурнирнаяТаблица
			               |		ЛЕВОЕ СОЕДИНЕНИЕ РегистрНакопления.ТурнирнаяТаблица КАК ТурнирнаяТаблица1
			               |		ПО ТурнирнаяТаблица.Команда = ТурнирнаяТаблица1.Команда
			               |			И ТурнирнаяТаблица.Период >= ТурнирнаяТаблица1.Период
			               |			И (ТурнирнаяТаблица1.КоличествоОчков > 0)
			               |ГДЕ
			               |	ТурнирнаяТаблица.КоличествоОчков > 0
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
			               |		ЛЕВОЕ СОЕДИНЕНИЕ РегистрНакопления.ТурнирнаяТаблица КАК ТурнирнаяТаблица
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
			               |		ВНУТРЕННЕЕ СОЕДИНЕНИЕ РегистрНакопления.ТурнирнаяТаблица КАК ТурнирнаяТаблица
			               |		ПО Окна.Команда = ТурнирнаяТаблица.Команда
			               |			И (ТурнирнаяТаблица.Период МЕЖДУ Окна.Период1 И Окна.Период)
			               |
			               |СГРУППИРОВАТЬ ПО
			               |	Окна.Период,
			               |	Окна.Команда
			               |
			               |ИМЕЮЩИЕ
			               |	КОЛИЧЕСТВО(РАЗЛИЧНЫЕ Окна.Период1) > 3
			               |;
			               |
			               |////////////////////////////////////////////////////////////////////////////////
			               |ВЫБРАТЬ РАЗЛИЧНЫЕ
			               |	МАКСИМУМ(Макси.Количество) КАК Количество,
			               |	Окна.Команда КАК Команда
			               |ИЗ
			               |	Окна КАК Окна
			               |		ВНУТРЕННЕЕ СОЕДИНЕНИЕ Макси КАК Макси
			               |		ПО Окна.Период = Макси.Период
			               |			И Окна.Команда = Макси.Команда
			               |		ЛЕВОЕ СОЕДИНЕНИЕ РегистрНакопления.ТурнирнаяТаблица КАК ТурнирнаяТаблица
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
			               |ИМЕЮЩИЕ
			               |	МАКСИМУМ(Макси.Количество) > СРЕДНЕЕ(Макси.Количество)
			               |
			               |УПОРЯДОЧИТЬ ПО
			               |	Количество УБЫВ,
			               |	Команда
			               |АВТОУПОРЯДОЧИВАНИЕ";
			Детали	= Запрос.Выполнить().Выбрать();
			Пока Детали.Следующий() Цикл
				График.УстановитьЗначение(График.УстановитьТочку(Детали.Количество), График.УстановитьСерию(Детали.Команда), Детали.Количество);
			КонецЦикла;
			
		Иначе
			Запрос.Текст = "ВЫБРАТЬ ПЕРВЫЕ 5
			               |	ТТ.Команда КАК Команда,
			               |	ТТ.КоличествоГоловОборот КАК КоличествоГолов,
			               |	ТТ.КоличествоОчковОборот КАК КоличествоОчков
			               |ПОМЕСТИТЬ Топ5
			               |ИЗ
			               |	РегистрНакопления.ТурнирнаяТаблица.Обороты(, , , Тур.Владелец = &Чемпионат) КАК ТТ
			               |
			               |УПОРЯДОЧИТЬ ПО
			               |	КоличествоГолов УБЫВ
			               |;
			               |
			               |////////////////////////////////////////////////////////////////////////////////
			               |ВЫБРАТЬ
			               |	ТТ.Команда КАК Команда,
			               |	ТТ.КоличествоОчков КАК КоличествоОчков,
			               |	ТТ.КоличествоГолов КАК КоличествоГолов,
			               |	ТТ.Тур КАК Тур
			               |ИЗ
			               |	РегистрНакопления.ТурнирнаяТаблица КАК ТТ
			               |		ВНУТРЕННЕЕ СОЕДИНЕНИЕ Топ5 КАК Топ5
			               |		ПО ТТ.Команда = Топ5.Команда
			               |ГДЕ
			               |	ТТ.Тур.Владелец = &Чемпионат
			               |
			               |УПОРЯДОЧИТЬ ПО
			               |	ТТ.Период
			               |ИТОГИ ПО
			               |	Команда";
			Если ТипГрафика = 0 Тогда
				Запрос.Текст = СтрЗаменить(Запрос.Текст, "Голов УБЫВ", "Очков УБЫВ")
			КонецЕсли;
			Выборка = Запрос.Выполнить().Выбрать(ОбходРезультатаЗапроса.ПоГруппировкам);
			Пока Выборка.Следующий() Цикл
				Серия	= График.УстановитьСерию(Выборка.Команда);
				
				Итого	= 0;
				Детали	= Выборка.Выбрать();
				Пока Детали.Следующий() Цикл
					Итого = Итого + ?(ТипГрафика = 0, Детали.КоличествоОчков, Детали.КоличествоГолов);
					График.УстановитьЗначение(График.УстановитьТочку(Детали.Тур), Серия, Итого);
				КонецЦикла;
			КонецЦикла;
		КонецЕсли;
	КонецЕсли;
КонецПроцедуры

&НаКлиенте
Процедура ЧемпионатПриИзменении(Элемент)
	ГрафикОбновить();
КонецПроцедуры

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	Если Параметры.Свойство("Чемпионат") Тогда
		ЭтаФорма.АвтоматическоеСохранениеДанныхВНастройках = АвтоматическоеСохранениеДанныхФормыВНастройках.НеИспользовать;
		Отчет.Чемпионат	= Параметры.Чемпионат;
	
	ИначеЕсли Параметры.Свойство("Команда") Тогда
		ЭтаФорма.АвтоматическоеСохранениеДанныхВНастройках = АвтоматическоеСохранениеДанныхФормыВНастройках.НеИспользовать;
		Отчет.Команда	= Параметры.Команда;
		Если ПустаяСтрока(Отчет.Чемпионат) Тогда
			Отчет.Чемпионат = СерверныйФункции.ЧемпионатПолучитьПоследнее(Отчет.Команда);
		КонецЕсли;
	КонецЕсли;
КонецПроцедуры

&НаКлиенте
Процедура ПриОткрытии(Отказ)
	ГрафикОбновить();
КонецПроцедуры

&НаКлиенте
Процедура ГрафикВыбор(Элемент, ЗначениеДиаграммы, СтандартнаяОбработка)
	Если ПустаяСтрока(Отчет.Команда)
	И ТипЗнч(ЗначениеДиаграммы.Значение) = Тип("СправочникСсылка.Команды")
	Тогда
		Отчет.Команда	= ЗначениеДиаграммы.Значение;
		ГрафикОбновить();
	КонецЕсли;
КонецПроцедуры

&НаКлиенте
Процедура КомандаНачалоВыбора(Элемент, ДанныеВыбора, СтандартнаяОбработка)
	СтандартнаяОбработка = Ложь;
	
	ДанныеВыбора = Новый Структура("Чемпионат", Отчет.Чемпионат);
	Если ЗначениеЗаполнено(Отчет.Команда) Тогда
		ДанныеВыбора.Вставить("ТекущаяСтрока", Отчет.Команда);
	КонецЕсли;
	ОткрытьФорму("Справочник.Команды.Форма.ФормаВыбора", ДанныеВыбора, Элемент);
КонецПроцедуры

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
			               |	Комбинации.Период1,
			               |	Комбинации.Команда
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
			               |		ПО Окна.Команда = ТурнирнаяТаблица.Команда
			               |			И (ТурнирнаяТаблица.Период МЕЖДУ Окна.Период1 И Окна.Период)
			               |
			               |СГРУППИРОВАТЬ ПО
			               |	Окна.Период
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
			
			//Запрос.Текст = "ВЫБРАТЬ
			//               |	МАКСИМУМ(ТурнирнаяТаблица.Период) КАК Период
			//               |ПОМЕСТИТЬ Макси
			//               |ИЗ
			//               |	РегистрНакопления.ТурнирнаяТаблица КАК ТурнирнаяТаблица
			//               |ГДЕ
			//               |	ТурнирнаяТаблица.Команда = &Команда
			//               |	И ТурнирнаяТаблица.КоличествоОчков = 0
			//               |	И ТурнирнаяТаблица.Тур.Владелец.Владелец = &Лига
			//               |	И ТурнирнаяТаблица.Тур.Владелец <> &Чемпионат
			//               |;
			//               |
			//               |////////////////////////////////////////////////////////////////////////////////
			//               |ВЫБРАТЬ
			//               |	ТурнирнаяТаблица.Тур.Владелец КАК Чемпионат,
			//               |	ТурнирнаяТаблица.Тур КАК Тур,
			//               |	ТурнирнаяТаблица.КоличествоОчков КАК КоличествоОчков
			//               |ИЗ
			//               |	РегистрНакопления.ТурнирнаяТаблица КАК ТурнирнаяТаблица,
			//               |	Макси КАК Макси
			//               |ГДЕ
			//               |	ТурнирнаяТаблица.Команда = &Команда
			//               |	И ТурнирнаяТаблица.Тур.Владелец.Владелец = &Лига
			//               |	И ТурнирнаяТаблица.Период > Макси.Период
			//               |
			//               |УПОРЯДОЧИТЬ ПО
			//               |	ТурнирнаяТаблица.Период УБЫВ";
			//Резалт	= Запрос.Выполнить();
			//Если Резалт.Пустой() Тогда
			//	Запрос.Текст = "ВЫБРАТЬ
			//	               |	ТурнирнаяТаблица.Тур.Владелец КАК Чемпионат,
			//	               |	ТурнирнаяТаблица.Тур КАК Тур,
			//	               |	ТурнирнаяТаблица.КоличествоОчков КАК КоличествоОчков
			//	               |ИЗ
			//	               |	РегистрНакопления.ТурнирнаяТаблица КАК ТурнирнаяТаблица
			//	               |ГДЕ
			//	               |	ТурнирнаяТаблица.Команда = &Команда
			//	               |	И ТурнирнаяТаблица.Тур.Владелец = &Чемпионат
			//	               |
			//	               |УПОРЯДОЧИТЬ ПО
			//	               |	ТурнирнаяТаблица.Период УБЫВ";
			//	Резалт	= Запрос.Выполнить();
			//КонецЕсли;
			//Детали	= Резалт.Выбрать();
			//Если Детали.Следующий() Тогда
			//	тЧемпионат = Детали.Чемпионат;
			//	Детали.Сбросить();
			//	
			//	Итого	= 0;
			//	Точка	= Неопределено;
			//	Серия	= График.УстановитьСерию(Отчет.Команда);
			//	Пока Детали.Следующий() Цикл
			//		Если Детали.КоличествоОчков > 0 Тогда
			//			Точка	= ?(Итого=0, Детали.Тур, Точка);
			//			Итого	= Итого + 1;
			//		Иначе
			//			Если Итого > 3 Тогда
			//				График.УстановитьЗначение(График.УстановитьТочку(Точка), Серия, Итого);
			//			ИначеЕсли тЧемпионат <> Детали.Чемпионат Тогда
			//				Прервать;
			//			КонецЕсли;
			//			Точка	= Неопределено;
			//			Итого	= 0;
			//		КонецЕсли;
			//	КонецЦикла;
			//	Если Итого > 3 Тогда
			//		График.УстановитьЗначение(График.УстановитьТочку(Точка), Серия, Итого);
			//	КонецЕсли;
			//КонецЕсли;
			
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
			Запрос.Текст = "ВЫБРАТЬ
			               |	КОЛИЧЕСТВО(РАЗЛИЧНЫЕ ТурнирнаяТаблица.Тур) КАК Количество
			               |ИЗ
			               |	РегистрНакопления.ТурнирнаяТаблица КАК ТурнирнаяТаблица
			               |ГДЕ
			               |	ТурнирнаяТаблица.Тур.Владелец = &Чемпионат";
			Итоги = Запрос.Выполнить().Выбрать();
			Туров = ?(Итоги.Следующий(), Итоги.Количество, 0);
			
			Топ = Новый ТаблицаЗначений;
			Топ.Колонки.Добавить("Команда");
			Топ.Колонки.Добавить("Тур");
			Топ.Колонки.Добавить("Количество");
			Запрос.Текст = "ВЫБРАТЬ
			               |	ТурнирнаяТаблица.Команда КАК Команда,
			               |	ТурнирнаяТаблица.Тур КАК Тур,
			               |	ТурнирнаяТаблица.КоличествоОчков КАК КоличествоОчков
			               |ИЗ
			               |	РегистрНакопления.ТурнирнаяТаблица КАК ТурнирнаяТаблица
			               |ГДЕ
			               |	ТурнирнаяТаблица.Тур.Владелец = &Чемпионат
			               |
			               |УПОРЯДОЧИТЬ ПО
			               |	ТурнирнаяТаблица.Период,
			               |	КоличествоОчков УБЫВ
			               |ИТОГИ
			               |	СУММА(КоличествоОчков)
			               |ПО
			               |	Команда";
			Итого	= 0;
			Ласт	= 0;
			Точка	= Неопределено;
			Итоги = Запрос.Выполнить().Выбрать(ОбходРезультатаЗапроса.ПоГруппировкам);
			Пока Итоги.Следующий() И Итоги.КоличествоОчков > Ласт Цикл
				Шаг		= 1;
				Итого	= 0;
				Детали	= Итоги.Выбрать();
				Пока Детали.Следующий() Цикл
					Если Детали.КоличествоОчков = 0 Тогда
						Если Итого > 3 Тогда
							тСтрока = Топ.Добавить();
							тСтрока.Команда		= Детали.Команда;
							тСтрока.Тур			= Точка;
							тСтрока.Количество	= Итого;
							Ласт	= Макс(Ласт, Итого);
						ИначеЕсли Туров - Шаг <= 3 Тогда
							Прервать;
						КонецЕсли;
						Итого	= 0;
					Иначе
						Итого	= Итого + 1;
						Точка	= Детали.Тур;
					КонецЕсли;
					Шаг	= Шаг + 1;
				КонецЦикла;
				Если Итого > 3 Тогда
					тСтрока = Топ.Добавить();
					тСтрока.Команда		= Детали.Команда;
					тСтрока.Тур			= Точка;
					тСтрока.Количество	= Итого;
					Ласт	= Макс(Ласт, Итого);
				КонецЕсли;
			КонецЦикла;

			Итого	= 1;
			Ласт	= 0;
			Топ.Сортировать("Количество Убыв");
			Для Каждого тСтрока Из Топ Цикл
				Если Итого > 5 Тогда
					Если тСтрока.Количество = Ласт Тогда
						График.УстановитьЗначение(График.УстановитьТочку(тСтрока.Тур), График.УстановитьСерию(тСтрока.Команда), тСтрока.Количество);
					Иначе
						Прервать;
					КонецЕсли;
				Иначе
					График.УстановитьЗначение(График.УстановитьТочку(тСтрока.Тур), График.УстановитьСерию(тСтрока.Команда), тСтрока.Количество);
					Ласт	= тСтрока.Количество;
				КонецЕсли;
				Итого	= Итого + 1;
			КонецЦикла;
			
			//Запрос.Текст = "ВЫБРАТЬ
			//               |	Дано.Период КАК Период2,
			//               |	Было.Период КАК Период,
			//               |	Дано.Команда КАК Команда,
			//               |	Дано.Тур КАК Тур,
			//               |	ВЫБОР
			//               |		КОГДА Было.Период ЕСТЬ NULL
			//               |			ТОГДА 0
			//               |		ИНАЧЕ 1
			//               |	КОНЕЦ КАК Количество
			//               |ПОМЕСТИТЬ Интервалы
			//               |ИЗ
			//               |	РегистрНакопления.ТурнирнаяТаблица КАК Дано
			//               |		ЛЕВОЕ СОЕДИНЕНИЕ РегистрНакопления.ТурнирнаяТаблица КАК Было
			//               |		ПО Дано.Команда = Было.Команда
			//               |			И Дано.Тур.Владелец.Владелец = Было.Тур.Владелец.Владелец
			//               |			И Дано.Период > Было.Период
			//               |			И (Было.КоличествоОчков > 0)
			//               |ГДЕ
			//               |	Дано.Тур.Владелец.Владелец = &Лига
			//               |	И Дано.КоличествоОчков > 0
			//               |;
			//               |
			//               |////////////////////////////////////////////////////////////////////////////////
			//               |ВЫБРАТЬ
			//               |	Дано.Период КАК Период,
			//               |	Дано.Период2 КАК Период2,
			//               |	Дано.Команда КАК Команда,
			//               |	Дано.Количество КАК Количество
			//               |ПОМЕСТИТЬ Пром
			//               |ИЗ
			//               |	Интервалы КАК Дано
			//               |		ЛЕВОЕ СОЕДИНЕНИЕ РегистрНакопления.ТурнирнаяТаблица КАК Было
			//               |		ПО Дано.Команда = Было.Команда
			//               |			И Дано.Тур.Владелец.Владелец = Было.Тур.Владелец.Владелец
			//               |			И Дано.Период < Было.Период
			//               |			И Дано.Период2 > Было.Период
			//               |ГДЕ
			//               |	Было.Период ЕСТЬ NULL
			//               |;
			//               |
			//               |////////////////////////////////////////////////////////////////////////////////
			//               |ВЫБРАТЬ
			//               |	Интервалы.Команда КАК Команда,
			//               |	СУММА(Интервалы.Количество) КАК Количество
			//               |ИЗ
			//               |	Пром КАК Интервалы
			//               |
			//               |СГРУППИРОВАТЬ ПО
			//               |	Интервалы.Команда
			//               |
			//               |ИМЕЮЩИЕ
			//               |	СУММА(Интервалы.Количество) > 0
			//               |
			//               |УПОРЯДОЧИТЬ ПО
			//               |	Количество УБЫВ,
			//               |	Команда
			//               |АВТОУПОРЯДОЧИВАНИЕ";
			//Итоги = Запрос.Выполнить().Выгрузить();
			//ф=1;
			
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
			               |	ТТ.КоличествоГолов КАК КоличествоГолов
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

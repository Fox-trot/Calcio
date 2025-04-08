﻿
Функция ОтчетСформировать(Объект) Экспорт
	ТабДокумент = Новый ТабличныйДокумент;
	Объект.Данные.Очистить();
	
	Запрос	= Новый Запрос("ВЫБРАТЬ
	      	               |	Команды.Ссылка КАК Команда,
	      	               |	МАКСИМУМ(ТурнирнаяТаблица.Период) КАК Период
	      	               |ИЗ
	      	               |	Справочник.Команды КАК Команды
	      	               |		ЛЕВОЕ СОЕДИНЕНИЕ РегистрНакопления.ТурнирнаяТаблица КАК ТурнирнаяТаблица
	      	               |		ПО (ТурнирнаяТаблица.Команда = Команды.Ссылка)
	      	               |ГДЕ
	      	               |	Команды.Город = &Город
	      	               |	И Команды.ПометкаУдаления = ЛОЖЬ
	      	               |
	      	               |СГРУППИРОВАТЬ ПО
	      	               |	Команды.Ссылка");
	Запрос.УстановитьПараметр("Город",			Город);
	Команды = Запрос.Выполнить().Выгрузить().ВыгрузитьКолонку(0);
	Если Команды.Количество() < 2 Тогда
		Возврат ТабДокумент;
	КонецЕсли;
	
	Запрос.УстановитьПараметр("Команды",		Команды);
	Запрос.Текст	= "ВЫБРАТЬ ПЕРВЫЕ 1
	            	  |	Туры.Владелец КАК Чемпионат,
	            	  |	Чемпионаты.Владелец КАК Лига
	            	  |ИЗ
	            	  |	РегистрНакопления.ТурнирнаяТаблица КАК ТурнирнаяТаблица
	            	  |		ВНУТРЕННЕЕ СОЕДИНЕНИЕ Справочник.Туры КАК Туры
	            	  |			ВНУТРЕННЕЕ СОЕДИНЕНИЕ Справочник.Чемпионаты КАК Чемпионаты
	            	  |				ВНУТРЕННЕЕ СОЕДИНЕНИЕ Справочник.Лига КАК Лига
	            	  |					ВНУТРЕННЕЕ СОЕДИНЕНИЕ Справочник.Страны КАК Страны
	            	  |					ПО Лига.Страна = Страны.Ссылка
	            	  |				ПО Чемпионаты.Владелец = Лига.Ссылка
	            	  |			ПО Туры.Владелец = Чемпионаты.Ссылка
	            	  |		ПО ТурнирнаяТаблица.Тур = Туры.Ссылка
	            	  |		ВНУТРЕННЕЕ СОЕДИНЕНИЕ РегистрНакопления.ТурнирнаяТаблица КАК Матчи
	            	  |		ПО ТурнирнаяТаблица.Регистратор = Матчи.Регистратор
	            	  |ГДЕ
	            	  |	ТурнирнаяТаблица.Команда В(&Команды)
	            	  |	И ТурнирнаяТаблица.Регистратор ССЫЛКА Документ.Матч
	            	  |	И Туры.ОлимпийскаяСистема = ЛОЖЬ
	            	  |	И ТурнирнаяТаблица.НомерСтроки <> Матчи.НомерСтроки
	            	  |
	            	  |УПОРЯДОЧИТЬ ПО
	            	  |	Туры.ДатаОкончания УБЫВ";
	Выборка = Запрос.Выполнить().Выбрать();
	Если Выборка.Следующий() Тогда
		ТабДокумент.Вывести(ЗаголовокПолучить(Выборка.Лига, Выборка.Чемпионат));
		
		Объект.Чемпионат	= Выборка.Чемпионат;
		Запрос.УстановитьПараметр("Чемпионат",			Выборка.Чемпионат);
		Запрос.Текст	= "ВЫБРАТЬ
		            	  |	ТурнирнаяТаблица.Регистратор КАК Регистратор,
		            	  |	ТурнирнаяТаблица.НомерСтроки КАК НомерСтроки,
		            	  |	ТурнирнаяТаблица.Команда КАК Команда,
		            	  |	ТурнирнаяТаблица.КоличествоГолов КАК КоличествоГолов,
		            	  |	ТурнирнаяТаблица.КоличествоОчков КАК КоличествоОчков
		            	  |ПОМЕСТИТЬ ТурнирнаяТаблица
		            	  |ИЗ
		            	  |	РегистрНакопления.ТурнирнаяТаблица КАК ТурнирнаяТаблица
		            	  |		ВНУТРЕННЕЕ СОЕДИНЕНИЕ РегистрНакопления.ТурнирнаяТаблица КАК Матчи
		            	  |		ПО ТурнирнаяТаблица.Регистратор = Матчи.Регистратор
		            	  |			И ТурнирнаяТаблица.НомерСтроки <> Матчи.НомерСтроки
		            	  |		ВНУТРЕННЕЕ СОЕДИНЕНИЕ Справочник.Туры КАК Туры
		            	  |		ПО ТурнирнаяТаблица.Тур = Туры.Ссылка
		            	  |ГДЕ
		            	  |	Туры.Владелец = &Чемпионат
		            	  |	И ТурнирнаяТаблица.Команда В(&Команды)
		            	  |	И ТурнирнаяТаблица.Регистратор ССЫЛКА Документ.Матч
		            	  |	И Матчи.Команда В(&Команды)
		            	  |;
		            	  |
		            	  |////////////////////////////////////////////////////////////////////////////////
		            	  |ВЫБРАТЬ
		            	  |	ТурнирнаяТаблица.Команда КАК Команда,
		            	  |	СУММА(ВЫБОР
		            	  |			КОГДА ТурнирнаяТаблица.Регистратор ЕСТЬ NULL
		            	  |				ТОГДА 0
		            	  |			ИНАЧЕ 1
		            	  |		КОНЕЦ) КАК КоличествоИгр,
		            	  |	СУММА(ТурнирнаяТаблица.КоличествоГолов) КАК Забито,
		            	  |	СУММА(ТурнирнаяТаблица.КоличествоОчков) КАК КоличествоОчков,
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
		            	  |	СУММА(Игра.КоличествоГолов) КАК Пропущено,
		            	  |	СУММА(ТурнирнаяТаблица.КоличествоГолов) - СУММА(Игра.КоличествоГолов) КАК Разница
		            	  |ИЗ
		            	  |	ТурнирнаяТаблица КАК ТурнирнаяТаблица
		            	  |		ВНУТРЕННЕЕ СОЕДИНЕНИЕ ТурнирнаяТаблица КАК Игра
		            	  |		ПО ТурнирнаяТаблица.Регистратор = Игра.Регистратор
		            	  |			И ТурнирнаяТаблица.НомерСтроки <> Игра.НомерСтроки
		            	  |
		            	  |СГРУППИРОВАТЬ ПО
		            	  |	ТурнирнаяТаблица.Команда
		            	  |
		            	  |УПОРЯДОЧИТЬ ПО
		            	  |	КоличествоОчков УБЫВ,
		            	  |	КоличествоИгр,
		            	  |	Разница УБЫВ,
		            	  |	Забито УБЫВ,
		            	  |	Команда
		            	  |АВТОУПОРЯДОЧИВАНИЕ";
		Выборка = Запрос.Выполнить().Выбрать();
		
		Макет  = ПолучитьОбщийМакет("ТурнирнаяТаблица");
		ТабДокумент.Вывести(Макет.ПолучитьОбласть("Шапка"));
		//ТабДокумент.ФиксацияСверху	= 2 + Выборка.Количество();
		//ТабДокумент.ФиксацияСлева	= 9;
		
		НомерСтроки	= 0;
		Пока Выборка.Следующий() Цикл
			НомерСтроки	= НомерСтроки + 1;
			
			ОбластьМакета = Макет.ПолучитьОбласть("Детали");
			ОбластьМакета.Параметры.Заполнить(Выборка);
			ОбластьМакета.Параметры.Место	= НомерСтроки;
			ТабДокумент.Вывести(ОбластьМакета);
			
			ЗаполнитьЗначенияСвойств(Объект.Данные.Добавить(), Выборка);
		КонецЦикла;
		
		ТабДокумент.Вывести(Макет.ПолучитьОбласть("Пробел"));
		
		Хозяева			= МояКомандаПолучить();
		Запрос.Текст	= "ВЫБРАТЬ
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
		            	  |	Матч.Тур.Владелец = &Чемпионат
		            	  |	И ТурнирнаяТаблица.НомерСтроки = 1
		            	  |	И ТурнирнаяТаблица.Команда В(&Команды)
		            	  |	И МатчКоманды.НомерСтроки = 2
		            	  |	И МатчКоманды.Команда В(&Команды)
		            	  |
		            	  |УПОРЯДОЧИТЬ ПО
		            	  |	Дата УБЫВ,
		            	  |	Счет";
		Запрос.УстановитьПараметр("Хозяева",		Хозяева);
		Выборка = Запрос.Выполнить().Выбрать();
		Пока Выборка.Следующий() Цикл
			Область = Макет.ПолучитьОбласть(?(Выборка.Хозяева, "Хозяева", "Матчи"));
			Область.Параметры.Заполнить(Выборка);
			ТабДокумент.Вывести(Область);
		КонецЦикла;
	КонецЕсли;
	
	Возврат ТабДокумент;
КонецФункции

Функция ЗаголовокПолучить(Лига, Чемпионат)
	Возврат СерверныйФункции.ЗаголовокПолучить(Новый Структура("Лига,Чемпионат,ВыводитьЧемпионат", Лига, Чемпионат, Истина));
КонецФункции

Функция МояКомандаПолучить()
	Возврат СерверныйФункции.МояКомандаПолучить();
КонецФункции

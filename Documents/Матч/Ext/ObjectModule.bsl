﻿
Процедура ПередЗаписью(Отказ, РежимЗаписи, РежимПроведения)
	Хозяева	= Неопределено;
	Если ПустаяСтрока(Тур) Тогда
		мКоманды = Новый Массив;
		Для Каждого тСтрока Из Команды Цикл
			мКоманды.Добавить(тСтрока.Команда);
			Если Хозяева = Неопределено Тогда
				Хозяева = тСтрока.Команда;
			КонецЕсли;
		КонецЦикла;
		Тур = СерверныйФункции.Тур(мКоманды, Дата);
	КонецЕсли;
	
	Если Команды.Количество() > 0 Тогда
		Если Хозяева = Неопределено Тогда
			Хозяева	= Команды[0].Команда;
		КонецЕсли;
		
		Если ПустаяСтрока(Тур) Тогда
			Тур = СерверныйФункции.Тур(Хозяева, Дата);
		КонецЕсли;
		
		Если ПустаяСтрока(Стадион) Тогда
			Стадион = СерверныйФункции.Стадион(Хозяева);
		КонецЕсли;
		
		Если Команды.Количество() = 2 Тогда
			Гости	= Команды[1].Команда;
			
			Если ПустаяСтрока(Тур) Тогда
				Тур = СерверныйФункции.Тур(Гости, Дата);
			КонецЕсли;
			
			Счет = СокрЛП(Хозяева) + " - " + СокрЛП(Гости) + ?(РежимЗаписи = РежимЗаписиДокумента.Проведение, "  " + СокрЛП(Команды[0].КоличествоГолов) + " : " + СокрЛП(Команды[1].КоличествоГолов), "");
		КонецЕсли;
	КонецЕсли;
	
	Если СоставыКоманд.Количество() > 0 Тогда
		СоставыКоманд.Свернуть("Игрок,Команда");
	КонецЕсли;
КонецПроцедуры

Процедура ОбработкаПроверкиЗаполнения(Отказ, ПроверяемыеРеквизиты)
	Если Команды.Количество() = 2 Тогда
		СерверныйФункции.МатчОбработкаПроверкиЗаполнения(ЭтотОбъект, Отказ);
	Иначе
		Отказ = Истина;
	КонецЕсли;
КонецПроцедуры

Процедура ОбработкаПроведения(Отказ, РежимПроведения)
	Секондо = Ложь;
	Для Каждого тСтрока Из Команды Цикл
		тЗапись = Движения.ТурнирнаяТаблица.Добавить();
		тЗапись.Период			= Дата;
		тЗапись.Тур				= Тур;
		тЗапись.Команда			= тСтрока.Команда;
		тЗапись.КоличествоГолов	= тСтрока.КоличествоГолов;
		тЗапись.КоличествоОчков	= КоличествоОчковРасчитать(Секондо);
		
		Секондо = Истина;
	КонецЦикла;
	Движения.ТурнирнаяТаблица.Записать();
КонецПроцедуры

Функция КоличествоОчковРасчитать(Знач Секондо)
	Если Команды[0].КоличествоГолов < Команды[1].КоличествоГолов Тогда
		Возврат	?(Секондо, 3, 0);
		
	ИначеЕсли Команды[0].КоличествоГолов > Команды[1].КоличествоГолов Тогда
		Возврат	?(Секондо, 0, 3);
		
	КонецЕсли;
	Возврат 1;
КонецФункции

Процедура ОбработкаЗаполнения(ДанныеЗаполнения, ТекстЗаполнения, СтандартнаяОбработка)
	Если ТипЗнч(ДанныеЗаполнения) = Тип("СправочникСсылка.Туры") Тогда
		Тур		= ДанныеЗаполнения;
		Дата	= ДанныеЗаполнения.ДатаНачала;
		
	ИначеЕсли ТипЗнч(ДанныеЗаполнения) = Тип("СправочникСсылка.Стадионы") Тогда
		Стадион	= ДанныеЗаполнения;
		
		Если Команды.Количество() > 0 Тогда
			Команды.Очистить();
		КонецЕсли;
		тКоманда = Команды.Добавить();
		тКоманда.Команда	= ДанныеЗаполнения.Владелец;
		
	ИначеЕсли ТипЗнч(ДанныеЗаполнения) = Тип("СправочникСсылка.Команды") Тогда
		Стадион	= СерверныйФункции.Стадион(ДанныеЗаполнения);
		
		Если Команды.Количество() > 0 Тогда
			Команды.Очистить();
		КонецЕсли;
		тКоманда = Команды.Добавить();
		тКоманда.Команда	= ДанныеЗаполнения;
	КонецЕсли;
КонецПроцедуры

Процедура ПриКопировании(ОбъектКопирования)
	Счет				= "";
	КоличествоЗрителей	= 0;
КонецПроцедуры

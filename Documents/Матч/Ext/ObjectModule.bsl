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
			Хозяева	= Команды.Получить(0).Команда;
		КонецЕсли;
		
		Если ПустаяСтрока(Тур) Тогда
			Тур = СерверныйФункции.Тур(Хозяева, Дата);
		КонецЕсли;
		
		Если ПустаяСтрока(Стадион) Тогда
			Стадион = Стадион(Хозяева);
		КонецЕсли;
		
		Если Команды.Количество() = 2 Тогда
			Гости	= Команды.Получить(1).Команда;
			
			Если ПустаяСтрока(Тур) Тогда
				Тур = СерверныйФункции.Тур(Гости, Дата);
			КонецЕсли;
			
			Счет = СокрЛП(Хозяева) + " - " + СокрЛП(Гости) + ?(РежимЗаписи = РежимЗаписиДокумента.Проведение, "  " + СокрЛП(Команды.Получить(0).КоличествоГолов) + " : " + СокрЛП(Команды.Получить(1).КоличествоГолов), "");
		КонецЕсли;
	КонецЕсли;
	
	Если РежимЗаписи = РежимЗаписиДокумента.Проведение И СоставыКоманд.Количество() > 0 Тогда
		СоставыКоманд.Свернуть("Игрок,Команда");
		
		СписокШиндлера = Новый Массив;
		Для Каждого тСтрока Из СоставыКоманд Цикл
			Если Команды.НайтиСтроки(Новый Структура("Команда", тСтрока.Команда)).Количество() = 0 Тогда
				СписокШиндлера.Добавить(тСтрока);
			КонецЕсли;
		КонецЦикла;
		Для Каждого тСтрока Из СписокШиндлера Цикл
			СоставыКоманд.Удалить(тСтрока);
		КонецЦикла;
	КонецЕсли;
КонецПроцедуры

Процедура ОбработкаПроверкиЗаполнения(Отказ, ПроверяемыеРеквизиты)
	Если Команды.Количество() = 2 Тогда
		СерверныйФункции.МатчОбработкаПроверкиЗаполнения(ЭтотОбъект, Отказ);
	Иначе
		СерверныйФункции.СообщитьОбОшибке("Недостаточно команд", Отказ);
	КонецЕсли;
	Если НЕ Отказ Тогда
		Запрос = Новый Запрос("ВЫБРАТЬ РАЗЛИЧНЫЕ
		                      |	ТурнирнаяТаблицаОбороты.Регистратор КАК Регистратор
		                      |ИЗ
		                      |	РегистрНакопления.ТурнирнаяТаблица.Обороты(&ДатаНач, &ДатаКон, Регистратор, Команда В (&Команды)) КАК ТурнирнаяТаблицаОбороты
		                      |ГДЕ
		                      |	ТурнирнаяТаблицаОбороты.Регистратор <> &Матч");
		Запрос.УстановитьПараметр("ДатаНач",	НачалоДня(Дата));
		Запрос.УстановитьПараметр("ДатаКон",	КонецДня(Дата));
		Запрос.УстановитьПараметр("Команды",	Команды.Выгрузить().ВыгрузитьКолонку("Команда"));
		Запрос.УстановитьПараметр("Матч",		Ссылка);
		Если НЕ Запрос.Выполнить().Пустой() Тогда
			СерверныйФункции.СообщитьОбОшибке("Такой матч уже есть в базе", Отказ);
		КонецЕсли;
	КонецЕсли;
КонецПроцедуры

Процедура ОбработкаПроведения(Отказ, РежимПроведения)
	Если НачалоДня(Дата) > НачалоДня(ТекущаяДата()) Тогда
		СерверныйФункции.СообщитьОбОшибке("Дата неверна", Отказ);
	КонецЕсли;
	
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
	Если Команды.Получить(0).КоличествоГолов < Команды.Получить(1).КоличествоГолов Тогда
		Возврат	?(Секондо, 3, 0);
		
	ИначеЕсли Команды.Получить(0).КоличествоГолов > Команды.Получить(1).КоличествоГолов Тогда
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
		Стадион	= Стадион(ДанныеЗаполнения);
		
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
	Стадион				= Неопределено;
	Тур					= Неопределено;
	
	Для Каждого тСтрока Из Команды Цикл
		тСтрока.КоличествоГолов = 0;
	КонецЦикла;
	Если Команды.Количество() = 2 Тогда
		Темпо	= Команды.Получить(0).Команда;
		Команды.Получить(0).Команда	= Команды.Получить(1).Команда;
		Команды.Получить(1).Команда	= Темпо;
	КонецЕсли;
КонецПроцедуры

Функция Стадион(Тим)
	Возврат СерверныйФункции.Стадион(Тим);
КонецФункции

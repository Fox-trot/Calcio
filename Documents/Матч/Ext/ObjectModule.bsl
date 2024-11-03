﻿Перем Хозяева, Гости;


Процедура ПередЗаписью(Отказ, РежимЗаписи, РежимПроведения)
	СчетУстановить(Команды, РежимЗаписи = РежимЗаписиДокумента.Проведение);
	Если НЕ ЗначениеЗаполнено(Стадион) Тогда
		ОбщегоНазначения.УстановитьЗначение(КоличествоЗрителей, 0);
	КонецЕсли;
	
	Если РежимЗаписи = РежимЗаписиДокумента.Проведение И СоставыКоманд.Количество() > 0 Тогда
		СписокШиндлера = Новый Массив;
		Для Каждого тСтрока Из СоставыКоманд Цикл
			Если Команды.НайтиСтроки(Новый Структура("Команда", тСтрока.Команда)).Количество() = 0 Тогда
				СписокШиндлера.Добавить(тСтрока);
			КонецЕсли;
		КонецЦикла;
		Для Каждого тСтрока Из СписокШиндлера Цикл
			СоставыКоманд.Удалить(тСтрока);
		КонецЦикла;
		
		СоставыКоманд.Свернуть("Игрок,Команда");
	КонецЕсли;
КонецПроцедуры

Процедура СчетУстановить(Команды, Проведение) Экспорт
	Если Команды.Количество() = 2 Тогда
		Хозяева	= Команды.Получить(0);
		Гости	= Команды.Получить(1);
		Если Проведение Тогда
			Счет = СтрШаблон("%1 - %2 %3:%4", Хозяева.Команда, Гости.Команда, Формат(Хозяева.КоличествоГолов, "ЧН=0; ЧГ=0"), Формат(Гости.КоличествоГолов, "ЧН=0; ЧГ=0"));
		Иначе
			Счет = СтрШаблон("%1 - %2", Хозяева.Команда, Гости.Команда);
		КонецЕсли;
	ИначеЕсли Команды.Количество() = 1 Тогда
		Счет = СокрЛП(Команды.Получить(0).Команда) + " - ??";
	Иначе
		Счет = "Матч";
	КонецЕсли;
КонецПроцедуры

Процедура ОбработкаПроверкиЗаполнения(Отказ, ПроверяемыеРеквизиты)
	//Если КоличествоЗрителей > 0 Тогда
	//	ПроверяемыеРеквизиты.Добавить("Стадион");
	//КонецЕсли;
	Если Команды.Количество() = 2 Тогда
		Хозяева	= Команды.Получить(0);
		Гости	= Команды.Получить(1);
		Если Хозяева.Команда = Гости.Команда Тогда
			ОбщегоНазначения.СообщитьОбОшибке("Неверно указаны команды", Отказ, Ссылка);
		КонецЕсли;
	Иначе
		ОбщегоНазначения.СообщитьОбОшибке("Неверно указаны команды", Отказ, Ссылка);
	КонецЕсли;
	Если НЕ Тур.ОлимпийскаяСистема Тогда
		мКоманды	= Команды.Выгрузить().ВыгрузитьКолонку("Команда");
		Запрос = Новый Запрос("ВЫБРАТЬ
		                      |	ТурнирнаяТаблица.Регистратор КАК Регистратор
		                      |ИЗ
		                      |	РегистрНакопления.ТурнирнаяТаблица КАК ТурнирнаяТаблица
		                      |		ВНУТРЕННЕЕ СОЕДИНЕНИЕ Документ.Матч КАК Матч
		                      |		ПО ТурнирнаяТаблица.Регистратор = Матч.Ссылка
		                      |ГДЕ
		                      |	ТурнирнаяТаблица.Тур = &Тур
		                      |	И ТурнирнаяТаблица.Команда В(&Команды)
		                      |	И ТурнирнаяТаблица.Регистратор <> &Матч");
		Запрос.УстановитьПараметр("Команды",	мКоманды);
		Запрос.УстановитьПараметр("Матч",		Ссылка);
		Запрос.УстановитьПараметр("Тур",		Тур);
		Ризалт	= Запрос.Выполнить();
		Если Ризалт.Пустой() Тогда
			Запрос.Текст = "ВЫБРАТЬ
			               |	Команды.Ссылка КАК Ссылка
			               |ИЗ
			               |	Справочник.Команды КАК Команды
			               |ГДЕ
			               |	Команды.Ссылка В(&Команды)";
			Выборка = Запрос.Выполнить().Выбрать();
			Если Выборка.Количество() = 2 И мКоманды.Количество() = 2 Тогда
				Отказ = МатчОбработкаПроверкиЗаполнения(ЭтотОбъект);
			Иначе
				ОбщегоНазначения.СообщитьОбОшибке("Неверно указаны команды", Отказ, Ссылка);
			КонецЕсли;
		Иначе
			Выборка = Ризалт.Выбрать();
			Если Выборка.Следующий() Тогда
				ОбщегоНазначения.СообщитьОбОшибке(СтрШаблон("Такой матч уже есть в базе (%1)", Выборка.Регистратор), Отказ);
			КонецЕсли;
		КонецЕсли;
	КонецЕсли;
КонецПроцедуры

Процедура ОбработкаПроведения(Отказ, РежимПроведения)
	Если НачалоДня(Дата) > НачалоДня(ТекущаяДатаСеанса()) Тогда
		ОбщегоНазначения.СообщитьОбОшибке("Дата неверна", Отказ, Ссылка);
		Возврат;
	КонецЕсли;
	
	Секондо = Ложь;
	Для Каждого тСтрока Из Команды Цикл
		тЗапись = Движения.ТурнирнаяТаблица.Добавить();
		ЗаполнитьЗначенияСвойств(тЗапись, тСтрока);
		тЗапись.Период			= Дата;
		тЗапись.Тур				= Тур;
		тЗапись.КоличествоОчков	= КоличествоОчковРасчитать(Секондо);
		
		Секондо = Истина;
	КонецЦикла;
	Движения.ТурнирнаяТаблица.Записать();
КонецПроцедуры

Функция КоличествоОчковРасчитать(Секондо)
	Если Хозяева.КоличествоГолов < Гости.КоличествоГолов Тогда
		Возврат	?(Секондо, 3, 0);
	ИначеЕсли Хозяева.КоличествоГолов > Гости.КоличествоГолов Тогда
		Возврат	?(Секондо, 0, 3);
	КонецЕсли;
	Возврат 1;
КонецФункции

Процедура ОбработкаЗаполнения(ДанныеЗаполнения, ТекстЗаполнения, СтандартнаяОбработка)
	Если ТипЗнч(ДанныеЗаполнения) = Тип("Структура") Тогда
		ЗаполнитьЗначенияСвойств(ЭтотОбъект, ДанныеЗаполнения);
		Если ДанныеЗаполнения.Свойство("Команды") Тогда
			Для Каждого Команда Из ДанныеЗаполнения.Команды Цикл
				Если ТипЗнч(Команда) = Тип("СправочникСсылка.Команды") Тогда
					ЗаполнитьЗначенияСвойств(Команды.Добавить(), Новый Структура("Команда", Команда));
				КонецЕсли;
			КонецЦикла;
		КонецЕсли;
		
	ИначеЕсли ТипЗнч(ДанныеЗаполнения) = Тип("СправочникСсылка.Туры") Тогда
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
		Стадион	= СтадионНайти(ДанныеЗаполнения);
		
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

Функция СтадионНайти(Тим, Все=Ложь) Экспорт
	Возврат СерверныйФункции.СтадионНайти(Тим, Все);
КонецФункции

Функция МатчОбработкаПроверкиЗаполнения(Объект) Экспорт
	Возврат СерверныйФункции.МатчОбработкаПроверкиЗаполнения(Объект);
КонецФункции

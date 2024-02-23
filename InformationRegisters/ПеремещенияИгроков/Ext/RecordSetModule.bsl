﻿
Процедура ОбработкаЗаполнения(ДанныеЗаполнения, СтандартнаяОбработка)
	Если ТипЗнч(ДанныеЗаполнения) = Тип("Структура") Тогда
		Запрос = Новый Запрос("ВЫБРАТЬ
		                      |	МАКСИМУМ(ТурнирнаяТаблица.Период) КАК Период
		                      |ИЗ
		                      |	РегистрНакопления.ТурнирнаяТаблица КАК ТурнирнаяТаблица");
		Выборка	= Запрос.Выполнить().Выбрать();
		Если Выборка.Следующий() Тогда
			Период = Дата(Год(Выборка.Период), ?(Месяц(Выборка.Период)<8, 1, 8), 1);
		Иначе
			Период = Дата(Год(ТекущаяДатаСеанса()), ?(Месяц(ТекущаяДатаСеанса())<8, 1, 8), 1);
		КонецЕсли;
		
		Для Каждого тЭлемент Из ЭтотОбъект Цикл
			тЭлемент.Период = Период;
			Если ДанныеЗаполнения.Свойство("Игрок")
			И ЗначениеЗаполнено(ДанныеЗаполнения.Игрок.Амплуа)
			Тогда
				тЭлемент.Амплуа	= ДанныеЗаполнения.Игрок.Амплуа;
			КонецЕсли;
		КонецЦикла;
	КонецЕсли;
КонецПроцедуры

Процедура ПриЗаписи(Отказ, Замещение)
	Для Каждого ТекЭлемент Из ЭтотОбъект Цикл
		Если ЗначениеЗаполнено(ТекЭлемент.Амплуа)
		И НЕ ЗначениеЗаполнено(ТекЭлемент.Игрок.Амплуа)
		Тогда
			тОбъект = ТекЭлемент.Игрок.ПолучитьОбъект();
			тОбъект.Амплуа	= ТекЭлемент.Амплуа;
			тОбъект.Записать();
		КонецЕсли;
	КонецЦикла;
КонецПроцедуры

Процедура ПередЗаписью(Отказ, Замещение)
	Для Каждого ТекЭлемент Из ЭтотОбъект Цикл
		Если НЕ ЗначениеЗаполнено(ТекЭлемент.Команда) Тогда
			ТекЭлемент.Номер = 0;
		КонецЕсли;
	КонецЦикла;
КонецПроцедуры

//Процедура ОбработкаПроверкиЗаполнения(Отказ, ПроверяемыеРеквизиты)
//	Для Каждого ТекЭлемент Из ЭтотОбъект Цикл
//		Если ЗначениеЗаполнено(ТекЭлемент.Команда) Тогда
//			ПроверяемыеРеквизиты.Добавить("Номер");
//		ИначеЕсли ЗначениеЗаполнено(ТекЭлемент.Номер) Тогда
//			ПроверяемыеРеквизиты.Добавить("Команда");
//		КонецЕсли;
//		Прервать;
//	КонецЦикла;
//КонецПроцедуры

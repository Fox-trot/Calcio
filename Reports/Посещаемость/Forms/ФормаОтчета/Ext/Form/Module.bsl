﻿
&НаСервере
Процедура ГрафикОбновитьНаСервере()
	Отчет.Данные.Очистить();
	Запрос = Новый Запрос("ВЫБРАТЬ
	                      |	Стадионы.Ссылка КАК Стадион,
	                      |	Матч.Ссылка КАК Матч,
	                      |	Туры.ДатаНачала КАК Период,
	                      |	СУММА(Матч.КоличествоЗрителей) КАК КоличествоЗрителей
	                      |ИЗ
	                      |	Справочник.Туры КАК Туры
	                      |		ВНУТРЕННЕЕ СОЕДИНЕНИЕ Документ.Матч КАК Матч
	                      |			ВНУТРЕННЕЕ СОЕДИНЕНИЕ Справочник.Стадионы КАК Стадионы
	                      |			ПО Матч.Стадион = Стадионы.Ссылка
	                      |		ПО Туры.Ссылка = Матч.Тур
	                      |ГДЕ
	                      |	Матч.Проведен = ИСТИНА
	                      |	И Матч.КоличествоЗрителей > 0
	                      |	И Туры.Владелец = &Чемпионат
	                      |
	                      |СГРУППИРОВАТЬ ПО
	                      |	Стадионы.Ссылка,
	                      |	Туры.ДатаНачала,
	                      |	Матч.Ссылка
	                      |
	                      |УПОРЯДОЧИТЬ ПО
	                      |	Период
	                      |ИТОГИ ПО
	                      |	Стадион");
	Если ЗначениеЗаполнено(Отчет.Стадион) Тогда
		Запрос.Текст = "ВЫБРАТЬ
		               |	Матч.Ссылка КАК Стадион,
		               |	Матч.Ссылка КАК Матч,
		               |	Матч.Дата КАК Период,
		               |	Матч.КоличествоЗрителей КАК КоличествоЗрителей
		               |ИЗ
		               |	Документ.Матч КАК Матч
		               |		ВНУТРЕННЕЕ СОЕДИНЕНИЕ Справочник.Стадионы КАК Стадионы
		               |		ПО Матч.Стадион = Стадионы.Ссылка
		               |		ВНУТРЕННЕЕ СОЕДИНЕНИЕ Справочник.Туры КАК Туры
		               |		ПО Матч.Тур = Туры.Ссылка
		               |ГДЕ
		               |	Матч.Стадион = &Стадион
		               |	И Матч.Проведен = ИСТИНА
		               |	И Матч.КоличествоЗрителей > 0
		               |	И Туры.Владелец = &Чемпионат
		               |
		               |УПОРЯДОЧИТЬ ПО
		               |	Период";
	КонецЕсли;
	Запрос.УстановитьПараметр("Стадион",		Отчет.Стадион);
	Запрос.УстановитьПараметр("Чемпионат",		Отчет.Чемпионат);
	Выборка	= Запрос.Выполнить().Выбрать();
	Пока Выборка.Следующий() Цикл
		ЗаполнитьЗначенияСвойств(Отчет.Данные.Добавить(), Выборка);
	КонецЦикла;
КонецПроцедуры

&НаКлиенте
Процедура ГрафикОбновить()
	График.Очистить();
	График.БазовоеЗначение	= 0;
	График.ОбластьЛегенды.Расположение	= ?(ЗначениеЗаполнено(Отчет.Стадион), РасположениеЛегендыДиаграммы.Нет, РасположениеЛегендыДиаграммы.Авто);
	_Мини	= 0;	_Макс	= 0;
	
	ГрафикОбновитьНаСервере();
	Если ЗначениеЗаполнено(Отчет.Стадион) Тогда
		Серия	= График.УстановитьСерию(Отчет.Стадион);
		
		Для Каждого Детали Из Отчет.Данные Цикл
			Точка				= График.УстановитьТочку(Детали.Период);
			Точка.Текст			= Формат(Детали.Период, "ДФ=dd.MM");
			График.УстановитьЗначение(Точка, Серия, Детали.КоличествоЗрителей, Детали.Матч);
			_Мини	= ?(_Мини = 0, Детали.КоличествоЗрителей, Мин(_Мини, Детали.КоличествоЗрителей));
			_Макс	= Макс(_Макс, Детали.КоличествоЗрителей);
		КонецЦикла;
		График.БазовоеЗначение	= Цел(Макс(_Мини * 0.1, _Мини - 0.1 * (_Макс - _Мини)));
	Иначе
		Для Каждого Детали Из Отчет.Данные Цикл
			Если ЗначениеЗаполнено(Детали.Матч) Тогда
				Точка				= График.УстановитьТочку(Детали.Период);
				Точка.Текст			= Формат(Детали.Период, "ДФ=dd.MM");
				График.УстановитьЗначение(Точка, Серия, Детали.КоличествоЗрителей, Детали.Матч);
			Иначе
				Серия	= График.УстановитьСерию(Детали.Стадион);
			КонецЕсли;
		КонецЦикла;
	КонецЕсли;
КонецПроцедуры

&НаКлиенте
Процедура ПриИзменении(Элемент)
	ГрафикОбновить();
КонецПроцедуры

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	Если Параметры.Свойство("Чемпионат") Тогда
		ЭтаФорма.АвтоматическоеСохранениеДанныхВНастройках = АвтоматическоеСохранениеДанныхФормыВНастройках.НеИспользовать;
		Отчет.Чемпионат	= Параметры.Чемпионат;
	
	ИначеЕсли Параметры.Свойство("Стадион") Тогда
		ЭтаФорма.АвтоматическоеСохранениеДанныхВНастройках = АвтоматическоеСохранениеДанныхФормыВНастройках.НеИспользовать;
		Отчет.Стадион	= Параметры.Стадион;
	КонецЕсли;
	Если НЕ ЗначениеЗаполнено(Отчет.Чемпионат) Тогда
		Отчет.Чемпионат = СерверныйФункции.ЧемпионатПолучитьПоследнее(Отчет.Стадион);
	КонецЕсли;
КонецПроцедуры

&НаКлиенте
Процедура ПриОткрытии(Отказ)
	ГрафикОбновить();
КонецПроцедуры

&НаКлиенте
Процедура ГрафикВыбор(Элемент, ЗначениеДиаграммы, СтандартнаяОбработка)
	Если ЗначениеЗаполнено(ЗначениеДиаграммы.Расшифровка) Тогда
		Попытка
			ПоказатьЗначение(, ЗначениеДиаграммы.Расшифровка);
			СтандартнаяОбработка = Ложь;
		Исключение КонецПопытки;
	ИначеЕсли НЕ ЗначениеЗаполнено(Отчет.Стадион)
	И ТипЗнч(ЗначениеДиаграммы.Значение) = Тип("СправочникСсылка.Стадионы")
	Тогда
		Отчет.Стадион	= ЗначениеДиаграммы.Значение;
		ГрафикОбновить();
	КонецЕсли;
КонецПроцедуры

&НаКлиенте
Процедура ОбработкаОповещения(ИмяСобытия, Параметр, Источник)
	Если ТипЗнч(Параметр) = Тип("СправочникСсылка.Чемпионаты") И Параметр = Отчет.Чемпионат Тогда
		ГрафикОбновить();
	//ИначеЕсли СтрСравнить(ИмяСобытия, "Матчи") = 0
	//И Параметр = Отчет.Чемпионат
	//Тогда
	//	ГрафикОбновить();
	КонецЕсли;
КонецПроцедуры

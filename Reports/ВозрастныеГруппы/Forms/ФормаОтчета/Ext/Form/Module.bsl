﻿
&НаКлиенте
Процедура Сформировать(Команда)
	Если ПроверитьЗаполнение() Тогда
		ГрафикОбновить();
	КонецЕсли;
КонецПроцедуры

&НаСервере
Процедура ДанныеЗагрузить(ТЧ=Неопределено)
	Если ТЧ = Неопределено Тогда
		Отчет.Данные.Очистить();
		
		Запрос = Новый Запрос("ВЫБРАТЬ
		                      |	""младше 21"" КАК Группа,
		                      |	16 КАК Мин,
		                      |	20 КАК Макс
		                      |ПОМЕСТИТЬ ВТ
		                      |
		                      |ОБЪЕДИНИТЬ ВСЕ
		                      |
		                      |ВЫБРАТЬ
		                      |	""21-25"",
		                      |	21,
		                      |	25
		                      |
		                      |ОБЪЕДИНИТЬ ВСЕ
		                      |
		                      |ВЫБРАТЬ
		                      |	""26-30"",
		                      |	26,
		                      |	30
		                      |
		                      |ОБЪЕДИНИТЬ ВСЕ
		                      |
		                      |ВЫБРАТЬ
		                      |	""старше 30"",
		                      |	31,
		                      |	99
		                      |;
		                      |
		                      |////////////////////////////////////////////////////////////////////////////////
		                      |ВЫБРАТЬ
		                      |	Игроки.Ссылка КАК Игрок,
		                      |	ПеремещенияИгроков.Команда КАК Команда,
		                      |	ВТ.Группа КАК Группа,
		                      |	РАЗНОСТЬДАТ(Игроки.ДатаРождения, &Дата, ГОД) КАК Количество
		                      |ИЗ
		                      |	РегистрСведений.ПеремещенияИгроков.СрезПоследних(&Дата, ГОД(Игрок.ДатаРождения) >= 1900) КАК ПеремещенияИгроков
		                      |		ВНУТРЕННЕЕ СОЕДИНЕНИЕ Справочник.Игроки КАК Игроки
		                      |		ПО ПеремещенияИгроков.Игрок = Игроки.Ссылка
		                      |		ВНУТРЕННЕЕ СОЕДИНЕНИЕ ВТ КАК ВТ
		                      |		ПО (РАЗНОСТЬДАТ(Игроки.ДатаРождения, &Дата, ГОД) МЕЖДУ ВТ.Мин И ВТ.Макс)
		                      |ГДЕ
		                      |	ПеремещенияИгроков.Команда В(&Команды)
		                      |
		                      |УПОРЯДОЧИТЬ ПО
		                      |	Игрок
		                      |АВТОУПОРЯДОЧИВАНИЕ
		                      |;
		                      |
		                      |////////////////////////////////////////////////////////////////////////////////
		                      |ВЫБРАТЬ
		                      |	ПеремещенияИгроков.Команда КАК Команда,
		                      |	ВТ.Группа КАК Группа,
		                      |	СУММА(1) КАК Количество
		                      |ИЗ
		                      |	РегистрСведений.ПеремещенияИгроков.СрезПоследних(&Дата, ГОД(Игрок.ДатаРождения) >= 1900) КАК ПеремещенияИгроков
		                      |		ВНУТРЕННЕЕ СОЕДИНЕНИЕ Справочник.Игроки КАК Игроки
		                      |		ПО ПеремещенияИгроков.Игрок = Игроки.Ссылка
		                      |		ВНУТРЕННЕЕ СОЕДИНЕНИЕ ВТ КАК ВТ
		                      |		ПО (РАЗНОСТЬДАТ(Игроки.ДатаРождения, &Дата, ГОД) МЕЖДУ ВТ.Мин И ВТ.Макс)
		                      |ГДЕ
		                      |	ПеремещенияИгроков.Команда В(&Команды)
		                      |
		                      |СГРУППИРОВАТЬ ПО
		                      |	ПеремещенияИгроков.Команда,
		                      |	ВТ.Группа,
		                      |	ВТ.Мин
		                      |
		                      |УПОРЯДОЧИТЬ ПО
		                      |	ВТ.Мин,
		                      |	Команда
		                      |АВТОУПОРЯДОЧИВАНИЕ");
		Запрос.УстановитьПараметр("Команды",		_Команды);
		Запрос.УстановитьПараметр("Дата",			ТекущаяДатаСеанса());
		Таблицы	= Запрос.ВыполнитьПакет();
		ДанныеЗагрузить(Таблицы.Получить(2));
		ДанныеЗагрузить(Таблицы.Получить(1));
	Иначе
		Выборка	= ТЧ.Выбрать();
		Пока Выборка.Следующий() Цикл
			ЗаполнитьЗначенияСвойств(Отчет.Данные.Добавить(), Выборка);
		КонецЦикла;
	КонецЕсли;
КонецПроцедуры

&НаКлиенте
Процедура ГрафикОбновить()
	ДанныеЗагрузить();
	
	График.Очистить();
	Для Каждого Детали Из Отчет.Данные Цикл
		Если ЗначениеЗаполнено(Детали.Игрок) Тогда
			Прервать;
		Иначе
			График.УстановитьЗначение(График.УстановитьТочку(Детали.Команда), График.УстановитьСерию(Детали.Группа), Детали.Количество, ИгрокиПолучить(Новый Структура("Команда,Группа", Детали.Команда, Детали.Группа)));
		КонецЕсли;
	КонецЦикла;
КонецПроцедуры

&НаСервере
Функция ИгрокиПолучить(Отбор)
	Ответ	= Новый СписокЗначений;
	Данные	= Отчет.Данные.НайтиСтроки(Отбор);
	Для Каждого Детали Из Данные Цикл
		Если Ответ.Количество() = 11 Тогда
			Прервать;
		ИначеЕсли ЗначениеЗаполнено(Детали.Игрок) Тогда
			Ответ.Добавить(Детали.Игрок, СтрШаблон("%1 (%2)", Детали.Игрок, Детали.Количество));
		КонецЕсли;
	КонецЦикла;
	Возврат Ответ;
КонецФункции

&НаКлиенте
Процедура ПриОткрытии(Отказ)
	Если _Команды.Количество() = 0 Тогда
		КомандыЗагрузить(Истина);
	КонецЕсли;
	Если ПроверитьЗаполнение() Тогда
		ГрафикОбновить();
	КонецЕсли;
КонецПроцедуры

&НаСервере
Процедура КомандыЗагрузить(Топ6=Ложь)
	Если ТипЗнч(Топ6) = Тип("СправочникСсылка.Лига") Тогда
		_Команды.ЗагрузитьЗначения(СерверныйФункции.КомандыЛиги(Топ6, Истина));
	ИначеЕсли ТипЗнч(Топ6) = Тип("СправочникСсылка.Чемпионаты") Тогда
		_Команды.ЗагрузитьЗначения(СерверныйФункции.КомандыЧемпионата(Топ6));
	Иначе
		МояКоманда	= СерверныйФункции.МояКомандаПолучить();
		Если Топ6 Тогда
			Лига		= СерверныйФункции.ЛигаКоманды(МояКоманда);
			КомандыЗагрузить(Лига);
		Иначе
			Чемпионат	= СерверныйФункции.ЧемпионатПолучитьПоследнее(МояКоманда);
			КомандыЗагрузить(Чемпионат);
		КонецЕсли;
	КонецЕсли;
КонецПроцедуры

&НаКлиенте
Процедура Заполнить(Команда)
	КомандыЗагрузить();
	ГрафикОбновить();
КонецПроцедуры

&НаКлиенте
Процедура ГрафикВыбор(Элемент, ЗначениеДиаграммы, СтандартнаяОбработка)
	СтандартнаяОбработка	= Ложь;
	Если ТипЗнч(ЗначениеДиаграммы) = Тип("ЗначениеДиаграммы") Тогда
		ПоказатьВыборИзСписка(Новый ОписаниеОповещения("ПослеВыбораКоманды", ЭтотОбъект), ЗначениеДиаграммы.Расшифровка);
	ИначеЕсли ТипЗнч(ЗначениеДиаграммы) = Тип("ТочкаДиаграммы") Тогда
		НаКлиенте.Показать(ЗначениеДиаграммы.Значение);
	КонецЕсли;
КонецПроцедуры

&НаКлиенте
Процедура ПослеВыбораКоманды(Элемент, ПараметрКоманды) Экспорт
	Если ТипЗнч(Элемент) = Тип("ЭлементСпискаЗначений") Тогда
		НаКлиенте.Показать(Элемент.Значение);
	КонецЕсли;
КонецПроцедуры

&НаКлиенте
Процедура КомандыПриИзменении(Элемент)
	ГрафикОбновить();
КонецПроцедуры

&НаКлиенте
Процедура КомандыОчистка(Элемент, СтандартнаяОбработка)
	Если _Команды.Количество() = 0 Тогда
		СтандартнаяОбработка	= Ложь;
		КомандыЗагрузить(Истина);
		ГрафикОбновить();
	КонецЕсли;
КонецПроцедуры

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	Если Параметры.Свойство("Команда") Тогда
		_Команды.Добавить(Параметры.Команда);
		ОбщегоНазначения.ЗаголовокСкрыть(ЭтаФорма, Элементы.ГруппаПараметры);
		
		График.ТипДиаграммы	= ТипДиаграммы.КруговаяОбъемная;
		
	ИначеЕсли Параметры.Свойство("Лига") Тогда
		КомандыЗагрузить(Параметры.Лига);
		ОбщегоНазначения.ЗаголовокСкрыть(ЭтаФорма, Элементы.ГруппаПараметры);
		
	ИначеЕсли Параметры.Свойство("Чемпионат") Тогда
		КомандыЗагрузить(Параметры.Чемпионат);
		ОбщегоНазначения.ЗаголовокСкрыть(ЭтаФорма, Элементы.ГруппаПараметры);
	КонецЕсли;
КонецПроцедуры

﻿
&НаСервере
Процедура ЧемпионатПриИзмененииНаСервере()
	Элементы.Команда.СписокВыбора.ЗагрузитьЗначения(КомандыЧемпионата());
	Если ЗначениеЗаполнено(Отчет.Команда) Тогда
		Если Элементы.Команда.СписокВыбора.НайтиПоЗначению(Отчет.Команда) = Неопределено Тогда
			Отчет.Команда	= Неопределено;
		КонецЕсли;
	Иначе
		Команда	= СерверныйФункции.МояКомандаПолучить();
		Если Элементы.Команда.СписокВыбора.НайтиПоЗначению(Команда) = Неопределено Тогда
			//
		Иначе
			Отчет.Команда	= Команда;
		КонецЕсли;
	КонецЕсли;
	СформироватьНаСервере();
КонецПроцедуры

&НаКлиенте
Процедура ЧемпионатПриИзменении(Элемент)
	ЧемпионатПриИзмененииНаСервере();
КонецПроцедуры

&НаСервере
Процедура СформироватьНаСервере()
	Если ЗначениеЗаполнено(Отчет.Чемпионат) И ЗначениеЗаполнено(Отчет.Команда) Тогда
		Результат = РеквизитФормыВЗначение("Отчет").ОтчетСформировать(Отчет);
		ГрафикОбновить();
	КонецЕсли;
КонецПроцедуры

&НаСервере
Процедура ГрафикОбновить()
	Если Элементы.График.Видимость Тогда
		СерверныйФункции.ГрафикОбновить(График, Отчет.Данные);
	КонецЕсли;
КонецПроцедуры

&НаКлиенте
Процедура Сформировать(Команда=Неопределено)
	Если ПроверитьЗаполнение() Тогда
		СформироватьНаСервере();
	КонецЕсли;
КонецПроцедуры

&НаСервере
Процедура НастройкиДефолт()
	Если НЕ ЗначениеЗаполнено(Отчет.Команда) Тогда
		Если ЗначениеЗаполнено(Отчет.Чемпионат) Тогда
			Команда	= СерверныйФункции.МояКомандаПолучить();
			КомандыЧемпионата = КомандыЧемпионата();
			Если КомандыЧемпионата.Найти(Команда) = Неопределено Тогда
				Если КомандыЧемпионата.Количество() > 0 Тогда
					Отчет.Команда	= КомандыЧемпионата.Получить(0);
				КонецЕсли;
			Иначе
				Отчет.Команда	= Команда;
			КонецЕсли;
		Иначе
			Отчет.Команда	= СерверныйФункции.МояКомандаПолучить();
			Отчет.Чемпионат	= СерверныйФункции.ЧемпионатПолучитьПоследнее(Отчет.Команда);
		КонецЕсли;
	КонецЕсли;
	Если НЕ ЗначениеЗаполнено(Отчет.Чемпионат) Тогда
		Отчет.Чемпионат = СерверныйФункции.ЧемпионатПолучитьПоследнее();
	КонецЕсли;
КонецПроцедуры

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	Если Параметры.Свойство("Команда") Тогда
		Отчет.Команда	= Параметры.Команда;
		Если Параметры.Свойство("Чемпионат") Тогда
			Отчет.Чемпионат	= Параметры.Чемпионат;
		Иначе
			Отчет.Чемпионат	= ЧемпионатПолучить(Параметры.Команда);
		КонецЕсли;
		ОбщегоНазначения.ЗаголовокСкрыть(ЭтаФорма, Элементы.ГруппаПараметры);
		
	ИначеЕсли Параметры.Свойство("Чемпионат") Тогда
		Отчет.Чемпионат	= Параметры.Чемпионат;
		ОбщегоНазначения.ЗаголовокСкрыть(ЭтаФорма, Элементы.Чемпионат);
	КонецЕсли;
	Если Параметры.Свойство("График") Тогда
		СерииЗаполнить();
	Иначе
		Элементы.График.Видимость	= Ложь;
	КонецЕсли;
КонецПроцедуры

&НаКлиенте
Процедура ПриОткрытии(Отказ)
	НастройкиДефолт();
	Сформировать();
КонецПроцедуры

&НаКлиенте
Процедура ПослеВыбораМатча(Элемент, ПараметрКоманды=Неопределено) Экспорт
	Если ТипЗнч(Элемент) = Тип("ЭлементСпискаЗначений") Тогда
		НаКлиенте.Показать(Элемент.Значение);
	КонецЕсли;
КонецПроцедуры

&НаКлиенте
Процедура ГрафикВыбор(Элемент, ЗначениеДиаграммы, СтандартнаяОбработка)
	СтандартнаяОбработка	= Ложь;
	Если ТипЗнч(ЗначениеДиаграммы) = Тип("ЗначениеДиаграммы") Тогда
		Матчи	= МатчиПолучить(Новый Структура("Команда,Результат", ЗначениеДиаграммы.Точка.Значение, ЗначениеДиаграммы.Серия.Значение));
		Если Матчи.Количество() = 1 Тогда
			ПослеВыбораМатча(Матчи.Получить(0));
		ИначеЕсли Матчи.Количество() > 0 Тогда
			ПоказатьВыборИзСписка(Новый ОписаниеОповещения("ПослеВыбораМатча", ЭтотОбъект), Матчи);
		КонецЕсли;
	КонецЕсли;
КонецПроцедуры

&НаСервере
Функция МатчиПолучить(Отбор)
	Запрос	= Новый Запрос("ВЫБРАТЬ РАЗЛИЧНЫЕ
	      	               |	ТурнирнаяТаблица.Регистратор КАК Значение,
	      	               |	Матчи.Ссылка.Счет КАК Представление,
	      	               |	ТурнирнаяТаблица.Период КАК Период
	      	               |ИЗ
	      	               |	РегистрНакопления.ТурнирнаяТаблица КАК ТурнирнаяТаблица
	      	               |		ВНУТРЕННЕЕ СОЕДИНЕНИЕ Документ.Матч.Команды КАК Матчи
	      	               |		ПО ТурнирнаяТаблица.Регистратор = Матчи.Ссылка
	      	               |ГДЕ
	      	               |	ТурнирнаяТаблица.Команда = &Команда
	      	               |	И ТурнирнаяТаблица.КоличествоОчков = &КоличествоОчков
	      	               |	И ТурнирнаяТаблица.Тур.Владелец = &Чемпионат
	      	               |	И Матчи.Команда = &Противник
	      	               |
	      	               |УПОРЯДОЧИТЬ ПО
	      	               |	Период УБЫВ");
	Запрос.УстановитьПараметр("Чемпионат",			Отчет.Чемпионат);
	Запрос.УстановитьПараметр("Команда",			Отчет.Команда);
	Запрос.УстановитьПараметр("Противник",			Отбор.Команда);
	Запрос.УстановитьПараметр("КоличествоОчков",	?(СтрСравнить(Отбор.Результат, "Проигрыш")=0, 0, 1));
	Если СтрСравнить(Отбор.Результат, "Выигрыш") = 0 Тогда
		Запрос.Текст = "ВЫБРАТЬ РАЗЛИЧНЫЕ
		               |	ТурнирнаяТаблица.Регистратор КАК Значение,
		               |	Матчи.Ссылка.Счет КАК Представление,
		               |	ТурнирнаяТаблица.Период КАК Период
		               |ИЗ
		               |	РегистрНакопления.ТурнирнаяТаблица КАК ТурнирнаяТаблица
		               |		ВНУТРЕННЕЕ СОЕДИНЕНИЕ Документ.Матч КАК Матчи
		               |		ПО ТурнирнаяТаблица.Регистратор = Матчи.Ссылка
		               |ГДЕ
		               |	ТурнирнаяТаблица.Команда = &Команда
		               |	И ТурнирнаяТаблица.КоличествоОчков >= 2
		               |	И ТурнирнаяТаблица.Тур.Владелец = &Чемпионат
		               |	И Матчи.Команды.Команда = &Противник
		               |
		               |УПОРЯДОЧИТЬ ПО
		               |	Период УБЫВ";
	КонецЕсли;
	Возврат СерверныйФункции.Выборка2СписокЗначений(Запрос.Выполнить().Выбрать());
КонецФункции

&НаСервере
Функция КомандыЧемпионата()
	Возврат СерверныйФункции.КомандыЧемпионата(Отчет.Чемпионат);
КонецФункции

&НаСервере
Функция ЧемпионатПолучить(Команда)
	Возврат СерверныйФункции.ЧемпионатПолучитьПоследнее(Команда);
КонецФункции

&НаКлиенте
Процедура КомандаПриИзменении(Элемент)
	СформироватьНаСервере();
КонецПроцедуры

&НаКлиенте
Процедура ОбработкаОповещения(ИмяСобытия, Параметр, Источник)
	Если ТипЗнч(Параметр) = Тип("СправочникСсылка.Чемпионаты") И Параметр = Отчет.Чемпионат Тогда
		СформироватьНаСервере();
	КонецЕсли;
КонецПроцедуры

&НаСервере
Процедура СерииЗаполнить()
	СерверныйФункции.СерииЗаполнить(График);
КонецПроцедуры

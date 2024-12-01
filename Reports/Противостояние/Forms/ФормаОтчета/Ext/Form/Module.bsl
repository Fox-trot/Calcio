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
		Результат = РеквизитФормыВЗначение("Отчет").ОтчетСформировать();
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
		ЭтаФорма.АвтоматическоеСохранениеДанныхВНастройках = АвтоматическоеСохранениеДанныхФормыВНастройках.НеИспользовать;
		Отчет.Команда	= Параметры.Команда;
		Если Параметры.Свойство("Чемпионат") Тогда
			Отчет.Чемпионат	= Параметры.Чемпионат;
		Иначе
			Отчет.Чемпионат	= ЧемпионатПолучить(Параметры.Команда);
		КонецЕсли;
	ИначеЕсли Параметры.Свойство("Чемпионат") Тогда
		ЭтаФорма.АвтоматическоеСохранениеДанныхВНастройках = АвтоматическоеСохранениеДанныхФормыВНастройках.НеИспользовать;
		Отчет.Чемпионат	= Параметры.Чемпионат;
	КонецЕсли;
КонецПроцедуры

&НаКлиенте
Процедура ПриОткрытии(Отказ)
	НастройкиДефолт();
	ЧемпионатПриИзмененииНаСервере();
КонецПроцедуры

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

﻿
&НаСервере
Процедура СформироватьНаСервере()
	ЭтаФорма.Результат = Отчеты.ТурнирнаяТаблица.ОтчетСформировать(Отчет.Чемпионат, Отчет.ПоказыватьРазницуМячей);
КонецПроцедуры

&НаКлиенте
Процедура Сформировать(Команда=Неопределено)
	Если ПроверитьЗаполнение() Тогда
		СформироватьНаСервере();
	КонецЕсли;
КонецПроцедуры

&НаКлиенте
Процедура ПриОткрытии(Отказ)
	Сформировать();
КонецПроцедуры

&НаКлиенте
Процедура ОбработкаОповещения(ИмяСобытия, Параметр, Источник)
	Если ИмяСобытия = "СписокМатчиОбновить" Тогда
		Сформировать();
	КонецЕсли;
КонецПроцедуры

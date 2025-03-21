﻿
&НаКлиенте
Процедура ПриОткрытии(Отказ)
	ТекущиеПриИзмененииНаСервере();
КонецПроцедуры

&НаСервере
Процедура ТекущиеПриИзмененииНаСервере()
	ОтборЭлемент = Неопределено;
	Для Каждого тЭлемент Из Список.Отбор.Элементы Цикл
		Если СтрСравнить(тЭлемент.Представление, "Текущие") = 0 Тогда
			ОтборЭлемент	= тЭлемент;
			Прервать;
		КонецЕсли;
	КонецЦикла;
	Если ОтборЭлемент = Неопределено Тогда
		ОтборЭлемент	= Список.Отбор.Элементы.Добавить(Тип("ЭлементОтбораКомпоновкиДанных"));
		ОтборЭлемент.ВидСравнения	= ВидСравненияКомпоновкиДанных.БольшеИлиРавно;
		ОтборЭлемент.ЛевоеЗначение	= Новый ПолеКомпоновкиДанных("ДатаОкончания");
		ОтборЭлемент.ПравоеЗначение	= КонецДня(ТекущаяДатаСеанса());
		ОтборЭлемент.Представление	= "Текущие";
	КонецЕсли;
	ОтборЭлемент.Использование = Текущие;
КонецПроцедуры

&НаКлиенте
Процедура ТекущиеПриИзменении(Элемент)
	ТекущиеПриИзмененииНаСервере();
КонецПроцедуры

﻿
Процедура ОбработкаЗаполнения(ДанныеЗаполнения, ТекстЗаполнения, СтандартнаяОбработка)
	Если ТипЗнч(ДанныеЗаполнения) = Тип("СправочникСсылка.Страны") Тогда
		Владелец	= ДанныеЗаполнения;
	ИначеЕсли ТипЗнч(ДанныеЗаполнения) = Тип("Структура") Тогда
		Если ДанныеЗаполнения.Свойство("Владелец") Тогда
			ОбработкаЗаполнения(ДанныеЗаполнения.Владелец, ТекстЗаполнения, Ложь);
		КонецЕсли;
	ИначеЕсли ТипЗнч(ДанныеЗаполнения) = Тип("СписокЗначений") Тогда
		Для Каждого ТекЭлемент Из ДанныеЗаполнения Цикл
			ОбработкаЗаполнения(ТекЭлемент.Значение, ТекстЗаполнения, Ложь);
			Прервать;
		КонецЦикла;
	ИначеЕсли ТипЗнч(ДанныеЗаполнения) = Тип("Массив") Тогда
		Для Каждого ТекЭлемент Из ДанныеЗаполнения Цикл
			ОбработкаЗаполнения(ТекЭлемент, ТекстЗаполнения, Ложь);
			Прервать;
		КонецЦикла;
	КонецЕсли;
КонецПроцедуры

﻿
&НаКлиенте
Процедура ОбработкаОповещения(ИмяСобытия, Параметр, Источник)
	Если СтрСравнить(ИмяСобытия, "Матчи") = 0 Тогда
		Элементы.Список.Обновить();
	КонецЕсли;
КонецПроцедуры

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	Если Параметры.Свойство("Отбор") <> Неопределено Тогда
		Список.АвтоматическоеСохранениеПользовательскихНастроек	= Ложь;
	КонецЕсли;
КонецПроцедуры

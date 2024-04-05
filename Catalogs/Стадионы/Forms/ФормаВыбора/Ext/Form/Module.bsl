﻿
&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	Если Параметры.Свойство("Чемпионат") Тогда
		Список.Параметры.УстановитьЗначениеПараметра("Чемпионат", Параметры.Чемпионат);
	ИначеЕсли Параметры.Свойство("ТекущаяСтрока") Тогда
		Список.Параметры.УстановитьЗначениеПараметра("Чемпионат", ЧемпионатПолучитьПоследнее(Параметры.ТекущаяСтрока));
	Иначе
		Список.Параметры.УстановитьЗначениеПараметра("Чемпионат", Справочники.Чемпионаты.ПустаяСсылка());
	КонецЕсли;
КонецПроцедуры

&НаСервере
Функция ЧемпионатПолучитьПоследнее(Стадиум)
	Возврат СерверныйФункции.ЧемпионатПолучитьПоследнее(Стадиум);
КонецФункции

﻿
&НаКлиенте
Процедура ОбработкаКоманды(ПараметрКоманды, ПараметрыВыполненияКоманды)
	ПоказатьВопрос(Новый ОписаниеОповещения("ПервоначальноеЗаполнение", ЭтотОбъект), "Точно?", РежимДиалогаВопрос.ОКОтмена, 60, КодВозвратаДиалога.Отмена, "Первоначальное заполнение");
КонецПроцедуры

&НаКлиенте
Процедура ПервоначальноеЗаполнение(Данные, ДопПараметры) Экспорт
	Если Данные = КодВозвратаДиалога.ОК Тогда
		СерверныйФункции.ПервоначальноеЗаполнение();
	КонецЕсли;
КонецПроцедуры

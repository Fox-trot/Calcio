﻿
&НаКлиенте
Процедура ОбработкаКоманды(ПараметрКоманды, ПараметрыВыполненияКоманды)
	Если ТипЗнч(ПараметрКоманды) = Тип("СправочникСсылка.Туры") Тогда
		НаКлиенте.ОбработкаКомандыОткрытьФорму("Документ.Матч.ФормаСписка", Новый Структура("Отбор", Новый Структура("Тур,ПометкаУдаления", ПараметрКоманды, Ложь)), ПараметрыВыполненияКоманды);
	Иначе
		НаКлиенте.ОбработкаКомандыОткрытьФорму("Документ.Матч.ФормаСписка", Новый Структура("Отбор", Новый Структура("Тур,ПометкаУдаления", ТурыЧемпионата(ПараметрКоманды), Ложь)), ПараметрыВыполненияКоманды);
	КонецЕсли;
КонецПроцедуры

&НаСервере
Функция ТурыЧемпионата(Чемпионат)
	Возврат СерверныйФункции.ТурыЧемпионата(Чемпионат);
КонецФункции

﻿
&НаКлиенте
Процедура ОбработкаКоманды(ПараметрКоманды, ПараметрыВыполненияКоманды)
	Если ТипЗнч(ПараметрКоманды) = Тип("СправочникСсылка.Команды") Тогда
		НаКлиенте.ОбработкаКомандыОткрытьФорму("Отчет.Противостояние.Форма", Новый Структура("Команда", ПараметрКоманды), ПараметрыВыполненияКоманды);
	ИначеЕсли ТипЗнч(ПараметрКоманды) = Тип("СправочникСсылка.Чемпионаты") Тогда
		НаКлиенте.ОбработкаКомандыОткрытьФорму("Отчет.Противостояние.Форма", Новый Структура("Чемпионат", ПараметрКоманды), ПараметрыВыполненияКоманды);
	КонецЕсли;
КонецПроцедуры

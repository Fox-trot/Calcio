﻿
&НаКлиенте
Процедура ОбработкаКоманды(ПараметрКоманды, ПараметрыВыполненияКоманды)
	Если ТипЗнч(ПараметрКоманды) = Тип("СправочникСсылка.Команды") Тогда
		ОткрытьФорму("Отчет.ВозрастныеГруппы.Форма", Новый Структура("Команда", ПараметрКоманды), ПараметрыВыполненияКоманды.Источник, ПараметрыВыполненияКоманды.Уникальность, ПараметрыВыполненияКоманды.Окно, ПараметрыВыполненияКоманды.НавигационнаяСсылка);
	ИначеЕсли ТипЗнч(ПараметрКоманды) = Тип("СправочникСсылка.Лига") Тогда
		ОткрытьФорму("Отчет.ВозрастныеГруппы.Форма", Новый Структура("Лига", ПараметрКоманды), ПараметрыВыполненияКоманды.Источник, ПараметрыВыполненияКоманды.Уникальность, ПараметрыВыполненияКоманды.Окно, ПараметрыВыполненияКоманды.НавигационнаяСсылка);
	ИначеЕсли ТипЗнч(ПараметрКоманды) = Тип("СправочникСсылка.Чемпионаты") Тогда
		ОткрытьФорму("Отчет.ВозрастныеГруппы.Форма", Новый Структура("Чемпионат", ПараметрКоманды), ПараметрыВыполненияКоманды.Источник, ПараметрыВыполненияКоманды.Уникальность, ПараметрыВыполненияКоманды.Окно, ПараметрыВыполненияКоманды.НавигационнаяСсылка);
	КонецЕсли;
КонецПроцедуры

﻿
&НаКлиенте
Процедура ОбработкаКоманды(ПараметрКоманды, ПараметрыВыполненияКоманды)
	Если ТипЗнч(ПараметрКоманды) = Тип("СправочникСсылка.Команды") Тогда
		ОткрытьФорму("Отчет.Хронология.Форма", Новый Структура("Команда", ПараметрКоманды), ПараметрыВыполненияКоманды.Источник, ПараметрыВыполненияКоманды.Уникальность, ПараметрыВыполненияКоманды.Окно, ПараметрыВыполненияКоманды.НавигационнаяСсылка);
	Иначе
		ОткрытьФорму("Отчет.Хронология.Форма", Новый Структура("Чемпионат", ПараметрКоманды), ПараметрыВыполненияКоманды.Источник, ПараметрыВыполненияКоманды.Уникальность, ПараметрыВыполненияКоманды.Окно, ПараметрыВыполненияКоманды.НавигационнаяСсылка);
	КонецЕсли;
КонецПроцедуры

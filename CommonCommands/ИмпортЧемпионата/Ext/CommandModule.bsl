﻿
&НаКлиенте
Процедура ОбработкаКоманды(ПараметрКоманды, ПараметрыВыполненияКоманды)
	УРЛ = УРЛ(ПараметрКоманды);
	ПоказатьВводСтроки(Новый ОписаниеОповещения("Импорт", ЭтотОбъект, ПараметрКоманды), УРЛ, "Импорт чемпионата");
КонецПроцедуры

&НаКлиенте
Процедура Импорт(УРЛ, Чемпионат) Экспорт
	Если НЕ ПустаяСтрока(УРЛ) Тогда
		Если ИмпортНаСервере(УРЛ, Чемпионат) Тогда
			Оповестить("Матчи", Чемпионат);
		КонецЕсли;
	КонецЕсли;
КонецПроцедуры

&НаСервере
Функция ИмпортНаСервере(Гиперссылка, Чемпионат)
	Возврат СерверныйФункции.ИмпортЧемпионата(Гиперссылка, Чемпионат);
КонецФункции

&НаСервере
Функция УРЛ(Чемпионат)
	Возврат СтрШаблон("https://football.kulichki.net/england/%1/", Формат(Год(Чемпионат.ДатаОкончания), "ЧГ=0"));
КонецФункции

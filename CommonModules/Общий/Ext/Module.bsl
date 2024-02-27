﻿
Функция Сутки(Количество=1) Экспорт
	Возврат 86400 * Количество;
КонецФункции

Функция СтрокаКакЧисло(Слово) Экспорт
	Ответ = 0;
	Если НЕ ПустаяСтрока(Слово) Тогда
		Попытка Ответ = Число(Слово); Исключение КонецПопытки;
	КонецЕсли;
	Возврат Ответ;
КонецФункции

Функция СтрокаСодержитЧисло(Слово) Экспорт
	Если НЕ ПустаяСтрока(Слово) Тогда
		Для Число = 0 По 9 Цикл
			Если СтрНайти(Слово, Формат(Число, "ЧН=0; ЧГ=0")) > 0 Тогда
				Возврат Истина;
			КонецЕсли;
		КонецЦикла;
	КонецЕсли;
	Возврат Ложь;
КонецФункции

Функция Возраст(Дата) Экспорт
	Возврат СтрокаСЧислом(";%1 год;%1 года;%1 года;%1 лет;", Цел(Макс(0, ТекущаяДата() - Дата) / Сутки(365)), ВидЧисловогоЗначения.Количественное);
КонецФункции

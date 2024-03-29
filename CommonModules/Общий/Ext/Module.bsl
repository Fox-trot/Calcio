﻿
Функция Сутки(Количество=1) Экспорт
	Возврат 86400 * Количество;
КонецФункции

Функция СтрокаКакМесяц(Слово) Экспорт
	Ответ = 0;
	Если ПустаяСтрока(Слово) Тогда
	ИначеЕсли СтрНайти(НРег(Слово), "янв") > 0 Тогда
		Ответ = 1;
	ИначеЕсли СтрНайти(НРег(Слово), "фев") > 0 Тогда
		Ответ = 2;
	ИначеЕсли СтрНайти(НРег(Слово), "мар") > 0 Тогда
		Ответ = 3;
	ИначеЕсли СтрНайти(НРег(Слово), "апр") > 0 Тогда
		Ответ = 4;
	ИначеЕсли СтрНайти(НРег(Слово), "мая") > 0 Тогда
		Ответ = 5;
	ИначеЕсли СтрНайти(НРег(Слово), "июн") > 0 Тогда
		Ответ = 6;
	ИначеЕсли СтрНайти(НРег(Слово), "июл") > 0 Тогда
		Ответ = 7;
	ИначеЕсли СтрНайти(НРег(Слово), "авг") > 0 Тогда
		Ответ = 8;
	ИначеЕсли СтрНайти(НРег(Слово), "сен") > 0 Тогда
		Ответ = 9;
	ИначеЕсли СтрНайти(НРег(Слово), "окт") > 0 Тогда
		Ответ = 10;
	ИначеЕсли СтрНайти(НРег(Слово), "ноя") > 0 Тогда
		Ответ = 11;
	ИначеЕсли СтрНайти(НРег(Слово), "дек") > 0 Тогда
		Ответ = 12;
	КонецЕсли;
	Возврат Ответ;
КонецФункции

Функция СтрокаКакЧисло(Слово) Экспорт
	Ответ = 0;
	Если НЕ ПустаяСтрока(Слово) Тогда
		Попытка Ответ = Число(Слово); Исключение КонецПопытки;
	КонецЕсли;
	Возврат Ответ;
КонецФункции

Функция СтрокаНачинаетсяЧислом(Слово) Экспорт
	Если НЕ ПустаяСтрока(Слово) Тогда
		Возврат (СтрНайти("1234567890", Лев(СокрЛ(Слово), 1)) > 0);
	КонецЕсли;
	Возврат Ложь;
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

Функция Разделить(Слово, Разделитель=" ") Экспорт
	Возврат СтрРазделить(Слово, Разделитель, Ложь);
КонецФункции

Функция ЭтоУРЛ(Слово) Экспорт
	Ответ = Ложь;
	Если ПустаяСтрока(Слово) Тогда
		//
	ИначеЕсли СтрСравнить(Лев(СокрЛ(Слово), 6), "https:") = 0 Тогда
		Ответ = Истина;
	ИначеЕсли СтрСравнить(Лев(СокрЛ(Слово), 5), "http:") = 0 Тогда
		Ответ = Истина;
	КонецЕсли;
	Возврат Ответ;
КонецФункции

Функция ИмяФайла(Знач Слово) Экспорт
	Если СтрНайти(Слово, "/") > 0 Тогда
		Слова = Разделить(Слово, "/");
	ИначеЕсли СтрНайти(Слово, "\") > 0 Тогда
		Слова = Разделить(Слово, "\");
	Иначе
		Возврат Слово;
	КонецЕсли;
	Для Каждого Слово Из Слова Цикл
	КонецЦикла;
	Возврат Слово;
КонецФункции

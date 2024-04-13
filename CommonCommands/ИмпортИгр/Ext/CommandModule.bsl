﻿//	https://football.kulichki.net/england/2019/26/

&НаКлиенте
Процедура ОбработкаКоманды(ПараметрКоманды, ПараметрыВыполненияКоманды)
	УРЛ = УРЛ(ПараметрКоманды);
	ПоказатьВводСтроки(Новый ОписаниеОповещения("Импорт", ЭтотОбъект, ПараметрКоманды), УРЛ, "Импорт игр");
КонецПроцедуры

&НаСервере
Функция УРЛ(Тур)
	Ответ = СерверныйФункции.КомментарийКакУРЛ(Тур.Комментарий);
	Если ПустаяСтрока(Ответ) Тогда
		Запрос = Новый Запрос("ВЫБРАТЬ
		                      |	Лига.Комментарий КАК Комментарий,
		                      |	Чемпионаты.ДатаОкончания КАК ДатаОкончания,
		                      |	Туры.Код КАК Код
		                      |ИЗ
		                      |	Справочник.Туры КАК Туры
		                      |		ВНУТРЕННЕЕ СОЕДИНЕНИЕ Справочник.Чемпионаты КАК Чемпионаты
		                      |			ВНУТРЕННЕЕ СОЕДИНЕНИЕ Справочник.Лига КАК Лига
		                      |			ПО Чемпионаты.Владелец = Лига.Ссылка
		                      |		ПО Туры.Владелец = Чемпионаты.Ссылка
		                      |ГДЕ
		                      |	Туры.Ссылка = &Тур
		                      |
		                      |ОБЪЕДИНИТЬ ВСЕ
		                      |
		                      |ВЫБРАТЬ
		                      |	Чемпионаты.Комментарий,
		                      |	Чемпионаты.ДатаОкончания,
		                      |	Туры.Код
		                      |ИЗ
		                      |	Справочник.Туры КАК Туры
		                      |		ВНУТРЕННЕЕ СОЕДИНЕНИЕ Справочник.Чемпионаты КАК Чемпионаты
		                      |		ПО Туры.Владелец = Чемпионаты.Ссылка
		                      |ГДЕ
		                      |	Туры.Ссылка = &Тур");
		Запрос.УстановитьПараметр("Тур",			Тур);
		Выборка = Запрос.Выполнить().Выбрать();
		Пока ПустаяСтрока(Ответ) И Выборка.Следующий() Цикл
			Ответ = СерверныйФункции.КомментарийКакУРЛ(Выборка.Комментарий);
			Если НЕ ПустаяСтрока(Ответ) Тогда
				Если СтрНайти(Ответ, "/%1/") > 0 И СтрНайти(Ответ, "/%2/") > 0 Тогда
					Ответ = СтрШаблон(Ответ, ФорматЧГ(Выборка.ДатаОкончания), ФорматЧГ(Выборка.Код));
				Иначе
					Ответ = СтрШаблон(Ответ + "%1/%2/", ФорматЧГ(Выборка.ДатаОкончания), ФорматЧГ(Выборка.Код));
				КонецЕсли;
			КонецЕсли;
		КонецЦикла;
	КонецЕсли;
	Возврат Ответ;
КонецФункции

&НаКлиенте
Процедура Импорт(УРЛ, Тур) Экспорт
	Если НЕ ПустаяСтрока(УРЛ) Тогда
		Если ИмпортНаСервере(УРЛ, Тур) Тогда
			Оповестить("Матчи", Чемпионат(Тур));
		КонецЕсли;
	КонецЕсли;
КонецПроцедуры

&НаСервере
Функция ИмпортНаСервере(Гиперссылка, Тур)
	Возврат СерверныйФункции.ИмпортИгр(Гиперссылка, Тур);
КонецФункции

&НаСервере
Функция Чемпионат(Тур)
	Возврат Тур.Владелец;
КонецФункции

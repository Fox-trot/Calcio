﻿
&НаКлиенте
Процедура КодПриИзменении(Элемент=Неопределено)
	Если Объект.Ссылка.Пустая() Или ПустаяСтрока(Объект.Наименование) Тогда
		Объект.Наименование = Строка(Объект.Код) + "-й тур";
	КонецЕсли;
КонецПроцедуры

&НаКлиенте
Процедура ПриОткрытии(Отказ)
	Если Объект.Ссылка.Пустая() Тогда
		//Если Объект.Код = 0 Тогда
			Объект.Код = КодНовыйПолучить(Объект.Владелец);
		//КонецЕсли;
		КодПриИзменении();
		//Если ПустаяСтрока(Объект.Владелец) Тогда
		//	Объект.Владелец = ЧемпионатЛигиПоследний();
		//КонецЕсли;
	Иначе
		ДоступностьУстановить();
	КонецЕсли;
КонецПроцедуры

&НаКлиенте
Процедура ДоступностьУстановить()
	Элементы.Владелец.Доступность = НЕ ЕстьМатчи(Объект.Ссылка);
КонецПроцедуры

&НаСервере
Функция ЧемпионатЛигиПоследний(Лига)
	Возврат СерверныйФункции.ЧемпионатЛигиПоследний(Лига);
КонецФункции

&НаСервере
Функция КодНовыйПолучить(Чемпионат)
	Возврат СерверныйФункции.ТурКодНовыйПолучить(Чемпионат);
КонецФункции

&НаКлиенте
Процедура ВладелецПриИзменении(Элемент)
	Объект.Код = КодНовыйПолучить(Объект.Владелец);
КонецПроцедуры

&НаСервере
Функция ЕстьМатчи(Знач Тур)
	Если Тур.Пустая() Тогда Возврат Ложь; КонецЕсли;
	Запрос = Новый Запрос("ВЫБРАТЬ
	                      |	ЕСТЬNULL(МАКСИМУМ(Матч.Дата), &Дата) КАК Дата
	                      |ИЗ
	                      |	Документ.Матч КАК Матч
	                      |ГДЕ
	                      |	Матч.Тур = &Тур");
	Запрос.УстановитьПараметр("Тур",	Тур);
	Запрос.УстановитьПараметр("Дата",	Дата(1, 1, 1));
	Выборка = Запрос.Выполнить().Выбрать();
	Возврат (Выборка.Следующий() И Год(Выборка.Дата) > 1);
КонецФункции

﻿
&НаКлиенте
Процедура МатчиВыбор(Элемент, ВыбраннаяСтрока, Поле, СтандартнаяОбработка)
	ОткрытьЗначение(Элемент.ТекущиеДанные.Матч);
КонецПроцедуры

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	Если Объект.Ссылка.Пустая() Тогда
		Объект.Владелец	= Справочники.ВидыСпорта.НайтиПоНаименованию("Футбол");
	Иначе
		Матчи.Параметры.УстановитьЗначениеПараметра("Ссылка", Объект.Ссылка);
		ТекущийСостав.Параметры.УстановитьЗначениеПараметра("Ссылка", Объект.Ссылка);
	КонецЕсли;
КонецПроцедуры

&НаКлиенте
Процедура ПриОткрытии(Отказ)
	Если Объект.Ссылка.Пустая() Тогда
		Элементы.Группа1.ТекущаяСтраница = Элементы.ОсновнаяИнформация;
	Иначе
		Элементы.Группа1.ТекущаяСтраница = Элементы.ГруппаМатчи;
	КонецЕсли;
КонецПроцедуры

&НаСервере
Процедура ПослеЗаписиНаСервере(ТекущийОбъект, ПараметрыЗаписи)
	Матчи.Параметры.УстановитьЗначениеПараметра("Ссылка", Объект.Ссылка);
	ТекущийСостав.Параметры.УстановитьЗначениеПараметра("Ссылка", Объект.Ссылка);
КонецПроцедуры

&НаКлиенте
Процедура ОбработкаОповещения(ИмяСобытия, Параметр, Источник)
	Если ТипЗнч(Параметр) = Тип("СправочникСсылка.Команды")
	И Параметр = Объект.Ссылка
	Тогда
		Элементы.Матчи.Обновить();
		Элементы.ТекущийСостав.Обновить();
	КонецЕсли;
КонецПроцедуры

&НаСервере
Функция ИсключитьНаСервере(Ссылка)
	Ответ = Ложь;
	Если ТипЗнч(Ссылка) = Тип("СправочникСсылка.Игроки") Тогда
		Ссылка.ПолучитьОбъект().УстановитьПометкуУдаления(НЕ Ссылка.ПометкаУдаления);
		Ответ = Истина;
	КонецЕсли;
	Возврат Ответ;
КонецФункции

&НаКлиенте
Процедура Исключить(Команда)
	Если ИсключитьНаСервере(Элементы.ТекущийСостав.ТекущиеДанные.Игрок) Тогда
		Элементы.ТекущийСостав.Обновить();
	КонецЕсли;
КонецПроцедуры

&НаСервере
Функция СезонНаСервере()
	Сезон.Очистить();
	ТекЧемпионат = СерверныйФункции.ЧемпионатПолучитьПоследнее(Объект.Ссылка);
	Если ЗначениеЗаполнено(ТекЧемпионат) Тогда
		МестоВЧемпионате = СерверныйФункции.МестоВЧемпионате(Объект.Ссылка, ТекЧемпионат);
		Если МестоВЧемпионате <> 0 Тогда
			нСтрока = Сезон.Добавить();
			нСтрока.Ключ		= "Место";
			нСтрока.Значение	= МестоВЧемпионате;
		КонецЕсли;
		Стат	= СерверныйФункции.СтатистикаИгр(Объект.Ссылка, ТекЧемпионат);
		Для Каждого ТекЭлемент Из Стат Цикл
			ЗаполнитьЗначенияСвойств(Сезон.Добавить(), ТекЭлемент);
		КонецЦикла;
	КонецЕсли;
	Возврат Строка(ТекЧемпионат);
КонецФункции

&НаКлиенте
Процедура СезонОбновитьНаКлиенте()
	Слово = СезонНаСервере();
	Элементы.ГруппаСезон.Заголовок = ?(ПустаяСтрока(Слово), "Сезон", "Сезон (" + Слово + ")");
КонецПроцедуры

&НаКлиенте
Процедура СезонОбновить(Команда)
	СезонОбновитьНаКлиенте();
КонецПроцедуры

&НаКлиенте
Процедура Группа1ПриСменеСтраницы(Элемент, ТекущаяСтраница)
	Если ТекущаяСтраница.Имя = "ГруппаСезон" И Сезон.Количество() = 0 Тогда
		СезонОбновитьНаКлиенте();
	КонецЕсли;
КонецПроцедуры

&НаКлиенте
Процедура ТекущийСоставВыбор(Элемент, ВыбраннаяСтрока, Поле, СтандартнаяОбработка)
	СтандартнаяОбработка = Ложь;
	ОткрытьЗначение(Элемент.ТекущиеДанные.Игрок);
КонецПроцедуры

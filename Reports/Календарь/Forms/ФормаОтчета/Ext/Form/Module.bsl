﻿
&НаКлиенте
Процедура ДатыУстановить()
	Отчет.Период.ДатаНачала		= НачалоМесяца(ТекущаяДата());
	Отчет.Период.ДатаОкончания	= КонецМесяца(Отчет.Период.ДатаНачала);
КонецПроцедуры

&НаКлиенте
Процедура КомандаСегодня(Команда)
	ДатыУстановить();
	КомандаОбновить();
КонецПроцедуры

&НаКлиенте
Процедура ОбработкаОповещения(ИмяСобытия, Параметр, Источник)
	Если Игрок = Параметр Тогда
		Игрок = Неопределено;
		ИзображениеУстановить(Элементы.Данные.ТекущиеДанные.ИгрокИлиМатч, Игрок, Изображение);
	КонецЕсли;
КонецПроцедуры

&НаКлиенте
Процедура ЭлементПриИзменении(Элемент)
	КомандаОбновить();
КонецПроцедуры

&НаКлиенте
Процедура ПриОткрытии(Отказ)
	ИзображениеДефолт	= ИзображениеДефолтПолучить();
	Если НЕ ЗначениеЗаполнено(Отчет.Период) Тогда
		ДатыУстановить();
	КонецЕсли;
	Если НЕ ЗначениеЗаполнено(Отчет.Команда) Тогда
		Отчет.Команда		= МояКоманда();
	КонецЕсли;
	КомандаОбновить();
КонецПроцедуры

&НаСервере
Процедура ДанныеЗагрузитьНаСервере()
	Отчет.Данные.Очистить();
	
	Запрос = Новый Запрос("ВЫБРАТЬ РАЗЛИЧНЫЕ
	                      |	Игроки.ДатаРождения КАК Дата,
	                      |	ПеремещенияИгроков.Игрок КАК ИгрокИлиМатч,
	                      |	ИСТИНА КАК ЭтоИгрок,
	                      |	МЕСЯЦ(Игроки.ДатаРождения) * 100 + ДЕНЬ(Игроки.ДатаРождения) КАК Порядок,
	                      |	Игроки.Представление КАК Представление
	                      |ИЗ
	                      |	РегистрСведений.ПеремещенияИгроков КАК ПеремещенияИгроков
	                      |		ВНУТРЕННЕЕ СОЕДИНЕНИЕ Справочник.Игроки КАК Игроки
	                      |		ПО ПеремещенияИгроков.Игрок = Игроки.Ссылка
	                      |ГДЕ
	                      |	ПеремещенияИгроков.Команда = &Команда
	                      |	И МЕСЯЦ(Игроки.ДатаРождения) * 100 + ДЕНЬ(Игроки.ДатаРождения) МЕЖДУ &Дата1 И &Дата2
	                      |
	                      |ОБЪЕДИНИТЬ ВСЕ
	                      |
	                      |ВЫБРАТЬ
	                      |	Матч.Дата,
	                      |	Матч.Ссылка,
	                      |	ЛОЖЬ,
	                      |	МЕСЯЦ(Матч.Дата) * 100 + ДЕНЬ(Матч.Дата) + 0.1,
	                      |	Матч.Представление
	                      |ИЗ
	                      |	Документ.Матч.Команды КАК МатчКоманды
	                      |		ВНУТРЕННЕЕ СОЕДИНЕНИЕ Документ.Матч КАК Матч
	                      |		ПО МатчКоманды.Ссылка = Матч.Ссылка
	                      |ГДЕ
	                      |	Матч.Дата МЕЖДУ &ДатаН И &ДатаК
	                      |	И МатчКоманды.Команда = &Команда
	                      |	И ВЫБОР
	                      |			КОГДА Матч.Дата <= &Дата
	                      |				ТОГДА Матч.Проведен = ИСТИНА
	                      |			ИНАЧЕ Матч.ПометкаУдаления = ЛОЖЬ
	                      |		КОНЕЦ
	                      |
	                      |УПОРЯДОЧИТЬ ПО
	                      |	Порядок,
	                      |	Представление");
	Если Отчет.ТолькоДниРождения Тогда
		Запрос.Текст = "ВЫБРАТЬ РАЗЛИЧНЫЕ
		               |	Игроки.ДатаРождения КАК Дата,
		               |	ПеремещенияИгроков.Игрок КАК ИгрокИлиМатч,
		               |	ИСТИНА КАК ЭтоИгрок,
		               |	МЕСЯЦ(Игроки.ДатаРождения) * 100 + ДЕНЬ(Игроки.ДатаРождения) КАК Порядок,
		               |	Игроки.Представление КАК Представление
		               |ИЗ
		               |	РегистрСведений.ПеремещенияИгроков КАК ПеремещенияИгроков
		               |		ВНУТРЕННЕЕ СОЕДИНЕНИЕ Справочник.Игроки КАК Игроки
		               |		ПО ПеремещенияИгроков.Игрок = Игроки.Ссылка
		               |ГДЕ
		               |	ПеремещенияИгроков.Команда = &Команда
		               |	И МЕСЯЦ(Игроки.ДатаРождения) * 100 + ДЕНЬ(Игроки.ДатаРождения) МЕЖДУ &Дата1 И &Дата2
		               |
		               |УПОРЯДОЧИТЬ ПО
		               |	Порядок,
		               |	Представление";
	КонецЕсли;
	Запрос.УстановитьПараметр("Команда",		Отчет.Команда);
	Запрос.УстановитьПараметр("Дата1",			Месяц(Отчет.Период.ДатаНачала) * 100 + День(Отчет.Период.ДатаНачала));
	Запрос.УстановитьПараметр("Дата2",			Месяц(Отчет.Период.ДатаОкончания) * 100 + День(Отчет.Период.ДатаОкончания));
	Запрос.УстановитьПараметр("Дата",			КонецДня(ТекущаяДатаСеанса()));
	Запрос.УстановитьПараметр("ДатаН",			Отчет.Период.ДатаНачала);
	Запрос.УстановитьПараметр("ДатаК",			Отчет.Период.ДатаОкончания);
	Выборка = Запрос.Выполнить().Выбрать();
	Пока Выборка.Следующий() Цикл
		ЗаполнитьЗначенияСвойств(Отчет.Данные.Добавить(), Выборка);
	КонецЦикла;
КонецПроцедуры

&НаСервере
Функция МояКоманда()
	Возврат СерверныйФункции.МояКомандаПолучить();
КонецФункции

&НаКлиенте
Процедура ДанныеВыбор(Элемент, ВыбраннаяСтрока, Поле, СтандартнаяОбработка)
	СтандартнаяОбработка = Ложь;
	ПоказатьЗначение(, Элемент.ТекущиеДанные.ИгрокИлиМатч);
КонецПроцедуры

&НаКлиенте
Процедура ДанныеПриАктивизацииСтроки(Элемент)
	Если Элемент.ТекущиеДанные = Неопределено Тогда
		//
	ИначеЕсли Элемент.ТекущиеДанные.ЭтоИгрок Тогда
		ИзображениеУстановить(Элемент.ТекущиеДанные.ИгрокИлиМатч, Игрок, Изображение);
	ИначеЕсли Изображение <> ИзображениеДефолт Тогда
		Изображение	= ИзображениеДефолт;
	КонецЕсли;
КонецПроцедуры

&НаСервереБезКонтекста
Процедура ИзображениеУстановить(ИгрокИлиМатч, Игрок, Изображение)
	Если ИгрокИлиМатч = Игрок Тогда
		//
	Иначе
		Если ИгрокИлиМатч.Изображение.Получить() = Неопределено Тогда
			Изображение	= ИзображениеДефолтПолучить();
		Иначе
			Изображение	= ПолучитьНавигационнуюСсылку(ИгрокИлиМатч, "Изображение");
		КонецЕсли;
		Игрок	= ИгрокИлиМатч;
	КонецЕсли;
КонецПроцедуры

&НаСервереБезКонтекста
Функция ИзображениеДефолтПолучить()
	Возврат СерверныйФункции.ИзображениеДефолтПолучить();
КонецФункции

&НаКлиенте
Процедура КомандаОбновить(Команда=Неопределено)
	Если ПроверитьЗаполнение() Тогда
		ДанныеЗагрузитьНаСервере();
	КонецЕсли;
КонецПроцедуры

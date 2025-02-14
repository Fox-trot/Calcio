﻿
Процедура ДатыУстановить(Ссылка) Экспорт
	Запрос	= Новый Запрос("ВЫБРАТЬ
	      	               |	МАКСИМУМ(Матч.Дата) КАК ДатаОкончания,
	      	               |	МИНИМУМ(Матч.Дата) КАК ДатаНачала,
	      	               |	КОЛИЧЕСТВО(РАЗЛИЧНЫЕ Матч.Ссылка) КАК Количество,
	      	               |	МАКСИМУМ(ЧемпионатыКоманды.НомерСтроки) КАК НомерСтроки
	      	               |ИЗ
	      	               |	Документ.Матч КАК Матч
	      	               |		ВНУТРЕННЕЕ СОЕДИНЕНИЕ Справочник.Туры КАК Туры
	      	               |			ВНУТРЕННЕЕ СОЕДИНЕНИЕ Справочник.Чемпионаты.Команды КАК ЧемпионатыКоманды
	      	               |			ПО Туры.Владелец = ЧемпионатыКоманды.Ссылка
	      	               |		ПО Матч.Тур = Туры.Ссылка
	      	               |ГДЕ
	      	               |	Матч.Тур = &Тур
	      	               |	И Матч.Проведен = ИСТИНА");
	Запрос.УстановитьПараметр("Тур",			Ссылка);
	Выборка	= Запрос.Выполнить().Выбрать();
	Если Выборка.Следующий()
	И (Ссылка.ДатаНачала <> Выборка.ДатаНачала Или Ссылка.ДатаОкончания <> Выборка.ДатаОкончания)
	Тогда
		оТур	= Ссылка.ПолучитьОбъект();
		оТур.ДатаНачала		= Выборка.ДатаНачала;
		Если Выборка.НомерСтроки = Выборка.Количество Тогда
			оТур.ДатаОкончания	= Выборка.ДатаОкончания;
		ИначеЕсли оТур.ДатаОкончания < Выборка.ДатаНачала Тогда
			оТур.ДатаОкончания	= Выборка.ДатаНачала;
		КонецЕсли;
		Попытка
			оТур.Записать();
		Исключение КонецПопытки;
	КонецЕсли;
КонецПроцедуры

Процедура ОбработкаПолученияПредставления(Данные, Представление, СтандартнаяОбработка)
	Если НЕ Данные.ПометкаУдаления Тогда
		СтандартнаяОбработка = Ложь;
		Представление = СтрШаблон(Данные.Наименование + " %1", Данные.Владелец);
	КонецЕсли;
КонецПроцедуры

Процедура ОбработкаПолученияПолейПредставления(Поля, СтандартнаяОбработка)
	СтандартнаяОбработка = Ложь;
    Поля.Добавить("ПометкаУдаления");
    Поля.Добавить("Наименование");
    Поля.Добавить("Владелец");
КонецПроцедуры

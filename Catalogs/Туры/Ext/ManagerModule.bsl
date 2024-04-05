﻿
Процедура ДатыУстановить(Ссылка) Экспорт
	Запрос	= Новый Запрос("ВЫБРАТЬ
	      	               |	МАКСИМУМ(Матч.Дата) КАК ДатаОкончания,
	      	               |	МИНИМУМ(Матч.Дата) КАК ДатаНачала
	      	               |ИЗ
	      	               |	Документ.Матч КАК Матч
	      	               |		ВНУТРЕННЕЕ СОЕДИНЕНИЕ Справочник.Туры КАК Туры
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
		оТур.ДатаОкончания	= Выборка.ДатаОкончания;
		Попытка
			оТур.Записать();
		Исключение КонецПопытки;
	КонецЕсли;
КонецПроцедуры

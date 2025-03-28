﻿
Процедура ОбработкаЗаполнения(ДанныеЗаполнения, ТекстЗаполнения, СтандартнаяОбработка)
	Если ТипЗнч(ДанныеЗаполнения) = Тип("СправочникСсылка.ВидыСпорта") Тогда
		Владелец	= ДанныеЗаполнения;
	ИначеЕсли ТипЗнч(ДанныеЗаполнения) = Тип("СправочникСсылка.Города") Тогда
		Город		= ДанныеЗаполнения;
	ИначеЕсли ТипЗнч(ДанныеЗаполнения) = Тип("Структура") Тогда
		Если ДанныеЗаполнения.Свойство("Владелец") Тогда
			ОбработкаЗаполнения(ДанныеЗаполнения.Владелец, ТекстЗаполнения, Ложь);
		КонецЕсли;
	Иначе
		Владелец	= ВидСпортаОпределить(ДанныеЗаполнения);
	КонецЕсли;
КонецПроцедуры

Процедура ПередЗаписью(Отказ)
	Если ПустаяСтрока(Комментарий) Тогда
		ОбщегоНазначения.УстановитьЗначение(Комментарий, НаименованиеСтрана());
	КонецЕсли;
КонецПроцедуры

Функция НаименованиеСтрана() Экспорт
	Страна	= Город.Владелец;
	Если НЕ ЗначениеЗаполнено(Страна) Тогда
		Запрос	= Новый Запрос("ВЫБРАТЬ
		      	               |	Лига.Страна КАК Ссылка
		      	               |ИЗ
		      	               |	РегистрНакопления.ТурнирнаяТаблица КАК ТурнирнаяТаблица
		      	               |		ВНУТРЕННЕЕ СОЕДИНЕНИЕ Справочник.Туры КАК Туры
		      	               |			ВНУТРЕННЕЕ СОЕДИНЕНИЕ Справочник.Чемпионаты КАК Чемпионаты
		      	               |				ВНУТРЕННЕЕ СОЕДИНЕНИЕ Справочник.Лига КАК Лига
		      	               |				ПО Чемпионаты.Владелец = Лига.Ссылка
		      	               |			ПО Туры.Владелец = Чемпионаты.Ссылка
		      	               |		ПО ТурнирнаяТаблица.Тур = Туры.Ссылка
		      	               |ГДЕ
		      	               |	ТурнирнаяТаблица.Команда = &Команда
		      	               |
		      	               |УПОРЯДОЧИТЬ ПО
		      	               |	Ссылка УБЫВ");
		Запрос.УстановитьПараметр("Команда",		Ссылка);
		Выборка = Запрос.Выполнить().Выбрать();
		Если Выборка.Следующий() Тогда
			Страна	= Выборка.Ссылка;
		КонецЕсли;
	КонецЕсли;
	Возврат ?(ЗначениеЗаполнено(Страна), СтрШаблон("%1 (%2)", СокрЛП(Наименование), Страна), "");
КонецФункции

Функция ВидСпортаОпределить(Параметр)
	Ответ	= Справочники.Страны.ПустаяСсылка();
	Запрос	= Новый Запрос("ВЫБРАТЬ
	      	               |	Лига.Владелец КАК Ссылка
	      	               |ИЗ
	      	               |	Справочник.Лига КАК Лига
	      	               |ГДЕ
	      	               |	Лига.Ссылка = &Параметр
	      	               |
	      	               |ОБЪЕДИНИТЬ ВСЕ
	      	               |
	      	               |ВЫБРАТЬ
	      	               |	Лига.Владелец
	      	               |ИЗ
	      	               |	Справочник.Чемпионаты КАК Чемпионаты
	      	               |		ВНУТРЕННЕЕ СОЕДИНЕНИЕ Справочник.Лига КАК Лига
	      	               |		ПО Чемпионаты.Владелец = Лига.Ссылка
	      	               |ГДЕ
	      	               |	Чемпионаты.Ссылка = &Параметр
	      	               |
	      	               |УПОРЯДОЧИТЬ ПО
	      	               |	Ссылка УБЫВ");
	Запрос.УстановитьПараметр("Параметр",		Параметр);
	Попытка
		Выборка = Запрос.Выполнить().Выбрать();
		Если Выборка.Следующий() Тогда
			Ответ	= Выборка.Ссылка;
		КонецЕсли;
	Исключение
		ОбщегоНазначения.СообщитьОбОшибке(ОписаниеОшибки());
	КонецПопытки;
	Возврат Ответ;
КонецФункции

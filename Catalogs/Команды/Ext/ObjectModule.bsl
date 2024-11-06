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
	Если ПустаяСтрока(Комментарий)
	И ЗначениеЗаполнено(Город)
	Тогда
		Комментарий	= НаименованиеСтрана();
	КонецЕсли;
КонецПроцедуры

Функция НаименованиеСтрана() Экспорт
	Возврат ?(ЗначениеЗаполнено(Город), СтрШаблон("%1 (%2)", СокрЛП(Наименование), Город.Владелец), "");
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

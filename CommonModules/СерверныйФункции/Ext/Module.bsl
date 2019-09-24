﻿
Функция Команда(Знач Игрок, Знач Дата) Экспорт
	Если ЗначениеЗаполнено(Игрок) Тогда
		Возврат РегистрыСведений.ПеремещенияИгроков.ПолучитьПоследнее(Дата, Новый Структура("Игрок", Игрок)).Команда;
	КонецЕсли;
	Возврат Справочники.Команды.ПустаяСсылка();
КонецФункции

Функция КомандаНайти(Знач Наименование, ВидСпорта) Экспорт
	Запрос = Новый Запрос("ВЫБРАТЬ
	                      |	Команды.Ссылка КАК Ссылка
	                      |ИЗ
	                      |	Справочник.Команды КАК Команды
	                      |ГДЕ Команды.Владелец = &ВидСпорта
	                      |	И (Команды.Наименование = &Наименование
	                      |			ИЛИ Команды.Примечание ПОДОБНО &Примечание)
	                      |	 ");
	Запрос.УстановитьПараметр("Наименование",	Наименование);
	Запрос.УстановитьПараметр("Примечание",		ВРег(Наименование));
	Запрос.УстановитьПараметр("ВидСпорта",		ВидСпорта);
	Выборка = Запрос.Выполнить().Выбрать();
	Возврат ?(Выборка.Следующий(), Выборка.Ссылка, Справочники.Команды.ПустаяСсылка());
КонецФункции

Функция Стадион(Знач Команда) Экспорт
	Шерлок = Справочники.Стадионы.Выбрать(, Команда);
	Возврат ?(Шерлок.Следующий(), Шерлок.Ссылка, Справочники.Стадионы.ПустаяСсылка());
КонецФункции

Функция Чемпионат(Знач Команды, Знач Дата) Экспорт
	Если ТипЗнч(Команды) = Тип("СправочникСсылка.Туры") Тогда
		Возврат Команды.Владелец;
	КонецЕсли;
	
	Запрос = Новый Запрос("ВЫБРАТЬ ПЕРВЫЕ 1
	                      |	Чемпионаты.Ссылка КАК Ссылка
	                      |ИЗ
	                      |	Справочник.Чемпионаты.Команды КАК Чемпионаты
	                      |ГДЕ
	                      |	&ДатаН МЕЖДУ Чемпионаты.Ссылка.ДатаНачала И Чемпионаты.Ссылка.ДатаОкончания
	                      |	И Чемпионаты.Команда В(&Команды)
	                      |
	                      |ОБЪЕДИНИТЬ ВСЕ
	                      |
	                      |ВЫБРАТЬ РАЗЛИЧНЫЕ
	                      |	ТурнирнаяТаблица.Тур.Владелец
	                      |ИЗ
	                      |	РегистрНакопления.ТурнирнаяТаблица.Обороты(&ДатаН, &ДатаК, , Команда В (&Команды)) КАК ТурнирнаяТаблица");
	//Если ТипЗнч(Команды) = Тип("СправочникСсылка.Команды") Тогда
	//КонецЕсли;
	Запрос.УстановитьПараметр("Команды",	Команды);
	Запрос.УстановитьПараметр("ДатаН",		НачалоДня(Дата));
	Запрос.УстановитьПараметр("ДатаК",		КонецДня(Дата));
	Выборка = Запрос.Выполнить().Выбрать();
	Возврат ?(Выборка.Следующий(), Выборка.Ссылка, Справочники.Чемпионаты.ПустаяСсылка());
КонецФункции

Функция ЧемпионатПолучитьПоследнее(Знач Команды) Экспорт
	Запрос = Новый Запрос("ВЫБРАТЬ ПЕРВЫЕ 1
	                      |	ТурнирнаяТаблица.Тур.Владелец КАК Ссылка
	                      |ИЗ
	                      |	РегистрНакопления.ТурнирнаяТаблица КАК ТурнирнаяТаблица
	                      |ГДЕ
	                      |	ТурнирнаяТаблица.Команда В(&Команды)
	                      |
	                      |УПОРЯДОЧИТЬ ПО
	                      |	ТурнирнаяТаблица.Период УБЫВ");
	//Если ТипЗнч(Команды) = Тип("СправочникСсылка.Команды") Тогда
	//КонецЕсли;
	Запрос.УстановитьПараметр("Команды",	Команды);
	Выборка = Запрос.Выполнить().Выбрать();
	Возврат ?(Выборка.Следующий(), Выборка.Ссылка, Справочники.Чемпионаты.ПустаяСсылка());
КонецФункции

Функция ЧемпионатЛигиПоследний(Лига) Экспорт
	Запрос = Новый Запрос("ВЫБРАТЬ ПЕРВЫЕ 1
	                      |	ТурнирнаяТаблица.Тур.Владелец КАК Ссылка,
	                      |	ТурнирнаяТаблица.Период КАК Период
	                      |ИЗ
	                      |	РегистрНакопления.ТурнирнаяТаблица КАК ТурнирнаяТаблица
	                      |ГДЕ
	                      |	ТурнирнаяТаблица.Тур.Владелец.Владелец = &Лига
	                      |
	                      |УПОРЯДОЧИТЬ ПО
	                      |	Период УБЫВ");
	Запрос.УстановитьПараметр("Лига",	Лига);
	Выборка = Запрос.Выполнить().Выбрать();
	Возврат ?(Выборка.Следующий(), Выборка.Ссылка, Справочники.Чемпионаты.ПустаяСсылка());
КонецФункции

Функция Тур(Команды, Дата) Экспорт
	Запрос = Новый Запрос("ВЫБРАТЬ ПЕРВЫЕ 1
	                      |	Туры.Ссылка КАК Ссылка
	                      |ИЗ
	                      |	Справочник.Туры КАК Туры
	                      |		ВНУТРЕННЕЕ СОЕДИНЕНИЕ Справочник.Чемпионаты.Команды КАК Чемпионаты
	                      |		ПО Туры.Владелец = Чемпионаты.Ссылка
	                      |ГДЕ
	                      |	&Дата МЕЖДУ Туры.ДатаНачала И Туры.ДатаОкончания
	                      |	И Чемпионаты.Команда В(&Команды)");
	//Если ТипЗнч(Команды) = Тип("СправочникСсылка.Команды") Тогда
	//КонецЕсли;
	Запрос.УстановитьПараметр("Команды",	Команды);
	Запрос.УстановитьПараметр("Дата",		НачалоДня(Дата));
	Выборка = Запрос.Выполнить().Выбрать();
	Возврат ?(Выборка.Следующий(), Выборка.Ссылка, Справочники.Чемпионаты.ПустаяСсылка());
КонецФункции

Функция ТурКодНовыйПолучить(Чемпионат) Экспорт
	Если НЕ ЗначениеЗаполнено(Чемпионат) Тогда
		Чемпионат = ЧемпионатЛигиПоследний(Чемпионат.Владелец);
	КонецЕсли;
	Запрос = Новый Запрос("ВЫБРАТЬ
	                      |	ЕСТЬNULL(МАКСИМУМ(Туры.Код), 0) КАК Код
	                      |ИЗ
	                      |	Справочник.Туры КАК Туры
	                      |ГДЕ
	                      |	Туры.Владелец = &Чемпионат");
	Запрос.УстановитьПараметр("Чемпионат",	Чемпионат);
	Выборка = Запрос.Выполнить().Выбрать();
	Возврат ?(Выборка.Следующий(), Выборка.Код + 1, 1);
КонецФункции

Функция ВидСпорта(Знач Ссылка) Экспорт
	Если ТипЗнч(Ссылка) = Тип("СправочникСсылка.ВидыСпорта") Тогда
		Возврат Ссылка;
		
	ИначеЕсли ТипЗнч(Ссылка) = Тип("СправочникСсылка.Команды") Тогда
		Возврат Ссылка.Владелец;
		
	ИначеЕсли ТипЗнч(Ссылка) = Тип("СправочникСсылка.Лига") Тогда
		Возврат Ссылка.Владелец;
		
	ИначеЕсли ТипЗнч(Ссылка) = Тип("СправочникСсылка.Амплуа") Тогда
		Возврат Ссылка.Владелец;
		
	ИначеЕсли ТипЗнч(Ссылка) = Тип("СправочникСсылка.Чемпионаты") Тогда
		Возврат Ссылка.Владелец.Владелец;
		
	ИначеЕсли ТипЗнч(Ссылка) = Тип("СправочникСсылка.Туры") Тогда
		Возврат Ссылка.Владелец.Владелец.Владелец;
		
	ИначеЕсли ТипЗнч(Ссылка) = Тип("СправочникСсылка.Стадионы") Тогда
		Возврат Ссылка.Владелец.Владелец;
		
	КонецЕсли;
	Возврат Справочники.ВидыСпорта.ПустаяСсылка();
КонецФункции

Функция Лига(Знач Чемпионат) Экспорт
	Если ТипЗнч(Чемпионат) = Тип("СправочникСсылка.Туры") Тогда
		Возврат Чемпионат.Владелец.Владелец;
	КонецЕсли;
	Возврат Чемпионат.Владелец;
КонецФункции

Функция ЛигаКоличествоКоманд(Знач Лига) Экспорт
	Возврат Лига.КоличествоКоманд;
КонецФункции

Функция СкачатьПоСсылке(Гиперссылка, КомОбъект=Неопределено) Экспорт
	Ответ = "";
	Если НЕ ПустаяСтрока(Гиперссылка) Тогда
		Попытка
			Если КомОбъект = Неопределено Тогда
				КомОбъект = Новый COMОбъект("Msxml2.XMLHTTP");
			КонецЕсли;
			КомОбъект.Open("GET", Гиперссылка, false);
			КомОбъект.Send();
			Ответ = КомОбъект.responseText;
		Исключение
		КонецПопытки;
	КонецЕсли;
	Возврат Ответ;
КонецФункции

Функция МатчОбработкаПроверкиЗаполнения(Объект, Отказ) Экспорт
	Гугл = Новый Структура("Команда");
	Для Каждого тСтрока Из Объект.СоставыКоманд Цикл
		Если ЗначениеЗаполнено(тСтрока.Команда) Тогда
			Гугл.Команда = тСтрока.Команда;
			Если Объект.Команды.НайтиСтроки(Гугл).Количество() = 0 Тогда
				Отказ = Истина;
				Прервать;
			КонецЕсли;
			
		Иначе
			Отказ = Истина;
			Прервать;
		КонецЕсли;
	КонецЦикла;
КонецФункции

Функция МатчНайти(Команда, Тур) Экспорт
	Запрос = Новый Запрос("ВЫБРАТЬ
	                      |	МатчКоманды.Ссылка КАК Ссылка
	                      |ИЗ
	                      |	Документ.Матч.Команды КАК МатчКоманды
	                      |ГДЕ
	                      |	МатчКоманды.Команда = &Команда
	                      |	И МатчКоманды.Ссылка.Тур = &Тур");
	Запрос.УстановитьПараметр("Команда",	Команда);
	Запрос.УстановитьПараметр("Тур",		Тур);
	Выборка = Запрос.Выполнить().Выбрать();
	Возврат ?(Выборка.Следующий(), Выборка.Ссылка, Документы.Матч.ПустаяСсылка());
КонецФункции

Функция СообщитьОбОшибке(ТекстСообщения="Ошибка!") Экспорт
	Сообщить(ТекстСообщения, СтатусСообщения.Внимание);
	Возврат Истина;
КонецФункции

Функция ТурнирнаяТаблица(Знач Чемпионат) Экспорт
	Запрос = Новый Запрос("ВЫБРАТЬ
	                      |	ТурнирнаяТаблица.Команда КАК Команда,
	                      |	КОЛИЧЕСТВО(РАЗЛИЧНЫЕ ТурнирнаяТаблица.Регистратор) КАК КоличествоИгр,
	                      |	СУММА(ТурнирнаяТаблица.КоличествоГолов) КАК Забито,
	                      |	СУММА(ТурнирнаяТаблица.КоличествоОчков) КАК КоличествоОчков,
	                      |	СУММА(ВЫБОР
	                      |			КОГДА ТурнирнаяТаблица.КоличествоОчков > Игра.КоличествоОчков
	                      |				ТОГДА 1
	                      |			ИНАЧЕ 0
	                      |		КОНЕЦ) КАК Выигрыш,
	                      |	СУММА(ВЫБОР
	                      |			КОГДА ТурнирнаяТаблица.КоличествоОчков = Игра.КоличествоОчков
	                      |				ТОГДА 1
	                      |			ИНАЧЕ 0
	                      |		КОНЕЦ) КАК Ничья,
	                      |	СУММА(ВЫБОР
	                      |			КОГДА ТурнирнаяТаблица.КоличествоОчков < Игра.КоличествоОчков
	                      |				ТОГДА 1
	                      |			ИНАЧЕ 0
	                      |		КОНЕЦ) КАК Проигрыш,
	                      |	СУММА(Игра.КоличествоГолов) КАК Пропущено
	                      |ИЗ
	                      |	РегистрНакопления.ТурнирнаяТаблица КАК ТурнирнаяТаблица
	                      |		ВНУТРЕННЕЕ СОЕДИНЕНИЕ РегистрНакопления.ТурнирнаяТаблица КАК Игра
	                      |		ПО ТурнирнаяТаблица.Регистратор = Игра.Регистратор
	                      |			И ТурнирнаяТаблица.НомерСтроки <> Игра.НомерСтроки
	                      |ГДЕ
	                      |	ТурнирнаяТаблица.Тур.Владелец = &Чемпионат
	                      |
	                      |СГРУППИРОВАТЬ ПО
	                      |	ТурнирнаяТаблица.Команда
	                      |
	                      |УПОРЯДОЧИТЬ ПО
	                      |	СУММА(ТурнирнаяТаблица.КоличествоОчков) УБЫВ,
	                      |	СУММА(ТурнирнаяТаблица.КоличествоГолов) - СУММА(Игра.КоличествоГолов) УБЫВ,
	                      |	Забито УБЫВ");
	Запрос.УстановитьПараметр("Чемпионат",		Чемпионат);
	Возврат Запрос.Выполнить().Выбрать();
КонецФункции

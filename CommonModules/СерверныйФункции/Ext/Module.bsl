﻿
Процедура ПервоначальноеЗаполнение() Экспорт
	СписокШиндлера = Новый Массив;
	СписокШиндлера.Добавить("Вратарь");
	СписокШиндлера.Добавить("Защитник");
	СписокШиндлера.Добавить("Полузащитник");
	СписокШиндлера.Добавить("Нападающий");
	Для Каждого ТекЭлемент Из СписокШиндлера Цикл
		Если Амплуа(ТекЭлемент).Пустая() Тогда
			Объект = Справочники.Амплуа.СоздатьЭлемент();
			Объект.Наименование	= ТекЭлемент;
			Объект.Владелец		= Футбол();
			Объект.Записать();
		КонецЕсли;
	КонецЦикла;
	
	СписокШиндлера.Очистить();
	СписокШиндлера.Добавить("Англия");
	Для Каждого ТекЭлемент Из СписокШиндлера Цикл
		Страна = Справочники.Страны.НайтиПоНаименованию(ТекЭлемент);
		Если Страна.Пустая() Тогда
			Объект = Справочники.Страны.СоздатьЭлемент();
			Объект.Наименование	= ТекЭлемент;
			Объект.Записать();
			
			Страна = Объект.Ссылка;
		КонецЕсли;
	КонецЦикла;
	
	СписокШиндлера.Очистить();
	СписокШиндлера.Добавить("Лондон");
	СписокШиндлера.Добавить("Ливерпуль");
	СписокШиндлера.Добавить("Манчестер");
	Для Каждого ТекЭлемент Из СписокШиндлера Цикл
		Если Справочники.Города.НайтиПоНаименованию(ТекЭлемент).Пустая() Тогда
			Объект = Справочники.Города.СоздатьЭлемент();
			Объект.Наименование	= ТекЭлемент;
			Объект.Владелец		= Страна;
			//Объект.УстановитьНовыйКод();
			Объект.Записать();
		КонецЕсли;
	КонецЦикла;
	
	СписокШиндлера.Очистить();
	СписокШиндлера.Добавить("Английская премьер лига");
	Для Каждого ТекЭлемент Из СписокШиндлера Цикл
		Если Справочники.Лига.НайтиПоНаименованию(ТекЭлемент).Пустая() Тогда
			Объект = Справочники.Лига.СоздатьЭлемент();
			Объект.Наименование	= ТекЭлемент;
			Объект.Владелец		= Футбол();
			Объект.Страна		= Страна;
			Объект.КоличествоКоманд		= 20;
			Объект.КоличествоРотация	= 3;
			Объект.КвалификацияВЛигуЧемпионовУЕФА	= 4;
			Объект.КвалификацияВЛигуЕвропыУЕФА		= 1;
			Объект.Записать();
		КонецЕсли;
	КонецЦикла;
	
	ЧтениеJSON	= Новый ЧтениеJSON;
	ЧтениеJSON.УстановитьСтроку(ПолучитьОбщийМакет("ПервоначальноеЗаполнение").ПолучитьТекст());
	СписокШиндлера = ПрочитатьJSON(ЧтениеJSON);
	Для Каждого ТекЭлемент Из СписокШиндлера Цикл
		Если Справочники.Команды.НайтиПоНаименованию(ТекЭлемент.Наименование).Пустая() Тогда
			Объект = Справочники.Команды.СоздатьЭлемент();
			Объект.Наименование	= ТекЭлемент.Наименование;
			Объект.Владелец		= Футбол();
			Объект.Город		= Справочники.Города.НайтиПоНаименованию(ТекЭлемент.Город);
			Объект.УстановитьНовыйКод();
			Объект.Записать();
		КонецЕсли;
	КонецЦикла;
КонецПроцедуры

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

Функция Стадион(Команда) Экспорт
	Шерлок = Справочники.Стадионы.Выбрать(, Команда);
	Возврат ?(Шерлок.Следующий(), Шерлок.Ссылка, Справочники.Стадионы.ПустаяСсылка());
КонецФункции

Функция Чемпионат(Команды, Знач Дата) Экспорт
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
	                      |ОБЪЕДИНИТЬ
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

Функция ЧемпионатПолучитьПоследнее(Знач Команды=Неопределено) Экспорт
	Запрос = Новый Запрос("ВЫБРАТЬ ПЕРВЫЕ 1
	                      |	ТурнирнаяТаблица.Тур.Владелец КАК Ссылка
	                      |ИЗ
	                      |	РегистрНакопления.ТурнирнаяТаблица КАК ТурнирнаяТаблица
	                      |ГДЕ
	                      |	ТурнирнаяТаблица.Команда В(&Команды)
	                      |
	                      |УПОРЯДОЧИТЬ ПО
	                      |	ТурнирнаяТаблица.Период УБЫВ");
	Если НЕ ЗначениеЗаполнено(Команды) Тогда
		Команды = МояКомандаПолучить();
	КонецЕсли;
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
	Запрос = Новый Запрос("ВЫБРАТЬ ПЕРВЫЕ 1
	                      |	МатчКоманды.Ссылка КАК Ссылка,
	                      |	1 КАК Порядок
	                      |ИЗ
	                      |	Документ.Матч.Команды КАК МатчКоманды
	                      |ГДЕ
	                      |	МатчКоманды.Команда = &Команда
	                      |	И МатчКоманды.Ссылка.Тур = &Тур
	                      |
	                      |ОБЪЕДИНИТЬ
	                      |
	                      |ВЫБРАТЬ ПЕРВЫЕ 1
	                      |	Матч.Ссылка,
	                      |	2
	                      |ИЗ
	                      |	Документ.Матч КАК Матч
	                      |ГДЕ
	                      |	Матч.ПометкаУдаления = ИСТИНА
	                      |
	                      |УПОРЯДОЧИТЬ ПО
	                      |	Порядок");
	Запрос.УстановитьПараметр("Команда",	Команда);
	Запрос.УстановитьПараметр("Тур",		Тур);
	Выборка = Запрос.Выполнить().Выбрать();
	Возврат ?(Выборка.Следующий(), Выборка.Ссылка, Документы.Матч.ПустаяСсылка());
КонецФункции

Функция СообщитьОбОшибке(ТекстСообщения="Ошибка!", Отказ=Ложь) Экспорт
	Отказ = Истина;
	Сообщить(ТекстСообщения, СтатусСообщения.Внимание);
	Возврат Истина;
КонецФункции

Функция ТурнирнаяТаблица(Знач Чемпионат) Экспорт
	Запрос = Новый Запрос(
	"ВЫБРАТЬ
	|	Команды.Команда КАК Команда,
	|	СУММА(ВЫБОР
	|			КОГДА ТИПЗНАЧЕНИЯ(ТурнирнаяТаблица.Регистратор) = ТИП(Документ.Матч)
	|				ТОГДА 1
	|			ИНАЧЕ 0
	|		КОНЕЦ) КАК КоличествоИгр,
	|	ЕСТЬNULL(СУММА(ТурнирнаяТаблица.КоличествоГолов), 0) КАК Забито,
	|	ЕСТЬNULL(СУММА(ТурнирнаяТаблица.КоличествоОчков), 0) КАК КоличествоОчков,
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
	|	ЕСТЬNULL(СУММА(Игра.КоличествоГолов), 0) КАК Пропущено,
	|	ЕСТЬNULL(СУММА(ТурнирнаяТаблица.КоличествоГолов) - СУММА(Игра.КоличествоГолов), 0) КАК Разница
	|ИЗ
	|	Справочник.Чемпионаты.Команды КАК Команды
	|		ЛЕВОЕ СОЕДИНЕНИЕ РегистрНакопления.ТурнирнаяТаблица КАК ТурнирнаяТаблица
	|			ВНУТРЕННЕЕ СОЕДИНЕНИЕ Справочник.Туры КАК Туры
	|			ПО ТурнирнаяТаблица.Тур = Туры.Ссылка
	|				И (Туры.Владелец = &Чемпионат)
	|		ПО Команды.Команда = ТурнирнаяТаблица.Команда
	|		ЛЕВОЕ СОЕДИНЕНИЕ РегистрНакопления.ТурнирнаяТаблица КАК Игра
	|		ПО (ТурнирнаяТаблица.Регистратор = Игра.Регистратор)
	|			И (ТурнирнаяТаблица.НомерСтроки <> Игра.НомерСтроки)
	|ГДЕ
	|	Команды.Ссылка = &Чемпионат
	|
	|СГРУППИРОВАТЬ ПО
	|	Команды.Команда
	|
	|УПОРЯДОЧИТЬ ПО
	|	КоличествоОчков УБЫВ,
	|	Разница УБЫВ,
	|	Забито УБЫВ");
	Запрос.УстановитьПараметр("Чемпионат",		Чемпионат);
	Возврат Запрос.Выполнить().Выбрать();
КонецФункции

Функция МояКоманда(Знач Чемпионат=Неопределено) Экспорт
	Если ЗначениеЗаполнено(Чемпионат) Тогда
		Запрос = Новый Запрос(
		"ВЫБРАТЬ
		|	ЧемпионатыКоманды.Команда КАК Команда
		|ИЗ
		|	Справочник.Чемпионаты.Команды КАК ЧемпионатыКоманды
		|ГДЕ
		|	ЧемпионатыКоманды.Команда = &Команда
		|
		|УПОРЯДОЧИТЬ ПО
		|	ЧемпионатыКоманды.Ссылка = &Ссылка УБЫВ");
		Запрос.УстановитьПараметр("Команда",	МояКомандаПолучить());
		Запрос.УстановитьПараметр("Ссылка",		Чемпионат);
		Выборка = Запрос.Выполнить().Выбрать();
		Возврат ?(Выборка.Следующий(), Выборка.Команда, Справочники.Команды.ПустаяСсылка());
	КонецЕсли;
	Возврат МояКомандаПолучить();
КонецФункции

Функция МояКомандаПолучить()
	Возврат Константы.МояКоманда.Получить();
КонецФункции

Функция СтатистикаИгр(Знач Команда, Знач Чемпионат=Неопределено) Экспорт
	Ответ = Новый Структура("Побед,Ничьих,Проигрышей,Результативность", 0, 0, 0, 0);
	//Ответ.Вставить("Средняя_результативность", 0);
	Запрос = Новый Запрос(
	"ВЫБРАТЬ ПЕРВЫЕ 10
	|	ТурнирнаяТаблица.Период КАК Период
	|ПОМЕСТИТЬ Последнее
	|ИЗ
	|	РегистрНакопления.ТурнирнаяТаблица КАК ТурнирнаяТаблица
	|ГДЕ
	|	ТурнирнаяТаблица.Команда = &Команда
	|	И ТурнирнаяТаблица.Тур.Владелец = &Чемпионат
	|
	|УПОРЯДОЧИТЬ ПО
	|	Период УБЫВ
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	|ВЫБРАТЬ ПЕРВЫЕ 1
	|	Последнее.Период КАК Период
	|ИЗ
	|	Последнее КАК Последнее
	|
	|УПОРЯДОЧИТЬ ПО
	|	Период");
	Запрос.УстановитьПараметр("Команда",	Команда);
	Запрос.УстановитьПараметр("Чемпионат",	Чемпионат);
	Если НЕ ЗначениеЗаполнено(Чемпионат) Тогда
		Запрос.Текст = СтрЗаменить(Запрос.Текст, "И ТурнирнаяТаблица.Тур.Владелец = &Чемпионат", "");
	КонецЕсли;
	//Выборка = Запрос.Выполнить().Выбрать();
	//Если Выборка.Следующий() Тогда
		Запрос.Текст = "ВЫБРАТЬ
		               |	ТурнирнаяТаблица.КоличествоОчков КАК КоличествоОчков,
		               |	СУММА(1) КАК Количество,
		               |	СУММА(ТурнирнаяТаблица.КоличествоГолов) КАК КоличествоГолов
		               |ИЗ
		               |	РегистрНакопления.ТурнирнаяТаблица КАК ТурнирнаяТаблица
		               |ГДЕ
		               |	ТурнирнаяТаблица.Команда = &Команда
					   //|	И ТурнирнаяТаблица.Период >= &Период
		               |	И ТурнирнаяТаблица.Тур.Владелец = &Чемпионат
		               |
		               |СГРУППИРОВАТЬ ПО
		               |	ТурнирнаяТаблица.КоличествоОчков";
		//Запрос.УстановитьПараметр("Период",	НачалоДня(Выборка.Период));
		Если Чемпионат = Неопределено Тогда
			Запрос.Текст = СтрЗаменить(Запрос.Текст, "И ТурнирнаяТаблица.Тур.Владелец = &Чемпионат", "");
		КонецЕсли;
		Выборка = Запрос.Выполнить().Выбрать();
		Пока Выборка.Следующий() Цикл
			Если Выборка.КоличествоОчков = 0 Тогда
				Ответ.Проигрышей = Выборка.Количество;
			ИначеЕсли Выборка.КоличествоОчков = 1 Тогда
				Ответ.Ничьих = Выборка.Количество;
			Иначе
				Ответ.Побед = Выборка.Количество;
			КонецЕсли;
			Ответ.Результативность = Ответ.Результативность + Выборка.КоличествоГолов;
			//Ответ.Средняя_результативность = Ответ.Средняя_результативность + Выборка.Количество;
		КонецЦикла;
		//Ответ.Средняя_результативность = Окр(Ответ.Результативность / Ответ.Средняя_результативность, 1);
	//КонецЕсли;
	Возврат Ответ;
КонецФункции

Функция МестоВЧемпионате(Знач Команда, Знач Чемпионат=Неопределено) Экспорт
	Ответ = 0;
	Выборка = ТурнирнаяТаблица(?(Чемпионат=Неопределено, ЧемпионатПолучитьПоследнее(Команда), Чемпионат));
	Пока Выборка.Следующий() Цикл
		Ответ = Ответ + 1;
		Если Выборка.Команда = Команда Тогда
			Прервать;
		КонецЕсли;
	КонецЦикла;
	Возврат Ответ;
КонецФункции

Функция ЭтоДерби(Матч) Экспорт
	Ответ	= Ложь;
	Запрос	= Новый Запрос(
	"ВЫБРАТЬ
	|	КОЛИЧЕСТВО(Команды.Город) + КОЛИЧЕСТВО(РАЗЛИЧНЫЕ Команды.Город) КАК Количество
	|ИЗ
	|	Документ.Матч.Команды КАК МатчКоманды
	|		ВНУТРЕННЕЕ СОЕДИНЕНИЕ Справочник.Команды КАК Команды
	|			ВНУТРЕННЕЕ СОЕДИНЕНИЕ Справочник.Города КАК Города
	|			ПО Команды.Город = Города.Ссылка
	|		ПО МатчКоманды.Команда = Команды.Ссылка
	|ГДЕ
	|	МатчКоманды.Ссылка = &Матч");
	Запрос.УстановитьПараметр("Матч",	Матч);
	Выборка = Запрос.Выполнить().Выбрать();
	Если Выборка.Следующий() Тогда
		Ответ = (Выборка.Количество = 3);
	КонецЕсли;
	Возврат Ответ;
КонецФункции

Функция ЕстьИстория(Ссылка, Вторая=Неопределено) Экспорт
		//Возврат Ложь;
	Запрос = Новый Запрос;
	Запрос.УстановитьПараметр("Ссылка",			Ссылка);
	Запрос.УстановитьПараметр("Вторая",			Вторая);
	Если ТипЗнч(Ссылка) = Тип("СправочникСсылка.Команды") Тогда
		Запрос.Текст = "ВЫБРАТЬ ПЕРВЫЕ 1
		               |	ТурнирнаяТаблица.Период КАК Период
		               |ИЗ
		               |	РегистрНакопления.ТурнирнаяТаблица КАК ТурнирнаяТаблица
		               |ГДЕ
		               |	ТурнирнаяТаблица.Команда = &Ссылка
		               |
		               |УПОРЯДОЧИТЬ ПО
		               |	Период";
	ИначеЕсли ТипЗнч(Ссылка) = Тип("СправочникСсылка.Лига") Тогда
		Запрос.Текст = "ВЫБРАТЬ ПЕРВЫЕ 1
		               |	Чемпионаты.Ссылка КАК Ссылка
		               |ИЗ
		               |	Справочник.Чемпионаты КАК Чемпионаты
		               |ГДЕ
		               |	Чемпионаты.Владелец = &Ссылка
		               |
		               |УПОРЯДОЧИТЬ ПО
		               |	Ссылка";
	ИначеЕсли ТипЗнч(Ссылка) = Тип("СправочникСсылка.Чемпионаты") Тогда
		Если Вторая = Неопределено Тогда
			Запрос.Текст = "ВЫБРАТЬ ПЕРВЫЕ 1
			               |	Туры.Ссылка КАК Ссылка
			               |ИЗ
			               |	Справочник.Туры КАК Туры
			               |ГДЕ
			               |	Туры.Владелец = &Ссылка
			               |
			               |УПОРЯДОЧИТЬ ПО
			               |	Ссылка";
		Иначе
			Запрос.Текст = "ВЫБРАТЬ ПЕРВЫЕ 1
	                      |	ТурнирнаяТаблица.Период КАК Период
	                      |ИЗ
	                      |	РегистрНакопления.ТурнирнаяТаблица КАК ТурнирнаяТаблица
	                      |		ВНУТРЕННЕЕ СОЕДИНЕНИЕ Справочник.Туры КАК Туры
	                      |		ПО ТурнирнаяТаблица.Тур = Туры.Ссылка
	                      |ГДЕ
	                      |	ТурнирнаяТаблица.Команда = &Вторая
	                      |	И Туры.Владелец = &Ссылка
	                      |
	                      |УПОРЯДОЧИТЬ ПО
	                      |	Период";
		КонецЕсли;
	Иначе
		Возврат Ложь;
	КонецЕсли;
	
	Возврат (НЕ Запрос.Выполнить().Пустой());
КонецФункции

Функция ИзображениеПолучить(Ссылка) Экспорт
	Возврат Новый Картинка(Ссылка.Изображение.Получить());
КонецФункции

Функция ИзображениеДефолтПолучить() Экспорт
	Возврат "";
КонецФункции

Функция ВидыСпорта(Наименование="Футбол") Экспорт
	Запрос = Новый Запрос(
	"ВЫБРАТЬ ПЕРВЫЕ 1
	|	ВидыСпорта.Ссылка КАК Ссылка
	|ИЗ
	|	Справочник.ВидыСпорта КАК ВидыСпорта
	|ГДЕ
	|	ВидыСпорта.Наименование = &Наименование
	|
	|УПОРЯДОЧИТЬ ПО
	|	ВидыСпорта.ПометкаУдаления");
	Запрос.УстановитьПараметр("Наименование",		Наименование);
	Выборка = Запрос.Выполнить().Выбрать();
	Если Выборка.Следующий() Тогда
		Возврат Выборка.Ссылка;
	КонецЕсли;
	Возврат Справочники.ВидыСпорта.ПустаяСсылка();
КонецФункции

Функция Футбол() Экспорт
	Возврат Справочники.ВидыСпорта.Футбол;
КонецФункции

Функция Амплуа(Наименование="Вратарь") Экспорт
	Запрос = Новый Запрос(
	"ВЫБРАТЬ ПЕРВЫЕ 1
	|	Амплуа.Ссылка КАК Ссылка
	|ИЗ
	|	Справочник.Амплуа КАК Амплуа
	|ГДЕ
	|	Амплуа.Наименование = &Наименование
	|
	|УПОРЯДОЧИТЬ ПО
	|	Амплуа.ПометкаУдаления");
	Запрос.УстановитьПараметр("Наименование",		Наименование);
	Выборка = Запрос.Выполнить().Выбрать();
	Если Выборка.Следующий() Тогда
		Возврат Выборка.Ссылка;
	КонецЕсли;
	Возврат Справочники.Амплуа.ПустаяСсылка();
КонецФункции

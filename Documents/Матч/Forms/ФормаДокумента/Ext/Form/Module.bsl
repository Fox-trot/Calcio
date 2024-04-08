﻿
&НаКлиенте
Процедура КомандыПередНачаломДобавления(Элемент, Отказ, Копирование, Родитель, Группа, Параметр)
	Отказ = (Объект.Команды.Количество() > 1);
КонецПроцедуры

&НаКлиенте
Процедура КомандыПослеУдаления(Элемент)
	Элементы.Стадион.СписокВыбора.Очистить();
	ТЧОчистить();
КонецПроцедуры

&НаСервере
Процедура ТЧОчистить()
	ПредыдущиеВстречи.Очистить();
	ПредыдущиеМатчи.Очистить();
	Игроки.Очистить();
	Сезон.Очистить();
КонецПроцедуры

&НаКлиенте
Процедура КомандыОбработкаЗаписиНового(НовыйОбъект, Источник, СтандартнаяОбработка)
	ВидимостьДоступностьУстановить();
КонецПроцедуры

&НаСервере
Функция КомандыПолучить()
	Возврат Объект.Команды.Выгрузить().ВыгрузитьКолонку("Команда");
КонецФункции

&НаСервере
Процедура СоставыЗаполнитьНаСервере()
	Если Объект.Команды.Количество() = 0 Тогда Возврат; КонецЕсли;
	
	Объект.СоставыКоманд.Очистить();
	
	Запрос = Новый Запрос("ВЫБРАТЬ ПЕРВЫЕ 1
	                      |	МатчСоставыКоманд.Ссылка КАК Ссылка
	                      |ПОМЕСТИТЬ ВТ
	                      |ИЗ
	                      |	Документ.Матч.СоставыКоманд КАК МатчСоставыКоманд
	                      |		ВНУТРЕННЕЕ СОЕДИНЕНИЕ Документ.Матч КАК Матч
	                      |		ПО МатчСоставыКоманд.Ссылка = Матч.Ссылка
	                      |ГДЕ
	                      |	Матч.Дата МЕЖДУ &ДатаН И &ДатаК
	                      |	И Матч.Проведен = ИСТИНА
	                      |	И МатчСоставыКоманд.Команда = &Команда
	                      |
	                      |УПОРЯДОЧИТЬ ПО
	                      |	Матч.Дата УБЫВ
	                      |;
	                      |
	                      |////////////////////////////////////////////////////////////////////////////////
	                      |ВЫБРАТЬ РАЗЛИЧНЫЕ
	                      |	МатчСоставыКоманд.Игрок КАК Игрок,
	                      |	МатчСоставыКоманд.Команда КАК Команда,
	                      |	Игроки.Амплуа КАК Амплуа
	                      |ИЗ
	                      |	Документ.Матч.СоставыКоманд КАК МатчСоставыКоманд
	                      |		ВНУТРЕННЕЕ СОЕДИНЕНИЕ Справочник.Игроки КАК Игроки
	                      |		ПО МатчСоставыКоманд.Игрок = Игроки.Ссылка
	                      |		ВНУТРЕННЕЕ СОЕДИНЕНИЕ ВТ КАК ВТ
	                      |		ПО МатчСоставыКоманд.Ссылка = ВТ.Ссылка
	                      |ГДЕ
	                      |	МатчСоставыКоманд.Команда = &Команда
	                      |	И Игроки.ПометкаУдаления = ЛОЖЬ
	                      |
	                      |УПОРЯДОЧИТЬ ПО
	                      |	Амплуа,
	                      |	Игрок
	                      |АВТОУПОРЯДОЧИВАНИЕ");
	Запрос.УстановитьПараметр("ДатаК", 		НачалоДня(Объект.Дата) - 1);
	Запрос.УстановитьПараметр("ДатаН", 		НачалоДня(ДобавитьМесяц(Объект.Дата, -6)));
	Для Каждого ТекСтрока Из Объект.Команды Цикл
		Запрос.УстановитьПараметр("Команда",	ТекСтрока.Команда);
		СоставыКомандДобавить(Запрос.Выполнить().Выбрать());
	КонецЦикла;
КонецПроцедуры

&НаСервере
Процедура СоставыКомандДобавить(Выборка)
	Пока Выборка.Следующий() Цикл
		ЗаполнитьЗначенияСвойств(Объект.СоставыКоманд.Добавить(), Выборка);
	КонецЦикла;
КонецПроцедуры

&НаСервере
Функция ГрафикОбновитьНаСервере(Команда, Колонка=0)
	Запрос = Новый Запрос("ВЫБРАТЬ
		               |	РАЗНОСТЬДАТ(Игроки.ДатаРождения, &Дата, ДЕНЬ) КАК Количество,
		               |	Игроки.ДатаРождения КАК ДатаРождения
		               |ИЗ
		               |	Документ.Матч.СоставыКоманд КАК Матч
		               |		ВНУТРЕННЕЕ СОЕДИНЕНИЕ РегистрСведений.ПеремещенияИгроков.СрезПоследних(&Дата, ГОД(Игрок.ДатаРождения) > 1900) КАК Перемещения
		               |		ПО Матч.Игрок = Перемещения.Игрок
		               |		ВНУТРЕННЕЕ СОЕДИНЕНИЕ Справочник.Игроки КАК Игроки
		               |		ПО Матч.Игрок = Игроки.Ссылка
		               |ГДЕ
		               |	Матч.Ссылка = &Ссылка
		               |	И Матч.Команда = &Команда");
	Запрос.УстановитьПараметр("Дата",		Объект.Дата);
	Запрос.УстановитьПараметр("Ссылка",		Объект.Ссылка);
	Запрос.УстановитьПараметр("Команда",	Команда);
	Если ЗначениеЗаполнено(Амплуа) Тогда
		Запрос.Текст = "ВЫБРАТЬ
		               |	РАЗНОСТЬДАТ(Игроки.ДатаРождения, &Дата, ДЕНЬ) КАК Количество,
		               |	Игроки.ДатаРождения КАК ДатаРождения
		               |ИЗ
		               |	Документ.Матч.СоставыКоманд КАК Матч
		               |		ВНУТРЕННЕЕ СОЕДИНЕНИЕ РегистрСведений.ПеремещенияИгроков.СрезПоследних(&Дата, ГОД(Игрок.ДатаРождения) > 1900) КАК Перемещения
		               |			ЛЕВОЕ СОЕДИНЕНИЕ Справочник.Амплуа КАК Роли
		               |			ПО Перемещения.Амплуа = Роли.Ссылка
		               |		ПО Матч.Игрок = Перемещения.Игрок
		               |		ВНУТРЕННЕЕ СОЕДИНЕНИЕ Справочник.Игроки КАК Игроки
		               |		ПО Матч.Игрок = Игроки.Ссылка
		               |ГДЕ
		               |	Матч.Ссылка = &Ссылка
		               |	И Матч.Команда = &Команда
		               |	И ЕСТЬNULL(Роли.Ссылка, Игроки.Амплуа) = &Амплуа";
		Запрос.УстановитьПараметр("Амплуа",		Амплуа);
	КонецЕсли;
	Возврат Запрос.Выполнить().Выгрузить().ВыгрузитьКолонку(Колонка);
КонецФункции

//СерияЦвет()
//Возврат ЦветаСтиля.ЦветОтрицательногоЧисла

&НаКлиенте
Процедура АнонсОбновить(Команда=Неопределено)
	Если КомандыДве() Тогда
		Если Элементы.ГруппаАнонс.Видимость Тогда
			АнонсОбновитьНаСервере();
		Иначе
			АнонсОбновитьНаСервере2();
		КонецЕсли;
	КонецЕсли;
КонецПроцедуры

&НаСервере
Функция Чемпионат()
	Если НЕ ЗначениеЗаполнено(Чемпионат) Тогда
		Чемпионат	= Объект.Тур.Владелец;
		Если НЕ ЗначениеЗаполнено(Чемпионат) Тогда
			Чемпионат = СерверныйФункции.ЧемпионатПолучитьПоследнее(КомандыПолучить());
		КонецЕсли;
	КонецЕсли;
	Возврат Чемпионат;
КонецФункции

&НаСервере
Процедура АнонсОбновитьНаСервере()
	Хозяева		= Хозяева();
	ИзображениеХозяева	= ПолучитьНавигационнуюСсылку(Хозяева, "Изображение");
	Гости		= Гости();
	ИзображениеГости	= ПолучитьНавигационнуюСсылку(Гости, "Изображение");
	
	ИгрСНачалаСезона	= 0;
	Очки				= 0;
	Побед				= 0;
	Ничьих				= 0;
	Проигрышей			= 0;
	КоличествоГолов		= 0;
	Результативность	= 0;
	
	ИгрСНачалаСезонаГости	= 0;
	ОчкиГости				= 0;
	ПобедГости				= 0;
	НичьихГости				= 0;
	ПроигрышейГости			= 0;
	КоличествоГоловГости	= 0;
	РезультативностьГости	= 0;
	
	Элементы.ИгрСНачалаСезона.МаксимальноеЗначение	= 0;
	Элементы.Очки.МаксимальноеЗначение				= 0;
	Элементы.Побед.МаксимальноеЗначение				= 0;
	Элементы.Ничьих.МаксимальноеЗначение			= 0;
	Элементы.Проигрышей.МаксимальноеЗначение		= 0;
	Элементы.КоличествоГолов.МаксимальноеЗначение	= 0;
	Элементы.Результативность.МаксимальноеЗначение	= 0;
	
	Тимз				= КомандыПолучить();
	Чемпионат			= Чемпионат();
	Запрос = Новый Запрос("ВЫБРАТЬ
	                      |	ТурнирнаяТаблица.Команда КАК Команда,
	                      |	ТурнирнаяТаблица.КоличествоОчков КАК КоличествоОчков,
	                      |	СУММА(1) КАК Количество,
	                      |	СУММА(ТурнирнаяТаблица.КоличествоГолов) КАК КоличествоГолов,
	                      |	ТурнирнаяТаблица.Команда = &Хозяева КАК Хозяева
	                      |ИЗ
	                      |	РегистрНакопления.ТурнирнаяТаблица КАК ТурнирнаяТаблица
	                      |		ВНУТРЕННЕЕ СОЕДИНЕНИЕ Документ.Матч КАК Матч
	                      |		ПО ТурнирнаяТаблица.Регистратор = Матч.Ссылка
	                      |		ВНУТРЕННЕЕ СОЕДИНЕНИЕ Справочник.Туры КАК Туры
	                      |		ПО ТурнирнаяТаблица.Тур = Туры.Ссылка
	                      |ГДЕ
	                      |	ТурнирнаяТаблица.Период МЕЖДУ &ДатаН И &ДатаК
	                      |	И ТурнирнаяТаблица.Команда В(&Команды)
	                      |	И Туры.Владелец = &Чемпионат
	                      |
	                      |СГРУППИРОВАТЬ ПО
	                      |	ТурнирнаяТаблица.КоличествоОчков,
	                      |	ТурнирнаяТаблица.Команда
	                      |
	                      |УПОРЯДОЧИТЬ ПО
	                      |	Хозяева УБЫВ");
	Если НЕ ЗначениеЗаполнено(Чемпионат) Тогда
		Запрос.Текст = СтрЗаменить(Запрос.Текст, "И Туры.Владелец = &Чемпионат", "");
		Элементы.ДекорацияИгрСНачалаСезона.Заголовок	= "Игр за последний год";
	КонецЕсли;
	Запрос.УстановитьПараметр("Команды",	Тимз);
	Запрос.УстановитьПараметр("Хозяева",	Хозяева);
	Запрос.УстановитьПараметр("Чемпионат",	Чемпионат);
	Запрос.УстановитьПараметр("ДатаК",		НачалоДня(Объект.Дата) - 1);
	Запрос.УстановитьПараметр("ДатаН",		НачалоМесяца(ДобавитьМесяц(Запрос.Параметры.ДатаК, -12)));
	Выборка = Запрос.Выполнить().Выбрать();
	Пока Выборка.Следующий() Цикл
		Элементы.ИгрСНачалаСезона.МаксимальноеЗначение	= Элементы.ИгрСНачалаСезона.МаксимальноеЗначение + Выборка.Количество;
		Элементы.Очки.МаксимальноеЗначение				= Элементы.Очки.МаксимальноеЗначение + Выборка.Количество * Выборка.КоличествоОчков;
		Если Выборка.Хозяева Тогда
			ИгрСНачалаСезона		= ИгрСНачалаСезона + Выборка.Количество;
			Очки					= Очки + Выборка.Количество * Выборка.КоличествоОчков;
		Иначе
			ИгрСНачалаСезонаГости	= ИгрСНачалаСезонаГости + Выборка.Количество;
			ОчкиГости				= ОчкиГости + Выборка.Количество * Выборка.КоличествоОчков;
		КонецЕсли;
		Если Выборка.КоличествоОчков = 0 Тогда
			Элементы.Проигрышей.МаксимальноеЗначение		= Элементы.Проигрышей.МаксимальноеЗначение + Выборка.Количество;
			Если Выборка.Хозяева Тогда
				Проигрышей			= Проигрышей + Выборка.Количество;
			Иначе
				ПроигрышейГости		= ПроигрышейГости + Выборка.Количество;
			КонецЕсли;
		ИначеЕсли Выборка.КоличествоОчков = 1 Тогда
			Элементы.Ничьих.МаксимальноеЗначение			= Элементы.Ничьих.МаксимальноеЗначение + Выборка.Количество;
			Если Выборка.Хозяева Тогда
				Ничьих				= Ничьих + Выборка.Количество;
			Иначе
				НичьихГости			= НичьихГости + Выборка.Количество;
			КонецЕсли;
		Иначе
			Элементы.Побед.МаксимальноеЗначение				= Элементы.Побед.МаксимальноеЗначение + Выборка.Количество;
			Если Выборка.Хозяева Тогда
				Побед				= Побед + Выборка.Количество;
			Иначе
				ПобедГости			= ПобедГости + Выборка.Количество;
			КонецЕсли;
		КонецЕсли;
		
		Элементы.КоличествоГолов.МаксимальноеЗначение	= Выборка.КоличествоГолов + Элементы.КоличествоГолов.МаксимальноеЗначение;
		Если Выборка.Хозяева Тогда
			КоличествоГолов				= КоличествоГолов + Выборка.КоличествоГолов;
		Иначе
			КоличествоГоловГости		= КоличествоГоловГости + Выборка.КоличествоГолов;
		КонецЕсли;
	КонецЦикла;
	Если КоличествоГолов + КоличествоГоловГости > 0 Тогда
		Элементы.Результативность.МаксимальноеЗначение	= Окр(КоличествоГолов / ИгрСНачалаСезона, 1) + Окр(КоличествоГоловГости / ИгрСНачалаСезонаГости, 1);
		Результативность		= Окр(КоличествоГолов / ИгрСНачалаСезона, 1);
		РезультативностьГости	= Окр(КоличествоГоловГости / ИгрСНачалаСезонаГости, 1);
	КонецЕсли;
	
	ЭлементыУдалить();
	
	Запрос.Текст = "ВЫБРАТЬ РАЗЛИЧНЫЕ ПЕРВЫЕ 5
	               |	ИСТИНА КАК Хозяева,
	               |	ТурнирнаяТаблица.Период КАК Период,
	               |	ТурнирнаяТаблица.КоличествоОчков КАК КоличествоОчков
	               |ПОМЕСТИТЬ ВТ
	               |ИЗ
	               |	РегистрНакопления.ТурнирнаяТаблица КАК ТурнирнаяТаблица
	               |		ВНУТРЕННЕЕ СОЕДИНЕНИЕ Справочник.Туры КАК Туры
	               |		ПО ТурнирнаяТаблица.Тур = Туры.Ссылка
	               |ГДЕ
	               |	ТурнирнаяТаблица.Период МЕЖДУ &ДатаН И &ДатаК
	               |	И ТурнирнаяТаблица.Команда = &Хозяева
	               |	И ТИПЗНАЧЕНИЯ(ТурнирнаяТаблица.Регистратор) = ТИП(Документ.Матч)
	               |	И Туры.Владелец = &Чемпионат
	               |
	               |ОБЪЕДИНИТЬ ВСЕ
	               |
	               |ВЫБРАТЬ РАЗЛИЧНЫЕ ПЕРВЫЕ 5
	               |	ЛОЖЬ,
	               |	ТурнирнаяТаблица.Период,
	               |	ТурнирнаяТаблица.КоличествоОчков
	               |ИЗ
	               |	РегистрНакопления.ТурнирнаяТаблица КАК ТурнирнаяТаблица
	               |		ВНУТРЕННЕЕ СОЕДИНЕНИЕ Справочник.Туры КАК Туры
	               |		ПО ТурнирнаяТаблица.Тур = Туры.Ссылка
	               |ГДЕ
	               |	ТурнирнаяТаблица.Период МЕЖДУ &ДатаН И &ДатаК
	               |	И ТурнирнаяТаблица.Команда = &Гости
	               |	И ТИПЗНАЧЕНИЯ(ТурнирнаяТаблица.Регистратор) = ТИП(Документ.Матч)
	               |	И Туры.Владелец = &Чемпионат
	               |
	               |УПОРЯДОЧИТЬ ПО
	               |	Период УБЫВ
	               |;
	               |
	               |////////////////////////////////////////////////////////////////////////////////
	               |ВЫБРАТЬ
	               |	ВТ.Хозяева КАК Хозяева,
	               |	ВТ.Период КАК Период,
	               |	ВТ.КоличествоОчков КАК КоличествоОчков
	               |ИЗ
	               |	ВТ КАК ВТ
	               |
	               |УПОРЯДОЧИТЬ ПО
	               |	Хозяева УБЫВ,
	               |	Период";
	Запрос.Текст = СтрЗаменить(Запрос.Текст, "5", Формат(КоличествоМатчейВАнонсе(), "ЧН=5; ЧГ=0"));
	Запрос.УстановитьПараметр("Гости",		Гости());
	Выборка = Запрос.Выполнить().Выбрать();
	Пока Выборка.Следующий() Цикл
		Если Выборка.Хозяева Тогда
			ИграУстановить2(Элементы.ГруппаПредыдущие5Хозяева, Выборка.КоличествоОчков);
		Иначе
			ИграУстановить2(Элементы.ГруппаПредыдущие5Гости, Выборка.КоличествоОчков);
		КонецЕсли;
	КонецЦикла;
КонецПроцедуры

&НаСервере
Процедура ЭлементыУдалить2(Викимз)
	Пока Викимз.Количество() > 0 Цикл
		Для Каждого Элемент Из Викимз Цикл
			Элементы.Удалить(Элемент);
		КонецЦикла;
	КонецЦикла;
КонецПроцедуры

&НаСервере
Процедура ЭлементыУдалить()
	ЭлементыУдалить2(Элементы.ГруппаПредыдущие5Хозяева.ПодчиненныеЭлементы);
	ЭлементыУдалить2(Элементы.ГруппаПредыдущие5Гости.ПодчиненныеЭлементы);
КонецПроцедуры

&НаСервере
Процедура ИграУстановить2(Родитель, КоличествоОчков)
	Элемент = Элементы.Добавить("_" + Лев(Новый УникальныйИдентификатор, 8), Тип("ДекорацияФормы"), Родитель);
	Если КоличествоОчков = 0 Тогда
		Элемент.Заголовок	= "L";
		Элемент.ЦветТекста	= ЦветаСтиля.ЦветОтрицательногоЧисла;
	ИначеЕсли КоличествоОчков = 1 Тогда
		Элемент.Заголовок	= "D";
		//Элемент.ЦветТекста	= ЦветаСтиля.ЦветТекстаПоля;
		//Элемент.ЦветФона	= ЦветаСтиля.ЦветРамки;
	Иначе
		Элемент.Заголовок	= "W";
		Элемент.ЦветТекста	= ЦветаСтиля.ЦветАкцента;
	КонецЕсли;
КонецПроцедуры

&НаСервере
Процедура ИграУстановить(Элемент, Игра, КоличествоОчков)
	Если КоличествоОчков = 0 Тогда
		Игра	= "L";
		Элемент.ЦветТекста	= ЦветаСтиля.ЦветОтрицательногоЧисла;
	ИначеЕсли КоличествоОчков = 1 Тогда
		Игра	= "D";
		Элемент.ЦветТекста	= ЦветаСтиля.ЦветТекстаПоля;
		//Элемент.ЦветФона	= ЦветаСтиля.ЦветРамки;
	Иначе
		Игра	= "W";
		Элемент.ЦветТекста	= ЦветаСтиля.ЦветАкцента;
	КонецЕсли;
	Элемент.Видимость	= Истина;
КонецПроцедуры

&НаСервере
Функция КоличествоМатчейВАнонсе()
	Возврат СерверныйФункции.КоличествоМатчейВАнонсе();
КонецФункции

&НаСервере
Процедура АнонсОбновитьНаСервере2()
	Сезон.Очистить();
	Предыдущие5.Очистить();
	Макет	= ПолучитьОбщийМакет("Матчи");
	Сколько	= КоличествоМатчейВАнонсе();
	
	Для Каждого тСтрока Из Объект.Команды Цикл
		Стат = СерверныйФункции.СтатистикаИгр(тСтрока.Команда, Чемпионат());
		Для Каждого ТекЭлемент Из Стат Цикл
			нСтрока = Сезон.Добавить();
			ЗаполнитьЗначенияСвойств(нСтрока, ТекЭлемент);
			нСтрока.Команда	= тСтрока.Команда;
		КонецЦикла;

		Выборка = СерверныйФункции.МатчиПоследние5(тСтрока.Команда, Чемпионат(), Объект.Дата, Сколько);
		Итератор = 0;
		Для Каждого Детали Из Выборка Цикл
			Область = Макет.ПолучитьОбласть("История|CC");
			Область.Параметры.Заполнить(Детали);
			Предыдущие5.Вывести(Область);
			
			Итератор = Итератор + 1;
			Прервать;
		КонецЦикла;
		Если Итератор > 0 Тогда
			Для Каждого Детали Из Выборка Цикл
				Область = Макет.ПолучитьОбласть("История|" + Детали.Результат);
				Область.Параметры.Заполнить(Детали);
				Предыдущие5.Присоединить(Область);
				Итератор = Итератор + 1;
			КонецЦикла;
			Пока Итератор <= Сколько Цикл
				Предыдущие5.Присоединить(Макет.ПолучитьОбласть("История|EE"));
				Итератор = Итератор + 1;
			КонецЦикла;
		КонецЕсли;
	КонецЦикла;
	Предыдущие5.ФиксацияСверху	= 2;
	Предыдущие5.ФиксацияСлева	= Сколько + 1;
КонецПроцедуры

&НаКлиенте
Процедура ГрафикОбновить(Команда=Неопределено)
	График.Очистить();
	Если КомандыДве() Тогда
		Если ЗначениеЗаполнено(Амплуа) Тогда
			Для Каждого тКоманда Из Объект.Команды Цикл
				мСтроки = ГрафикОбновитьНаСервере(тКоманда.Команда);
				Для тФаза = 1 По 3 Цикл
					Серия	= График.УстановитьСерию(Биоритмы.ФЭИ(тФаза));
					//Серия.Цвет = СерияЦвет(тФаза);
					
					КолИтого	= 0;
					ВесИтого	= 0;
					Для Каждого тЭлемент Из мСтроки Цикл
						КолИтого	= КолИтого + 1;
						ВесИтого	= ВесИтого + Биоритмы.ФазаРасчитать2(тЭлемент, тФаза);
					КонецЦикла;
					Если КолИтого > 0 Тогда
						Точка	= График.УстановитьТочку(тКоманда.Команда);
						График.УстановитьЗначение(Точка, Серия, Окр(ВесИтого / КолИтого, 1));
					КонецЕсли;
				КонецЦикла;
			КонецЦикла;
		Иначе
			Для Каждого тКоманда Из Объект.Команды Цикл
				мСтроки = ГрафикОбновитьНаСервере(тКоманда.Команда, "ДатаРождения");
				Для тФаза = 1 По 3 Цикл
					Серия	= График.УстановитьСерию(Биоритмы.ФЭИ(тФаза));
					
					КолИтого	= 0;
					ВесИтого	= 0;
					Для Каждого тЭлемент Из мСтроки Цикл
						КолИтого	= КолИтого + 1;
						ВесИтого	= ВесИтого + Биоритмы.ФазаРасчитать1(тЭлемент, тФаза, Объект.Дата);
					КонецЦикла;
					Если КолИтого > 0 Тогда
						Точка	= График.УстановитьТочку(тКоманда.Команда);
						График.УстановитьЗначение(Точка, Серия, Окр(ВесИтого / КолИтого, 1));
					КонецЕсли;
				КонецЦикла;
			КонецЦикла;
		КонецЕсли;
	КонецЕсли;
КонецПроцедуры

&НаКлиенте
Процедура СоставыЗаполнить(Команда=Неопределено)
	Если КомандыДве() Тогда
		СоставыЗаполнитьНаСервере();
	КонецЕсли;
КонецПроцедуры

&НаКлиенте
Функция КомандыДве()
	Если Объект.Команды.Количество() = 2 Тогда Возврат Истина; КонецЕсли;
	ОбщегоНазначения.СообщитьОбОшибке("Сначала заполните таблицу 'Команды' ",, Объект.Ссылка, "Команды");
	Элементы.Страницы.ТекущаяСтраница = Элементы.ГруппаКоманды;
	Возврат Ложь;
КонецФункции

&НаКлиенте
Процедура СтраницыПриСменеСтраницы(Элемент, ТекущаяСтраница)
	Если Элементы.ГруппаСравнение = ТекущаяСтраница Тогда
		Если График.КоличествоСерий <> 3 И Объект.СоставыКоманд.Количество() > 0 Тогда
			ГрафикОбновить();
			РаздельноПриИзменении();
		КонецЕсли;
		
	ИначеЕсли Элементы.ГруппаАнонс = ТекущаяСтраница Тогда
		Если ИгрСНачалаСезона = 0 Тогда
			АнонсОбновить();
		КонецЕсли;
	ИначеЕсли Элементы.ГруппаАнонс2 = ТекущаяСтраница Тогда
		Если Сезон.Количество() = 0 Тогда
			АнонсОбновить();
		КонецЕсли;
	ИначеЕсли Элементы.ГруппаБиоритмы = ТекущаяСтраница Тогда
		Если График2.КоличествоСерий = 0 И Объект.СоставыКоманд.Количество() > 0 Тогда
			График2Обновить();
		КонецЕсли;
		
	ИначеЕсли Элементы.ГруппаМатчи = ТекущаяСтраница Тогда
		Если ПредыдущиеМатчиКоличество = 0 Тогда
			ПредыдущиеВстречиОбновитьНаСервере();
			ПредыдущиеМатчиОбновитьНаСервере();
		КонецЕсли;
	КонецЕсли;
КонецПроцедуры

&НаСервере
Функция Хозяева()
	Возврат ?(Объект.Команды.Количество() = 0, Справочники.Команды.ПустаяСсылка(), Объект.Команды.Получить(0).Команда);
КонецФункции

&НаСервере
Функция Гости()
	Возврат ?(Объект.Команды.Количество() < 2, Неопределено, Объект.Команды.Получить(1).Команда);
КонецФункции

&НаСервере
Процедура ОбработкаПроверкиЗаполненияНаСервере(Отказ, ПроверяемыеРеквизиты)
	Если Объект.Команды.Количество() = 2 Тогда
		Отказ = СерверныйФункции.МатчОбработкаПроверкиЗаполнения(Объект);
		Если Отказ Тогда
			ОбщегоНазначения.СообщитьОбОшибке("ТЧ 'Составы команд' заполнена неверно", Отказ, Объект.Ссылка, "СоставыКоманд.Команда");
		КонецЕсли;
		
	Иначе
		ОбщегоНазначения.СообщитьОбОшибке("ТЧ 'Команды' заполнена неверно", Отказ, Объект.Ссылка, "Команды");
	КонецЕсли;
КонецПроцедуры

&НаСервере
Процедура СтадионПриИзмененииНаСервере()
	тКоманда = Объект.Стадион.Владелец;
	Если ЗначениеЗаполнено(тКоманда) И ТипЗнч(тКоманда) = Тип("СправочникСсылка.Команды") Тогда
		мКоманды = Объект.Команды.НайтиСтроки(Новый Структура("Команда", тКоманда));
		Если мКоманды.Количество() = 0 Тогда
			Если Объект.Команды.Количество() = 0 Тогда
				тСтрока = Объект.Команды.Добавить();
			Иначе
				тСтрока = Объект.Команды.Получить(0);
			КонецЕсли;
			тСтрока.Команда = тКоманда;
		КонецЕсли;
	КонецЕсли;
КонецПроцедуры

&НаКлиенте
Процедура СтадионПриИзменении(Элемент)
	СтадионПриИзмененииНаСервере();
КонецПроцедуры

&НаКлиенте
Процедура СоставыКомандИгрокПриИзменении(Элемент)
	Элементы.СоставыКоманд.ТекущиеДанные.Команда = СерверныйФункции.КомандаИгрока(Элементы.СоставыКоманд.ТекущиеДанные.Игрок, Объект.Дата);
КонецПроцедуры

&НаКлиенте
Процедура АмплуаПриИзменении(Элемент)
	ГрафикОбновить();
КонецПроцедуры

&НаКлиенте
Процедура РаздельноПриИзменении(Элемент=Неопределено)
	График.ТипДиаграммы	= ?(Раздельно, ТипДиаграммы.ГистограммаОбъемная, ТипДиаграммы.ГистограммаСНакоплениемОбъемная);
КонецПроцедуры

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	ЭтоДерби	= "ДЕРБИ";
	
	Если СерверныйФункции.СтарыйВидАнонсов() Тогда
		Элементы.ГруппаАнонс.Видимость	= Ложь;
	Иначе
		Элементы.ГруппаАнонс2.Видимость	= Ложь;
	КонецЕсли;
КонецПроцедуры

&НаКлиенте
Процедура ПриОткрытии(Отказ)
	ТурПриИзменении();
	КомандыПриИзменении();
	//РаздельноПриИзменении();
	ВидимостьДоступностьУстановить();
КонецПроцедуры

&НаСервере
Процедура ВидимостьДоступностьУстановить()
	Элементы.ЭтоДерби.Видимость				= СерверныйФункции.ЭтоДерби(Объект.Ссылка);
	Элементы.ГруппаАнонс.Доступность		= (НЕ Объект.Ссылка.Пустая());
	Элементы.ГруппаАнонс2.Доступность		= (НЕ Объект.Ссылка.Пустая());
	//Элементы.ГруппаСравнение.Доступность	= (Объект.СоставыКоманд.Количество() > 0);
	Элементы.ГруппаМатчи.Доступность		= (Объект.Команды.Количество() = 2);
КонецПроцедуры

&НаСервере
Процедура ПослеЗаписиНаСервере(ТекущийОбъект, ПараметрыЗаписи)
	ВидимостьДоступностьУстановить();
КонецПроцедуры

&НаКлиенте
Процедура СоставыКомандПередОкончаниемРедактирования(Элемент, НоваяСтрока, ОтменаРедактирования, Отказ)
	Если Элемент.ТекущиеДанные.Свойство("Команда")
	И ЗначениеЗаполнено(Элемент.ТекущиеДанные.Команда)
	Тогда
		мСтроки = Объект.Команды.НайтиСтроки(Новый Структура("Команда", Элемент.ТекущиеДанные.Команда));
		Если мСтроки.Количество() = 0 Тогда
			Отказ = Истина;
			
			Сообщить("Игрок из другой команды");
		КонецЕсли;
	КонецЕсли;
КонецПроцедуры

&НаСервере
Процедура КомандыПриИзмененииНаСервере()
	Элементы.ГрафикКоманда.СписокВыбора.Очистить();
	
	Если Объект.СоставыКоманд.Количество() > 0 Тогда
		СписокШиндлера	= Новый Массив;
		мКоманды = Новый Массив;
		Для Каждого тСтрока Из Объект.Команды Цикл
			мКоманды.Добавить(тСтрока.Команда);
			Если тСтрока.НомерСтроки = 1 Тогда
				Объект.Стадион = СтадионПодобрать(тСтрока.Команда);
			КонецЕсли;
			
			Элементы.ГрафикКоманда.СписокВыбора.Добавить(тСтрока.Команда);
			Если НЕ ЗначениеЗаполнено(ГрафикКоманда) Тогда
				ГрафикКоманда = тСтрока.Команда;
			КонецЕсли;
		КонецЦикла;
		
		Для Каждого тСтрока Из Объект.СоставыКоманд Цикл
			Если мКоманды.Найти(тСтрока.Команда) = Неопределено Тогда
				СписокШиндлера.Добавить(тСтрока);
			КонецЕсли;
		КонецЦикла;
		
		Для Каждого тСтрока Из СписокШиндлера Цикл
			Объект.СоставыКоманд.Удалить(тСтрока);
		КонецЦикла;
		
	Иначе
		Для Каждого тСтрока Из Объект.Команды Цикл
			Если тСтрока.НомерСтроки = 1 Тогда
				Объект.Стадион = СтадионПодобрать(тСтрока.Команда);
				//Прервать;
			КонецЕсли;
			Элементы.ГрафикКоманда.СписокВыбора.Добавить(тСтрока.Команда);
			Если НЕ ЗначениеЗаполнено(ГрафикКоманда) Тогда
				ГрафикКоманда = тСтрока.Команда;
			КонецЕсли;
		КонецЦикла;
	КонецЕсли;
	
	Элементы.Тур.СписокВыбора.Очистить();
	Элементы.Стадион.СписокВыбора.Очистить();
	
	ТЧОчистить();
КонецПроцедуры

&НаКлиенте
Процедура КомандыПриИзменении(Элемент=Неопределено)
	Если Элементы.Команды.ТекущиеДанные = Неопределено Тогда
		Если НЕ ПустаяСтрока(Объект.Стадион) Тогда
			Объект.Стадион = Неопределено;
		КонецЕсли;
		
	ИначеЕсли НЕ ЗначениеЗаполнено(Объект.Тур) Тогда
		Объект.Тур		= СерверныйФункции.Тур(Элементы.Команды.ТекущиеДанные.Команда, Объект.Дата);
	КонецЕсли;
	
	КомандыПриИзмененииНаСервере();
КонецПроцедуры

&НаСервере
Функция СтадионПодобрать(Тим)
	Ответ = Неопределено;
	Виктимз	= СтадионНайти(Тим, Объект.Тур);
	Если ТипЗнч(Виктимз) = Тип("СправочникСсылка.Стадионы") Тогда
		Ответ = Виктимз;
	ИначеЕсли Виктимз.Количество() > 0 Тогда
		Ответ = Виктимз.Получить(0);
	КонецЕсли;
	Возврат Ответ;
КонецФункции

&НаСервереБезКонтекста
Функция СтадионНайти(Тим, Тур=Неопределено)
	Если ЗначениеЗаполнено(Тур) И Тур.ОлимпийскаяСистема Тогда
		Ответ = СерверныйФункции.СтадионНайти(Тур.Владелец, Истина);
	Иначе
		Ответ = Новый Массив;
		Ответ.Добавить(СерверныйФункции.СтадионНайти(Тим));
	КонецЕсли;
	Возврат Ответ;
КонецФункции

&НаКлиенте
Процедура СтадионНачалоВыбора(Элемент, ДанныеВыбора, СтандартнаяОбработка)
	Если Объект.Команды.Количество() > 0
	//И Элемент.СписокВыбора.Количество() = 0
	Тогда
		Стадионы.ЗагрузитьЗначения(СтадионНайти(Объект.Команды.Получить(0).Команда, Объект.Тур));
		Если Стадионы.Количество() = 1 Тогда
			Стадион = Стадионы.Получить(0).Значение;
			Если НЕ ЗначениеЗаполнено(Объект.Стадион) Тогда
				СтандартнаяОбработка	= Ложь;
				Модифицированность		= Истина;
				Объект.Стадион			= Стадион;
			КонецЕсли;
			Если Элемент.СписокВыбора.НайтиПоЗначению(Стадион) = Неопределено Тогда
				Элемент.СписокВыбора.Добавить(Стадион);
			КонецЕсли;
		//ИначеЕсли Стадионы.Количество() > 0 Тогда
		//	Элемент.СписокВыбора.ЗагрузитьЗначения(Стадионы.ВыгрузитьЗначения());
		КонецЕсли;
	КонецЕсли;
КонецПроцедуры

&НаКлиенте
Процедура СоставыКомандИгрокНачалоВыбора(Элемент, ДанныеВыбора, СтандартнаяОбработка)
	Тимз = Новый Массив;
	Для Каждого ТекСтрока Из Объект.Команды Цикл
		Тимз.Добавить(ТекСтрока.Команда);
	КонецЦикла;
	Игроки.ЗагрузитьЗначения(ИгрокиПолучить(Объект.Дата, Тимз));
КонецПроцедуры

&НаСервереБезКонтекста
Функция ИгрокиПолучить(Дата, Команды)
	Запрос = Новый Запрос("ВЫБРАТЬ
	                      |	Перемещения.Игрок КАК Игрок,
	                      |	Перемещения.Команда КАК Команда
	                      |ИЗ
	                      |	РегистрСведений.ПеремещенияИгроков.СрезПоследних(&Дата, ) КАК Перемещения
	                      |ГДЕ
	                      |	Перемещения.Команда В(&Команды)
	                      |
	                      |УПОРЯДОЧИТЬ ПО
	                      |	Команда,
	                      |	Игрок
	                      |АВТОУПОРЯДОЧИВАНИЕ");
	Запрос.УстановитьПараметр("Дата",		Дата);
	Запрос.УстановитьПараметр("Команды",	Команды);
	Возврат Запрос.Выполнить().Выгрузить().ВыгрузитьКолонку(0);
КонецФункции

&НаСервере
Процедура ПредыдущиеВстречиОбновитьНаСервере()
	ПредыдущиеВстречи.Очистить();
	Если Объект.Команды.Количество() <> 2 Тогда Возврат; КонецЕсли;
	
	Запрос = Новый Запрос("ВЫБРАТЬ РАЗЛИЧНЫЕ
	                      |	Матч.Дата КАК Дата,
	                      |	Матч.Счет КАК Счет,
	                      |	МатчКоманды.Ссылка КАК Матч,
	                      |	Туры.Владелец КАК Чемпионат,
	                      |	ТурнирнаяТаблица.Команда = &Хозяева КАК Хозяева
	                      |ИЗ
	                      |	Документ.Матч КАК Матч
	                      |		ВНУТРЕННЕЕ СОЕДИНЕНИЕ РегистрНакопления.ТурнирнаяТаблица КАК ТурнирнаяТаблица
	                      |			ВНУТРЕННЕЕ СОЕДИНЕНИЕ Документ.Матч.Команды КАК МатчКоманды
	                      |			ПО ТурнирнаяТаблица.Регистратор = МатчКоманды.Ссылка
	                      |		ПО Матч.Ссылка = ТурнирнаяТаблица.Регистратор
	                      |		ВНУТРЕННЕЕ СОЕДИНЕНИЕ Справочник.Туры КАК Туры
	                      |		ПО Матч.Тур = Туры.Ссылка
	                      |ГДЕ
	                      |	ТурнирнаяТаблица.Период <= &ДатаК
	                      |	И ТурнирнаяТаблица.Команда В(&Команды)
	                      |	И ТурнирнаяТаблица.НомерСтроки = 1
	                      |	И МатчКоманды.Команда В(&Команды)
	                      |	И МатчКоманды.НомерСтроки = 2
	                      |
	                      |УПОРЯДОЧИТЬ ПО
	                      |	Дата УБЫВ");
	Запрос.УстановитьПараметр("ДатаК",			НачалоДня(Объект.Дата) - 1);
	Запрос.УстановитьПараметр("Команды",		КомандыПолучить());
	Запрос.УстановитьПараметр("Хозяева",		Хозяева());
	Выборка = Запрос.Выполнить().Выбрать();
	Макет = ПолучитьОбщийМакет("Матчи");
	ПредыдущиеВстречи.Вывести(Макет.ПолучитьОбласть("Шапка"));
	Пока Выборка.Следующий() Цикл
		Область = Макет.ПолучитьОбласть(?(Выборка.Хозяева, "Хозяева", "Детали"));
		Область.Параметры.Заполнить(Выборка);
		ПредыдущиеВстречи.Вывести(Область);
	КонецЦикла;
	ПредыдущиеВстречи.ФиксацияСверху	= 1;
КонецПроцедуры

&НаСервере
Процедура ПредыдущиеМатчиОбновитьНаСервере()
	ПредыдущиеМатчиКоличество	= 0;
	ПредыдущиеМатчи.Очистить();
	Если Объект.Команды.Количество() <> 2 Тогда Возврат; КонецЕсли;
	
	Запрос = Новый Запрос("ВЫБРАТЬ РАЗЛИЧНЫЕ
	                      |	Матч.Дата КАК Дата,
	                      |	Матч.Счет КАК Счет,
	                      |	Матч.Ссылка КАК Матч,
	                      |	Туры.Владелец КАК Чемпионат,
	                      |	ТурнирнаяТаблица.Команда = &Хозяева КАК Хозяева
	                      |ИЗ
	                      |	РегистрНакопления.ТурнирнаяТаблица КАК ТурнирнаяТаблица
	                      |		ВНУТРЕННЕЕ СОЕДИНЕНИЕ Документ.Матч КАК Матч
	                      |		ПО ТурнирнаяТаблица.Регистратор = Матч.Ссылка
	                      |		ВНУТРЕННЕЕ СОЕДИНЕНИЕ Справочник.Туры КАК Туры
	                      |		ПО ТурнирнаяТаблица.Тур = Туры.Ссылка
	                      |ГДЕ
	                      |	ТурнирнаяТаблица.Период МЕЖДУ &ДатаН И &ДатаК
	                      |	И ТурнирнаяТаблица.Команда В(&Команды)
	                      |
	                      |УПОРЯДОЧИТЬ ПО
	                      |	Дата УБЫВ");
	Если МатчиФильтр = 1 Тогда
		Запрос.Текст = "ВЫБРАТЬ РАЗЛИЧНЫЕ
		               |	Матч.Дата КАК Дата,
		               |	Матч.Счет КАК Счет,
		               |	Матч.Ссылка КАК Матч,
		               |	Туры.Владелец КАК Чемпионат,
		               |	ТурнирнаяТаблица.Команда = &Хозяева КАК Хозяева
		               |ИЗ
		               |	РегистрНакопления.ТурнирнаяТаблица КАК ТурнирнаяТаблица
		               |		ВНУТРЕННЕЕ СОЕДИНЕНИЕ Документ.Матч КАК Матч
		               |		ПО ТурнирнаяТаблица.Регистратор = Матч.Ссылка
		               |		ВНУТРЕННЕЕ СОЕДИНЕНИЕ Справочник.Туры КАК Туры
		               |		ПО ТурнирнаяТаблица.Тур = Туры.Ссылка
		               |ГДЕ
		               |	ТурнирнаяТаблица.Период МЕЖДУ &ДатаН И &ДатаК
		               |	И ТурнирнаяТаблица.Команда В(&Команды)
		               |	И Туры.Владелец = &Чемпионат
		               |
		               |УПОРЯДОЧИТЬ ПО
		               |	Дата УБЫВ";
	ИначеЕсли МатчиФильтр = 2 Тогда
		Запрос.Текст = "ВЫБРАТЬ РАЗЛИЧНЫЕ
		               |	Матч.Дата КАК Дата,
		               |	Матч.Счет КАК Счет,
		               |	Матч.Ссылка КАК Матч,
		               |	Туры.Владелец КАК Чемпионат,
		               |	ТурнирнаяТаблица.Команда = &Хозяева КАК Хозяева
		               |ИЗ
		               |	РегистрНакопления.ТурнирнаяТаблица КАК ТурнирнаяТаблица
		               |		ВНУТРЕННЕЕ СОЕДИНЕНИЕ Документ.Матч КАК Матч
		               |		ПО ТурнирнаяТаблица.Регистратор = Матч.Ссылка
		               |		ВНУТРЕННЕЕ СОЕДИНЕНИЕ Справочник.Команды КАК ВсеКоманды
		               |		ПО ТурнирнаяТаблица.Команда = ВсеКоманды.Ссылка
		               |		ВНУТРЕННЕЕ СОЕДИНЕНИЕ Справочник.Туры КАК Туры
		               |		ПО ТурнирнаяТаблица.Тур = Туры.Ссылка
		               |ГДЕ
		               |	ТурнирнаяТаблица.Период МЕЖДУ &ДатаН И &ДатаК
		               |	И ТурнирнаяТаблица.Команда В(&Команды)
		               |	И ВсеКоманды.Город В
		               |			(ВЫБРАТЬ РАЗЛИЧНЫЕ
		               |				Города.Ссылка КАК Ссылка
		               |			ИЗ
		               |				Справочник.Команды КАК Команды
		               |					ВНУТРЕННЕЕ СОЕДИНЕНИЕ Справочник.Города КАК Города
		               |					ПО
		               |						Команды.Город = Города.Ссылка
		               |			ГДЕ
		               |				ТурнирнаяТаблица.Период МЕЖДУ &ДатаН И &ДатаК
		               |				И Команды.Ссылка В (&Команды))
		               |
		               |УПОРЯДОЧИТЬ ПО
		               |	Дата УБЫВ";
	КонецЕсли;
	Запрос.УстановитьПараметр("ДатаК",			НачалоДня(Объект.Дата) - 1);
	Запрос.УстановитьПараметр("ДатаН",			НачалоДня(ДобавитьМесяц(Объект.Дата, -12)));
	Запрос.УстановитьПараметр("Команды",		КомандыПолучить());
	Запрос.УстановитьПараметр("Хозяева",		Хозяева());
	Запрос.УстановитьПараметр("Чемпионат",		Чемпионат());
	Выборка = Запрос.Выполнить().Выбрать();
	Макет = ПолучитьОбщийМакет("Матчи");
	ПредыдущиеМатчи.Вывести(Макет.ПолучитьОбласть("Шапка"));
	Пока Выборка.Следующий() Цикл
		Область = Макет.ПолучитьОбласть(?(Выборка.Хозяева, "Хозяева", "Детали"));
		Область.Параметры.Заполнить(Выборка);
		ПредыдущиеМатчи.Вывести(Область);
		
		ПредыдущиеМатчиКоличество = ПредыдущиеМатчиКоличество + 1;
	КонецЦикла;
	ПредыдущиеМатчи.ФиксацияСверху	= 1;
КонецПроцедуры

&НаКлиенте
Процедура ПредыдущиеВстречиОбновить(Команда)
	ПредыдущиеВстречиОбновитьНаСервере();
	ПредыдущиеМатчиОбновитьНаСервере();
КонецПроцедуры

&НаСервере
Функция КомандыТура()
	мКоманды	= СерверныйФункции.КомандыТура(Объект.Тур);
	Если мКоманды.Количество() = 0 И Объект.Тур.ОлимпийскаяСистема Тогда
		мКоманды = СерверныйФункции.КомандыЧемпионата(Чемпионат());
	КонецЕсли;
	Возврат мКоманды;
КонецФункции

&НаКлиенте
Процедура ТурПриИзменении(Элемент=Неопределено)
	//Чемпионат	= Чемпионат();
	КомандыТура.ЗагрузитьЗначения(КомандыТура());
	//Если КомандыТура.Количество() = 0 Тогда
	//Иначе
	//КонецЕсли;
КонецПроцедуры

&НаКлиенте
Процедура ОбработкаОповещения(ИмяСобытия, Параметр, Источник)
	Если ТипЗнч(Параметр) = Тип("ДокументСсылка.Матч")
	И Параметр = Объект.Ссылка
	Тогда
		Прочитать();
		
		ВидимостьДоступностьУстановить();
	КонецЕсли;
КонецПроцедуры

&НаКлиенте
Процедура СоставыКомандПередНачаломДобавления(Элемент, Отказ, Копирование, Родитель, Группа, Параметр)
	Если Объект.Команды.Количество() = 0 Тогда Отказ = Истина; КонецЕсли;
КонецПроцедуры

&НаКлиенте
Процедура МатчиФильтрПриИзменении(Элемент)
	ПредыдущиеМатчиОбновитьНаСервере();
КонецПроцедуры

&НаКлиенте
Процедура ДатаПриИзменении(Элемент)
	КомандыПриИзменении();
КонецПроцедуры

&НаСервереБезКонтекста
Функция ТурыПолучить(Дата, Команда=Неопределено)
	Запрос = Новый Запрос("ВЫБРАТЬ РАЗЛИЧНЫЕ
	                      |	Туры.Ссылка КАК Ссылка
	                      |ИЗ
	                      |	Справочник.Туры КАК Туры
	                      |		ВНУТРЕННЕЕ СОЕДИНЕНИЕ Справочник.Чемпионаты.Команды КАК ЧемпионатыКоманды
	                      |		ПО Туры.Владелец = ЧемпионатыКоманды.Ссылка
	                      |ГДЕ
	                      |	&Дата МЕЖДУ Туры.ДатаНачала И КОНЕЦПЕРИОДА(Туры.ДатаОкончания, ДЕНЬ)
	                      |	И Туры.ПометкаУдаления = ЛОЖЬ
	                      |	И ЧемпионатыКоманды.Команда В(&Команда)
	                      |
	                      |УПОРЯДОЧИТЬ ПО
	                      |	Туры.ДатаНачала");
	Если Команда = Неопределено Тогда
		Запрос.Текст = "ВЫБРАТЬ РАЗЛИЧНЫЕ
		               |	Туры.Ссылка КАК Ссылка
		               |ИЗ
		               |	Справочник.Туры КАК Туры
		               |		ВНУТРЕННЕЕ СОЕДИНЕНИЕ Справочник.Чемпионаты.Команды КАК ЧемпионатыКоманды
		               |		ПО Туры.Владелец = ЧемпионатыКоманды.Ссылка
		               |ГДЕ
		               |	&Дата МЕЖДУ Туры.ДатаНачала И КОНЕЦПЕРИОДА(Туры.ДатаОкончания, ДЕНЬ)
		               |	И Туры.ПометкаУдаления = ЛОЖЬ
		               |
		               |УПОРЯДОЧИТЬ ПО
		               |	Туры.ДатаНачала";
	КонецЕсли;
	Запрос.УстановитьПараметр("Дата",			НачалоДня(Дата));
	Запрос.УстановитьПараметр("Команда",		Команда);
	Возврат Запрос.Выполнить().Выгрузить().ВыгрузитьКолонку(0);
КонецФункции

&НаКлиенте
Процедура ТурНачалоВыбора(Элемент, ДанныеВыбора, ВыборДобавлением, СтандартнаяОбработка)
	Если Объект.Команды.Количество() = 0 Тогда
		Туры.ЗагрузитьЗначения(ТурыПолучить(Объект.Дата));
	Иначе
		мКоманды = Новый Массив;
		Для Каждого ТекСтрока Из Объект.Команды Цикл
			мКоманды.Добавить(ТекСтрока.Команда);
		КонецЦикла;
		Туры.ЗагрузитьЗначения(ТурыПолучить(Объект.Дата, мКоманды));
	КонецЕсли;
	Элемент.СписокВыбора.ЗагрузитьЗначения(Туры.ВыгрузитьЗначения());
КонецПроцедуры

&НаСервере
Функция График2ОбновитьНаСервере()
	Запрос = Новый Запрос("ВЫБРАТЬ
	                      |	РАЗНОСТЬДАТ(Игроки.ДатаРождения, &Дата, ДЕНЬ) КАК Количество,
	                      |	Матч.Игрок КАК Игрок,
	                      |	Игроки.Амплуа КАК Амплуа
	                      |ИЗ
	                      |	Документ.Матч.СоставыКоманд КАК Матч
	                      |		ВНУТРЕННЕЕ СОЕДИНЕНИЕ РегистрСведений.ПеремещенияИгроков.СрезПоследних(&Дата, ГОД(Игрок.ДатаРождения) > 1900) КАК Перемещения
	                      |		ПО Матч.Игрок = Перемещения.Игрок
	                      |		ВНУТРЕННЕЕ СОЕДИНЕНИЕ Справочник.Игроки КАК Игроки
	                      |		ПО Матч.Игрок = Игроки.Ссылка
	                      |ГДЕ
	                      |	Матч.Ссылка = &Ссылка
	                      |	И Матч.Команда = &Команда
	                      |
	                      |УПОРЯДОЧИТЬ ПО
	                      |	Амплуа,
	                      |	Игрок
	                      |АВТОУПОРЯДОЧИВАНИЕ");
	Запрос.УстановитьПараметр("Дата",		Объект.Дата);
	Запрос.УстановитьПараметр("Ссылка",		Объект.Ссылка);
	Запрос.УстановитьПараметр("Команда",	ГрафикКоманда);
	Выборка = Запрос.Выполнить().Выбрать();
	Пока Выборка.Следующий() Цикл
		Для тФаза = 1 По 3 Цикл
			Серия	= График2.УстановитьСерию(Биоритмы.ФЭИ(тФаза));
			Точка	= График2.УстановитьТочку(Выборка.Игрок);
			График2.УстановитьЗначение(Точка, Серия, Биоритмы.ФазаРасчитать2(Выборка.Количество, тФаза));
		КонецЦикла;
	КонецЦикла;
КонецФункции

&НаКлиенте
Процедура График2Обновить(Команда=Неопределено)
	График2.Очистить();
	График2ОбновитьНаСервере();
КонецПроцедуры

&НаКлиенте
Процедура ГрафикКомандаПриИзменении(Элемент)
	График2Обновить();
КонецПроцедуры

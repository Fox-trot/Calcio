﻿
Функция ФазыРасчитать(Знач ДатаРождения, Знач ТекущаяДата=Неопределено) Экспорт
	ТекущаяДата	= НачалоДня(?(ТекущаяДата=Неопределено, ТекущаяДата(), ТекущаяДата));
	Ответ	= Новый Структура("Физический,Эмоциональный,Интеллектуальный", 0, 0, 0);
	Ответ.Физический		= ФазаРасчитать2((ТекущаяДата - ДатаРождения) / Сутки(), 1);
	Ответ.Эмоциональный		= ФазаРасчитать2((ТекущаяДата - ДатаРождения) / Сутки(), 2);
	Ответ.Интеллектуальный	= ФазаРасчитать2((ТекущаяДата - ДатаРождения) / Сутки(), 3);
	Возврат Ответ;
КонецФункции

Функция ФазаРасчитать1(Знач ДатаРождения, Знач Фаза=1, Знач ТекущаяДата=Неопределено) Экспорт
	Возврат ФазаРасчитать2(Цел((НачалоДня(?(ТекущаяДата=Неопределено, ТекущаяДата(), ТекущаяДата)) - ДатаРождения) / Сутки()), Фаза);
КонецФункции

Функция ФазаРасчитать2(Знач КоличествоДней, Знач Фаза=1) Экспорт
	Фаза	= ФазаЦикличность(Фаза);									//	общее количество дней фазы
	Ответ	= Окр((КоличествоДней / Фаза - Цел(КоличествоДней / Фаза)) * Фаза, 2);		//	день фазы
	
	Если Ответ <= Окр(Фаза / 4, 1) Тогда
		Ответ	= Окр(Ответ * 25 / Фаза, 1);
		
	ИначеЕсли Ответ <= Окр(Фаза / 2, 1) Тогда
		Ответ	= Окр((Фаза / 4 - (Ответ - Фаза / 4)) * 25 / Фаза, 1);
		
	ИначеЕсли Ответ <= Окр(Фаза / 4 * 3, 1) Тогда	// минус
		Ответ	= - Окр((Ответ - Фаза / 2) * 25 / Фаза, 1);
		
	Иначе	//Если Ответ <= Окр(Фаза / 2, 1) Тогда	// минус
		Ответ	= - Окр((Фаза / 4 - (Ответ - Фаза / 4 * 3)) * 25 / Фаза, 1);
	КонецЕсли;
	Возврат Ответ;
КонецФункции

Функция ФЭИ(Знач Фаза=1) Экспорт
	Возврат ?(Фаза=3, "Интеллектуальный", ?(Фаза=2, "Эмоциональный", "Физический"));
КонецФункции

Функция ФазаЦикличность(Знач Фаза) Экспорт
	Возврат ?(Фаза=3, 33, ?(Фаза=2, 28, 23));
КонецФункции

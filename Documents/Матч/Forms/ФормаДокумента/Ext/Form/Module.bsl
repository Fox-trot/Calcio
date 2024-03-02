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
	Объект.СоставыКоманд.Очистить();
	
	Запрос = Новый Запрос;
	Запрос.УстановитьПараметр("Дата", 		НачалоДня(Объект.Дата));
	мКоманды = Новый Массив;
	Если Объект.Команды.Количество() > 0 Тогда
		Запрос.Текст = "ВЫБРАТЬ
		               |	МатчСоставыКоманд.Игрок КАК Игрок,
		               |	Матч.Дата КАК Дата
		               |ПОМЕСТИТЬ ВТ
		               |ИЗ
		               |	Документ.Матч.СоставыКоманд КАК МатчСоставыКоманд
		               |		ВНУТРЕННЕЕ СОЕДИНЕНИЕ Документ.Матч КАК Матч
		               |		ПО МатчСоставыКоманд.Ссылка = Матч.Ссылка
		               |ГДЕ
		               |	Матч.Дата < &Дата
		               |	И Матч.Проведен = ИСТИНА
		               |	И МатчСоставыКоманд.Команда = &Команда
		               |
		               |СГРУППИРОВАТЬ ПО
		               |	МатчСоставыКоманд.Игрок,
		               |	Матч.Дата
		               |
		               |ИМЕЮЩИЕ
		               |	МАКСИМУМ(Матч.Дата) = Матч.Дата
		               |;
		               |
		               |////////////////////////////////////////////////////////////////////////////////
		               |ВЫБРАТЬ РАЗЛИЧНЫЕ
		               |	Перемещения.Игрок КАК Игрок,
		               |	Перемещения.Команда КАК Команда,
		               |	ЕСТЬNULL(Роли.Ссылка, Игроки.Амплуа) КАК Амплуа
		               |ИЗ
		               |	РегистрСведений.ПеремещенияИгроков.СрезПоследних(
		               |			&Дата,
		               |			Команда = &Команда
		               |				И Игрок В
		               |					(ВЫБРАТЬ
		               |						ВТ.Игрок
		               |					ИЗ
		               |						ВТ)) КАК Перемещения
		               |		ВНУТРЕННЕЕ СОЕДИНЕНИЕ Справочник.Игроки КАК Игроки
		               |		ПО Перемещения.Игрок = Игроки.Ссылка
		               |		ЛЕВОЕ СОЕДИНЕНИЕ Справочник.Амплуа КАК Роли
		               |		ПО Перемещения.Амплуа = Роли.Ссылка
		               |
		               |УПОРЯДОЧИТЬ ПО
		               |	Амплуа,
		               |	Игрок
		               |АВТОУПОРЯДОЧИВАНИЕ";
		Для Каждого ТекКоманда Из Объект.Команды Цикл
			Запрос.УстановитьПараметр("Команда",	ТекКоманда.Команда);
			Выборка = Запрос.Выполнить().Выбрать();
			Если Выборка.Количество() = 0 Тогда
				мКоманды.Добавить(ТекКоманда.Команда);
			Иначе
				СоставыКомандДобавить(Выборка);
			КонецЕсли;
		КонецЦикла;
	КонецЕсли;
	Если мКоманды.Количество() > 0 Тогда
		Запрос.Текст = "ВЫБРАТЬ РАЗЛИЧНЫЕ
		               |	Перемещения.Игрок КАК Игрок,
		               |	Перемещения.Команда КАК Команда,
		               |	ЕСТЬNULL(Роли.Ссылка, Игроки.Амплуа) КАК Амплуа,
		               |	Перемещения.Команда = &Гости КАК Порядок
		               |ИЗ
		               |	РегистрСведений.ПеремещенияИгроков.СрезПоследних(
		               |			&Дата,
		               |			Игрок.ПометкаУдаления = ЛОЖЬ
		               |				И Команда В (&Команды)) КАК Перемещения
		               |		ВНУТРЕННЕЕ СОЕДИНЕНИЕ Справочник.Игроки КАК Игроки
		               |			ЛЕВОЕ СОЕДИНЕНИЕ Справочник.Амплуа КАК Роли
		               |			ПО Игроки.Амплуа = Роли.Ссылка
		               |		ПО Перемещения.Игрок = Игроки.Ссылка
		               |
		               |УПОРЯДОЧИТЬ ПО
		               |	Порядок,
		               |	Амплуа,
		               |	Игрок
		               |АВТОУПОРЯДОЧИВАНИЕ";
		Запрос.УстановитьПараметр("Команды",	мКоманды);
		Запрос.УстановитьПараметр("Гости",	?(Объект.Команды.Количество()=2, Объект.Команды.Получить(1).Команда, Неопределено));
		СоставыКомандДобавить(Запрос.Выполнить().Выбрать());
	КонецЕсли;
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
	Запрос.УстановитьПараметр("Дата",	Объект.Дата);
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
		АнонсОбновитьНаСервере();
	КонецЕсли;
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
		//Если График.КоличествоСерий < 3 И Объект.СоставыКоманд.Количество() > 0 Тогда
		//	ГрафикОбновить();
		//	РаздельноПриИзменении();
		//КонецЕсли;
		
	ИначеЕсли Элементы.ГруппаАнонс = ТекущаяСтраница Тогда
		Если Сезон.Количество() = 0 Тогда
			АнонсОбновитьНаСервере();
		КонецЕсли;
		
	ИначеЕсли Элементы.ГруппаМатчи = ТекущаяСтраница Тогда
		Если ПредыдущиеМатчиПусто() Тогда
			ПредыдущиеВстречиОбновитьНаСервере();
		КонецЕсли;
	КонецЕсли;
КонецПроцедуры

&НаСервере
Функция Хозяева()
	Возврат ?(Объект.Команды.Количество() = 0, Неопределено, Объект.Команды.Получить(0).Команда);
КонецФункции

&НаСервере
Процедура ОбработкаПроверкиЗаполненияНаСервере(Отказ, ПроверяемыеРеквизиты)
	Если Объект.Команды.Количество() = 2 Тогда
		Отказ = СерверныйФункции.МатчОбработкаПроверкиЗаполнения(Объект);
		Если Отказ Тогда
			ОбщегоНазначения.СообщитьОбОшибке("ТЧ 'СоставыКоманд' заполнена неверно", Отказ, Объект.Ссылка, "СоставыКоманд.Команда");
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
	ЭтоДерби="ДЕРБИ";
КонецПроцедуры

&НаКлиенте
Процедура ПриОткрытии(Отказ)
	//Если Объект.Проведен Тогда
	//	//ГрафикОбновить();
	//КонецЕсли;
	КомандыТураЗагрузить();
	РаздельноПриИзменении();
	ВидимостьДоступностьУстановить();
КонецПроцедуры

&НаСервере
Процедура ВидимостьДоступностьУстановить()
	Элементы.ЭтоДерби.Видимость				= СерверныйФункции.ЭтоДерби(Объект.Ссылка);
	Элементы.ГруппаАнонс.Доступность		= (НЕ Объект.Ссылка.Пустая());
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
	Если Объект.СоставыКоманд.Количество() > 0 Тогда
		СписокШиндлера	= Новый Массив;
		мКоманды = Новый Массив;
		Для Каждого тСтрока Из Объект.Команды Цикл
			мКоманды.Добавить(тСтрока.Команда);
			Если тСтрока.НомерСтроки = 1 Тогда
				Объект.Стадион	= СтадионНайти(тСтрока.Команда);
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
				Объект.Стадион	= СтадионНайти(тСтрока.Команда);
				Прервать;
			КонецЕсли;
		КонецЦикла;
	КонецЕсли;
	
	Элементы.Стадион.СписокВыбора.Очистить();
	ТЧОчистить();
КонецПроцедуры

&НаКлиенте
Процедура КомандыПриИзменении(Элемент)
	Если Элемент.ТекущиеДанные = Неопределено Тогда
		Если НЕ ПустаяСтрока(Объект.Стадион) Тогда
			Объект.Стадион = Неопределено;
		КонецЕсли;
		
	ИначеЕсли НЕ ЗначениеЗаполнено(Объект.Тур) Тогда
		Объект.Тур		= СерверныйФункции.Тур(Элемент.ТекущиеДанные.Команда, Объект.Дата);
	КонецЕсли;
	
	КомандыПриИзмененииНаСервере();
КонецПроцедуры

&НаСервере
Процедура АнонсОбновитьНаСервере()
	Сезон.Очистить();
	Чемпионат = Объект.Тур.Владелец;
	Если НЕ ЗначениеЗаполнено(Чемпионат) Тогда
		Чемпионат = СерверныйФункции.ЧемпионатПолучитьПоследнее(Объект.Команды.Выгрузить().ВыгрузитьКолонку("Команда"));
	КонецЕсли;
	//Если ЗначениеЗаполнено(Чемпионат) Тогда
		Предыдущие5.Очистить();
		Макет	= ПолучитьОбщийМакет("Матчи");
		НашМакс	= 5;
		Запрос	= Новый Запрос("ВЫБРАТЬ РАЗЛИЧНЫЕ ПЕРВЫЕ 5
		      	               |	ТурнирнаяТаблица.Период КАК Период,
		      	               |	ТурнирнаяТаблица.КоличествоОчков КАК КоличествоОчков,
		      	               |	ТурнирнаяТаблица.Регистратор КАК Регистратор
		      	               |ПОМЕСТИТЬ ВТ
		      	               |ИЗ
		      	               |	РегистрНакопления.ТурнирнаяТаблица КАК ТурнирнаяТаблица
		      	               |		ВНУТРЕННЕЕ СОЕДИНЕНИЕ Справочник.Туры КАК Туры
		      	               |		ПО ТурнирнаяТаблица.Тур = Туры.Ссылка
		      	               |ГДЕ
		      	               |	ТурнирнаяТаблица.Период МЕЖДУ &ДатаН И &ДатаК
		      	               |	И ТурнирнаяТаблица.Команда = &Команда
		      	               |	И ТИПЗНАЧЕНИЯ(ТурнирнаяТаблица.Регистратор) = ТИП(Документ.Матч)
		      	               |	И Туры.Владелец = &Чемпионат
		      	               |
		      	               |УПОРЯДОЧИТЬ ПО
		      	               |	Период УБЫВ
		      	               |;
		      	               |
		      	               |////////////////////////////////////////////////////////////////////////////////
		      	               |ВЫБРАТЬ
		      	               |	ВТ.Период КАК Период,
		      	               |	ВЫБОР
		      	               |		КОГДА ВТ.КоличествоОчков = 0
		      	               |			ТОГДА ""LL""
		      	               |		КОГДА ВТ.КоличествоОчков = 1
		      	               |			ТОГДА ""DD""
		      	               |		ИНАЧЕ ""WW""
		      	               |	КОНЕЦ КАК Результат,
		      	               |	&Команда КАК Команда,
		      	               |	ВТ.Регистратор КАК Регистратор
		      	               |ИЗ
		      	               |	ВТ КАК ВТ
		      	               |
		      	               |УПОРЯДОЧИТЬ ПО
		      	               |	Период");
		Запрос.Текст = СтрЗаменить(Запрос.Текст, "5", Формат(НашМакс, "ЧН=5; ЧГ=0"));
		
		Запрос.УстановитьПараметр("ДатаН",				НачалоДня(ДобавитьМесяц(Объект.Дата, - 12)));
		Запрос.УстановитьПараметр("ДатаК",				НачалоДня(Объект.Дата) - 1);
		Запрос.УстановитьПараметр("Чемпионат",			Чемпионат);
		
		Для Каждого тСтрока Из Объект.Команды Цикл
			Стат = СерверныйФункции.СтатистикаИгр(тСтрока.Команда, Чемпионат, Объект.Дата);
			Для Каждого ТекЭлемент Из Стат Цикл
				нСтрока = Сезон.Добавить();
				ЗаполнитьЗначенияСвойств(нСтрока, ТекЭлемент);
				//нСтрока.Ключ	= СтрЗаменить(нСтрока.Ключ, "_", " ");
				нСтрока.Команда	= тСтрока.Команда;
			КонецЦикла;

			Запрос.УстановитьПараметр("Команда",		тСтрока.Команда);
			Выборка = Запрос.Выполнить().Выгрузить();
			//Предыдущие5.Вывести(Макет.ПолучитьОбласть("Пробел"));
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
				Пока Итератор <= НашМакс Цикл
					Предыдущие5.Присоединить(Макет.ПолучитьОбласть("История|EE"));
					Итератор = Итератор + 1;
				КонецЦикла;
			КонецЕсли;
		КонецЦикла;
		Предыдущие5.ФиксацияСверху	= 2;
		Предыдущие5.ФиксацияСлева	= НашМакс + 1;
	//КонецЕсли;
КонецПроцедуры

&НаСервереБезКонтекста
Функция СтадионНайти(Тим, Тур=Неопределено)
	Если ЗначениеЗаполнено(Тур) И Тур.ОлимпийскаяСистема Тогда
		Ответ = СерверныйФункции.СтадионНайти(Тур.Владелец, Истина);
	Иначе
		Ответ = СерверныйФункции.СтадионНайти(Тим, Истина);
	КонецЕсли;
	Возврат Ответ;
КонецФункции

&НаКлиенте
Процедура СтадионНачалоВыбора(Элемент, ДанныеВыбора, СтандартнаяОбработка)
	Если Элемент.СписокВыбора.Количество() = 0
	И Объект.Команды.Количество() > 0
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
		ИначеЕсли Стадионы.Количество() > 0 Тогда
			Элемент.СписокВыбора.ЗагрузитьЗначения(Стадионы.ВыгрузитьЗначения());
		КонецЕсли;
	КонецЕсли;
КонецПроцедуры

&НаКлиенте
Процедура СоставыКомандИгрокНачалоВыбора(Элемент, ДанныеВыбора, СтандартнаяОбработка)
	Тимз = Новый Массив;
	Для Каждого ТекСтрока Из Объект.Команды Цикл
		Тимз.Добавить(ТекСтрока.Команда);
	КонецЦикла;
	Игроки.ЗагрузитьЗначения(ИгрокиПолучить(Тимз));
КонецПроцедуры

&НаСервереБезКонтекста
Функция ИгрокиПолучить(Тимз)
	Запрос = Новый Запрос("ВЫБРАТЬ
	                      |	Перемещения.Игрок КАК Игрок,
	                      |	Перемещения.Команда КАК Команда
	                      |ИЗ
	                      |	РегистрСведений.ПеремещенияИгроков.СрезПоследних КАК Перемещения
	                      |ГДЕ
	                      |	Перемещения.Команда В(&Команда)
	                      |
	                      |УПОРЯДОЧИТЬ ПО
	                      |	Команда,
	                      |	Игрок
	                      |АВТОУПОРЯДОЧИВАНИЕ");
	Запрос.УстановитьПараметр("Команда",	Тимз);
	Возврат Запрос.Выполнить().Выгрузить().ВыгрузитьКолонку(0);
КонецФункции

&НаСервере
Функция ПредыдущиеМатчиПусто()
	Возврат (ПредыдущиеМатчи.КоличествоСтраниц() = 0);
КонецФункции

&НаСервере
Процедура ПредыдущиеВстречиОбновитьНаСервере()
	ПредыдущиеВстречи.Очистить();
	ПредыдущиеМатчи.Очистить();
	Если Объект.Команды.Количество() <> 2 Тогда Возврат; КонецЕсли;
	
	Запрос = Новый Запрос("ВЫБРАТЬ РАЗЛИЧНЫЕ
	                      |	Матч.Дата КАК Дата,
	                      |	Матч.Счет КАК Счет,
	                      |	МатчКоманды.Ссылка КАК Матч
	                      |ИЗ
	                      |	Документ.Матч КАК Матч
	                      |		ВНУТРЕННЕЕ СОЕДИНЕНИЕ РегистрНакопления.ТурнирнаяТаблица КАК ТурнирнаяТаблица
	                      |			ВНУТРЕННЕЕ СОЕДИНЕНИЕ Документ.Матч.Команды КАК МатчКоманды
	                      |			ПО ТурнирнаяТаблица.Регистратор = МатчКоманды.Ссылка
	                      |		ПО Матч.Ссылка = ТурнирнаяТаблица.Регистратор
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
	Выборка = Запрос.Выполнить().Выбрать();
	Макет = ПолучитьОбщийМакет("Матчи");
	ПредыдущиеВстречи.Вывести(Макет.ПолучитьОбласть("Шапка"));
	Пока Выборка.Следующий() Цикл
		Область = Макет.ПолучитьОбласть("Детали");
		Область.Параметры.Заполнить(Выборка);
		ПредыдущиеВстречи.Вывести(Область);
	КонецЦикла;
	ПредыдущиеВстречи.ФиксацияСверху	= 2;
	
	Запрос.Текст = "ВЫБРАТЬ
	               |	Матч.Дата КАК Дата,
	               |	Матч.Счет КАК Счет,
	               |	Матч.Ссылка КАК Матч
	               |ИЗ
	               |	РегистрНакопления.ТурнирнаяТаблица КАК ТурнирнаяТаблица
	               |		ВНУТРЕННЕЕ СОЕДИНЕНИЕ Документ.Матч КАК Матч
	               |		ПО ТурнирнаяТаблица.Регистратор = Матч.Ссылка
	               |ГДЕ
	               |	ТурнирнаяТаблица.Период МЕЖДУ &ДатаН И &ДатаК
	               |	И ТурнирнаяТаблица.НомерСтроки = 2
	               |	И ТурнирнаяТаблица.Команда В(&Команды)
	               |
	               |УПОРЯДОЧИТЬ ПО
	               |	Дата УБЫВ";
	Запрос.УстановитьПараметр("ДатаН",			НачалоДня(ДобавитьМесяц(Объект.Дата, -12)));
	Выборка = Запрос.Выполнить().Выбрать();
	//Макет = ПолучитьОбщийМакет("Матчи");
	ПредыдущиеМатчи.Вывести(Макет.ПолучитьОбласть("Шапка"));
	Пока Выборка.Следующий() Цикл
		Область = Макет.ПолучитьОбласть("Детали");
		Область.Параметры.Заполнить(Выборка);
		ПредыдущиеМатчи.Вывести(Область);
	КонецЦикла;
	ПредыдущиеМатчи.ФиксацияСверху	= 2;
КонецПроцедуры

&НаКлиенте
Процедура ПредыдущиеВстречиОбновить(Команда)
	ПредыдущиеВстречиОбновитьНаСервере();
КонецПроцедуры

&НаСервере
Функция КомандыТура()
	Возврат ?(Объект.Тур.ОлимпийскаяСистема, СерверныйФункции.КомандыТура(Объект.Тур), СерверныйФункции.КомандыЧемпионата(Объект.Тур.Владелец));
КонецФункции

&НаКлиенте
Процедура КомандыТураЗагрузить()
	КомандыТура.ЗагрузитьЗначения(КомандыТура());
	//Если КомандыТура.Количество() = 0 Тогда
	//Иначе
	//КонецЕсли;
КонецПроцедуры

&НаКлиенте
Процедура ТурПриИзменении(Элемент)
	КомандыТураЗагрузить();
КонецПроцедуры

&НаКлиенте
Процедура ОбработкаОповещения(ИмяСобытия, Параметр, Источник)
	Если СтрСравнить(ИмяСобытия, "Матч") = 0
	И Параметр = Объект.Ссылка
	Тогда
		ОбновлятьЭлементы = Новый Массив;
		ОбновлятьЭлементы.Добавить(Элементы.ЛеваяКолонка);
		ОбновлятьЭлементы.Добавить(Элементы.ПраваяКолонка);
		ОбновлятьЭлементы.Добавить(Элементы.ГруппаКомандыПравая);
		ОбновлятьЭлементы.Добавить(Элементы.ГруппаСоставыКоманд);
		ОбновитьОтображениеДанных(ОбновлятьЭлементы);
		
		ВидимостьДоступностьУстановить();
	КонецЕсли;
КонецПроцедуры

&НаКлиенте
Процедура СоставыКомандПередНачаломДобавления(Элемент, Отказ, Копирование, Родитель, Группа, Параметр)
	Если Объект.Команды.Количество() = 0 Тогда Отказ = Истина; КонецЕсли;
КонецПроцедуры

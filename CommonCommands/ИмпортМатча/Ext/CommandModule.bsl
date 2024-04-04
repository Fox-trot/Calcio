﻿
&НаКлиенте
Процедура ОбработкаКоманды(ПараметрКоманды, ПараметрыВыполненияКоманды)
	УРЛ = УРЛ(ПараметрКоманды);
	ПоказатьВводСтроки(Новый ОписаниеОповещения("Импорт", ЭтотОбъект, ПараметрКоманды), УРЛ, "Импорт матча");
КонецПроцедуры

&НаКлиенте
Процедура Импорт(УРЛ, ПараметрКоманды) Экспорт
	Если НЕ ПустаяСтрока(УРЛ) Тогда
		Если ИмпортНаСервере(УРЛ, ПараметрКоманды) Тогда
			Оповестить("Матч", ПараметрКоманды);
		КонецЕсли;
	КонецЕсли;
КонецПроцедуры

&НаСервере
Функция ИмпортНаСервере(Гиперссылка, Матч)
	Итого	= 0;
	Начала	= 0;
	
	сМатч	= Новый Структура("Матч,Дата,Счет,КоличествоЗрителей,Команда1,Команда2,Комментарий,Команды,СоставыКоманд,Стадион", Матч, Дата(1,1,1), "", 0, "", "", "", Новый Массив, Новый Массив);
	сМатч.Вставить("Страна", СерверныйФункции.СтранаНайти(Матч.Тур));
	Команда1	= "";
	Команда2	= "";
	Док		= Неопределено;
	
	Слова	= СерверныйФункции.ПолучитьЭлементыПоИмени(Гиперссылка);
	Для Каждого Слово Из Слова Цикл
		Если Начала < 2 Тогда
			Если СтрНайти(НРег(Слово), "стадион") > 0 Тогда
				Начала = Начала + 1;
				Если Начала = 2 Тогда
					ШапкаЗаполнить(сМатч, Слово);
				КонецЕсли;
			КонецЕсли;
		ИначеЕсли ПустаяСтрока(сМатч.Счет) Тогда
			Если СтрокаСодержитЧисло(Слово) Тогда
				КомандыЗаполнить(сМатч, Слово);
			КонецЕсли;
		ИначеЕсли ПустаяСтрока(Команда1) ИЛИ ПустаяСтрока(Команда2) Тогда
			Для Каждого ТекЭлемент Из сМатч.Команды Цикл
				Если ПустаяСтрока(Команда1) Тогда
					Команда1 = ТекЭлемент.Команда.ПолноеНаименование();
				ИначеЕсли ПустаяСтрока(Команда2) Тогда
					Команда2 = ТекЭлемент.Команда.ПолноеНаименование();
				КонецЕсли;
			КонецЦикла;
			
		ИначеЕсли СтрСравнить(Команда1, Слово) = 0 Тогда
			//
		ИначеЕсли СтрСравнить(Команда2, Слово) = 0 Тогда
			//
		ИначеЕсли СтрЧислоСтрок(Слово) = 1 Тогда
			Если СтрНайти(Слово, ":") > 0 Тогда
				Если СтрЧислоВхождений(Слово, ".") > 3 Тогда
					сМатч.Комментарий = Слово;
				КонецЕсли;
				Продолжить;
			ИначеЕсли СтрНайти(Слово, ",") > 0 Тогда
				Слово = Разделить(Слово, ",").Получить(0);
			КонецЕсли;
			Игрок = СерверныйФункции.Игрок(Слово);
			сМатч.СоставыКоманд.Добавить(Новый Структура("Игрок,Команда", Игрок, СерверныйФункции.КомандаИгрока(Игрок, сМатч.Дата)));
		Иначе
			Прервать;
		КонецЕсли;
	КонецЦикла;
	//ДокМатч=Документы.Матч.СоздатьДокумент()
	Если НЕ ПустаяСтрока(сМатч.Счет)
	И Год(сМатч.Дата) > 1
	И сМатч.Команды.Количество() = 2
	Тогда
		Док = сМатч.Матч.ПолучитьОбъект();
		ЗаполнитьЗначенияСвойств(Док, сМатч);
		Если Док.Команды.НайтиСтроки(Новый Структура("Команда", сМатч.Команда1)).Количество() = 0
		Или Док.Команды.НайтиСтроки(Новый Структура("Команда", сМатч.Команда2)).Количество() = 0
		Тогда
			Док.Команды.Очистить();
			Для Каждого ТекЭлемент Из сМатч.Команды Цикл
				ЗаполнитьЗначенияСвойств(Док.Команды.Добавить(), ТекЭлемент);
			КонецЦикла;
		КонецЕсли;
		////Виктимз = Ложь;
		////Для Каждого ТекЭлемент Из Док.СоставыКоманд Цикл
		////	Если Док.Команды.НайтиСтроки(Новый Структура("Команда", ТекЭлемент.Команда)).Количество() = 0 Тогда
		//		Виктимз = Истина;
		////		Прервать;
		////	КонецЕсли;
		////КонецЦикла;
		//Если Виктимз Тогда Док.СоставыКоманд.Очистить(); КонецЕсли;
		//Если Док.СоставыКоманд.Количество() = 0 Тогда
			Для Каждого ТекЭлемент Из сМатч.СоставыКоманд Цикл
				//Если ЗначениеЗаполнено(ТекЭлемент.Команда)
				//И (ТекЭлемент.Команда = сМатч.Команда1 Или ТекЭлемент.Команда = сМатч.Команда2)
				//Тогда
					ЗаполнитьЗначенияСвойств(Док.СоставыКоманд.Добавить(), ТекЭлемент);
				//КонецЕсли;
			КонецЦикла;
		//КонецЕсли;
		СоставыКомандСортировать(Док);
		Если Док.ПроверитьЗаполнение() Тогда
			Если ПустаяСтрока(Док.Комментарий) Тогда
				Док.Комментарий = Гиперссылка;
			КонецЕсли;
			Если Док.ПометкаУдаления Тогда
				Док.УстановитьПометкуУдаления(Ложь);
			КонецЕсли;
			Попытка
				Док.Записать(РежимЗаписиДокумента.Проведение);
				Итого = Итого + 1;
			Исключение
			КонецПопытки;
		Иначе
			ОбщегоНазначения.СообщитьОбОшибке(ОписаниеОшибки(),, Док.Ссылка);
		КонецЕсли;
	КонецЕсли;
	Возврат (Итого > 0);
КонецФункции

&НаСервере
Процедура СоставыКомандСортировать(Док)
	Если Док.СоставыКоманд.Количество() = 0 Тогда Возврат; КонецЕсли;
	Запрос = Новый Запрос("ВЫБРАТЬ РАЗЛИЧНЫЕ
	                      |	СоставыКоманд.Игрок КАК Игрок,
	                      |	СоставыКоманд.Команда КАК Команда
	                      |ПОМЕСТИТЬ ВТ
	                      |ИЗ
	                      |	&СоставыКоманд КАК СоставыКоманд
	                      |ГДЕ
	                      |	СоставыКоманд.Команда В(&Команды)
	                      |;
	                      |
	                      |////////////////////////////////////////////////////////////////////////////////
	                      |ВЫБРАТЬ
	                      |	ВТ.Игрок КАК Игрок,
	                      |	ВТ.Команда КАК Команда
	                      |ИЗ
	                      |	ВТ КАК ВТ
	                      |		ВНУТРЕННЕЕ СОЕДИНЕНИЕ Справочник.Игроки КАК Игроки
	                      |		ПО ВТ.Игрок = Игроки.Ссылка
	                      |
	                      |УПОРЯДОЧИТЬ ПО
	                      |	ВТ.Команда = &Хозяева УБЫВ,
	                      |	Игроки.Амплуа,
	                      |	Игрок
	                      |АВТОУПОРЯДОЧИВАНИЕ");
	Запрос.УстановитьПараметр("СоставыКоманд",		Док.СоставыКоманд.Выгрузить());
	Запрос.УстановитьПараметр("Команды",			Док.Команды.ВыгрузитьКолонку("Команда"));
	Запрос.УстановитьПараметр("Хозяева",			Док.Команды.Получить(0).Команда);
	Док.СоставыКоманд.Загрузить(Запрос.Выполнить().Выгрузить());
КонецПроцедуры

&НаСервере
Процедура ШапкаЗаполнить(Матч, Слова)
	Город	= Неопределено;
	Ультима	= "";
	Для Каждого Слово Из Разделить(Слова, ".") Цикл
		Если Год(Матч.Дата) < 2 Тогда
			Матч.Дата = СтрокаКакДата(Слово);
			
		ИначеЕсли СтрНайти(НРег(Слово), "стадион") > 0 Тогда
			Если НЕ ПустаяСтрока(Ультима) Тогда
				Город	= СерверныйФункции.ГородНайти(Ультима);
			КонецЕсли;
			//Если ЗначениеЗаполнено(Город) Тогда
				Для Каждого Строка Из Разделить(Слово) Цикл
					Если ЗначениеЗаполнено(Матч.Стадион) Тогда
						Прервать;
					ИначеЕсли СтрНайти(НРег(Строка), "стадион") = 0 Тогда
						Матч.Стадион = СерверныйФункции.СтадионНайти(СтрЗаменить(Строка, """", ""));
						Если НЕ ЗначениеЗаполнено(Матч.Стадион)
						И ЗначениеЗаполнено(Город)
						И Матч.Матч.Тур.ОлимпийскаяСистема
						Тогда
							Матч.Стадион = СерверныйФункции.СтадионНайти(Город);
						ИначеЕсли ЗначениеЗаполнено(Матч.Стадион)
						И НЕ ЗначениеЗаполнено(Город)
						И Матч.Матч.Тур.ОлимпийскаяСистема
						Тогда
							Город = Матч.Стадион.Город;
						КонецЕсли;
					КонецЕсли;
				КонецЦикла;
			//КонецЕсли;
			
		ИначеЕсли СтрНайти(НРег(Слово), "зрител") > 0 Тогда
			Для Каждого Строка Из Разделить(Слово) Цикл
				Если СтрокаКакЧисло(Строка) > 0 Тогда
					Матч.КоличествоЗрителей = СтрокаКакЧисло(Строка);
					Прервать;
				КонецЕсли;
			КонецЦикла;
		Иначе
			Ультима	= Слово;
		КонецЕсли;
	КонецЦикла;
КонецПроцедуры

&НаСервере
Процедура КомандыЗаполнить(Матч, Слова)
	Голов1			= -1;
	Голов2			= -1;
	
	Для Каждого Слово Из Разделить(Слова, "-") Цикл
		Если Голов2 >= 0 Тогда
			Прервать;
		ИначеЕсли НЕ ЗначениеЗаполнено(Матч.Команда1) Тогда
			Матч.Команда1 = СерверныйФункции.КомандаНайти(Слово);
		ИначеЕсли НЕ ЗначениеЗаполнено(Матч.Команда2) Тогда
			Матч.Команда2 = СерверныйФункции.КомандаНайти(Слово);
		ИначеЕсли СтрНайти(Слово, ":") > 0 Тогда
			Для Каждого Голов Из Разделить(Разделить(Слово).Получить(0), ":") Цикл
				Если Голов1 < 0 Тогда
					Голов1		= СтрокаКакЧисло(Голов);
				ИначеЕсли Голов2 < 0 Тогда
					Голов2		= СтрокаКакЧисло(Голов);
				КонецЕсли;
			КонецЦикла;
		КонецЕсли;
	КонецЦикла;
	Если Голов1 >= 0 И ЗначениеЗаполнено(Матч.Команда1)
	И Голов2 >= 0 И ЗначениеЗаполнено(Матч.Команда2)
	Тогда
		Матч.Команды.Добавить(Новый Структура("Команда,КоличествоГолов", Матч.Команда1, Голов1));
		Матч.Команды.Добавить(Новый Структура("Команда,КоличествоГолов", Матч.Команда2, Голов2));
		Матч.Счет	= Слова;
		
		Если НЕ ЗначениеЗаполнено(Матч.Стадион)
		И ЗначениеЗаполнено(Матч.Команда1)
		Тогда
			Матч.Стадион = СерверныйФункции.СтадионНайти(Матч.Команда1);
		КонецЕсли;
	КонецЕсли;
КонецПроцедуры

&НаСервере
Функция ДатаНачалаСезона(Гиперссылка="")
	Слова	= СтрРазделить(Гиперссылка, "/");
	Год		= ?(Месяц(ТекущаяДатаСеанса())<8, Год(ТекущаяДатаСеанса()), Год(ТекущаяДатаСеанса()) - 1);
	Для Каждого Слово Из Слова Цикл
		Если СтрокаКакЧисло(Слово) > 2000 Тогда
			Год = СтрокаКакЧисло(Слово) - 1;
			Прервать;
		КонецЕсли;
	КонецЦикла;
	Возврат Дата(Год, ?(Год = Год(ТекущаяДатаСеанса()), 1, 8), 1);
КонецФункции

&НаСервере
Функция СтрокаКакДата(Знач Слово)
	Ответ = Дата(1,1,1);
	Если СтрНайти(Слово, " ") = 0 Тогда
		Попытка
			Если СтрДлина(Слово) = 10 Тогда
				Ответ = Дата(Сред(Слово, 7, 4) + Сред(Слово, 4, 2) + Лев(Слово, 2));
			Иначе
				Слова = Разделить(Слово, ".");
				Если Слова.Количество() = 3 Тогда
					Ответ = Дата(Слова.Получить(2) + Прав("0" + Слова.Получить(1), 2) + Прав("0" + Слова.Получить(0), 2));
				КонецЕсли;
			КонецЕсли;
		Исключение КонецПопытки;
	Иначе
		Мезе	= 0;
		Жьорно	= 0;
		Для Каждого Строка Из Разделить(Слово) Цикл
			Если Жьорно = 0 Тогда
				Жьорно	= СтрокаКакЧисло(Строка);
			ИначеЕсли СтрокаКакМесяц(Строка) > 0 Тогда
				Мезе	= СтрокаКакМесяц(Строка);
			КонецЕсли;
		КонецЦикла;
		Если Мезе > 0 И Жьорно > 0 Тогда
			Попытка
				Ответ = Дата(Год(ТекущаяДатаСеанса()), Мезе, Жьорно);
				Если Ответ > ТекущаяДатаСеанса() Тогда
					Ответ = Дата(Год(ТекущаяДатаСеанса()) - 1, Мезе, Жьорно);
				КонецЕсли;
			Исключение КонецПопытки;
		КонецЕсли;
	КонецЕсли;
	Возврат Ответ;
КонецФункции

&НаСервере
Функция УРЛ(Матч)
	Возврат ?(ЭтоУРЛ(Матч.Комментарий), Матч.Комментарий, "");
КонецФункции

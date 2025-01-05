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
	
	сМатч	= Новый Структура("Матч,Дата,Счет,КоличествоЗрителей,Команда1,Команда2,Команды,СоставыКоманд,Стадион", Матч, Дата(1,1,1), "", 0, "", "", Новый Массив, Новый Массив);
	сМатч.Вставить("Страна",	СтранаНайти(Матч.Тур));
	сМатч.Вставить("Игроки1",	Новый Соответствие);
	сМатч.Вставить("Игроки2",	Новый Соответствие);
	Команды		= Новый Массив;
	Команда1	= "";
	Команда2	= "";
	Тренеры		= Ложь;
	События		= "";
	Док		= Неопределено;
	
	Слова	= ПолучитьЭлементыПоИмени(Гиперссылка);
	Для Каждого Слово Из Слова Цикл
		Если НЕ ЗначениеЗаполнено(сМатч.Стадион) Тогда
			Если СтрНайти(НРег(Слово), "стадион") > 0 И СтрЧислоСтрок(Слово) = 1 Тогда
				ШапкаЗаполнить(сМатч, Слово);
			КонецЕсли;
		ИначеЕсли ПустаяСтрока(сМатч.Счет) Тогда
			Если СтрокаСодержитЧисло(Слово) Тогда
				Если КомандыЗаполнить(сМатч, Слово) Тогда
					Для Каждого ТекЭлемент Из сМатч.Команды Цикл
						Если ПустаяСтрока(Команда1) Тогда
							Команда1	= ТекЭлемент.Команда.ПолноеНаименование();
							Команды.Добавить(ТекЭлемент.Команда);
							сМатч.Игроки1	= ИгрокиПолучить(ТекЭлемент.Команда, сМатч.Дата);
							
						ИначеЕсли ПустаяСтрока(Команда2) Тогда
							Команда2	= ТекЭлемент.Команда.ПолноеНаименование();
							Команды.Добавить(ТекЭлемент.Команда);
							сМатч.Игроки2	= ИгрокиПолучить(ТекЭлемент.Команда, сМатч.Дата);
						КонецЕсли;
					КонецЦикла;
				КонецЕсли;
			КонецЕсли;
			
		ИначеЕсли СтрСравнить(Команда1, Слово) = 0 Тогда
			//
		ИначеЕсли СтрСравнить(Команда2, Слово) = 0 Тогда
			//
		ИначеЕсли СтрЧислоСтрок(Слово) = 1 Тогда
			Если СтрНайти(Слово, ":") > 0 Тогда
				Если СтрСравнить(СтрУдалить(Слово), "Наказания") = 0 Тогда
					//
				ИначеЕсли СтрСравнить(СтрУдалить(Слово), "Тренеры") = 0 Тогда
					Тренеры	= Истина;
				ИначеЕсли СтрЧислоВхождений(Слово, Команда1) + СтрЧислоВхождений(Слово, Команда2) > 1
				//И СтрЧислоВхождений(Слово, ".") >= СтрЧислоВхождений(Слово, Команда1) + СтрЧислоВхождений(Слово, Команда2)
				Тогда // это Комментарий
					сМатч.Вставить("Комментарий", ?(ПустаяСтрока(КомментарийКакУРЛ(Слово)), Слово + Символы.ПС + Гиперссылка, Слово));
				ИначеЕсли ПустаяСтрока(События) Тогда // это голы
					События	= Слово;
				КонецЕсли;
				Продолжить;
			ИначеЕсли Тренеры Тогда
				Продолжить;
			ИначеЕсли СтрНайти(Слово, ",") > 0 Тогда
				Слово = Разделить(Слово, ",").Получить(0);
			КонецЕсли;
			Если СоставыКомандДобавить(Слово, 0, сМатч) Тогда
				Продолжить;
			ИначеЕсли СоставыКомандДобавить(Слово, 1, сМатч) Тогда
				Продолжить;
			Иначе
				Игрок = ИгрокНайти(Слово, Команды);
				Если Команды.Найти(Игрок.Команда) = Неопределено Тогда
					//
				Иначе
					сМатч.СоставыКоманд.Добавить(Игрок);
				КонецЕсли;
			КонецЕсли;
		КонецЕсли;
	КонецЦикла;
	Если НЕ ПустаяСтрока(сМатч.Счет)
	И Год(сМатч.Дата) > 1
	И сМатч.Команды.Количество() = 2
	Тогда
		Док = сМатч.Матч.ПолучитьОбъект();
		Если НачалоДня(Док.Дата) = сМатч.Дата Тогда
			ЗаполнитьЗначенияСвойств(Док, сМатч,, "Дата");
		Иначе
			ЗаполнитьЗначенияСвойств(Док, сМатч);
		КонецЕсли;
		Если Док.Команды.НайтиСтроки(Новый Структура("Команда", сМатч.Команда1)).Количество() = 0
		Или Док.Команды.НайтиСтроки(Новый Структура("Команда", сМатч.Команда2)).Количество() = 0
		Тогда
			Док.Команды.Очистить();
			Для Каждого ТекЭлемент Из сМатч.Команды Цикл
				ЗаполнитьЗначенияСвойств(Док.Команды.Добавить(), ТекЭлемент);
			КонецЦикла;
			Док.СоставыКоманд.Очистить();
		КонецЕсли;
		Для Каждого ТекЭлемент Из сМатч.СоставыКоманд Цикл
			ЗаполнитьЗначенияСвойств(Док.СоставыКоманд.Добавить(), ТекЭлемент);
		КонецЦикла;
		СоставыКомандСортировать(Док);
		Если Док.ПроверитьЗаполнение() Тогда
			Если ПустаяСтрока(Док.Комментарий) Тогда
				Док.Комментарий = Гиперссылка;
			ИначеЕсли ПустаяСтрока(КомментарийКакУРЛ(Док.Комментарий)) Тогда
				Док.Комментарий = Док.Комментарий + Символы.ПС + Гиперссылка;
			КонецЕсли;
			Если Док.ПометкаУдаления Тогда
				Док.УстановитьПометкуУдаления(Ложь);
			КонецЕсли;
			Попытка
				Док.Записать(РежимЗаписиДокумента.Проведение);
				Итого = Итого + 1;
			Исключение
				ОбщегоНазначения.СообщитьОбОшибке(ОписаниеОшибки());
			КонецПопытки;
		Иначе
			ОбщегоНазначения.СообщитьОбОшибке(ОписаниеОшибки(),, Док.Ссылка);
		КонецЕсли;
	КонецЕсли;
	Возврат (Итого > 0);
КонецФункции

&НаСервере
Процедура СоставыКомандСортировать(Док)
	Если Док.СоставыКоманд.Количество() = 0 Тогда Возврат;
	ИначеЕсли Док.Команды.Количество() = 0 Тогда Возврат;
	КонецЕсли;
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
	Стадион	= "";
	Для Каждого Слово Из Разделить(Слова, ".") Цикл
		Если Год(Матч.Дата) < 2 Тогда
			Матч.Дата = КакДата(Слово);
			
		ИначеЕсли СтрНайти(НРег(Слово), "стадион") > 0 Тогда
			Если НЕ ПустаяСтрока(Ультима) Тогда
				Город	= ГородНайти(Ультима, Матч.Страна);
			КонецЕсли;
			//Если ЗначениеЗаполнено(Город) Тогда
				Для Каждого Строка Из Разделить(Слово) Цикл
					Если ЗначениеЗаполнено(Матч.Стадион) Тогда
						Прервать;
					ИначеЕсли СтрНайти(НРег(Строка), "стадион") = 0 Тогда
						Стадион			= СтрУдалить(Строка, """");
						Матч.Стадион	= СтадионНайти(Стадион);
						Если НЕ ЗначениеЗаполнено(Матч.Стадион)
						И ЗначениеЗаполнено(Город)
						И Матч.Матч.Тур.ОлимпийскаяСистема
						Тогда
							Матч.Стадион = СтадионНайти(Город);
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
					Если ЗначениеЗаполнено(Матч.Стадион) Тогда
						Матч.КоличествоЗрителей = СтрокаКакЧисло(Строка);
					КонецЕсли;
					Прервать;
				КонецЕсли;
			КонецЦикла;
		Иначе
			Ультима	= Слово;
		КонецЕсли;
	КонецЦикла;
	Если НЕ ЗначениеЗаполнено(Матч.Стадион) Тогда
		Матч.Стадион	= Стадион;
	КонецЕсли;
КонецПроцедуры

&НаСервере
Функция КомандыЗаполнить(Матч, Слова)
	Голов1			= -1;
	Голов2			= -1;
	
	Для Каждого Слово Из Разделить(Слова, "-") Цикл
		Если Голов2 >= 0 Тогда
			Прервать;
		ИначеЕсли НЕ ЗначениеЗаполнено(Матч.Команда1) Тогда
			Матч.Команда1 = КомандаНайти(Слово);
		ИначеЕсли НЕ ЗначениеЗаполнено(Матч.Команда2) Тогда
			Матч.Команда2 = КомандаНайти(Слово);
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
			Матч.Стадион = СтадионНайти(Матч.Команда1);
		КонецЕсли;
	Иначе
		Возврат Ложь;
	КонецЕсли;
	Возврат Истина;
КонецФункции

&НаСервере
Функция КакДата(Слово)
	Ответ = Дата(1,1,1);
	Если СтрНайти(Слово, " ") = 0 Тогда
		Ответ = СтрокаКакДата(Слово);
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
	Возврат ?(ТипЗнч(Матч)=Тип("ДокументСсылка.Матч"), КомментарийКакУРЛ(Матч.Комментарий), "");
КонецФункции

&НаСервере
Функция ПолучитьЭлементыПоИмени(Гиперссылка)
	Возврат СерверныйФункции.ПолучитьЭлементыПоИмени(Гиперссылка);
КонецФункции

&НаСервере
Функция КомментарийКакУРЛ(Комментарий)
	Возврат СерверныйФункции.КомментарийКакУРЛ(Комментарий);
КонецФункции

&НаСервере
Функция ГородНайти(Слово, Страна)
	Возврат СерверныйФункции.ГородНайти(Слово, Страна);
КонецФункции

&НаСервере
Функция КомандаНайти(Слово)
	Возврат СерверныйФункции.КомандаНайти(Слово);
КонецФункции

&НаСервере
Функция ИгрокиПолучить(Команда, Дата)
	Ответ	= Новый Соответствие;
	Запрос	= Новый Запрос("ВЫБРАТЬ
	      	               |	Игроки.Наименование КАК Ключ,
	      	               |	Перемещения.Игрок КАК Значение
	      	               |ИЗ
	      	               |	РегистрСведений.ПеремещенияИгроков.СрезПоследних(&Дата, ) КАК Перемещения
	      	               |		ВНУТРЕННЕЕ СОЕДИНЕНИЕ Справочник.Игроки КАК Игроки
	      	               |		ПО Перемещения.Игрок = Игроки.Ссылка
	      	               |ГДЕ
	      	               |	Перемещения.Команда = &Команда");
	Запрос.УстановитьПараметр("Команда",			Команда);
	Запрос.УстановитьПараметр("Дата",				Дата);
	Выборка	= Запрос.Выполнить().Выбрать();
	Пока Выборка.Следующий() Цикл
		Ответ.Вставить(Выборка.Ключ, Выборка.Значение);
	КонецЦикла;
	Возврат Ответ;
КонецФункции

&НаСервере
Функция ИгрокНайти(Слово, Команды)
	Возврат СерверныйФункции.ИгрокНайти(Слово, Команды);
КонецФункции

&НаСервере
Функция СоставыКомандДобавить(Слово, Индекс, сМатч)
	Игрок = ?(Индекс=0, сМатч.Игроки1.Получить(Слово), сМатч.Игроки2.Получить(Слово));
	Если Игрок = Неопределено Тогда
		Возврат Ложь;
	КонецЕсли;
	сМатч.СоставыКоманд.Добавить(Новый Структура("Игрок,Команда", Игрок, ?(Индекс=0, сМатч.Команда1, сМатч.Команда2)));
	Возврат Истина;
КонецФункции

&НаСервере
Функция СтранаНайти(Тур)
	Возврат СерверныйФункции.СтранаНайти(Тур);
КонецФункции

&НаСервере
Функция СтадионНайти(Параметр)
	Возврат СерверныйФункции.СтадионНайти(Параметр);
КонецФункции

﻿//	https://football.kulichki.net/england/2019/26/index.htm
&НаКлиенте
Процедура ОбработкаКоманды(ПараметрКоманды, ПараметрыВыполненияКоманды)
	УРЛ = УРЛ(ПараметрКоманды);
	//Если ВвестиСтроку(УРЛ, "Импорт игр") И ЗначениеЗаполнено(УРЛ) Тогда
	//	Если ИмпортИгр(ПараметрКоманды, УРЛ) Тогда
	//		Оповестить("СписокМатчиОбновить", ПараметрКоманды, ПолучитьФорму("Документ.Матч.ФормаСписка"));
	//		//Оповестить(, ПараметрКоманды, ПолучитьФорму("Документ.Матч.ФормаОбъекта"));
	//	КонецЕсли;
	//КонецЕсли;
	ПоказатьВводСтроки(Новый ОписаниеОповещения("ИмпортИгр", ЭтотОбъект, ПараметрКоманды), УРЛ, "Импорт игр");
КонецПроцедуры

&НаСервере
Функция УРЛ(Тур)
	Возврат "https://football.kulichki.net/england/" + Формат(Год(Тур.Владелец.ДатаОкончания), "ЧГ=0") + "/" + Строка(Тур.Код) + "/index.htm";
КонецФункции

&НаКлиенте
Процедура ИмпортИгр(УРЛ, ПараметрКоманды) Экспорт
	Если НЕ ПустаяСтрока(УРЛ) Тогда
		Если ИмпортИгрНаСервере(ПараметрКоманды, УРЛ) Тогда
			Оповестить("Матчи", ПараметрКоманды);
		КонецЕсли;
	КонецЕсли;
КонецПроцедуры

&НаСервере
Функция ИмпортИгрНаСервере(Тур, Гиперссылка)
	Итого	= 0;
	Шагов	= 0;

	Чемпионат	= Тур.Владелец;
	ВидСпорта	= СерверныйФункции.ВидСпорта(Чемпионат);
	сИгра	= Новый Структура("Тур,Дата,Счет,Гол1,Гол2,КоличествоЗрителей,Комментарий,Команда1,Команда2,Стадион", Тур, Дата(1,1,1), "", 0, 0, 0, "");
	Слова	= СерверныйФункции.ПолучитьЭлементыПоИмени(Гиперссылка);
	Для Каждого Слово Из Слова Цикл
		Шагов	= Шагов + 1;
		Если Шагов > 42 Тогда
			Прервать;
		ИначеЕсли СтрНайти(НРег(Слово), "текст") > 0 Тогда
			Продолжить;
			
		ИначеЕсли СтрокаСодержитЧисло(Слово) Тогда
			Если СтрСравнить(Прав(Слово, 4), "тур.") = 0 И СтрНайти(Слово, "-") > 1 Тогда
				сИгра.Тур = ТурПолучить(Слово, Чемпионат, Тур);
			ИначеЕсли СтрЧислоВхождений(Слово, ":") = 2 И СтрЗаканчиваетсяНа(Слово, ")") Тогда
				Слова = СтрРазделить(Слово, " ", Ложь);
				сИгра.Счет	= Слова.Получить(0);
				Слова = СтрРазделить(сИгра.Счет, ":", Ложь);
				Если Слова.Количество() = 2 Тогда
					сИгра.Гол1	= СтрокаКакЧисло(Слова.Получить(0));
					сИгра.Гол2	= СтрокаКакЧисло(Слова.Получить(1));
				Иначе
					сИгра.Счет	= "";
				КонецЕсли;
			//ИначеЕсли Год(сИгра.Дата) < 2 Тогда
			ИначеЕсли ПустаяСтрока(сИгра.Счет) Тогда
				сИгра.Дата = Строка2Дата(Слово, Тур.ДатаНачала);
			КонецЕсли;
		ИначеЕсли СтрЧислоСтрок(Слово) = 2 И СтрНайти(Слово, "-") > 2 Тогда
			Слова = СтрРазделить(Слово, "-", Ложь);
			сИгра.Команда1	= СерверныйФункции.КомандаНайти(СокрЛП(Слова.Получить(0)), ВидСпорта);
			сИгра.Команда2	= СерверныйФункции.КомандаНайти(СокрЛП(Слова.Получить(1)), ВидСпорта);
		ИначеЕсли СтрСравнить(Слово, "ОТМ") = 0 Тогда
			Продолжить;
		Иначе
			Сообщить(Слово);
		КонецЕсли;
		
		Если НЕ ПустаяСтрока(сИгра.Счет)
		И Год(сИгра.Дата) > 2000
		И ЗначениеЗаполнено(сИгра.Тур)
		И ЗначениеЗаполнено(сИгра.Команда1) И ЗначениеЗаполнено(сИгра.Команда2)
		Тогда
			Ссылка = СерверныйФункции.МатчНайти(сИгра.Команда1, сИгра.Тур);
			Если ЗначениеЗаполнено(Ссылка) Тогда
				Док = Ссылка.ПолучитьОбъект();
				Если Док.Проведен Тогда
					//
				Иначе
					Если Док.ПометкаУдаления Тогда Док.УстановитьПометкуУдаления(Ложь); КонецЕсли;
					ЗаполнитьЗначенияСвойств(Док, сИгра);
					Док.Команды.Очистить();
					Док.СоставыКоманд.Очистить();
				КонецЕсли;
			Иначе
				Док = Документы.Матч.СоздатьДокумент();
				ЗаполнитьЗначенияСвойств(Док, сИгра);
			КонецЕсли;
			Если Док.Команды.Количество() = 0 Тогда
				ЗаполнитьЗначенияСвойств(Док.Команды.Добавить(), Новый Структура("Команда,КоличествоГолов", сИгра.Команда1, сИгра.Гол1));
				ЗаполнитьЗначенияСвойств(Док.Команды.Добавить(), Новый Структура("Команда,КоличествоГолов", сИгра.Команда2, сИгра.Гол2));
			КонецЕсли;
			Док.Стадион	= СерверныйФункции.Стадион(сИгра.Команда1);
			Попытка
				Док.Записать(РежимЗаписиДокумента.Проведение);
			Исключение
				Сообщить(ОписаниеОшибки());
			КонецПопытки;
			Итого = Итого + 1;
			
			сИгра.Счет		= "";
			сИгра.Дата		= Дата(1,1,1);
			сИгра.Команда1	= Неопределено;
			сИгра.Команда2	= Неопределено;
		КонецЕсли;
		//Прервать;
	КонецЦикла;
	
	Возврат (Итого > 0);
КонецФункции

&НаСервере
Процедура ГолыОпределить(Слово, сИгра)
КонецПроцедуры

&НаСервере
Функция ТурПолучить(Слово, Чемпионат, Тур)
	Слова = СтрРазделить(Слово, "-");
	Если Слова.Количество() > 0 И СтрокаКакЧисло(Слова.Получить(0)) > 0 Тогда
		Возврат ТурНайти(Лев(Слово, СтрДлина(Слово) / 2), Чемпионат);
	КонецЕсли;
	Возврат Тур;
КонецФункции

&НаСервере
Функция ТурНайти(Наименование, Чемпионат)
	Запрос = Новый Запрос;
	Запрос.Текст = "ВЫБРАТЬ ПЕРВЫЕ 1
	               |	Туры.Ссылка КАК Ссылка
	               |ИЗ
	               |	Справочник.Туры КАК Туры
	               |ГДЕ
	               |	Туры.Владелец = &Чемпионат
	               |	И Туры.Наименование ПОДОБНО &Наименование
	               |	И Туры.ПометкаУдаления = ЛОЖЬ
	               |
	               |УПОРЯДОЧИТЬ ПО
	               |	Туры.Код";
	Запрос.УстановитьПараметр("Чемпионат",		Чемпионат);
	Запрос.УстановитьПараметр("Наименование",	Наименование + "%");
	Выборка = Запрос.Выполнить().Выбрать();
	Если Выборка.Следующий() Тогда
		Возврат Выборка.Ссылка;
	КонецЕсли;
	Возврат Справочники.Туры.ПустаяСсылка();
КонецФункции

Функция Строка2Дата(Слово, Знач ДатаНачала)
	Ответ = Дата(1,1,1);
	Если СтрНайти("123456789", Лев(Слово, 1)) > 0 Тогда
		Попытка
			ДД = СтрокаКакЧисло(Лев(Слово, СтрНайти(Слово, " ") - 1));
			Если ДД > 0 И ДД < 32 Тогда
				Пока День(ДатаНачала) <> ДД Цикл
					ДатаНачала = ДатаНачала + Сутки();
				КонецЦикла;
				Ответ = ДатаНачала;
			КонецЕсли;
		Исключение
		КонецПопытки;
	КонецЕсли;
	Возврат Ответ;
КонецФункции

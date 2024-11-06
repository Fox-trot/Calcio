﻿
&НаКлиенте
Процедура ТолькоДниРожденияПриИзменении(Элемент)
	СписокУстановитьЗначениеПараметра("ТолькоДниРождения",	ТолькоДниРождения);
КонецПроцедуры

&НаКлиенте
Процедура ДатыУстановить()
	Период.Вариант	= ВариантСтандартногоПериода.ДоКонцаЭтогоМесяца;
КонецПроцедуры

&НаКлиенте
Процедура КомандаСегодня(Команда)
	ДатыУстановить();
	КомандаОбновить();
КонецПроцедуры

&НаКлиенте
Процедура ОбработкаОповещения(ИмяСобытия, Параметр, Источник)
	Если ТипЗнч(Параметр) = Тип("СправочникСсылка.Игроки")
	И Параметр = Игрок
	Тогда
		Игрок = Неопределено;
		ИзображениеУстановить(Элементы.Список.ТекущиеДанные.ИгрокИлиМатч, Игрок, Изображение);
	КонецЕсли;
КонецПроцедуры

&НаКлиенте
Процедура КомандаПриИзменении(Элемент)
	СписокУстановитьЗначениеПараметра("Команда",			МояКоманда);
	СписокПриАктивизацииСтроки();
КонецПроцедуры

&НаКлиенте
Процедура ПриОткрытии(Отказ)
	ИзображениеДефолт	= ИзображениеПолучить();
	
	Список.Параметры.УстановитьЗначениеПараметра("Дата",				Вчера());
	Список.Параметры.УстановитьЗначениеПараметра("ТолькоДниРождения",	ТолькоДниРождения);
	
	Если НЕ ЗначениеЗаполнено(Период) Тогда
		ДатыУстановить();
	КонецЕсли;
	Если НЕ ЗначениеЗаполнено(МояКоманда) Тогда
		МояКоманда		= МояКоманда();
	КонецЕсли;
	КомандаОбновить();
КонецПроцедуры

&НаСервереБезКонтекста
Функция МояКоманда()
	Возврат СерверныйФункции.МояКомандаПолучить();
КонецФункции

&НаСервере
Функция ИзображениеПолучить(Команда=Неопределено)
	Если Команда = Неопределено Тогда
		Возврат СерверныйФункции.ИзображениеДефолтПолучить();
	КонецЕсли;
	Возврат СерверныйФункции.ИзображениеПолучить(Команда);
КонецФункции

&НаСервере
Функция Вчера()
	Возврат (НачалоДня(ТекущаяДатаСеанса()) - 1);
КонецФункции

&НаКлиенте
Процедура КомандаОбновить(Команда=Неопределено)
	Элементы.Период.Подсказка	= Строка(Период);
	
	СписокУстановитьЗначениеПараметра("Команда",			МояКоманда);
	СписокУстановитьЗначениеПараметра("ДатаН",				Период.ДатаНачала);
	СписокУстановитьЗначениеПараметра("ДатаК",				Период.ДатаОкончания);
	СписокУстановитьЗначениеПараметра("ТолькоДниРождения",	ТолькоДниРождения);
	СписокПриАктивизацииСтроки();
КонецПроцедуры

&НаКлиенте
Процедура СписокУстановитьЗначениеПараметра(ПараметрИмя, Значение)
	ШалостьУдалась = Ложь;
	Для Каждого Параметр Из Список.Параметры.Элементы Цикл
		Если СтрСравнить(Параметр.Параметр, ПараметрИмя) = 0 Тогда
			Если Параметр.Значение <> Значение Тогда
				Список.Параметры.УстановитьЗначениеПараметра(ПараметрИмя, Значение);
			КонецЕсли;
			ШалостьУдалась		= Истина;
			Прервать;
		КонецЕсли;
	КонецЦикла;
	Если НЕ ШалостьУдалась Тогда
		Список.Параметры.УстановитьЗначениеПараметра(ПараметрИмя, Значение);
	КонецЕсли;
КонецПроцедуры

&НаКлиенте
Процедура СписокВыбор(Элемент, ВыбраннаяСтрока, Поле, СтандартнаяОбработка)
	Показать(Элемент.ТекущиеДанные, СтандартнаяОбработка);
КонецПроцедуры

&НаКлиенте
Процедура СписокПриАктивизацииСтроки(Элемент=Неопределено)
	Если Элементы.Список.ТекущиеДанные = Неопределено Тогда
		Изображение	= ИзображениеПолучить(МояКоманда);
	ИначеЕсли Элементы.Список.ТекущиеДанные.ЭтоИгрок Тогда
		ИзображениеУстановить(Элементы.Список.ТекущиеДанные.ИгрокИлиМатч, Игрок, Изображение);
	Иначе
		Изображение	= ИзображениеПолучить(МояКоманда);
		Игрок		= Неопределено;
	КонецЕсли;
КонецПроцедуры

&НаСервере
Процедура ИзображениеУстановить(ИгрокИлиМатч, Игрок, Изображение)
	Если ИгрокИлиМатч = Игрок Тогда
		//
	Иначе
		Изображение	= ИзображениеПолучить(ИгрокИлиМатч);
		Игрок	= ИгрокИлиМатч;
	КонецЕсли;
КонецПроцедуры

&НаКлиенте
Процедура ПериодПриИзменении(Элемент)
	КомандаОбновить();
КонецПроцедуры

&НаСервере
Процедура Зачистить(Виктим, ЭтоСобытие=Ложь)
	ЗаполнитьЗначенияСвойств(Виктим, Новый Структура("ЭтоСобытие,Дата,Команды,Стадион,Комментарий", ЭтоСобытие, Дата(1,1,1), Новый Массив));
КонецПроцедуры

&НаСервере
Функция ПервоеДороже(Слова, Первое=Ложь)
	Ответ	= "";
	мСлова = СтрРазделить(Слова, ":", Ложь);
	Если Первое Тогда
		Если мСлова.Количество() > 0
		И НЕ ПустаяСтрока(Лев(мСлова.Получить(0), 1))
		Тогда
			Ответ = СокрЛП(мСлова.Получить(0));
		КонецЕсли;
	Иначе
		Если ПустаяСтрока(Лев(Слова, 1)) Тогда
			Ответ	= Слова;
		Иначе
			Если мСлова.Количество() >= 2 Тогда
				Ответ	= мСлова.Получить(1);
				Для Индекс = 2 По мСлова.ВГраница() Цикл
					Ответ	= Ответ + ":" + мСлова.Получить(Индекс);
				КонецЦикла;
			КонецЕсли;
		КонецЕсли;
	КонецЕсли;
	Возврат Ответ;
КонецФункции

&НаСервере
Функция СтрокаКакКоманды(Знач Слова, Тимз)
	Ответ	= Новый Массив;
	Слова	= СокрЛП(СтрЗаменить(СтрЗаменить(Слова, "(A)",""), "(H)",""));
	Солянка	= "";
	мСлова	= Новый Массив;
	Для Каждого Слово Из СтрРазделить(Слова, " ", Ложь) Цикл
		Если СтрСравнить(Слово, "vs") = 0 Тогда
			мСлова.Добавить(Солянка);
			Солянка	= "";
		ИначеЕсли ПустаяСтрока(Солянка) Тогда
			Солянка	= Слово;
		Иначе
			Солянка	= Солянка + " " + Слово;
		КонецЕсли;
	КонецЦикла;
	мСлова.Добавить(Солянка);
	
	Для Каждого Слово Из мСлова Цикл
		Команда	= Тимз.Получить(Слово);
		Если Команда = Неопределено Тогда
			Команда	= КомандаНайти(Слово);
			Если ЗначениеЗаполнено(Команда) Тогда
				Тимз.Вставить(Слово, Команда);
			КонецЕсли;
		КонецЕсли;
		Если ЗначениеЗаполнено(Команда) Тогда
			Ответ.Добавить(Команда);
		КонецЕсли;
	КонецЦикла;
	Возврат Ответ;
КонецФункции

&НаСервере
Функция Внятно(Слово, Целиком=Ложь)
	Если Целиком Тогда
		Возврат СтрЗаменить(Слово, "\", "");
	КонецЕсли;
	
	Ответ	= "";
	Для Индекс = 1 По СтрДлина(Слово) Цикл
		Если СтрСравнить("\", Сред(Слово, Индекс, 1)) = 0 Тогда
			Прервать;
		Иначе
			Ответ = Ответ + Сред(Слово, Индекс, 1);
		КонецЕсли;
	КонецЦикла;
	Возврат Ответ;
КонецФункции

&НаСервере
Функция КомандаИмпортНаСервере(Текст)
	Ответ	= 0;
	Тимз	= Новый Соответствие;
	Стадионы= Новый Соответствие;
	Элемент = Новый Структура("ЭтоСобытие,Дата,Команды,Стадион,Комментарий");
	Зачистить(Элемент);
	Для НомерСтроки = 1 По СтрЧислоСтрок(Текст) Цикл
		Слово	= СтрПолучитьСтроку(Текст, НомерСтроки);
		Первое	= ПервоеДороже(Слово, Истина);
		Если СтрСравнить(Первое, "BEGIN") = 0 Тогда
			Зачистить(Элемент, СтрСравнить(ПервоеДороже(Слово), "VEVENT") = 0);
			
		ИначеЕсли НЕ Элемент.ЭтоСобытие Тогда
			//
		ИначеЕсли ПустаяСтрока(Первое) Тогда
			Если НЕ ПустаяСтрока(Элемент.Комментарий) Тогда
				Элемент.Комментарий = Элемент.Комментарий + ПервоеДороже(Слово);
			КонецЕсли;
		ИначеЕсли СтрСравнить(Первое, "DESCRIPTION") = 0 Тогда
			Элемент.Комментарий = ПервоеДороже(Слово);
		ИначеЕсли СтрСравнить(Первое, "DTSTART") = 0 Тогда
			Элемент.Дата	= СтрокаКакДата(ПервоеДороже(Слово));
			Если Элемент.Дата <= ТекущаяУниверсальнаяДата() Тогда
				Зачистить(Элемент);
			КонецЕсли;
		ИначеЕсли СтрСравнить(Первое, "SUMMARY") = 0 Тогда
			Элемент.Команды = СтрокаКакКоманды(ПервоеДороже(Слово), Тимз);
		ИначеЕсли СтрСравнить(Первое, "LOCATION") = 0 Тогда
			Слово	= Внятно(ПервоеДороже(Слово), Истина);
			Элемент.Стадион = СтадионПодобрать(Слово, Стадионы);
		ИначеЕсли СтрСравнить(Первое, "END") = 0 Тогда
			Если Элемент.Дата > ТекущаяДатаСеанса()
			И Элемент.Команды.Количество() = 2
			Тогда
				Матч	= МатчНайти(Элемент);
				Если ЗначениеЗаполнено(Матч) Тогда
					МатчОбъект	= Матч.ПолучитьОбъект();
					ОбщегоНазначения.УстановитьЗначение(МатчОбъект.Дата, Элемент.Дата);
					Если НЕ ЗначениеЗаполнено(МатчОбъект.Стадион)
					И ЗначениеЗаполнено(Элемент.Стадион)
					Тогда
						МатчОбъект.Стадион	= Элемент.Стадион;
					КонецЕсли;
					ОбщегоНазначения.УстановитьЗначение(МатчОбъект.Комментарий, Причесать(Элемент.Комментарий));
				Иначе
					МатчОбъект	= СерверныйФункции.МатчСоздать();
					МатчОбъект.Заполнить(Элемент);
				КонецЕсли;
				Если МатчОбъект.Модифицированность() Тогда
					МатчОбъект.Записать(РежимЗаписиДокумента.Запись);
					МатчОбъект.УстановитьПометкуУдаления(Ложь);
					Ответ	= Ответ + 1;
				КонецЕсли;
			КонецЕсли;
			Зачистить(Элемент);
		КонецЕсли;
	КонецЦикла;
	Возврат Ответ;
КонецФункции

&НаКлиенте
Процедура КомандаИмпорт(Команда)
	Гиперссылка	= УРЛ;
	ПоказатьВводСтроки(Новый ОписаниеОповещения("Импорт", ЭтотОбъект), Гиперссылка, "Импорт календаря (iCal)");
КонецПроцедуры

&НаКлиенте
Процедура Импорт(Гиперссылка, ДополнительныеПараметры=Неопределено) Экспорт
	Текст	= "";
	Если ЭтоУРЛ(Гиперссылка) Тогда
		УРЛ		= Гиперссылка;
		Текст	= ОбщегоНазначения.СкачатьПоСсылке(Гиперссылка);
	Иначе
		Текст	= ОбщегоНазначения.ТекстовыйДокументПрочитать(Гиперссылка);
	КонецЕсли;
	Ответ	= КомандаИмпортНаСервере(Текст);
	Если Ответ > 0 Тогда
		Оповестить("Матчи");
		Сообщить(СтрШаблон("Добавлено/изменено событий  %1", Ответ));
	КонецЕсли;
КонецПроцедуры

&НаСервере
Функция КомандаНайти(Слово)
	Возврат СерверныйФункции.КомандаНайти(Слово);
КонецФункции

&НаСервере
Функция СтадионПодобрать(Слово, Стадионы)
	Стадион	= Стадионы.Получить(Слово);
	Если Стадион = Неопределено Тогда
		Стадион	= СерверныйФункции.СтадионНайти(Слово);
		Если ЗначениеЗаполнено(Стадион) Тогда
			Стадионы.Вставить(Слово, Стадион);
		КонецЕсли;
	КонецЕсли;
	Возврат Стадион;
КонецФункции

&НаСервере
Функция МатчНайти(Элемент)
	Возврат СерверныйФункции.МатчНайти(Элемент.Команды, Элемент.Дата);
КонецФункции

&НаКлиенте
Процедура ИзображениеНажатие(Элемент, СтандартнаяОбработка)
	Показать(Элементы.Список.ТекущиеДанные, СтандартнаяОбработка);
КонецПроцедуры

&НаКлиенте
Процедура Показать(ТекущиеДанные, СтандартнаяОбработка=Ложь)
	СтандартнаяОбработка = Ложь;
	Если ТекущиеДанные = Неопределено Тогда
		//
	Иначе
		ПоказатьЗначение(, ТекущиеДанные.ИгрокИлиМатч);
	КонецЕсли;
КонецПроцедуры

&НаСервере
Функция Причесать(Текст)
	Если ПустаяСтрока(Текст) Тогда Возврат ""; КонецЕсли;
	Ответ	= "";
	Слова	= СтрЗаменить(СтрЗаменить(Текст, "\n\n", Символы.ПС), "\n", " ");
	Для НомерСтроки = 1 По СтрЧислоСтрок(Слова) Цикл
		Слово	= СтрПолучитьСтроку(Слова, НомерСтроки);
		Если СтрНайти(Слово, "http") = 0 Тогда
			Ответ	= ?(ПустаяСтрока(Ответ), Слово, Ответ + Символы.ПС + Слово);
		КонецЕсли;
	КонецЦикла;
	Возврат Ответ;
КонецФункции

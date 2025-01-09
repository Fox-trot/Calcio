﻿
&НаКлиенте
Процедура ОбработкаОповещения(ИмяСобытия, Параметр, Источник)
	Если ТипЗнч(Параметр) = Тип("СправочникСсылка.Команды") Тогда
		КомандыЛигиЗагрузить();
	КонецЕсли;
КонецПроцедуры

&НаКлиенте
Процедура КомандыПередНачаломДобавления(Элемент, Отказ, Копирование, Родитель, Группа, Параметр)
	Если Объект.Команды.Количество() = ЛигаКоличествоКоманд(Объект.Владелец) Тогда
		Отказ = Истина;
	КонецЕсли;
КонецПроцедуры

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	Изображение	= СерверныйФункции.ИзображениеПолучить(Объект.Владелец);
	ВидимостьДоступностьУстановить();
КонецПроцедуры

&НаСервереБезКонтекста
Функция ЛигаКоличествоКоманд(Лига)
	Возврат СерверныйФункции.ЛигаКоличествоКоманд(Лига);
КонецФункции

&НаСервереБезКонтекста
Функция ЕстьИстория(Ссылка, Команда=Неопределено)
	Возврат СерверныйФункции.ЕстьИстория(Ссылка, Команда);
КонецФункции

&НаКлиенте
Процедура КомандыПередУдалением(Элемент, Отказ)
	Если ЕстьИстория(Объект.Ссылка, Элемент.ТекущиеДанные.Команда) Тогда
		Отказ = Истина;
	КонецЕсли;
КонецПроцедуры

&НаСервере
Процедура ВидимостьДоступностьУстановить()
	Если ЕстьИстория(Объект.Ссылка) Тогда
		Элементы.Владелец.ТолькоПросмотр			= Истина;
		Если ИгрыВсе() Тогда
			Элементы.Команды.ТолькоПросмотр				= Истина;
			Элементы.КомандаИмпортКоманд.Доступность	= Ложь;
		КонецЕсли;
		Элементы.КомандыУпорядочить.Доступность		= Истина;
	Иначе
		Элементы.КомандыУпорядочить.Доступность		= Ложь;
	КонецЕсли;
КонецПроцедуры

&НаСервере
Функция ИгрыВсе()
	Возврат РеквизитФормыВЗначение("Объект").ИгрыВсе();
КонецФункции

&НаСервереБезКонтекста
Функция КомандыЛиги(Лига)
	Возврат СерверныйФункции.КомандыСтраны(Лига);
КонецФункции

&НаСервере
Процедура КомандыЛигиЗагрузить()
	КомандыЛиги.ЗагрузитьЗначения(КомандыЛиги(Объект.Владелец));
КонецПроцедуры

&НаКлиенте
Процедура ВладелецПриИзменении(Элемент=Неопределено)
	КомандыЛигиЗагрузить();
КонецПроцедуры

&НаКлиенте
Процедура ПриОткрытии(Отказ)
	ВладелецПриИзменении();
	ВидимостьДоступностьУстановить();
КонецПроцедуры

&НаКлиенте
Процедура КомандаИмпортКоманд(Команда=Неопределено)
	УРЛ = УРЛ();
	Если Команда = Неопределено Или Объект.Команды.Количество() = 0 Тогда
		ПоказатьВводСтроки(Новый ОписаниеОповещения("Импорт", ЭтотОбъект), УРЛ, "Импорт команд");
	Иначе
		ПоказатьВопрос(Новый ОписаниеОповещения("ВопросИмпортДо", ЭтотОбъект), "Заменить текущий список?", РежимДиалогаВопрос.ОКОтмена, 60, КодВозвратаДиалога.Отмена, "Команды");
	КонецЕсли;
КонецПроцедуры

&НаСервере
Функция УРЛ()
	Ответ = СерверныйФункции.КомментарийКакУРЛ(Объект.Комментарий);
	Если ПустаяСтрока(Ответ) Тогда
		Ответ = СерверныйФункции.КомментарийКакУРЛ(Объект.Владелец.Комментарий);
	КонецЕсли;
	Возврат ?(ПустаяСтрока(Ответ), ?(СтрНайти(НРег(Объект.Наименование), "англ") = 0, "", СтрШаблон("https://football.kulichki.net/england/%1/", ФорматЧГ(Объект.ДатаОкончания))), Ответ);
КонецФункции

&НаКлиенте
Процедура ВопросИмпортДо(КодОтвета, ПараметрКоманды) Экспорт
	Если КодОтвета = КодВозвратаДиалога.ОК Тогда
		КомандаИмпортКоманд();
	КонецЕсли;
КонецПроцедуры

&НаКлиенте
Процедура Импорт(Гиперссылка, ПараметрКоманды) Экспорт
	Если ИмпортНаСервере(Гиперссылка) Тогда
		Если ПустаяСтрока(Объект.Комментарий) Тогда
			Объект.Комментарий = Гиперссылка;
		КонецЕсли;
	КонецЕсли;
КонецПроцедуры

&НаСервере
Функция ИмпортНаСервере(Гиперссылка)
	Если ПустаяСтрока(Гиперссылка) Тогда Возврат Ложь; КонецЕсли;
	
	Итого	= 0;
	Старт	= Ложь;
	
	Объект.Команды.Очистить();
	КоличествоКоманд	= ЛигаКоличествоКоманд(Объект.Владелец);
	сИгра	= Новый Структура("Команда");
	Если ЭтоУРЛ(Гиперссылка) Тогда
		мСлова	= СерверныйФункции.ПолучитьЭлементыПоИмени(Гиперссылка);
	Иначе
		мСлова	= Новый Массив;
		Для Каждого Тимз Из Разделить(Гиперссылка, "¶") Цикл
			Для Каждого Слово Из Разделить(Тимз, "-", Истина) Цикл
				Если СтрСравнить(Слово, "матч") <> 0 Тогда
					мСлова.Добавить(Слово);
				КонецЕсли;
			КонецЦикла;
		КонецЦикла;
		Старт	= Истина;
	КонецЕсли;
	Для Каждого Слово Из мСлова Цикл
		Если Объект.Команды.Количество() >= КоличествоКоманд Тогда		// финито
			Прервать;
		ИначеЕсли СтрСравнить(Прав(Слово, 1) , ".") = 0 Тогда
		ИначеЕсли СтрЧислоСтрок(Слово) > 1 Тогда
		//ИначеЕсли СтрНайти("клуб,мячи,очки", НРег(Слово)) > 0 И Объект.Команды.Количество() = 0 Тогда
		//ИначеЕсли СтрокаКакМесяц(Слово) > 0 Тогда
		ИначеЕсли СтрокаКакЧисло(Слово) > 0 Тогда
			Если НЕ Старт Тогда
				Старт = Истина;
			КонецЕсли;
		ИначеЕсли Старт И СтрДлина(Слово) < 3 Тогда
		ИначеЕсли Старт И ЭтоСчетНаверное(Слово) Тогда
		ИначеЕсли Старт Тогда //НЕ ЗначениеЗаполнено(сИгра.Команда) Тогда
			сИгра.Команда	= КомандаНайти(Слово);
			Если НЕ ЗначениеЗаполнено(сИгра.Команда) Тогда
				сИгра.Команда	= СерверныйФункции.КомандыСоздать(Слово);
			КонецЕсли;
			Если ЗначениеЗаполнено(сИгра.Команда) Тогда
				ЗаполнитьЗначенияСвойств(Объект.Команды.Добавить(), сИгра);
				сИгра.Команда	= Неопределено;
				Итого			= Итого + 1;
			//Иначе
			//	Сообщить(Слово);
			КонецЕсли;
		КонецЕсли;
	КонецЦикла;
	Возврат (Итого > 0);
КонецФункции

&НаСервере
Функция КомандаНайти(Слово)
	Страна	= Страна();
	Возврат СерверныйФункции.КомандаНайти(Слово, ?(ЗначениеЗаполнено(Страна), Страна, Неопределено));
КонецФункции

&НаСервере
Функция ЭтоСчетНаверное(Слово)
	Ответ = Ложь;
	Попытка
		Ответ	= (ТипЗнч(Вычислить(Слово)) = Тип("Число"));
	Исключение КонецПопытки;
	Возврат Ответ;
КонецФункции

&НаСервере
Функция Страна()
	Возврат Объект.Владелец.Страна;
КонецФункции

&НаКлиенте
Процедура ДатаНачалаПриИзменении(Элемент)
	Если Объект.Ссылка.Пустая()
	И ЗначениеЗаполнено(Объект.ДатаНачала)
	Тогда
		Объект.ДатаОкончания = ДатаОкончания(Объект.ДатаНачала);
	КонецЕсли;
КонецПроцедуры

&НаКлиенте
Процедура НаименованиеПриИзменении(Элемент)
	Если Объект.Ссылка.Пустая() Тогда
		Слова = Разделить(Объект.Наименование);
		Для Каждого Слово Из Слова Цикл
			Если СтрокаСодержитЧисло(Слово) Тогда
				Объект.ДатаНачала		= СтрокаКакДата(Лев(Слово, 4) + "0801");
				Объект.ДатаОкончания	= ДатаОкончания(Объект.ДатаНачала);
			КонецЕсли;
		КонецЦикла;
	КонецЕсли;
КонецПроцедуры

&НаКлиенте
Функция ДатаОкончания(Дата)
	Возврат КонецМесяца(ДобавитьМесяц(Дата, 9));
КонецФункции

&НаКлиенте
Процедура ПослеЗаписи(ПараметрыЗаписи)
	КомандыЛиги.ЗагрузитьЗначения(КомандыЛиги(Объект.Владелец));
КонецПроцедуры

&НаКлиенте
Процедура Упорядочить(Команда)
	УпорядочитьНаСервере();
КонецПроцедуры

&НаСервере
Процедура УпорядочитьНаСервере()
	РеквизитФормыВЗначение("Объект").КомандыУпорядочить(Объект.Команды);
КонецПроцедуры

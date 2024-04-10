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
	КонецЕсли;
КонецПроцедуры

&НаСервереБезКонтекста
Функция КомандыЛиги(Лига)
	Возврат СерверныйФункции.КомандыСтраны(Лига);
КонецФункции

&НаКлиенте
Процедура КомандыЛигиЗагрузить()
	КомандыЛиги.ЗагрузитьЗначения(КомандыЛиги(Объект.Владелец));
КонецПроцедуры

&НаКлиенте
Процедура ВладелецПриИзменении(Элемент=Неопределено)
	КомандыЛигиЗагрузить();
	ВидимостьДоступностьУстановить();
КонецПроцедуры

&НаКлиенте
Процедура ПриОткрытии(Отказ)
	ВладелецПриИзменении();
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
	Возврат ?(СтрНайти(НРег(Объект.Наименование), "англ") = 0, "", СтрШаблон("https://football.kulichki.net/england/%1/", Формат(Год(Объект.ДатаОкончания), "ЧГ=0")));
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
		//
	КонецЕсли;
КонецПроцедуры

&НаСервере
Функция ИмпортНаСервере(Гиперссылка)
	Если ПустаяСтрока(Гиперссылка) Тогда Возврат Ложь; КонецЕсли;
	
	Итого	= 0;
	
	Объект.Команды.Очистить();
	КоличествоКоманд	= ЛигаКоличествоКоманд(Объект.Владелец);
	сИгра	= Новый Структура("Команда");
	мСлова	= СерверныйФункции.ПолучитьЭлементыПоИмени(Гиперссылка);
	Для Каждого Слово Из мСлова Цикл
		Если СтрДлина(Слово) < 3
		Или СтрСравнить(Прав(Слово, 1) , ".") = 0
		Или СтрЧислоСтрок(Слово) > 1
		Тогда
			
		ИначеЕсли Объект.Команды.Количество() >= КоличествоКоманд Тогда		// финито
			Прервать;
		ИначеЕсли СтрНайти("клуб,мячи,очки", НРег(Слово)) > 0 И Объект.Команды.Количество() = 0 Тогда
		ИначеЕсли ЭтоСчетНаверное(Слово) Тогда
			
		ИначеЕсли НЕ ЗначениеЗаполнено(сИгра.Команда) Тогда
			сИгра.Команда	= КомандаНайти(Слово);
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
	Возврат СерверныйФункции.КомандаНайти(Слово);
КонецФункции

&НаСервере
Функция ЭтоСчетНаверное(Слово)
	Ответ = Ложь;
	Попытка
		Ответ	= (ТипЗнч(Вычислить(Слово)) = Тип("Число"));
	Исключение КонецПопытки;
	Возврат Ответ;
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

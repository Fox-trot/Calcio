﻿
&НаКлиенте
Процедура ТолькоДниРожденияПриИзменении(Элемент)
	СписокУстановитьЗначениеПараметра("ТолькоДниРождения",	ТолькоДниРождения);
КонецПроцедуры

&НаКлиенте
Процедура ДатыУстановить()
	Период.Вариант		= ВариантСтандартногоПериода.ДоКонцаЭтогоМесяца;
	Период.ДатаНачала	= Сегодня();
	Если День(Период.ДатаОкончания) - День(Период.ДатаНачала) <= 3 Тогда
		Период.ДатаОкончания	= КонецМесяца(Период.ДатаОкончания + Сутки());
	КонецЕсли;
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
		ИзображениеУстановить(Элементы.Список.ТекущиеДанные.ИгрокИлиМатч);
	КонецЕсли;
КонецПроцедуры

&НаКлиенте
Процедура КомандаПриИзменении(Элемент)
	СписокУстановитьЗначениеПараметра("Команда",			МояКоманда);
	СписокПриАктивизацииСтроки();
КонецПроцедуры

&НаКлиенте
Процедура ПриОткрытии(Отказ)
	Список.Параметры.УстановитьЗначениеПараметра("ТолькоДниРождения",	ТолькоДниРождения);
	ДатыУстановить();
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

&НаСервереБезКонтекста
Функция Сегодня()
	Возврат НачалоДня(ТекущаяДатаСеанса());
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
		ИзображениеУстановить(Элементы.Список.ТекущиеДанные.ИгрокИлиМатч);
	Иначе
		Изображение	= ИзображениеПолучить(МояКоманда);
		Игрок		= Неопределено;
	КонецЕсли;
КонецПроцедуры

&НаСервере
Процедура ИзображениеУстановить(ИгрокИлиМатч)
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
Функция КомандаИмпортНаСервере(Текст)
	Возврат СерверныйФункции.ИмпортИгрПоКалендарю(Текст);
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
		Текст	= СкачатьПоСсылке(Гиперссылка);
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
Функция СкачатьПоСсылке(Гиперссылка)
	Возврат СерверныйФункции.СкачатьПоСсылке(Гиперссылка);
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
		НаКлиенте.Показать(ТекущиеДанные.ИгрокИлиМатч);
	КонецЕсли;
КонецПроцедуры

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	ИзображениеДефолт	= ИзображениеПолучить();
КонецПроцедуры

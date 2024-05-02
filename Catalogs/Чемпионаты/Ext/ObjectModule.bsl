﻿
Процедура ОбработкаПроверкиЗаполнения(Отказ, ПроверяемыеРеквизиты)
	Если ДатаНачала >= ДатаОкончания Тогда
		ОбщегоНазначения.СообщитьОбОшибке("Неверно указаны дата", Отказ, Ссылка, "ДатаОкончания");
	КонецЕсли;
	Если Команды.Количество() <> Цел(Команды.Количество() / 2) * 2 Тогда
		ОбщегоНазначения.СообщитьОбОшибке("Неверное количество команд", Отказ, Ссылка, "Команды");
	КонецЕсли;
КонецПроцедуры

Процедура ПриКопировании(ОбъектКопирования)
	ТекЛига			= ОбъектКопирования.Владелец;
	ЧемпионатЛигиПоследний = СерверныйФункции.ЧемпионатЛигиПоследний(ТекЛига);
	Наименование	= "";
	нГод			= 0;
	Слова			= Разделить(Строка(ЧемпионатЛигиПоследний));
	Для Каждого Слово Из Слова Цикл
		Если СтрНайти("0123456789", Лев(Слово, 1)) > 0 Тогда
			нГод = СтрокаКакЧисло(Лев(Слово, 4)) + 1;
			Прервать;
		Иначе
			Наименование = Наименование + Слово + " ";
		КонецЕсли;
	КонецЦикла;
	
	Наименование = Наименование + ?(нГод = 0,
		ФорматЧГ(ТекущаяДата()) + "/" + Формат((Год(ТекущаяДата()) + 1) - Цел((Год(ТекущаяДата()) + 1) / 100) * 100, "ЧН=00"),
		ФорматЧГ(нГод) + "/" + ФорматЧГ(нГод + 1));
	
	ДатаНачала		= ДобавитьМесяц(?(нГод = 0, ДатаНачала, ЧемпионатЛигиПоследний.ДатаНачала), 12);
	ДатаОкончания	= ДобавитьМесяц(?(нГод = 0, ДатаОкончания, ЧемпионатЛигиПоследний.ДатаОкончания), 12);
	
	Команды.Очистить();
	Шаг		= 0;
	Выборка	= СерверныйФункции.ТурнирнаяТаблица(ЧемпионатЛигиПоследний);
	Пока Выборка.Следующий() И Шаг < ТекЛига.КоличествоКоманд - ТекЛига.КоличествоРотация Цикл
		ЗаполнитьЗначенияСвойств(Команды.Добавить(), Выборка);
		
		Шаг = Шаг + 1;
	КонецЦикла;
	Команды.Сортировать("Команда");
КонецПроцедуры

Процедура ПередЗаписью(Отказ)
	Команды.Свернуть("Команда");
КонецПроцедуры

Процедура ОбработкаЗаполнения(ДанныеЗаполнения, ТекстЗаполнения, СтандартнаяОбработка)
	Если ТипЗнч(ДанныеЗаполнения) = Тип("СправочникСсылка.Лига") Тогда
		Владелец	= ДанныеЗаполнения;
	ИначеЕсли ТипЗнч(ДанныеЗаполнения) = Тип("Структура") Тогда
		Если ДанныеЗаполнения.Свойство("Владелец") Тогда
			ОбработкаЗаполнения(ДанныеЗаполнения.Владелец, ТекстЗаполнения, Ложь);
		КонецЕсли;
	КонецЕсли;
КонецПроцедуры

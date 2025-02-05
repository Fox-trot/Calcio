﻿
Процедура ОбработкаПроверкиЗаполнения(Отказ, ПроверяемыеРеквизиты)
	Если ДатаНачала >= ДатаОкончания Тогда
		ОбщегоНазначения.СообщитьОбОшибке("Неверно указаны даты", Отказ, Ссылка, "ДатаОкончания");
	КонецЕсли;
	Если Команды.Количество() <> Цел(Команды.Количество() / 2) * 2 Тогда
		//	https://it.wikipedia.org/wiki/S%C3%BCper_Lig_2020-2021
		ОбщегоНазначения.СообщитьОбОшибке("Возможно неверное количество команд",, Ссылка, "Команды");
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
		ФорматЧГ(ТекущаяДатаСеанса()) + "/" + Формат((Год(ТекущаяДатаСеанса()) + 1) - Цел((Год(ТекущаяДатаСеанса()) + 1) / 100) * 100, "ЧН=00"),
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
	КомандыСвернуть();
КонецПроцедуры

Процедура ОбработкаЗаполнения(ДанныеЗаполнения, ТекстЗаполнения, СтандартнаяОбработка)
	Если ТипЗнч(ДанныеЗаполнения) = Тип("СправочникСсылка.Лига") Тогда
		Владелец	= ДанныеЗаполнения;
		Команды.Загрузить(ДанныеЗаполнения.Команды.Выгрузить());
		
	ИначеЕсли ТипЗнч(ДанныеЗаполнения) = Тип("Структура") Тогда
		Если ДанныеЗаполнения.Свойство("Владелец") Тогда
			ОбработкаЗаполнения(ДанныеЗаполнения.Владелец, ТекстЗаполнения, Ложь);
		КонецЕсли;
	КонецЕсли;
КонецПроцедуры

Процедура КомандыСвернуть()
	СерверныйФункции.КомандыСвернуть(Команды);
КонецПроцедуры

Процедура КомандыУпорядочить(Тимз) Экспорт
	Выборка	= ТурнирнаяТаблица();
	Если Выборка.Количество() = 0 Тогда
		Тимз.Сортировать("Команда");
	Иначе
		Тимз.Очистить();
		Пока Выборка.Следующий() Цикл
			ЗаполнитьЗначенияСвойств(Тимз.Добавить(), Выборка);
		КонецЦикла;
	КонецЕсли;
КонецПроцедуры

Функция ТурнирнаяТаблица()
	Возврат СерверныйФункции.ТурнирнаяТаблица(Ссылка);
КонецФункции

Функция ИгрыВсе() Экспорт
	Возврат (Команды.Количество() > 1 И СерверныйФункции.КоличествоИгр(Ссылка) = (Команды.Количество() - 1) * Команды.Количество());
КонецФункции

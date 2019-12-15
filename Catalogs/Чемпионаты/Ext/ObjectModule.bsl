﻿
Процедура ОбработкаПроверкиЗаполнения(Отказ, ПроверяемыеРеквизиты)
	Если ДатаНачала >= ДатаОкончания Тогда
		Отказ = Истина;
	КонецЕсли;
КонецПроцедуры

Процедура ПриКопировании(ОбъектКопирования)
	ТекЛига			= ОбъектКопирования.Владелец;
	ЧемпионатЛигиПоследний = СерверныйФункции.ЧемпионатЛигиПоследний(ТекЛига);
	Наименование	= "";
	нГод			= 0;
	Слова			= СтрРазделить(Строка(ЧемпионатЛигиПоследний), " ", Ложь);
	Для Каждого Слово Из Слова Цикл
		Если СтрНайти("0123456789", Лев(Слово, 1)) > 0 Тогда
			нГод = Число(Лев(Слово, 4)) + 1;
			Прервать;
		Иначе
			Наименование = Наименование + Слово + " ";
		КонецЕсли;
	КонецЦикла;
	
	Наименование = Наименование + ?(нГод = 0,
		Формат(Год(ТекущаяДата()), "ЧГ=0") + "/" + Формат((Год(ТекущаяДата()) + 1) - Цел((Год(ТекущаяДата()) + 1) / 100) * 100, "ЧН=00"),
		Формат(нГод, "ЧГ=0") + "/" + Прав(Формат(нГод + 1, "ЧГ=0"), 2));
	
	ДатаНачала		= ДобавитьМесяц(?(нГод = 0, ДатаНачала, ЧемпионатЛигиПоследний), 12);
	ДатаОкончания	= ДобавитьМесяц(?(нГод = 0, ДатаОкончания, ЧемпионатЛигиПоследний), 12);
	
	Команды.Очистить();
	Шаг		= 0;
	Выборка	= СерверныйФункции.ТурнирнаяТаблица(ЧемпионатЛигиПоследний);
	Пока Выборка.Следующий() И Шаг < ТекЛига.КоличествоКоманд - ТекЛига.КоличествоРотация Цикл
		ЗаполнитьЗначенияСвойств(Команды.Добавить(), Выборка);
		
		Шаг = Шаг + 1;
	КонецЦикла;
	Команды.Сортировать("Команда");
КонецПроцедуры

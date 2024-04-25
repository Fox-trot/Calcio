﻿
Процедура ОбработкаПроверкиЗаполнения(Отказ, ПроверяемыеРеквизиты)
	Если ДатаНачала > ДатаОкончания Тогда
		Отказ = Истина;
	ИначеЕсли ДатаНачала < Владелец.ДатаНачала Тогда
		Отказ = Истина;
	ИначеЕсли ДатаНачала > Владелец.ДатаОкончания Тогда
		Отказ = Истина;
	ИначеЕсли ДатаОкончания < Владелец.ДатаНачала Тогда
		Отказ = Истина;
	ИначеЕсли ДатаОкончания > Владелец.ДатаОкончания Тогда
		Отказ = Истина;
	//ИначеЕсли ОлимпийскаяСистема Тогда
	//	//
	//Иначе
	//	Запрос = Новый Запрос("ВЫБРАТЬ
	//	                      |	КОЛИЧЕСТВО(РАЗЛИЧНЫЕ Команды.Команда) КАК Количество
	//	                      |ИЗ
	//	                      |	Справочник.Чемпионаты.Команды КАК Команды
	//	                      |ГДЕ
	//	                      |	Команды.Ссылка = &Владелец");
	//	Запрос.УстановитьПараметр("Владелец", Владелец);
	//	Выборка = Запрос.Выполнить().Выбрать();
	//	Если Выборка.Следующий() И Выборка.Количество * 2 - 2 < Код Тогда
	//		Отказ = Истина;
	//	КонецЕсли;
	КонецЕсли;
КонецПроцедуры

Процедура ОбработкаЗаполнения(ДанныеЗаполнения, ТекстЗаполнения, СтандартнаяОбработка)
	Если ТипЗнч(ДанныеЗаполнения) = Тип("СправочникСсылка.Чемпионаты") Тогда
		Владелец			= ДанныеЗаполнения;
		ОлимпийскаяСистема	= ДанныеЗаполнения.Владелец.ОлимпийскаяСистема;
		
		ТурПоследний = ТурПоследний();
		Если ТурПоследний.Код = 0 Тогда
			Код	= 1;
		Иначе
			Если ОлимпийскаяСистема Тогда
				УстановитьНовыйКод(ТурПоследний.Код + 1);
				Наименование	= НаименованиеПолучить(ТурПоследний.Финал);
			ИначеЕсли ТурПоследний.Код < Владелец.Команды.Количество() * 2 - 2 Тогда
				УстановитьНовыйКод(ТурПоследний.Код + 1);
				Наименование	= НаименованиеПолучить();
				ДатаНачала		= ДатаНачала(ТурПоследний.ДатаОкончания);
				ДатаОкончания	= ДатаНачала + Сутки();
			КонецЕсли;
		КонецЕсли;
		
	ИначеЕсли ТипЗнч(ДанныеЗаполнения) = Тип("СправочникСсылка.Туры") Тогда
		ОбработкаЗаполнения(ДанныеЗаполнения.Владелец, ТекстЗаполнения, Ложь);
		
	ИначеЕсли ТипЗнч(ДанныеЗаполнения) = Тип("Структура") Тогда
		Если ДанныеЗаполнения.Свойство("Владелец") Тогда
			ОбработкаЗаполнения(ДанныеЗаполнения.Владелец, ТекстЗаполнения, Ложь);
		КонецЕсли;
	КонецЕсли;
КонецПроцедуры

Функция ДатаНачала(Знач Дата)
	Дата	= Дата + Сутки();
	Пока ДеньНедели(Дата) <> 6 Цикл
		Дата	= Дата + Сутки();
	КонецЦикла;
	Возврат Дата;
КонецФункции

Процедура ПриКопировании(ОбъектКопирования)
	Код				= КодНовыйПолучить();
	Наименование	= "";
	ДатаНачала		= Дата(1,1,1);
	ДатаОкончания	= Дата(1,1,1);
	Комментарий		= "";
КонецПроцедуры

Процедура ПриУстановкеНовогоКода(СтандартнаяОбработка, Префикс)
	ЗаполнитьЗначенияСвойств(ЭтотОбъект, Новый Структура("Код", Префикс));
КонецПроцедуры

Функция КодНовыйПолучить() Экспорт
	Если НЕ ЗначениеЗаполнено(Владелец) Тогда
		Владелец = СерверныйФункции.ЧемпионатЛигиПоследний(Владелец.Владелец);
	КонецЕсли;
	Запрос = Новый Запрос("ВЫБРАТЬ
	                      |	ЕСТЬNULL(МАКСИМУМ(Туры.Код), 0) КАК Код
	                      |ИЗ
	                      |	Справочник.Туры КАК Туры
	                      |ГДЕ
	                      |	Туры.Владелец = &Чемпионат
	                      |	И Туры.ПометкаУдаления = ЛОЖЬ");
	Запрос.УстановитьПараметр("Чемпионат",						Владелец);
	Выборка = Запрос.Выполнить().Выбрать();
	Возврат ?(Выборка.Следующий(), Выборка.Код + 1, 1);
КонецФункции

Функция НаименованиеПолучить(Знач Финал=Неопределено) Экспорт
	Если НЕ ОлимпийскаяСистема Тогда
		Возврат Строка(Макс(1, Код)) + "-й тур";
	КонецЕсли;
	
	Ответ = "";
	Если НЕ ЗначениеЗаполнено(Финал) Тогда
		ТурПоследний = ТурПоследний();
		Финал = ТурПоследний.Финал;
	КонецЕсли;
	Если ЗначениеЗаполнено(Финал) Тогда
		Запрос = Новый Запрос("ВЫБРАТЬ
		                      |	КОЛИЧЕСТВО(РАЗЛИЧНЫЕ Таблица.Команда) КАК Количество,
		                      |	1 КАК Порядок
		                      |ИЗ
		                      |	РегистрНакопления.ТурнирнаяТаблица КАК Таблица
		                      |ГДЕ
		                      |	Таблица.Тур = &Тур
		                      |	И Таблица.НомерСтроки = 2
		                      |	И ТИПЗНАЧЕНИЯ(Таблица.Регистратор) = ТИП(Документ.Матч)
		                      |
		                      |ОБЪЕДИНИТЬ ВСЕ
		                      |
		                      |ВЫБРАТЬ
		                      |	КОЛИЧЕСТВО(РАЗЛИЧНЫЕ ЧемпионатыКоманды.Команда),
		                      |	2
		                      |ИЗ
		                      |	Справочник.Чемпионаты.Команды КАК ЧемпионатыКоманды
		                      |
		                      |УПОРЯДОЧИТЬ ПО
		                      |	Порядок");
		Запрос.УстановитьПараметр("Тур",				Финал);
		Выборка = Запрос.Выполнить().Выбрать();
		Если Выборка.Следующий() Тогда
			Если Выборка.Количество = 4 Тогда
				Ответ = "Полуфиналы";
			ИначеЕсли Выборка.Количество > 2 Тогда
				Ответ = СтрШаблон("1/%1 финала", Выборка.Количество);
			Иначе
				Ответ = "Финал";
			КонецЕсли;
		КонецЕсли;
	КонецЕсли;
	Возврат Ответ;
КонецФункции

Функция ТурПоследний()
	Ответ = Новый Структура("Код,ДатаНачала,ДатаОкончания,Финал", 0, Дата(1,1,1), Дата(1,1,1));
	Запрос = Новый Запрос("ВЫБРАТЬ ПЕРВЫЕ 1
	                      |	Туры.Код КАК Код,
	                      |	Туры.ДатаНачала КАК ДатаНачала,
	                      |	Туры.ДатаОкончания КАК ДатаОкончания,
	                      |	Туры.Ссылка КАК Финал
	                      |ИЗ
	                      |	Справочник.Туры КАК Туры
	                      |ГДЕ
	                      |	Туры.Владелец = &Владелец
	                      |	И Туры.ПометкаУдаления = ЛОЖЬ
	                      |
	                      |УПОРЯДОЧИТЬ ПО
	                      |	ДатаОкончания УБЫВ");
	Запрос.УстановитьПараметр("Владелец", Владелец);
	Выборка = Запрос.Выполнить().Выбрать();
	Если Выборка.Следующий() Тогда
		ЗаполнитьЗначенияСвойств(Ответ, Выборка);
	КонецЕсли;
	Возврат Ответ;
КонецФункции

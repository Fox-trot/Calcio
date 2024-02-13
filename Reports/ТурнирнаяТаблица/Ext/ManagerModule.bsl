﻿
Функция ОтчетСформировать(Знач Чемпионат, ПоказыватьРазницуМячей=Ложь) Экспорт
	ТабДокумент = Новый ТабличныйДокумент;
	
	Лига	= Чемпионат.Владелец;
	Выборка = СерверныйФункции.ТурнирнаяТаблица(Чемпионат);
	
	Макет  = ПолучитьМакет("Макет");
	ОбластьМакета = Макет.ПолучитьОбласть("Заголовок");
	ОбластьМакета.Параметры.Чемпионат	= Чемпионат;
	Изображение	= СерверныйФункции.ИзображениеПолучить(Лига);
	Если Изображение.Вид <> ВидКартинки.Пустая Тогда
		//ОбластьИзображение = Макет.ПолучитьОбласть("Изображение");
		//ОбластьИзображение.Рисунки.Получить(0).Картинка = Изображение;
		//ОбластьМакета.Присоединить(ОбластьИзображение);
		ОбластьМакета.Рисунки.Получить(0).Картинка = Изображение;
	КонецЕсли;
	ТабДокумент.Вывести(ОбластьМакета);
	
	ТабДокумент.Вывести(Макет.ПолучитьОбласть("Шапка|Основа"));
	
	НаВылет		= Выборка.Количество() - Лига.КоличествоРотация;
	НомерСтроки	= 0;
	Пятерка		= 0;
	Пока Выборка.Следующий() Цикл
		НомерСтроки	= НомерСтроки + 1;
		
		Если НомерСтроки > 5 Тогда
			Если НомерСтроки > НаВылет Тогда
				ОбластьМакета = ПолучитьОбласть(Макет, 5);
				
			ИначеЕсли Пятерка = Выборка.КоличествоОчков Тогда
				ОбластьМакета = ПолучитьОбласть(Макет, 5);
				ТабДокумент.ФиксацияСверху = 2 + НомерСтроки;

			Иначе
				ОбластьМакета = ПолучитьОбласть(Макет);
			КонецЕсли;
			
		Иначе
			ОбластьМакета = ПолучитьОбласть(Макет, 5);
			ТабДокумент.ФиксацияСверху = 2 + НомерСтроки;

			Пятерка = Выборка.КоличествоОчков;
		КонецЕсли;
		ОбластьМакета.Параметры.Заполнить(Выборка);
		ОбластьМакета.Параметры.Место	= НомерСтроки;
		Если НЕ ПоказыватьРазницуМячей Тогда
			ОбластьМакета.Параметры.Разница	= Строка(Выборка.Забито) + "-" + Строка(Выборка.Пропущено);
		КонецЕсли;
		
		ТабДокумент.Вывести(ОбластьМакета);
	КонецЦикла;
	
	Выборка = КомментарииПолучить(Чемпионат);
	Пока Выборка.Следующий() Цикл
		ОбластьМакета = Макет.ПолучитьОбласть("Комментарий");
		ОбластьМакета.Параметры.Заполнить(Выборка);
		ТабДокумент.Вывести(ОбластьМакета);
	КонецЦикла;
	
	Возврат ТабДокумент;
КонецФункции

Функция ПолучитьОбласть(Макет, Параметр=0)
	Если Параметр = 0 Тогда
		ОбластьМакета = Макет.ПолучитьОбласть("Детали|Основа");
	Иначе
		ОбластьМакета = Макет.ПолучитьОбласть("Пятерка|Основа");
	КонецЕсли;
	Возврат ОбластьМакета;
КонецФункции

Функция КомментарииПолучить(Чемпионат)
	Запрос = Новый Запрос(
	"ВЫБРАТЬ
	|	СнятиеОчков.Комментарий КАК Комментарий,
	|	ТурнирнаяТаблица.Регистратор КАК Регистратор
	|ИЗ
	|	РегистрНакопления.ТурнирнаяТаблица КАК ТурнирнаяТаблица
	|		ВНУТРЕННЕЕ СОЕДИНЕНИЕ Документ.СнятиеОчков КАК СнятиеОчков
	|		ПО ТурнирнаяТаблица.Регистратор = СнятиеОчков.Ссылка
	|		ВНУТРЕННЕЕ СОЕДИНЕНИЕ Справочник.Чемпионаты.Команды КАК ЧемпионатыКоманды
	|		ПО ТурнирнаяТаблица.Команда = ЧемпионатыКоманды.Команда
	|ГДЕ
	|	ЧемпионатыКоманды.Ссылка = &Чемпионат
	|
	|УПОРЯДОЧИТЬ ПО
	|	ТурнирнаяТаблица.Период");
	Запрос.УстановитьПараметр("Чемпионат",		Чемпионат);
	Возврат Запрос.Выполнить().Выбрать();
КонецФункции

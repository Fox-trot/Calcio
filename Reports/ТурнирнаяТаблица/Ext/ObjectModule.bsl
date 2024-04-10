﻿
Функция ОтчетСформировать() Экспорт
	ТабДокумент = Новый ТабличныйДокумент;
	
	Регистраторы.Очистить();
	
	Лига	= Чемпионат.Владелец;
	Выборка = СерверныйФункции.ТурнирнаяТаблица(Чемпионат);
	
	Макет  = ПолучитьМакет("Макет");
	ОбластьМакета = Макет.ПолучитьОбласть("Заголовок");
	ОбластьМакета.Параметры.Заполнить(Новый Структура("Чемпионат,Лига", Чемпионат, Лига));
	Изображение	= СерверныйФункции.ИзображениеПолучить(Лига, Истина);
	Если Изображение.Вид <> ВидКартинки.Пустая Тогда
		ОбластьМакета.Рисунки.Получить(0).Картинка = Изображение;
	КонецЕсли;
	ТабДокумент.Вывести(ОбластьМакета);
	
	НомерСтроки	= 0;
	Если СерверныйФункции.ТурнирнаяТаблицаКакНаBBC() Тогда
		ТабДокумент.Вывести(Макет.ПолучитьОбласть("Шапка1"));
		Пока Выборка.Следующий() Цикл
			НомерСтроки	= НомерСтроки + 1;
			ОбластьМакета = Макет.ПолучитьОбласть("Детали1|Начало");
			ОбластьМакета.Параметры.Заполнить(Выборка);
			ОбластьМакета.Параметры.Место	= НомерСтроки;
			ТабДокумент.Вывести(ОбластьМакета);
			
			Пятерка		= 1;
			Матчи = СерверныйФункции.МатчиПоследние5(Выборка.Команда, Чемпионат);
			Для Каждого Детали Из Матчи Цикл
				ОбластьМакета = Макет.ПолучитьОбласть("Детали1|" + Детали.Результат);
				ОбластьМакета.Параметры.Заполнить(Детали);
				ТабДокумент.Присоединить(ОбластьМакета);
				Пятерка		= Пятерка + 1;
			КонецЦикла;
			Для Шаг = Пятерка По 5 Цикл
				ОбластьМакета = Макет.ПолучитьОбласть("Детали1|NN");
				ТабДокумент.Присоединить(ОбластьМакета);
			КонецЦикла;
		КонецЦикла;
	Иначе
		ТабДокумент.Вывести(Макет.ПолучитьОбласть("Шапка"));
		
		НаВылет		= Выборка.Количество() - Лига.КоличествоРотация;
		Пятерка		= 0;
		Пока Выборка.Следующий() Цикл
			НомерСтроки	= НомерСтроки + 1;
			
			Если НомерСтроки > Лига.КвалификацияВЛигуЧемпионовУЕФА Тогда
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
			
			//Регистраторы.Добавить(Выборка.Команда);
		КонецЦикла;
		Регистраторы.Добавить(Чемпионат);
		
		ОбластьМакета = Макет.ПолучитьОбласть("Комментарий");
		Выборка = КомментарииПолучить(Чемпионат);
		Пока Выборка.Следующий() Цикл
			ОбластьМакета.Параметры.Заполнить(Выборка);
			ТабДокумент.Вывести(ОбластьМакета);
			
			Регистраторы.Добавить(Выборка.Регистратор);
		КонецЦикла;
	КонецЕсли;
	Возврат ТабДокумент;
КонецФункции

Функция ПолучитьОбласть(Макет, Параметр=0)
	Если Параметр = 0 Тогда
		ОбластьМакета = Макет.ПолучитьОбласть("Детали");
	Иначе
		ОбластьМакета = Макет.ПолучитьОбласть("Пятерка");
	КонецЕсли;
	Возврат ОбластьМакета;
КонецФункции

Функция КомментарииПолучить(Чемпионат)
	Запрос = Новый Запрос(
	"ВЫБРАТЬ
	|	ВЫБОР
	|		КОГДА ДЛИНАСТРОКИ(СнятиеОчков.Комментарий) = 0
	|			ТОГДА СнятиеОчков.Представление
	|		ИНАЧЕ ПОДСТРОКА(СнятиеОчков.Комментарий, 1, 100)
	|	КОНЕЦ КАК Комментарий,
	|	ТурнирнаяТаблица.Регистратор КАК Регистратор,
	|	ТурнирнаяТаблица.Период КАК Дата
	|ИЗ
	|	РегистрНакопления.ТурнирнаяТаблица КАК ТурнирнаяТаблица
	|		ВНУТРЕННЕЕ СОЕДИНЕНИЕ Документ.СнятиеОчков КАК СнятиеОчков
	|		ПО ТурнирнаяТаблица.Регистратор = СнятиеОчков.Ссылка
	|		ВНУТРЕННЕЕ СОЕДИНЕНИЕ Справочник.Туры КАК Туры
	|		ПО ТурнирнаяТаблица.Тур = Туры.Ссылка
	|ГДЕ
	|	Туры.Владелец = &Чемпионат
	|
	|УПОРЯДОЧИТЬ ПО
	|	Дата");
	Запрос.УстановитьПараметр("Чемпионат",		Чемпионат);
	Возврат Запрос.Выполнить().Выбрать();
КонецФункции

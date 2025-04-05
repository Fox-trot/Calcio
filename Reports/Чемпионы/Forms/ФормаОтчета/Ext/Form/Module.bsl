﻿
&НаСервере
Процедура ГрафикОбновитьНаСервере()
	Если НЕ ЗначениеЗаполнено(Лига()) Тогда Возврат; КонецЕсли;
	
	Отчет.Данные.Очистить();
	Запрос = Новый Запрос("ВЫБРАТЬ ПЕРВЫЕ 13
	                      |	Чемпионаты.Ссылка КАК Ссылка,
	                      |	ГОД(Чемпионаты.ДатаОкончания) КАК Год
	                      |ПОМЕСТИТЬ Чемпионаты
	                      |ИЗ
	                      |	РегистрНакопления.ТурнирнаяТаблица КАК ТурнирнаяТаблица
	                      |		ВНУТРЕННЕЕ СОЕДИНЕНИЕ Справочник.Туры КАК Туры
	                      |			ВНУТРЕННЕЕ СОЕДИНЕНИЕ Справочник.Чемпионаты КАК Чемпионаты
	                      |			ПО Туры.Владелец = Чемпионаты.Ссылка
	                      |		ПО ТурнирнаяТаблица.Тур = Туры.Ссылка
	                      |ГДЕ
	                      |	Чемпионаты.Владелец = &Лига
						  //|	И Чемпионаты.ДатаОкончания <= &Дата
						  //|	И ТурнирнаяТаблица.Регистратор ССЫЛКА Документ.Матч
	                      |
	                      |СГРУППИРОВАТЬ ПО
	                      |	Чемпионаты.Ссылка,
	                      |	ГОД(Чемпионаты.ДатаОкончания)
	                      |
	                      |ИМЕЮЩИЕ
	                      |	КОЛИЧЕСТВО(РАЗЛИЧНЫЕ ТурнирнаяТаблица.Регистратор) = (КОЛИЧЕСТВО(РАЗЛИЧНЫЕ ТурнирнаяТаблица.Команда) - 1) * КОЛИЧЕСТВО(РАЗЛИЧНЫЕ ТурнирнаяТаблица.Команда) И
	                      |	КОЛИЧЕСТВО(РАЗЛИЧНЫЕ ТурнирнаяТаблица.Регистратор) >= КОЛИЧЕСТВО(РАЗЛИЧНЫЕ ТурнирнаяТаблица.Команда)
	                      |
	                      |УПОРЯДОЧИТЬ ПО
	                      |	Год УБЫВ
	                      |;
	                      |
	                      |////////////////////////////////////////////////////////////////////////////////
	                      |ВЫБРАТЬ
	                      |	Чемпионаты.Ссылка КАК Чемпионат,
	                      |	Чемпионаты.Год КАК Год,
	                      |	ТурнирнаяТаблица.Команда КАК Команда,
	                      |	СУММА(ТурнирнаяТаблица.КоличествоОчков) КАК КоличествоОчков,
	                      |	СУММА(ТурнирнаяТаблица.КоличествоГолов) КАК КоличествоГолов
	                      |ИЗ
	                      |	РегистрНакопления.ТурнирнаяТаблица КАК ТурнирнаяТаблица
	                      |		ВНУТРЕННЕЕ СОЕДИНЕНИЕ Справочник.Туры КАК Туры
	                      |			ВНУТРЕННЕЕ СОЕДИНЕНИЕ Чемпионаты КАК Чемпионаты
	                      |			ПО Туры.Владелец = Чемпионаты.Ссылка
	                      |		ПО ТурнирнаяТаблица.Тур = Туры.Ссылка
						  //|ГДЕ
						  //|	ТурнирнаяТаблица.Регистратор ССЫЛКА Документ.Матч
	                      |
	                      |СГРУППИРОВАТЬ ПО
	                      |	ТурнирнаяТаблица.Команда,
	                      |	Чемпионаты.Год,
	                      |	Чемпионаты.Ссылка
	                      |
	                      |УПОРЯДОЧИТЬ ПО
	                      |	Год,
	                      |	КоличествоОчков УБЫВ,
	                      |	КоличествоГолов УБЫВ");
	Запрос.УстановитьПараметр("Лига",			Лига());
	Запрос.УстановитьПараметр("Дата",			ТекущаяДатаСеанса());
	Если Отчет.Лига.ОлимпийскаяСистема Тогда
		Запрос.Текст = "ВЫБРАТЬ ПЕРВЫЕ 13
		               |	Чемпионаты.Ссылка КАК Ссылка,
		               |	ГОД(Чемпионаты.ДатаОкончания) КАК Год,
		               |	КОЛИЧЕСТВО(РАЗЛИЧНЫЕ ТурнирнаяТаблица.Тур) КАК Тур
		               |ПОМЕСТИТЬ Чемпионаты
		               |ИЗ
		               |	РегистрНакопления.ТурнирнаяТаблица КАК ТурнирнаяТаблица
		               |		ВНУТРЕННЕЕ СОЕДИНЕНИЕ Справочник.Туры КАК Туры
		               |			ВНУТРЕННЕЕ СОЕДИНЕНИЕ Справочник.Чемпионаты КАК Чемпионаты
		               |			ПО Туры.Владелец = Чемпионаты.Ссылка
		               |		ПО ТурнирнаяТаблица.Тур = Туры.Ссылка
		               |ГДЕ
		               |	Чемпионаты.Владелец = &Лига
		               |	И Чемпионаты.ДатаОкончания <= &Дата
		               |	И ТурнирнаяТаблица.Регистратор ССЫЛКА Документ.Матч
		               |
		               |СГРУППИРОВАТЬ ПО
		               |	Чемпионаты.Ссылка,
		               |	ГОД(Чемпионаты.ДатаОкончания)
		               |
		               |ИМЕЮЩИЕ
		               |	КОЛИЧЕСТВО(РАЗЛИЧНЫЕ ТурнирнаяТаблица.Регистратор) >= КОЛИЧЕСТВО(РАЗЛИЧНЫЕ ТурнирнаяТаблица.Команда)
		               |	И КОЛИЧЕСТВО(РАЗЛИЧНЫЕ ТурнирнаяТаблица.Регистратор) >= КОЛИЧЕСТВО(РАЗЛИЧНЫЕ ТурнирнаяТаблица.Команда)
		               |
		               |УПОРЯДОЧИТЬ ПО
		               |	Год УБЫВ
		               |;
		               |
		               |////////////////////////////////////////////////////////////////////////////////
		               |ВЫБРАТЬ
		               |	Чемпионаты.Ссылка КАК Чемпионат,
		               |	Чемпионаты.Год КАК Год,
		               |	ТурнирнаяТаблица.Команда КАК Команда,
		               |	СУММА(ТурнирнаяТаблица.КоличествоОчков) КАК КоличествоОчков,
		               |	СУММА(ТурнирнаяТаблица.КоличествоГолов) КАК КоличествоГолов
		               |ИЗ
		               |	Чемпионаты КАК Чемпионаты
		               |		ВНУТРЕННЕЕ СОЕДИНЕНИЕ Справочник.Туры КАК Туры
		               |			ВНУТРЕННЕЕ СОЕДИНЕНИЕ РегистрНакопления.ТурнирнаяТаблица КАК ТурнирнаяТаблица
		               |			ПО Туры.Ссылка = ТурнирнаяТаблица.Тур
		               |		ПО Чемпионаты.Ссылка = Туры.Владелец
		               |ГДЕ
		               |	ТурнирнаяТаблица.Регистратор ССЫЛКА Документ.Матч
		               |
		               |СГРУППИРОВАТЬ ПО
		               |	ТурнирнаяТаблица.Команда,
		               |	Чемпионаты.Год,
		               |	Чемпионаты.Ссылка,
		               |	Чемпионаты.Тур
		               |
		               |ИМЕЮЩИЕ
		               |	КОЛИЧЕСТВО(РАЗЛИЧНЫЕ ТурнирнаяТаблица.Тур) = Чемпионаты.Тур
		               |
		               |УПОРЯДОЧИТЬ ПО
		               |	Год,
		               |	КоличествоОчков УБЫВ";
	КонецЕсли;
	Выборка		= Запрос.Выполнить().Выбрать();
	Чемпионаты	= Новый Массив;
	
	Если ПростойОтчет Тогда
		Пока Выборка.Следующий() Цикл
			Если Чемпионаты.Найти(Выборка.Чемпионат) = Неопределено Тогда
				Чемпионаты.Добавить(Выборка.Чемпионат);
				
				ЗаполнитьЗначенияСвойств(Отчет.Данные.Добавить(), Выборка);
			КонецЕсли;
		КонецЦикла;

	Иначе
		Кондуит		= Новый Массив;
		Пока Выборка.Следующий() Цикл
			Если Чемпионаты.Найти(Выборка.Чемпионат) = Неопределено Тогда
				Чемпионаты.Добавить(Выборка.Чемпионат);
				Если Кондуит.Найти(Выборка.Команда) = Неопределено Тогда
					Кондуит.Добавить(Выборка.Команда);
				КонецЕсли;
			КонецЕсли;
		КонецЦикла;
		
		Запрос.Текст	= "ВЫБРАТЬ
		            	  |	ГОД(Чемпионаты.ДатаОкончания) КАК Год,
		            	  |	ТурнирнаяТаблица.Команда КАК Команда,
		            	  |	СУММА(ТурнирнаяТаблица.КоличествоОчков) КАК КоличествоОчков
		            	  |ИЗ
		            	  |	РегистрНакопления.ТурнирнаяТаблица КАК ТурнирнаяТаблица
		            	  |		ВНУТРЕННЕЕ СОЕДИНЕНИЕ Справочник.Туры КАК Туры
		            	  |			ВНУТРЕННЕЕ СОЕДИНЕНИЕ Справочник.Чемпионаты КАК Чемпионаты
		            	  |			ПО Туры.Владелец = Чемпионаты.Ссылка
		            	  |		ПО ТурнирнаяТаблица.Тур = Туры.Ссылка
		            	  |ГДЕ
		            	  |	ТурнирнаяТаблица.Команда В(&Команды)
		            	  |	И Туры.Владелец В(&Чемпионаты)
		            	  |
		            	  |СГРУППИРОВАТЬ ПО
		            	  |	ТурнирнаяТаблица.Команда,
		            	  |	ГОД(Чемпионаты.ДатаОкончания)
		            	  |
		            	  |УПОРЯДОЧИТЬ ПО
		            	  |	Год,
		            	  |	Команда
		            	  |АВТОУПОРЯДОЧИВАНИЕ";
		Запрос.УстановитьПараметр("Чемпионаты",		Чемпионаты);
		Запрос.УстановитьПараметр("Команды",		Кондуит);
		Выборка		= Запрос.Выполнить().Выбрать();
		Пока Выборка.Следующий() Цикл
			ЗаполнитьЗначенияСвойств(Отчет.Данные.Добавить(), Выборка);
		КонецЦикла;
	КонецЕсли;
КонецПроцедуры

&НаСервере
Функция Лига()
	Если НЕ ЗначениеЗаполнено(Отчет.Лига) Тогда
		Запрос = Новый Запрос("ВЫБРАТЬ ПЕРВЫЕ 1
		                      |	Чемпионаты.Владелец КАК Лига
		                      |ИЗ
		                      |	Справочник.Чемпионаты.Команды КАК ЧемпионатыКоманды
		                      |		ВНУТРЕННЕЕ СОЕДИНЕНИЕ Справочник.Чемпионаты КАК Чемпионаты
		                      |		ПО ЧемпионатыКоманды.Ссылка = Чемпионаты.Ссылка
		                      |ГДЕ
		                      |	ЧемпионатыКоманды.Команда = &Команда
		                      |
		                      |УПОРЯДОЧИТЬ ПО
		                      |	Чемпионаты.Владелец.ОлимпийскаяСистема,
		                      |	Чемпионаты.ДатаОкончания УБЫВ");
		Запрос.УстановитьПараметр("Команда",			СерверныйФункции.МояКомандаПолучить());
		Выборка	= Запрос.Выполнить().Выбрать();
		Если Выборка.Следующий() Тогда
			Отчет.Лига	= Выборка.Лига;
		КонецЕсли;
	КонецЕсли;
	Возврат Отчет.Лига;
КонецФункции

&НаСервере
Процедура СформироватьНаСервере()
	Если ЗначениеЗаполнено(Отчет.Лига) Тогда
		Результат = РеквизитФормыВЗначение("Отчет").ОтчетСформировать();
	КонецЕсли;
КонецПроцедуры

&НаКлиенте
Процедура ВидимостьДоступностьУстановить()
	Элементы.ОтображатьТаблицуДанных.Доступность	= (НЕ ПростойОтчет);
	Элементы.График.Видимость						= (НЕ ПростойОтчет);
	Элементы.Результат.Видимость					= ПростойОтчет;
КонецПроцедуры

&НаСервереБезКонтекста
Функция Цвет(Команда)
	Возврат СерверныйФункции.ЦветКоманды(Команда);
КонецФункции

&НаКлиенте
Процедура ГрафикОбновить(ТолькоГрафик=Ложь)
	Если НЕ ТолькоГрафик Тогда
		ГрафикОбновитьНаСервере();
	КонецЕсли;
	Если ПростойОтчет Тогда
		СформироватьНаСервере();
	Иначе
		График.ОбластьПостроения.ОтображатьТаблицуДанных	= ОтображатьТаблицуДанных;
		График.Очистить();
		Для Каждого Детали Из Отчет.Данные Цикл
			Серия		= График.УстановитьСерию(Детали.Команда);
			Цвет	= Цвет(Детали.Команда);
			Если ЗначениеЗаполнено(Цвет) Тогда
				Серия.Цвет			= Цвет;
			КонецЕсли;
			Точка		= График.УстановитьТочку(Детали.Год);
			Точка.Текст	= ФорматЧГ(Детали.Год);
			График.УстановитьЗначение(Точка, Серия, Детали.КоличествоОчков, Детали.Команда);
		КонецЦикла;
	КонецЕсли;
	ВидимостьДоступностьУстановить();
КонецПроцедуры

&НаКлиенте
Процедура ЛигаПриИзменении(Элемент)
	ГрафикОбновить();
КонецПроцедуры

&НаКлиенте
Процедура ПриОткрытии(Отказ)
	ГрафикОбновить();
КонецПроцедуры

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	Если Параметры.Свойство("Лига") Тогда
		Отчет.Лига		= Параметры.Лига;
		ПростойОтчет	= Истина;
		ОбщегоНазначения.ЗаголовокСкрыть(ЭтаФорма, Элементы.ГруппаПараметры);
	КонецЕсли;
КонецПроцедуры

&НаКлиенте
Процедура ОтображатьТаблицуДанныхПриИзменении(Элемент)
	ГрафикОбновить(Истина);
КонецПроцедуры

&НаКлиенте
Процедура ПростойОтчетПриИзменении(Элемент)
	ГрафикОбновить();
КонецПроцедуры

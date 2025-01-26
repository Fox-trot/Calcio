﻿
&НаСервере
Процедура СформироватьНаСервере()
	Если ЗначениеЗаполнено(Отчет.Чемпионат) Тогда
		Результат = РеквизитФормыВЗначение("Отчет").ОтчетСформировать(Отчет);
		
		Если Элементы.График.Видимость Тогда
			График.Точки.Очистить();
			Для Каждого Детали Из Отчет.Данные Цикл
				Точка	= График.УстановитьТочку(Детали.Команда);
				УстановитьЗначение(Точка, 0, Детали.Проигрыш);
				УстановитьЗначение(Точка, 1, Детали.Ничья);
				УстановитьЗначение(Точка, 2, Детали.Выигрыш);
			КонецЦикла;
		КонецЕсли;
	КонецЕсли;
КонецПроцедуры

&НаСервере
Процедура УстановитьЗначение(Точка, Серия, Значение)
	Если Значение > 0 Тогда
		График.УстановитьЗначение(Точка, График.Серии.Получить(Серия), Значение);
	КонецЕсли;
КонецПроцедуры

&НаКлиенте
Процедура Сформировать(Команда=Неопределено)
	Если ПроверитьЗаполнение() Тогда
		СформироватьНаСервере();
	КонецЕсли;
КонецПроцедуры

&НаКлиенте
Процедура ПриОткрытии(Отказ)
	НастройкиДефолт();
	ВидимостьУстановить();
	Сформировать();
КонецПроцедуры

&НаКлиенте
Процедура ОбработкаОповещения(ИмяСобытия, Параметр, Источник)
	Если ТипЗнч(Параметр) = Тип("СправочникСсылка.Чемпионаты") И Параметр = Отчет.Чемпионат Тогда
		СформироватьНаСервере();
	КонецЕсли;
КонецПроцедуры

&НаСервере
Процедура НастройкиДефолт()
	Если НЕ ЗначениеЗаполнено(Отчет.Чемпионат) Тогда
		Отчет.Чемпионат = СерверныйФункции.ЧемпионатПолучитьПоследнее();
	КонецЕсли;
КонецПроцедуры

&НаКлиенте
Процедура ЧемпионатПриИзменении(Элемент)
	СформироватьНаСервере();
КонецПроцедуры

&НаКлиенте
Процедура ПоказыватьРазницуМячейПриИзменении(Элемент)
	СформироватьНаСервере();
КонецПроцедуры

&НаСервере
Процедура ВидимостьУстановить()
	Элементы.ПоказыватьРазницуМячей.Видимость = (НЕ СерверныйФункции.ТурнирнаяТаблицаКакНаBBC());
КонецПроцедуры

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	Если Параметры.Свойство("Чемпионат") Тогда
		Отчет.Чемпионат	= Параметры.Чемпионат;
		ОбщегоНазначения.ЗаголовокСкрыть(ЭтаФорма, Элементы.ГруппаПараметры);
	Иначе
		Лиги.ЗагрузитьЗначения(ЛигиПолучить());
	КонецЕсли;
	Если НЕ Параметры.Свойство("График") Тогда
		Элементы.График.Видимость	= Ложь;
	КонецЕсли;
	
	СерииЗаполнить();
КонецПроцедуры

&НаСервере
Процедура СерииЗаполнить()
	СерверныйФункции.СерииЗаполнить(График);
КонецПроцедуры

&НаСервереБезКонтекста
Функция ЛигиПолучить()
	Запрос = Новый Запрос("ВЫБРАТЬ РАЗЛИЧНЫЕ
	                      |	Чемпионаты.Владелец КАК Владелец
	                      |ИЗ
	                      |	Справочник.Туры КАК Туры
	                      |		ВНУТРЕННЕЕ СОЕДИНЕНИЕ Справочник.Чемпионаты КАК Чемпионаты
	                      |		ПО Туры.Владелец = Чемпионаты.Ссылка
	                      |ГДЕ
	                      |	Туры.ОлимпийскаяСистема = ЛОЖЬ
	                      |	И Туры.ПометкаУдаления = ЛОЖЬ");
	Возврат Запрос.Выполнить().Выгрузить().ВыгрузитьКолонку(0);
КонецФункции

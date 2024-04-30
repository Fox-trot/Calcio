﻿
&НаКлиенте
Процедура ДомаПриИзменении(Элемент)
	ПараметрыУстановить();
КонецПроцедуры

&НаКлиенте
Процедура ПослеЗаписи(ПараметрыЗаписи)
	Оповестить("Команда", Объект.Ссылка);
КонецПроцедуры

&НаКлиенте
Процедура МатчиВыбор(Элемент, ВыбраннаяСтрока, Поле, СтандартнаяОбработка)
	ПоказатьЗначение(, Элемент.ТекущиеДанные.Матч);
КонецПроцедуры

&НаСервере
Процедура ПараметрыУстановить()
	Матчи.Параметры.УстановитьЗначениеПараметра("Ссылка",	Объект.Ссылка);
	Матчи.Параметры.УстановитьЗначениеПараметра("Дома",		Дома);
	ТекущийСостав.Параметры.УстановитьЗначениеПараметра("Ссылка", Объект.Ссылка);
КонецПроцедуры

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	Если Объект.Ссылка.Пустая() Тогда
		Объект.Владелец	= СерверныйФункции.Футбол();
		//Изображение	= ИзображениеДефолтПолучить();
	Иначе

		Изображение	= СерверныйФункции.ИзображениеПолучить(Объект.Ссылка);
		
		Если ЕстьИстория() Тогда
			Элементы.Владелец.ТолькоПросмотр	= Истина;
		КонецЕсли;
	КонецЕсли;
КонецПроцедуры

&НаСервере
Функция ИзображениеДефолтПолучить()
	Возврат СерверныйФункции.ИзображениеДефолтПолучить();
КонецФункции

&НаСервере
Функция ЕстьИстория()
	Возврат СерверныйФункции.ЕстьИстория(Объект.Ссылка);
КонецФункции

&НаКлиенте
Процедура ПриОткрытии(Отказ)
	ПараметрыУстановить();
	Если Объект.Ссылка.Пустая() Тогда
		Элементы.Страницы.ТекущаяСтраница = Элементы.ОсновнаяИнформация;
	Иначе
		Если НЕ ЗначениеЗаполнено(Объект.Город) Тогда
			//
		ИначеЕсли ТекущийСоставПустой() Тогда
			Элементы.Страницы.ТекущаяСтраница = Элементы.ГруппаТекущийСостав;
		Иначе
			Элементы.Страницы.ТекущаяСтраница = Элементы.ГруппаМатчи;
		КонецЕсли;
		Группа1ПриСменеСтраницы(Элементы.Страницы, Элементы.Страницы.ТекущаяСтраница);
		Страна.ЗагрузитьЗначения(Страна(Объект.Ссылка));
		Лиги.ЗагрузитьЗначения(Лиги(Объект.Ссылка));
	КонецЕсли;
КонецПроцедуры

&НаСервереБезКонтекста
Функция Лиги(Ссылка)
	Возврат СерверныйФункции.Лиги(Ссылка);
КонецФункции

&НаСервереБезКонтекста
Функция Страна(Команда)
	Запрос = Новый Запрос("ВЫБРАТЬ РАЗЛИЧНЫЕ
	                      |	Лига.Страна КАК Страна
	                      |ИЗ
	                      |	Справочник.Чемпионаты.Команды КАК ЧемпионатыКоманды
	                      |		ВНУТРЕННЕЕ СОЕДИНЕНИЕ Справочник.Чемпионаты КАК Чемпионаты
	                      |			ВНУТРЕННЕЕ СОЕДИНЕНИЕ Справочник.Лига КАК Лига
	                      |				ВНУТРЕННЕЕ СОЕДИНЕНИЕ Справочник.Страны КАК Страны
	                      |				ПО Лига.Страна = Страны.Ссылка
	                      |			ПО Чемпионаты.Владелец = Лига.Ссылка
	                      |		ПО ЧемпионатыКоманды.Ссылка = Чемпионаты.Ссылка
	                      |ГДЕ
	                      |	ЧемпионатыКоманды.Команда = &Команда");
	Запрос.УстановитьПараметр("Команда",			Команда);
	Ризалт = Запрос.Выполнить();
	Если Ризалт.Пустой() Тогда
		Запрос.Текст = "ВЫБРАТЬ РАЗЛИЧНЫЕ
		               |	Страны.Ссылка КАК Страна
		               |ИЗ
		               |	Справочник.Страны КАК Страны
		               |		ВНУТРЕННЕЕ СОЕДИНЕНИЕ Справочник.Города КАК Города
		               |		ПО Страны.Ссылка = Города.Владелец
		               |ГДЕ
		               |	Страны.ПометкаУдаления = ЛОЖЬ
		               |	И Города.ПометкаУдаления = ЛОЖЬ";
		Ризалт = Запрос.Выполнить();
	КонецЕсли;
	Возврат Ризалт.Выгрузить().ВыгрузитьКолонку(0);
КонецФункции

&НаСервере
Функция ТекущийСоставПустой()
	Запрос = Новый Запрос(ТекущийСостав.ТекстЗапроса);
	Запрос.УстановитьПараметр("Ссылка", Объект.Ссылка);
	Возврат Запрос.Выполнить().Пустой();
КонецФункции

&НаСервере
Процедура ПослеЗаписиНаСервере(ТекущийОбъект, ПараметрыЗаписи)
	ПараметрыУстановить();
КонецПроцедуры

&НаКлиенте
Процедура ОбработкаОповещения(ИмяСобытия, Параметр, Источник)
	Если ТипЗнч(Параметр) = Тип("СправочникСсылка.Команды")
	И Параметр = Объект.Ссылка
	Тогда
		Прочитать();
		Лиги.ЗагрузитьЗначения(Лиги(Объект.Ссылка));
		Элементы.ТекущийСостав.Обновить();
	ИначеЕсли ТипЗнч(Параметр) = Тип("СправочникСсылка.Города") Тогда
		Страна.ЗагрузитьЗначения(Страна(Объект.Ссылка));
	КонецЕсли;
КонецПроцедуры

&НаСервере
Функция ИсключитьНаСервере(Ссылка)
	Ответ = Ложь;
	Если ТипЗнч(Ссылка) = Тип("СправочникСсылка.Игроки") Тогда
		Ссылка.ПолучитьОбъект().УстановитьПометкуУдаления(НЕ Ссылка.ПометкаУдаления);
		Ответ = Истина;
	КонецЕсли;
	Возврат Ответ;
КонецФункции

&НаКлиенте
Процедура Исключить(Команда)
	Если Элементы.ТекущийСостав.ТекущиеДанные = Неопределено Тогда
		//
	ИначеЕсли ИсключитьНаСервере(Элементы.ТекущийСостав.ТекущиеДанные.Игрок) Тогда
		Элементы.ТекущийСостав.Обновить();
	КонецЕсли;
КонецПроцедуры

&НаСервере
Функция СезонНаСервере()
	Сезон.Очистить();
	Если Чемпионат.Пустая() Тогда
		Чемпионат = СерверныйФункции.ЧемпионатПолучитьПоследнее(Объект.Ссылка);
		Если Чемпионат.Пустая() Тогда
			Чемпионат = СерверныйФункции.ЧемпионатПолучитьПоследнее(Объект.Ссылка, Истина);
		КонецЕсли;
	КонецЕсли;
	Если ЗначениеЗаполнено(Чемпионат) Тогда
		Если НЕ СерверныйФункции.ЛигаОлимпийскаяСистема(Чемпионат.Владелец) Тогда
			МестоВЧемпионате = СерверныйФункции.МестоВЧемпионате(Объект.Ссылка, Чемпионат);
			Если МестоВЧемпионате <> 0 Тогда
				нСтрока = Сезон.Добавить();
				нСтрока.Ключ		= "Место";
				нСтрока.Значение	= МестоВЧемпионате;
			КонецЕсли;
		КонецЕсли;
		Стат	= СерверныйФункции.СтатистикаИгр(Объект.Ссылка, Чемпионат);
		Для Каждого ТекЭлемент Из Стат Цикл
			ЗаполнитьЗначенияСвойств(Сезон.Добавить(), ТекЭлемент);
		КонецЦикла;
	КонецЕсли;
	Возврат ?(ЗначениеЗаполнено(Чемпионат), Чемпионат.ПолноеНаименование(), "");
КонецФункции

&НаКлиенте
Процедура СезонОбновить(Команда=Неопределено)
	Если Объект.Ссылка.Пустая() Тогда Возврат; КонецЕсли;

	Слово = СезонНаСервере();
	Если ПустаяСтрока(Слово) Тогда
		Элементы.СтраницаСезон.Заголовок = "Сезон";
	Иначе
		Элементы.СтраницаСезон.Заголовок = "Сезон (" + Слово + ")";
		Предыдущие5Обновить();
	КонецЕсли;
КонецПроцедуры

&НаСервере
Процедура Предыдущие5Обновить()
	ЭлементыУдалить();
	Запрос	= Новый Запрос("ВЫБРАТЬ
	      	               |	ТурнирнаяТаблица.Период КАК Период,
	      	               |	ТурнирнаяТаблица.КоличествоОчков КАК КоличествоОчков
	      	               |ИЗ
	      	               |	РегистрНакопления.ТурнирнаяТаблица КАК ТурнирнаяТаблица
						   |		ВНУТРЕННЕЕ СОЕДИНЕНИЕ Справочник.Туры КАК Туры
						   |		ПО ТурнирнаяТаблица.Тур = Туры.Ссылка
						   |ГДЕ
						   |	ТурнирнаяТаблица.Команда = &Команда
						   |	И ТИПЗНАЧЕНИЯ(ТурнирнаяТаблица.Регистратор) = ТИП(Документ.Матч)
						   |	И Туры.Владелец = &Чемпионат
	      	               |
	      	               |УПОРЯДОЧИТЬ ПО
	      	               |	Период");
	Запрос.УстановитьПараметр("Команда",	Объект.Ссылка);
	Запрос.УстановитьПараметр("Чемпионат",	Чемпионат);
	Выборка = Запрос.Выполнить().Выбрать();
	Пока Выборка.Следующий() Цикл
		ИграУстановить2(Элементы.ГруппаПредыдущие5, Выборка);
	КонецЦикла;
КонецПроцедуры

&НаСервере
Процедура ИграУстановить2(Родитель, Выборка)
	Элемент = Элементы.Добавить("_" + Лев(Новый УникальныйИдентификатор, 8), Тип("ДекорацияФормы"), Родитель);
	Если Выборка.КоличествоОчков = 0 Тогда
		Элемент.Заголовок	= "L";
		Элемент.ЦветТекста	= ЦветаСтиля.ЦветОтрицательногоЧисла;
	ИначеЕсли Выборка.КоличествоОчков = 1 Тогда
		Элемент.Заголовок	= "D";
		Элемент.ЦветТекста	= ЦветаСтиля.ЦветТекстаПоля;
		//Элемент.ЦветФона	= ЦветаСтиля.ЦветРамки;
	Иначе
		Элемент.Заголовок	= "W";
		Элемент.ЦветТекста	= ЦветаСтиля.ЦветАкцента;
	КонецЕсли;
КонецПроцедуры

&НаСервере
Процедура ЭлементыУдалить2(Викимз)
	Пока Викимз.Количество() > 0 Цикл
		Для Каждого Элемент Из Викимз Цикл
			Элементы.Удалить(Элемент);
		КонецЦикла;
	КонецЦикла;
КонецПроцедуры

&НаСервере
Процедура ЭлементыУдалить()
	ЭлементыУдалить2(Элементы.ГруппаПредыдущие5.ПодчиненныеЭлементы);
КонецПроцедуры

&НаКлиенте
Процедура Группа1ПриСменеСтраницы(Элемент, ТекущаяСтраница)
	Если Элементы.СтраницаСезон = ТекущаяСтраница Тогда
		Если Сезон.Количество() = 0 Тогда
			СезонОбновить();
		КонецЕсли;
	ИначеЕсли Элементы.ГруппаБиоритмы = ТекущаяСтраница Тогда
		Если График2.КоличествоСерий = 0 И Элементы.ТекущийСостав.ТекущиеДанные <> Неопределено Тогда
			График2Обновить();
		КонецЕсли;
	КонецЕсли;
КонецПроцедуры

&НаКлиенте
Процедура ТекущийСоставВыбор(Элемент, ВыбраннаяСтрока, Поле, СтандартнаяОбработка)
	СтандартнаяОбработка = Ложь;
	ПоказатьЗначение(, Элемент.ТекущиеДанные.Игрок);
КонецПроцедуры

&НаКлиенте
Процедура ВыбратьИзображение(Команда)
	Если СтрСравнить(Команда.Имя, "ВыбратьИзображение") = 0 Тогда
		НачатьПомещениеФайлаНаСервер(Новый ОписаниеОповещения("ОбработатьВыборФайла", ЭтотОбъект));
	ИначеЕсли СтрСравнить(Команда.Имя, "УдалитьИзображение") = 0 Тогда
		Изображение = ИзображениеДефолтПолучить();
		Модифицированность	= Истина;
	КонецЕсли;
КонецПроцедуры

&НаКлиенте
Процедура ОбработатьВыборФайла(Результат, ДополнительныеПараметры) Экспорт
	Если ТипЗнч(Результат) = Тип("ОписаниеПомещенногоФайла") Тогда
		Если ОбщегоНазначения.РасширениеФайлаВерно(Результат.СсылкаНаФайл.Расширение) Тогда
			Изображение = Результат.Адрес;
			Модифицированность	= Истина;
		Иначе
			ОбщегоНазначения.СообщитьОбОшибке("Данные тип файла не поддерживается");
		КонецЕсли;
	ИначеЕсли ТипЗнч(Результат) = Тип("Строка") И НЕ ПустаяСтрока(Результат) Тогда
		Изображение			= ПоместитьВоВременноеХранилище(Новый Картинка(Результат), УникальныйИдентификатор);
		Модифицированность	= Истина;
	КонецЕсли;
КонецПроцедуры

&НаКлиенте
Процедура ИзображениеПроверкаПеретаскивания(Элемент, ПараметрыПеретаскивания, СтандартнаяОбработка)
	Если ЭтоУРЛ(ПараметрыПеретаскивания.Значение) Тогда
		НачатьКопированиеФайла(Новый ОписаниеОповещения("ОбработатьВыборФайла", ЭтотОбъект), ПараметрыПеретаскивания.Значение, КаталогВременныхФайлов() + ИмяФайла(ПараметрыПеретаскивания.Значение));
	ИначеЕсли ТипЗнч(ПараметрыПеретаскивания.Значение) = Тип("СсылкаНаФайл") Тогда
		Изображение			= ПоместитьВоВременноеХранилище(Новый Картинка(ПараметрыПеретаскивания.Значение.Файл.ПолноеИмя), УникальныйИдентификатор);
		Модифицированность	= Истина;
		СтандартнаяОбработка= Ложь;
	КонецЕсли;
КонецПроцедуры

&НаСервере
Процедура ПередЗаписьюНаСервереИзображение(Объект, Адрес="", Отказ=Ложь) Экспорт
	Если Отказ Тогда
		//
	ИначеЕсли ЭтоАдресВременногоХранилища(Адрес) Тогда
		тИзображение = Новый ХранилищеЗначения(ПолучитьИзВременногоХранилища(Адрес));
		Если Объект.Изображение.Получить() <> тИзображение.Получить() Тогда
			Объект.Изображение = тИзображение;
		КонецЕсли;
	ИначеЕсли ПустаяСтрока(Адрес) И ЗначениеЗаполнено(Объект.Изображение.Получить()) Тогда
		Объект.Изображение = NULL;
	КонецЕсли;
КонецПроцедуры

&НаСервере
Процедура ПередЗаписьюНаСервере(Отказ, ТекущийОбъект, ПараметрыЗаписи)
	Если Модифицированность Тогда
		ПередЗаписьюНаСервереИзображение(ТекущийОбъект, Изображение);
	КонецЕсли;
КонецПроцедуры

&НаКлиенте
Процедура ТекущийСоставПередУдалением(Элемент, Отказ)
	Отказ = Истина;

	Если ИсключитьНаСервере(Элементы.ТекущийСостав.ТекущиеДанные.Игрок) Тогда
		Элементы.ТекущийСостав.Обновить();
	КонецЕсли;
КонецПроцедуры

&НаКлиенте
Процедура Уволить(Команда)
	Если Элементы.ТекущийСостав.ТекущиеДанные = Неопределено Тогда
		//
	ИначеЕсли УволитьНаСервере(Элементы.ТекущийСостав.ТекущиеДанные.Игрок) Тогда
		Элементы.ТекущийСостав.Обновить();
	КонецЕсли;
КонецПроцедуры

&НаСервере
Функция УволитьНаСервере(Ссылка)
	Ответ = Ложь;
	Если ТипЗнч(Ссылка) = Тип("СправочникСсылка.Игроки") Тогда
		Запрос = Новый Запрос("ВЫБРАТЬ
		                      |	СрезПоследних.Период КАК Период,
		                      |	СрезПоследних.Команда КАК Команда
		                      |ИЗ
		                      |	РегистрСведений.ПеремещенияИгроков.СрезПоследних(, Игрок = &Игрок) КАК СрезПоследних");
		Запрос.УстановитьПараметр("Игрок",			Ссылка);
		Выборка = Запрос.Выполнить().Выбрать();
		Если Выборка.Следующий() И Выборка.Команда = Объект.Ссылка Тогда
			Запись = РегистрыСведений.ПеремещенияИгроков.СоздатьМенеджерЗаписи();
			ЗаполнитьЗначенияСвойств(Запись, Новый Структура("Период,Игрок", КонецМесяца(ДобавитьМесяц(Выборка.Период, 4)), Ссылка));
			Если Запись.ПроверитьЗаполнение() Тогда
				Попытка
					Запись.Записать();
					Ответ = Истина;
				Исключение
					ОбщегоНазначения.СообщитьОбОшибке(ОписаниеОшибки());
				КонецПопытки;
			КонецЕсли;
		КонецЕсли;
	КонецЕсли;
	Возврат Ответ;
КонецФункции

&НаКлиенте
Процедура ЧемпионатПриИзменении(Элемент)
	СезонОбновить();
КонецПроцедуры

&НаКлиенте
Процедура ГородНачалоВыбора(Элемент, ДанныеВыбора, ВыборДобавлением, СтандартнаяОбработка)
	Если ЗначениеЗаполнено(Объект.Город) Тогда
		Страна.ЗагрузитьЗначения(Страна(Объект.Ссылка));
	Иначе
		Объект.Город = ГородНайти(Объект.Наименование);
		Если ЗначениеЗаполнено(Объект.Город) Тогда
			СтандартнаяОбработка = Ложь;
		Иначе
			Страна.ЗагрузитьЗначения(Страна(Объект.Ссылка));
		КонецЕсли;
	КонецЕсли;
КонецПроцедуры

&НаСервереБезКонтекста
Функция ГородНайти(Наименование)
	Запрос = Новый Запрос("ВЫБРАТЬ ПЕРВЫЕ 1
	                      |	Города.Ссылка КАК Ссылка
	                      |ИЗ
	                      |	Справочник.Города КАК Города
	                      |ГДЕ
	                      |	Города.Наименование = &Наименование
	                      |
	                      |УПОРЯДОЧИТЬ ПО
	                      |	Города.ПометкаУдаления");
	Запрос.УстановитьПараметр("Наименование",		Наименование);
	Выборка = Запрос.Выполнить().Выбрать();
	Если Выборка.Следующий() Тогда
		Возврат Выборка.Ссылка;
	КонецЕсли;
	Возврат Справочники.Города.ПустаяСсылка();
КонецФункции

&НаСервере
Функция График2ОбновитьНаСервере()
	Запрос = Новый Запрос("ВЫБРАТЬ
	                      |	РАЗНОСТЬДАТ(Игроки.ДатаРождения, &Дата, ДЕНЬ) КАК Количество,
	                      |	Игроки.Ссылка КАК Игрок,
	                      |	ЕСТЬNULL(Перемещения.Амплуа.Ссылка, Игроки.Амплуа) КАК Амплуа
	                      |ИЗ
	                      |	РегистрСведений.ПеремещенияИгроков.СрезПоследних(
	                      |			&Дата,
	                      |			Игрок.ПометкаУдаления = ЛОЖЬ
	                      |				И ГОД(Игрок.ДатаРождения) > 1900) КАК Перемещения
	                      |		ВНУТРЕННЕЕ СОЕДИНЕНИЕ Справочник.Игроки КАК Игроки
	                      |		ПО Перемещения.Игрок = Игроки.Ссылка
	                      |ГДЕ
	                      |	Перемещения.Команда = &Команда
	                      |
	                      |УПОРЯДОЧИТЬ ПО
	                      |	Амплуа,
	                      |	Игрок
	                      |АВТОУПОРЯДОЧИВАНИЕ");
	Запрос.УстановитьПараметр("Дата",			ТекущаяДатаСеанса());
	Запрос.УстановитьПараметр("Команда",		Объект.Ссылка);
	Если ЗначениеЗаполнено(Амплуа) Тогда
		Запрос.Текст = "ВЫБРАТЬ
		               |	РАЗНОСТЬДАТ(Игроки.ДатаРождения, &Дата, ДЕНЬ) КАК Количество,
		               |	Игроки.Ссылка КАК Игрок
		               |ИЗ
		               |	РегистрСведений.ПеремещенияИгроков.СрезПоследних(&Дата, ГОД(Игрок.ДатаРождения) > 1900) КАК Перемещения
		               |		ВНУТРЕННЕЕ СОЕДИНЕНИЕ Справочник.Игроки КАК Игроки
		               |		ПО Перемещения.Игрок = Игроки.Ссылка
		               |ГДЕ
		               |	Перемещения.Команда = &Команда
		               |	И ЕСТЬNULL(Перемещения.Амплуа.Ссылка, Игроки.Амплуа) = &Амплуа
		               |
		               |УПОРЯДОЧИТЬ ПО
		               |	Игрок
		               |АВТОУПОРЯДОЧИВАНИЕ";
		Запрос.УстановитьПараметр("Амплуа",			Амплуа);
	КонецЕсли;
	Выборка = Запрос.Выполнить().Выбрать();
	Пока Выборка.Следующий() Цикл
		Для тФаза = 1 По 3 Цикл
			Серия	= График2.УстановитьСерию(Биоритмы.ФЭИ(тФаза));
			Точка	= График2.УстановитьТочку(Выборка.Игрок);
			График2.УстановитьЗначение(Точка, Серия, Биоритмы.ФазаРасчитать2(Выборка.Количество, тФаза), Выборка.Игрок);
		КонецЦикла;
	КонецЦикла;
КонецФункции

&НаКлиенте
Процедура График2Обновить(Команда=Неопределено)
	График2.Очистить();
	График2ОбновитьНаСервере();
КонецПроцедуры

&НаКлиенте
Процедура АмплуаПриИзменении(Элемент)
	График2Обновить();
КонецПроцедуры

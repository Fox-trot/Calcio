﻿//	https://football.kulichki.net/england/2019/teams/arsenal.htm
&НаКлиенте
Процедура ОбработкаКоманды(ПараметрКоманды, ПараметрыВыполненияКоманды)
	УРЛ = УРЛ(ПараметрКоманды);
	ПоказатьВводСтроки(Новый ОписаниеОповещения("Импорт", ЭтотОбъект, ПараметрКоманды), УРЛ, "Импорт игроков");
КонецПроцедуры

&НаКлиенте
Процедура Импорт(УРЛ, ПараметрКоманды) Экспорт
	Если НЕ ПустаяСтрока(УРЛ) Тогда
		//Если ИмпортИгроковНаСервере2(УРЛ, ПараметрКоманды) Тогда
		Если ИмпортИгроковНаСервере(УРЛ, ПараметрКоманды) Тогда
			Оповестить("Команда", ПараметрКоманды);
		КонецЕсли;
	КонецЕсли;
КонецПроцедуры

&НаСервере
Функция ИмпортИгроковНаСервере2(Гиперссылка, Команда)
	Итого	= 0;
	Шагов	= 0;
	
	сИгрок	= Новый Структура("Команда,Период,Номер,ДатаРождения,Наименование,Страна,Игрок", Команда, ДатаНачалаСезона(Гиперссылка), 0, Дата(1,1,1), "");
	//Амплуа
	
	Слова	= СерверныйФункции.ПолучитьЭлементыПоИмени(Гиперссылка);
	Для Каждого Слово Из Слова Цикл
		Шагов	= Шагов + 1;
		Если Шагов > 321 Тогда
			Прервать;
		ИначеЕсли Шагов = 1 Тогда
			Если СтрСравнить(Слово, Команда.Наименование) <> 0 Тогда	// возможно ошибка урл
				Прервать;
			КонецЕсли;
		ИначеЕсли СтрСравнить(Слово, "-") = 0 Тогда
			сИгрок.Номер = 0;
		//ИначеЕсли Макс(0, СтрокаКакЧисло(Слово)) > 0 Тогда
		//	сИгрок.Номер		= СтрокаКакЧисло(Слово);
		//	сИгрок.Наименование	= "";
		ИначеЕсли сИгрок.Номер = 0 Тогда
			сИгрок.Номер		= СтрокаКакЧисло(Слово);
			сИгрок.Наименование	= "";
		//ИначеЕсли СтрНайти("тур,дата,соперник,голы", НРег(Слово)) > 0 И Шагов > 0 Тогда
		//	Прервать;
		ИначеЕсли ПустаяСтрока(сИгрок.Наименование) Тогда
			Если СтрДлина(Слово) > 7 И Год(СтрокаКакДата(Слово)) > 2000 Тогда
				Прервать;
			ИначеЕсли СтрокаСодержитЧисло(Слово) Тогда
				Прервать;
			ИначеЕсли СтрДлина(Слово) > 3 Тогда
				сИгрок.Наименование = Слово;
			КонецЕсли;
			
		ИначеЕсли Год(сИгрок.ДатаРождения) < 2 Тогда
			сИгрок.ДатаРождения = СтрокаКакДата(Слово);
			
		ИначеЕсли НЕ ЗначениеЗаполнено(сИгрок.Страна) Тогда
			сИгрок.Страна = СерверныйФункции.СтранаНайти(Слово);
			
	//	КонецЕсли;
	//
	//	Если НЕ ПустаяСтрока(сИгрок.Наименование)
	//	И Год(сИгрок.ДатаРождения) > 1
	//	И сИгрок.Номер > 0
	//	И ТипЗнч(сИгрок.Страна) = Тип("СправочникСсылка.Страны")
	//	Тогда
		ИначеЕсли ТипЗнч(сИгрок.Страна) = Тип("СправочникСсылка.Страны") Тогда
 			сИгрок.Игрок = СерверныйФункции.ИгрокНайти(сИгрок.Наименование);
			Если ЗначениеЗаполнено(сИгрок.Игрок) Тогда
				НовыйИгрок = сИгрок.Игрок.ПолучитьОбъект();
				//Если ЗначениеЗаполнено(сИгрок.Амплуа) И НовыйИгрок.Амплуа <> сИгрок.Амплуа Тогда
				//	НовыйИгрок.Амплуа = сИгрок.Амплуа;
				//КонецЕсли;
				Если НовыйИгрок.ДатаРождения <> сИгрок.ДатаРождения Тогда
					НовыйИгрок.ДатаРождения = сИгрок.ДатаРождения;
				КонецЕсли;
				Если ЗначениеЗаполнено(сИгрок.Страна) И НовыйИгрок.Страна <> сИгрок.Страна Тогда
					НовыйИгрок.Страна = сИгрок.Страна;
				КонецЕсли;
			Иначе
				НовыйИгрок = Справочники.Игроки.СоздатьЭлемент();
				ЗаполнитьЗначенияСвойств(НовыйИгрок, сИгрок);
				НовыйИгрок.УстановитьНовыйКод();
			КонецЕсли;
			Если НовыйИгрок.Модифицированность() Тогда
				Если НовыйИгрок.ПроверитьЗаполнение() Тогда
					Попытка
						НовыйИгрок.Записать();
						сИгрок.Игрок = НовыйИгрок.Ссылка;
					Исключение
						Прервать;
					КонецПопытки;
				Иначе
					Продолжить;
				КонецЕсли;
			КонецЕсли;
			
			Последнее = РегистрыСведений.ПеремещенияИгроков.ПолучитьПоследнее(сИгрок.Период, Новый Структура("Игрок", сИгрок.Игрок));
			Если Последнее.Команда <> Команда
			//Или Последнее.Номер <> сИгрок.Номер
			Тогда
				НЗ = РегистрыСведений.ПеремещенияИгроков.СоздатьМенеджерЗаписи();
				ЗаполнитьЗначенияСвойств(НЗ, сИгрок);
				Попытка
					НЗ.Записать();
					Итого = Итого + 1;
				Исключение
				КонецПопытки;
			КонецЕсли;
			
			сИгрок.Номер		= 0;
			сИгрок.ДатаРождения	= Дата(1,1,1);
			сИгрок.Наименование	= "";
			сИгрок.Игрок		= Неопределено;
			сИгрок.Страна		= Неопределено;
		КонецЕсли;
	КонецЦикла;
	Возврат (Итого > 0);
КонецФункции

&НаСервере
Функция ИмпортИгроковНаСервере(Гиперссылка, Команда)
	Итого		= 0;
	ВсеПлохо	= НРег(Команда.Наименование);
	ДатаНачала	= ДатаНачалаСезона(Гиперссылка);

	Слова	= СерверныйФункции.ПолучитьЭлементыПоИмени(Гиперссылка, "font");
	сИгрок	= Новый Структура("Команда,Период,Номер,ДатаРождения,Наименование,Амплуа,Страна,Игрок", Команда, ДатаНачала, 0, Дата(1,1,1), "");
	Для Каждого Слово Из Слова Цикл
		Если СтрСравнить(Слово, "Соперник") = 0 Тогда
			Прервать;
		ИначеЕсли СтрСравнить(Слово, "Игроки") = 0 Тогда
			сИгрок.Команда	= Неопределено;
			сИгрок.Период	= КонецГода(ДатаНачала);
			сИгрок.Амплуа	= Справочники.Амплуа.ПустаяСсылка();
			
		ИначеЕсли СтрСравнить(Слово, "-") = 0
		Или СтрСравнить(Слово, "Гражданство") = 0
		Тогда
			сИгрок.Номер = 0;
			
		ИначеЕсли НЕ ПустаяСтрока(ВсеПлохо) Тогда
			Если СтрНайти(НРег(Слово), ВсеПлохо) > 0 Тогда
				ВсеПлохо = "";
			ИначеЕсли СтрНайти(НРег(Команда.Комментарий), НРег(Слово)) > 0 Тогда
				ВсеПлохо = "";
			КонецЕсли;
		ИначеЕсли СтрЧислоСтрок(Слово) > 1 Тогда
			сИгрок.Номер = 0;
		ИначеЕсли СтрСравнить(Слово, "Вратари") = 0 Тогда
			сИгрок.Амплуа = СерверныйФункции.Амплуа();
		ИначеЕсли СтрСравнить(Слово, "Защитники") = 0 Тогда
			сИгрок.Амплуа = СерверныйФункции.Амплуа("Защитник");
		ИначеЕсли СтрСравнить(Слово, "Полузащитники") = 0 Тогда
			сИгрок.Амплуа = СерверныйФункции.Амплуа("Полузащитник");
		ИначеЕсли СтрСравнить(Слово, "Нападающие") = 0 Тогда
			сИгрок.Амплуа = СерверныйФункции.Амплуа("Нападающий");
		ИначеЕсли сИгрок.Амплуа = Неопределено Тогда
		
		ИначеЕсли сИгрок.Номер = 0 И ЗначениеЗаполнено(сИгрок.Команда) Тогда
			сИгрок.Номер = Макс(0, СтрокаКакЧисло(Слово));
			сИгрок.Наименование	= "";
			
		ИначеЕсли ПустаяСтрока(сИгрок.Наименование) Тогда
			Если СтрокаСодержитЧисло(Слово) Тогда
				сИгрок.Номер = 0;
			ИначеЕсли СтрНайти(Слово, ".") > 0 Тогда
				сИгрок.Номер = 0;
			ИначеЕсли СтрДлина(Слово) > 3 Тогда
				сИгрок.Наименование = Слово;
			Иначе
				сИгрок.Номер = 0;
			КонецЕсли;

		ИначеЕсли Год(сИгрок.ДатаРождения) < 2 Тогда
			сИгрок.ДатаРождения = СтрокаКакДата(Слово);
			
		ИначеЕсли НЕ ЗначениеЗаполнено(сИгрок.Страна) Тогда
			сИгрок.Страна = СерверныйФункции.СтранаНайти(Слово);
			//
			сИгрок.Игрок = СерверныйФункции.ИгрокНайти(сИгрок.Наименование);
			Если ЗначениеЗаполнено(сИгрок.Игрок) Тогда
				НовыйИгрок = сИгрок.Игрок.ПолучитьОбъект();
				Если ЗначениеЗаполнено(сИгрок.Амплуа) И НовыйИгрок.Амплуа <> сИгрок.Амплуа Тогда
					НовыйИгрок.Амплуа = сИгрок.Амплуа;
				КонецЕсли;
				Если НовыйИгрок.ДатаРождения <> сИгрок.ДатаРождения Тогда
					НовыйИгрок.ДатаРождения = сИгрок.ДатаРождения;
				КонецЕсли;
				Если ЗначениеЗаполнено(сИгрок.Страна) И НовыйИгрок.Страна <> сИгрок.Страна Тогда
					НовыйИгрок.Страна = сИгрок.Страна;
				КонецЕсли;
			Иначе
				НовыйИгрок = Справочники.Игроки.СоздатьЭлемент();
				ЗаполнитьЗначенияСвойств(НовыйИгрок, сИгрок);
				НовыйИгрок.УстановитьНовыйКод();
			КонецЕсли;
			Если НовыйИгрок.Модифицированность() Тогда
				Если НовыйИгрок.ПроверитьЗаполнение() Тогда
					Попытка
						НовыйИгрок.Записать();
						сИгрок.Игрок = НовыйИгрок.Ссылка;
					Исключение
						Прервать;
					КонецПопытки;
				Иначе
					Продолжить;
				КонецЕсли;
			КонецЕсли;
			
			Если ?(ЗначениеЗаполнено(сИгрок.Команда), сИгрок.Команда <> СерверныйФункции.КомандаИгрока(сИгрок.Игрок, сИгрок.Период), Команда = СерверныйФункции.КомандаИгрока(сИгрок.Игрок)) Тогда
				НЗ = РегистрыСведений.ПеремещенияИгроков.СоздатьМенеджерЗаписи();
				ЗаполнитьЗначенияСвойств(НЗ, сИгрок);
				Если НЗ.ПроверитьЗаполнение() Тогда
					Попытка
						НЗ.Записать();
						Итого = Итого + 1;
					Исключение
					КонецПопытки;
				КонецЕсли;
			КонецЕсли;
				
			сИгрок.Номер		= 0;
			сИгрок.ДатаРождения	= Дата(1,1,1);
			сИгрок.Наименование	= "";
			сИгрок.Игрок		= Неопределено;
			сИгрок.Страна		= Неопределено;
		КонецЕсли;
	КонецЦикла;
	//Если Итого > 0 И ПустаяСтрока(Команда.Комментарий) Тогда
	//	оКоманда = Команда.ПолучитьОбъект();
	//	оКоманда.Комментарий = Гиперссылка;
	//	Попытка
	//		оКоманда.Записать();
	//	Исключение КонецПопытки;
	//КонецЕсли;

	Возврат (Итого > 0);
КонецФункции

&НаСервере
Функция ДатаНачалаСезона(Гиперссылка="")
	Слова	= Разделить(Гиперссылка, "/");
	Месяц	= 8;
	Год		= ?(Месяц(ТекущаяДатаСеанса()) < Месяц, Год(ТекущаяДатаСеанса()), Год(ТекущаяДатаСеанса()) - 1);
	Для Каждого Слово Из Слова Цикл
		Если СтрокаКакЧисло(Слово) > 2000 Тогда
			Год = СтрокаКакЧисло(Слово) - 1;
			Прервать;
		КонецЕсли;
	КонецЦикла;
	Возврат Дата(Год, ?(Год = Год(ТекущаяДатаСеанса()), 1, Месяц), 1);
КонецФункции

&НаСервере
Функция УРЛ(Команда)
	Возврат СерверныйФункции.КомментарийКакУРЛ(Команда.Комментарий);
КонецФункции

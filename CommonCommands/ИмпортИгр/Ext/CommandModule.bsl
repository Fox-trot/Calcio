﻿//	https://football.kulichki.net/england/2019/26/index.htm
&НаКлиенте
Процедура ОбработкаКоманды(ПараметрКоманды, ПараметрыВыполненияКоманды)
	УРЛ = УРЛ(ПараметрКоманды);
	Если ВвестиСтроку(УРЛ, "Импорт игр") И ЗначениеЗаполнено(УРЛ) Тогда
		Если ИмпортИгр(ПараметрКоманды, УРЛ) Тогда
			Оповестить("СписокМатчиОбновить", ПараметрКоманды, ПолучитьФорму("Документ.Матч.ФормаСписка"));
			//Оповестить(, ПараметрКоманды, ПолучитьФорму("Документ.Матч.ФормаОбъекта"));
		КонецЕсли;
	КонецЕсли;
КонецПроцедуры

&НаСервере
Функция УРЛ(Тур)
	Возврат "https://football.kulichki.net/england/" + Формат(Год(Тур.Владелец.ДатаОкончания), "ЧГ=0") + "/" + Строка(Тур.Код) + "/index.htm";
КонецФункции

&НаСервере
Функция ИмпортИгр(Тур, Гиперссылка)
	Итого	= 0;
	Текст	= СерверныйФункции.СкачатьПоСсылке(Гиперссылка);
	Если НЕ ПустаяСтрока(Текст) Тогда
		ВидСпорта	= СерверныйФункции.ВидСпорта(Тур);
		
		Контрол = Новый ФорматированныйДокумент;
		Контрол.УстановитьHTML(Текст, Новый Структура);
		
		Начало	= Контрол.НайтиТекст("тур.");
		Конец	= Контрол.НайтиТекст("Туры:");
		Если Начало = Неопределено Тогда
			Возврат Ложь;
		ИначеЕсли Конец = Неопределено Тогда
			мЭлементы = Контрол.СформироватьЭлементы(Начало.ЗакладкаКонца);
		Иначе
			мЭлементы = Контрол.СформироватьЭлементы(Начало.ЗакладкаНачала, Конец.ЗакладкаНачала);
		КонецЕсли;
		
		ШалостьУдалась	= Ложь;
		сИгра	= Новый Структура("Тур,Дата,Счет,Гол1,Гол2,КоличествоЗрителей,Комментарий,Команда1,Команда2,Стадион", Тур, Дата(1,1,1), "", 0, 0, 0, "");
		Для Каждого тЭлемент Из мЭлементы Цикл
			Попытка
				Слово = СокрЛП(тЭлемент.Текст);
			Исключение
				Продолжить;
			КонецПопытки;
			
			Если ШалостьУдалась Тогда
				Если ПустаяСтрока(Слово) Тогда
					
				ИначеЕсли Слово = "-" Тогда
					
				ИначеЕсли Год(сИгра.Дата) < 2 Тогда
					сИгра.Дата = Строка2Дата(Слово, Тур.ДатаНачала);
					
				ИначеЕсли ПустаяСтрока(сИгра.Команда1) Тогда
					Попытка
						сИгра.Команда1 = СерверныйФункции.КомандаНайти(Слово, ВидСпорта);
					Исключение
					КонецПопытки;
				
				ИначеЕсли ПустаяСтрока(сИгра.Команда2) Тогда
					Попытка
						сИгра.Команда2 = СерверныйФункции.КомандаНайти(Слово, ВидСпорта);
					Исключение
					КонецПопытки;
					
				ИначеЕсли СтрЧислоВхождений(Слово, ":") > 0
				Или СтрНайти(ВРег(Слово), "ОТМ") > 0
				Тогда
					Если СтрЧислоВхождений(Слово, ":") > 0 Тогда
						сИгра.Гол1		= СтрокаКакЧисло(Лев(Слово, СтрНайти(Слово, ":") - 1));
						сИгра.Гол2		= СтрокаКакЧисло(Сред(Слово, СтрНайти(Слово, ":") + 1));
					КонецЕсли;
					
					Ссылка = СерверныйФункции.МатчНайти(сИгра.Команда1, Тур);
					Если ЗначениеЗаполнено(Ссылка) Тогда
						Док = Ссылка.ПолучитьОбъект();
						Если Док.ПометкаУдаления Тогда
							Док.УстановитьПометкуУдаления(Ложь);
						КонецЕсли;
						Док.Команды.Очистить();
						//Док.СоставыКоманд.Очистить();
					Иначе
						Док = Документы.Матч.СоздатьДокумент();
					КонецЕсли;
					ЗаполнитьЗначенияСвойств(Док, сИгра);
					Если СтрНайти(ВРег(Слово), "ОТМ") > 0
					Или сИгра.Гол1 + сИгра.Гол2 > 12
					Тогда
						тСтрока = Док.Команды.Добавить();
						тСтрока.Команда			= сИгра.Команда1;
						тСтрока = Док.Команды.Добавить();
						тСтрока.Команда			= сИгра.Команда2;
						Попытка
							Док.Записать(?(Док.Проведен, РежимЗаписиДокумента.ОтменаПроведения, РежимЗаписиДокумента.Запись));
						Исключение
							Сообщить(ОписаниеОшибки());
						КонецПопытки;
					Иначе
						Док.Стадион	= СерверныйФункции.Стадион(сИгра.Команда1);
						
						тСтрока = Док.Команды.Добавить();
						тСтрока.Команда			= сИгра.Команда1;
						тСтрока.КоличествоГолов	= сИгра.Гол1;
						тСтрока = Док.Команды.Добавить();
						тСтрока.Команда			= сИгра.Команда2;
						тСтрока.КоличествоГолов	= сИгра.Гол2;
						Попытка
							Док.Записать(РежимЗаписиДокумента.Проведение);
						Исключение
							Сообщить(ОписаниеОшибки());
						КонецПопытки;
					КонецЕсли;
					Итого = Итого + 1;
					
					сИгра.Дата		= Дата(1,1,1);
					сИгра.Счет		= "";
					сИгра.Команда1	= Неопределено;
					сИгра.Команда2	= Неопределено;
				КонецЕсли;
			ИначеЕсли Прав(Слово, 4) = "тур." Тогда
				ШалостьУдалась = Истина;
			КонецЕсли;
		КонецЦикла;
	КонецЕсли;
	Возврат (Итого > 0);
КонецФункции

Функция Строка2Дата(Слово, Знач ДатаНачала)
	Ответ = Дата(1,1,1);
	Если СтрНайти("123456789", Лев(Слово, 1)) > 0 Тогда
		Попытка
			ДД = СтрокаКакЧисло(Лев(Слово, СтрНайти(Слово, " ") - 1));
			Если ДД > 0 И ДД < 32 Тогда
				Пока День(ДатаНачала) <> ДД Цикл
					ДатаНачала = ДатаНачала + Сутки();
				КонецЦикла;
				Ответ = ДатаНачала;
			КонецЕсли;
		Исключение
		КонецПопытки;
	КонецЕсли;
	Возврат Ответ;
КонецФункции

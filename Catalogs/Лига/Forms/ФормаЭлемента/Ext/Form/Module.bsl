﻿
&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	Если Объект.Ссылка.Пустая() Тогда
		//
	Иначе
		Если Объект.Ссылка.Изображение.Получить() = Неопределено Тогда
			//Изображение	= ИзображениеДефолтПолучить();
		Иначе
			Изображение	= ПолучитьНавигационнуюСсылку(Объект.Ссылка, "Изображение");
		КонецЕсли;
		Если ЕстьИстория() Тогда
			Элементы.Владелец.ТолькоПросмотр	= Истина;
		КонецЕсли;
	КонецЕсли;
КонецПроцедуры

&НаСервере
Функция ЕстьИстория()
	Возврат СерверныйФункции.ЕстьИстория(Объект.Ссылка);
КонецФункции

&НаКлиенте
Процедура ВыбратьИзображение(Команда)
	Если СтрСравнить(Команда.Имя, "ВыбратьИзображение") = 0 Тогда
		НачатьПомещениеФайлаНаСервер(Новый ОписаниеОповещения("ОбработатьВыборФайла", ЭтотОбъект));
	ИначеЕсли Команда.Имя = "УдалитьИзображение" Тогда
		Изображение = ИзображениеДефолтПолучить();
		//ОбновитьОтображениеДанных();
	КонецЕсли;
КонецПроцедуры

&НаСервере
Функция ИзображениеДефолтПолучить()
	Возврат СерверныйФункции.ИзображениеДефолтПолучить();
КонецФункции

&НаКлиенте
Процедура ОбработатьВыборФайла(Результат, ДополнительныеПараметры) Экспорт
	Если ТипЗнч(Результат) = Тип("ОписаниеПомещенногоФайла") Тогда
		Если ОбщегоНазначения.РасширениеФайлаВерно(Результат.СсылкаНаФайл.Расширение) Тогда
			Изображение = Результат.Адрес;
		Иначе
			ОбщегоНазначения.СообщитьОбОшибке("Данные тип файла не поддерживается");
		КонецЕсли;
	КонецЕсли;
КонецПроцедуры

&НаСервере
Процедура ПередЗаписьюНаСервереИзображение(Объект, Знач Адрес="", Отказ=Ложь) Экспорт
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
Процедура СтранаПриИзменении(Элемент)
	ДоступОбновить();
КонецПроцедуры

&НаСервере
Процедура ДоступОбновить()
	Элементы.ГруппаУЕФА.Доступность = ЗначениеЗаполнено(Объект.Страна);
КонецПроцедуры

&НаКлиенте
Процедура ПриОткрытии(Отказ)
	ДоступОбновить();
КонецПроцедуры

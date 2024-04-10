﻿
&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	Изображение	= СерверныйФункции.ИзображениеПолучить(Объект.Ссылка);
КонецПроцедуры

&НаКлиенте
Процедура ВыбратьИзображение(Команда)
	Если СтрСравнить(Команда.Имя, "ВыбратьИзображение") = 0 Тогда
		НачатьПомещениеФайлаНаСервер(Новый ОписаниеОповещения("ОбработатьВыборФайла", ЭтотОбъект));
	ИначеЕсли СтрСравнить(Команда.Имя, "УдалитьИзображение") = 0 Тогда
		Изображение = ИзображениеДефолтПолучить();
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
	ИначеЕсли ТипЗнч(Результат) = Тип("Строка") И НЕ ПустаяСтрока(Результат) Тогда
		Изображение			= ПоместитьВоВременноеХранилище(Новый Картинка(Результат), УникальныйИдентификатор);
		Модифицированность	= Истина;
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
Процедура ДатаРожденияПриИзменении(Элемент=Неопределено)
	Возраст = Возраст(Объект.ДатаРождения);
КонецПроцедуры

&НаКлиенте
Процедура ПриОткрытии(Отказ)
	ДатаРожденияПриИзменении();
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

&НаКлиенте
Процедура ПослеЗаписи(ПараметрыЗаписи)
	Оповестить("Игрок", Объект.Ссылка);
КонецПроцедуры

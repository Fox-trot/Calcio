﻿	
Функция ПараметрыДиалога() Экспорт
	ПараметрыДиалога = Новый ПараметрыДиалогаПомещенияФайлов;
	ПараметрыДиалога.Заголовок	= "Выберите изображение";
	//ПараметрыДиалога.МножественныйВыбор	= 
	ПараметрыДиалога.Фильтр		= "Изображения|*.JPG;*.JPEG;*.JP2;*.JPG2;*.PNG;*.BMP;*.SVG;*.TIFF;*.WMF";
	Возврат ПараметрыДиалога;
КонецФункции

Процедура ПоНавигационнойСсылкеПерейти(НавигационнаяСсылка) Экспорт
	Попытка
		ПерейтиПоНавигационнойСсылке(НавигационнаяСсылка);
	Исключение
		Сообщить(ОписаниеОшибки());
	КонецПопытки;
КонецПроцедуры

Процедура Показать(Данные, СтандартнаяОбработка=Ложь) Экспорт
	СтандартнаяОбработка = Ложь;
	Если Данные <> Неопределено Тогда
		Попытка
			ПоказатьЗначение(, Данные);
		Исключение
		КонецПопытки;
	КонецЕсли;
КонецПроцедуры

Процедура КаталогаФайловУстановить() Экспорт
	ОткрытьФорму("ОбщаяФорма.КаталогаФайловУстановить");
КонецПроцедуры

Процедура ОбработкаКомандыОткрытьФорму(ИмяФормы, ПараметрКоманды, ПараметрыВыполненияКоманды) Экспорт
	ОткрытьФорму(ИмяФормы, ПараметрКоманды, ПараметрыВыполненияКоманды.Источник, ПараметрыВыполненияКоманды.Уникальность, ПараметрыВыполненияКоманды.Окно, ПараметрыВыполненияКоманды.НавигационнаяСсылка);
КонецПроцедуры

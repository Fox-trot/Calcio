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

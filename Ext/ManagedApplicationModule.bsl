﻿
Процедура ПриНачалеРаботыСистемы()
	Старье	= НастройкиВосстановить();
	ОповещенияПользователя = СобытияНаСегодня();
	Для Каждого Событие Из ОповещенияПользователя Цикл
		Если Старье.Найти(Событие.Ссылка) = Неопределено Тогда
			ПоказатьОповещениеПользователя(Событие.Ссылка, ПолучитьНавигационнуюСсылку(Событие.Ссылка), Событие.Дата, Событие.Картинка, СтатусОповещенияПользователя.Важное, ПолучитьНавигационнуюСсылку(Событие.Ссылка));
			Старье.Добавить(Событие.Ссылка);
		КонецЕсли;
	КонецЦикла;
	НастройкиСохранить(Старье);
КонецПроцедуры

Функция СобытияНаСегодня()
	Возврат СерверныйФункции.СобытияНаСегодня();
КонецФункции

Процедура НастройкиСохранить(Значение)
	СерверныйФункции.НастройкиСохранить(Значение);
КонецПроцедуры

Функция НастройкиВосстановить()
	Возврат СерверныйФункции.НастройкиВосстановить();
КонецФункции

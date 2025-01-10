﻿
Процедура ПриНачалеРаботыСистемы()
	Если ОповещенияНаСегодня() Тогда
		ПодключитьОбработчикОжидания("ОповещенияПользователя", Часов());
	КонецЕсли;
КонецПроцедуры

Функция ОповещенияНаСегодня(ТолькоМатчи=Ложь)
	Ответ	= Ложь;
	События	= СерверныйФункции.ОповещенияНаСегодня(ТолькоМатчи);
	Для Каждого Событие Из События Цикл
		ПоказатьОповещениеПользователя(Событие.Ссылка, Событие.Ключ, Событие.Дата, Событие.Картинка, СтатусОповещенияПользователя.Важное, Событие.КлючУникальности);
		Если Событие.Повторить Тогда
			Ответ	= Истина;
		КонецЕсли;
	КонецЦикла;
	Возврат Ответ;
КонецФункции

Процедура ОповещенияПользователя() Экспорт
	ОповещенияНаСегодня(Истина);
КонецПроцедуры

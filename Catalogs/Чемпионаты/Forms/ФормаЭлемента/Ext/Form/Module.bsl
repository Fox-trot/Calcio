﻿
&НаКлиенте
Процедура КомандыПередНачаломДобавления(Элемент, Отказ, Копирование, Родитель, Группа, Параметр)
	Если Объект.Команды.Количество() = СерверныйФункции.ЛигаКоличествоКоманд(Объект.Владелец) Тогда
		Отказ = Истина;
	КонецЕсли;
КонецПроцедуры

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	Если Объект.Ссылка.Пустая() Тогда
		//
	ИначеЕсли ЕстьИстория(Объект.Ссылка) Тогда
		Элементы.Владелец.ТолькоПросмотр	= Истина;
		//Элементы.Страна.Доступность		= Ложь;
	КонецЕсли;
КонецПроцедуры

&НаСервереБезКонтекста
Функция ЕстьИстория(Ссылка, Команда=Неопределено)
	Возврат СерверныйФункции.ЕстьИстория(Ссылка, Команда);
КонецФункции

&НаКлиенте
Процедура КомандыПередУдалением(Элемент, Отказ)
	Если ЕстьИстория(Объект.Ссылка, Элемент.ТекущиеДанные.Команда) Тогда
		Отказ = Истина;
	КонецЕсли;
КонецПроцедуры

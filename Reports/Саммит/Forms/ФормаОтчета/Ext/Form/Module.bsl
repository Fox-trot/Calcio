﻿
&НаСервере
Процедура СформироватьНаСервере()
	Если ЗначениеЗаполнено(Отчет.Чемпионат) Тогда
		Результат = РеквизитФормыВЗначение("Отчет").ОтчетСформировать();
	КонецЕсли;
КонецПроцедуры

&НаКлиенте
Процедура Сформировать(Команда=Неопределено)
	Если ПроверитьЗаполнение() Тогда
		СформироватьНаСервере();
	КонецЕсли;
КонецПроцедуры

&НаКлиенте
Процедура ПриОткрытии(Отказ)
	Сформировать();
КонецПроцедуры

&НаКлиенте
Процедура ЧемпионатПриИзменении(Элемент)
	СформироватьНаСервере();
КонецПроцедуры

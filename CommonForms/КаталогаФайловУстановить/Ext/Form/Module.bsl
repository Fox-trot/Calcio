﻿
&НаКлиенте
Процедура ПриОткрытии(Отказ)
	НачатьПолучениеКаталогаВременныхФайлов(Новый ОписаниеОповещения("КаталогаФайловУстановить", ЭтотОбъект));
КонецПроцедуры

&НаКлиенте
Процедура КаталогаФайловУстановить(ИмяКаталогаВременныхФайлов, ДополнительныеПараметры=Неопределено) Экспорт
	КаталогаФайловУстановитьНаСервере(ИмяКаталогаВременныхФайлов);
	Закрыть();
КонецПроцедуры

&НаСервере
Процедура КаталогаФайловУстановитьНаСервере(ИмяКаталогаВременныхФайлов)
	ПараметрыСеанса.КаталогаФайлов	= ИмяКаталогаВременныхФайлов;
КонецПроцедуры

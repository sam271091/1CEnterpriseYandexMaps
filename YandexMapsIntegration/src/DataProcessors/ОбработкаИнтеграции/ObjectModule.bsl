#Область ПрограммныйИнтерфейс
// Получить результат поиска мест.
// 
// Параметры:
//  ТекстПоиска - Строка - Текст поиска
// 
// Возвращаемое значение:
//  Структура - Получить результат поиска мест
Функция ПолучитьРезультатПоискаМест(ТекстПоиска = "") Экспорт
	Результат = МодульИнтеграцииВызовСервера.ПолучитьМеста(ТекстПоиска);//Структура

	Возврат Результат;

КонецФункции



// Получить данные места.
// 
// Параметры:
//  Место - Строка - Место
// 
// Возвращаемое значение:
//  Структура, Произвольный - Получить данные места
Функция ПолучитьДанныеМеста(Место = "") Экспорт
	Результат = МодульИнтеграцииВызовСервера.ПолучитьКоординатыМеста(Место);//Структура

	Возврат Результат;

КонецФункции



// Получить адрес.
// 
// Параметры:
//  Наименование - Строка - Наименование
//  Долгота - Строка - Долгота
//  Широта - Строка - Широта
// 
// Возвращаемое значение:
//  СправочникСсылка.Адреса - Получить адрес
Функция ПолучитьАдрес(Наименование="",Долгота="",Широта="") Экспорт
	
	Адрес = Справочники.Адреса.НайтиПоНаименованию(СокрЛП(Наименование), Истина);
	
	Если Не ЗначениеЗаполнено(Адрес)  Тогда
		ОбъектАдрес = Справочники.Адреса.СоздатьЭлемент();
		ОбъектАдрес.Наименование = СокрЛП(Наименование);
		ОбъектАдрес.ПолноеНаименование = СокрЛП(Наименование);
		ОбъектАдрес.Долгота = Число(Долгота);
		ОбъектАдрес.Широта  = Число(Широта);
		ОбъектАдрес.Записать();
		Возврат ОбъектАдрес.Ссылка;
	КонецЕсли;
	
	Возврат Адрес;
	
КонецФункции


#КонецОбласти
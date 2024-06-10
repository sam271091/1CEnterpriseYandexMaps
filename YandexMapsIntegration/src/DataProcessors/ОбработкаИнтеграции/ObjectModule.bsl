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
//  uri - Строка - uri
// 
// Возвращаемое значение:
//  Структура, Произвольный - Получить данные места
Функция ПолучитьДанныеМеста(uri = "") Экспорт
		
	Результат = МодульИнтеграцииВызовСервера.ПолучитьКоординатыМеста(uri);//Структура

	Возврат Результат;

КонецФункции



// Получить адрес.
// 
// Параметры: Наименование - Строка - Наименование
//  ПолученныеДанные - Структура:
//  * Uri - Строка
//  *Адрес - Строка
//  *Представление - Строка
//  Долгота - Строка - Долгота
//  Широта - Строка - Широта
// 
// Возвращаемое значение:
//  СправочникСсылка.Адреса - Получить адрес
Функция ПолучитьАдрес(ПолученныеДанные, Долгота = "", Широта = "") Экспорт

	Адрес = Справочники.Адреса.НайтиПоРеквизиту("Uri", СокрЛП(ПолученныеДанные.Uri));

	Если Не ЗначениеЗаполнено(Адрес) Тогда
		ОбъектАдрес = Справочники.Адреса.СоздатьЭлемент();
		ОбъектАдрес.Наименование = СокрЛП(ПолученныеДанные.Представление);
		ОбъектАдрес.ПолноеНаименование = СокрЛП(ПолученныеДанные.Представление);
		ОбъектАдрес.Адрес = ПолученныеДанные.Адрес;
		ОбъектАдрес.Uri = ПолученныеДанные.Uri;
		ОбъектАдрес.Долгота = Число(Долгота);
		ОбъектАдрес.Широта  = Число(Широта);
		ОбъектАдрес.Записать();
		Возврат ОбъектАдрес.Ссылка;
	КонецЕсли;

	Возврат Адрес;

КонецФункции

// Получить текст шаблона.
// 
// Возвращаемое значение:
//  Строка - Получить текст шаблона
Функция ПолучитьТекстШаблона() Экспорт

	ApiKey = Константы.YandexAPIKEY.Получить();


    МакетHTML = ПолучитьМакет("ШаблонКарты");
    ТекстHTML = МакетHTML.ПолучитьТекст();
	ТекстHTML = СтрЗаменить(ТекстHTML,"%apikey%",ApiKey);

	Возврат ТекстHTML;

КонецФункции
#КонецОбласти
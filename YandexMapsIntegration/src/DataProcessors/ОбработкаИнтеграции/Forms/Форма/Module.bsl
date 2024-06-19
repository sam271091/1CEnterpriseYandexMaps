&НаКлиенте
Процедура СтрокаПоискаПриИзменении(Элемент)
	УдалитьМеткиНаКарте();
	ЗавершитьВыборИзМеню(СтрокаПоиска, Неопределено);
	Элементы.СтрокаПоиска.СписокВыбора.Очистить();
	УстановитьСоответсвиеВРеквизит(Новый Соответствие);
	Элементы.СтрокаПоиска.ОбновитьТекстРедактирования();
КонецПроцедуры


&НаКлиенте
Процедура СтрокаПоискаАвтоПодбор(Элемент, Текст, ДанныеВыбора, ПараметрыПолученияДанных, Ожидание, СтандартнаяОбработка)
	НачалоПоиска(Текст);
КонецПроцедуры
&НаКлиенте
Процедура ПолеHTMLПриНажатии(Элемент, ДанныеСобытия, СтандартнаяОбработка)
	ЭлементНажатия = ДанныеСобытия.Element;
	Если ЭлементНажатия.id = "interactionButton" Тогда
		MyData = Элементы.ПолеHTML.Документ.defaultView.exchangeData;
		ОписаниеОповещения = Новый ОписаниеОповещения("ПолучитьОтвет", ЭтотОбъект, MyData);
		ПоказатьВопрос(ОписаниеОповещения, "Сздать адрес?", РежимДиалогаВопрос.ДаНет);
	КонецЕсли;
КонецПроцедуры

&НаКлиенте
Процедура ПолучитьОтвет(Параметры, ДопПараметр) Экспорт
	Если Параметры = КодВозвратаДиалога.Да Тогда
		ДанныеМетки = МодульИнтеграцииВызовСервера.ПолучитьДанныеИзJSON(ДопПараметр);

		ФормаНовогоАдреса = ПолучитьФорму("Справочник.Адреса.ФормаОбъекта");
		ДанныеФормы = ФормаНовогоАдреса.Объект;
		Координаты = ПолучитьКоординатыТочки(Новый Структура("Долгота,Широта", ДанныеМетки.lng, ДанныеМетки.lat));
		ОбработатьДанныеНаСервере(ДанныеФормы, Координаты);

		КопироватьДанныеФормы(ДанныеФормы, ФормаНовогоАдреса.Объект);

		ФормаНовогоАдреса.Модифицированность = Истина;
		ФормаНовогоАдреса.Открыть();
	КонецЕсли;
КонецПроцедуры
&НаСервереБезКонтекста
Процедура ОбработатьДанныеНаСервере(ДанныеФормы, Координаты)

	НовыйАдрес = ДанныеФормыВЗначение(ДанныеФормы, Тип("СправочникОбъект.Адреса"));
	НовыйАдрес.Долгота = Координаты.Долгота;
	НовыйАдрес.Широта = Координаты.Широта;

	ЗначениеВДанныеФормы(НовыйАдрес, ДанныеФормы);

КонецПроцедуры

&НаКлиенте
Процедура ЗавершитьВыборИзМеню(ВыбранноеЗначение, Параметры) Экспорт

	Соответствие = ПолучитьСоответствиеИзРеквизита();

	Если ВыбранноеЗначение <> Неопределено Тогда
		ПолученныеДанные = Соответствие.Получить(ВыбранноеЗначение);

		Если ПолученныеДанные <> Неопределено Тогда
			СтрокаПоиска = ПолученныеДанные.Представление;

			ПолучитьДанныеМеста(ПолученныеДанные);
			ПодключитьОбработчикОжидания("ВывестиДанныеТС", 0.5, Истина);
		КонецЕсли;
	Иначе
		СтрокаПоиска = "";
	КонецЕсли;
КонецПроцедуры

&НаКлиенте
Процедура КомандаОбновитьКарту(Команда)
	ВывестиДанныеТС();
КонецПроцедуры

&НаКлиенте
Процедура НачалоПоиска(Текст)
	Если СтрДлина(Текст) > 3 Тогда
		НачалоПоискаНаСервере(Текст);
	КонецЕсли;
КонецПроцедуры
&НаСервере
Процедура ПолучитьДанныеМеста(ПолученныеДанные)
	ОбъектОбработки = РеквизитФормыВЗначение("Объект");
	РезультатПоиска = ОбъектОбработки.ПолучитьДанныеМеста(ПолученныеДанные.uri);

	Если РезультатПоиска.Свойство("response") И РезультатПоиска.response.Свойство("GeoObjectCollection")
		И РезультатПоиска.response.GeoObjectCollection.featureMember.Количество() > 0 Тогда

		Точка = РезультатПоиска.response.GeoObjectCollection.featureMember[0].GeoObject.Point.pos;

		СимволРазделителя = СтрНайти(Точка, " ");

		Долгота = СокрЛП(Лев(Точка, СимволРазделителя));

		Широта  = СокрЛП(Сред(Точка, СимволРазделителя));

		Адрес  = ОбъектОбработки.ПолучитьАдрес(ПолученныеДанные, Долгота, Широта);

		Если ВыбранныеАдреса.НайтиПоЗначению(Адрес) = Неопределено Тогда
			ВыбранныеАдреса.Добавить(Адрес);
			ОбновитьZoom = Истина;
		КонецЕсли;

	КонецЕсли;

	Элементы.СтрокаПоиска.СписокВыбора.Очистить();
	УстановитьСоответсвиеВРеквизит(Новый Соответствие);
КонецПроцедуры

&НаКлиенте
Процедура ВывестиДанныеТС() Экспорт
	МассивТС = ПолучитьМассивТС();

	Элементы.ПолеHTML.Документ.defaultView.removeAllPoints();

	Для Каждого ДанныеТС Из МассивТС Цикл		
		ОтобразитьТочкуНаКарте(ДанныеТС);
	КонецЦикла;

	ПодключитьОбработчикОжидания("ВывестиДанныеТС", 5, Истина);
КонецПроцедуры
&НаСервере
Функция ПолучитьМассивТС()
	МассивВыбранныхАдресов = ВыбранныеАдреса.ВыгрузитьЗначения();

	Запрос = Новый Запрос("ВЫБРАТЬ
						  |	КоординатыТранспортныхСредствСрезПоследних.ТранспортноеСредство КАК Сущность,
						  |	КоординатыТранспортныхСредствСрезПоследних.Долгота,
						  |	КоординатыТранспортныхСредствСрезПоследних.Широта,
						  |	ТранспортныеСредства.Автомобиль,
						  |	ТранспортныеСредства.Водитель,
						  |	ТранспортныеСредства.Категория,
						  |	ТранспортныеСредства.СубКатегория,
						  |	ТранспортныеСредства.КоличествоЗаказов,
						  |	ИСТИНА КАК ЭтоТС
						  |ИЗ
						  |	РегистрСведений.КоординатыТранспортныхСредств.СрезПоследних КАК КоординатыТранспортныхСредствСрезПоследних
						  |		ЛЕВОЕ СОЕДИНЕНИЕ Справочник.ТранспортныеСредства КАК ТранспортныеСредства
						  |		ПО КоординатыТранспортныхСредствСрезПоследних.ТранспортноеСредство = ТранспортныеСредства.Ссылка
						  |
						  |ОБЪЕДИНИТЬ ВСЕ
						  |
						  |ВЫБРАТЬ
						  |	Адреса.Ссылка,
						  |	Адреса.Долгота,
						  |	Адреса.Широта,
						  |	NULL,
						  |	NULL,
						  |	NULL,
						  |	NULL,
						  |	NULL,
						  |	ЛОЖЬ
						  |ИЗ
						  |	Справочник.Адреса КАК Адреса
						  |ГДЕ
						  |	Адреса.Ссылка В (&МассивВыбранныхАдресов)");

	Запрос.УстановитьПараметр("МассивВыбранныхАдресов", МассивВыбранныхАдресов);
	Выборка = Запрос.Выполнить().Выбрать();

	МассивТС = Новый Массив;

    


	Пока Выборка.Следующий() Цикл
		СтруктураДанных = Новый Структура("Водитель,Автомобиль,Категория,СубКатегория,КоличествоЗаказов,Долгота,Широта,ЭтоТС,Сущность");
		СтруктураДанных.Водитель = Выборка.Водитель;
		СтруктураДанных.Автомобиль = Выборка.Автомобиль;
		СтруктураДанных.Категория = Выборка.Категория;
		СтруктураДанных.СубКатегория = Выборка.СубКатегория;
		СтруктураДанных.КоличествоЗаказов = Выборка.КоличествоЗаказов;
		СтруктураДанных.Долгота = Выборка.Долгота;
		СтруктураДанных.Широта = Выборка.Широта;
		СтруктураДанных.Сущность = Выборка.Сущность;
		СтруктураДанных.ЭтоТС = Выборка.ЭтоТС;

		МассивТС.Добавить(СтруктураДанных);
	КонецЦикла;

	Возврат МассивТС;

КонецФункции
&НаКлиенте
Процедура ОтобразитьТочкуНаКарте(ДанныеТС)

	Координаты = ПолучитьКоординатыТочки(ДанныеТС);

	Подсказка = СформиоватьПодсказку(ДанныеТС);

    ОбновитьZoomНаКарте = Ложь;
    Если ДанныеТС.Сущность = Адрес И ОбновитьZoom Тогда
        ОбновитьZoom = Ложь;
        ОбновитьZoomНаКарте = Истина;    	
    КонецЕсли;

	Элементы.ПолеHTML.Документ.defaultView.setPoints(Координаты.Широта, Координаты.Долгота, Подсказка,ОбновитьZoomНаКарте);
	
	
КонецПроцедуры

&НаКлиенте
Функция СформиоватьПодсказку(ДанныеТС)

	Если Не ДанныеТС.ЭтоТС Тогда
		Возврат Строка(ДанныеТС.Сущность);
	КонецЕсли;

	ШаблонПодсказки = "Sürücü:%1
					  |Avtomobil:%2
					  |Kateqoriya:%3
					  |Subkateqoriya:%4
					  |Üstündə olan sifariş:%5";

	Возврат СтрШаблон(ШаблонПодсказки, ДанныеТС.Водитель, ДанныеТС.Автомобиль, ДанныеТС.Категория, ДанныеТС.СубКатегория,
		Формат(ДанныеТС.КоличествоЗаказов, "ЧЦ=10;"));

КонецФункции

&НаКлиенте
Процедура ПриОткрытии(Отказ)
	ПодключитьОбработчикОжидания("ВывестиДанныеТС", 5, Истина);
КонецПроцедуры
&НаСервере
Функция ПолучитьКоординатыТочки(ДанныеТС)
	Структура = Новый Структура;
	Структура.Вставить("Широта", Формат(ДанныеТС.Широта, "ЧРД=.;"));
	Структура.Вставить("Долгота", Формат(ДанныеТС.Долгота, "ЧРД=.;"));

	Возврат Структура;
КонецФункции
&НаСервере
Функция ПолучитьСоответствиеИзРеквизита()
	Возврат Объект.ПредложенныйСписок;
КонецФункции

&НаСервере
Процедура УстановитьСоответсвиеВРеквизит(НовоеСоответсвие)
	Объект.ПредложенныйСписок = Новый ФиксированноеСоответствие(НовоеСоответсвие);
КонецПроцедуры
&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	УстановитьСоответсвиеВРеквизит(Новый Соответствие);
	Если Не ЗначениеЗаполнено(Константы.MappableAPIKey.Получить()) Тогда
		Сообщить("Заполните API KEY (Mappble)!");
		Элементы.СтрокаПоиска.Доступность = Ложь;
	КонецЕсли;
	Если Не ЗначениеЗаполнено(Константы.YandexAPIKEY.Получить()) Тогда
		Сообщить("Заполните API KEY (Yandex)!");
		Элементы.ПолеHTML.Доступность = Ложь;
	Иначе
		ИнициализироватьКарту();
	КонецЕсли;

КонецПроцедуры
&НаСервере
Процедура ИнициализироватьКарту()
	ОбъектОбработки = РеквизитФормыВЗначение("Объект");
	ПолеHTML = ОбъектОбработки.ПолучитьТекстШаблона();
КонецПроцедуры
&НаСервере
Процедура НачалоПоискаНаСервере(Текст)
	Элементы.СтрокаПоиска.СписокВыбора.Очистить();
	УстановитьСоответсвиеВРеквизит(Новый Соответствие);

	ОбъектОбработки = РеквизитФормыВЗначение("Объект");
	РезультатПоиска = ОбъектОбработки.ПолучитьРезультатПоискаМест(Текст );

	СоответсвиеДанных = Новый Соответствие;

	Если РезультатПоиска.Свойство("results") Тогда
		Для Каждого Элемент Из РезультатПоиска.results Цикл
			ПредставлениеАдреса = "";
			Если Элемент.address.Свойство("component") Тогда
				Для Каждого ЧастьАдреса Из Элемент.address.component Цикл
					ПредставлениеАдреса = ПредставлениеАдреса + ?(ПредставлениеАдреса = "", "", ",") + ЧастьАдреса.name;
				КонецЦикла;
			КонецЕсли;
			Элементы.СтрокаПоиска.СписокВыбора.Добавить(Элемент.Uri, Элемент.title.text + " (" + ПредставлениеАдреса
				+ ")");

			СтруктураДанных = Новый Структура("Адрес,Uri,Представление");
			СтруктураДанных.Адрес = ПредставлениеАдреса;
			СтруктураДанных.Uri = Элемент.Uri;
			СтруктураДанных.Представление = Элемент.title.text;

			СоответсвиеДанных.Вставить(Элемент.Uri, СтруктураДанных);
		КонецЦикла;

	КонецЕсли;

	УстановитьСоответсвиеВРеквизит(СоответсвиеДанных);

КонецПроцедуры

&НаКлиенте
Процедура СтрокаПоискаОчистка(Элемент, СтандартнаяОбработка)
	УдалитьМеткиНаКарте();
КонецПроцедуры

&НаКлиенте
Процедура УдалитьМеткиНаКарте()
    Адрес = Неопределено;
	ВыбранныеАдреса.Очистить();
	ПодключитьОбработчикОжидания("ВывестиДанныеТС", 0.5, Истина);
КонецПроцедуры

--Лабораторная работа №5 – СУБД – 4 часа

--Программирование T-SQL.
--Разработать T-SQL-скрипт  следующего содержания: 
--объявить переменные типа: char, varchar, datetime, time, int, smallint,  tinint, numeric(12, 5).
--первые две переменные проинициализировать в операторе объявления.
--присвоить  произвольные значения следующим двум переменным с помощью оператора SET, 
--одной из  этих переменных  присвоить значение, полученное в результате запроса SELECT.
--одну из переменных оставить без инициализации и не присваивать ей значения, 
--оставшимся переменным присвоить некоторые значения с помощью оператора SELECT;. 
--значения половины переменных вывести с помощью оператора SELECT, 
--значения другой половины переменных распечатать с помощью оператора PRINT. 

DECLARE @char char(15)='Привет';
DECLARE @varchar varchar(15)='Лабораторная 5';
SELECT @char char, @varchar varchar;
GO

DECLARE @date date;
SET @date='01/01/2021';
SELECT @date date;
GO

DECLARE @time time;
SET @time='11:11:11';
SELECT @time time;
GO

DECLARE @int int;
SELECT @int=5;
PRINT @int;
GO

DECLARE @smallint smallint;
PRINT @smallint;
GO

DECLARE @tinyint tinyint;
SELECT @tinyint=1;
PRINT @tinyint;
GO

DECLARE @numeric numeric(12, 5);
SELECT @numeric=3.14;
PRINT @numeric;
GO

--Разработать скрипт, в котором определяется средняя стоимость продукта.
--Если средняя стоимость продукта превышает 10, то вывести количество продуктов, среднюю стоимость продукта, максимальную стоимость продукта. 
--Если средняя стоимость продукта меньше 10, то вывести минимальную стоимость продукта. 
DECLARE @AVG_PRICE_PRODUCT numeric(8,3), 
        @COUNT_PRICE_PRODUCT numeric(8,3),
		@MAX_PRICE_PRODUCT numeric(8,3),
		@MIN_PRICE_PRODUCT numeric(8,3);
SELECT @AVG_PRICE_PRODUCT= (SELECT CAST(AVG(PRICE) as numeric(8,3)) FROM PRODUCTS);
SELECT @COUNT_PRICE_PRODUCT= (SELECT CAST(COUNT(PRICE) as numeric(8,3)) FROM PRODUCTS);
SELECT @MAX_PRICE_PRODUCT= (SELECT CAST(MAX(PRICE) as numeric(8,3)) FROM PRODUCTS);
SELECT @MIN_PRICE_PRODUCT= (SELECT CAST(MIN(PRICE) as numeric(8,3)) FROM PRODUCTS);

IF @AVG_PRICE_PRODUCT>10  -- =889
     SELECT @COUNT_PRICE_PRODUCT 'COUNT_PRICE_PRODUCT',
	        @AVG_PRICE_PRODUCT 'AVG_PRICE_PRODUCT', 
			@MAX_PRICE_PRODUCT 'MAX_PRICE_PRODUCT'
ELSE SELECT @MIN_PRICE_PRODUCT 'MIN_PRICE_PRODUCT';
GO

--Подсчитать количество заказов сотрудника в определенный период.
DECLARE @begin_year char(4) = '2007';
DECLARE @finish_year char(4) = '2008';
DECLARE @ORDERS_IN_PERIOD INT=
(SELECT SUM(QTY) FROM ORDERS WHERE YEAR(ORDER_DATE) BETWEEN @begin_year AND @finish_year);
SELECT @ORDERS_IN_PERIOD 'ORDERS_IN_PERIOD';
GO
--SELECT*FROM ORDERS

--Разработать T-SQL-скрипты, выполняющие: 
--преобразование имени сотрудника в инициалы.
SELECT SUBSTRING(NAME, 1, 1) NAME FROM SALESREPS;
SELECT PATINDEX('% %', NAME) FROM SALESREPS;--возвращаю индекс первой буквы фамилии
--результат последнего запроса будет второй парамерт функции SUBSTRING

SELECT SUBSTRING(CITY, 1, 4) l4, SUBSTRING(CITY, 4, 4) r4 FROM OFFICES;
-- SUBSTRING() вырезает из строки подстроку определенной длины
-- начиная с определенного индекса
-- Первый параметр функции - строка
-- второй - начальный индекс
-- третий - количество вырезаемых символов

SELECT CITY, PATINDEX('%a%n%', CITY) Str_Pos FROM OFFICES;
-- PATINDEX() возвращает индекс, по которому находится
-- первое вхождение определенного шаблона в строке

SELECT CITY, CHARINDEX('an', CITY) Str_Pos FROM OFFICES;
-- CHARINDEX() возвращает индекс, по которому находится первое вхождение подстроки в строке
-- В качестве первого параметра передается подстрока поиска,
-- в качестве второго параметра - строка, в которой надо вести поиск


--поиск сотрудников, у которых дата найма в следующем месяце.
SELECT NAME, HIRE_DATE FROM SALESREPS
WHERE MONTH(HIRE_DATE) = MONTH(GETDATE()) + 1;
GO

--поиск сотрудников, которые проработали более 10 лет.
SELECT NAME, HIRE_DATE FROM SALESREPS
WHERE (YEAR(GETDATE())-YEAR(HIRE_DATE))>10;
GO

--поиск дня недели, в который делались заказы.
SELECT DATENAME(weekday, GETDATE());

SELECT ORDER_DATE, DATENAME(weekday, ORDER_DATE)  FROM ORDERS

--Продемонстрировать применение оператора IF… ELSE.
--пример выше
DECLARE @X int = 7;
IF @x > 10 PRINT 'x > 10'
 ELSE PRINT 'x < 10';
GO

--Продемонстрировать применение оператора CASE.
SELECT PRODUCT_ID,
	CASE 
		WHEN PRICE BETWEEN 0 AND 100 THEN 'Категоия 0-100'
		WHEN PRICE BETWEEN 100 AND 1000 THEN 'Категоия 100-1000'
		WHEN PRICE BETWEEN 1000 AND 10000 THEN 'Категоия 1000-10000'
		ELSE 'Категоия свыше 10000'
	END
FROM PRODUCTS;
 
--Продемонстрировать применение оператора RETURN.
PRINT 'Привет';
RETURN;              -- выход из пакета
PRINT 'не выполнится'; -- не выполнится
GO
PRINT 'Пока';

--Разработать скрипт с ошибками, в котором используются для обработки ошибок блоки TRY и CATCH. 
--Применить функции ERROR_NUMBER (код последней ошибки), 
--ERROR_MESSAGE (сообщение об ошибке), 
--ERROR_LINE(код последней ошибки), 
--ERROR_PROCEDURE (имя  процедуры или NULL), 
--ERROR_SEVERITY (уровень серьезности ошибки), 
--ERROR_ STATE (метка ошибки). 
DECLARE @X int;
BEGIN TRY
 SET @X = 'NELLO'; -- ERR
END TRY
BEGIN CATCH
 PRINT (CAST(ERROR_NUMBER() AS VARCHAR(100)) +'-код последней ошибки')
 PRINT (CAST(ERROR_MESSAGE() AS VARCHAR(100)) + '-сообщение об ошибке') 
 PRINT (CAST(ERROR_LINE() AS VARCHAR(100)) + '-код последней ошибки')
 PRINT (CAST(ERROR_PROCEDURE() AS VARCHAR(100)) + '-имя  процедуры или NULL') 
 PRINT (CAST(ERROR_SEVERITY() AS VARCHAR(100)) + '-уровень серьезности ошибки') 
 PRINT (CAST(ERROR_STATE() AS VARCHAR(100)) + '-метка ошибки')
END CATCH
GO

--Создать локальную временную таблицу из трех столбцов. Добавить данные (10 строк) 
--с использованием оператора WHILE. Вывести ее содержимое.
CREATE TABLE #T2 (ФАМИЛИЯ VARCHAR(20), ИМЯ VARCHAR(20), ОТЧЕСТВО VARCHAR(20));

DECLARE @X INT = 1;
WHILE (@X<=10)
BEGIN
INSERT INTO #T2(ФАМИЛИЯ, ИМЯ, ОТЧЕСТВО) VALUES ('D', 'D', 'D');
SET @X = @x+1;
END
GO

SELECT*FROM #T2;
DROP TABLE #T2;
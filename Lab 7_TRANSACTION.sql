--Лабораторная работа №7 – СУБД – 2 часа

--Транзакции в T-SQL.
--1. Разработать скрипт, демонстрирующий работу в режиме неявной транзакции.
--SELECT*FROM OFFICES
SET IMPLICIT_TRANSACTIONS ON; --запускаем неявную транзакцию
INSERT OFFICES VALUES (100, 'TEST 1', 'Eastern',null,10000.00,100.00);
COMMIT;

SELECT*FROM OFFICES;
DELETE FROM OFFICES WHERE OFFICE=100;


--2. Разработать скрипт, демонстрирующий свойства ACID явной транзакции. 
--В блоке CATCH предусмотреть выдачу соответствующих сообщений об ошибках.
--XACT_STATE это функция, которая возвращает пользователю состояние запущенной транзакции
--согласованность, атомарность
SELECT*FROM CUSTOMERS;


insert into customers values(1000,'JCP Inc.',103,90);
begin try
begin transaction
	delete CUSTOMERS WHERE CUST_NUM=1000;
end try
begin catch
	if (xact_state()) = -1
	begin 
		print 'Транзакция не завершена'
		rollback transaction;
	end;
	if (xact_state()) = 1
	begin 
		print 'Транзакция завершена'
		commit transaction;
	end;
end catch;

--3. Разработать скрипт, демонстрирующий применение оператора SAVETRAN. 
--В блоке CATCH предусмотреть выдачу соответствующих сообщений об ошибках.
SELECT*FROM OFFICES;

BEGIN TRY
BEGIN TRANSACTION
   INSERT INTO OFFICES VALUES (100, 'TEST 3A', 'Eastern', null, 10000.00, 100.00);
   SAVE TRANSACTION A;

   INSERT INTO OFFICES VALUES (200, 'TEST 3B', 'Eastern', null, 10000.00, 100.00);
   SAVE TRANSACTION B;

   INSERT INTO OFFICES VALUES (300, 'TEST 3C', 'Eastern', null, 10000.00, 100.00);
   ROLLBACK TRANSACTION B;

   INSERT INTO OFFICES VALUES (400, 'TEST 3D', 'Eastern', null, 10000.00, 100.00);
   ROLLBACK TRANSACTION A;
END TRY
BEGIN CATCH
  IF (xact_state()) = -1
  BEGIN
     PRINT 'Транзакция не завершена'
	 ROLLBACK TRANSACTION
  END;
  BEGIN
     PRINT 'Транзакция завершена'
	 COMMIT TRANSACTION
  END;
END CATCH;

SELECT*FROM OFFICES;
DELETE FROM OFFICES WHERE CITY='TEST 3A';

--4. Разработать два скрипта A и B. Продемонстрировать неподтвержденное, 
--неповторяющееся и фантомное чтение. Показать усиление уровней изолированности.
CREATE TABLE TEST_ISOLATION_LEVEL
(NAME CHAR(10), AGE INT, LOCATION CHAR(20))
INSERT INTO TEST_ISOLATION_LEVEL VALUES ('TANYA',32,'MINSK');
INSERT INTO TEST_ISOLATION_LEVEL VALUES ('VIKA',33,'WARSHAVA');
INSERT INTO TEST_ISOLATION_LEVEL VALUES ('DIMA',35,'RIGA');

SELECT*FROM TEST_ISOLATION_LEVEL;
DELETE FROM TEST_ISOLATION_LEVEL WHERE AGE=37;
drop table TEST_ISOLATION_LEVEL
----- Покажем, что уровень изолированности READ UNCOMMITTED допускает неподтвержденное чтение

-- 1
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
BEGIN TRAN
SELECT COUNT(*) FROM TEST_ISOLATION_LEVEL -- запускаем транзакцию, Результат: 3
--  3
SELECT COUNT(*) FROM TEST_ISOLATION_LEVEL
-- Результат: , налицо неподтвержденное чтение
 
-- 5
SELECT COUNT(*) FROM TEST_ISOLATION_LEVEL -- Результат: , после отката транзакции В
COMMIT TRAN

----- Покажем, что уровень изолированности READ COMMITTED не допускает неподтвержденное чтение

-- 6
SET TRANSACTION ISOLATION LEVEL READ COMMITTED
BEGIN TRAN
SELECT COUNT(*) FROM TEST_ISOLATION_LEVEL -- запускаем транзакцию, Результат: 
 
--  8
SELECT COUNT(*) FROM TEST_ISOLATION_LEVEL -- Результат: ожидание, неподтвержденного чтения нет
 
-- 10
SELECT COUNT(*) FROM TEST_ISOLATION_LEVEL -- сразу после отката транзакции В Результат: , 
COMMIT TRAN

----- Покажем, что уровень изолированности READ COMMITTED  допускает неповторяющееся чтение

-- 11
SET TRANSACTION ISOLATION LEVEL READ COMMITTED
BEGIN TRAN
SELECT COUNT(*) FROM TEST_ISOLATION_LEVEL -- Результат: 
 
-- 13
SELECT COUNT(*) FROM TEST_ISOLATION_LEVEL -- Результат: 
-- пока вторая транзакция удаляла запись, данные дважды прочитались по-разному.
COMMIT TRAN


----- Покажем, что уровень изолированности REPEATABLE READ  допускает проблему фантомных записей
INSERT INTO TEST_ISOLATION_LEVEL VALUES ('DIMA',35,'RIGA'); -- вернем запись
-- 18
SET TRANSACTION ISOLATION LEVEL REPEATABLE READ 
BEGIN TRAN
SELECT COUNT(*) FROM TEST_ISOLATION_LEVEL -- Результат: 
 
-- 20
SELECT COUNT(*) FROM TEST_ISOLATION_LEVEL -- Результат: 
--- в рамках одной транзакции А два результата
COMMIT TRAN


--5. Разработать скрипт, демонстрирующий свойства вложенных транзакций. 
BEGIN TRANSACTION ONETRAN;
INSERT OFFICES VALUES (200, 'TEST 5A', 'TEST',null,20000.00,200.00);
    BEGIN TRANSACTION TWOTRAN;
    UPDATE OFFICES SET CITY='TEST 5B' WHERE REGION ='TEST';
	COMMIT TRANSACTION TWOTRAN;
COMMIT TRANSACTION ONETRAN;

--SELECT*FROM OFFICES;
DELETE FROM OFFICES WHERE CITY='TEST 5B';
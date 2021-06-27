--- 2
BEGIN TRAN  -- открываем параллельную транзакцию
DELETE FROM TEST_ISOLATION_LEVEL WHERE AGE=35 -- удаляем строку из таблицы

--- 4
ROLLBACK TRAN -- откатываем транзакцию

--- 7
BEGIN TRAN  -- открываем параллельную транзакцию
DELETE FROM TEST_ISOLATION_LEVEL WHERE AGE=35 -- удаляем строку из таблицы

--- 9
ROLLBACK TRAN -- откатываем транзакцию 

--- 12
BEGIN TRAN  -- открываем параллельную транзакцию
DELETE FROM TEST_ISOLATION_LEVEL WHERE AGE=35 -- удаляем строку из таблицы
COMMIT TRAN

--- 19
BEGIN TRAN
INSERT INTO TEST_ISOLATION_LEVEL VALUES ('EVGENIY',37,'BREST');-- Строк обработано:1
COMMIT TRAN -- завершаем транзакцию


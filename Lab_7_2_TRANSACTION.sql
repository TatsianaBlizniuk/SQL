--- 2
BEGIN TRAN  -- ��������� ������������ ����������
DELETE FROM TEST_ISOLATION_LEVEL WHERE AGE=35 -- ������� ������ �� �������

--- 4
ROLLBACK TRAN -- ���������� ����������

--- 7
BEGIN TRAN  -- ��������� ������������ ����������
DELETE FROM TEST_ISOLATION_LEVEL WHERE AGE=35 -- ������� ������ �� �������

--- 9
ROLLBACK TRAN -- ���������� ���������� 

--- 12
BEGIN TRAN  -- ��������� ������������ ����������
DELETE FROM TEST_ISOLATION_LEVEL WHERE AGE=35 -- ������� ������ �� �������
COMMIT TRAN

--- 19
BEGIN TRAN
INSERT INTO TEST_ISOLATION_LEVEL VALUES ('EVGENIY',37,'BREST');-- ����� ����������:1
COMMIT TRAN -- ��������� ����������


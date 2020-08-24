USE Northwind;

-- �ε��� ���ٹ�� (Access)
-- Index Scan vs Index Seek

CREATE TABLE TestAccess
(
	id INT NOT NULL,
	name NCHAR(50) NOT NULL,
	dummy NCHAR(1000) NULL
);
GO

CREATE CLUSTERED INDEX TestAccess_CI
ON TestAccess(id);
GO

CREATE NONCLUSTERED INDEX TestAccess_NCI
ON TestAccess(name);
GO

DECLARE @i INT;
SET @i = 1;

WHILE (@i <= 500)
BEGIN
	INSERT INTO TestAccess
	VALUES (@i, 'Name' + CONVERT(VARCHAR, @i), 'Hello World' + CONVERT(VARCHAR, @i));
	SET @i = @i + 1;
END

-- �ε��� ����
EXEC sp_helpindex 'TestAccess';
-- �ε��� ��ȣ
SELECT index_id, name
FROM sys.indexes
WHERE object_id = object_id('TestAccess')
-- ��ȸ
DBCC IND('NorthWind', 'TestAccess', 1);
DBCC IND('NorthWind', 'TestAccess', 2);


-- ���� �б� -> ���� �����͸� ã�� ���� ���� ������ ��
SET STATISTICS TIME ON;
SET STATISTICS IO ON;

-- INDEX SCAN : LEAF PAGE ���������� �˻�
SELECT *
FROM TestAccess;

-- INDEX SEEK
SELECT *
FROM TestAccess
WHERE id = 104;

-- INDEX SEEK + KEY LOOKUP (Ŭ�����͵� �ε����� ���� ���, ��Ŭ�����͵�� Ŭ�����͵��� �ּҸ� �������)
SELECT *
FROM TestAccess
WHERE name = 'name5';

-- INDEX SCAN + KEY LOOKUP
SELECT TOP 5 *
FROM TestAccess
ORDER BY name;
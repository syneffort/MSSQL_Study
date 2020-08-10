USE Northwind;

-- DB ���� ���캸��
EXEC sp_helpdb 'Northwind';

-- �ӽ� ���̺� ����� (�ε��� �׽�Ʈ ��)
CREATE TABLE Test
(
	EmployeeID INT NOT NULL,
	LastName NVARCHAR(20) NULL,
	FristName NVARCHAR(20) NULL,
	HireDate DATETIME NULL
);
GO

INSERT INTO Test
SELECT EmployeeID, LastName, FirstName, HireDate
FROM Employees;

SELECT *
FROM Test;

-- FILLFACTOR (���� ������ ���� 1%�� ���)
-- PAD_INDEX (FILLFACTOR �߰� ������ ����)
CREATE INDEX Test_Index ON Test(LastName)
WITH (FILLFACTOR = 1, PAD_INDEX = ON)
GO

-- �ε��� ��ȣ ã��
SELECT index_id, name
FROM sys.indexes
WHERE object_id = object_id('Test');

-- �ε��� ���� ���캸��
DBCC IND('Northwind', 'Test', 2);

-- Root(2) -> Branch(1) -> Leaf(0) => ����Ʈ��

-- HEAP RID([������ �ּ�(4)][����ID(2)][���Թ�ȣ(2)] ������ ROW �ĺ���. ���̺��� ���� ����)
DBCC PAGE('Northwind', 1/*���Ϲ�ȣ*/, 840/*��������ȣ*/, 3/*��¿ɼ�*/);
DBCC PAGE('Northwind', 1/*���Ϲ�ȣ*/, 848/*��������ȣ*/, 3/*��¿ɼ�*/);
DBCC PAGE('Northwind', 1/*���Ϲ�ȣ*/, 849/*��������ȣ*/, 3/*��¿ɼ�*/);

DBCC PAGE('Northwind', 1/*���Ϲ�ȣ*/, 856/*��������ȣ*/, 3/*��¿ɼ�*/);
DBCC PAGE('Northwind', 1/*���Ϲ�ȣ*/, 880/*��������ȣ*/, 3/*��¿ɼ�*/);

DBCC PAGE('Northwind', 1/*���Ϲ�ȣ*/, 857/*��������ȣ*/, 3/*��¿ɼ�*/);

-- Random Access (�� �� �б� ���� �� ������ �� ����)
-- Bookmark Lookup (RID�� ���� ���� ã��)
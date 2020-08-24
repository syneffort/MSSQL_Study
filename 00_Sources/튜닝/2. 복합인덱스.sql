USE Northwind;

-- �ֹ� �� ������ ���캸��
SELECT *
FROM [Order Details]
ORDER BY OrderID;

-- �ӽ� �׽�Ʈ ���̺��� �ۼ��ϰ� �����͸� ����
SELECT *
INTO TestOrderDetails
FROM [Order Details];

SELECT *
FROM TestOrderDetails;

-- ���� �ε��� �߰�
CREATE INDEX Index_TestOrderDetails
ON TestOrderDetails(OrderID, ProductID);

-- �ε��� ���� ���캸��
EXEC sp_helpindex 'TestOrderDetails';

-- INDEX SCAN => ���� Ž�� (Ǯ��ĵ)
-- INDEX SEEK => ���� Ž��

-- �ε��� ���� �׽�Ʈ 1
SELECT *
FROM TestOrderDetails
WHERE OrderID = 10248 AND ProductID = 11;

-- �ε��� ���� �׽�Ʈ 2
SELECT *
FROM TestOrderDetails
WHERE ProductID = 11 AND OrderID = 10248;

-- �ε��� ���� �׽�Ʈ 3
SELECT *
FROM TestOrderDetails
WHERE OrderID = 10248;

-- �ε��� ���� �׽�Ʈ 4
SELECT *
FROM TestOrderDetails
WHERE ProductID = 11;
-- > �����ε����� ó�� �Է��� �ʵ尡 �켱 �������� �۵���

-- INDEX ����
DBCC IND('Northwind', 'TestOrderDetails', 2);
DBCC PAGE('Northwind', 1, 832,3);

-- ���� �ε���(A, B)�� ������̶�� �ε��� (A) ��� ����
-- ������ B�ε� �˻��� �ʿ��ϴٸ� �ε���(B)�� ������ �������־����

-- �ε����� �����Ͱ� CUD �Ǿ �����Ǿ�� ��
-- ������ 50�� ���� �Է��غ���.
-- ���� ���� 10248-11, �� 10387-24
DECLARE @i INT = 0;
WHILE @i < 50
BEGIN
	INSERT INTO TestOrderDetails
	VALUES (10248, 100 + @i, 10, 1, 0)
	SET @i = @i + 1
END

-- �ε��� ����
DBCC IND('Northwind', 'TestOrderDetails', 2);
DBCC PAGE('Northwind', 1, 832,3);
DBCC PAGE('Northwind', 1, 833,3);

-- ��� : ������ ���������� ���� ��� ������ ������ �߻���

-- ���� �׽�Ʈ
SELECT LastName
INTO TestEmployees
FROM Employees;

SELECT *
FROM TestEmployees;

-- �ε��� �߰�
CREATE INDEX Index_TestEmplyees
ON TestEmployees(LastName);

-- INDEX SCAN -> BAD
-- �ε��� ������ �����ؾ���
SELECT *
FROM TestEmployees
WHERE SUBSTRING(LastName, 1, 2) = 'Bu';

-- INDEX SEEK -> GOOD
SELECT *
FROM TestEmployees
WHERE LastName LIKE 'Bu%';
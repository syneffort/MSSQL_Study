USE Northwind;
-- ���� �ε��� �÷� ����
-- Index(A, B, C)

-- �ϸ�ũ ���
-- Leaf Page Ž���� ������ ������
-- [����, ����] �ε��� ���� (56���� �޸�) Ž���� ������ �ϳ��� ������ ���ϱ⿡ �ϸ�ũ ����� ���ӵ�

-- ������ (56~60���� �޸�)���� ��ȸ�Ѵٸ�?

SELECT *
INTO TestOrders
FROM Orders;

DECLARE @i INT = 1;
DECLARE @emp INT;
SELECT @emp = MAX(EmployeeID) FROM Orders;

-- ���� ������ �뷮 ���� (830 * 1000)

WHILE (@i < 1000)
BEGIN
	INSERT INTO TestOrders(CustomerID, EmployeeID, OrderDate)
	SELECT CustomerID, @emp + @i, OrderDate
	FROM Orders;
	SET @i = @i + 1;
END

SELECT COUNT(*)
FROM TestOrders;

CREATE NONCLUSTERED INDEX idx_emp_ord
ON TestOrders(EmployeeID, OrderDate);

CREATE NONCLUSTERED INDEX idx_ord_emp
ON TestOrders(OrderDate, EmployeeId);

SET STATISTICS TIME ON;
SET STATISTICS IO ON;

-- �ΰ��� ��ȸ ��

SELECT *
FROM TestOrders WITH(INDEX(idx_emp_ord))
WHERE EmployeeID = 1 AND OrderDate = CONVERT(DATETIME, '19970101');

SELECT *
FROM TestOrders WITH(INDEX(idx_ord_emp))
WHERE EmployeeID = 1 AND OrderDate = CONVERT(DATETIME, '19970101');

-- ���� ���캸��
-- ��ȸ �ӵ� �� ����� ���� �����ϴ�.
--> Eqaul ���ǿ� ���� ��ȸ�� ������ �ε����� ������ ���� ��ȸ �ӵ�/��� ������ ���� ����
SELECT *
FROM TestOrders
ORDER BY EmployeeID, OrderDate;

SELECT *
FROM TestOrders
ORDER BY OrderDate, EmployeeID;

-- ���� �������� ã�´ٸ�?
-- ������ �о������� ��ȸ �ӵ� ���̰� Ŀ��
SELECT *
FROM TestOrders WITH(INDEX(idx_emp_ord))
WHERE EmployeeID = 1 AND OrderDate BETWEEN '19970101' AND '19970103';
--OrderDate >= '19970101' AND OrderDate <='19970103'

SELECT *
FROM TestOrders WITH(INDEX(idx_ord_emp))
WHERE EmployeeID = 1 AND OrderDate BETWEEN '19970101' AND '19970103';

-- ���� ���캸��
--> Eqaul �������� ������ ���� �� ��� ������ ũ�� ��ȸ �ӵ� ���̰� ���� ���� (���� ��ü Ȯ������ ���� �ӵ� ���� ����)
--> ������ �־��� �������� ������ ���� �� ��� ���� ��ü�� ���� ������ ������ ��ĵ�ؾ��ϱ� ������ �ӵ� ����
SELECT *
FROM TestOrders
ORDER BY EmployeeID, OrderDate;

SELECT *
FROM TestOrders
ORDER BY OrderDate, EmployeeID;

-- ���� �ε����� �����Ǿ� ���� ��, ���� ���ǿ� BETWEEN ����� ��� ���� ������ �ε��� ����� ���� �����
-- BETWEEN ������ �ִ��� ���࿡ ��ġ�ؾ� ��
-- �׷� BETWEEN ���� �񱳰� �ʿ��� ��� �ε��� ������ �ٲپ����� �ɱ�?
--> NO! �ε��� ���� �������� ���� �ٸ� ��ȸ�� ������ �ݵ�� ����ؾ���

-- BETWEEN ������ ���� �� -> IN-LIST�� ��ü�ϴ� ���� ��� (��ǻ� �ټ��� �񱳿����� ����)
SET STATISTICS PROFILE ON;

SELECT *
FROM TestOrders WITH(INDEX(idx_ord_emp))
WHERE EmployeeID = 1 AND OrderDate IN('19970101','19970102', '19970103');

-- ���

-- ���� �ø� �ε��� (����, ����) ������ ������ �� �� ����
-- BETWEEN, �ε�ȣ ������ ���࿡ ���� ������ �ε����� ����� �����
-- ���� �ε��� BETWEEN�� ������ ���� ��� IN-LIST�� ��ü�ϸ� ��ȸ �ӵ� ������ ������ �� �� �ִ�
-- �� �ݴ��� ��쿡�� ������ ��ȸ �ӵ� ���� ���ϰ� �߻��� �� ������ ����!
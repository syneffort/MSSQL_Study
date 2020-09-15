USE Northwind;

-- Hash Join

SELECT * INTO TestOrders FROM Orders;
SELECT * INTO TestCustomer FROM Customers;

SELECT * FROM TestOrders; -- 830 row
SELECT * FROM TestCustomer; -- 91 row

-- NL (������ : Inner ���̺� �ε����� ��� ��� ��ĵ�ϰԵ�)
SELECT *
FROM TestOrders AS o
	INNER JOIN TestCustomer AS c
	ON o.CustomerID = c.CustomerID
	OPTION (FORCE ORDER, LOOP JOIN);

-- MERGE (������ : ���� ���̺� �ε����� ��� Sort �� Outer ���̺� �ε��� ���ϼ� ������ ��� Many-to-Many ���� ó����)
SELECT *
FROM TestOrders AS o
	INNER JOIN TestCustomer AS c
	ON o.CustomerID = c.CustomerID
	OPTION (FORCE ORDER, MERGE JOIN);

-- HASH
-- �ؽ����̺��� ���̺� ����� ���� ���� �̿��ؼ� ����Ե�
SELECT *
FROM TestOrders AS o
	INNER JOIN TestCustomer AS c
	ON o.CustomerID = c.CustomerID;

-- ���
-- 1) ������ �ʿ�ġ �ʴ� -> �����Ͱ� �ʹ� ���Ƽ� Merge�� �δ㽺���� ��, Hash�� ����� �� �� ����
-- 2) �ε��� ������ ������ ���� �ʴ´� ***
	-- NL or Merge�� ���� Ȯ���� ����
	-- HashTable�� ����� ����� �����ؼ��� �ȵ� (���� �󵵰� ���ٸ� Index�� ���� �����ϴ°� ����)
-- 3) ���� �׼��� ���ַ� ������� �ʴ´�
-- 4) �����Ͱ� ���� ���� HashTable�� ����°��� �����ϴ�
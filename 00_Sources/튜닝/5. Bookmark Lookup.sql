USE Northwind;

-- �ϸ�ũ ���

-- Index Scan vs Index Seek
-- Index Scan�� �׻� ���۰��� �ƴϰ�,  Index Seek�� �׻� �������� �ƴϴ�.
-- �ε����� ����ϴµ� ��� ���� �� �ִ°��ϱ�?

-- Clusterd�� ��� Index Seek�� ���� �� ����
-- NonClustered�� ���, �����Ͱ� Leaf Page�� ���� ������ �ѹ� �� ������ �ʿ���
	-- 1) RID -> Heap Table (Bookmark Lookup)
	-- 2) Key -> Clustered

SELECT *
INTO TestOrders
FROM Orders;

SELECT *
FROM TestOrders;

CREATE NONCLUSTERED INDEX Orders_Index01
ON TestOrders(CustomerID);

-- �ε��� ��ȣ
SELECT index_id, name
FROM sys.indexes
WHERE object_id = object_id('TestOrders');

-- ��ȸ
DBCC IND('Northwind', 'TestOrders', 2);

--     880
-- 840 848 849
-- Heap Table[ {Page} {Page}]

SET STATISTICS TIME ON;
SET STATISTICS IO ON;
SET STATISTICS PROFILE ON;

-- �⺻ Ž��
SELECT *
FROM TestOrders
WHERE CustomerID = 'QUICK';

-- ������ �ε����� �̿��ϰ� �غ���
SELECT *
FROM TestOrders WITH(INDEX(Orders_Index01))
WHERE CustomerID = 'QUICK';

SELECT *
FROM TestOrders WITH(INDEX(Orders_Index01))
WHERE CustomerID = 'QUICK' AND ShipVia = 3;

DROP INDEX TestOrders.Orders_Index01;

-- ����� ���̱� ���� ���θ�
-- �˻��Ϸ��� �ʵ���� �ټ� ����ִ� �ε��� -> Covered Index
CREATE NONCLUSTERED INDEX Orders_Index01
ON TestOrders(CustomerID, ShipVia);

-- 8ȸ�� ��� ������ ���о��� ���� (�������� 28ȸ ����� ����)
SELECT *
FROM TestOrders WITH(INDEX(Orders_Index01))
WHERE CustomerID = 'QUICK' AND ShipVia = 3;

-- Q) Covered Index�� �ټ� �ʵ带 �����ϴ°� ������?
-- A) �� �׷��� �ʴ�. DML (Insert, Update, Delete) ó�� �ӵ��� ������

DROP INDEX TestOrders.Orders_Index01;

-- ����� ���̱� ���� ���θ�
CREATE NONCLUSTERED INDEX Orders_Index01
ON TestOrders(CustomerID) INCLUDE (ShipVia); -- ���� �������� ShipVia ������ ����, ������ �������� �������

-- 8ȸ�� ��� ������ ���о��� ���� (�������� 28ȸ ����� ����)
SELECT *
FROM TestOrders WITH(INDEX(Orders_Index01))
WHERE CustomerID = 'QUICK' AND ShipVia = 3;

-- ���� ���� �����ܿ� ��¿��� ���� ���ٸ�?
-- Clustered Index Ȱ���� ����� �� �ִ�.
-- ������ Clustered Index�� ���̺� �� 1���� ��밡���ϴٴ� ���� ����ؾ��Ѵ�.

--- �� �� ---

-- NonClustered Index�� �ǿ����� �ִ� ���?
	-- �ϸ�ũ ����� �ɰ��� ���ϸ� �߱��� ��
-- ���?
	-- �ɼ�1) Covered Index : �˻��� ��� �ʵ带 �����ϰڴ�
	-- �ɼ�2) Index�� Include�� �̿��� ��Ʈ�� �����
	-- �ɼ�3) Clustered Index : ��, 1���� ����� �� �ִ� �ñر�...
			--> ��� �� NonClustered�� �ǿ����� �� �� ���� (�ٸ� ��Ŭ�����͵��� �˻��� Ŭ�����͵带 ���� �����)
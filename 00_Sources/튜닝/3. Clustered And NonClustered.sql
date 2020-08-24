USE Northwind;

-- �ε��� ����
-- Clustered(����) vs NonClustered(����)

-- Clustered
	-- Leaf page = Data page
	--> Clustered Index Ű ������ ���� ���� ������ ������ �߻���

-- NonClustered
	-- Clustered Index�� ���� �ٸ��� ����
	-- 1) Clustered�� ���� ���
		-- �����ʹ� Heap Table�� ���� (Leaf page�� ���� ����)
		-- Heap RID�� ���� �����̺� �����Ͽ� ������ ����
	-- 2) Clustered�� �ִ� ���
		-- �����ʹ� Leaf Table�� ���� (Heap Table ����)
		-- Clustered Index�� ���� Ű ���� ��� ����

-- �ӽ� ���̺� ���� �� ����
SELECT *
INTO TestOrderDetails
FROM [Order Details]

SELECT *
FROM TestOrderDetails;

-- �ε��� �߰�
CREATE INDEX Index_OrderDetails
ON TestOrderDetails(OrderID, ProductID);

-- �ε��� ����
EXEC sp_helpindex 'TestOrderDetails';
-- �ε��� ��ȣ ã��
SELECT index_id, name
FROM sys.indexes
WHERE object_id = object_id('TestOrderDetails');

-- ��ȸ
DBCC IND('Northwind', 'TestOrderDetails', 2);

-- Heap RID ([�������ּ�(4)][����ID(2)][����(2)]) : Row �ĺ���
DBCC PAGE('Northwind', 1, 832, 3);

-- Clustered Index �߰�
CREATE CLUSTERED INDEX Index_OrderDetails_Clustered
ON TestOrderDetails(OrderID);

-- �ε��� ����
EXEC sp_helpindex 'TestOrderDetails';
-- �ε��� ��ȣ ã��
SELECT index_id, name
FROM sys.indexes
WHERE object_id = object_id('TestOrderDetails');

-- Heap RID �����
DBCC PAGE('Northwind', 1, 928, 3);

-- ��ȸ
DBCC IND('Northwind', 'TestOrderDetails', 1);
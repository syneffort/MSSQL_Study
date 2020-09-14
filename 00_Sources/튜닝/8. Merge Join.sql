USE BaseballData

SET STATISTICS TIME ON;
SET STATISTICS IO ON;
SET STATISTICS PROFILE ON;

-- Non Clustered
--   1
-- 2 3 4

-- Clustered
--   1
-- 2 3 4

-- Heap Table [ {Page} {Page} ]

-- Merge(����) ���� = Sort Merge(���� ����) ����

-- Non Clustered Index�� playerID�� �ɷ��ִٰ� �ص�, Clustered Index�� Leaf �������� �ٽ� �����ϴ� ����� ������ 
SELECT *
FROM players AS	p
	INNER JOIN salaries AS s
	ON p.playerID = s.playerID;

-- Merge ���ε� ������ �ٴ´� (Outer�� Unique �ؾ��� = One-to-Many = PK, Unique �� ����Ǿ����)
-- ������ Random Access ��� -> Clustered Scan �� ������

SELECT *
FROM schools AS s
	INNER JOIN schoolsplayers AS p
	ON s.schoolID = p.schoolID;

-- ���
-- Merge -> Sort Merge Join
-- 1) ���� ������ Sort �ϰ� Merge �Ѵ�
	-- �̹� ���ĵ� ���¶�� Sort�� ����, Ư�� Clustered�� ������ ���ĵ� ���¶�� Best
	-- ������ �����Ͱ� �ʹ� ������ GG -> ��� Hash ����� ���� �� ����
-- 2) Random Access ���ַ� ������� ����
-- 3) Many-to-Many ���ٴ� One-to-Many ���ο� ȿ����
	-- PK, UNIQUE �� �ε����� �������
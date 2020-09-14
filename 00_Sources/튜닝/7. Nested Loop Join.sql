USE BaseballData;

-- ������ ����
	-- 1) Nested Loop (NL) ����
	-- 2) Merge (����) ����
	-- 3) Hash (�ؽ�) ����

-- Merge
SELECT *
FROM players AS p
	INNER JOIN salaries AS s
	ON p.playerID = s.playerID;

-- NL
SELECT TOP 5 *
FROM players AS p
	INNER JOIN salaries AS s
	ON p.playerID = s.playerID;

-- Hash
SELECT *
FROM salaries AS s
	INNER JOIN teams AS t
	ON s.teamID = t.teamID;

-- NL
SELECT *
FROM players AS p
	INNER JOIN salaries AS s
	ON p.playerID = s.playerID
	OPTION(LOOP JOIN);

-- ���� ���� ���� (������, salaries ���̺��� clustered index �켱�Ͽ� ��� ���ϰ� ��)
SELECT *
FROM players AS p
	INNER JOIN salaries AS s
	ON p.playerID = s.playerID
	OPTION(FORCE ORDER, LOOP JOIN);

-- ������ ���
-- NL Ư¡
-- ���� �׼����� OUTER ���̺��� �ο츦 ���ʴ�� ��ĵ -> INNER ���̺� ���� �׼���
-- INNER ���̺� �ε����� ���ٸ� ���
-- �κй��� ó���� ���� (ex. Top 5 ...)
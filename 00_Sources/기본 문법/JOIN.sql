USE GameDB;

-- JOIN (����)

CREATE TABLE testA
(
	a INTEGER
)

CREATE TABLE testB
(
	b VARCHAR(10)
)

INSERT INTO testA VALUES(1);
INSERT INTO testA VALUES(2);
INSERT INTO testA VALUES(3);

INSERT INTO testB VALUES('A');
INSERT INTO testB VALUES('B');
INSERT INTO testB VALUES('C');

SELECT *
FROM testA;

SELECT *
FROM testB;

-- CROSS JOIN (���� ����)
SELECT *
FROM testA
	CROSS JOIN testB;

SELECT *
FROM testA, testB

---------------------------------------------------------

USE BaseballData;

SELECT *
FROM players
ORDER BY playerID;

SELECT *
FROM salaries
ORDER BY playerID;

-- INNER JOIN (�� ���� ���̺��� ���η� ���� + ���� ������ ON����)

SELECT *
FROM players AS p
	INNER JOIN salaries AS s
	ON p.playerID = s.playerID

-- OUTER JOIN (�ܺΰ���)
	-- LEFT / RIGHT
	-- ��� ���ʿ��� �ִ� ������ ó�� ��å

-- LEFT JOIN
SELECT *
FROM players AS p
	LEFT JOIN salaries AS s
	ON p.playerID = s.playerID

-- RIGHT JOIN
SELECT *
FROM players AS p
	RIGHT JOIN salaries AS s
	ON p.playerID = s.playerID
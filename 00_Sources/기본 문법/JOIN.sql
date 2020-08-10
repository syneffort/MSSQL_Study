USE GameDB;

-- JOIN (결합)

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

-- CROSS JOIN (교차 결합)
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

-- INNER JOIN (두 개의 테이블을 가로로 결합 + 결합 기준은 ON으로)

SELECT *
FROM players AS p
	INNER JOIN salaries AS s
	ON p.playerID = s.playerID

-- OUTER JOIN (외부결합)
	-- LEFT / RIGHT
	-- 어느 한쪽에만 있는 데이터 처리 정책

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
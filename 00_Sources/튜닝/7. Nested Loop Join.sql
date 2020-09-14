USE BaseballData;

-- 조인의 원리
	-- 1) Nested Loop (NL) 조인
	-- 2) Merge (병합) 조인
	-- 3) Hash (해시) 조인

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

-- 조인 순서 강제 (느려짐, salaries 테이블의 clustered index 우선하여 사용 못하게 됨)
SELECT *
FROM players AS p
	INNER JOIN salaries AS s
	ON p.playerID = s.playerID
	OPTION(FORCE ORDER, LOOP JOIN);

-- 오늘의 결론
-- NL 특징
-- 먼저 액세스한 OUTER 테이블의 로우를 차례대로 스캔 -> INNER 테이블 랜덤 액세스
-- INNER 테이블에 인덱스가 없다면 노답
-- 부분범위 처리에 좋다 (ex. Top 5 ...)
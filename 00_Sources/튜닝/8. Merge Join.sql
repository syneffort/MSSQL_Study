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

-- Merge(병합) 조인 = Sort Merge(정렬 병합) 조인

-- Non Clustered Index가 playerID에 걸려있다고 해도, Clustered Index의 Leaf 페이지를 다시 정렬하는 방법을 선택함 
SELECT *
FROM players AS	p
	INNER JOIN salaries AS s
	ON p.playerID = s.playerID;

-- Merge 조인도 조건이 붙는다 (Outer가 Unique 해야함 = One-to-Many = PK, Unique 등 보장되어야함)
-- 일일히 Random Access 대신 -> Clustered Scan 후 재정렬

SELECT *
FROM schools AS s
	INNER JOIN schoolsplayers AS p
	ON s.schoolID = p.schoolID;

-- 결론
-- Merge -> Sort Merge Join
-- 1) 양쪽 집합을 Sort 하고 Merge 한다
	-- 이미 정렬된 상태라면 Sort는 생략, 특히 Clustered로 물리적 정렬된 상태라면 Best
	-- 정렬한 데이터가 너무 많으면 GG -> 대신 Hash 사용이 나을 수 있음
-- 2) Random Access 위주로 수행되지 않음
-- 3) Many-to-Many 보다는 One-to-Many 조인에 효과적
	-- PK, UNIQUE 가 인덱스에 있을경우
USE BaseballData;

-- Sorting을 줄이자!
-- 일반적을 O(NLogN) -> 일반적으로 부하가 크지 않음
	--> DB에서 Sorting은 데이터 수가 매우 많아 Sorting 비용이 크다!
	-- 너무 용량이 커서 가용 메모리로 커버가 안되면, 드라이브까지 이용해야한다 (!!)
	-- Sorting이 언제 발생하는지 파악하고 있어야함

-- Sorting이 일어날 때
-- 1) SORT MERGE JOIN
	-- 원인) 알고리즘 특성 상 Merge 전 Sort 필요 (이미 인덱스 Sorting 되어있다면 Sort 생략됨)
-- 2) ORDER BY
-- 3) GROUP BY
-- 4) DISTINCT
-- 5) UNION
-- 6) RANKING WINDOWS FUNCTION
-- 7) MIN MAX

-- 1) 생략..

-- 2) ORDER BY
	-- 원인) 순서대로 정렬 해야 하니까
SELECT *
FROM players
ORDER BY college;

-- 3) GROUP BY
	-- 원인) 집계를 하기 위해 그룹화 과정에서 정렬
SELECT college, COUNT(college)
FROM players
WHERE college LIKE 'C%'
GROUP BY college;

-- 4) DISTINCT
	-- 원인) 중복 제거 처리
SELECT DISTINCT college
FROM players
WHERE college LIKE 'C%'

-- 5) UNION
	-- 원인) 두 집합의 중복 제거 처리
SELECT college
FROM players
WHERE college LIKE 'B%'
UNION
SELECT college
FROM players
WHERE college LIKE 'B%'

-- 5) RANKING WINDOW FUNCTION
SELECT ROW_NUMBER() OVER (ORDER BY college)
FROM players;

-- INDEX를 잘 이용한다면 Sorting을 피할 수 있음

SELECT *
FROM batting
ORDER BY playerID, YearID;

SELECT playerID, COUNT(playerID)
FROM players
WHERE playerID LIKE 'C%'
GROUP BY playerID;

-- DISTINCT, UNION은 중복 제거가 반드시 필요한지 검토해서 Sorting 회피 가능
-- B 시작과 C 시작은 중복이 불가능 --> 중복 확인 필요없음
SELECT college
FROM players
WHERE college LIKE 'B%'
UNION ALL
SELECT college
FROM players
WHERE college LIKE 'B%'
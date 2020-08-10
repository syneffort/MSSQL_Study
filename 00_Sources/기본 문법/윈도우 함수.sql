USE BaseballData

-- 윈도우 함수
-- 행들의 서브 집합을 대상으로, 각 행별로 계산을 해서 스칼라(단일 고정)값을 출력하는 함수

-- GROUPING과 비교 (SUM, COUNT, AVG 집계 함수)
SELECT *
FROM salaries
ORDER BY salary DESC;

SELECT playerID, MAX(salary)
FROM salaries
GROUP BY playerID
ORDER BY MAX(salary) DESC;

-- 헤딩 하면서 배우는 윈도우 함수
-- ~OVER([PARTITION] [ORDER BY] [ROWS])

-- 전체 데이터를 연봉 순서로 나열하고, 순위 표기

SELECT *,
	ROW_NUMBER() OVER (ORDER BY salary DESC), -- 행 번호
	RANK() OVER (ORDER BY salary DESC), -- 랭킹
	DENSE_RANK() OVER (ORDER BY salary DESC), -- 랭킹
	NTILE(100) OVER (ORDER BY salary DESC) -- 상위 백분율
FROM salaries;


-- playerID 별 순위를 따로 처리하고 싶다면?

SELECT *,
	RANK() OVER (PARTITION BY playerID ORDER BY salary DESC)
FROM salaries
ORDER BY playerID;

-- LAG(바로 이전), LEAD(바로 다음)
SELECT *,
	RANK() OVER (PARTITION BY playerID ORDER BY salary DESC),
	LAG(salary) OVER (PARTITION BY playerID ORDER BY salary DESC) AS preSalary,
	LEAD(salary) OVER (PARTITION BY playerID ORDER BY salary DESC) AS nextSalary
FROM salaries
ORDER BY playerID;

-- FIRST_VALUE, LAST_VALUE
-- FRAME : FIRST ~ CURRENT (default로 설정된 범위)
SELECT *,
	RANK() OVER (PARTITION BY playerID ORDER BY salary DESC),
	FIRST_VALUE(salary) OVER (PARTITION BY playerID 
								ORDER BY salary DESC
								ROWS BETWEEN UNBOUNDED PRECEDING AND CURRENT ROW) AS best,
	LAST_VALUE(salary) OVER (PARTITION BY playerID 
								ORDER BY salary DESC
								ROWS BETWEEN CURRENT ROW AND UNBOUNDED FOLLOWING) AS worst
FROM salaries
ORDER BY playerID;
USE BaseballData;

-- 커리어 평균이 3000000 이상인 선수
SELECT playerID, AVG(salary) AS avgSalary
FROM salaries
GROUP BY playerID
HAVING AVG(salary) >= 3000000

-- 12월에 태어난 선수
SELECT playerID, birthMonth
FROM players
WHERE birthMonth = 12

-- [커리어 평균이 3000000 이상] || [12월에 태어난] 선수
-- UNION (중복 제거)
SELECT playerID
FROM salaries
GROUP BY playerID
HAVING AVG(salary) >= 3000000
UNION ALL
SELECT playerID
FROM players
WHERE birthMonth = 12
ORDER BY playerID

-- [커리어 평균이 3000000 이상] && [12월에 태어난] 선수
-- UNION (중복 제거)
SELECT playerID
FROM salaries
GROUP BY playerID
HAVING AVG(salary) >= 3000000
INTERSECT
SELECT playerID
FROM players
WHERE birthMonth = 12
ORDER BY playerID

-- [커리어 평균이 3000000 이상] - [12월에 태어난] 선수
-- UNION (중복 제거)
SELECT playerID
FROM salaries
GROUP BY playerID
HAVING AVG(salary) >= 3000000
EXCEPT
SELECT playerID
FROM players
WHERE birthMonth = 12
ORDER BY playerID
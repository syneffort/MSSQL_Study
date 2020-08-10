USE BaseballData;

-- Ŀ���� ����� 3000000 �̻��� ����
SELECT playerID, AVG(salary) AS avgSalary
FROM salaries
GROUP BY playerID
HAVING AVG(salary) >= 3000000

-- 12���� �¾ ����
SELECT playerID, birthMonth
FROM players
WHERE birthMonth = 12

-- [Ŀ���� ����� 3000000 �̻�] || [12���� �¾] ����
-- UNION (�ߺ� ����)
SELECT playerID
FROM salaries
GROUP BY playerID
HAVING AVG(salary) >= 3000000
UNION ALL
SELECT playerID
FROM players
WHERE birthMonth = 12
ORDER BY playerID

-- [Ŀ���� ����� 3000000 �̻�] && [12���� �¾] ����
-- UNION (�ߺ� ����)
SELECT playerID
FROM salaries
GROUP BY playerID
HAVING AVG(salary) >= 3000000
INTERSECT
SELECT playerID
FROM players
WHERE birthMonth = 12
ORDER BY playerID

-- [Ŀ���� ����� 3000000 �̻�] - [12���� �¾] ����
-- UNION (�ߺ� ����)
SELECT playerID
FROM salaries
GROUP BY playerID
HAVING AVG(salary) >= 3000000
EXCEPT
SELECT playerID
FROM players
WHERE birthMonth = 12
ORDER BY playerID
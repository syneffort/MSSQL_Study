USE BaseballData;

-- Sorting�� ������!
-- �Ϲ����� O(NLogN) -> �Ϲ������� ���ϰ� ũ�� ����
	--> DB���� Sorting�� ������ ���� �ſ� ���� Sorting ����� ũ��!
	-- �ʹ� �뷮�� Ŀ�� ���� �޸𸮷� Ŀ���� �ȵǸ�, ����̺���� �̿��ؾ��Ѵ� (!!)
	-- Sorting�� ���� �߻��ϴ��� �ľ��ϰ� �־����

-- Sorting�� �Ͼ ��
-- 1) SORT MERGE JOIN
	-- ����) �˰��� Ư�� �� Merge �� Sort �ʿ� (�̹� �ε��� Sorting �Ǿ��ִٸ� Sort ������)
-- 2) ORDER BY
-- 3) GROUP BY
-- 4) DISTINCT
-- 5) UNION
-- 6) RANKING WINDOWS FUNCTION
-- 7) MIN MAX

-- 1) ����..

-- 2) ORDER BY
	-- ����) ������� ���� �ؾ� �ϴϱ�
SELECT *
FROM players
ORDER BY college;

-- 3) GROUP BY
	-- ����) ���踦 �ϱ� ���� �׷�ȭ �������� ����
SELECT college, COUNT(college)
FROM players
WHERE college LIKE 'C%'
GROUP BY college;

-- 4) DISTINCT
	-- ����) �ߺ� ���� ó��
SELECT DISTINCT college
FROM players
WHERE college LIKE 'C%'

-- 5) UNION
	-- ����) �� ������ �ߺ� ���� ó��
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

-- INDEX�� �� �̿��Ѵٸ� Sorting�� ���� �� ����

SELECT *
FROM batting
ORDER BY playerID, YearID;

SELECT playerID, COUNT(playerID)
FROM players
WHERE playerID LIKE 'C%'
GROUP BY playerID;

-- DISTINCT, UNION�� �ߺ� ���Ű� �ݵ�� �ʿ����� �����ؼ� Sorting ȸ�� ����
-- B ���۰� C ������ �ߺ��� �Ұ��� --> �ߺ� Ȯ�� �ʿ����
SELECT college
FROM players
WHERE college LIKE 'B%'
UNION ALL
SELECT college
FROM players
WHERE college LIKE 'B%'
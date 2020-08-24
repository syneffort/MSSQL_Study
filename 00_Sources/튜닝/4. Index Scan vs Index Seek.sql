USE Northwind;

-- 인덱스 접근방식 (Access)
-- Index Scan vs Index Seek

CREATE TABLE TestAccess
(
	id INT NOT NULL,
	name NCHAR(50) NOT NULL,
	dummy NCHAR(1000) NULL
);
GO

CREATE CLUSTERED INDEX TestAccess_CI
ON TestAccess(id);
GO

CREATE NONCLUSTERED INDEX TestAccess_NCI
ON TestAccess(name);
GO

DECLARE @i INT;
SET @i = 1;

WHILE (@i <= 500)
BEGIN
	INSERT INTO TestAccess
	VALUES (@i, 'Name' + CONVERT(VARCHAR, @i), 'Hello World' + CONVERT(VARCHAR, @i));
	SET @i = @i + 1;
END

-- 인덱스 정보
EXEC sp_helpindex 'TestAccess';
-- 인덱스 번호
SELECT index_id, name
FROM sys.indexes
WHERE object_id = object_id('TestAccess')
-- 조회
DBCC IND('NorthWind', 'TestAccess', 1);
DBCC IND('NorthWind', 'TestAccess', 2);


-- 논리적 읽기 -> 실제 데이터를 찾기 위해 읽은 페이지 수
SET STATISTICS TIME ON;
SET STATISTICS IO ON;

-- INDEX SCAN : LEAF PAGE 순차적으로 검색
SELECT *
FROM TestAccess;

-- INDEX SEEK
SELECT *
FROM TestAccess
WHERE id = 104;

-- INDEX SEEK + KEY LOOKUP (클러스터드 인덱스가 있을 경우, 논클러스터드는 클러스터드의 주소만 들고있음)
SELECT *
FROM TestAccess
WHERE name = 'name5';

-- INDEX SCAN + KEY LOOKUP
SELECT TOP 5 *
FROM TestAccess
ORDER BY name;
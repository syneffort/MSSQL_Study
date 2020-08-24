USE Northwind;

-- 주문 상세 정보를 살펴보자
SELECT *
FROM [Order Details]
ORDER BY OrderID;

-- 임시 테스트 테이블을 작성하고 데이터를 복사
SELECT *
INTO TestOrderDetails
FROM [Order Details];

SELECT *
FROM TestOrderDetails;

-- 복합 인덱스 추가
CREATE INDEX Index_TestOrderDetails
ON TestOrderDetails(OrderID, ProductID);

-- 인덱스 정보 살펴보기
EXEC sp_helpindex 'TestOrderDetails';

-- INDEX SCAN => 나쁜 탐색 (풀스캔)
-- INDEX SEEK => 좋은 탐색

-- 인덱스 적용 테스트 1
SELECT *
FROM TestOrderDetails
WHERE OrderID = 10248 AND ProductID = 11;

-- 인덱스 적용 테스트 2
SELECT *
FROM TestOrderDetails
WHERE ProductID = 11 AND OrderID = 10248;

-- 인덱스 적용 테스트 3
SELECT *
FROM TestOrderDetails
WHERE OrderID = 10248;

-- 인덱스 적용 테스트 4
SELECT *
FROM TestOrderDetails
WHERE ProductID = 11;
-- > 복합인덱스는 처음 입력한 필드가 우선 조건으로 작동함

-- INDEX 정보
DBCC IND('Northwind', 'TestOrderDetails', 2);
DBCC PAGE('Northwind', 1, 832,3);

-- 따라서 인덱스(A, B)를 사용중이라면 인덱스 (A) 없어도 무방
-- 하지만 B로도 검색이 필요하다면 인덱스(B)는 별도로 설정해주어야함

-- 인덱스는 데이터가 CUD 되어도 유지되어야 함
-- 데이터 50개 강제 입력해보자.
-- 현재 시작 10248-11, 끝 10387-24
DECLARE @i INT = 0;
WHILE @i < 50
BEGIN
	INSERT INTO TestOrderDetails
	VALUES (10248, 100 + @i, 10, 1, 0)
	SET @i = @i + 1
END

-- 인덱스 정보
DBCC IND('Northwind', 'TestOrderDetails', 2);
DBCC PAGE('Northwind', 1, 832,3);
DBCC PAGE('Northwind', 1, 833,3);

-- 결론 : 페이지 여유공간이 없을 경우 페이지 분할이 발생함

-- 가공 테스트
SELECT LastName
INTO TestEmployees
FROM Employees;

SELECT *
FROM TestEmployees;

-- 인덱스 추가
CREATE INDEX Index_TestEmplyees
ON TestEmployees(LastName);

-- INDEX SCAN -> BAD
-- 인덱스 가공은 신중해야함
SELECT *
FROM TestEmployees
WHERE SUBSTRING(LastName, 1, 2) = 'Bu';

-- INDEX SEEK -> GOOD
SELECT *
FROM TestEmployees
WHERE LastName LIKE 'Bu%';
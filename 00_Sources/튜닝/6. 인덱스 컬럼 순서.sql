USE Northwind;
-- 복합 인덱스 컬럼 순서
-- Index(A, B, C)

-- 북마크 룩업
-- Leaf Page 탐색은 여전히 존재함
-- [레벨, 종족] 인덱스 조건 (56레벨 휴먼) 탐색시 데이터 하나만 보장을 못하기에 북마크 룩업이 지속됨

-- 조건을 (56~60레벨 휴먼)으로 조회한다면?

SELECT *
INTO TestOrders
FROM Orders;

DECLARE @i INT = 1;
DECLARE @emp INT;
SELECT @emp = MAX(EmployeeID) FROM Orders;

-- 더미 데이터 대량 생성 (830 * 1000)

WHILE (@i < 1000)
BEGIN
	INSERT INTO TestOrders(CustomerID, EmployeeID, OrderDate)
	SELECT CustomerID, @emp + @i, OrderDate
	FROM Orders;
	SET @i = @i + 1;
END

SELECT COUNT(*)
FROM TestOrders;

CREATE NONCLUSTERED INDEX idx_emp_ord
ON TestOrders(EmployeeID, OrderDate);

CREATE NONCLUSTERED INDEX idx_ord_emp
ON TestOrders(OrderDate, EmployeeId);

SET STATISTICS TIME ON;
SET STATISTICS IO ON;

-- 두가지 조회 비교

SELECT *
FROM TestOrders WITH(INDEX(idx_emp_ord))
WHERE EmployeeID = 1 AND OrderDate = CONVERT(DATETIME, '19970101');

SELECT *
FROM TestOrders WITH(INDEX(idx_ord_emp))
WHERE EmployeeID = 1 AND OrderDate = CONVERT(DATETIME, '19970101');

-- 직접 살펴보자
-- 조회 속도 및 방식이 거의 동일하다.
--> Eqaul 조건에 대한 조회는 설정된 인덱스의 순서에 의해 조회 속도/방식 영향이 거의 없다
SELECT *
FROM TestOrders
ORDER BY EmployeeID, OrderDate;

SELECT *
FROM TestOrders
ORDER BY OrderDate, EmployeeID;

-- 범위 조건으로 찾는다면?
-- 범위가 넓어질수록 조회 속도 차이가 커짐
SELECT *
FROM TestOrders WITH(INDEX(idx_emp_ord))
WHERE EmployeeID = 1 AND OrderDate BETWEEN '19970101' AND '19970103';
--OrderDate >= '19970101' AND OrderDate <='19970103'

SELECT *
FROM TestOrders WITH(INDEX(idx_ord_emp))
WHERE EmployeeID = 1 AND OrderDate BETWEEN '19970101' AND '19970103';

-- 직접 살펴보자
--> Eqaul 조건으로 정렬이 먼저 된 경우 기존과 크게 조회 속도 차이가 나지 않음 (범위 전체 확인으로 인한 속도 영향 있음)
--> 범위로 주어진 조건으로 정렬이 먼저 된 경우 범위 전체에 대한 나머지 조건을 스캔해야하기 때문에 속도 느림
SELECT *
FROM TestOrders
ORDER BY EmployeeID, OrderDate;

SELECT *
FROM TestOrders
ORDER BY OrderDate, EmployeeID;

-- 복합 인덱스로 구성되어 있을 때, 선행 조건에 BETWEEN 사용할 경우 후행 조건은 인덱스 기능을 거의 상실함
-- BETWEEN 조건은 최대한 후행에 위치해야 함
-- 그럼 BETWEEN 같은 비교가 필요할 경우 인덱스 순서만 바꾸어지면 될까?
--> NO! 인덱스 순서 변경으로 인한 다른 조회에 영향을 반드시 고려해야함

-- BETWEEN 범위가 작을 때 -> IN-LIST로 대체하는 것을 고려 (사실상 다수의 비교연산을 수행)
SET STATISTICS PROFILE ON;

SELECT *
FROM TestOrders WITH(INDEX(idx_ord_emp))
WHERE EmployeeID = 1 AND OrderDate IN('19970101','19970102', '19970103');

-- 결론

-- 복합 컬림 인덱스 (선행, 후행) 순서가 영향을 줄 수 있음
-- BETWEEN, 부등호 조건이 선행에 들어가면 후행의 인덱스는 기능을 상실함
-- 선행 인덱스 BETWEEN의 범위가 작을 경우 IN-LIST로 대체하면 조회 속도 개선에 도움이 될 수 있다
-- 그 반대의 경우에는 오히려 조회 속도 성능 저하가 발생할 수 있음에 주의!
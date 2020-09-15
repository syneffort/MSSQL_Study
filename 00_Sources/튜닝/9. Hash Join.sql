USE Northwind;

-- Hash Join

SELECT * INTO TestOrders FROM Orders;
SELECT * INTO TestCustomer FROM Customers;

SELECT * FROM TestOrders; -- 830 row
SELECT * FROM TestCustomer; -- 91 row

-- NL (문제점 : Inner 테이블에 인덱스가 없어서 모두 스캔하게됨)
SELECT *
FROM TestOrders AS o
	INNER JOIN TestCustomer AS c
	ON o.CustomerID = c.CustomerID
	OPTION (FORCE ORDER, LOOP JOIN);

-- MERGE (문제점 : 양쪽 테이블에 인덱스가 없어서 Sort 및 Outer 테이블 인덱스 유일성 보장이 없어서 Many-to-Many 병합 처리됨)
SELECT *
FROM TestOrders AS o
	INNER JOIN TestCustomer AS c
	ON o.CustomerID = c.CustomerID
	OPTION (FORCE ORDER, MERGE JOIN);

-- HASH
-- 해시테이블은 테이블 사이즈가 작은 쪽을 이용해서 만들게됨
SELECT *
FROM TestOrders AS o
	INNER JOIN TestCustomer AS c
	ON o.CustomerID = c.CustomerID;

-- 결론
-- 1) 정렬이 필요치 않다 -> 데이터가 너무 많아서 Merge가 부담스러울 때, Hash가 대안이 될 수 있음
-- 2) 인덱스 유무에 영향을 받지 않는다 ***
	-- NL or Merge에 비해 확실한 장점
	-- HashTable을 만드는 비용을 무시해서는 안됨 (수행 빈도가 많다면 Index를 만들어서 관리하는게 나음)
-- 3) 랜덤 액세스 위주로 수행되지 않는다
-- 4) 데이터가 적은 쪽을 HashTable로 만드는것이 유리하다
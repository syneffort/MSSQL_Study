USE Northwind;

-- 북마크 룩업

-- Index Scan vs Index Seek
-- Index Scan이 항상 나쁜것은 아니고,  Index Seek가 항상 좋은것은 아니다.
-- 인덱스를 사용하는데 어떻게 느릴 수 있는것일까?

-- Clusterd의 경우 Index Seek가 느릴 수 없음
-- NonClustered의 경우, 데이터가 Leaf Page에 없기 때문에 한번 더 과정이 필요함
	-- 1) RID -> Heap Table (Bookmark Lookup)
	-- 2) Key -> Clustered

SELECT *
INTO TestOrders
FROM Orders;

SELECT *
FROM TestOrders;

CREATE NONCLUSTERED INDEX Orders_Index01
ON TestOrders(CustomerID);

-- 인덱스 번호
SELECT index_id, name
FROM sys.indexes
WHERE object_id = object_id('TestOrders');

-- 조회
DBCC IND('Northwind', 'TestOrders', 2);

--     880
-- 840 848 849
-- Heap Table[ {Page} {Page}]

SET STATISTICS TIME ON;
SET STATISTICS IO ON;
SET STATISTICS PROFILE ON;

-- 기본 탐색
SELECT *
FROM TestOrders
WHERE CustomerID = 'QUICK';

-- 강제로 인덱스를 이용하게 해보자
SELECT *
FROM TestOrders WITH(INDEX(Orders_Index01))
WHERE CustomerID = 'QUICK';

SELECT *
FROM TestOrders WITH(INDEX(Orders_Index01))
WHERE CustomerID = 'QUICK' AND ShipVia = 3;

DROP INDEX TestOrders.Orders_Index01;

-- 룩업을 줄이기 위한 몸부림
-- 검색하려는 필드들을 다수 집어넣는 인덱스 -> Covered Index
CREATE NONCLUSTERED INDEX Orders_Index01
ON TestOrders(CustomerID, ShipVia);

-- 8회의 룩업 과정을 실패없이 수행 (기존에는 28회 룩업을 수행)
SELECT *
FROM TestOrders WITH(INDEX(Orders_Index01))
WHERE CustomerID = 'QUICK' AND ShipVia = 3;

-- Q) Covered Index로 다수 필드를 구성하는게 좋은가?
-- A) 꼭 그렇지 않다. DML (Insert, Update, Delete) 처리 속도가 느려짐

DROP INDEX TestOrders.Orders_Index01;

-- 룩업을 줄이기 위한 몸부림
CREATE NONCLUSTERED INDEX Orders_Index01
ON TestOrders(CustomerID) INCLUDE (ShipVia); -- 리프 페이지에 ShipVia 정보를 포함, 데이터 순서에는 영향없음

-- 8회의 룩업 과정을 실패없이 수행 (기존에는 28회 룩업을 수행)
SELECT *
FROM TestOrders WITH(INDEX(Orders_Index01))
WHERE CustomerID = 'QUICK' AND ShipVia = 3;

-- 위와 같은 눈물겨운 노력에도 답이 없다면?
-- Clustered Index 활용을 고려할 수 있다.
-- 하지만 Clustered Index는 테이블 당 1개만 사용가능하다는 점을 고려해야한다.

--- 결 론 ---

-- NonClustered Index가 악영향을 주는 경우?
	-- 북마크 룩업이 심각한 부하를 야기할 때
-- 대안?
	-- 옵션1) Covered Index : 검색할 모든 필드를 포함하겠다
	-- 옵션2) Index에 Include를 이용해 힌트를 남긴다
	-- 옵션3) Clustered Index : 단, 1번만 사용할 수 있는 궁극기...
			--> 사용 시 NonClustered에 악영향을 줄 수 있음 (다른 논클러스터드의 검색이 클러스터드를 거쳐 수행됨)
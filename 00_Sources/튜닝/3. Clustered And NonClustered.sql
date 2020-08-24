USE Northwind;

-- 인덱스 종류
-- Clustered(사전) vs NonClustered(색인)

-- Clustered
	-- Leaf page = Data page
	--> Clustered Index 키 순서에 따라 실제 데이터 정렬이 발생함

-- NonClustered
	-- Clustered Index에 따라 다르게 동작
	-- 1) Clustered가 없는 경우
		-- 데이터는 Heap Table에 저장 (Leaf page가 없기 때문)
		-- Heap RID을 통해 힙테이블에 접근하여 데이터 추출
	-- 2) Clustered가 있는 경우
		-- 데이터는 Leaf Table에 저장 (Heap Table 없음)
		-- Clustered Index의 실제 키 값을 들고 있음

-- 임시 테이블 생성 후 복사
SELECT *
INTO TestOrderDetails
FROM [Order Details]

SELECT *
FROM TestOrderDetails;

-- 인덱스 추가
CREATE INDEX Index_OrderDetails
ON TestOrderDetails(OrderID, ProductID);

-- 인덱스 정보
EXEC sp_helpindex 'TestOrderDetails';
-- 인덱스 번호 찾기
SELECT index_id, name
FROM sys.indexes
WHERE object_id = object_id('TestOrderDetails');

-- 조회
DBCC IND('Northwind', 'TestOrderDetails', 2);

-- Heap RID ([페이지주소(4)][파일ID(2)][슬롯(2)]) : Row 식별자
DBCC PAGE('Northwind', 1, 832, 3);

-- Clustered Index 추가
CREATE CLUSTERED INDEX Index_OrderDetails_Clustered
ON TestOrderDetails(OrderID);

-- 인덱스 정보
EXEC sp_helpindex 'TestOrderDetails';
-- 인덱스 번호 찾기
SELECT index_id, name
FROM sys.indexes
WHERE object_id = object_id('TestOrderDetails');

-- Heap RID 사라짐
DBCC PAGE('Northwind', 1, 928, 3);

-- 조회
DBCC IND('Northwind', 'TestOrderDetails', 1);
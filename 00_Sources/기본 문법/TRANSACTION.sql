USE GameDB;

SELECT *
FROM accounts;

-- TRAN 명시하지 않으면 자동으로 COMMIT
INSERT INTO accounts VALUES(1, 'synk', 100, GETUTCDATE());

DELETE accounts;

-- BEGIN TRAN : 준비
-- COMMIT : 실행
-- ROLLBACK : 파기

-- 성공/실패 여부에 따라 COMMIT
BEGIN TRAN;
	INSERT INTO accounts VALUES(2, 'synk2', 100, GETUTCDATE());
ROLLBACK;

BEGIN TRAN;
	INSERT INTO accounts VALUES(2, 'synk2', 100, GETUTCDATE());
COMMIT;

-- 응용
BEGIN TRY
	BEGIN TRAN
		INSERT INTO accounts VALUES(1, 'synk1', 100, GETUTCDATE());
		INSERT INTO accounts VALUES(2, 'synk2', 100, GETUTCDATE());
	COMMIT
	PRINT('커밋 완료')
END TRY
BEGIN CATCH
	IF @@TRANCOUNT > 0 -- 현재 활성화된 트랜잭션 수 반환
		ROLLBACK
	PRINT('롤백 처리됨')
END CATCH

-- TRAN 사용시 주의점
-- TRAN 안에는 반드시 원자적으로 실행될 구문만 작성해야함

BEGIN TRAN
	INSERT INTO accounts VALUES(3, 'synk3', 100, GETUTCDATE());
ROLLBACK

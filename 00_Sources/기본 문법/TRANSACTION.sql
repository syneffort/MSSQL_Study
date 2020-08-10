USE GameDB;

SELECT *
FROM accounts;

-- TRAN ������� ������ �ڵ����� COMMIT
INSERT INTO accounts VALUES(1, 'synk', 100, GETUTCDATE());

DELETE accounts;

-- BEGIN TRAN : �غ�
-- COMMIT : ����
-- ROLLBACK : �ı�

-- ����/���� ���ο� ���� COMMIT
BEGIN TRAN;
	INSERT INTO accounts VALUES(2, 'synk2', 100, GETUTCDATE());
ROLLBACK;

BEGIN TRAN;
	INSERT INTO accounts VALUES(2, 'synk2', 100, GETUTCDATE());
COMMIT;

-- ����
BEGIN TRY
	BEGIN TRAN
		INSERT INTO accounts VALUES(1, 'synk1', 100, GETUTCDATE());
		INSERT INTO accounts VALUES(2, 'synk2', 100, GETUTCDATE());
	COMMIT
	PRINT('Ŀ�� �Ϸ�')
END TRY
BEGIN CATCH
	IF @@TRANCOUNT > 0 -- ���� Ȱ��ȭ�� Ʈ����� �� ��ȯ
		ROLLBACK
	PRINT('�ѹ� ó����')
END CATCH

-- TRAN ���� ������
-- TRAN �ȿ��� �ݵ�� ���������� ����� ������ �ۼ��ؾ���

BEGIN TRAN
	INSERT INTO accounts VALUES(3, 'synk3', 100, GETUTCDATE());
ROLLBACK

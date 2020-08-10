USE BaseballData;

----------------- 변수 -------------------------

DECLARE @i AS INT = 10;

DECLARE @j AS INT;
SET @j = 10;

-- 예제> 역대 최고 연봉을 받은 선수 이름

DECLARE @firstName AS NVARCHAR(15);
DECLARE @lastName AS NVARCHAR(15);

SET @firstName = (SELECT TOP 1 p.nameFirst
					FROM players AS p
						INNER JOIN salaries AS s
						ON p.playerID = s.playerID
					ORDER BY s.salary DESC);

SELECT @firstName;

-- SQL SERVER

GO -- 배치 (GO를 기준으로 구문을 별도로 구분, GO 기준 앞 구문이 에러가 있어도 이후 구문 실행됨)

DECLARE @firstName AS NVARCHAR(15);
DECLARE @lastName AS NVARCHAR(15);

SELECT TOP 1 @firstName = p.nameFirst, @lastName = p.nameLast
FROM players AS p
	INNER JOIN salaries AS s
	ON p.playerID = s.playerID
ORDER BY s.salary DESC;

SELECT @firstName, @lastName;


--------- 흐름제어 --------

--IF
GO
DECLARE @i AS INT = 10;

IF @i = 10
	PRINT('BINGO!');
ELSE
	PRINT('NO!');

-- IF
GO
DECLARE @i AS INT = 10;

IF @i = 10
BEGIN
	PRINT('BINGO!');
	PRINT('BINGO!');
END
ELSE
	PRINT('NO!');

------- WHILE --------------
GO
DECLARE @i AS INT = 0;
WHILE @i <= 10
BEGIN
	SET @i = @i + 1;
	IF @i = 6
		CONTINUE;--BREAK;
	PRINT @i;
END

----------------- 테이블 변수 ---------------
-- 임시로 사용할 테이블을 변수로 만들 수 있음
-- tempdb 데이터베이스에 임시 저장됨

GO
DECLARE @test TABLE
(
	name VARCHAR(50) NOT NULL,
	salary INT NOT NULL
);

INSERT INTO @test
SELECT p.nameFirst + ' ' + p.nameLast, s.salary
FROM players AS p
	INNER JOIN salaries AS s
	ON p.playerID = s.playerID

SELECT *
FROM @test;



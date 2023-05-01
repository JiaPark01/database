USE sqldb;
SET @myVar1 = 5;
SET @myVar2 = 3;
SET @myVar3 = 4.25;
SET @myVar4 = '가수 이름 ==>';

SELECT @myVar1, @myVar2, @myVar3, @myVar4;
SELECT @myVar4, name FROM usertbl WHERE height > 180;

-- 데이터의 형식과 형변환
SELECT AVG(amount) FROM buytbl;
SELECT CAST(AVG(amount) AS SIGNED INT) AS '평균구매개수' FROM buytbl;		-- 실수를 반올림해서 정수 변환
SELECT CONVERT(AVG(amount), SIGNED INT) AS '평균구매개수' FROM buytbl;

-- 문자열을 DATE 형으로 변환
SELECT CAST('2020-01-01' AS DATETIME);
SELECT CAST('2020.01.01' AS DATE);
SELECT CAST('12:34:56' AS TIME);

-- 암시적인 형변환
SELECT '100'+'200';				-- 문자와 문자를 정수로 변환해서 연산
SELECT 'ABC'+'DEF';				-- 0
SELECT CONCAT('ABC', 'DEF');	-- 'ABCDEF'
SELECT CONCAT('100', '200');	-- 100200
SELECT CONCAT(100, 200);		-- 100200

SELECT 1 > '2mega';				-- 1 > 2 --> 0
SELECT 3 > '2MEGA';				-- 3 > 2 --> 1
SELECT 0 > 'mega2';				-- 0 > 0 --> 0
SELECT 3 > 'mega2';				-- 3 > 0 --> 1

-- 제어 흐름 함수
SELECT IF(100 > 200, '참이다', '거짓이다');
SELECT IFNULL(NULL, 'Null :('), IFNULL(100, 'Null :('), IFNULL(100 > 200, 'Null :(');
SELECT NULLIF(100, 100), NULLIF(100, 200);
-- 문자열 함수
SELECT ASCII('A'), char(5);
SELECT bit_length('abc'), char_length('abc'), length('abc');
SELECT bit_length('가나다'), char_length('가나다'), length('가나다');

SELECT concat('abc', 'def');
SELECT concat_ws('/', 'abc', 'def', 'ghi');

SELECT ELT(2, '하나', '둘', '셋'), field('둘', '하나', '둘', '셋'), find_in_set('둘', '하나,둘,셋');
SELECT INSTR('하나둘셋', '나'), LOCATE('나', '하나둘셋');

SELECT FORMAT(123456.123456, 4);

SELECT BIN(31), hex(31), oct(31);

SELECT LPAD('이것이', 5, '#@');

 -- 날짜 및 시간 함수
SELECT ADDDATE('2025-01-01', 100);
SELECT ADDDATE('2025-01-01', INTERVAL 1 DAY);
SELECT ADDDATE('2025-01-30', INTERVAL 1 MONTH);		-- 02-28
SELECT ADDDATE('2025-01-01', INTERVAL 1 YEAR);

SELECT SUBDATE('2025-01-01', 100);
SELECT SUBDATE('2025-01-01', INTERVAL 1 DAY);
SELECT SUBDATE('2025-01-30', INTERVAL 1 MONTH);
SELECT SUBDATE('2025-01-01', INTERVAL 1 YEAR);

SELECT ADDTIME('02:13:04', '01:50:01'), ADDTIME('2023-03-04 23:13:04', '01:50:01');
SELECT SUBTIME('02:13:04', '01:50:01'), SUBTIME('2023-03-04 23:13:04', '01:50:01');

SELECT curdate(), curtime(), now(), sysdate();

SELECT YEAR(curdate()), MONTH(curdate()), DAY(curdate());
SELECT HOUR(curtime()), MINUTE(curtime()), SECOND(curtime());
SELECT microsecond(CURTIME());

SELECT datediff('2025-01-01', NOW()), timediff('23:23:59', '12:11:10');
-- SELECT timediff(now(), '1970-01-01 00:00:00');

SELECT last_day('2025-02-01');
SELECT QUARTER('2025-07-07');
SELECT time_to_sec('12:11:10');

SELECT USER();
SELECT DATABASE();

SELECT * FROM usertbl;
SELECT found_rows();

-- 피벗
USE sqldb;
DROP TABLE IF EXISTS pivotTest;
CREATE TABLE pivotTest(uName char(3), season char(2), amount int);

INSERT INTO pivotTest values
	('김범수', '겨울', 10),
    ('윤종신', '여름', 15),
    ('김범수', '가을', 25),
    ('김범수', '봄', 3),
    ('김범수', '봄', 37),
    ('윤종신', '겨울', 40),
    ('김범수', '여름', 14),
    ('김범수', '겨울', 22),
    ('윤종신', '여름', 64);
    
SELECT * FROM pivotTest;

SELECT
	uName,
	sum(IF(season = '봄', amount, 0)) AS '봄',
	sum(IF(season = '여름', amount, 0)) AS '여름',
	sum(IF(season = '가을', amount, 0)) AS '가을',
	sum(IF(season = '겨울', amount, 0)) AS '겨울',
	sum(amount) AS '합계'
FROM pivottest GROUP BY uName;

SELECT
	season,
    sum(IF(uName = '김범수', amount, 0)) AS '김범수',
    sum(IF(uName = '윤종신', amount, 0)) AS '윤종신',
    sum(amount) AS '합계'
FROM pivottest GROUP BY season ORDER BY season;


SELECT version();

-- JOIN
USE sqldb;
SELECT 
    userID, name, prodName, addr, concat(mobile1, mobile2) AS mobile 
FROM
    buytbl
        NATURAL JOIN
    usertbl
ORDER BY num;

SELECT 
	B.userID, U.name, B.prodName, U.addr, concat(U.mobile1, U.mobile2) AS '연락처'
FROM
	buytbl B
		INNER JOIN
	usertbl U ON B.userID = U.userID
ORDER BY num;

-- 세 개의 테이블 조인
SELECT 
    s.stdName, s.addr, c.clubName, c.roomNo
FROM
    stdtbl s
        INNER JOIN
    stdclubtbl sc ON s.stdName = sc.stdName
        INNER JOIN
    clubtbl c ON sc.clubName = c.clubName
ORDER BY s.stdName;

-- 프로시저 프로그래밍 (PL/SQL)
DROP PROCEDURE IF EXISTS ifProc;
DELIMITER $$
CREATE PROCEDURE ifProc()
BEGIN
	DECLARE var1 INT;		-- 변수 생성
    SET var1 = 100;			-- 변수값 대입
    
    IF var1 = 100 THEN
		SELECT '100입니다';
	ELSE
		SELECT '100이 아닙니다';
	END IF;
END $$
DELIMITER ;

CALL ifProc();

	-- 실습1: 각각의 사람들이 가입한 클럽의 개수
SELECT
	s.stdName,
    count(*) AS '가입한 클럽 개수'
FROM
	stdtbl s
        INNER JOIN
    stdclubtbl sc ON s.stdName = sc.stdName
        INNER JOIN
    clubtbl c ON sc.clubName = c.clubName
GROUP BY s.stdName
ORDER BY s.stdName;

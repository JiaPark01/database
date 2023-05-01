use sqldb;
-- 	열이름		테이블
select * from usertbl;
select * from buytbl;

select * from usertbl where not (name = '김경호');

-- AND OR
select userId, name from usertbl where birthYear >= 1970 AND height >= 182;
select userId, name from usertbl where birthYear >= 1970 OR height >= 182;

-- BETWEEN
select name, height from usertbl where height between 172 AND 174;
select name, height from usertbl where height >= 172 AND height <= 174;

-- IN
select * from usertbl where addr = '경남' OR addr = '전남' or addr = '경북';
select * from usertbl where addr in('경남', '전남', '경북');

-- 와일드키
select * from usertbl where name like '김%';
select * from usertbl where name like '_종신';

-- 서브 쿼리
select * from usertbl where height > 177;
select * from usertbl where height >
	(select height from usertbl where name = '김경호');

-- ANY : 173보다 크거나 170보다 크거나 (OR)
select * from usertbl where height > ANY
	(select height from usertbl where addr = '경남');

-- SOME : ANY랑 동일?
select * from usertbl where height > SOME
	(select height from usertbl where addr = '경남');
    
-- ALL : 173보다 크고 170보다 큰 (AND)
select * from usertbl where height > ALL
	(select height from usertbl where addr = '경남');
    
-- ANY IN : = ANY
select * from usertbl where height in (select height from usertbl where addr='경남');

-- ORDER BY
select name, mDate from usertbl order by mDate;
select name, mDate from usertbl order by mDate desc;

select name, height from usertbl order by height desc, name;

-- DISTINCT
select distinct addr from usertbl order by addr;

-- LIMIT
SELECT emp_no, hire_date FROM employees.employees ORDER BY hire_date LIMIT 0, 5;

-- 테이블 생성과 복사
USE sqldb;
CREATE TABLE buytbl2 (SELECT * FROM buytbl);
SELECT * FROM buytbl2;

-- UNION
SELECT mobile1 FROM sqldb.usertbl WHERE mobile1 = 019
UNION
SELECT mobile1 FROM sqldb.usertbl WHERE mobile1 = 018;

-- GROUP BY, AS
SELECT
	userID AS '사용자 아이디',
    sum(amount) AS '총 구매 개수',
    sum(amount*price) AS '총 구매액'
	FROM buytbl GROUP BY userID ORDER BY userID;
    
SELECT userID, avg(amount) AS '평균 구매 개수' FROM buytbl GROUP BY userID;

SELECT name, height FROM usertbl
	where height = (select max(height) FROM usertbl)
	OR height = (select min(height) fROM usertbl);

-- 테이블의 행의 수
SELECT COUNT(*) FROM usertbl;
-- 휴대폰 사용자의 수
SELECT COUNT(mobile1) FROM usertbl;
SELECT COUNT(DISTINCT mobile1) FROM usertbl;

-- HAVING
SELECT
	userID AS '사용자 아이디',
    sum(amount*price) AS '총 구매액'
FROM buytbl
GROUP BY userID
HAVING sum(amount*price) >= 1000
ORDER BY sum(amount*price);

SELECT num, groupName, SUM(price*amount) AS '비용'
FROM buytbl
GROUP BY groupName, num
WITH ROLLUP;

-- -------------------------------데이터 변경을 위한 SQL문-------------------------------

USE sqldb;
CREATE TABLE testTBL1(id int, userName char(3), age int);
INSERT INTO testtbl1 VALUES (1,  '홍길동', 25);
INSERT INTO testtbl1(id, userName) VALUES (2, '설현');
INSERT INTO testtbl1 (id, age) values (3, 34);
INSERT INTO testtbl1(userName, age, id) values ('하니', 26, 4);

SELECT * FROM testtbl1;

CREATE TABLE testTBL2(id int AUTO_INCREMENT PRIMARY KEY, userName char(3), age int);
INSERT INTO testtbl2 VALUES(NULL, '지민', 25);
INSERT INTO testtbl2 VALUES(NULL, '유나', 22);
INSERT INTO testtbl2 VALUES(NULL, '유경', 21);
SELECT LAST_INSERT_ID();
INSERT INTO testtbl2 VALUES(10, '민호', 45);
INSERT INTO testtbl2 VALUES(NULL, '제니', 21);
INSERT INTO testtbl2 VALUES(4, '로제', 21);
INSERT INTO testtbl2 VALUES(NULL, '지훈', 24);

ALTER TABLE testtbl2 AUTO_INCREMENT = 16;		-- 현재의 값보다 작게는 설정 불가
INSERT INTO testtbl2 VALUES(NULL, '리사', 22);

SET @@auto_increment_increment=3;
INSERT INTO testtbl2 VALUES(NULL, '나연', 22);
INSERT INTO testtbl2 VALUES(NULL, '정연', 22);
INSERT INTO testtbl2 VALUES(NULL, '모모', 22);

-- 대량의 샘플 데이터 생성
use sqldb;
CREATE TABLE testtbl4(id int, Fname varchar(50), Lname varchar(50));

INSERT INTO testtbl4 SELECT emp_no, first_name, last_name FROM employees.employees;

CREATE TABLE testtbl5(SELECT emp_no, first_name, last_name FROM employees.employees);

CREATE TABLE testtbl6(
	SELECT
		emp_no AS 'id',
        first_name AS 'Fname',
        last_name AS 'Lname'
	FROM
		employees.employees);

-- UPDATE: 데이터 수정
UPDATE testtbl4 SET Lname = '없음' WHERE Fname = 'Kyoichi';

UPDATE buytbl SET price = price * 1.5;

-- DELETE
DELETE FROM testtbl4 WHERE Fname = 'Aamer';
DELETE FROM sqldb.testtbl4 WHERE Fname = 'Domenick' ORDER BY id LIMIT 5;




	-- 실습 1: 김경호에 대한 정보만 출력
SELECT * FROM usertbl WHERE NAME = '김경호';

	-- 실습 2: 
select name from usertbl where name between '김경호' AND '성시경';
select name from usertbl where name >= '김경호' AND name <= '성시경';
    
	-- 실습 3: 1990년 1월 1일부터 채용된 사람 100명
SELECT 
    *
FROM
    employees.employees
WHERE
    hire_date >= '1990-01-01'
ORDER BY hire_date , emp_no
LIMIT 100;

	-- 실습 4: 018과 019를 사용하는 사람
SELECT * FROM sqldb.usertbl where mobile1 = 018 OR mobile1 = 019;

	-- 실습 5: 제품별 판매 개수 출력
SELECT prodName, sum(amount) FROM buytbl GROUP BY prodName;

	-- 실습 6: 총 구매량이 제일 높은 사람과 제일 낮은 사람
SELECT userID, tot AS '총 구매량'
FROM
	(SELECT userID, SUM(amount) AS 'tot' FROM buytbl GROUP BY userID) total
WHERE
	tot = (SELECT MAX(amount) AS 'amount'
	FROM (SELECT userID, SUM(amount) AS 'amount' FROM buytbl GROUP BY userID) max)
OR
	tot = (SELECT MIN(amount) AS 'amount'
    FROM (SELECT userID, SUM(amount) AS 'amount' FROM buytbl GROUP BY userID) min);
    
	-- 실습 7: HAVING 이용해 실습 6
SELECT userID, sum(amount) as 'Sum Amount' from buytbl group by userID having sum(amount) = max();
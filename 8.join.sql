-- post테이블의 author_id값을 nullable하게 변경
alter table post modify column author_id bigint;

-- inner join
-- 두 테이블사이에 지정된 조건에 맞는 레코드만을 반환. on 조건을 통해 교집합 찾기
-- 즉 post테이블에 글쓴적이 있는 author에 글쓴이가 author에 있는 post 데이터를 결합하여 출력
select * from author inner join post on author.id =post.author_id;
select * from author a inner join post p on a.id =p.author_id;
-- 출력순서만 달라질뿐 위 쿼리와 아래쿼리는 동일
select * from post.p inner join author a on a.id=p.author_id;
-- 만약 같게 하고 싶다면
select a.*, p.* from post p inner join author a on a.id =p.author_id;

-- 글쓴이가 있는 글 전체 정보와 글쓴이의 이메일만 출력하시오.
-- post의 글쓴이가 없는 데이터는 제외. 글쓴이중에 글쓴적 없는 사람도 제외 
select p.* ,a.email from post p inner join author a on a.id = p.author_id;

-- 글쓴이가 있는 글의 제목, 내용, 그리고 글쓴이의 이름만 출력하시오
select p.title , p.content ,a.name from post p inner join author a on a.id = p.author_id

-- A left join B : A테이블의 데이터는 모두 조회하고, 관련있는 (on 조건) B데이터도 출력
-- 글쓴이를 모두 출력하되, 글을 쓴적이 있다면 관련글도 같이 출력
select * from author a left join post p on a.id = p.author_id;

-- 모든 글목록을 출력하고, 만약 저자가 있다면 이메일 정보를 출력
select p.*,a.email from post p left join author a on a.id = p.author_id;

-- 모든 글목록을 출력하고, 관련된 저자 정보 출력. (author_id가 not null이라면)
-- 만약, author_id가 not null이라면 아래 2쿼리는 동일
select * from post p left join author a on p.author_id = a.id;
select * from post p inner join author a on p.author_id = a.id;

-- 실습) 글쓴이가 있는 글중에서 글의 title과 저자의 email을 출력하되, 저자의 나이가 30세 이상인 글만 출력하겠다.
select p.title, a.email from post p left join author a on p.author_id = a.id where age>29;

-- 전체 글 몰록을 조회하되, 글의 저자의 이름이 비어져 있지 않은 글 목록만을 출력.
select p.title,p.content,a.name from post p left join author a on p.author_id = a.id where a.name is not null
select p.* from post p inner join author a on p.author_id = a.id where a.name is not null;

--조건에 맞는 도서와 저자 리스트 출력
SELECT B.BOOK_ID,A.AUTHOR_NAME,DATE_FORMAT(B.PUBLISHED_DATE,'%Y-%m-%d') from book B inner join Author A
on B.author_id = A.author_id where B.category like '경제%' order by published_date ;

-- 없어진 기록 찾기
SELECT O.ANIMAL_ID,O.NAME 
FROM ANIMAL_OUTS O 
left join ANIMAL_INS I ON O.ANIMAL_ID = I.ANIMAL_ID 
where I.datetime is null order by o.ANIMAL_ID;

SELECT o.animal_id, o.name from animal_outs o where o.animal_id not in (select animal_id from animal_ins);


--번외 앞자리 코드 두자리수를 카운팅하는 법
SELECT
  LEFT(PRODUCT_CODE, 2) AS CATEGORY,
  COUNT(*)           AS PRODUCTS
FROM PRODUCT
GROUP BY CATEGORY
ORDER BY CATEGORY;

-- union : 두 테이블의 select 결과를 횡으로 결합(기본적으로 distinct 적용)
-- union 시킬때 컬럼의 개수와 컬럼의 타입이 같아야함.
select name, email from author union select title , content from post;
-- union all : 중복까지 모두 포함
select name, email from author union all select title , content from post;

-- 서브쿼리: select문 안에 또다른 select문을 서브쿼리라 한다.
select 컬럼 from 테이블 where 조건

--where절 안에 서브쿼리
-- 한번이라도 글을 쓴 author 목록 조회
select distinct a.* from author a inner join post p on a.id=p.author_id;
-- null값은 in조건절에서 자동으로 제외
select * from author where id in(select author_id from post);

--컬럼 위치에 서브쿼리
-- author의 email과 author 별로 본인이 쓴 글의 개수로 출력.
select email, (select COUNT(*) from post p where a.id=p.author_id) from author a;
select count(*) from author; --null은 카운터에서 빠짐



--from절 위치에 서브쿼리
select a.* from (select * from author where id>5) as a;

-- group by  컬럼명 : 특정 컬럼으로 데이터를 그룹화 하며, 하나의 행(row)처럼 취급
select author_id from post group by author_id;
-- 보통 아래와 같이 집계합수와 같이 많이 사용
select author_id,count(*) from post group by author_id;

-- 집계함수
-- null은 count에서 제외
select count(*) from author;
select sum(price) from post;
select avg(price) from post;
-- 소수점 3번째 자리에서 반올림
select round(avg(price),3) from post;

--group by와 집계함수
select author_id,count(*),sum(price) from post group by author_id;

-- where와 group by
-- 날짜별 post 글의 개수 출력(날짜 값이 null은 제외)
select DATE_FORMAT(created_time,'%Y-%m-%d') as day,count(*) from post where created_time is not null group by day;

-- 자동차 종류 별 특정 옵션이 포함된 자동차 수 구하기
SELECT CAR_TYPE,COUNT(*) AS CARS
FROM CAR_RENTAL_COMPANY_CAR
WHERE OPTIONS REGEXP '통풍시트|열선시트|가죽시트'
GROUP BY CAR_TYPE
ORDER BY CAR_TYPE;

-- 입양시각 구하기(1)
SELECT
  HOUR(`datetime`) AS `hour`,
  COUNT(*)        AS `count`
FROM ANIMAL_OUTS
WHERE
  HOUR(`datetime`) BETWEEN 9 AND 20
GROUP BY
  HOUR(`datetime`)
ORDER BY
  `hour`;

-- group by와 having
-- having은 group by를 통해 나온 집계값에 대한 조건
-- 글을 두번이상 쓴사람에 대한 ID 찾기
select author_id,count(*) from post group by author_id having count(*) > 1;

-- 동명 동물 수 찾기
SELECT NAME,COUNT(NAME)
FROM ANIMAL_INS
WHERE NAME IS NOT NULL
GROUP BY NAME
HAVING COUNT(*) > 1
ORDER BY NAME;

-- 카테고리 별 도서 판매량 집계하기
SELECT B.CATEGORY, SUM(BS.SALES)  AS TOTAL_SALES
FROM BOOK B INNER JOIN BOOK_SALES BS ON B.BOOK_ID = BS.BOOK_ID
WHERE DATE_FORMAT(BS.SALES_DATE, '%Y-%m') = '2022-01'
GROUP BY B.CATEGORY ORDER BY B.CATEGORY;

-- 조건에 맞는 사용자의 총 거래 금액 찾기
SELECT USER_ID,NICKNAME,SUM(B.PRICE)TOTAL_SALES
FROM USED_GOODS_BOARD B INNER JOIN USED_GOODS_USER U ON B.WRITER_ID = U.USER_ID
WHERE B.STATUS = 'DONE'
GROUP BY USER_ID,NICKNAME
HAVING TOTAL_SALES >=700000
ORDER BY TOTAL_SALES;

-- 다중열 GROUP BY: 
-- group by 첫번째 컬럼, 두번째 컬럼: 첫번째 컬럼으로 먼저 grouping이후에 두번째 컬럼으로 grouping
-- post테이블에서 작성자별로 만든 제목의 개수를 출력하시오
select author_id,title,count(*) from post group by author_id, title;

--재구매가 일어난 상품과 회원 리스트 구하기
SELECT USER_ID,PRODUCT_ID
FROM ONLINE_SALE
GROUP BY USER_ID,PRODUCT_ID
HAVING COUNT(*)>1
ORDER BY USER_ID ASC,PRODUCT_ID DESC;
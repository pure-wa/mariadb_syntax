-- tinyint : -128~127
-- author테이블에 age칼럼 변경
alter table author modify column age tinyint UNSIGNED;
insert into author(id,email,age) values(6, 'abc@naver.com',300);

-- int : 4바이트(대략,40억 숫자 범위)

-- bigint : 8바이트
-- author, post 테이블에 id값 bigint로 변경
alter table author modify column id bigint
alter table post modify column id bigint

-- decimal(총자리수, 소수부자리수)
alter table post add column price decimal(10,3);
-- decimal 소수점 초과시 짤림현상발생
insert into post(id, title, price, author_id)values(7, 'hello python', 10.33412, 3);

-- 문자타입 : 고정길이(char), 가변길이(varchar, test)
alter table author add column gender char(10);
alter table author add column self_introdution text;

--blob(바이너리데이터) 타입 실습
--일반적으로 blob을 저장하기보다, varchar로 설계하고 이미지 경로만 저장함.
alter table author add column profile_image longblob;
insert into author(id,email,profile_image) values(8,'aaa@naver.com',LOAD_FILE(''));

-- enum : 삼입될 수 있는 데이터의 종류를 한정하는 데이터 타입
-- role컬럼 추가
alter table author add column role enum('admin','user') not null default 'user';
--enum에 지정된 값이 아닌경우
insert into author(id,email,role) values(10,'ssa@naver.com','admin2');
--role를 저장안한 경우
insert into author(id,email) values(11,'ssa@naver.com');
-- enum에 지정된 값인 경우
insert into author(id,email,role) values(12,'ssa@naver.com','admin');

-- date datetime
-- 날짜타입의 입력,수정,조회시에 문자열 형식을 사용
alter table author add column birthday date;
alter table post add column created_time datetime;
insert into post(1d, title,author_id created_time) values ('13','hello',3,'2025-05-23 14:25:00');
alter table post add column created_time datetime default current_timestamp;
insert into post(id,title,author_id)values(10,'hello',3);

--비교 연산자
select * from author where id >=2 and id <= 4;
select * from author where id between 2 and 4;
select * from author where id in(2,3,4);

-- like : 특정 문자를 포함하는 데이터를 조회하기 위한 키워드
select * from post where title like "h%"
select * from post where title like "%h"
select * from post where title like "%h%"

--regexp : 정규표현식을 황요한 조회
select * from post where title regexp '[a-z]' --하나라도 알파벳 소문자가 들어있으면
select * from post where tutke regexpt '[가-힝]' -- 하나라도 한글이 있으면

--날짜변환 : 숫자 -> 날짜
select cast(20250523 as date) from author; --2025-05-23
-- 문자 -> 날짜
select cast('20250523' as date); --2025-05-23
-- 문자 -> 숫자
select cast('12' as UNSIGNED);

-- 날짜조회 방법 : 2025-05-23 14:30:25
-- like패턴, 부동호 활용, date_format
select * from post where created_time like '2025-05%'; --문자열처럼 조회
--5월 1일부터 5월 20일까지, 날짜만 입력시 시간부분은 00:00:00이 자동으로 붙음.
select * from post where created_time >= '2025-05-01' and created_time < '2025-05-21';

select date_format(created_time, '%Y-%m-%d') from post;
select date_format(created_time, '%H-%i-%s') from post;
select * from post where date_format(created_time, '%m')= '05';

select * from post where cast(date_format(created_time, '%m')as UNSIGNED)= 5;
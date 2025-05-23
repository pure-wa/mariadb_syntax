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

insert onto post(1d, title,author_id created_time) values ('13','hello',3,'2025-05-23 14:25:00');

alter table post add column created_time datetime default current_timestamp;
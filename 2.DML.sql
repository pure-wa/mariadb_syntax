--insert : 테이블에 데이터 삽입
insert into 테이블명(컬럼1,컬럼2,컬럼3) values(데이터1,데이터2,데이터3);
insert into author(id,name,email) values(3,'hong3','hong3@anaver.com'); --문자열 작을 따옴표
-- update,set : 테이블에 데이터 변경
update author set name = '홍길동', email='hong100@naver.com' where id =3;

-- select : 조회
select 컬럼1, 컬럼2 from 테이블명;
select name,email from author;
select * from author;

-- delete : 삭제
delete from 테이블명  where 조건명;
delete from author where id =3;

--select 조건절 활용 조회
--테스트 데이터 삽입 : insert 문을 활용해서 author데이터 3개 ,post데이터 5개
select*from author; -- 어떤 조회조건 없이 모든 컬럼 조회
select*from author where id = 1;
select*from author where name = 'hongildong';
select*from author where id>3;
select*from author where id>2 and name = 'hongildong4';
select * from author where id in (1,3,5);
select * from where author_id in(select id from author where name = 'hong')

--중복제거 조회
select name from author;
select distint from author;

-- 정령: order by
-- asc: 오름차순,desc : 내림차순 디폴트는 오름차순
-- 아무런 정렬조건없이 조회할 경우에는 pk(프라임키)기준으로 오름차순
select * from author order by name desc;

-- 멀티컬럼 order by : 여러컬럼으로 정렬시에, 먼저 쓴 컬럼 우선정렬. 중복시, 그다음 정렬옵션적음.
select * from author order by name desc,email asc; --name이 중복돠묜 email로 정렬,

-- 결과값 개수 제한
select * from author order by id desc limit 1;

-- 별칭(alias)를 이용한 select 
select name as '이름', email as '이메일' from author;
select a.name,a.email from author as a; --테이블 별칭도 가능
select a.name,a.email from author a;

--null을 조회조건으로 활용
select * from author where password is null;
select * from author where password is not null;
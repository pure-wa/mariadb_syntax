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
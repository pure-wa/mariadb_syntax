-- read uncommited : 커맛되지 않은 데이터 read가능 -> dirty read 문제 발생
-- 실습절차
-- 1)워크벤치에서 auto_commit에서 update후, commit하지 않음.(transaction1)
-- 2)터미널을 열어 select했을때 위 변경사항이 읽히는지 확인(transaction2)
-- 결론: mariadb는 기본이 repeatable read이므로 dirty read 발생하지 않음.


-- read commited : 커밋한 데이터 read 가능 -> phantom read 발생(또는 non-repeatable)
start transaction;
select count(*) from author;
do sleep(15);
select count(*) from author;
--터미널에서 실행
insert into author(email) values("xxxxxx@naver.com");

-- repeatable read : (phantom read 문제해결)읽기의 일관성 보장 -> lost update의 문제 발생 -> 배타적 잠금으로 해결.
-- lost update 문제 발생
DELIMITER //
create procedure concurrent_test1()
begin
    declare count int;
    start transaction;
    insert into post(title,author_id) values('hellow world',1);
    select post_count into count from author where id=1;
    do sleep(15)
    update author set post_count=count+1 where id =1;
    commit; --또는 rollback;
end//
DELIMITER ;
-- 터미널에서 아래코드 설정
select post_count from author where id=1;

-- lost update 문제 해결 : select for update시에 트렌젝션이 종료후에 특정행에 대한 lock이 풀림.
DELIMITER //
create procedure concurrent_test2()
begin
    declare count int;
    start transaction;
    insert into post(title,author_id) values('hellow world',1);
    select post_count into count from author where id=1 for update;
    do sleep(15)
    update author set post_count=count+1 where id =1;
    commit; --또는 rollback;
end//
DELIMITER ;
-- 터미널에서 아래코드 설정
select post_count from author where id=1 for update;

-- serializable : 모든 트렌젝션 순차적 실행 -> 동시성 문제 없음.(성능저하)
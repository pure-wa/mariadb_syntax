-- view : 실제데이터를 참조만 하는 가상의 테이블. Select만 가능
-- 사용목적 : 1)복잡한 쿼리를 사전생성 2) 권한분리

-- view생성
create view author_for_view as select name, email from author;


-- view 조회
select * from author_for_view;

-- view 권한부여
grant select on board.author_for_view to '게정명'@'%';

-- view 삭제
drop view author_for_view;

-- procedure(프로시져)생성
DELIMITER //
create procedure hello_procedure()
begin 
    select "hello world";
end
//DELIMITER ;

-- procedure(프로시져)호출
call hello_procedure();

-- 프로시저 삭제
drop procedure hello_procedure;

-- 회원목록조회

DELIMITER //
create procedure 회원목록조회()
begin 
    select * from author;
end
//DELIMITER ;

-- 회원상세조회 : input값 사용가눙
DELIMITER //
create procedure 회원상세조회(in emailInput varchar(255))
begin 
    select * from author where email = emailInput;
end
//DELIMITER ;

-- 글쓰기 
DELIMITER //
create procedure 글쓰기(in titleInput varchar(255),in contentsInput varchar(255),in emailInput varchar(255))
begin
    --declare는 begin밑에 위치
    declare authoridInput bigint;
	declare postidInput bigint;
    declare exit handler for  SQLEXCEPTION --오류코드가 나오면 롤백
    begin
        rollback;
    end;
    start transaction;
        select id into authoridInput from author where email = emailInput;
        insert into post(title, content) values(titleInput,contentsInput);
        select id into postidInput from post order by id desc limit 1;
        insert into author_post(author_id,post_id) values(authoridInput,postidInput);
    commit;
end
//DELIMITER ;
-- 여러명이 편집가능한 글에서 글삭제
DELIMITER //
create procedure 글삭제(in postidInput bigint,int emailInput varchar(255))
begin
    declare authorId bigint;
    declare authorPostCount bigint;
    select count(*) into authorPostCount from author_post where post_id = postidInput;
    select id authorid from author where email = emailInput;
    -- 글쓴이가 나밖에 없는경우 : author_post 삭제 ,post까지 삭제
    -- 글쓴이가 나 이외에 다른사람도 있는 경우: author_post만 삭제
    if authorPostCount=1 then
-- elseif도 사용가능
        delete from author_post where author_id = authorid and post_id = postidInput;
        delete from post where id=postidInput; 
    else
        delete from author_post where author_id = authorID and post_id = postidInput;
    end if;
end
//DELIMITER ;

-- 반복문을 통한 Post 대량생성
DELIMITER //
create procedure 대량글쓰기(in countInput bigint, in emailInput varchar(255))
	begin
	declare authoridInput bigint;
	declare postidInput bigint;
    declare countvalue bigint default 0;
    while countValue < countInput do
        select id into authoridInput from author where email = emailInput;
        insert into post(title) values("안녕하세요");
        select id into postidInput from post order by id desc limit 1;
        insert into author_post(author_id,post_id) values(authoridInput,postidInput);
        set countValue = countValue+1;
	end while;
end
//DELIMITER ;


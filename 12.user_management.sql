-- 사용자관리
-- 사용자목록조회
select * from mysql.user;

-- 사용자생성
create user 'tkdghks8242'@'%''IDENTIFIED' by '4321';
CREATE USER '아이디'@'호스트' IDENTIFIED BY '비밀번호';

-- 사용자에게 권한부여
grant select on board.author to 'tkdghks8242'@'%';
GRANT SELECT, INSERT ON board.* TO 'tkdghks8242'@'%';


-- 사용자 권한 조회
show grants for 'tkdghks8242'@'%';

-- 사용자 권한 삭제
drop user 'tkdghks8242'@'%';
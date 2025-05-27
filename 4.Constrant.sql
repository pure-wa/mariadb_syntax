-- not null 제약조건 추가
alter table author modify column name varchar(255) not null;
-- not null 제약조건 제거
alter table author modify column name varchar(255);
-- not null unique 제약조건 동시추가
alter table author column email varchar(255) not null unique;

--테이블 차원의 제약조건(pk,fk)추가/제거
-- 제약조건 삭제(fk) 제약조건이 여러개 걸려있을수도 있음 ex)여러 테이블에 참조되어있을수도 있음.
alter table post drop foreign key 제약조건명
alter table post drop constraint 제약조건명

select * from information_schema.key_column_usage where table_name='post'; --조회
-- 제약조건 삭제 (pk)
alter table post drop primary key
-- 제약조건 조회
alter table post add constraint post_pk primary key(id);
alter table post add constraint post_pk primary key(author_id) references author(id);

-- on delete/update 제약조건 테스트
-- 부모테이블 데이터 delete할 시 자식 fk칼럼 set null, update할시 fk 칼럼 cascade
alter table post add constraint post_fk_new foreign key (author_id) references author(id) on delete set null on update cascade;

-- default 옵션
-- enum타입 및 현재시간 (current_timestanp)에서 많이 사용
alter table author modify column name varchar(255) default 'anonymous';

-- auto_increment : 입력을 안했을 때 마지막에 입력된 가장 큰 값에서 +1만큼 자동으로 증가된 숫자값을 적용
alter table author modify column id bigint auto_increment;
alter table post modify column id bigint auto_increment;

-- uuid타입
alter table post add column user_id char(36) default (uuid());

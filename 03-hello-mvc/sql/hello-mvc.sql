--================================
-- 관리자계정 system
--================================
alter session set "_oracle_script"  = true; -- c## 접두어 없이 계정 생성가능하도록 설정

create user web
identified by web
default tablespace users;

alter user web quota  unlimited on users;

grant connect, resource to web;

--================================
-- WEB 계정
--================================
create table member (
    member_id varchar2(15),
    password varchar2(300) not null,
    member_name varchar2(50) not null,
    member_role char(1) default 'U' not null,
    gender char(1),
    birthday date,
    email varchar2(200),
    phone char(11) not null,
    hobby varchar2(200),
    point number default 1000,
    enroll_date date default sysdate,
    constraint pk_member_id primary key(member_id),
    constraint ck_member_role check(member_role in ('U', 'A')),
    constraint ck_member_gender check(gender in ('M', 'F')),
    constraint uq_member_email unique(email)
);

insert into member
values (
    'honggd', '1234', '홍길동', 'U', 'M', to_date('20000909','yyyymmdd'),
    'honggd@naver.com', '01012341234', '운동,등산,독서', default, default
);

insert into member
values (
    'qwerty', '1234', '쿠어티', 'U', 'F', to_date('19900215','yyyymmdd'),
    'qwerty@naver.com', '01012341234', '운동,등산', default, default
);

insert into member
values (
    'admin', '1234', '관리자', 'A', 'M', to_date('19801010','yyyymmdd'),
    'admin@naver.com', '01056785678', '게임,독서', default, default
);

commit;

select * from member;
select * from member order by enroll_date desc;

--insert into member
--values (
--    ?, ?, ?, default, ?, ?, ?, ?, ?, default, default
--);

--update member
--set
--    member_name = ?,
--    gender = ?,
--    birthday = ?,
--    email = ?,
--    phone = ?,
--    hobby = ?
--where
--    member_id = ?

delete from member 
where member_id in ('xyzxyz', 'khkh');
commit;

-- 페이징쿼리
select count(*) from member; -- 114
-- 총페이지수 - 12페이지
-- 페이지당 게시물수 10건 limit
-- 1페이지 : 1 ~ 10
-- 2페이지 : 11 ~ 20
-- 3페이지 : 21 ~ 30
-- n페이지 :  (n - 1) * 10  + 1  ~ n * limit

-- row_number()
select 
    *
from (
    select
        row_number() over(order by enroll_date desc) rnum,
        m.*
    from
        member m
)
where
    rnum between 111 and 120;

--select * from (select row_number() over(order by enroll_date desc) rnum, m.* from member m) where rnum between ? and ?

select count(*) from member;

-- 게시판 /첨부파일 테이블
create table board (
    no number,
    title varchar2(200) not null,
    writer varchar2(20),
    content varchar2(4000) not null,
    read_count number default 0,
    reg_date date default sysdate,
    constraint pk_board_no primary key(no),
    constraint fk_board_writer foreign key(writer) references member(member_id)
        on delete set null
);
create sequence seq_board_no;

create table attachment (
    no number,
    board_no number not null,
    original_filename varchar2(255) not null, -- 업로드한 파일명
    renamed_filename varchar2(255) not null, -- 실제 저장된 파일명
    reg_date date default sysdate,
    constraint pk_attachment_no primary key(no),
    constraint fk_attachment_board_no foreign key(board_no) references board(no) 
      on delete cascade
);

create sequence seq_attachment_no;

comment on column board.no is '게시글번호';
comment on column board.title is '게시글제목';
comment on column board.writer is '게시글작성자 아이디';
comment on column board.content is '게시글내용';
comment on column board.read_count is '조회수';
comment on column board.reg_date is '게시글작성일시';

comment on column attachment.no is '첨부파일번호(PK)';
comment on column attachment.board_no is '게시판글번호(FK)';
comment on column attachment.original_filename is '업로드한 첨부파일명';
comment on column attachment.renamed_filename is '서버에 저장된 첨부파일명';
comment on column attachment.reg_date is '첨부파일업로드일시';

select 
    b.*,
    () attach_cnt 
from 
    board b;










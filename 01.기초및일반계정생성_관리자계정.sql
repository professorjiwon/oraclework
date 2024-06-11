-- 한줄 주석 (단축키 : ctrl+/ )
/*
    여러줄 주석
    alt + shift + c
*/

-- 커서가 있는 줄 실행 단축키 : crtl + enter

-- 나의 계정 보기
show user;

-- 사용자 계정 조회
/*
    - 조회시
      select 속성명 from 테이블명
*/
select * from dba_users;
select username, user_id from dba_users;

-- user 계정 생성
/*
    오라클 12버전부터 일반사용자는 c##로 시작하는 이름을 가져야 함
    비밀번호는 문자로만 가능
*/
-- CREATE USER user1 IDENTIFIED BY 1234;
create user c##user2 IDENTIFIED by 1234;

-- c##키워드를 회피하는 설정
alter session set "_oracle_script" = true;

-- 수업시간에 사용할 user생성
/*
    계정명은 대소문자 안가림
    create user 계정명 identified by 비밀번호
*/
create user tjoeun identified by 1234;

-- 권한생성
/*
    [표현법] GRANT 권한1, 권한2, .... TO 계정명;
*/
GRANT RESOURCE, CONNECT TO TJOEUN;

-- USER 삭제
-- DROP USER USER명 CASCAED;

-- insert시 생성된 유저에게 테이블스페이스에 얼마만큼의 영역을 할당할 것인지 정해줘야함
alter user tjoeun default tablespace users quota unlimited on users;

-- 특정 용량만큼 정해서 할당
alter user tjoeun quota 30M on users;






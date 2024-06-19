/*
    * DCL(DATA CONTROL LANGUAGE) : 데이터 제어 언어
      계정(사용자)에게 시스템 권한 또는 객체접근권한을 부여(GRANT)하거나 회수(REVOKE)하는 구문
      
      >> 시스템 권한 : DB에 접근하는 권한, 객체를 생성할 수 있는 권한
           시스템 권한의 종류
           - CREATE SESSION : 접속할 수 있는 권한
           - CREATE TABLE : 테이블을 생성할 수 있는 권한
           - CREATE VIEW : 뷰 생성할 수 있는 권한
           - CREATE SEQUENCE : 시퀀스를 생성할 수 있는 권한
           ...
           
      >> 객체 접근 권한 : 특정 객체들을 조작할 수 있는 권한
          객체 접근 권한의 종류
          
          권한종류
          SELECT            TABLE, VIEW, SEQUENCE
          INSERT            TABLE, VIEW
          UPDATE           TABLE, VIEW
          DELETE            TABLE, VIEW
          ...    
*/

-------------------------------------------------------------------------
-- 시스템 권한
-- 1. SAMPLE / 1234  계정생성
alter session set "_oracle_script" = true;
CREATE USER SAMPLE IDENTIFIED BY 1234;

-- 2. 접속을 위한 권한 부여
GRANT CREATE SESSION TO SAMPLE;

-- 3. 테이블을 생성할 수 있는 권한 부여
GRANT CREATE TABLE TO SAMPLE;

-- 4. TABLESPACE 할당
ALTER USER SAMPLE QUOTA 2M ON USERS;
ALTER USER SAMPLE DEFAULT TABLESPACE USERS QUOTA UNLIMITED ON USERS;

----------------------------------------------------------------------------------------------------------
-- 객체 접근
-- 4. SAMPLE계정에게 TJOEUN계정의 EMPLOYEE을 SELECT할 수 있는 권한
GRANT SELECT ON TJOEUN.EMPLOYEE TO SAMPLE;

-- 5. SAMPLE계정에 TJOEUN계정의 EMPLOYEE을 INSERT할 수 있는 권한
GRANT INSERT ON TJOEUN.EMPLOYEE TO SAMPLE;

----------------------------------------------------------------------------------------------------------
-- 권한 회수
-- REVOKE 회수할권한 ON 테이블명 FROM 계정명;
REVOKE SELECT ON TJOEUN.EMPLOYEE FROM SAMPLE;
REVOKE INSERT ON TJOEUN.EMPLOYEE FROM SAMPLE;

----------------------------------------------------------------------------------------------------------
/*
    * ROLE
      : 특정 권한들을 하나의 집합으로 모아놓은 것
      
      CONNECT : CREATE + SESSION
      RESOURCE : CREATE TABLE + CREATE SEQUENCE + ...
      DBA : 시스템 및 객체관리에 대한 모든 권한을 갖고 있는 롤
      
      GRANT CONNECT, RESOURCE TO 계정명;
*/



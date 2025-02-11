/*
    <DCL : DATA CONTROL LANGUAGE> 데이터 제어 언어
    계정에게 시스템 권한 또는 객체접근할 수 있는 권한 부여(GRANT) 하거나 회수(REVOKE)하는 구문
    
    >> 시스템 권한 : DB에 접근하는 권한, 객체들을 생성할 수 있는 권한
         * 종류
            - CREATE SESSION : 접속할 수 있는 권한
            - CREATE TABLE : 테이블을 생성할 수 있는 권한
            - CREATE VIEW : 뷰를 생성할 수 있는 권한
            - CREATE SEQUENCE : 시퀀스를 생성할 수 있는 권한
              ...
    >> 객체 접근 권한 : 특정객체를 조작할 수 있는 권한  
*/

ALTER SESSION SET "_oracle_script" = true;
-- 1. SAMPLE / 1234  사용자 생성
CREATE USER SAMPLE IDENTIFIED BY 1234;
    -- 접속 못함. 접근 권한 없음

-- 2. 접속을 위한 CREATE SESSION 권한 부여    
GRANT CREATE SESSION TO SAMPLE;   
    -- 접속하여 테이블을 만들면 오류. 테이블을 만들수 있는 권한 없음
    
-- 3. 테이블을 생성할 수 있는 권한 부여
GRANT CREATE TABLE TO SAMPLE;

-- 4. 테이블에 데이터를 삽입하려면 tablespace를 줘야 한다
ALTER USER SAMPLE default tablespace users quota unlimited on users;

-----------------------------------------------------------------------------------------
/*
    * 객체 접근 권한 종류
      특정 객체에 접근하여 조작할 수 있는 권한
      
      권한의 종류
      SELECT        TABLE, VIEW, SEQUENCE
      INSERT        TABLE, VIEW
      UPDATE       TABLE, VIEW
      DELETE        TABLE, VIEW
      ....
      
      [표현식]
      GRANT 권한의 종류 ON 특정객체 TO 계정명;
*/

-- 5. SAMPLE계정에게 TJOEUN계정에 EMPLOYEE 테이블을 SELECT할 수 있는 권한
GRANT SELECT ON TJOEUN.EMPLOYEE TO SAMPLE;

-- 6. SAMPLE계정에게 TJOEUN계정에 EMPLOYEE 테이블을 INSERT할 수 있는 권한
GRANT INSERT ON TJOEUN.EMPLOYEE TO SAMPLE;

-- * 권한 회수
--   REVOKE 회수할 권한 ON 특정객체 FROM 계정명;
REVOKE SELECT ON TJOEUN.EMPLOYEE FROM SAMPLE;
REVOKE INSERT ON TJOEUN.EMPLOYEE FROM SAMPLE;

-----------------------------------------------------------------------------------------
/*
    <롤 ROLE>
    - 특정 권한들을 하나의 집합으로 모아놓은 것
    
    CONNECT : CREATE, SESSION
    RESOURCE : CREATE TABLE, CREATE SEQUENCE, ....
    DBA : 시스템 및 객체관리에 대한 모든 권한을 갖고 있는롤
*/

GRANT CONNECT, RESOURCE TO SAMPLE;


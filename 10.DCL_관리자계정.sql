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




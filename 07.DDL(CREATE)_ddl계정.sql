/*
    * DDL(DATA DEFINITION LANGUAGE) : 데이터 정의 언어
      : 오라클에서 제공하는 객체(OBJECT)를 만들고(CREATE), 구조를 변경(ALTER)하고, 구조 자체를 삭제(DROP)하는 언어
        즉, 실제 데이터 값이 아닌 구조 자체를 정의하는 언어
        주로 DB관리자, 설계자가 사용함
        
        - 오라클에서 객체(구조) : 테이블(TABLE), 뷰(VIEW), 시퀀스(SEQUENCE), 인덱스(INDEX),  패키지(PACKAGE)
                                            트리거(TRIGGER), 프로시저(PROCEDURE), 함수(FUNCTION), 동의어(SYNONYM), 사용자(USER)
*/
--==================================================================================
/*
    * CREATE
      : 객체를 생성하는 구문
*/
----------------------------------------------------------------------------------------------------------------------------------------------
/*
    1. 테이블 생성
       - 테이블이란 : 행(ROW)과 열(COLUMN)으로 구성되는 가장 기본적이 데이터베이스 객체
                            모든 데이터들은 테이블을 통해 저장됨
                            (표 형태를 DB에서는 테이블)
                            
       [표현식]
       CREATE TABLE 테이블명 (
            컬럼명 자료형(크기),
            컬럼명 자료형(크기),
            컬럼명 자료형,
            ....
        );
        
        * 자료형
        - 문자 (CHAR(바이트크기) | VARCHAR2(바이트크기) ) -> 반드시 크기 지정 해야됨
           > CHAR : 최대 2000byte까지 지정 가능
                         고정길이(지정한 크기보다 더 적은값이 들어와도 공백으로라도 채워서 처음 지정한 크기만큼 고정)
                         고정된 데이터를 넣을 때 사용
          >  VARCHAR2 : 최대 4000byte까지 지정 가능
                                 가변길이(들어온 값의 크기에 따라 달라짐)
                                 몇글자 들어올지 모를 때 사용
        - 숫자(NUMBER)
        - 날짜(DATE)
*/

-- 회원에 대한 데이터를 담기위한 테이블 MEMBER생성
CREATE TABLE MEMBER(
    MEM_NO NUMBER,
    MEM_ID VARCHAR2(20),
    MEM_PWD VARCHAR2(20),
    MEM_NAME VARCHAR2(20),
    GENDER CHAR(3),
    PHONE VARCHAR(13),
    EMAIL VARCHAR(50),
    MEM_DATE DATE
);

SELECT * FROM MEMBER;

-- 사용자가 가지고 있는 테이블정보
-- 데이터 딕셔너리 : 다양한 객체들의 정보를 저장하고 있는 시스템 테이블등
-- [참고] USER_TABLES : 이 사용자가 가지고 있는 테이블의 전반적인 구조를 확인할 수 있는 시스템 테이블
SELECT * FROM USER_TABLES;

-- [참고] USER_TAB_COLUMNS : 이 사용자가 가지고 있는 테이블의 모든 컬럼의 전반적인 구조를 확인할 수 있는 시스템 테이블
SELECT * FROM USER_TAB_COLUMNS;









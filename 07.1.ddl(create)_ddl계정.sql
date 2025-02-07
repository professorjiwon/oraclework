/*
    * DDL(DATA DEFINITION LANGUAGE) : 데이터 정의 언어
      오라클에서 제공하는 객체(OBJECT)를 만들고(CREATE), 구조를 변경하고(ALTER)하고, 구조를 삭제(DROP) 하는 언어
      즉, 실제 데이터 값이 아닌 구조 자체를 정의하는 언어
      주로 DB관리자, 설계자가 사용함
      
      오라클 객체(구조) : 테이블, 뷰, 시퀀스, 인덱스, 패키지, 트리거, 프로시저, 함수, 동의어, 사용자
*/

--==============================================================
--                                                   CREATE : 객체 생성
--==============================================================
/*
    1. 테이블 생성
      - 테이블이란 : 행과 열로 구성된 가장 기본적인 데이터베이스 객체
                         모든 데이터들은 테이블을 통해 저장됨
    
    [표현식]
    CREATE TABLE 테이블명 (
            컬럼명 자료형(크기),
            컬럼명 자료형(크기),
            컬럼명 자료형,
            ...
    );
    
     * 자료형
       - 문자 (CHAR(바이트크기) | VARCHAR2(바이트크기))  -> 반드시 크기지정 해야됨
         > CHAR : 최대 2000BYTE까지 지정 가능
                       고정 길이(지정한 크기보다 적은 값이 들와도 공백으로 채워서 지정한 크기만큼 고정)
                        고정된 길이의 데이터 사용시
         > VARCHAR2 : 최대 4000BYTE까지 지정 가능
                              가변길이(들어오는 값의 크기에 따라 공간이 맞춰짐)
                              데이터의 길이 일정하지 않을 때 사용
       - 숫자(NUMBER)
       - 날짜(DATE)
*/
-- 회원에 대한 테이블 (MEMBER 생성)
CREATE TABLE MEMBER(
    MEM_NO NUMBER,
    MEM_ID VARCHAR2(20),
    MEM_PWD VARCHAR2(20),
    MEM_NAME VARCHAR2(20),
    GENDER CHAR(3),
    PHONE VARCHAR2(15),
    EMAIL VARCHAR2(50),
    MEM_DATE DATE
);

---------------------------------------------------------------------------------------------------------
/*
    2. 컬럼에 주석 달기(컬럼에 대한 설명)
    
    [표현법]
    COMMENT ON COLUMN 테이블명.컬럼명 IS '주석내용';
    
    >> 잘못 작성하였을 경우 수정 후 다시 실행하면 됨
*/
COMMENT ON COLUMN MEMBER.MEM_NO IS '회원번호';
COMMENT ON COLUMN MEMBER.MEM_ID IS '회원아이디';
COMMENT ON COLUMN MEMBER.MEM_PWD IS '회원비밀번호';
COMMENT ON COLUMN MEMBER.MEM_NAME IS '회원이름';
COMMENT ON COLUMN MEMBER.GENDER IS '회원성별';
COMMENT ON COLUMN MEMBER.PHONE IS '회원전화번호';
COMMENT ON COLUMN MEMBER.EMAIL IS '회원이메일';
COMMENT ON COLUMN MEMBER.MEM_DATE IS '회원일';

COMMENT ON COLUMN MEMBER.MEM_DATE IS '회원가입일';

SELECT * FROM MEMBER;
INSERT INTO MEMBER VALUES(1, 'user01', 'pwd01', '홍길동', '남', '010-1234-5678', 'hong@naver.com', '25/02/07');
INSERT INTO MEMBER VALUES(2, 'user02', 'pwd02', '나순이', '여', '010-1982-2929', 'na@google.com', '25/02/06');

INSERT INTO MEMBER VALUES(NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL);
INSERT INTO MEMBER VALUES(3, 'user03', 'pwd03', '이고잉', NULL, NULL, NULL, NULL);

---------------------------------------------------------------------------------------------------------
/*
    <제약 조건>
    - 원하는 데이터값(유효한 형식의 값)만 유지하기 위해 특정 컬럼에 설정하는 제약
    - 데이터 무결성 보장을 목적으로 한다.
      : 데이터에 결합이 없는 상태, 즉 데이터가 정확하고 유효하게 유지된 상태
      1) 개체 무결성 제약조건 : NOT NULL, UNIQUE, PRIMARY KEY 조건 위배
      2) 참조 무결성 제약조건 : FOREIGN KEY(외래키) 조건 위배
      
    * 종류 : NOT NULL, UNIQUE, CHECK(조건), PRIMARY KEY, FOREIGN KEY
    
    * 제약조건을 부여하는 방식 2가지
      1) 컬럼 레벨 방식 : 컬럼명 자료형 옆에 기술
      2) 테이블 레벨 방식 : 모든 컬럼을 정의한 후 마지막 기술
*/

---------------------------------------------------------------------------------------------------------
/*
    * NOT NULL 제약조건
      해당 컬럼에 반드시 값이 존재해야 함(즉, NULL이 들어오면 안됨)
      삽입/수정시 NULL값을 허용하지 않는다
      
      **  주의사항 : 컬럼 레벨 방식밖에 안됨
*/
-- 컬럼 레벨 방식
CREATE TABLE MEM_NOTNULL (
    MEM_NO NUMBER NOT NULL,
    MEM_ID VARCHAR2(20) NOT NULL,
    MEM_PWD VARCHAR2(20) NOT NULL,
    MEM_NAME VARCHAR2(20) NOT NULL,
    GENDER CHAR(3),
    PHONE VARCHAR2(20),
    EMAIL VARCHAR2(50)
);

INSERT INTO MEM_NOTNULL VALUES(1, 'user01', 'pwd01', '홍길동', '남', '010-1234-5678', 'hong@naver.com');
INSERT INTO MEM_NOTNULL VALUES(2, 'user02', 'pwd02', '나순이', '여', '010-1982-2929', 'na@google.com');
INSERT INTO MEM_NOTNULL VALUES(3, 'user03', 'pwd03', '이고잉', NULL, NULL, NULL);


INSERT INTO MEM_NOTNULL VALUES(NULL, NULL, NULL, NULL, NULL, NULL, NULL);
-- NOT NULL 제약조건 위배 오류

INSERT INTO MEM_NOTNULL VALUES(3, 'user03', 'pwd03', '박한빛', NULL, NULL, NULL);
-- NO, ID가 중복 되었음에도 잘 추가

---------------------------------------------------------------------------------------------------------
/*
    * UNIQUE 제약 조건
      해당 컬럼에 중복된 값이 들어가서는 안됨
      컬럼값에 중복값을 제한하는 제약조건
      삽입/수정시 기존의 데이터와 동일한 중복값이 있을 때 오류 발생
      
      >> 컬럼 레벨 방식
          CREATE TABLE 테이블명(
                컬럼명 자료형 [CONSTRAINT 제약조건명] 제약조건,
                컬럼명 자료형
                ...
            );
            
       >> 테이블 레벨 방식  
          CREATE TABLE 테이블명(
                컬럼명 자료형,
                컬럼명 자료형
                ...,
                [CONSTRAINT 제약조건명] 제약조건(컬럼명),
                [CONSTRAINT 제약조건명] 제약조건(컬럼명),
            );
*/

-- 컬럼 레벨 방식
CREATE TABLE MEM_UNIQUE (
    MEM_NO NUMBER NOT NULL UNIQUE,
    MEM_ID VARCHAR2(20) NOT NULL UNIQUE,
    MEM_PWD VARCHAR2(20) NOT NULL,
    MEM_NAME VARCHAR2(20) NOT NULL,
    GENDER CHAR(3),
    PHONE VARCHAR2(20),
    EMAIL VARCHAR2(50)
);

INSERT INTO MEM_UNIQUE VALUES(1, 'user01', 'pwd01', '홍길동', '남', '010-1234-5678', 'hong@naver.com');
INSERT INTO MEM_UNIQUE VALUES(2, 'user02', 'pwd02', '나순이', '여', '010-1982-2929', 'na@google.com');
INSERT INTO MEM_UNIQUE VALUES(3, 'user03', 'pwd03', '이고잉', NULL, NULL, NULL);

INSERT INTO MEM_UNIQUE VALUES(3, 'user03', 'pwd03', '박한빛', NULL, NULL, NULL);
-- UNIQUE 제약 조건 위배


-- 테이블 레벨 방식
CREATE TABLE MEM_UNIQUE2 (
    MEM_NO NUMBER NOT NULL,
    MEM_ID VARCHAR2(20) NOT NULL,
    MEM_PWD VARCHAR2(20) NOT NULL,
    MEM_NAME VARCHAR2(20) NOT NULL,
    GENDER CHAR(3),
    PHONE VARCHAR2(20),
    EMAIL VARCHAR2(50),
    UNIQUE (MEM_NO),
    UNIQUE (MEM_ID)
);

-- 테이블 레벨 방식
CREATE TABLE MEM_UNIQUE3 (
    MEM_NO NUMBER CONSTRAINT NO_NULL NOT NULL,
    MEM_ID VARCHAR2(20) CONSTRAINT ID_NULL NOT NULL,
    MEM_PWD VARCHAR2(20) CONSTRAINT PWD_NULL NOT NULL,
    MEM_NAME VARCHAR2(20) CONSTRAINT NAME_NULL NOT NULL,
    GENDER CHAR(3),
    PHONE VARCHAR2(20),
    EMAIL VARCHAR2(50),
    CONSTRAINT NO_UNIQUE UNIQUE (MEM_NO),
    CONSTRAINT ID_UNIQUE UNIQUE (MEM_ID)
);

INSERT INTO MEM_UNIQUE3 VALUES(1, 'user01', 'pwd01', '홍길동', '남', '010-1234-5678', 'hong@naver.com');
INSERT INTO MEM_UNIQUE3 VALUES(2, 'user02', 'pwd02', '나순이', '여', '010-1982-2929', 'na@google.com');
INSERT INTO MEM_UNIQUE3 VALUES(3, 'user03', 'pwd03', '이고잉', NULL, NULL, NULL);

INSERT INTO MEM_UNIQUE3 VALUES(3, 'user03', 'pwd03', '박한빛', NULL, NULL, NULL);
-- UNIQUE 제약 조건 위배


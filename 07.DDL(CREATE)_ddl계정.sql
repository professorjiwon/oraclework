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
        - 숫자(NUMBER) : 정수, 실수, 음수, 양수
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

----------------------------------------------------------------------------------------------------------------------------------------------
/*
    2. 컬럼에 주석 달기
    
    [표현법]
    COMMENT ON COLUMN 테이블명.컬럼명 IS '주석내용';
    
    >> 잘못 작성을 했을 때 수정한 후 다시 실행하면 덮어쓰기 됨
*/
COMMENT ON COLUMN MEMBER.MEM_ID IS '회원아이디';
COMMENT ON COLUMN MEMBER.MEM_NO IS '회원번호';
COMMENT ON COLUMN MEMBER.MEM_PWD IS '회원비밀번호';
COMMENT ON COLUMN MEMBER.MEM_NAME IS '회원이름';
COMMENT ON COLUMN MEMBER.GENDER IS '회원성별(남,여)';
COMMENT ON COLUMN MEMBER.PHONE IS '회원전화번호';
COMMENT ON COLUMN MEMBER.EMAIL IS '회원이메일';
COMMENT ON COLUMN MEMBER.MEM_DATE IS '회원가입일';

COMMENT ON COLUMN MEMBER.MEM_DATE IS '가입일';

-- 테이블에 데이터를 추가시키는 구문
-- INSERT INTO 테이블명 VALUES();
INSERT INTO MEMBER VALUES(1, 'user01', 'pass01', '홍길동', '남','010-1234-5678', 'user01@naver.com', '24/06/01');
INSERT INTO MEMBER VALUES(2, 'user02', 'pass02', '남길동', '남',null, NULL, SYSDATE);

INSERT INTO MEMBER VALUES(NULL,NULL, NULL, NULL, NULL,null, NULL, NULL);

----------------------------------------------------------------------------------------------------------------------------------------------
/*
     * 제약조건(CONSTRAINTS)
        - 원하는 데이터값(유효한 형식의 값)만 유지하게 위해 특정 컬럼에 설정하는 제약
        - 데이터 무결성 보장을 목적으로 한다\
          : 데이터의 결함이 없는 상태, 즉 데이터가 정확하고 유효하게 유지된 상태
          1) 개체 무결성 제약 조건 : NOT NULL, UNIQUE, PRIMARY KEY 조건 위배
          2) 참조 무결성 제약 조건 : FOREIGN KEY(외래키) 조건 위배
          
          종류 : NOT NULL, UNIQUE, PRIMARY KEY, CHECK(조건), FOREIGN KEY
          
        - 제약조건을 부여하는 방식 2가지
         1) 컬럼 레벨 방식 : 컬럼명 자료형 옆에 기술
         2) 테이블 레벨 방식 : 모든 컬럼들을 나열한 후 마지막에 기술
*/

----------------------------------------------------------------------------------------------------------------------------------------------

/*
    * NOT NULL 제약조건
      해당 컬럼에 반드시 값이 존재해야만 할 경우(즉, 컬럼값에 NULL이 들어오면 안됨)
      삽입/수정시 NULL값을 허용하지 않도록 제한
      
      -->> 컬럼 레벨 방식만 가능
*/

-- NOT NULL 제약조건 
CREATE TABLE MEM_NOTNULL (
    MEM_NO NUMBER NOT NULL,
    MEM_ID VARCHAR2(20) NOT NULL,
    MEM_PWD VARCHAR2(20) NOT NULL,
    MEM_NAME VARCHAR2(20) NOT NULL,
    GENDER CHAR(3),
    PHONE VARCHAR2(13),
    EMAIL VARCHAR2(50)
);

INSERT INTO MEM_NOTNULL VALUES(1, 'user01', 'pass01', '이고잉', '여', '010-1234-5678', 'user01@gmail.com');
INSERT INTO MEM_NOTNULL VALUES(2, 'user01', null, '김고잉', '여', null, 'user01@gmail.com');  -- 비밀번호의 null값 허용 안함 오류
-- NOT NULL 제약조건에 위배되는 오류

INSERT INTO MEM_NOTNULL VALUES(1, 'user01', 'pass03', '김앤북', '여', '010-1234-0000', 'user03@gmail.com');

----------------------------------------------------------------------------------------------------------------------------------------------
/*
    * UNIQUE 제약조건
      : 해당 컬럼에 중복된 값이 들어가서는 안되는 경우
        삽입/ 수정시 기존에 있는 데이터의 중복값이 있을 경우 오류 발생
*/
-- 컬럼 레벨 방식
CREATE TABLE MEM_UNIQUE(
    MEM_NO NUMBER NOT NULL,
    MEM_ID VARCHAR(20) NOT NULL UNIQUE,
    MEM_PWD VARCHAR(20) NOT NULL,
    MEM_NAME VARCHAR(20) NOT NULL,
    GENDER CHAR(3),
    PHONE VARCHAR(20),
    EMAIL VARCHAR(50)
);

-- 테이블 레벨 방식
CREATE TABLE MEM_UNIQUE2(
    MEM_NO NUMBER NOT NULL,
    MEM_ID VARCHAR(20) NOT NULL,
    MEM_PWD VARCHAR(20) NOT NULL,
    MEM_NAME VARCHAR(20) NOT NULL,
    GENDER CHAR(3),
    PHONE VARCHAR(20),
    EMAIL VARCHAR(50),
    UNIQUE (MEM_ID)
);

INSERT INTO MEM_UNIQUE2 VALUES (1, 'user01', 'pass01', '이고잉', '여', '010-1234-5678', 'user01@gmail.com');
INSERT INTO MEM_UNIQUE2 VALUES (2, 'user01', 'pass01', '채규태', '여', '010-1234-5678', 'user01@gmail.com');
-- 오류 UNIQUE 제약조건 위배

-- 테이블 레벨 방식
-- 각 컬럼별로 중복값 확인
CREATE TABLE MEM_UNIQUE3(
    MEM_NO NUMBER NOT NULL,
    MEM_ID VARCHAR(20) NOT NULL,
    MEM_PWD VARCHAR(20) NOT NULL,
    MEM_NAME VARCHAR(20) NOT NULL,
    GENDER CHAR(3),
    PHONE VARCHAR(20),
    EMAIL VARCHAR(50),
    UNIQUE (MEM_NO),
    UNIQUE (MEM_ID)
);

-- 테이블 레벨 방식
-- 2개의 컬럼을 묶어서 중복값 확인( ex) (1, user01) != (1, user02)  )
CREATE TABLE MEM_UNIQUE4(
    MEM_NO NUMBER NOT NULL,
    MEM_ID VARCHAR(20) NOT NULL,
    MEM_PWD VARCHAR(20) NOT NULL,
    MEM_NAME VARCHAR(20) NOT NULL,
    GENDER CHAR(3),
    PHONE VARCHAR(20),
    EMAIL VARCHAR(50),
    UNIQUE (MEM_NO, MEM_ID)
); 
INSERT INTO MEM_UNIQUE4 VALUES (1, 'user01', 'pass01', '이고잉', '여', '010-1234-5678', 'user01@gmail.com');
INSERT INTO MEM_UNIQUE4 VALUES (2, 'user01', 'pass01', '채규태', '여', '010-1234-5678', 'user01@gmail.com');

INSERT INTO MEM_UNIQUE4 VALUES (3, 'user03', 'pass03', '우재남', 'ㄴ', '010-1234-5678', 'user01@gmail.com');
-- > 성별이 유효한 값이 아니어도 들어감

----------------------------------------------------------------------------------------------------------------------------------------------
/*
    * CHECK(조건식) 제약조건
      : 사용자가 정의 제약조건을 넣고 싶을 때
*/
-- 컬럼 레벨 방식
CREATE TABLE MEM_CHECK(
    MEM_NO NUMBER NOT NULL,
    MEM_ID VARCHAR2(20) NOT NULL UNIQUE,
    MEM_PWD VARCHAR2(20) NOT NULL,
    MEM_NAME VARCHAR2(20) NOT NULL,
    GENDER CHAR(3) CHECK(GENDER IN ('남','여')),
    PHONE VARCHAR2(13),
    EMAIL VARCHAR2(50)
);

-- 테이블 레벨 방식
CREATE TABLE MEM_CHECK2(
    MEM_NO NUMBER NOT NULL,
    MEM_ID VARCHAR2(20) NOT NULL,
    MEM_PWD VARCHAR2(20) NOT NULL,
    MEM_NAME VARCHAR2(20) NOT NULL,
    GENDER CHAR(3),
    PHONE VARCHAR2(13),
    EMAIL VARCHAR2(50),
    UNIQUE (MEM_ID),
    CHECK(GENDER IN ('남','여'))
);

INSERT INTO MEM_CHECK VALUES(1, 'user01', 'pass01', '이고잉', '여', '010-1234-5678', 'user01@gmail.com');
INSERT INTO MEM_CHECK VALUES(2, 'user02', 'pass02', '우재남', 'ㄴ', '010-1234-5678', 'user02@gmail.com');
-- CHECK 제약조건에 위배

----------------------------------------------------------------------------------------------------------------------------------------------
/*
    * PRIMARY KEY(기본키) 제약조건
      : 테이블에서 각 행들을 식별하기 위해 사용될 컬럼에 부여하는 제약조건(식별자 역할)
      
      EX) 회원번호, 학번, 사원번호, 주문번호, 예약번호, 운송장 번호, .....
      
      - PRIMARY KEY(기본키) 제약조건을 부여하면 NOT NULL + UNIQUE 제약조건을 의미
        >> 대체적으로 검색, 수정, 삭제할 때 기본키의 컬럼값을 이용함
        
        ** 주의사항 : 한 테이블당 오로지 1개만 설정 가능
*/
-- 컬럼 레벨 방식
CREATE TABLE MEM_PRIMARY(
    MEM_NO NUMBER PRIMARY KEY,
    MEM_ID VARCHAR2(20) NOT NULL UNIQUE,
    MEM_PWD VARCHAR2(20) NOT NULL,
    MEM_NAME VARCHAR2(20) NOT NULL,
    GENDER CHAR(3) CHECK(GENDER IN ('남','여')),
    PHONE VARCHAR2(13),
    EMAIL VARCHAR2(50)
);

/*
    * 제약조건 부여시 제약조건명까지 지어주는 방법
    
    >> 컬럼 레벨 방식
    CREATE TABLE 테이블명(
        컬럼명 자료형 [CONSTRAINT 제약조건명] 제약조건,
        컬럼명 자료형
    );
    
    >> 테이블 레벨 방식
    CREATE TABLE 테이블명(
        컬럼명 자료형,
        컬럼명 자료형,
        [CONSTRAINT 제약조건명] 제약조건(컬럼명)
    );
*/

-- 테이블 레벨 방식
CREATE TABLE MEM_PRIMARY3(
    MEM_NO NUMBER,
    MEM_ID VARCHAR2(20) NOT NULL CONSTRAINT ID_UNIQUE UNIQUE,
    MEM_PWD VARCHAR2(20) NOT NULL,
    MEM_NAME VARCHAR2(20) NOT NULL,
    GENDER CHAR(3) CONSTRAINT MEM_GENDER CHECK(GENDER IN ('남','여')),
    PHONE VARCHAR2(13),
    EMAIL VARCHAR2(50),
    CONSTRAINT MEM_PK PRIMARY KEY(MEM_NO)
);

INSERT INTO MEM_PRIMARY3 VALUES(1, 'user01', 'pass01', '홍길동', '남', null, null);
INSERT INTO MEM_PRIMARY3 VALUES(2, 'user02', 'pass02', '우재남', '남', null, null);
INSERT INTO MEM_PRIMARY3 VALUES(2, 'user03', 'pass03', '이고잉', '여', null, null);

/*
    * 복합키
      : 2개이상의 컬럼을 묶어서 하나의 기본키로 설정됨
      
      >> 테이블 레벨 방식으로만 가능

      - 복합키 사용 예시(찜 기능)
        1, A    --> 2개를 묶어서 하나의 기본키 역할을 함
        1, B
        1, A    --> 오류 떠야 됨
        2, A
        2, B
        2, C
*/

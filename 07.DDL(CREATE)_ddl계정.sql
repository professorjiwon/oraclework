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
        - 데이터 무결성 보장을 목적으로 한다
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

-- 오류
INSERT INTO MEM_PRIMARY3 VALUES(2, 'user03', 'pass03', '이고잉', '여', null, null);   -- unique
INSERT INTO MEM_PRIMARY3 VALUES(null, 'user03', 'pass03', '이고잉', '여', null, null);  -- null

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

CREATE TABLE TB_LIKE(
    MEM_NO NUMBER,
    PRODUCT_NAME VARCHAR2(20),
    LIKE_DATE DATE,
    PRIMARY KEY(MEM_NO, PRODUCT_NAME)
);

INSERT INTO TB_LIKE VALUES(1, 'A', SYSDATE);
INSERT INTO TB_LIKE VALUES(1, 'B', SYSDATE);

INSERT INTO TB_LIKE VALUES(2, 'A', SYSDATE);
INSERT INTO TB_LIKE VALUES(2, 'B', SYSDATE);

-- 복합키 제약조건 오류
INSERT INTO TB_LIKE VALUES(1, 'A', SYSDATE);
INSERT INTO TB_LIKE VALUES(2, 'B', SYSDATE);

-- 복합키도 기본키이기 때문에 NOT NULL + UNIQUE 다 맞아야 됨
--  각 컬럼은 NULL값 안되고, 2개의 컬럼을 합쳐서 유일해야 됨
INSERT INTO TB_LIKE VALUES(3, NULL, SYSDATE);

--===================================================================
-- 회원등급 테이블과 회원테이블 2개 생성
-- 회원 등급 테이블
CREATE TABLE MEM_GRADE(
    GRADE_CODE NUMBER PRIMARY KEY,
    GRADE_NAME VARCHAR2(30) NOT NULL
);
INSERT INTO MEM_GRADE VALUES(10, '일반회원');
INSERT INTO MEM_GRADE VALUES(20, '우수회원');
INSERT INTO MEM_GRADE VALUES(30, '특별회원');

-- 회원 테이블
CREATE TABLE MEM(
    MEM_NO NUMBER CONSTRAINT PK PRIMARY KEY,
    MEM_ID VARCHAR(20) NOT NULL UNIQUE,
    MEM_PW VARCHAR(20) NOT NULL,
    MEM_NAME VARCHAR2(20) NOT NULL,
    GENDER CHAR(3) CONSTRAINT GEN CHECK(GENDER IN ('남', '여')),
    GRADE_ID NUMBER  
);

INSERT INTO MEM VALUES(1, 'user01', 'pass01', '이고잉', '여', 10);
INSERT INTO MEM VALUES(2, 'user02', 'pass02', '우재남', '남', 30);
INSERT INTO MEM VALUES(3, 'user03', 'pass03', '채규태', '남', 100);
-- 유효한 회원등급번호가 아님에도 불구하고 입력됨

----------------------------------------------------------------------------------------------------------------------------------------------
/*
    * 외래키(FOREIGN KEY) 제약조건
      : 다른 테이블에 존재하는 값만 들어와야되는 특정컬럼에 부여하는 제약조건
       --> 다른 테이블을 참조한다고 표현
       --> 주로 외래키 제약조건에 의해 테이블 간의 관계가 형성됨
       
     >> 컬럼 레벨 방식 : 참조할컬럼명이 primary key 였을 때 생략 가능
           컬럼명 자료형 [CONSTRAINT 제약조건명] REFERENCES 참조할테이블명 [(참조할컬럼명)]
           
     >> 테이블 레벨 방식
          [CONSTRAINT 제약조건명] FOREIGN KEY(컬럼명) REFERENCES 참조할테이블명 [(참조할컬럼명)]      
*/

CREATE TABLE MEM2(
    MEM_NO NUMBER PRIMARY KEY,
    MEM_ID VARCHAR(20) NOT NULL UNIQUE,
    MEM_PW VARCHAR(20) NOT NULL,
    MEM_NAME VARCHAR2(20) NOT NULL,
    GENDER CHAR(3) CHECK(GENDER IN ('남', '여')),
    GRADE_ID NUMBER REFERENCES MEM_GRADE(GRADE_CODE)     -- 컬럼 레벨 방식
--    , FOREIGN KEY(GRADE_ID) REFERENCES MEM_GRADE(GRADE_CODE)   -- 테이블 레벨 방식
);
INSERT INTO MEM2 VALUES(1, 'user01', 'pass01', '이고잉', '여', 10);
INSERT INTO MEM2 VALUES(2, 'user02', 'pass02', '우재남', '남', 30);
INSERT INTO MEM2 VALUES(3, 'user03', 'pass03', '채규태', '남', NULL);
-- 외래키 제약조건은 기본적으로 NULL값을 허용함

INSERT INTO MEM2 VALUES(3, 'user03', 'pass03', '채규태', '남', 100);
--  외래키 제약조건 위배
--  MEM_GRADE(부모테이블) -|--------<-- MEM2 (자식테이블)

--> 이때 부모테이블에서 데이터값을 삭제할 경우 문제 발생
--  데이터삭제 : DELETE FROM 테이블명 WHERE 조건;

-- 자식테이블에서 사용하지 않는 컬럼값은 삭제 가능
DELETE FROM MEM_GRADE
WHERE GRADE_CODE = 20;

-- 자식테이블에서 사용하고 있는 컬럼값은 삭제 불가
DELETE FROM MEM_GRADE
WHERE GRADE_CODE = 10;

----------------------------------------------------------------------------------------------------------------------------------------------
/*
    * 자식테이블 생성시 외래키 제약조건 부여할 때 삭제옵션 지정 가능
      - 삭제 옵션 : 부모테이블의 데이터 삭제 시 자식테이블이 사용하고 있는 값을 어떻게 처리할지
      
      1) ON DELETE RESTRICTED(기본값) : 삭제 제한 옵션으로, 자식테이블이 쓰고 있는 값이면 부모테이블에서 삭제 안됨
      2) ON DELETE SET NULL : 부모테이블의 데이터 삭제시 자식테이블이 쓰고 있는 값들을 NULL로 변경하고 부모테이블의 행 삭제
      3) ON DELETE CASCADE : 부모테이블의 데이터 삭제시 자식테이블이 쓰고 있는 행도 삭제
*/
DROP TABLE MEM;
DROP TABLE MEM2;

-- 외래키 생성시 참조테이블명만 넣으면 참조테이블의 기본키의 컬럼이 자동으로 설정됨
CREATE TABLE MEM(
    MEM_NO NUMBER PRIMARY KEY,
    MEM_ID VARCHAR(20) NOT NULL UNIQUE,
    MEM_PW VARCHAR(20) NOT NULL,
    MEM_NAME VARCHAR2(20) NOT NULL,
    GENDER CHAR(3) CHECK(GENDER IN ('남', '여')),
    GRADE_ID NUMBER REFERENCES MEM_GRADE ON DELETE SET NULL
);

INSERT INTO MEM VALUES(1, 'user01', 'pass01', '이고잉', '여', 10);
INSERT INTO MEM VALUES(2, 'user02', 'pass02', '우재남', '남', 30);
INSERT INTO MEM VALUES(3, 'user03', 'pass03', '송미영', '여', 20);
INSERT INTO MEM VALUES(4, 'user04', 'pass04', '김앤북', '남', 30);
INSERT INTO MEM VALUES(5, 'user05', 'pass05', '채규태', '남', NULL);

DELETE FROM MEM_GRADE WHERE GRADE_CODE = 30;
-- 삭제됨 자식은 NULL값으로 바뀜

DROP TABLE MEM;

CREATE TABLE MEM(
    MEM_NO NUMBER PRIMARY KEY,
    MEM_ID VARCHAR(20) NOT NULL UNIQUE,
    MEM_PW VARCHAR(20) NOT NULL,
    MEM_NAME VARCHAR2(20) NOT NULL,
    GENDER CHAR(3) CHECK(GENDER IN ('남', '여')),
    GRADE_ID NUMBER REFERENCES MEM_GRADE ON DELETE CASCADE
);

INSERT INTO MEM_GRADE VALUES(30, '특별회원');
INSERT INTO MEM VALUES(1, 'user01', 'pass01', '이고잉', '여', 10);
INSERT INTO MEM VALUES(2, 'user02', 'pass02', '우재남', '남', 30);
INSERT INTO MEM VALUES(3, 'user03', 'pass03', '송미영', '여', 20);
INSERT INTO MEM VALUES(4, 'user04', 'pass04', '김앤북', '남', 30);
INSERT INTO MEM VALUES(5, 'user05', 'pass05', '채규태', '남', NULL);

DELETE FROM MEM_GRADE WHERE GRADE_CODE = 30;

----------------------------------------------------------------------------------------------------------------------------------------------
/*
    * DEFAULT 값 설정하기
      컬럼의 값이 들어오지 않았을 때 기본값으로 넣어줌
      
      컬럼명 자료형 DEFAULT 기본값 [제약조건]
*/
CREATE TABLE MEMBER2 (
    MEM_NO NUMBER,
    MEM_ID VARCHAR2(20) NOT NULL,
    MEM_AGE NUMBER,
    HOBBY VARCHAR2(20) DEFAULT '없음',
    MEM_DATE DATE DEFAULT SYSDATE,
    PRIMARY KEY(MEM_NO)
);
INSERT INTO MEMBER2 VALUES(1, 'user01', 25, '잠자기', '24/06/13');
INSERT INTO MEMBER2 VALUES(2, 'user02', null, null, null);
INSERT INTO MEMBER2 VALUES(3, 'user03', 27, default, default);

INSERT INTO MEMBER2 (MEM_NO, MEM_ID, MEM_AGE) VALUES(4, 'user04', 25);


--=======================================================================
------------------------------------- tjoeun 계정에서 실행 ---------------------------------------------
/*
    * SUBQUERY를 이용한 테이블 생성
       테이블 복사하는 개념
       
       [표현식]
       CREATE TABLE 테이블명 AS 서브쿼리;     
*/
-- EMPLOYEE테이블을 복제(컬럼값까지)한 새로운 테이블 생성
CREATE TABLE EMPLOYEE_COPY
AS SELECT *
      FROM EMPLOYEE;
-- 컬럼, 데이터값 복사 됨
-- 제약조건은 NOT NULL만 복사됨. 나머지는 안됨
--     FRIMARY KEY, DEFAULT, COMMENT...는 복사안됨

-- EMPLOYEE테이블을 복제(컬럼값제외 구조만)한 새로운 테이블 생성
CREATE TABLE EMPLOYEE_COPY2
AS SELECT *
      FROM EMPLOYEE
      WHERE 1=0;
      
-- EMPLOYEE테이블을 복제(컬럼값제외 구조만)한 컬럼을 내가 원하는 컬럼만으로 새로운 테이블 생성
CREATE TABLE EMPLOYEE_COPY3
AS SELECT EMP_ID, EMP_NAME, SALARY
      FROM EMPLOYEE
      WHERE 1=0;
      
-- EMPLOYEE테이블을 복제(컬럼값제외 구조만)한 컬럼을 기준테이블에 없는 컬럼도 생성
CREATE TABLE EMPLOYEE_COPY4
AS SELECT EMP_ID, EMP_NAME, SALARY, SALARY*12 연봉
      FROM EMPLOYEE;
      -- 서브쿼리 SELECT절에 산술식 또는 함수식이 기술된 경우 반드시 별칭을 지정해야 됨
      
--------------------------------------------------------------------------------------------------------------
/*
    * 테이블 생성 후 제약조건 추가
      ALTER TABLE 테이블명 변경할 내용
       - PRIMARY KEY : ALTER TABLE 테이블명 ADD PRIMARY KEY(컬럼명)
       - FOREIGN KEY : ALTER TABLE 테이블명 ADD FOREIGN KEY(컬럼명) REFERENCES 참조할테이블명 [(참조할컬럼명)]
       - UNIQUE : ALTER TABLE 테이블명 ADD UNIQUE(컬럼명)
       - CHECK : ALTER TABLE 테이블명 ADD CHECK(컬럼에 대한 조건식)
       - NOT NULL : ALTER TABLE 테이블명 MODIFY 컬럼명 NOT NULL
*/
-- EMPLOYEE_COPY 테이블에 PRIMARY KEY 제약 조건 추가
ALTER TABLE EMPLOYEE_COPY ADD PRIMARY KEY(EMP_ID);

-- EMPLOYEE_COPY 테이블에 외래키 제약 조건 추가
ALTER TABLE EMPLOYEE_COPY ADD FOREIGN KEY(DEPT_CODE) REFERENCES DEPARTMENT;

-- COMMENT
COMMENT ON COLUMN EMPLOYEE_COPY.EMP_ID IS '사원아이디';


----------------------------------------------------- 연습문제 ---------------------------------------------------
--  DDL 계정에서
/*
도서관리 프로그램을 만들기 위한 테이블들 만들기
이때, 제약조건에 이름을 부여할 것.
       각 컬럼에 주석달기

1. 출판사들에 대한 데이터를 담기위한 출판사 테이블(TB_PUBLISHER)
   컬럼  :  PUB_NO(출판사번호) NUMBER -- 기본키(PUBLISHER_PK) 
	PUB_NAME(출판사명) VARCHAR2(50) -- NOT NULL(PUBLISHER_NN)
	PHONE(출판사전화번호) VARCHAR2(13) - 제약조건 없음

   - 3개 정도의 샘플 데이터 추가하기


2. 도서들에 대한 데이터를 담기위한 도서 테이블(TB_BOOK)
   컬럼  :  BK_NO (도서번호) NUMBER -- 기본키(BOOK_PK)
	BK_TITLE (도서명) VARCHAR2(50) -- NOT NULL(BOOK_NN_TITLE)
	BK_AUTHOR(저자명) VARCHAR2(20) -- NOT NULL(BOOK_NN_AUTHOR)
	BK_PRICE(가격) NUMBER
	BK_PUB_NO(출판사번호) NUMBER -- 외래키(BOOK_FK) (TB_PUBLISHER 테이블을 참조하도록)
			         이때 참조하고 있는 부모데이터 삭제 시 자식 데이터도 삭제 되도록 옵션 지정
   - 5개 정도의 샘플 데이터 추가하기


3. 회원에 대한 데이터를 담기위한 회원 테이블 (TB_MEMBER)
   컬럼명 : MEMBER_NO(회원번호) NUMBER -- 기본키(MEMBER_PK)
   MEMBER_ID(아이디) VARCHAR2(30) -- 중복금지(MEMBER_UQ)
   MEMBER_PWD(비밀번호)  VARCHAR2(30) -- NOT NULL(MEMBER_NN_PWD)
   MEMBER_NAME(회원명) VARCHAR2(20) -- NOT NULL(MEMBER_NN_NAME)
   GENDER(성별)  CHAR(1)-- 'M' 또는 'F'로 입력되도록 제한(MEMBER_CK_GEN)
   ADDRESS(주소) VARCHAR2(70)
   PHONE(연락처) VARCHAR2(13)
   STATUS(탈퇴여부) CHAR(1) - 기본값으로 'N' 으로 지정, 그리고 'Y' 혹은 'N'으로만 입력되도록 제약조건(MEMBER_CK_STA)
   ENROLL_DATE(가입일) DATE -- 기본값으로 SYSDATE, NOT NULL 제약조건(MEMBER_NN_EN)

   - 5개 정도의 샘플 데이터 추가하기


4. 어떤 회원이 어떤 도서를 대여했는지에 대한 대여목록 테이블(TB_RENT)
   컬럼  :  RENT_NO(대여번호) NUMBER -- 기본키(RENT_PK)
	RENT_MEM_NO(대여회원번호) NUMBER -- 외래키(RENT_FK_MEM) TB_MEMBER와 참조하도록
			이때 부모 데이터 삭제시 자식 데이터 값이 NULL이 되도록 옵션 설정
	RENT_BOOK_NO(대여도서번호) NUMBER -- 외래키(RENT_FK_BOOK) TB_BOOK와 참조하도록
			이때 부모 데이터 삭제시 자식 데이터 값이 NULL값이 되도록 옵션 설정
	RENT_DATE(대여일) DATE -- 기본값 SYSDATE

   - 3개 정도 샘플데이터 추가하기
*/
-- 1.
CREATE TABLE TB_PUBLISHER(
    PUB_NO NUMBER CONSTRAINT PUBLISHER_PK PRIMARY KEY,
    PUB_NAME  VARCHAR2(50) CONSTRAINT PUBLISHER_NN NOT NULL,
    PHONE VARCHAR2(13)
);
COMMENT ON COLUMN TB_PUBLISHER.PUB_NO IS '출판사번호';
COMMENT ON COLUMN TB_PUBLISHER.PUB_NAME IS '출판사명';
COMMENT ON COLUMN TB_PUBLISHER.PHONE IS '출판사전화번호';

-- 2. 
CREATE TABLE TB_BOOK(
    BK_NO NUMBER CONSTRAINT BOOK_PK PRIMARY KEY,
    BK_TITLE  VARCHAR2(50) CONSTRAINT BOOK_NN_TITLE NOT NULL,
    BK_AUTHOR  VARCHAR2(20) CONSTRAINT BOOK_NN_AUTHOR NOT NULL,
    BK_PRICE NUMBER,
    BK_PUB_NO NUMBER CONSTRAINT BOOK_FK REFERENCES TB_PUBLISHER ON DELETE CASCADE
);
COMMENT ON COLUMN TB_BOOK.BK_NO IS '도서번호';
COMMENT ON COLUMN TB_BOOK.BK_TITLE IS '도서명';
COMMENT ON COLUMN TB_BOOK.BK_AUTHOR IS '저자명';
COMMENT ON COLUMN TB_BOOK.BK_PRICE IS '가격';
COMMENT ON COLUMN TB_BOOK.BK_PUB_NO IS '출판사번호';

--3.
CREATE TABLE TB_MEMBER (
    MEMBER_NO NUMBER CONSTRAINT MEMBER_PK PRIMARY KEY,
    MEMBER_ID  VARCHAR2(30) CONSTRAINT MEMBER_UQ UNIQUE,
    MEMBER_PW  VARCHAR2(30) CONSTRAINT MEMBER_NN_PWD NOT NULL,
    MEMBER_NAME  VARCHAR2(20) CONSTRAINT MEMBER_NN_NAME NOT NULL,
    GENDER CHAR(1) CONSTRAINT MEMBER_CK_GEN CHECK(GENDER IN ('M', 'F')),
    ADDRESS VARCHAR2(70),
    PHONE VARCHAR2(13),
    STATUS CHAR(1) DEFAULT 'N' CONSTRAINT MEMBER_CK_STA CHECK(STATUS IN ('Y', 'N')),
    ENROLL_DATE DATE DEFAULT SYSDATE CONSTRAINT MEMBER_NN_EN NOT NULL
);

-- 4.
CREATE TABLE TB_RENT (
    RENT_NO NUMBER CONSTRAINT RENT_PK PRIMARY KEY,
    RENT_MEM_NO NUMBER CONSTRAINT RENT_FK_MEM REFERENCES TB_MEMBER ON DELETE SET NULL,
    RENT_BOOK_NO NUMBER CONSTRAINT RENT_FK_BOOK REFERENCES TB_BOOK ON DELETE SET NULL,
    RENT_DATE DATE DEFAULT SYSDATE
);
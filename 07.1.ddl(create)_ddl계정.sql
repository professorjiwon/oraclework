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
    CREATE TABLE(객체명) 테이블명(객체이름) (
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
      : 데이터에 결함이 없는 상태, 즉 데이터가 정확하고 유효하게 유지된 상태
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
    UNIQUE(MEM_NO),
    UNIQUE(MEM_ID)
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

INSERT INTO MEM_UNIQUE3 VALUES(4, 'user04', 'pwd04', '박아름', 'ㄱ', NULL, NULL);
--> 성별이 유효한 값이 아니어도 입력됨

---------------------------------------------------------------------------------------------------------
/*
    * CHECK(조건식) 제약조건
      해당 컬럼값에 들어올 수 있는 값에 대한 조건을 제시
      해당 조건에 맞는 데이터값만 입력하도록 함
*/


CREATE TABLE MEM_CHECK (
    MEM_NO NUMBER NOT NULL,
    MEM_ID VARCHAR2(20) NOT NULL,
    MEM_PWD VARCHAR2(20) NOT NULL,
    MEM_NAME VARCHAR2(20) NOT NULL,
    GENDER CHAR(3), -- CHECK(GENDER IN ('남', '여')),   -- 컬럼 레벨 방식
    PHONE VARCHAR2(20),
    EMAIL VARCHAR2(50),
    UNIQUE (MEM_NO),
    CHECK(GENDER IN ('남', '여'))   -- 테이블 레벨 방식
);

INSERT INTO MEM_CHECK VALUES(1, 'user01', 'pwd01', '홍길동', '남', '010-1234-5678', 'hong@naver.com');
INSERT INTO MEM_CHECK VALUES(2, 'user02', 'pwd02', '나순이', '영', '010-1982-2929', 'na@google.com');
-- CHECK 제약조건 위배

---------------------------------------------------------------------------------------------------------
/*
    * PRIMARY KEY(기본키) 제약조건
      테이블에서 각 행들을 식별하기 위해 사용될 컬럼에 부여하는 제약조건(식별자 역할)
      그 컬럼에 NOT NULL + UNIQUE 제약조건 ->  검색, 삭제, 수정 등에 기본키의 컬럼을 이용한
      EX) 회원번호, 학번, 사원번호, 운송장 번호, 예약번호, 주문번호....
      
      ** 유의 사항 : 한테이블 당 오로지 한개만 설정 가능
*/
-- 컬럼 레벨 방식
CREATE TABLE MEM_PRIMARY (
    MEM_NO NUMBER PRIMARY KEY,
    MEM_ID VARCHAR2(20) NOT NULL UNIQUE,
    MEM_PWD VARCHAR2(20) NOT NULL,
    MEM_NAME VARCHAR2(20) NOT NULL,
    GENDER CHAR(3) CHECK(GENDER IN ('남', '여')),
    PHONE VARCHAR2(20),
    EMAIL VARCHAR2(50)
);

-- 테이블 레벨 방식
CREATE TABLE MEM_PRIMARY2 (
    MEM_NO NUMBER,
    MEM_ID VARCHAR2(20) NOT NULL,
    MEM_PWD VARCHAR2(20) NOT NULL,
    MEM_NAME VARCHAR2(20) NOT NULL,
    GENDER CHAR(3),
    PHONE VARCHAR2(20),
    EMAIL VARCHAR2(50),
    PRIMARY KEY(MEM_NO),
    UNIQUE(MEM_ID),
    CHECK(GENDER IN ('남', '여'))
);

CREATE TABLE MEM_PRIMARY3 (
    MEM_NO NUMBER PRIMARY KEY,
    MEM_ID VARCHAR2(20) PRIMARY KEY  -- 오류 : PRIMARY KEY는 한개만 가능 
);

INSERT INTO MEM_PRIMARY VALUES(1, 'user01', 'pwd01', '홍길동', '남', '010-1234-5678', 'hong@naver.com');
INSERT INTO MEM_PRIMARY VALUES(2, 'user02', 'pwd02', '나순이', '여', '010-1982-2929', 'na@google.com');
INSERT INTO MEM_PRIMARY VALUES(NULL, 'user02', 'pwd02', '나순이', '여', '010-1982-2929', 'na@google.com');
INSERT INTO MEM_PRIMARY VALUES(2, 'user03', 'pwd03', '나순이', '여', '010-1982-2929', 'na@google.com');

-- 오류 : PRIMARY KEY는 하나만 가능
CREATE TABLE TB_MULTI2 (
    MEM_NO NUMBER,
    PRODUCT_NAME VARCHAR2(10),
    LIKE_DATE DATE,
    PRIMARY KEY(MEM_NO), 
    PRIMARY KEY(PRODUCT_NAME)
);

/*
    * 복합키 : 기본키를 2개 이상의 컬럼을 묶어서 사용
    
    - 복합키 사용 예) 찜하기
    회원번호 |  상품
        1       |    A   ->   1A
        1       |    A          부적합
        1       |    B   ->   1B
        1       |    C   ->   1C
        2       |    A   ->   2A
        2       |    C   ->   2C
*/
CREATE TABLE TB_MULTI (
    MEM_NO NUMBER,
    PRODUCT_NAME VARCHAR2(10),
    LIKE_DATE DATE,
    PRIMARY KEY(MEM_NO, PRODUCT_NAME)
);

INSERT INTO TB_MULTI VALUES(1, 'A' ,SYSDATE);
INSERT INTO TB_MULTI VALUES(1, 'B', SYSDATE);
INSERT INTO TB_MULTI VALUES(2, 'B', SYSDATE);
INSERT INTO TB_MULTI VALUES(1, 'B', SYSDATE);  --> 오류

---------------------------------------------------------------------------------------------------------
-- 회원등급에 대한 테이블 생성
CREATE TABLE MEM_GRADE (
    GRADE_CODE NUMBER PRIMARY KEY,
    GRADE_NAME VARCHAR2(30) NOT NULL
);

-- 10 : 일반회원, 20 : 우수회원, 30 : 특별회원
INSERT INTO MEM_GRADE VALUES(10, '일반회원');
INSERT INTO MEM_GRADE VALUES(20, '우수회원');
INSERT INTO MEM_GRADE VALUES(30, '특별회원');

-- 회원 정보 테이블 생성
CREATE TABLE MEM(
    MEM_NO NUMBER PRIMARY KEY,
    MEM_ID VARCHAR2(20) NOT NULL UNIQUE,
    MEM_PWD VARCHAR2(20) NOT NULL,
    MEM_NAME VARCHAR2(20) NOT NULL,
    GENDER CHAR(3) CHECK(GENDER IN ('남', '여')),
    PHONE VARCHAR2(20),
    EMAIL VARCHAR2(50),
    GRADE_ID NUMBER   -- 회원 등급 보관 컬럼
);

INSERT INTO MEM VALUES(1, 'user01', 'pwd01', '홍길동', '남', '010-1234-5678', 'hong@naver.com', NULL);
INSERT INTO MEM VALUES(2, 'user02', 'pwd02', '나순이', '여', '010-1982-2929', 'na@google.com', 10);
INSERT INTO MEM VALUES(3, 'user03', 'pwd03', '김순이', '여', '010-1982-2929', 'na@google.com', 50);
-- 유효한 회원 등급이 아님에도 입력됨

---------------------------------------------------------------------------------------------------------
/*
    * FOREIGN KEY(외래키) 제약조건
      다른 테이블에 존재하는 값만 들어와야 되는 컬럼에 부여하는 제약조건
      --> 다른 테이블을 참조한다라고 표현
      --> 주로 FOREIGN KEY 제약조건에 의해 테이블 간의 관계가 형성됨
      
      >> 컬럼 레벨 방식
           -  컬럼명 자료형 REFERENCES 참조할테이블명(참조할컬럼명)
              컬럼명 자료형 [CONSTRAINT 제약조건명] REFERENCES 참조할테이블명(참조할컬럼명)
                
      >> 테이블 레벨 방식
          - FOREIGN KEY(컬럼명) REFERENCES 참조할테이블명(참조할컬럼명)
            [CONSTRAINT 제약조건명] FOREIGN KEY(컬럼명) REFERENCES 참조할테이블명(참조할컬럼명)
*/

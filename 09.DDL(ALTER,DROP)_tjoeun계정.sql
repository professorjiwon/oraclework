/*
    * ALTER
      객체를 변경하는 구문
      
      [표현식]
       ALTER TABLE 테이블명 변경할내용;
       
       - 변경할 내용
          1) 컬럼 추가 / 수정 / 삭제
          2) 제약조건 추가 / 삭제  -> 수정불가(수정하려면 삭제하고 다시 새로 추가)
          3) 컬럼명 / 제약조건명 / 테이블명 변경     
*/
----------------------------------------------------------------------------------------------------------
/*
    1) 컬럼 추가 / 수정 / 삭제
*/
/*
        1.1 컬럼 추가 (ADD)  
        
        [표현법]
        ADD 컬럼명 데이터타입 [DEFAULT 기본값]
*/
-- DEPT_COPY에 CNAME컬럼 추가
ALTER TABLE DEPT_COPY ADD CNAME VARCHAR2(20);

-- DEPT_COPY에 LNAME컬럼 추가 기본값으로 '한국'
ALTER TABLE DEPT_COPY ADD LNAME VARCHAR2(30) DEFAULT '한국';

/*
        1.2 컬럼 수정 (MODIFY)  
        
        [표현법]
        -데이터 타입 수정
          MODIFY 컬럼명 바꾸고자하는데이터타입
          
       - DEFAULT 값 수정
         MODIFY 컬럼명 DEFAULT 바꾸고자하는기본값
*/
-- DEPT_COPY테이블의 DEPT_ID의 자료형 CHAR(3) 변경
ALTER TABLE DEPT_COPY MODIFY DEPT_ID CHAR(3);

-- DEPT_COPY테이블의 DEPT_ID의 자료형 NUMBER 변경
-- 오류 : 숫자로 변경할 수 없는 값이 들어있어서
ALTER TABLE DEPT_COPY MODIFY DEPT_ID NUMBER;

-- DEPT_COPY테이블의 DEPT_TITLE의 자료형 VARCHAR2(10) 변경
-- 오류 : 들어있는 데이터값이 변경하고자하는 자료형보다 큰 값이 들어있기 때문
ALTER TABLE DEPT_COPY MODIFY DEPT_TITLE VARCHAR2(10);

-- DEPT_COPY테이블의 DEPT_TITLE의 자료형 VARCHAR2(40) 변경
-- DEPT_COPY테이블의 LOCATION_ID 자료형 VARCHAR2(2) 변경
-- DEPT_COPY테이블의 LNAME컬럼의 기본값을 '미국'으로 변경

-- 다중변경 가능
ALTER TABLE DEPT_COPY
          MODIFY DEPT_TITLE VARCHAR2(40)
          MODIFY LOCATION_ID VARCHAR2(2)
          MODIFY LNAME DEFAULT '미국';

/*
        1.3 컬럼 삭제  
        
        [표현법]
        DROP COLUMN 컬럼명
*/
-- DEPT_COPY테이블에서 CNAME컬럼 삭제
ALTER TABLE DEPT_COPY DROP COLUMN CNAME;
-- DROP은 다중 삭제 안됨


ALTER TABLE DEPT_COPY DROP COLUMN DEPT_TITLE;
ALTER TABLE DEPT_COPY DROP COLUMN LOCATION_ID;
ALTER TABLE DEPT_COPY DROP COLUMN LNAME;

-- 테이블에서 최소한 1개의 컬럼은 존재해야 한다
ALTER TABLE DEPT_COPY DROP COLUMN DEPT_ID;  -- 오류

---------------------------------------------------------------------------------------------------------------------------------
/*
    * 제약조건 추가 / 삭제
      > 제약조건 추가
           ALTER TABLE 테이블명 변경할 내용
       - PRIMARY KEY : ALTER TABLE 테이블명 ADD PRIMARY KEY(컬럼명)
       - FOREIGN KEY : ALTER TABLE 테이블명 ADD FOREIGN KEY(컬럼명) REFERENCES 참조할테이블명 [(참조할컬럼명)]
       - UNIQUE : ALTER TABLE 테이블명 ADD UNIQUE(컬럼명)
       - CHECK : ALTER TABLE 테이블명 ADD CHECK(컬럼에 대한 조건식)
       - NOT NULL : ALTER TABLE 테이블명 MODIFY 컬럼명 NOT NULL
       
       + 제약조건명을 지정하려면 CONSTRAINT 제약조건명  제약조건
      
     > 제약조건 삭제
         DROP CONSTRAINT  제약조건
         MODIFY 컬럼명 NULL(NOT NULL 제약조건을 NULL 바꿀때)
*/
-- DEPARTMENT테이블을 복사하여 DEPT_COPY테이블 생성

-- DEPT_COPY테이블에 LNAME컬럼 추가


-- DEPT_COPY테이블 제약조건 추가
-- 1) DEPT_ID컬럼에 기본키
-- 2) DEPT_TITLE 컬럼에 UNIQUE
-- 3) LNAME컬럼에 NOT NULL

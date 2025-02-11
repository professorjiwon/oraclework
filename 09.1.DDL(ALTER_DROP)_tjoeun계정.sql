/*
    * ALTER : 객체를 변경하는 구문
      
      [표현법]
      ALTER 객체 객체명 변경할 내용;
      
      -- 변경할 내용
         1) 컬럼 추가 / 수정 / 삭제
         2) 제약조건 추가 / 삭제  -> 수정 불가
         3) 컬럼명 / 제약조건명 / 테이블명 변경
*/
-------------------------------------------------------------------------------------------------------
/*
    1. 컬럼 추가 / 수정 / 삭제
       1.1 컬럼 추가 (ADD)
            
            [표현법]
            ADD 컬럼명 데이터타입 [DEFAULT 기본값]
*/
ALTER TABLE DEPT_COPY ADD CNAME VARCHAR(20);

ALTER TABLE DEPT_COPY ADD LNAME VARCHAR(20) DEFAULT '한국';

/*
       1.2 컬럼 수정 (MODIFY)
            
            [표현법]
            - 데이터 타입 수정
              MODIFY 컬럼명 바꾸고자하는 데이터타입
              
            - DEFAULT 값 수정
              MODIFY 컬럼명 DEFAULT 바꾸고자하는 기본값
*/
ALTER TABLE DEPT_COPY MODIFY DEPT_ID CHAR(3);

-- 오류 : 컬럼값에 문자가 포함되어 있음. 컬럼의 타입을 변경하려면 값들을 모두 지워야 변경가능
ALTER TABLE DEPT_COPY MODIFY DEPT_ID NUMBER;

-- 오류 : 컬럼의 타입을 변경하려면 값들을 모두 지워야 변경가능
ALTER TABLE EMPLOYEE_COPY MODIFY EMP_ID NUMBER;

-- 오류 : 컬럼값이 10BYTE가 넘는 자료가 들어가 있음
ALTER TABLE DEPT_COPY MODIFY DEPT_TITLE VARCHAR(10);

-- DEPT_COPY 테이블
--   DEPT_TITLE 컬럼을 VARCHAR2(40)
--   LOCAIONT_ID VARCHAR2(2)
--   LNAME 컬럼의 기본값을 '미국'으로 변경

-- 다중 변경
ALTER TABLE DEPT_COPY
    MODIFY DEPT_TITLE VARCHAR2(40)
    MODIFY LOCATION_ID VARCHAR2(2)
    MODIFY LNAME DEFAULT '미국';

/*
    1.3 컬럼 삭제
    
    [표현법]
    DROP COLUMN 컬럼명
*/
-- 테이블 생성
CREATE TABLE DEPT_COPY2
AS SELECT * FROM DEPARTMENT;

-- DEPT_COPY2에서 DEPT_ID 삭제
ALTER TABLE DEPT_COPY2
    DROP COLUMN DEPT_ID;


ALTER TABLE DEPT_COPY2
    DROP COLUMN DEPT_ID;
    
-- 오류 : 컬럼 삭제는 다중으로 안됨    
ALTER TABLE DEPT_COPY2
    DROP COLUMN DEPT_TITLE
    DROP COLUMN DEPT_LONG;
    
ALTER TABLE DEPT_COPY2
    DROP COLUMN DEPT_TITLE;
    
ALTER TABLE DEPT_COPY2
    DROP COLUMN DEPT_LONG;

-- 오류 : 한 테이블에 적어도 1개의 컬럼은 가지고 있어야 한다
ALTER TABLE DEPT_COPY2
    DROP COLUMN LOCATION_ID;
    
 --=============================================================
 /*
    2. 컬럼명 / 테이블명 변경
       2.1 컬럼명 변경
       
            [표현법]
            RENAME COLUMN 기존컬럼명 TO 바꿀컬럼명
 */
-- DEPT_COPY테이블에서 DEPT_TITLE => DEPT_NAME 변경
ALTER TABLE DEPT_COPY
    RENAME COLUMN DEPT_TITLE TO DEPT_NAME;
    
-- DEPT_COPY테이블명을 DEPT_TEST변경
ALTER TABLE DEPT_COPY RENAME TO DEPT_TEST;

 --=============================================================
 -- 테이블 삭제
 DROP TABLE DEPT_COPY2;
 
 /*
    - 외래키의 부모테이블은 삭제 안됨
      그래도 삭제하고 싶다면
      * 방법1 : 자식테이블을 먼저 삭제한 후 부모테이블 삭제
      * 방법2 : 부모테이블만 삭제하는데 제약조건을 같이 삭제하는 방법
                    DROP TABLE 부모테이블명 CASCADE CONSTRAINT;
 */
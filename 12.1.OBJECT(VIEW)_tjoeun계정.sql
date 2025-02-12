/*
    * VIEW
      : SELECT문을 저장해둘 수 있는 객체
        > 실제테이블이 아님
        > 임시테이블 같은 존재(논리적인 테이블) : 실제로 데이터가 담겨있지 않음
        
      - 자주 사용하는 긴 SELECT문
        > 한번만 만들어 놓으면 다시 기술할 필요 없음    
*/

-- 한국에서 근무하는 사원들의 사번, 사원명, 부서명, 급여, 근무국가명 조회
SELECT EMP_ID, EMP_NAME, DEPT_TITLE, SALARY, NATIONAL_NAME
    FROM EMPLOYEE
    JOIN DEPARTMENT ON (DEPT_CODE = DEPT_ID)
    JOIN LOCATION ON (LOCATION_ID = LOCAL_CODE)
    JOIN NATIONAL USING(NATIONAL_CODE)
WHERE NATIONAL_NAME = '한국';

-- 러시아에서 근무하는 사원들의 사번, 사원명, 부서명, 급여, 근무국가명 조회
SELECT EMP_ID, EMP_NAME, DEPT_TITLE, SALARY, NATIONAL_NAME
    FROM EMPLOYEE
    JOIN DEPARTMENT ON (DEPT_CODE = DEPT_ID)
    JOIN LOCATION ON (LOCATION_ID = LOCAL_CODE)
    JOIN NATIONAL USING(NATIONAL_CODE)
WHERE NATIONAL_NAME = '러시아';

-- 일본에서 근무하는 사원들의 사번, 사원명, 부서명, 급여, 근무국가명 조회
SELECT EMP_ID, EMP_NAME, DEPT_TITLE, SALARY, NATIONAL_NAME
    FROM EMPLOYEE
    JOIN DEPARTMENT ON (DEPT_CODE = DEPT_ID)
    JOIN LOCATION ON (LOCATION_ID = LOCAL_CODE)
    JOIN NATIONAL USING(NATIONAL_CODE)
WHERE NATIONAL_NAME = '일본';

--------------------------------------------------------------------------------------------------
/*
    1. VIEW 생성 방법
    
    [표현식]
    CREATE VIEW 뷰명
    AS 서브쿼리;
*/
-- 관리자 계정에서 뷰를 만들수 있는 권한 주기
GRANT CREATE VIEW TO tjoeun;

-- VIEW 생성
CREATE VIEW VW_LOCATION
AS SELECT EMP_ID, EMP_NAME, DEPT_TITLE, SALARY, NATIONAL_NAME
    FROM EMPLOYEE
    JOIN DEPARTMENT ON (DEPT_CODE = DEPT_ID)
    JOIN LOCATION ON (LOCATION_ID = LOCAL_CODE)
    JOIN NATIONAL USING(NATIONAL_CODE);
    
SELECT * FROM VW_LOCATION;

-- 위의 구문을 실행하면 실제로는 아래와 같이 실행됨(서브쿼리 사용)
SELECT * FROM ( SELECT EMP_ID, EMP_NAME, DEPT_TITLE, SALARY, NATIONAL_NAME
                            FROM EMPLOYEE
                            JOIN DEPARTMENT ON (DEPT_CODE = DEPT_ID)
                            JOIN LOCATION ON (LOCATION_ID = LOCAL_CODE)
                            JOIN NATIONAL USING(NATIONAL_CODE)
);

-- 뷰는 논리적인 가상 테이블(실질적으로 데이터를 저장하고 있지 않음)

SELECT * FROM VW_LOCATION
WHERE NATIONAL_NAME = '한국';

SELECT * FROM VW_LOCATION
WHERE NATIONAL_NAME = '러시아';

--------------------------------------------------------------------------------------------------
/*
    * 뷰 컬럼에 별칭 부여
      서브쿼리의 SELECT절에 함수식이나 산술연산식이 기술되어 있는 경우는 반드시 별칭 부여
      
      - CREATE OR REPLACE VIEW 뷰명 : 뷰명이 기존에 만들었던 뷰명이면 덮어쓰기
*/
-- 전 사원의 사번, 사원명, 직급명, 성별(남/여), 근무년수를 조회. SELECT문을 뷰로 정의
CREATE OR REPLACE VIEW VW_EMP
AS SELECT EMP_ID, EMP_NAME, JOB_NAME,
                DECODE(SUBSTR(EMP_NO, 8, 1), '1', '남', '2', '여', '3', '남', '4', '여'),
                EXTRACT(YEAR FROM SYSDATE) - EXTRACT(YEAR FROM HIRE_DATE)
      FROM EMPLOYEE
      JOIN JOB USING(JOB_CODE);
-- 오류 : 함수식과 산술식에 별칭부여 하지 않아

CREATE OR REPLACE VIEW VW_EMP
AS SELECT EMP_ID, EMP_NAME, JOB_NAME,
                DECODE(SUBSTR(EMP_NO, 8, 1), '1', '남', '2', '여', '3', '남', '4', '여') 성별,
                EXTRACT(YEAR FROM SYSDATE) - EXTRACT(YEAR FROM HIRE_DATE) 근무년수
      FROM EMPLOYEE
      JOIN JOB USING(JOB_CODE);
      
SELECT * FROM VW_EMP;

-- 별칭 부여의 다른 방법
CREATE OR REPLACE VIEW VW_EMP(사번, 사원명, 직급명, 성별, 근무년수)
AS SELECT EMP_ID, EMP_NAME, JOB_NAME,
                DECODE(SUBSTR(EMP_NO, 8, 1), '1', '남', '2', '여', '3', '남', '4', '여'),
                EXTRACT(YEAR FROM SYSDATE) - EXTRACT(YEAR FROM HIRE_DATE)
      FROM EMPLOYEE
      JOIN JOB USING(JOB_CODE);

SELECT * FROM VW_EMP
WHERE 근무년수 >= 30;

SELECT * FROM VW_EMP
WHERE 성별 = '여';

------------------------------------------------------------------------------------------------
-- 뷰 삭제
DROP VIEW VW_EMP;

------------------------------------------------------------------------------------------------
-- 생성된 뷰를 통해 DML(INSERT, UPDATE, DELETE) 가능
-- 뷰를 통해 DML을 실행하면 실제 데이터가 담겨있는 테이블에 반영됨

CREATE VIEW VW_JOB
AS SELECT JOB_CODE, JOB_NAME
      FROM JOB;
      
-- 뷰를 통해 삽입
INSERT INTO VW_JOB VALUES('J8','인턴');  -- JOB테이블에도 삽입

-- 뷰를 통한 수정
UPDATE VW_JOB
SET JOB_NAME = '수습사원'
WHERE JOB_CODE = 'J8';

-- 뷰를 통한 삭제
DELETE FROM VW_JOB
WHERE JOB_CODE = 'J8';

/*
    * DML 명령어로 조작이 불가능한 경우
    1) 뷰에 정의되지 않은 컬럼 조작하고 할 때
    2) 뷰에 정의되어 있는 컬럼 중에 테이블에 NOT NULL제약조건이 지정되어 있는 경우
    3) 산술연산식 또는 함수식으로 정의되어 있는 경우
    4) 그룹함수나 GROUP BY절이 포함된 경우
    5) DISTINCT 구문이 포함된 경우
    6) JOIN을 이용하여 여러 테이블을 연결시켜놓은 경우
*/
      
-- 2) 뷰에 정의되어 있는 컬럼 중에 테이블에 NOT NULL제약조건이 지정되어 있는 경우
CREATE OR REPLACE VIEW VW_JOB
AS SELECT JOB_NAME
    FROM JOB;
        
-- INSERT
INSERT INTO VW_JOB VALUES('인턴');
-- 실제 테이블에 (NULL, 인턴) 추가. JOB_CODE는 NOT NULL 이기 때문에 오류

-- 3) 산술연산식 또는 함수식으로 정의되어 있는 경우
CREATE OR REPLACE VIEW VW_SAL
AS SELECT EMP_ID, EMP_NAME, EMP_NO, JOB_CODE, SALARY, SALARY*12 연봉
      FROM EMPLOYEE;
      
-- INSERT
INSERT INTO VW_SAL VALUES(400, '아무개', '901023-2738465', 'J1', 3000000, 36000000);
-- 오류

-- 사번 302인 사원의 연봉 30000000
UPDATE VW_SAL
SET 연봉 = 30000000
WHERE EMP_ID = 302;
-- 오류

-- 사번 302 사원의 급여 2500000
UPDATE VW_SAL
SET SALARY = 2500000
WHERE EMP_ID = 302;

-- DELETE
DELETE FROM VW_SAL
WHERE 연봉 = 18600000;

-- 2개 동일 : 한 그룹에 여러명이 포함되어 있기 때문
-- 4) 그룹함수나 GROUP BY절이 포함된 경우
-- 5) DISTINCT 구문이 포함된 경우
CREATE OR REPLACE VIEW VW_GROUP
AS SELECT DEPT_CODE, SUM(SALARY) 합계, CEIL(AVG(SALARY)) 평균
      FROM EMPLOYEE
    GROUP BY DEPT_CODE;

-- INSERT (오류)
INSERT INTO VW_GROUP VALUES('D3', 80000000, 40000000);

-- UPDATE (오류)
UPDATE VW_GROUP
SET 합계 = 80000000
WHERE DEPT_CODE = 'D1';

-- DELETE (오류)
DELETE FROM VW_GROUP
WHERE 합계 = 4970000;

-- 6) JOIN을 이용하여 여러 테이블을 연결시켜놓은 경우
CREATE OR REPLACE VIEW VW_JOIN
AS SELECT EMP_ID, EMP_NAME, EMP_NO, JOB_CODE, DEPT_TITLE
      FROM EMPLOYEE
      JOIN DEPARTMENT ON (DEPT_CODE = DEPT_ID);
      
-- INSERT (오류)
INSERT INTO VW_JOIN VALUES('400','이순신', '981112-2847564','J1','총무부');

-- UPDATE (오류)
UPDATE VW_JOIN
SET DEPT_TITLE = '회계관리부'
WHERE EMP_ID = '217';

-- DELETE
DELETE VW_JOIN
WHERE EMP_ID = 211;
      
---------------------------------------------------------------------------------------------------
/*
    * VIEW 옵션
    
    [상세표현식] 
    CREATE [OR REPLACE] [FORCE | NOFORCE] VIEW 뷰명
    AS 서브쿼리
    [WITH CHECK OPTION]
    [WITH READ ONLY]
    
    - OR REPLACE : 기존에 동일한 이름의 뷰가 존재하면 덮어쓰기, 존재하지 않으면 새로 생성
    - FORCE | NOFORCE
      > FORCE : 서브쿼리에 기술된 테이블이 존재하지 않아도 뷰를 생성할 수 있다
      > NOFORCE : 서브쿼리에 기술된 테이블이 반드시 존재 해야만 뷰를 생성할 수 있다(기본값)
    - WITH CHECK OPTION : DML시 서브쿼리에 기술된 조건에 부합한 값으로만 DML가능하도록 함
    - WITH READ ONLY : 뷰를 조회만 가능(SELECT를 제외한 DML 불가)
*/
-- FORCE  생성은 되지만 활용 못함(타입이 정의되지 않음)
CREATE OR REPLACE FORCE VIEW VW_EMP
AS SELECT TCODE, TNAME, TCONTENT
        FROM TTT;

-- WITH CHECK OPTION
CREATE OR REPLACE VIEW VW_EMP
AS SELECT *
      FROM EMPLOYEE
      WHERE SALARY >= 3000000;
      
-- 301번을 2000000만원으로 변경
UPDATE VW_EMP
SET SALARY = 2000000
WHERE EMP_ID = '301';

ROLLBACK;

-- WITH CHECK OPTION
CREATE OR REPLACE VIEW VW_EMP
AS SELECT *
      FROM EMPLOYEE
      WHERE SALARY >= 3000000
WITH CHECK OPTION;      

-- WITH CHECK OPTION 위배 오류
UPDATE VW_EMP
SET SALARY = 2000000
WHERE EMP_ID = '301';

-- 가능
UPDATE VW_EMP
SET SALARY = 4000000
WHERE EMP_ID = '301';

ROLLBACK;

-- WITH READ ONLY
CREATE OR REPLACE VIEW VW_EMP
AS SELECT *
      FROM EMPLOYEE
      WHERE SALARY >= 3000000
WITH READ ONLY;

-- 읽기 전용 (DML불가)
DELETE VW_EMP
WHERE EMP_ID = 217;

SELECT * FROM VW_EMP;
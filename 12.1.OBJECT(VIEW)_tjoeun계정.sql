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






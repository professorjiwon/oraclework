/*
    * VIEW
      SELECT문을 저장해둘수 있는 객체
      (자주 쓰이는 긴 SELECT문을 저장해 두었다가 호출하여 사용할 수 있다)
      임시테이블 같은 존재(실제 데이터가 담겨있는거 아님 -> 논리적 테이블)
*/

-- 한국 근무하는 사원의 사번, 사원명, 부서명, 급여, 근무국가명
SELECT EMP_ID, EMP_NAME, DEPT_TITLE, SALARY, NATIONAL_NAME
 FROM EMPLOYEE
  JOIN DEPARTMENT ON (DEPT_CODE = DEPT_ID)
  JOIN LOCATION ON (LOCATION_ID = LOCAL_CODE)
  JOIN NATIONAL USING (NATIONAL_CODE)
WHERE NATIONAL_NAME = '한국';  

-- 러시아 근무하는 사원의 사번, 사원명, 부서명, 급여, 근무국가명
SELECT EMP_ID, EMP_NAME, DEPT_TITLE, SALARY, NATIONAL_NAME
 FROM EMPLOYEE
  JOIN DEPARTMENT ON (DEPT_CODE = DEPT_ID)
  JOIN LOCATION ON (LOCATION_ID = LOCAL_CODE)
  JOIN NATIONAL USING (NATIONAL_CODE)
WHERE NATIONAL_NAME = '러시아';  

-- 일본 근무하는 사원의 사번, 사원명, 부서명, 급여, 근무국가명
SELECT EMP_ID, EMP_NAME, DEPT_TITLE, SALARY, NATIONAL_NAME
 FROM EMPLOYEE
  JOIN DEPARTMENT ON (DEPT_CODE = DEPT_ID)
  JOIN LOCATION ON (LOCATION_ID = LOCAL_CODE)
  JOIN NATIONAL USING (NATIONAL_CODE)
WHERE NATIONAL_NAME = '일본'; 

-----------------------------------------------------------------------------------------------
/*
    1. VIEW 생성
    
     [표현법]
     CREATE VIEW 뷰명
     AS 서브쿼리;
*/
-- 관리자계정에서 권한 부여
GRANT CREATE VIEW TO TJOEUN;

-- VIEW 생성
CREATE VIEW VM_EMPLOYEE
AS SELECT EMP_ID, EMP_NAME, DEPT_TITLE, SALARY, NATIONAL_NAME
      FROM EMPLOYEE
        JOIN DEPARTMENT ON (DEPT_CODE = DEPT_ID)
        JOIN LOCATION ON (LOCATION_ID = LOCAL_CODE)
        JOIN NATIONAL USING (NATIONAL_CODE);
        
SELECT * FROM VM_EMPLOYEE;

-- 한국에서 근무하는 사원 검색
SELECT *
 FROM VM_EMPLOYEE
WHERE NATIONAL_NAME = '한국'; 

SELECT *
 FROM VM_EMPLOYEE
WHERE NATIONAL_NAME = '러시아'; 

SELECT *
 FROM VM_EMPLOYEE
WHERE NATIONAL_NAME = '일본'; 

-----------------------------------------------------------------------------------------------
/*
    * 뷰컬럼에 별칭 부여
       서브쿼리의 서브쿼리에 함수식, 산술식이 기술되면 반드시 별칭 부여해 줘야함
*/
-- 전 사원의 사번, 사원명, 직급명, 성별(남/여), 근무년수를 조회할 수 있는 뷰(VM_EMP_JOB) 생성
-- CREATE OR REPLACE VIEW : 이미 같은 이름의 뷰가 있으면 덮어쓰기 함. 없으면 생성
CREATE OR REPLACE VIEW VM_EMP_JOB
AS SELECT EMP_ID, EMP_NAME, JOB_NAME,
                DECODE(SUBSTR(EMP_NO,8,1),'1','남','2','여'),
                EXTRACT(YEAR FROM SYSDATE) - EXTRACT(YEAR FROM HIRE_DATE)
      FROM EMPLOYEE
        JOIN JOB USING(JOB_CODE);
-- 오류 : 함수식이 들어간 컬럼에 별칭 부여 안함

CREATE OR REPLACE VIEW VM_EMP_JOB
AS SELECT EMP_ID, EMP_NAME, JOB_NAME,
                DECODE(SUBSTR(EMP_NO,8,1),'1','남','2','여') 성별,
                EXTRACT(YEAR FROM SYSDATE) - EXTRACT(YEAR FROM HIRE_DATE) 근무년수
      FROM EMPLOYEE
        JOIN JOB USING(JOB_CODE);
        
-- 별칭을 다른 방식으로도 부여 가능
CREATE OR REPLACE VIEW VM_EMP_JOB(사번, 사원명, 직급명, 성별, 근무년수)
AS SELECT EMP_ID, EMP_NAME, JOB_NAME,
                DECODE(SUBSTR(EMP_NO,8,1),'1','남','2','여'),
                EXTRACT(YEAR FROM SYSDATE) - EXTRACT(YEAR FROM HIRE_DATE)
      FROM EMPLOYEE
        JOIN JOB USING(JOB_CODE);

-- 여성사원의 사원명, 근무년수 검색
SELECT 사원명, 근무년수
 FROM VM_EMP_JOB
WHERE 성별 = '여'; 

-- 30년 이상 근무한 직원 사원명, 직급명 검색
SELECT 사원명, 직급명
 FROM VM_EMP_JOB
WHERE 근무년수 >= 30; 

-----------------------------------------------------------------------------------------------
/*
    * 뷰 삭제
      DROP VIEW 뷰명
*/
DROP VIEW VM_EMP_JOB;

-----------------------------------------------------------------------------------------------
/*
    * 생성된  VIEW를 통해 DML사용 가능
      VIEW에서 INSERT, UPDATE, DELETE를 실행하면 실제 데이터베이스에 반영됨
*/
-- 뷰(VM_JOB) JOB테이블의 모든컬럼 서브쿼리
CREATE OR REPLACE VIEW VM_JOB
AS SELECT *
     FROM JOB;
     
     






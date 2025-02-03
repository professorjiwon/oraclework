/*
    (') 홑따옴표 : 문자열을 감싸주는 기호
    (") 쌍따옴표 : 컬럼명을 감싸주는 기호
*/
/*
    <SELECT>
    데이터를 조회할 때 사용하는 구문
    
    >> RESULT SET : SELECT문을 통해 조회된 결과물(조회된 행들의 집합)
    
    [표현법]
    SELECT 조회하고자하는 컬럼명, 컬럼명, ....
    FROM 테이블명;
*/

-- EMPLOYEE테이블에서 모든 컬럼(*) 조회
SELECT *
FROM employee;

-- EMPLOYEE테이블에서 사번, 이름, 급여만 조회
SELECT EMP_ID, EMP_NAME, SALARY
FROM EMPLOYEE;

-- JOB테이블 모두 컬럼 조회
SELECT *
FROM JOB;

--------------------------------- 실습문제 ---------------------------------
-- 1. JOB테이블에 직급명만 출력
SELECT JOB_NAME
FROM JOB;

-- 2. DEPARTMENT테이블의 모든 컬럼 조회
SELECT *
FROM DEPARTMENT;

-- 3. DEPARTMENT테이블의 부서코드, 부서명 조회
SELECT DEPT_ID, DEPT_TITLE
FROM DEPARTMENT;

-- 4. EMPLOYEE테이블에서 사원명, 이메일, 전화번호, 입사일, 급여 조회
SELECT EMP_NAME, EMAIL, PHONE, HIRE_DATE, SALARY
FROM EMPLOYEE;
-------------------------------------------------------------------------------
/*
    <컬럼값을 통한 산술연산>
    SELECT절 컬럼명 작성부부에 산술연산 기술할 수 있음(산술연산된 결과 조회)
*/
-- EMPLOYEE테이블에서 사원명, 사원의 연봉(급여*12) 조회
SELECT EMP_NAME, SALARY*12
FROM EMPLOYEE;

-- EMPLOYEE테이블에서 사원명, 급여, 보너스, 연봉, 보너스가포함된연봉 조회
SELECT EMP_NAME, SALARY, BONUS, SALARY*12, (SALARY*BONUS + SALARY)*12
FROM EMPLOYEE;
 -- > 산술연산 과정 중 NULL값이 존재할 경우 산술연산한 결과값도 무조건 NULL값으로 나옴
 
 -- EMPLOYEE테이블에서 사원명, 입사일, 근무일수 조회
 -- DATE형식도 연산가능 : 결과값 일 단위
 -- * 오늘 날짜 : SYSDATE
 SELECT EMP_NAME, HIRE_DATE, SYSDATE-HIRE_DATE
 FROM EMPLOYEE;
   -- > 근무일수에 소수점이하는 시분초 단위로 계산하기 때문
   
---------------------------------------------------------------------------------------------
/*
    <컬럼명에 별칭 지정하기>
    산술연산시 컬럼명이 산술에 들어간 수식 그대로 컬럼명이 됨. 이때 별칭을 부여할 수 있다
    
    [표현법]
    컬럼명 별칭  /  컬럼명 AS 별칭  /  컬럼명 "별칭"  /  컬럼명 AS "별칭"
    
    * 반드시 (" ")쌍따옴표가 들어가야 하는 경우
       별칭에 띄어쓰기가 있거나, 특수문자가 포함되어 있는 경우
*/

-- EMPLOYEE테이블에서 사원명, 급여, 보너스, 연봉, 보너스가포함된연봉 조회
SELECT EMP_NAME, SALARY, BONUS, SALARY*12 연봉, (SALARY*BONUS + SALARY)*12 "보너스포함 연봉"
FROM EMPLOYEE;

SELECT EMP_NAME, SALARY, BONUS, SALARY*12 "연봉(원)", (SALARY*BONUS + SALARY)*12 "보너스포함 연봉"
FROM EMPLOYEE;









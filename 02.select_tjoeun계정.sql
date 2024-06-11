/*
 (')홀따옴표 : 문자열
 (")쌍따옴표 : 컬럼명
*/

/*
    <SELECT>
    데이터 조회할 때 사용하는 구문
    
    >> RESULT SET : SELECT구문을 통해서 조회된 결과물( 즉, 조회된 행들의 집합)
    
    [표현법]
    SELECT 조회하고자하는 컬럼명, 컬럼명, ...
    FROM 테이블명;
*/
-- EMPLOYEE테이블의 모든 컬럼(*) 조회
SELECT *
  FROM employee;

SELECT *
FROM DEPARTMENT;

SELECT * FROM JOB;

-- EMPLOYEE테이블에서 사번, 이름, 급여만 조회
SELECT EMP_ID, EMP_NAME, SALARY 
  FROM employee;

------------------- 실습문제----------------------
--1. JOB테이블에 직급명만 조회

--2. DEPARTMENT 테이블의 모든 컬럼 조회

--3. DEPARTMENT 테이블의 부서코드, 부서명만 조회

--4. EMPLOYEE 테이블에 사원명, 이메일, 전화번호, 입사일, 급여 조회

/*
    <컬럼값을 통한 산술연산>
    SELECT절의 컬럼명 작성부분에 산술연산 기술 가능(이때 산술연산된 결과 조회)
*/
-- EMPLOYEE테이블 사원명, 사원의 연봉(급여*12) 조회
SELECT EMP_NAME, SALARY*12
  FROM EMPLOYEE;
  
-- EMPLOYEE테이블 사원명, 급여, 보너스
SELECT EMP_NAME, SALARY, BONUS
  FROM EMPLOYEE;

-- EMPLOYEE테이블 사원명, 급여, 보너스, 연봉, 보너스를 포함한 연봉( (급여+보너스*급여)*12) )
SELECT EMP_NAME, SALARY, BONUS, SALARY*12, (SALARY+BONUS*SALARY)*12
  FROM EMPLOYEE;
  --> 산술연산 중 NULL값이 존재할 경우 산술연산한 결과값도 무조건 NULL이 됨
  
-- EMPLOYEE테이블 사원명, 입사일, 근무일수(오늘날짜-입사일)
-- DATE형태끼리도 연산 가능 : 결과값은 일 단위
-- * 오늘날짜 : SYSDATE
SELECT EMP_NAME, HIRE_DATE, SYSDATE-HIRE_DATE
  FROM EMPLOYEE;
-- 소수점까지 나오는 이유는 초단위까지 관리하기 때문

-----------------------------------------------------------------------
/*
    <컬럼명에 별칭 지정하기>
    산술연산시 컬럼명이 산술에 들어간 수식 그대로 됨. 이때 별칭을 부여하면 별칭이 컬럼명이 됨
    
    [표현법]
    컬럼명 별칭 
    컬럼명 AS 별칭
    컬럼명 "별칭"
    컬럼명 AS "별칭"
*/

SELECT EMP_NAME, SALARY, BONUS, SALARY*12 연봉, (SALARY+BONUS*SALARY)*12 AS 총연봉
  FROM EMPLOYEE;

-- 별칭에 특수기호나 띄어쓰기가 들어가면 반드시 쌍따옴표(")로 묶어줘야함
SELECT EMP_NAME, SALARY, BONUS, SALARY*12 "연봉(원)", (SALARY+BONUS*SALARY)*12 AS "총 연봉"
  FROM EMPLOYEE;
  
-- 위의 예제에서 사원명, 급여, 보너스, 연봉(원), 총 연봉 별칭부여하기
SELECT EMP_NAME 사원명, SALARY AS 급여, BONUS "보너스", SALARY*12 "연봉(원)", (SALARY+BONUS*SALARY)*12 AS "총 연봉"
  FROM EMPLOYEE;

--------------------------------------------------------------------------------
/*
    <리터럴>
    임의로 지정한 문자열(')
    
    SELECT절에 리터럴을 넣으면 마치 테이블상에 존재하는 데이터 처럼 조회 가능
    조회된 RESULT SET의 모든 행에 반복적으로 같이 출력
*/
-- EMPLOYEE 사번, 사원명, 급여 조회 - 컬럼을 하나 만들어서 원을 넣어주도록함
SELECT EMP_ID, EMP_NAME, SALARY, '원' AS 단위
  FROM EMPLOYEE;

--------------------------------------------------------------------------------
/*
    <연결 연산자 : ||>
    여러 컬럼값을 마치 하나의 컬럼값인것처럼 연결하거나, 컬럼값과 리터럴을 연결할 수 있음
*/

-- EMPLOYEE 사번, 사원명, 급여를 하나의 커럼으로 조회
SELECT EMP_ID || EMP_NAME || SALARY AS "사원의 급여"
  FROM EMPLOYEE;

-- 컬럼값과 리터럴과 연결
SELECT EMP_NAME || '의 월급은 ' || SALARY || '원 입니다'
FROM EMPLOYEE;

SELECT EMP_ID, EMP_NAME, SALARY || '원'
  FROM EMPLOYEE;

--------------------------------------------------------------------------------
/*
    <DISTINCT>
    컬럼에 중복된 값들은 한번씩만 표시하고자 할 때
*/

-- EMPLOYEE에 부서코드 중복제거 조회
SELECT DISTINCT DEPT_CODE
FROM EMPLOYEE;

-- EMPLOYEE에 직급코드 중복제거 조회
SELECT DISTINCT JOB_CODE
  FROM EMPLOYEE;
  
-- 주의사항 : DISTINCT는 SELECT절에 딱 한번만 기술 가능
-- SELECT DISTINCT DEPT_CODE DISTINCT JOB_CODE
SELECT DISTINCT DEPT_CODE, JOB_CODE  -- 2개의 조합으로 1번
  FROM EMPLOYEE;
  
---------------------------------------------------------
/*
    <WHERE 절>
    조회하고자 하는 테이블로부터 특정조건에 만족하는 데이터만 조회할 때
    이때 WHERE절에 조건식을 쓰면 됨
    조건식에서는 다양한 연산자 사용가능
    
    [표현법]
    SELECT 컬럼명,... 
    FROM 테이블명
    WHERE 조건식;
    
    - 비교연산자
    >, <, >=, <=   --> 대소비교
    =              --> 같은지 비교
    !=, ^=, <>     --> 같지않은지 비교
*/

-- EMPLOYEE에서 부서코드가 'D9'인 사원들의 모든 컬럼 조회
SELECT *
  FROM EMPLOYEE
 WHERE DEPT_CODE = 'D9';
 
-- EMPLOYEE에서 부서코드가 'D1'인 사원들의 사원명, 급여, 부서코드 조회
SELECT EMP_NAME, SALARY, DEPT_CODE
FROM EMPLOYEE
WHERE DEPT_CODE = 'D1';

-- EMPLOYEE에서 부서코드가 'D1'이 아닌 사원들의 사원명, 이메일, 부서코드 조회
SELECT EMP_NAME, EMAIL, DEPT_CODE
  FROM EMPLOYEE
-- WHERE DEPT_CODE != 'D1';
-- WHERE DEPT_CODE ^= 'D1';
WHERE DEPT_CODE <> 'D1';

-- EMPLOYEE에서 급여가 4백만원 이상인 사원들의 사원명, 부서코드, 급여 조회
SELECT EMP_NAME, DEPT_CODE, SALARY
  FROM EMPLOYEE
 WHERE SALARY >= 4000000; 

-- EMPLOYEE에서 재직중(ENT_YN)인 사원의 사원명, 전화번호 조회
SELECT EMP_NAME, PHONE
  FROM EMPLOYEE
 WHERE ENT_YN = 'N'; 

------------------- 실습문제----------------------
--1. 급여가 300만원 이상인 사원들의 사원명, 급여, 입사일, (연봉) 조회

--2. 연봉이 5000만원 이상인 사원들의 사원명, 급여, (연봉), 부서코드 조회

--3. 직급코드가 'J3'이 아닌 사원들의 사번, 사원명, 직급코드, (퇴사여부) 조회








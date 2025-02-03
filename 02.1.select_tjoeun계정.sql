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
---------------------------------------------------------------------------------------------
/*
    <리터럴>
    임의로 지정한 문자열을 컬럼처럼 넣을 수 있음
    
    SELECT절에 리터럴을 넣으면 마치 테이블사에 존재하는 데이터처럼 조회 가능
    조회된 RESULT SET의 모든 행에 반복적으로 같이 출력
*/

-- EMPLOYEE 테이블에서 사번, 사원명, 급여, 원 조회
SELECT EMP_ID, EMP_NAME, SALARY, '원' AS 단위
FROM EMPLOYEE;

-- EMPLOYEE 테이블에서 사번, 사원명, 급여, 원, 보너스, % 조회
SELECT EMP_ID, EMP_NAME, SALARY, '원' AS 단위, BONUS, '%' "단위(%)"
FROM EMPLOYEE;

---------------------------------------------------------------------------------------------
/*
    <연결 연산자 : || >
    여러 컬럼값들을 마치 하나의 컬럼인것처럼 연결하거나, 컬럼값과 리터럴을 연결할 수 있음
*/

-- EMPLOYEE테이블에서 사번, 사원명, 급여를 하나의 컬럼으로 조회
SELECT EMP_ID, EMP_NAME, SALARY
FROM EMPLOYEE;

SELECT EMP_ID || EMP_NAME || SALARY 종합정보
FROM EMPLOYEE;

-- EMPLOYEE테이블에서 ???의 월급은 ???원 입니다 1컬럼으로 조회
SELECT EMP_NAME || '의 월급은 ' || SALARY || '원 입니다'
FROM EMPLOYEE;

-- EMPLOYEE테이블에서 사원명, 급여원 으로 조회
-- ex) 김정보  |  8000000원
SELECT EMP_NAME, SALARY || '원' 급여
FROM EMPLOYEE;

---------------------------------------------------------------------------------------------
/*
    <DISTINCT>
    컬럼에 중복된 값들은 한번씩만 표시
*/
-- EMPLOYEE테이블에서 직급코드 조회
SELECT JOB_CODE
FROM EMPLOYEE;

-- EMPLOYEE테이블에서 직급코드의 중복제거한 데이터 조회
SELECT DISTINCT JOB_CODE
FROM EMPLOYEE;

-- EMPLOYEE테이블에서 부서코드의 중복제거한 데이터 조회
SELECT DISTINCT DEPT_CODE
FROM EMPLOYEE;

-- 유의사항 : DISTINCT는 SELECT절에서 딱 한번만 기술 가능
/*  오류
SELECT DISTINCT JOB_CODE,  DISTINCT DEPT_CODE
FROM EMPLOYEE;
*/

SELECT DISTINCT JOB_CODE,  DEPT_CODE
FROM EMPLOYEE;
-- 조합으로 겹치지 않는것 조회(J1-D1, J1-D2)

---------------------------------------------------------------------------------------------
/*
    <WHERE절>
    조회하고자하는 테이블에서 특정 조건에 맞는 데이터만 조회할 때
    WHERE절에 조건식을 제시함
    조건식에는 다양한 연산자들 사용 가능
    
    [표현법]
    SELECT 컬럼1, 컬럼2, ...
    FROM 테이블명
    WHERE 조건식;
    
    *  비교연산자
    대소비교 : >, <, >=, >=
    같은지 비교 : =
    같지 않은지 비교 : !=, ^=, <>
*/

-- EMPLOYEE테이블에서 부서코드가 'D9'인 사원들의 모든 컬럼 조회
SELECT *
FROM EMPLOYEE
WHERE DEPT_CODE = 'D9';

-- EMPLOYEE테이블에서 부서코드가 'D1'인 사원들의 사번, 사원명, 부서코드 조회
SELECT EMP_ID, EMP_NAME, DEPT_CODE
FROM EMPLOYEE
WHERE DEPT_CODE = 'D1';

-- EMPLOYEE테이블에서 부서코드가 'D1'이 아닌 사원들의 사번, 사원명, 부서코드 조회
SELECT EMP_ID, EMP_NAME, DEPT_CODE
FROM EMPLOYEE
-- WHERE DEPT_CODE != 'D1';
-- WHERE DEPT_CODE ^= 'D1';
WHERE DEPT_CODE <> 'D1';

-- EMPLOYEE테이블에서 급여가 400만원 이상인 사원들의 사원명, 부서코드, 급여 조회
SELECT EMP_NAME, DEPT_CODE, SALARY
FROM EMPLOYEE
WHERE SALARY >= 4000000;

-- EMPLOYEE테이블에서 재직중인 사원들의 사번, 사원명, 입사일, 퇴직여부 조회
SELECT EMP_ID, EMP_NAME, HIRE_DATE, ENT_YN
FROM EMPLOYEE
WHERE ENT_YN = 'N';

--------------------------------- 실습문제 ---------------------------------
-- EMPLOYEE테이블에서
--1. 급여가 300만원 이상인 사원들의 사원명, 급여, 입사일, 연봉 조회

--2. 연봉이 5000만원 이상인 사원들의 사원명, 급여, 연봉, 부서코드 조회

--3. 직급코드가 'J3'이 아닌 사원들의 사번, 사원명, 직급코드, 퇴사여부 조회






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

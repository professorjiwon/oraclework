/*
    * 서브쿼리
       : 하나의 sql문안에 포함된 또다른 select문
       - 메인 sql문을 위해 보조 역할을 하는 쿼리문
*/

-- 김정보와 같은 부서의 사원 조회
-- 1. 김정보 부서 먼저 조회
SELECT DEPT_CODE
 FROM EMPLOYEE
WHERE EMP_NAME = '김정보';

-- 2. 부서가 D9인 사원 조회
SELECT EMP_NAME
 FROM EMPLOYEE
WHERE DEPT_CODE = 'D9'; 

-- 위의 단계를 하나의 쿼리문으로 합침
SELECT EMP_NAME
 FROM EMPLOYEE
WHERE DEPT_CODE = (SELECT DEPT_CODE
                                    FROM EMPLOYEE
                                  WHERE EMP_NAME = '김정보'); 

-- 전 직원의 평균급여보다 더 많은 급여를 받는 사원의 사번, 사원명, 직급코드 ,급여 조회
-- 1. 전 직원의 평균급여
SELECT CEIL(AVG(SALARY))
 FROM EMPLOYEE;
 
-- 2. 평균급여보다 많이 받는 사원들 조회
SELECT EMP_ID, EMP_NAME, JOB_CODE, SALARY
 FROM EMPLOYEE
WHERE SALARY > (SELECT CEIL(AVG(SALARY))
                             FROM EMPLOYEE); 

 -------------------------------------------------------------------------------------------------------------------
 /*
    * 서브쿼리의 구분
       서브쿼리를 수행한 결과값이 몇 행 몇 열이냐 따라 구분
       
       - 단일행 서브쿼리 : 서브쿼리의 조회 결과값이 오로지 1개 일때(1행1열)
       - 다중행 서브쿼리 : 서브쿼리의 조회 결과값이 여러행 일 때(여러행 1열)
       - 다중열 서브쿼리 : 서브쿼리의 조회 결과값이 여러열 일 때(1행 여러열)
       - 다중행 다중열 서브쿼리 : 서브쿼리의 조회 결과값이 여러행 여러열 일 때(여러행 여러열)
       
       >> 서브쿼리의 종류가 뭐냐에 따라 서브쿼리 앞에 붙는 연산자가 달라짐
 */

/*
    1. 단일행 서브쿼리 : 서브쿼리의 조회 결과값이 오로지 1개 일때(1행1열)
        일반 비교연산자 사용 가능
        =, !=, >, < .....
*/
--  1) 전 직원의 평균급여보다 더 적게 받는 직원의 사원명, 직급코드, 급여 조회
SELECT EMP_NAME, JOB_CODE, SALARY
 FROM EMPLOYEE
WHERE SALARY < (SELECT AVG(SALARY)
                             FROM EMPLOYEE);

-- 2) 최저급여를 받는 사원의 사번, 사원명, 급여, 입사일 조회
SELECT EMP_ID, EMP_NAME, SALARY, HIRE_DATE
 FROM EMPLOYEE
WHERE SALARY = (SELECT MIN(SALARY)
                             FROM EMPLOYEE);

-- 3) 박정보 사원의 급여보다 더 많이받는 사원들의 사번, 사원명, 부서코드, 급여 조회
SELECT EMP_ID, EMP_NAME, DEPT_CODE, SALARY
 FROM EMPLOYEE
WHERE SALARY > (SELECT SALARY
                             FROM EMPLOYEE
                             WHERE EMP_NAME = '박정보');

-- JOIN
-- 4) 박정보 사원의 급여보다 더 많이받는 사원들의 사번, 사원명, 부서명, 급여 조회
--    >> 오라클전용 구문
SELECT EMP_ID, EMP_NAME, DEPT_TITLE, SALARY
 FROM EMPLOYEE, DEPARTMENT
WHERE DEPT_CODE = DEPT_ID    
    AND SALARY > (SELECT SALARY
                             FROM EMPLOYEE
                             WHERE EMP_NAME = '박정보');  -- 순서 상관 없음




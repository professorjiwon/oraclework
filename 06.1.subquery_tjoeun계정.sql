/*
    * 서브쿼리
      -  하나의 SQL문 안에 포함된 또다른 SELECT문
      -  메인 SQL문의 보조 역할을 하는 쿼리문
*/
-- 간단한 서브쿼링 예1
-- 박정보 사원과 같은 부서에 속한 사원들 조회
-- 1. 박정보 사원의 부서
SELECT DEPT_CODE
FROM EMPLOYEE
WHERE EMP_NAME = '박정보';

-- 2. 부서코드가 D9인 사원 조회
SELECT EMP_ID, EMP_NAME, DEPT_CODE
FROM EMPLOYEE
WHERE DEPT_CODE = 'D9';

-- 위의 2개의 쿼리문을 합치면
SELECT EMP_ID, EMP_NAME, DEPT_CODE
FROM EMPLOYEE
WHERE DEPT_CODE = (SELECT DEPT_CODE
                                  FROM EMPLOYEE
                                 WHERE EMP_NAME = '박정보');
                                 
-- 전 직원의 평균급여보다 더 많은 급여를 받는 사원의 사번, 사원명, 직급코드, 급여 조회
-- 1. 평균급여 조회
SELECT AVG(SALARY)
FROM EMPLOYEE;

-- 2. 평균급여보다 급여를 많이 받는 사원
SELECT EMP_ID, EMP_NAME, JOB_CODE, SALARY
FROM EMPLOYEE
WHERE SALARY > 3047662;

-- 위의 쿼리문을 합치면
SELECT EMP_ID, EMP_NAME, JOB_CODE, SALARY
FROM EMPLOYEE
WHERE SALARY > (SELECT AVG(SALARY)
                            FROM EMPLOYEE);

---------------------------------------------------------------------------------------------------------
/*
    * 서브쿼리의 구분
      서브쿼리를 수행한 결과값이 몇행 몇열이냐에 따라 분류
      
      - 단일행 서브쿼리 : 서브쿼리를 실행한 결과 오로지 1개일 때(한행 한열)
      - 다중행 서브쿼리 : 서브쿼리를 실행한 결과 여러행 일 때(여러행 한열)
      - 다중열 서브쿼리 : 서브쿼리를 실행한 결과 여러열 일 때(한행 여러열)
      - 다중행 다중열 서브쿼리 : 서브쿼리를 실행한 결과 여러행 여러열 일 때(여러행 여러열)
      
      >> 서브쿼리의 종류가 무엇이냐에 따라 서브쿼리 앞에 붙는 연산자가 달라짐
*/
---------------------------------------------------------------------------------------------------------
/*
    1. 단일행 서브쿼리(SINGLE ROW SUBQUERY)
       - 비교연산자 사용가능
         = , !=, >, < .....
*/
-- 전 직원의 평균급여보다 급여를 더 적게 받는 사원들의 사원명, 직급코드, 급여 조회
SELECT EMP_NAME, JOB_CODE, SALARY
FROM EMPLOYEE
WHERE SALARY < (SELECT AVG(SALARY)
                            FROM EMPLOYEE)
ORDER BY SALARY;

-- 최저 급여를 받는 사원의 사번, 사원명, 급여, 입사일 조회
SELECT EMP_ID, EMP_NAME, SALARY, HIRE_DATE
FROM EMPLOYEE
WHERE SALARY = (SELECT MIN(SALARY)
                            FROM EMPLOYEE);

-- 박정보 사원의 급여보다 더 많이 받는 사원들의 사번, 사원명, 직급코드, 급여 조회
SELECT EMP_ID, EMP_NAME, JOB_CODE, SALARY
FROM EMPLOYEE
WHERE SALARY > (SELECT SALARY
                            FROM EMPLOYEE
                            WHERE EMP_NAME = '박정보');

-- JOIN
-- 박정보 사원의 급여보다 더 많이 받는 사원들의 사번, 사원명, 부서이름, 급여 조회
-->> 오라클 전용 구문
SELECT EMP_ID, EMP_NAME, DEPT_TITLE, SALARY
FROM EMPLOYEE, DEPARTMENT
WHERE DEPT_CODE = DEPT_ID
   AND SALARY > (SELECT SALARY
                            FROM EMPLOYEE
                            WHERE EMP_NAME = '박정보'); 

-->> ANSI 구문
SELECT EMP_ID, EMP_NAME, DEPT_TITLE, SALARY
FROM EMPLOYEE
JOIN DEPARTMENT ON (DEPT_CODE = DEPT_ID)
WHERE SALARY > (SELECT SALARY
                            FROM EMPLOYEE
                            WHERE EMP_NAME = '박정보');

-- 서브쿼리에 나온 결과는 제외하여 조회하고 싶을때
-- 지정보사원과 같은 부서원들의 사번, 사원명, 부서명 조회 단, 지정보는 제외
-->> 오라클 전용 구문
SELECT EMP_ID, EMP_NAME, DEPT_TITLE
FROM EMPLOYEE, DEPARTMENT
WHERE DEPT_CODE = DEPT_ID
   AND DEPT_CODE = (SELECT DEPT_CODE
                                FROM EMPLOYEE
                                WHERE EMP_NAME = '지정보')
   AND EMP_NAME != '지정보';

-->> ANSI 구문
SELECT EMP_ID, EMP_NAME, DEPT_TITLE
FROM EMPLOYEE
JOIN DEPARTMENT ON (DEPT_CODE = DEPT_ID)
WHERE DEPT_CODE = (SELECT DEPT_CODE
                                FROM EMPLOYEE
                                WHERE EMP_NAME = '지정보')
    AND EMP_NAME != '지정보';
    
-- GROUP BY
-- 부서별 급여합이 가장 큰 부서의 부서코드, 급여합 조회
-- 1. 부서별 급여 합 중에서 가장 큰 값 조회
SELECT MAX(SUM(SALARY))
FROM EMPLOYEE
GROUP BY DEPT_CODE;

-- 2. 급여의 합이 17700000과 같은 행 조회
SELECT DEPT_CODE, SUM(SALARY)
FROM EMPLOYEE
GROUP BY DEPT_CODE
HAVING SUM(SALARY) = 17700000;

-- 위의 문장을 합치면  
SELECT DEPT_CODE, SUM(SALARY)
FROM EMPLOYEE
GROUP BY DEPT_CODE
HAVING SUM(SALARY) = (SELECT MAX(SUM(SALARY))
                                    FROM EMPLOYEE
                                    GROUP BY DEPT_CODE);    
    
---------------------------------------------------------------------------------------------------------
/*
    * 다중행 서브쿼리
      - IN 서브쿼리 : 여러개의 결과값 중 한개라도 일치하는 값이 있다면
      
      - > ANY 서브쿼리 : 여러개의 결과값 중 "한개라도" 클 경우
                                 즉, 결과값 중 가장 작은값 보다 클 경우
      - < ANY 서브쿼리 : 여러개의 결과값 중 "한개라도" 작은 경우
                                 즉, 결과값 중 가장 큰값 보다 작을 경우   
      - ALL : 서브쿼리의 값들 중 가장 큰값보다 더 큰값을 얻어올 때
*/

-- 조정연 또는 지정보 사원과 같은 직급을 가진 사원들의 사번, 사원명, 직급코드, 급여 조회
-- 1. 조정연 또는 지정보 사원의 직급
SELECT JOB_CODE
FROM EMPLOYEE
--WHERE EMP_NAME = '조정연' OR EMP_NAME = '지정보';
WHERE EMP_NAME IN ('조정연', '지정보');

-- 2. J3, J7인 직원들 조회
SELECT EMP_ID, EMP_NAME, JOB_CODE, SALARY
FROM EMPLOYEE
WHERE JOB_CODE IN ('J3', 'J7');

-- 위의 쿼리문을 하나로
SELECT EMP_ID, EMP_NAME, JOB_CODE, SALARY
FROM EMPLOYEE
WHERE JOB_CODE IN (SELECT JOB_CODE
                                FROM EMPLOYEE
                                WHERE EMP_NAME IN ('조정연', '지정보'));

-- 대리 직급임에도 과장의 급여의 최소 급여보다 많이 받는 직원의 사번, 사원명, 직급명, 급여 조회
-- 1. 과장들의 급여 조회
SELECT SALARY
FROM EMPLOYEE
JOIN JOB USING(JOB_CODE)
WHERE JOB_NAME = '과장';

-- 2. 대리직급의 급여 중 2200000큰 사원 조회
SELECT EMP_ID, EMP_NAME, JOB_NAME, SALARY
FROM EMPLOYEE
JOIN JOB USING(JOB_CODE)
WHERE JOB_NAME = '대리'
    AND SALARY > 2200000;

-- 3. ANY 구문으로 하면
SELECT EMP_ID, EMP_NAME, JOB_NAME, SALARY
FROM EMPLOYEE
JOIN JOB USING(JOB_CODE)
WHERE JOB_NAME = '대리'
    AND SALARY > ANY (2200000, 2500000, 3760000);
    
-- 위의 쿼리문을 하나로
SELECT EMP_ID, EMP_NAME, JOB_NAME, SALARY
FROM EMPLOYEE
JOIN JOB USING(JOB_CODE)
WHERE JOB_NAME = '대리'
    AND SALARY > ANY (SELECT SALARY
                                    FROM EMPLOYEE
                                    JOIN JOB USING(JOB_CODE)
                                    WHERE JOB_NAME = '과장');
                                    
-- 단일행 서브쿼리로도 가능
SELECT EMP_ID, EMP_NAME, JOB_NAME, SALARY
FROM EMPLOYEE
JOIN JOB USING(JOB_CODE)
WHERE JOB_NAME = '대리'
    AND SALARY > (SELECT MIN(SALARY)
                            FROM EMPLOYEE
                            JOIN JOB USING(JOB_CODE)
                            WHERE JOB_NAME = '과장');
    
-- 차장 직급임에도 과장직급의 급여보다 적게 받는 사원의 사번, 사원명, 직급명, 급여 조회
-- 과장의 가장 큰 금액보다 적게 받는 차장
SELECT EMP_ID, EMP_NAME, JOB_NAME, SALARY
FROM EMPLOYEE
JOIN JOB USING(JOB_CODE)
WHERE JOB_NAME = '차장'
    AND SALARY < ANY(SELECT SALARY
                                    FROM EMPLOYEE
                                    JOIN JOB USING(JOB_CODE)
                                    WHERE JOB_NAME = '과장');

-- ALL : 서브쿼리의 값들 중 가장 큰값보다 더 큰값을 얻어올 때
-- 차장의 가장 큰 급여보다 더 많이 받는 과장 사번, 사원명, 직급명, 급여 조회
SELECT EMP_ID, EMP_NAME, JOB_NAME, SALARY
FROM EMPLOYEE
JOIN JOB USING(JOB_CODE)
WHERE JOB_NAME = '과장'
     AND SALARY > ALL(SELECT SALARY
                                 FROM EMPLOYEE
                                 JOIN JOB USING(JOB_CODE)
                                 WHERE JOB_NAME = '차장');

---------------------------------------------------------------------------------------------------------
/*
    * 다중열 서브쿼리
        : 서브쿼리의 결과값이 행은 하나 열은 여러개
*/
-- 구정하 사원과 같은 부서코드, 직급코드에 해당하는 사원들의 사번, 사원명, 부서코드, 직급코드 조회
SELECT EMP_ID, EMP_NAME, DEPT_CODE, JOB_CODE
FROM EMPLOYEE
WHERE DEPT_CODE = 구정하사원의 부서코드
    AND JOB_CODE = 구정하사원의 직급코드;


SELECT EMP_ID, EMP_NAME, DEPT_CODE, JOB_CODE
FROM EMPLOYEE
WHERE DEPT_CODE = (SELECT DEPT_CODE
                                  FROM EMPLOYEE
                                  WHERE EMP_NAME = '구정하')
    AND JOB_CODE = (SELECT JOB_CODE
                                  FROM EMPLOYEE
                                  WHERE EMP_NAME = '구정하');
                                  
-->> 다중행 서브쿼리                                  
SELECT EMP_ID, EMP_NAME, DEPT_CODE, JOB_CODE
FROM EMPLOYEE
WHERE (DEPT_CODE, JOB_CODE) = (SELECT DEPT_CODE, JOB_CODE
                                                  FROM EMPLOYEE
                                                  WHERE EMP_NAME = '구정하');
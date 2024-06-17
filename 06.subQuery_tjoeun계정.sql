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

 -------------------------------------------------------------------------------------------------------------------
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

--    >> ANSI 구문
SELECT EMP_ID, EMP_NAME, DEPT_TITLE, SALARY
 FROM EMPLOYEE
   JOIN DEPARTMENT ON (DEPT_CODE = DEPT_ID)
WHERE SALARY > (SELECT SALARY
                             FROM EMPLOYEE
                             WHERE EMP_NAME = '박정보');
                             
-- 5) 왕정보 사원과 부서코드가 같은 사원들의 사번, 사원명, 전화번호, 입사일, 부서명 조회(단, 왕정보는 제외)
--    >> 오라클전용 구문
SELECT EMP_ID, EMP_NAME, PHONE, HIRE_DATE, DEPT_TITLE
 FROM EMPLOYEE, DEPARTMENT
WHERE DEPT_CODE = DEPT_ID
   AND DEPT_CODE = (SELECT DEPT_CODE
                                  FROM EMPLOYEE
                                 WHERE EMP_NAME = '왕정보')
   AND EMP_NAME != '왕정보';

--    >> ANSI 구문
SELECT EMP_ID, EMP_NAME, PHONE, HIRE_DATE, DEPT_TITLE
 FROM EMPLOYEE
  JOIN DEPARTMENT ON (DEPT_CODE = DEPT_ID)
WHERE DEPT_CODE = (SELECT DEPT_CODE
                                  FROM EMPLOYEE
                                 WHERE EMP_NAME = '왕정보')
   AND EMP_NAME != '왕정보';
   
   
-- GROUP BY
-- 6) 부서별 급여합이 가장 큰 부서의 부서코드, 급여합 조회
--      6.1 부서별 급여합 중 가장 큰 값 하나만 조회
SELECT MAX(SUM(SALARY))
 FROM EMPLOYEE
GROUP BY DEPT_CODE;

--     6.2 부서별 급여합이 17700000인 부서를 조회
SELECT DEPT_CODE, SUM(SALARY)
 FROM EMPLOYEE
GROUP BY DEPT_CODE
HAVING SUM(SALARY) = 17700000;

-- 위의 쿼리문을 하나로
SELECT DEPT_CODE, SUM(SALARY)
 FROM EMPLOYEE
GROUP BY DEPT_CODE
HAVING SUM(SALARY) = (SELECT MAX(SUM(SALARY))
                                       FROM EMPLOYEE
                                      GROUP BY DEPT_CODE);

 -------------------------------------------------------------------------------------------------------------------
/*
    2. 다중행 서브쿼리
       : 서브쿼리의 조회 결과값이 여러행 일 때(여러행 1열)
       - IN 서브쿼리 : 여러개의 결과값 중에서 한개라도 일치하는 값이 있다면
          > ANY 서브쿼리 : 여러개의 결과값 중에서 "한개라도" 클 경우
                                    (여러개의 결과값 중에서 가장 작은값 보다 클 경우)
          < ANY 서브쿼리 : 여러개의 결과값 중에서 "한개라도" 작은 경우
                                     (여러개의 결과값 중에서 가장 큰값 보다 작을 경우)  
                                     
        비교대상 > ANY (값1, 값2, 값3)
        비교대상 > 값1 OR 비교대상 > 값2 OR 비교대상 > 값3
*/
-- 1) 조정연 또는 전지연 사원과 같은 직급인 사원들의 사번, 사원명, 직급코드, 급여 조회
--    1.1 조정연 또는 전지연의 직급
SELECT JOB_CODE
 FROM EMPLOYEE
WHERE EMP_NAME IN ('조정연', '전지연');

--    1.2 J3, J7 직급인 사원들 조회
SELECT EMP_ID, EMP_NAME, JOB_CODE, SALARY
 FROM EMPLOYEE
WHERE JOB_CODE IN ('J3', 'J7'); 

-- 위의 쿼리문을 한줄로
SELECT EMP_ID, EMP_NAME, JOB_CODE, SALARY
 FROM EMPLOYEE
WHERE JOB_CODE IN  (SELECT JOB_CODE
                                   FROM EMPLOYEE
                                 WHERE EMP_NAME IN ('조정연', '전지연'));

--  사원 -> 대리 -> 과장
-- 2) 대리 직급임에도 불구하고 과장직급 급여들 중 최소 급여보다 많이 받는 직원의 사번, 사원명, 직급, 급여 조회
--     2.1. 과장들의 급여
SELECT SALARY
 FROM EMPLOYEE
  JOIN JOB USING (JOB_CODE)
WHERE JOB_NAME = '과장';     -- 2200, 2500, 3760

--     2.2. 직급이 대리이면서 급여가 위의 목록의 값 보다 하나라도 큰 사원
SELECT EMP_ID, EMP_NAME, JOB_NAME, SALARY
 FROM EMPLOYEE
 JOIN JOB USING (JOB_CODE)
WHERE JOB_NAME = '대리' 
    AND SALARY > ANY(2200000, 2500000, 3760000);

-- 위의 쿼리문을 하나로
SELECT EMP_ID, EMP_NAME, JOB_NAME, SALARY
 FROM EMPLOYEE
 JOIN JOB USING (JOB_CODE)
WHERE JOB_NAME = '대리' 
    AND SALARY > ANY (SELECT SALARY
                                    FROM EMPLOYEE
                                      JOIN JOB USING (JOB_CODE)
                                    WHERE JOB_NAME = '과장');

-- 단일행 쿼리로도 가능
SELECT EMP_ID, EMP_NAME, JOB_NAME, SALARY
 FROM EMPLOYEE
 JOIN JOB USING (JOB_CODE)
WHERE JOB_NAME = '대리' 
    AND SALARY > (SELECT MIN(SALARY)
                              FROM EMPLOYEE
                                JOIN JOB USING (JOB_CODE)
                            WHERE JOB_NAME = '과장');

 -------------------------------------------------------------------------------------------------------------------
/*
    3. 다중열 서브쿼리
       : 결과값이 한행이고 컬럼수가 여러개 일 때
*/
-- 1) 장정보 사원과 같은 부서코드, 같은 직급코드에 해당하는 사원들의 사원명, 부서코드, 직급코드, 입사일 조회
--     1.1  장정보 사원의 부서코드, 직급코드
SELECT DEPT_CODE, JOB_CODE
FROM EMPLOYEE
WHERE EMP_NAME = '장정보';

SELECT EMP_NAME, DEPT_CODE, JOB_CODE, HIRE_DATE
 FROM EMPLOYEE
WHERE DEPT_CODE = (SELECT DEPT_CODE
                                  FROM EMPLOYEE
                                 WHERE EMP_NAME = '장정보')
   AND JOB_CODE = (SELECT JOB_CODE
                                  FROM EMPLOYEE
                                 WHERE EMP_NAME = '장정보');

-- 다중열 서브쿼리
SELECT EMP_NAME, DEPT_CODE, JOB_CODE, HIRE_DATE
 FROM EMPLOYEE
WHERE (DEPT_CODE, JOB_CODE) = (SELECT DEPT_CODE, JOB_CODE
                                                     FROM EMPLOYEE
                                                    WHERE EMP_NAME = '장정보');
                                                    
-- 지정보 사원과 같은 직급코드, 같은 사수를 가지고 있는 사원들의 사번, 사원명, 직급코드, 사수번호 조회                                                   











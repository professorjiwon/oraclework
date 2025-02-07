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
                                                  
-- 하정연 사원의 직급코드와 사수가 같은 사원의 사번, 사원명, 직급코드,사수ID 조회   

---------------------------------------------------------------------------------------------------------
/*
    * 다중행 다중열 서브쿼리
        : 서브쿼리의 결과값이 여러행은 여러열의 결과
*/

-- 각 직급별 최소급여를 받는 사원의 사번, 사원명, 직급코드, 급여 조회
-- 1. 직급별 최소급여 금액과 직급코드 조회
SELECT JOB_CODE, MIN(SALARY)
FROM EMPLOYEE
GROUP BY JOB_CODE;

SELECT EMP_ID, EMP_NAME, JOB_CODE, SALARY
FROM EMPLOYEE
GROUP BY JOB_CODE = 'J5' AND SALARY = 2200000
           OR JOB_CODE = 'J6' AND SALARY = 2000000
           ...;


SELECT EMP_ID, EMP_NAME, JOB_CODE, SALARY
FROM EMPLOYEE
WHERE (JOB_CODE, SALARY) = ('J5', 2200000)
      OR (JOB_CODE, SALARY) = ('J6', 2000000)
      ...;

-- 서브쿼리 적용
SELECT EMP_ID, EMP_NAME, JOB_CODE, SALARY
FROM EMPLOYEE
WHERE (JOB_CODE, SALARY) IN (SELECT JOB_CODE, MIN(SALARY)
                                               FROM EMPLOYEE
                                               GROUP BY JOB_CODE);
                                               
-- 각 부서별 최고급여를 받는 사원들의 사번, 사원명, 부서코드, 급여 조회
SELECT EMP_ID, EMP_NAME, DEPT_CODE, SALARY
FROM EMPLOYEE
WHERE (DEPT_CODE, SALARY) IN (SELECT DEPT_CODE, MAX(SALARY)
                                                FROM EMPLOYEE
                                                GROUP BY DEPT_CODE);
                                                
---------------------------------------------------------------------------------------------------------
/*
    * 인라인 뷰(INLINE VIEW)
      FROM절에 서브쿼리 작성
      
      서버쿼리 결과를 마치 테이블처럼 사용
*/
-- 사원들의 사번, 사원명, 보너스포함연봉(별칭부여), 부서코드 조회
-- NULL값이 나오지 않게
-- 단, 보너스포함 연봉이 3000만원이상인 사원들만 조회

SELECT EMP_ID, EMP_NAME, SALARY * NVL(1+BONUS, 1) * 12 연봉, DEPT_CODE
FROM EMPLOYEE
WHERE SALARY * NVL(1+BONUS, 1) * 12 >= 30000000;

-- WHERE절에 연봉이라는 별칭을 쓰고 싶으면
SELECT *
FROM (SELECT EMP_ID, EMP_NAME, SALARY * NVL(1+BONUS, 1) * 12 연봉, DEPT_CODE
            FROM EMPLOYEE)   -- 테이블처럼 사용
WHERE 연봉 >= 30000000;

-- FROM절의 서브쿼리에 있는 컬럼들만 사용가능
SELECT EMP_NAME, 연봉
FROM (SELECT EMP_ID, EMP_NAME, SALARY * NVL(1+BONUS, 1) * 12 연봉, DEPT_CODE
            FROM EMPLOYEE)
WHERE 연봉 >= 30000000;

-- FROM절의 서브쿼리에 JOB_CODE컬럼이 없어서 오류남
SELECT EMP_NAME, 연봉, JOB_CODE
FROM (SELECT EMP_ID, EMP_NAME, SALARY * NVL(1+BONUS, 1) * 12 연봉, DEPT_CODE
            FROM EMPLOYEE)
WHERE 연봉 >= 30000000;

------------ >> 인라인 뷰를 주로 사용하는 예) TOP-N분석(상위 몇위까지만 가져오기)
-- 전 직원들중 급여가 가장 많이받는 사원의 상위 5위까지 가져오기
-----> * ROWNUM : 오라클에서 제공해주는 컬럼. 조회된 순서대로 1부터 순번을 부여해주는 컬럼
SELECT ROWNUM, EMP_NAME, SALARY
FROM EMPLOYEE;

-- 우선 SELECT의 이름과 급여를 가져와서 그결과에 번호 매긴 후 급여의 내림차순 정렬
SELECT ROWNUM, EMP_NAME, SALARY
FROM EMPLOYEE
WHERE ROWNUM <= 5
ORDER BY SALARY DESC;

SELECT ROWNUM, EMP_NAME, SALARY
FROM (SELECT EMP_NAME, SALARY
            FROM EMPLOYEE
            ORDER BY SALARY DESC)
WHERE ROWNUM <= 5;

-- 테이블 서브쿼리외의 다른컬럼을 사용할때는 서브쿼리에 별칭을 부여한 후 별칭.* 으로만 사용가능
SELECT ROWNUM, E.*
FROM (SELECT EMP_NAME, SALARY
            FROM EMPLOYEE
            ORDER BY SALARY DESC) E
WHERE ROWNUM <= 5;

-- 가장 최근에 입사한 사원 3명의 사원명, 급여, 입사일 조회
SELECT ROWNUM, E.*
FROM (SELECT EMP_NAME, SALARY, HIRE_DATE
            FROM EMPLOYEE
            ORDER BY HIRE_DATE DESC) E
WHERE ROWNUM <= 3;

-- 각 부서별 평균급여가 높은 3개의 부서의 부서코드, 평균급여 조회
SELECT *
FROM (SELECT DEPT_CODE, CEIL(AVG(SALARY)) 평균급여
            FROM EMPLOYEE
            GROUP BY DEPT_CODE
            ORDER BY 평균급여 DESC)
WHERE ROWNUM <= 3;

---------------------------------------------------------------------------------------------------------
/*
    * WITH
      서브쿼리에 이름 붙여주고 인라인 뷰로 사용시 서브쿼리의 이름을 FROM절에 기술
      
      - 장점
        같은 서브쿼리가 여러 번 사용될 경우 중복 작성을 피할 수 있다
        실행속도도 빠르다
*/

WITH TOP_SAL AS (SELECT DEPT_CODE, CEIL(AVG(SALARY)) 평균급여
                            FROM EMPLOYEE
                            GROUP BY DEPT_CODE
                            ORDER BY 평균급여 DESC)

SELECT *
FROM TOP_SAL
WHERE ROWNUM <= 5;
-- MINUS, UNION 을 쓸 때 유용

---------------------------------------------------------------------------------------------------------
/*
    * 순위 매기는 함수
      RANK() OVER(정렬기준)  |   DENSE_RANK() OVER(정렬기준)
      - RANK() OVER(정렬기준) : 동일한 순위 이후의 등수를 동일한 인원수 만큼 건너뛰어 순위 계산
                                            EX) 공동 1위가 2명이면 다음 순위는 3위
      - DENSE_RANK() OVER(정렬기준) : 동일한 순위 이후의 등수를 무조건 1증가 시킴
                                            EX) 공동 1위가 2명이면 다음 순위는 2위
     >>  SELECT절에서만 사용 가능
*/
-- 급여가 높은 순서대로 순위를 매겨서 조회
SELECT EMP_NAME, SALARY, RANK() OVER(ORDER BY SALARY DESC) 순위
FROM EMPLOYEE;
-- 공동 19위가 2명 -> 그 다음 순위는 21위

SELECT EMP_NAME, SALARY, DENSE_RANK() OVER(ORDER BY SALARY DESC) 순위
FROM EMPLOYEE;
-- 공동 19위가 2명 -> 그 다음 순위는 20위

-- 급여가 상위 5위인 사원들의 사원명, 급여, 순위 조회
SELECT EMP_NAME, SALARY, RANK() OVER(ORDER BY SALARY DESC) 순위
FROM EMPLOYEE
WHERE RANK() OVER(ORDER BY SALARY DESC) <= 5;
-- 오류 : RANK() 함수는 SELECT절에서만 사용가능

--->> 인라인 뷰를 사용할 수 밖에 없다
SELECT *
FROM (SELECT EMP_NAME, SALARY, RANK() OVER(ORDER BY SALARY DESC) 순위
            FROM EMPLOYEE)
WHERE 순위 <= 5;

-- WITH와 함께 사용
WITH TOPN_SAL AS (SELECT EMP_NAME, SALARY, RANK() OVER(ORDER BY SALARY DESC) 순위
                                FROM EMPLOYEE)

SELECT 순위, EMP_NAME, SALARY
FROM TOPN_SAL
WHERE 순위 <= 5;
-- SUBQUERY_연습문제
-- 1. 70년대 생(1970~1979) 중 여자이면서 전씨인 사원의 사원명, 주민번호, 부서명, 직급명 조회 
SELECT EMP_NAME, EMP_NO, DEPT_TITLE, JOB_NAME
FROM EMPLOYEE
JOIN DEPARTMENT ON (DEPT_CODE = DEPT_ID)
JOIN JOB USING (JOB_CODE)
WHERE SUBSTR(EMP_NO, 1, 2) BETWEEN 70 AND 79
    AND SUBSTR(EMP_NO, 8, 1) IN ('2', '4')
    AND EMP_NAME LIKE '전%';
-- SUBSTR(EMP_NO, 1, 2) >= 70 AND SUBSTR(EMP_NO, 1, 2) < 80

-- 2. 나이가 가장 막내의 사번, 사원명, 나이, 부서명, 직급명 조회
SELECT EMP_ID, EMP_NAME, 
            EXTRACT(YEAR FROM SYSDATE) - EXTRACT(YEAR FROM TO_DATE(SUBSTR(EMP_NO, 1, 2), 'RR')),
            DEPT_TITLE, JOB_NAME
FROM EMPLOYEE
JOIN DEPARTMENT ON (DEPT_CODE = DEPT_ID)
JOIN JOB USING (JOB_CODE)
WHERE EXTRACT(YEAR FROM SYSDATE) - EXTRACT(YEAR FROM TO_DATE(SUBSTR(EMP_NO, 1, 2), 'RR')) = 
( SELECT MIN(EXTRACT(YEAR FROM SYSDATE) - EXTRACT(YEAR FROM TO_DATE(SUBSTR(EMP_NO, 1, 2), 'RR')))
    FROM EMPLOYEE
);

SELECT EMP_ID, EMP_NAME, 
            EXTRACT(YEAR FROM SYSDATE) - EXTRACT(YEAR FROM TO_DATE(SUBSTR(EMP_NO, 1, 2), 'RR')),
            DEPT_TITLE, JOB_NAME
FROM EMPLOYEE
JOIN DEPARTMENT ON (DEPT_CODE = DEPT_ID)
JOIN JOB USING (JOB_CODE)
WHERE TO_DATE(SUBSTR(EMP_NO,1,2),'RR') = (SELECT MAX(TO_DATE(SUBSTR(EMP_NO,1,2), 'RR'))
                                                                    FROM EMPLOYEE);
                                                                    
-- INLINE VIEW
SELECT *
FROM (SELECT EMP_ID, 
                                EMP_NAME, 
                                EXTRACT(YEAR FROM SYSDATE) - EXTRACT(YEAR FROM TO_DATE(SUBSTR(EMP_NO, 1, 2), 'RR')) 나이,
                                DEPT_TITLE, 
                                JOB_NAME
                      FROM EMPLOYEE
                      JOIN DEPARTMENT ON (DEPT_CODE = DEPT_ID)
                      JOIN JOB USING (JOB_CODE)) E
WHERE E.나이 = (SELECT MIN(EXTRACT(YEAR FROM SYSDATE) - EXTRACT(YEAR FROM TO_DATE(SUBSTR(EMP_NO, 1, 2), 'RR')))
                        FROM EMPLOYEE);
                        
-- WITH
WITH AGE AS (SELECT EMP_ID, 
                                EMP_NAME, 
                                EXTRACT(YEAR FROM SYSDATE) - EXTRACT(YEAR FROM TO_DATE(SUBSTR(EMP_NO, 1, 2), 'RR')) 나이,
                                DEPT_TITLE, 
                                JOB_NAME
                      FROM EMPLOYEE
                      JOIN DEPARTMENT ON (DEPT_CODE = DEPT_ID)
                      JOIN JOB USING (JOB_CODE))
SELECT *
  FROM AGE
WHERE 나이 = (SELECT MIN(나이) FROM AGE);  

-- 3. 이름에 ‘하’가 들어가는 사원의 사번, 사원명, 직급명 조회


-- 4. 부서 코드가 D5이거나 D6인 사원의 사원명, 직급명, 부서코드, 부서명 조회


-- 5. 보너스를 받는 사원의 사원명, 보너스, 부서명, 지역명 조회


-- 6. 모든 사원의 사원명, 직급명, 부서명, 지역명 조회


-- 7. 한국이나 일본에서 근무 중인 사원의 사원명, 부서명, 지역명, 국가명 조회 


-- 8. 하정연 사원과 같은 부서에서 일하는 사원의 사원명, 부서코드 조회


-- 9. 보너스가 없고 직급 코드가 J4이거나 J7인 사원의 사원명, 직급명, 급여 조회 (NVL 이용)


-- 10. 퇴사 하지 않은 사람과 퇴사한 사람의 수 조회


-- 11. 보너스 포함한 연봉이 높은 5명의 사번, 사원명, 부서명, 직급명, 입사일, 순위 조회


-- 12. 부서 별 급여 합계가 전체 급여 총 합의 20%보다 많은 부서의 부서명, 부서별 급여 합계 조회
--	   12-1. JOIN과 HAVING 사용  

--	   12-2. 인라인 뷰 사용 

--	   12-3. WITH 사용

-- 13. 부서명별 급여 합계 조회(NULL도 조회되도록)

-- 14. WITH를 이용하여 급여합과 급여평균 조회

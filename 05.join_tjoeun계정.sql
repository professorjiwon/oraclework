/*
    JOIN
    두개 이상의 테이블에서 데이터를 조회하고자 할 때 사용하는 구문
    조회 결과는 하나의 결과물(RESULT SET)로 나옴
    
    => 관계형 데이터베이스에서 SQL문을 이용한 테이블간의 '관계'를 맺는 방법
    
    JOIN은 크게 "오라클전용구문"과 "ANSI 구문"(ANSI==미국국립표준협회)
    
                                        [JOIN 용어 정리]
    --------------------------------------------------------------------------------------------------
            오라클 전용 구문                  |                                   ANSI
    --------------------------------------------------------------------------------------------------            
                   등가조인                      |       내부조인(INNER JOIN) => JOIN USING | ON
               (EQUAL JOIN)                  |       자연조인(NATURAL JOIN) => JOIN USING
    --------------------------------------------------------------------------------------------------            
                   포괄조인                      |      왼쪽 외부조인(LEFT OUTER JOIN)
               (LEFT OUTER)                  |       오른쪽 외부조인(RIGHT OUTER JOIN)          
             (RIGHT OUTER)                  |       전체 외부조인(FULL OUTER JOIN)           
    --------------------------------------------------------------------------------------------------            
        자체조인(SELF JOIN)                 |                   JOIN ON
    비등가조인(NON EQUAL JOIN)      |       
    --------------------------------------------------------------------------------------------------           
   카테시안 곱(CARTESIAN PRODUCT) |                  교차조인(CROSS JOIN)
    --------------------------------------------------------------------------------------------------            
*/
-------------------------------------------------------------------------------------------------------------------
/*
    1. 등가조인 / 내부조인
        연결시키는 컬럼의 값이 "일치하는 행들만" 조인되어 조회(=일치하는 않는 행은 조회에서 제외)
*/
/*
      >> 오라클 전용 구문
           - FROM절에 조회하고자 하는 테이블들을 나열(, 구분자로)
           - WHERE절에 매칭시킬 컬럼(연결고리)에 대한 조건 제시함
*/
-- 1) 연결한 컬럼명이 다른 경우(EMPLOYEE: DEPT_CODE, DEPARTMENT: DEPT_ID)
-- 사번, 사원명, 부서코드, 부서명을 조회
SELECT EMP_ID, EMP_NAME, DEPT_CODE, DEPT_TITLE
FROM EMPLOYEE, DEPARTMENT
WHERE DEPT_CODE = DEPT_ID;
-- 일치하는 행이 없으면 조회에서 제외

-- 2) 연결할 컬럼명이 같은 경우(EMPLOYEE: JOB_CODE, JOB: JOB_CODE)
-- 사번, 사원명, 직급코드, 직급명
--   반드시 어떤테이블의 컬럼인지를 써줘야 됨
SELECT EMP_ID, EMP_NAME, EMPLOYEE.JOB_CODE, JOB_NAME
 FROM EMPLOYEE, JOB
WHERE EMPLOYEE.JOB_CODE = JOB.JOB_CODE;

--   테이블에 별칭을 이용해도 가능
SELECT EMP_ID, EMP_NAME, E.JOB_CODE, JOB_NAME
 FROM EMPLOYEE E, JOB J
WHERE E.JOB_CODE = J.JOB_CODE;

/*
      >> ANSI 구문
           - FROM절에 기준이되는 테이블을 하나만 기술
           - JOIN절에 같이 조회하고자 하는 테이블 기술 + 매칭시킬 컬럼에 대한 기술
           - JOIN USING, JOIN ON
*/
-- 1) 연결한 컬럼명이 다른 경우(EMPLOYEE: DEPT_CODE, DEPARTMENT: DEPT_ID)
--      => 오로지 JOIN ON구문만 사용

-- 사번, 사원명, 부서코드, 부서명을 조회
SELECT EMP_ID, EMP_NAME, DEPT_CODE, DEPT_TITLE
 FROM EMPLOYEE
   JOIN DEPARTMENT ON (DEPT_CODE = DEPT_ID);

-- 2) 연결할 컬럼명이 같은 경우(EMPLOYEE: JOB_CODE, JOB: JOB_CODE)
--     => JOIN ON과 JOIN USING 둘 다 사용가능

--     JOIN USING 사용
--       =>  두 테이블의 컬럼명이 같은경우 1개만 기술
-- 사번, 사원명, 직급코드, 직급명
SELECT EMP_ID, EMP_NAME, JOB_CODE, JOB_NAME
 FROM EMPLOYEE
   JOIN JOB USING (JOB_CODE);

--     JOIN ON 사용
--       =>  두 테이블의 컬럼명을 모두 기술
SELECT EMP_ID, EMP_NAME, EMPLOYEE.JOB_CODE, JOB_NAME
 FROM EMPLOYEE
   JOIN JOB ON (EMPLOYEE.JOB_CODE=JOB.JOB_CODE);
   
   -- 별칭 사용 가능
SELECT EMP_ID, EMP_NAME, E.JOB_CODE, JOB_NAME
 FROM EMPLOYEE E
   JOIN JOB J ON (E.JOB_CODE=J.JOB_CODE);

-- 3) 추가 조건이 있을 때
-- 직급이 대리인 사원의 사번, 사원명, 직급명, 급여를 조회
--  >> 오라클 전용 구문
SELECT EMP_ID, EMP_NAME, JOB_NAME, SALARY
 FROM EMPLOYEE E, JOB J
WHERE E.JOB_CODE = J.JOB_CODE
    AND JOB_NAME='대리';

--  >> ANSI 구문
SELECT EMP_ID, EMP_NAME, JOB_NAME, SALARY
 FROM EMPLOYEE
   JOIN JOB USING(JOB_CODE)
WHERE JOB_NAME = '대리';   

------------------------------------------  실습 문제  -------------------------------------------
-- 1. 부서가 인사관리부인 사원들의 사번, 이름,  부서명, 보너스 조회
--  >> 오라클 전용 구문

--  >> ANSI 구문

-- 2. DEPARTMENT과 LOCATION을 참고하여 전체 부서의 부서코드, 부서명, 지역코드, 지역명 조회
--  >> 오라클 전용 구문

--  >> ANSI 구문

-- 3. 보너스를 받는 사원들의 사번, 사원명, 보너스, 부서명 조회
--  >> 오라클 전용 구문

--  >> ANSI 구문

-- 4. 부서가 총무부가 아닌 사원들의 사원명, 급여, 부서명 조회
--  >> 오라클 전용 구문

--  >> ANSI 구문
/*
    <join>
    두개 이상의 테이블에서 데이터를 조회하고자 할때 사용되는 구문
    조회결과는 하나의 결과물(result set)로 나옴
    
    - 관계형데이터베이스는 최소한의 데이터로 각각 테이블에 담고 있음
      (중복을 최소화하기 위해)
      => 관계형 데이터베이스에서는 SQL문을 이용한 테이블간의 "관계"를 맺는 방법
      
    - JOIN은 크게 "오라클전용구문"과 "ANSI 구문" (ANSI == 미국국립표준협회)  
    
                                                     [ JOIN 용어 정리]
                        오라클 전용 구문                |                   ANSI
    -------------------------------------------------------------------------------------------------------
                            등가조인                       |       내부조인(INNER JOIN) => JOIN USING/ON
                        (EQUAL JOIN)                    |       자연조인(NATURAL JOIN) => JOIN USING
    -------------------------------------------------------------------------------------------------------
                            포괄조인                       |       왼쪽 외부 조인(LEFT OUTER JOIN)
                        (LEFT OUTER)                    |        오른쪽 외부 조인(RIGHT OUTER JOIN) 
                        (RIGHT OUTER)                  |        전체 외부 조인(FULL OUTER JOIN)
    -------------------------------------------------------------------------------------------------------
                 자체조인(SELF JOIN)                  |                         JOIN ON
           비등가 조인(NON EQUAL JOIN)         |     
    -------------------------------------------------------------------------------------------------------
          카테시안곱(CARTESIAN RPODUCT)      |                 교차조인(CROSS JOIN)
*/
-- 전체 사원의 사번, 사원명, 부서코드, 부서명을 조회
SELECT EMP_ID, EMP_NAME, DEPT_CODE
FROM EMPLOYEE;

SELECT DEPT_TITLE
FROM DEPARTMENT;

-- 전체 사원의 사번, 사원명, 직급코드, 직급명을 조회
SELECT EMP_ID, EMP_NAME, JOB_CODE
FROM EMPLOYEE;

SELECT JOB_NAME
FROM JOB;

---------------------------------------------------------------------------------------------------------
/*
    1. 등가조인(EQUAL JOIN) / 내부조인(INNER JOIN)
       연결시키는 컬럼의 값이 "일치하는 행들만" 조인되어 조회
*/
--  >> 오라클 전용구문
--      FROM절에 조회하고자하는 테이블들을 나열
--      WHERE절에 매칭시킬 컬럼(연결고리)에 대한 조건 제시

-- 1) 연결할 두컬럼명이 서로 다른 경우(EMPLYEE: DEPT_CODE, DEPARTMENT: DEPT_ID)
-- 전체 사원의 사번, 사원명, 부서코드, 부서명을 조회
SELECT EMP_ID, EMP_NAME, DEPT_CODE, DEPT_TITLE
FROM EMPLOYEE, DEPARTMENT;
-- 인사관리부를 23번, 회계관리부 23번,....

SELECT EMP_ID, EMP_NAME, DEPT_CODE, DEPT_TITLE
FROM EMPLOYEE, DEPARTMENT
WHERE DEPT_CODE = DEPT_ID;
-- 일치하는 값이 없는 행은 조회 제외

-- 2) 연결할 두컬럼명이 같은 경우(EMPLYEE: JOB_CODE, JOB: JOB_CODE)
-- 전체 사원의 사번, 사원명, 직급코드, 직급명을 조회
SELECT EMP_ID, EMP_NAME, JOB_CODE, JOB_NAME
FROM EMPLOYEE, JOB
WHERE JOB_CODE = JOB_CODE;

-- 해결방법1) 테이블명을 이용하는 방법
SELECT EMP_ID, EMP_NAME, EMPLOYEE.JOB_CODE, JOB_NAME
FROM EMPLOYEE, JOB
WHERE EMPLOYEE.JOB_CODE = JOB.JOB_CODE;

-- 해결방법2) 테이블에 별칭을 부여하여 이용하는 방법
SELECT EMP_ID, EMP_NAME, E.JOB_CODE, JOB_NAME
FROM EMPLOYEE E, JOB J
WHERE E.JOB_CODE = J.JOB_CODE;

--  >> ANSI 구문
--      FROM절에 기준이되는 테이블을 하나 기술한 후
--      JOIN절에 같이 조회하고자하는 테이블 기술 + 매칭시킬 컬럼에 대한 조건도 기술
--      JOIN USING, JOIN ON

-- 1) 연결할 두컬럼명이 서로 다른 경우(EMPLYEE: DEPT_CODE, DEPARTMENT: DEPT_ID)
-- 전체 사원의 사번, 사원명, 부서코드, 부서명을 조회
SELECT EMP_ID, EMP_NAME, DEPT_CODE, DEPT_TITLE
FROM EMPLOYEE
JOIN DEPARTMENT ON (DEPT_CODE = DEPT_ID);

-- 2) 연결할 두컬럼명이 같은 경우(EMPLYEE: JOB_CODE, JOB: JOB_CODE)
-- 전체 사원의 사번, 사원명, 직급코드, 직급명을 조회
SELECT EMP_ID, EMP_NAME, JOB_CODE, JOB_NAME
FROM EMPLOYEE
JOIN JOB ON (JOB_CODE = JOB_CODE);  -- 오류

-- 해결방법1) 테이블에 테이블명 또는 별칭을 이용하는 방법
SELECT EMP_ID, EMP_NAME, E.JOB_CODE, JOB_NAME
FROM EMPLOYEE E
JOIN JOB J ON (E.JOB_CODE = J.JOB_CODE);

-- 해결방법2) JOIN USING구문 사용하는 방법(두 컬럼이 일치할 때만 사용가능)
SELECT EMP_ID, EMP_NAME, JOB_CODE, JOB_NAME
FROM EMPLOYEE
JOIN JOB USING(JOB_CODE);




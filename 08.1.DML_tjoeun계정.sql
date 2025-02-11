/*
    * DML(DATA MANIPLATION LANGUAGE) : 데이터 조작언어
      : 테이블에 값을 검색(SELECT), 삽입(INSERT), 수정(UPDATE), 삭제(DELETE)하는 구문
*/
--=============================================================
/*
    1. INSERT
       테이블에 새로운 행을 추가는 구문
       
       [표현식]
       1) INSERT INTO 테이블명 VALUES(값1, 값2, 값3, ...)
          테이블에 모든 컬럼에 대한 값을 넣고자 할때
          컬럼의 순서를 지켜야 한다.
          
          부족하게 값을 넣을 경우 -> not enough value오류
          값을 많이 넣을 경우 -> too many value 오류
*/
-- EMPLOYEE테이블에 한 행 추가
INSERT INTO EMPLOYEE VALUES(300, '더조은', '980924-1234567', 'tjoeun@or.kr', '01012345678'
, 'D2', 'J1', 3500000, 0.2, 200, SYSDATE, NULL, DEFAULT);

-----------------------------------------------------------------------------------------------------------------
/*
    2) INSERT INTO 테이블명(컬럼명1, 컬럼명2, 컬럼명3...) VALUES(값1, 값2, 값3 ...)
       : 테이블에 내가 선택한 컬럼에 대한 값만 INSERT할때
         그래도 한 행 단위로 추가됨.
       -> 선택이 안된 컬럼은 NULL이 들어감. DEFAULT가 지정되어 있으면 NULL이 아닌 DEFAULT값이 들어감
       
       *  주의 : NOT NULL 제약조건이 들어있는 컬럼은 반드시 선택하여 값을 넣어야됨
*/
INSERT INTO EMPLOYEE(EMP_NAME, EMP_ID, EMP_NO, HIRE_DATE, JOB_CODE)
                      VALUES ('이고잉', '301', '091023-1298765', SYSDATE, 'J3');

INSERT 
    INTO EMPLOYEE
                    (
                        EMP_NAME
                      , EMP_ID
                      , EMP_NO
                      , HIRE_DATE
                      , JOB_CODE
                    )
    VALUES 
                    (
                        '이고잉'
                        , '301'
                        , '091023-1298765'
                        , SYSDATE
                        , 'J3'
                        );

-----------------------------------------------------------------------------------------------------------------
/*
    3) INSERT INTO 테이블명 (서브쿼리)
       : 서브쿼리로 조회된 결과값을 모두 INSERT함(여러행 INSERT가능)
*/
-- 새로운 테이블 생성
CREATE TABLE EMP_01 (
    EMP_ID NUMBER,
    EMP_NAME VARCHAR2(20),
    DEPT_CODE VARCHAR2(20)
);

INSERT INTO EMP_01 (
    SELECT EMP_ID, EMP_NAME, DEPT_CODE
    FROM EMPLOYEE   
);

CREATE TABLE EMP_02 (
    EMP_ID NUMBER,
    EMP_NAME VARCHAR2(20),
    DEPT_NAME VARCHAR2(20)
);

INSERT INTO EMP_02
(SELECT EMP_ID, EMP_NAME, DEPT_TITLE
    FROM EMPLOYEE
    LEFT JOIN DEPARTMENT ON (DEPT_CODE = DEPT_ID));

-----------------------------------------------------------------------------------------------------------------
/*
    3) INSERT ALL
       : 두개 이상의 테이블에 각각 INSERT할 때
         이때 사용되는 서브쿼리가 동일한 경우
*/
-- 2개 테이블 생성
CREATE TABLE EMP_DEPT
AS SELECT EMP_ID, EMP_NAME, DEPT_CODE, HIRE_DATE
     FROM EMPLOYEE
     WHERE 1=0;

CREATE TABLE EMP_MANAGER
AS SELECT EMP_ID, EMP_NAME, MANAGER_ID
      FROM EMPLOYEE
      WHERE 1=0;

-- 부서코드가 D1인 사원들을 2테이블에 삽입
SELECT EMP_ID, EMP_NAME, DEPT_CODE, HIRE_DATE,  MANAGER_ID
FROM EMPLOYEE
WHERE DEPT_CODE = 'D1';

INSERT ALL 
INTO EMP_DEPT VALUES(EMP_ID, EMP_NAME, DEPT_CODE, HIRE_DATE)
INTO EMP_MANAGER VALUES(EMP_ID, EMP_NAME, MANAGER_ID)
        SELECT EMP_ID, EMP_NAME, DEPT_CODE, HIRE_DATE,  MANAGER_ID
        FROM EMPLOYEE
        WHERE DEPT_CODE = 'D1';

-----------------------------------------------------------------------------------------------------------------
/*
    * 조건을 사용하여 각 테이블에 값 INSERT가능
    
    [표현식]
    INSERT ALL
    WHEN 조건1 THEN
            INTO 테이블명1 VALUES(컬럼명, 컬럼명...)
    WHEN 조건2 THEN
            INTO 테이블명2 VALUES(컬럼명, 컬럼명...)
    서브쿼리;
*/
-- 입사일이 2000년도 이전에 입사한 사원들의 정보 테이블
CREATE TABLE EMP_OLD
AS SELECT EMP_ID, EMP_NAME, HIRE_DATE, SALARY
      FROM EMPLOYEE
     WHERE 1=0; 

-- 입사일이 2000년도 이후에 입사한 사원들의 정보 테이블
CREATE TABLE EMP_NEW
AS SELECT EMP_ID, EMP_NAME, HIRE_DATE, SALARY
      FROM EMPLOYEE
     WHERE 1=0;
     
INSERT ALL
WHEN HIRE_DATE < '2000/01/01' THEN
        INTO EMP_OLD VALUES(EMP_ID, EMP_NAME, HIRE_DATE, SALARY)
WHEN HIRE_DATE >= '2000/01/01' THEN
        INTO EMP_NEW VALUES(EMP_ID, EMP_NAME, HIRE_DATE, SALARY)
    SELECT EMP_ID, EMP_NAME, HIRE_DATE, SALARY
    FROM EMPLOYEE;

-- 급여가 3백만원보다 많이 받는 사람을 넣을 테이블, 적게받는 사람을 넣을 테이블
-- ID, NAME, SALARY, BONUS
-- 테이블 2개 생성


     
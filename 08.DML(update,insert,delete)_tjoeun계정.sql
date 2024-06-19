/*
    * DML(DATA MANIPULATION LANGUAGE) : 데이터 조작 언어
      : 테이블에 값으 삽입(INSERT)하거나, 수정(UPDATE), 삭제(DELETE)하는 구문
*/
--=======================================================
/*
    * INSERT
      : 테이블에 새로운 행을 추가하는 구문
      
      [표현식]
      1) INSERT INTO 테이블명 VALUES(값1, 값2, 값3 ...);
          테이블의 모든 컬럼에 대한 값을 넣고자 할때(한행 추가)
          컬럼의 순서를 지켜서 값을 넣어야 됨
          
          값의 갯수 부족하면 => NOT ENOUGH VALUE 오류
          값의 갯수 많으면 => TOO MANY VALUES 오류
*/
SELECT * FROM EMPLOYEE;

INSERT INTO EMPLOYEE_COPY
VALUES(301, '이말순', '030616-4123456','sun@naver.com',
            '01012345678','D7','J5',3500000,0.1,200,SYSDATE,NULL,'N');

-------------------------------------------------------------------------------------------------------------------------------
/*
    2) INSERT INTO 테이블명(컬럼명, 컬럼명,...) VALUES(값1,값2,...);
        : 테이블에 내가 선택한 컬럼에만 값을 삽입할 때 사용
          -> 내가 선택한 컬럼값 이외의 값들은 NULL이 들어가고 DEFAULT 값이 설정되어 있으면 DEFAULT값이 들어감
          
        ** 주의
            - 컬럼이 NOT NULL제약조건이 있으면 반드시 값을 넣어야됨
              => DEFAULT값이 설정되어 있으면 안 넣어도됨 
*/
INSERT INTO EMPLOYEE_COPY(EMP_ID, EMP_NAME, EMP_NO, JOB_CODE, HIRE_DATE, PHONE)
                                 VALUES('302', '이고잉', '120421-3456789', 'J5', SYSDATE, '01089780987');
                                 
INSERT INTO EMPLOYEE_COPY(EMP_ID, EMP_NAME, EMP_NO, HIRE_DATE, PHONE)
                                 VALUES('303', '우재남', '110711-4456780', SYSDATE, '01089780985');

INSERT INTO EMPLOYEE_COPY(EMP_ID, EMP_NAME, HIRE_DATE, PHONE)
                                 VALUES('304', '채규태', SYSDATE, '01089780983');
-- EMP_NO의 NULL값 오류

INSERT 
    INTO EMPLOYEE_COPY
            (
                  EMP_ID
                , EMP_NAME
                , EMP_NO
                , JOB_CODE
                , HIRE_DATE
                , PHONE
            )
      VALUES
            (
                  '302'
                , '이고잉'
                , '120421-3456789'
                , 'J5'
                , SYSDATE
                , '01089780987'
            );

-------------------------------------------------------------------------------------------------------------------------------
/*
    3) INSERT INTO 테이블명 (서브쿼리);
        VALUES로 값을 직접 넣는 대신 서브쿼리로 조회된 결과를 모두 INSERT가능
*/
CREATE TABLE EMP_01 (
    EMP_ID VARCHAR2(3),
    EMP_NAME VARCHAR2(20),
    DEPT_NAME VARCHAR2(35)
);

-- 전체 사원들의 사번, 사원명, 부서명 조회
SELECT EMP_ID, EMP_NAME, DEPT_TITLE
 FROM EMPLOYEE_COPY, DEPARTMENT
WHERE DEPT_CODE = DEPT_ID(+); 

INSERT INTO EMP_01 
        (SELECT EMP_ID, EMP_NAME, DEPT_TITLE
        FROM EMPLOYEE_COPY, DEPARTMENT
        WHERE DEPT_CODE = DEPT_ID(+));

-------------------------------------------------------------------------------------------------------------------------------
/*
    * INSERT ALL
      2개 이상의 테이블에 각각 INSERT할 때
      사용하는 서브쿼리가 동일한 경우
      
      [표현식]
      INSERT ALL
      INTO 테이블명1 VALUES(컬럼명, 컬럼명, ...)
      INTO 테이블명2 VALUES(컬럼명, 컬럼명, ...)
              서브쿼리;
*/
-- 테스트할 테이블 2개 생성
CREATE TABLE EMP_DEPT
AS SELECT EMP_ID, EMP_NAME, DEPT_CODE, HIRE_DATE
      FROM EMPLOYEE
      WHERE 1=0;

CREATE TABLE EMP_MANAGER
AS SELECT EMP_ID, EMP_NAME, MANAGER_ID
      FROM EMPLOYEE
      WHERE 1=0;

-- 부서코드가 D1인 사원들의 사번, 이름, 부서코드, 입사일, 사수사번 조회
SELECT EMP_ID, EMP_NAME, DEPT_CODE, HIRE_DATE, MANAGER_ID
FROM EMPLOYEE
WHERE DEPT_CODE = 'D1';

INSERT ALL
INTO EMP_DEPT VALUES(EMP_ID, EMP_NAME, DEPT_CODE, HIRE_DATE)
INTO EMP_MANAGER VALUES(EMP_ID, EMP_NAME, MANAGER_ID)
        SELECT EMP_ID, EMP_NAME, DEPT_CODE, HIRE_DATE, MANAGER_ID
        FROM EMPLOYEE
        WHERE DEPT_CODE = 'D1';

-------------------------------------------------------------------------------------------------------------------------------
/*
    * 조건을 사용하는 INSERT ALL
        
       [표현식]
       INSERT ALL
       WHEN 조건1 THEN
                 INTO 테이블명1 VALUES(컬럼명, 컬럼명, ...)
       WHEN 조건2 THEN
                 INTO 테이블명2 VALUES(컬럼명, 컬럼명, ...)
        서브쿼리;
*/
-- 2000년도 이전에 입사한 사원들을 저장할 테이블 생성
CREATE TABLE EMP_OLD
AS SELECT EMP_ID, EMP_NAME, HIRE_DATE, SALARY
      FROM EMPLOYEE
      WHERE 1=0;

-- 2000년도 이후에 입사한 사원들을 저장할 테이블 생성
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

--=====================================================================
/*
    * UPDATE
      테이블의 데이터를 수정하는 구문
      
      [표현식]
      UPDATE 테이블명
      SET 컬럼명 = 바꿀값,
            컬럼명 = 바꿀값,
            ....
      [WHERE 조건];  --> ** 주의 : 조건을 생략하면 모든행의 데이터가 변경됨
*/
-- DEPARTMENT 복사본 테이블 생성
CREATE TABLE DEPT_COPY
AS SELECT * FROM DEPARTMENT;

-- D9 부서명을 전략기획부로 변경
UPDATE DEPT_COPY
SET DEPT_TITLE = '전략기획부';

ROLLBACK;

UPDATE DEPT_COPY
SET DEPT_TITLE = '전략기획부'
WHERE DEPT_ID = 'D9';

-- EMPLOYEE_COPY테이블에서 왕정보의 급여를 1,500,000으로 인상
UPDATE EMPLOYEE_COPY
SET SALARY = 1500000
WHERE EMP_NAME = '왕정보';

-- EMPLOYEE_COPY테이블에서 구정하의 급여를 1,800,000으로 인상하고 보너스는 10%
UPDATE EMPLOYEE_COPY
SET SALARY = 1800000,
      BONUS = 0.1
WHERE EMP_NAME = '구정하';      

-- EMPLOYEE_COPY테이블에서 전체 사원의 급여를 기존의 급여에 10% 인상한 금액으로 변경
UPDATE EMPLOYEE_COPY
SET SALARY = SALARY * 1.1;

-------------------------------------------------------------------------------------------------------------------------------
/*
    * 서브쿼리를 사용한 UPDATE
    
      [표현식]
      UPDATE 테이블명
      SET 컬럼명 = (서브쿼리)
      [WHERE 조건];
*/
-- 이고잉 사원의 급여와 보너스를 전정보사원의 급여와 보너스값으로 변경
-- 단일행 서브쿼리
UPDATE EMPLOYEE_COPY
SET SALARY = (SELECT SALARY
                        FROM EMPLOYEE_COPY
                       WHERE EMP_NAME = '전정보'),
      BONUS = (SELECT BONUS
                        FROM EMPLOYEE_COPY
                       WHERE EMP_NAME = '전정보')
WHERE EMP_NAME = '이고잉';

-- 다중열 서브쿼리 가능
UPDATE EMPLOYEE_COPY
SET (SALARY, BONUS) = (SELECT SALARY, BONUS
                                    FROM EMPLOYEE_COPY
                                    WHERE EMP_NAME = '전정보')
WHERE EMP_NAME = '이고잉';




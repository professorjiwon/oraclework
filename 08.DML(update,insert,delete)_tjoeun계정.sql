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








/*
    * PL/SQL
      PROCEDURAL LANGUAGE EXTENSION TO SQL
      
      오라클 자체에 내장되어 있는 절차적 언어
      SQL문장 내에서 변수의 정의, 조건처리(IF), 반복처리(LOOP, FOR, WHILE)등을 지원하여 SQL의 단점을 보완함
      다수의 SQL문을 한번 실행 가능(BLOCK구조)
      
      * 구조
      - [선언부 (DECLARE SECTION)] : DECLARE로 시작, 변수나 상수를 선언 및 초기화하는 부분
      - 실행부 (EXECUTABLE SECTION) : BEGIN로 시작, SQL문 또는 제어문(조건문, 반복문)등의 로직을 기술하는 부분
      - [예외처리부 (EXCEPTION SECTION)] : EXCEPTION으로 시작, 예외 발생시 해결하기 위한 구문을 미리 기술해 두는 부분
*/

-- * 화면에 출력하기
SET SERVEROUTPUT ON;

BEGIN
     -- System.out.println("HELLO ORACLE");
    DBMS_OUTPUT.PUT_LINE('HELLO ORACLE');
END;
/

/*
    1. DECLARE 선언부
       변수, 상수 선언하는 공간(선언과 동시 초기화도 가능)
       일반타입변수, 레퍼런스타입의 변수, ROW타입의 변수
    
       1.1 일반타입변수 선언 및 초기화
             [표현식] 
             변수명 [CONSTANT] 자료형 [ := 값 ]
*/

DECLARE
    EID NUMBER;
    ENAME VARCHAR2(20);
    PI CONSTANT NUMBER := 3.1415;
BEGIN
    EID := 600;
    ENAME := '임수정';
    
    -- System.out.println("EID : " + EID);
    DBMS_OUTPUT.PUT_LINE('EID : ' || EID);
    DBMS_OUTPUT.PUT_LINE('ENAME : ' || ENAME);
    DBMS_OUTPUT.PUT_LINE('PI : ' || PI);
END;
/
 
 
-- 사용자로부터 입력받아서 출력
DECLARE
    EID NUMBER;
    ENAME VARCHAR2 (20);
    PI CONSTANT NUMBER := 3.14;
BEGIN
    EID := &번호;
    ENAME := '&이름';
    
    DBMS_OUTPUT.PUT_LINE('EID : ' || EID);
    DBMS_OUTPUT.PUT_LINE('ENAME : ' || ENAME);
    DBMS_OUTPUT.PUT_LINE('PI : ' || PI);
END;
/
 
---------------------------------------------------------------------------------------------------------------- 
/*
    1.2 레퍼런스타입변수 선언 및 초기화
         : 어떤 테이블의 어떤 컬럼의 데이터타입을 참조하여 그타입으로 지정
         
        [표현식] 
        변수명  테이블명.컬럼명%TYPE;
*/
 
DECLARE
    EID EMPLOYEE.EMP_ID%TYPE;
    ENAME EMPLOYEE.EMP_NAME%TYPE;
    SAL EMPLOYEE.SALARY%TYPE;
BEGIN
    EID := '300';
    ENAME := '유재석';
    SAL := 4000000;
    
    DBMS_OUTPUT.PUT_LINE('EID : ' || EID);
    DBMS_OUTPUT.PUT_LINE('ENAME : ' || ENAME);
    DBMS_OUTPUT.PUT_LINE('급여 : ' || SAL);
END;
/

DECLARE
    EID EMPLOYEE.EMP_ID%TYPE;
    ENAME EMPLOYEE.EMP_NAME%TYPE;
    SAL EMPLOYEE.SALARY%TYPE;
BEGIN
    SELECT EMP_ID, EMP_NAME, SALARY
       INTO EID, ENAME, SAL
      FROM EMPLOYEE
    WHERE EMP_ID = &사번; 
    
    DBMS_OUTPUT.PUT_LINE('EID : ' || EID);
    DBMS_OUTPUT.PUT_LINE('ENAME : ' || ENAME);
    DBMS_OUTPUT.PUT_LINE('급여 : ' || SAL);
END;
/

--------------------------------  실습문제  ---------------------------------------------
/*
    레퍼런스타입변수로 EID, ENAME, JCODE, SAL, DTITLE를 선언하고
    각 자료형 EMPLOYEE(EMP_ID, EMP_NAME, JOB_CODE, SALARY), DEPARTMENT (DEPT_TITLE)들을 참조하도록
    
    사용자가 입력한 사번의 사원의 사번, 사원명, 직급코드, 급여, 부서명 조회 한 후 각 변수에 담아 출력
*/


---------------------------------------------------------------------------------------------------------------- 
/*
    1.3 ROW타입의 변수
         : 어떤 테이블의 한 행에 대한 모든 컬럼값을 한꺼번에 담을 수 있는 변수
         
        [표현식] 
        변수명  테이블명%ROWTYPE;
*/
DECLARE
    E EMPLOYEE%ROWTYPE;
BEGIN
    SELECT *
       INTO E
     FROM EMPLOYEE
    WHERE EMP_ID = &사번;
    
    DBMS_OUTPUT.PUT_LINE('사원명 : ' || E.EMP_NAME);
    DBMS_OUTPUT.PUT_LINE('급여 : ' || E.SALARY);
    -- DBMS_OUTPUT.PUT_LINE('보너스 : ' || E.BONUS);  성공이긴 하지만 값이 없음
    -- DBMS_OUTPUT.PUT_LINE('보너스 : ' || NVL(E.BONUS,'없음'));  자료형이 맞지 않아서 오류
    DBMS_OUTPUT.PUT_LINE('보너스 : ' || NVL(E.BONUS,0));
END;
/
    
DECLARE
    E EMPLOYEE%ROWTYPE;
BEGIN
    SELECT EMP_NAME, SALARY, BONUS  -- 무조건 * 를 사용해야 됨
       INTO E
      FROM EMPLOYEE
    WHERE EMP_ID = &사번;
    
    DBMS_OUTPUT.PUT_LINE('사원명 : ' || E.EMP_NAME);
    DBMS_OUTPUT.PUT_LINE('급여 : ' || E.SALARY);
    DBMS_OUTPUT.PUT_LINE('보너스 : ' || NVL(E.BONUS,0));
END;
/    
    
---------------------------------------------------------------------------------------------------------------- 
/*
    2. 실행부
        
        <조건부>
        1) IF 조건식 THEN 실행내용 END IF;  (단일 IF문)  
*/

-- 사번을 입력받아 사번, 이름, 급여, 보너스(%) 출력
--  단, 보너스를 받지 않는 사원은 '보너스를 지급받지 않는 사원입니다'출력

DECLARE
    EID EMPLOYEE.EMP_ID%TYPE;
    ENAME EMPLOYEE.EMP_NAME%TYPE;
    SALARY EMPLOYEE.SALARY%TYPE;
    BONUS EMPLOYEE.BONUS%TYPE;
BEGIN
    SELECT EMP_ID, EMP_NAME, SALARY, NVL(BONUS, 0)
       INTO EID, ENAME, SALARY, BONUS
     FROM EMPLOYEE
    WHERE EMP_ID = &사번;
    
    DBMS_OUTPUT.PUT_LINE('사번 : ' || EID);
    DBMS_OUTPUT.PUT_LINE('사원명 : ' || ENAME);
    DBMS_OUTPUT.PUT_LINE('급여 : ' || SALARY);
    
    IF BONUS = 0
        THEN DBMS_OUTPUT.PUT_LINE('보너스를 받지 않는 사원입니다');
    END IF;
    
    DBMS_OUTPUT.PUT_LINE('보너스 : ' || BONUS*100 || '%');
END;
/

----------------------------------------------------------------------------------------------
-- 2) IF 조건식 THEN 실행내용 ELSE 실행내용 END IF;  (IF-ELSE)

DECLARE
    EID EMPLOYEE.EMP_ID%TYPE;
    ENAME EMPLOYEE.EMP_NAME%TYPE;
    SALARY EMPLOYEE.SALARY%TYPE;
    BONUS EMPLOYEE.BONUS%TYPE;
BEGIN
    SELECT EMP_ID, EMP_NAME, SALARY, NVL(BONUS, 0)
       INTO EID, ENAME, SALARY, BONUS
     FROM EMPLOYEE
    WHERE EMP_ID = &사번;
    
    DBMS_OUTPUT.PUT_LINE('사번 : ' || EID);
    DBMS_OUTPUT.PUT_LINE('사원명 : ' || ENAME);
    DBMS_OUTPUT.PUT_LINE('급여 : ' || SALARY);
    
    IF BONUS = 0
        THEN DBMS_OUTPUT.PUT_LINE('보너스를 받지 않는 사원입니다');
    ELSE
        DBMS_OUTPUT.PUT_LINE('보너스 : ' || BONUS*100 || '%');
    END IF;

END;
/

------------------------------------------ 실습문제 ---------------------------------------------
/*
    레퍼런스변수 : EID, ENAME, DTITLE, NCODE
          참조컬럼 : EMP_ID, EMP_NAME, DEPT_TITLE, NATIONAL_CODE
          
    일반변수 : TEAM(소속)  
    
    실행 : 사용자가 입력한 사번의 사번, 이름, 부서명, 근무국가코드를 변수에 대입
             단) NCODE값이 KO일 경우   => TEAM변수에 '국내팀'
                  NCODE값이 KO가 아닐 경우   => TEAM변수에 '해외팀'
                  
             출력 : 사번, 이름, 부서명, 소속     
*/
DECLARE
    EID EMPLOYEE.EMP_ID%TYPE; 
    ENAME EMPLOYEE.EMP_NAME%TYPE; 
    DTITLE DEPARTMENT.DEPT_TITLE%TYPE;
    NCODE LOCATION.NATIONAL_CODE%TYPE;
    
    TEAM VARCHAR2(10);
    
BEGIN
    SELECT EMP_ID, EMP_NAME, DEPT_TITLE, NATIONAL_CODE
       INTO EID, ENAME, DTITLE, NCODE
     FROM EMPLOYEE
      JOIN DEPARTMENT ON (DEPT_CODE = DEPT_ID)
      JOIN LOCATION ON (LOCATION_ID = LOCAL_CODE)
    WHERE EMP_ID = &사번;
    
    IF NCODE = 'KO'
        THEN TEAM := '국내팀';
    ELSE
        TEAM := '해외팀';
    END IF;    

    DBMS_OUTPUT.PUT_LINE('사번 : ' || EID);
    DBMS_OUTPUT.PUT_LINE('사원명 : ' || ENAME);
    DBMS_OUTPUT.PUT_LINE('부서명 : ' || DTITLE);
    DBMS_OUTPUT.PUT_LINE('소속 : ' || TEAM);
END;
/

----------------------------------------------------------------------------------------------
/*
    3) IF-ELSE IF 조건문
    IF 조건식1
         THEN 실행내용1
    ELSIF 조건식2
         THEN 실행내용2
    ELSIF 조건식3
         THEN 실행내용3
    ELSE
         실행내용4
    END IF;     
*/

-- 사용자로부터 점수를 입력받아 학점 출력
DECLARE
    SCORE NUMBER;
    GRADE CHAR(1);
BEGIN
    SCORE := &점수;
    
    IF SCORE >= 90 THEN GRADE := 'A';
    ELSIF SCORE >= 80 THEN GRADE := 'B';
    ELSIF SCORE >= 70 THEN GRADE := 'C';
    ELSIF SCORE >= 60 THEN GRADE := 'D';
    ELSE GRADE := 'F';
    END IF;
    
    DBMS_OUTPUT.PUT_LINE('당신의 점수는 ' || SCORE || '점 이고, 학점은 ' || GRADE || '입니다');
END;
/
    
------------------------------------------ 실습문제 ---------------------------------------------
/*
    사용자로 부터 사번을 입력받아 사원의 급여를 조회하여 SAL변수에 저장
    500만원 이상이면 '고급'
    499 ~ 300만원 이면 '중급'
    나머지는 '초급'
*/





----------------------------------------------------------------------------------------------
/*
    4) CASE 문(SWITH CASE문과 동일)
    
    CASE 비교대상자
        WHEN 비교할값1 THEN 실행내용1
        WHEN 비교할값2 THEN 실행내용2
        WHEN 비교할값3 THEN 실행내용3
        ELSE 실행내용4
    END;    
*/

-- 사용자로부터 사번을 입력받아 DEPT_CODE를 조회
-- DEPT_CODE가 D1이면 인사관리부 .....

DECLARE
    EID EMPLOYEE.EMP_ID%TYPE;
    ENAME EMPLOYEE.EMP_NAME%TYPE;
    DCODE EMPLOYEE.DEPT_CODE%TYPE;
    DNAME VARCHAR2(30);
BEGIN
    SELECT EMP_ID, EMP_NAME ,DEPT_CODE
       INTO EID, ENAME, DCODE
      FROM EMPLOYEE
    WHERE EMP_ID = &사번;
    
   DNAME := CASE DCODE
                        WHEN 'D1' THEN '인사관리부'
                        WHEN 'D2' THEN '회계관리부'
                        WHEN 'D3' THEN  '마케팅부'
                        WHEN 'D4' THEN '국내영업부'
                        WHEN 'D8' THEN '기술지원부'
                        WHEN 'D9' THEN '총무부'
                        ELSE '해외영업부'
                     END;
                     
    DBMS_OUTPUT.PUT_LINE(ENAME || '는 ' || DNAME || '입니다');
END;
/
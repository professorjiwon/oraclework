/*
    <함수 function>
    전달된 컬럼값을 읽어들여 함수를 실행한 결과 반환
    
    - 단일행 함수 : N개의 값을 읽어들여 N개의 결과값 반환(매 행마다 실행)
    - 그룹 함수 : N개의 값을 읽어들여 1개의 결과값 반환(그룹별로 함수 실행)
    
    >> SELECT절에 단일행 함수와 그룹함수를 함께 사용할 수 없음
    >> 함수식을 기술할 수 있는 위치 : SELECT절, WHERE절, ORDER BY절, HAVING절
*/

---------------------------------- 단일행 함수 -------------------------------
--=========================================================================
--                                  문자처리 함수
--=========================================================================
/*
    LENGTH / LENGTHB => NUMBER로 반환
    
    LENGTH(컬럼|'문자열') : 해당 문자열의 글자수 반환
    LENGTHB(컬럼|'문자열') : 해당 문자열의 byte수 반환
      - 한글 : XE버전일 때 => 1글자당 3BYTE(ㄱ, ㅏ 등도 3BYTE)
              EE버전일 때 => 1글자당 2BYTE
      - 그외 : 1글자당 1BYTE
*/
SELECT LENGTH('오라클'), LENGTHB('오라클')
  FROM DUAL;   -- 오라클에서 제공하는 가상테이블

SELECT LENGTH('ORACLE'), LENGTHB('ORACLE')
  FROM DUAL;

SELECT EMP_NAME, LENGTH(EMP_NAME), LENGTHB(EMP_NAME),
       EMAIL, LENGTH(EMAIL), LENGTHB(EMAIL)
  FROM EMPLOYEE;

---------------------------------------------------------------------------
/*
    * INSTR : 문자열로부터 특정문자의 시작위치(INDEX)를 찾아서 반환(반환형:NUMBER)
      - ORACLE에서 INDEX번호는 1부터 시작.  찾을 문자가 없으면 0반환
      
     [표현법]
     INSTR(컬럼|'문자열', '찾고자하는 문자', [찾을위치의 시작값, [순번]])
       - 찾을위치 시작값
          1 : 앞에서부터 찾기(기본값)
          -1 : 뒤에서부터 찾기
*/

SELECT INSTR('JAVASCRIPTJAVAORACLE', 'A') FROM DUAL;
SELECT INSTR('JAVASCRIPTJAVAORACLE', 'A', 1) FROM DUAL;
SELECT INSTR('JAVASCRIPTJAVAORACLE', 'A', -1) FROM DUAL;
SELECT INSTR('JAVASCRIPTJAVAORACLE', 'A', 1, 3) FROM DUAL;
SELECT INSTR('JAVASCRIPTJAVAORACLE', 'A', -1, 2) FROM DUAL;

SELECT INSTR('JAVASCRIPTJAVAORACLE', 'A', 3) FROM DUAL;

SELECT EMAIL, INSTR(EMAIL, '_') "_의 위치", INSTR(EMAIL, '@') "@의 위치"
  FROM EMPLOYEE;

---------------------------------------------------------------------------
/*
    * SUBSTR : 문자열에서 특정 문자열을 추출하여 반환(반환형 : NUMBER)
    
    [표현법]
    SUBSTR(컬럼|'문자열', POSITION, [LENGTH])
      - POSITION : 문자열을 추추할 시작위치 INDEX
      - LENGTH : 추출할 문자의 갯수(생략시 마지막까지 추출)
*/

SELECT SUBSTR('ORACLEHTMLCSS', 7) FROM DUAL;
SELECT SUBSTR('ORACLEHTMLCSS', 7, 4) FROM DUAL;
SELECT SUBSTR('ORACLEHTMLCSS', 1, 6) FROM DUAL;
SELECT SUBSTR('ORACLEHTMLCSS', -7, 4) FROM DUAL;

-- EMPLOYEE에서 사원명, 주민번호, 성별(주민번호에서 성별만 추출하기)
SELECT EMP_NAME, EMP_NO, SUBSTR(EMP_NO,8,1) 성별
  FROM EMPLOYEE;
  
-- EMPLOYEE에서 여자사원들의 사원번호, 사원명, 성별 조회
SELECT EMP_ID, EMP_NAME, SUBSTR(EMP_NO,8,1) 성별
  FROM EMPLOYEE
 WHERE SUBSTR(EMP_NO,8,1) = '2' OR SUBSTR(EMP_NO,8,1) = '4';

-- EMPLOYEE에서 남자사원들의 사원번호, 사원명, 성별 조회
SELECT EMP_ID, EMP_NAME, SUBSTR(EMP_NO,8,1) 성별
  FROM EMPLOYEE
 WHERE SUBSTR(EMP_NO,8,1) IN (1,3)
 ORDER BY 2;

-- EMPLOYEE에서 사원명, 이메일, 아이디 조회
SELECT EMP_NAME, EMAIL, SUBSTR(EMAIL, 1, INSTR(EMAIL,'@')-1) "아이디"
  FROM EMPLOYEE;

SELECT EMAIL, INSTR(EMAIL,'@')
  FROM EMPLOYEE;
  
---------------------------------------------------------------------------
/*
    * LPAD / RPAD : 문자열을 조회할 때 통일감있게 조회하고자 할 때(반환형 : CHARACTER)
      
      [표현법]
      LPAD/RPAD('문자열', 최종적으로 반환할 문자의 길이, [덧붙이고자하는 문자])
       - 문자열에 덧붙이고자하는 문자를 왼쪽 또는 오른쪽에 덧붙여서 최종 N길이만큼의 문자열 반환
*/
-- EMPLOYEE에서 사원명, 이메일(길이 20, 오른쪽 정렬)
SELECT EMP_NAME, EMAIL, LPAD(EMAIL, 20)     -- 덧붙이고자하는 문자 생략시 공백으로 채워짐
  FROM EMPLOYEE;




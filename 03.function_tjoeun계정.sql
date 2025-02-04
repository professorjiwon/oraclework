/*
    <함수 FUNCTION>
    전달된 컬럼값을 읽어들여 함수를 실행한 결과를 반환
    
    - 단일행 함수 : n개의 값을 읽어들여 n개의 결과값 반환(매 행마다 함수 실행)
    - 그룹 함수 : n개의 값을 읽어들여 1개의 결과값 반환(그룹별로 함수 실행)
    
    >> SELECT절에 단일행 함수와 그룹함수를 함께 사용할 수 없음
    
    >> 함수식을 기술할 수 있는 위치 : SELECT절, WHERE절, ORDER BY절, HAVING절
*/

---------------------------------------------- 단일행 함수 -----------------------------------------------
--==============================================================
--                                                      <문자 처리 함수>
--==============================================================
/*
    * LENGTH / LENGTHB  => NUMBER로 반환
    
    LENGTH(컬럼|'문자열') : 해당 문자열의 글자수를 반환
    LENGTHB(컬럼|'문자열') : 해당 문자열의 byte를 반환
        - 한글 : XE버전일 때 => 1글자당 3byte (ㄱ, ㅏ, 등도 1글자에 해당)
                   EE버전일 때 => 1글자당 2byte
        - 그외 : 1글자당 1byte
*/

SELECT LENGTH('오라클'), LENGTHB('오라클')
FROM DUAL;      -- 오라클에서 제공해주는 가상테이블

SELECT LENGTH('oracle'), LENGTHB('oracle')
FROM DUAL;

SELECT EMP_NAME, LENGTH(EMP_NAME), LENGTHB(EMP_NAME), EMAIL, LENGTH(EMAIL), LENGTHB(EMAIL)
FROM EMPLOYEE;

---------------------------------------------------------------------------------------------------------
/*
    * INSTR : 문자열로 부터 특정 문자의 시작위치(INDEX)를 찾아서 반환(반환형 : NUMBER)
        - ORACLE은 INDEX번호는 1번부터 시작, 찾는 문자가 없을 때 0반환
        
    INSTR(컬럼|'문자열', '찾고자하는 문자', [찾을위치의 시작값, [순번]])
       - 찾을 위치값
         1: 앞에서부터 찾기(기본값)
         -1 : 뒤에서부터 찾기
*/

SELECT INSTR('JAVASCRIPTJAVAORACLE', 'A') FROM DUAL;
SELECT INSTR('JAVASCRIPTJAVAORACLE', 'A', 1) FROM DUAL;
SELECT INSTR('JAVASCRIPTJAVAORACLE', 'A', 3) FROM DUAL;
SELECT INSTR('JAVASCRIPTJAVAORACLE', 'A', -1) FROM DUAL;

SELECT INSTR('JAVASCRIPTJAVAORACLE', 'A', 1, 3) FROM DUAL;    -- 앞에서부터 3번째 나오는 A의 INDEX번호
SELECT INSTR('JAVASCRIPTJAVAORACLE', 'A', -1, 2) FROM DUAL; 

SELECT EMAIL, INSTR(EMAIL, '_') "_위치", INSTR(EMAIL, '@') "@위치"
FROM EMPLOYEE;

---------------------------------------------------------------------------------------------------------
/*
    * SUBSTR : 문자열에서 특정 문자열을 추출하여 반환(반환형 : CHARACTER)
    
      SUBSTR('문자열', POSITION, [LENGTH])
        - POSITION : 문자열을 추출할 시작위치  INDEX
        - LENGTH : 추출할 문자의 갯수(생략시 맨 마지막까지 추출)
*/

SELECT SUBSTR('ORACLEHTMLCSS', 7) FROM DUAL;
SELECT SUBSTR('ORACLEHTMLCSS', 7, 4) FROM DUAL;
SELECT SUBSTR('ORACLEHTMLCSS', 1, 6) FROM DUAL;
SELECT SUBSTR('ORACLEHTMLCSS', -3) FROM DUAL;
SELECT SUBSTR('ORACLEHTMLCSS', -7, 4) FROM DUAL;

-- EMPLOYEE테이블에서 주민번호에서 성별만 추출하여 사원명, 주민번호, 성별을 조회
SELECT EMP_NAME, EMP_NO, SUBSTR(EMP_NO, 8, 1) 성별
FROM EMPLOYEE;

-- EMPLOYEE테이블에서 주민번호에서 성별만 추출하여 여성 사원만 사원명, 주민번호, 성별을 조회
SELECT EMP_NAME, EMP_NO, SUBSTR(EMP_NO, 8, 1) 성별
FROM EMPLOYEE
WHERE SUBSTR(EMP_NO, 8, 1) IN ('2', '4');

-- EMPLOYEE테이블에서 주민번호에서 성별만 추출하여 남성 사원만 사원명, 주민번호, 성별을 조회
SELECT EMP_NAME, EMP_NO, SUBSTR(EMP_NO, 8, 1) 성별
FROM EMPLOYEE
WHERE SUBSTR(EMP_NO, 8, 1) IN ('1', '3');

-- EMPLOYEE테이블에서 EMAIL에서 아이디만 추출하여 사원명, 이메일, 아이디를 조회
SELECT EMP_NAME, EMAIL, SUBSTR(EMAIL, 1, INSTR(EMAIL, '@')-1) 아이디
FROM EMPLOYEE;

---------------------------------------------------------------------------------------------------------
/*
    * LPAD / RPAD : 문자열을 조회할 때 통일감있게 자리수에 맞춰서 조회하고자 할 때(반환형 : CHARACTER)

      LPAD/RPAD('문자열', 최종적으로 반환할 문자의 길이, [덧붙이고자하는 문자])
      : 문자열에 덧이붙이고자하는 문자를 왼쪽 또는 오른쪽에 덧붙여서 최종 n길이 만큼의 문자열 반환
*/

SELECT EMP_NAME, LPAD(EMAIL, 25)
FROM EMPLOYEE;

SELECT EMP_NAME, LPAD(EMAIL, 25, '#')
FROM EMPLOYEE;

SELECT EMP_NAME, RPAD(EMAIL, 25, '#')
FROM EMPLOYEE;

-- EMPLOYEE테이블에서 주민번호를 123456-1****** 형식 사번, 사원명, 주민번호(형식에 맞춰) 조회
SELECT EMP_ID, EMP_NAME, RPAD(SUBSTR(EMP_NO, 1, 8), 14, '*') 주민번호
FROM EMPLOYEE;

SELECT EMP_ID, EMP_NAME, SUBSTR(EMP_NO, 1, 8) || '******' 주민번호
FROM EMPLOYEE;

---------------------------------------------------------------------------------------------------------
/*
    * LTRIM / RTRIM : 문자열에서 특정 문자를 제거한 나머지 반환(반환형: CHARACTER)
    * TRIM : 문자열의 앞/뒤 양쪽에 있는 특정 문자를 제거한 나머지 반환
    
    [표현법]
    LTRIM / RTRIM('문자열', [제거하고자하는 문자])
    TRIM([LEADING|TRAILING|BOTH] 제거하고자하는 문자들 FROM '문자열') => 제거하고자하는 문자는 1개만 가능
*/

SELECT LTRIM('     TJOEUN     ') || '더조은' FROM DUAL;  -- 제거할 문자를 않넣으면 공백 제거
SELECT RTRIM('     TJOEUN     ') || '더조은' FROM DUAL;

SELECT LTRIM('JAVAJAVASCRIPTJAVA', 'JAVA') FROM DUAL;
SELECT LTRIM('BAABCABFDSIA', 'ABC') FROM DUAL;
SELECT LTRIM('37284DKI2637', '0123456789') FROM DUAL;

SELECT RTRIM('JAVAJAVASCRIPTJAVA', 'JAVA') FROM DUAL;
SELECT RTRIM('BAABCABFDSIA', 'ABC') FROM DUAL;
SELECT RTRIM('37284DKI2637', '0123456789') FROM DUAL;

SELECT TRIM('     TJOEUN     ') || '더조은' FROM DUAL;

SELECT TRIM(LEADING 'A' FROM 'AAABKADAISLAAAA') FROM DUAL;
SELECT TRIM(TRAILING 'A' FROM 'AAABKADAISLAAAA') FROM DUAL;
SELECT TRIM(BOTH 'A' FROM 'AAABKADAISLAAAA') FROM DUAL;
SELECT TRIM('A' FROM 'AAABKADAISLAAAA') FROM DUAL;   -- BOTH 기본값 생략가능

---------------------------------------------------------------------------------------------------------
/*
    * LOWER / UPPER / INITCAP : 문자열을 모두 대문자로 혹은 소문자로, 첫글자만 대문자로 변환(반환형: CHARACTER)
      
      [표현법]
      LOWER / UPPER / INITCAP('문자열)
*/

SELECT LOWER('JAVA JAVASCRIPT Oracle') FROM DUAL;
SELECT UPPER('JAVA JAVASCRIPT Oracle') FROM DUAL;
SELECT INITCAP('JAVA JAVASCRIPT Oracle') FROM DUAL;

---------------------------------------------------------------------------------------------------------
/*
    * CONCAT : 문자열 2개를 전달받아 하나로 합친 문자 반환
      
      [표현법]
      CONCAT('문자열', '문자열')
*/
SELECT CONCAT('Oracle', '오라클') from dual;
SELECT 'Oracle' || '오라클' FROM DUAL;

-- SELECT CONCAT('Oracle', '오라클', '참 재미있어요') from dual; -- 문자열 2개만 가능
SELECT 'Oracle' || '오라클' || '참 재미있어요' FROM DUAL;

---------------------------------------------------------------------------------------------------------
/*
    * REPLACE : 기존문자열을 새로운 문자열로 바꿈
    
      [표현법]
      REPLACE('문자열', '기존문자열', '바꿀문자열')
*/

SELECT EMP_NAME, EMAIL, REPLACE(EMAIL, 'tjoeun.or.kr', 'naver.com')
FROM EMPLOYEE;







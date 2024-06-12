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
SELECT EMP_NAME, EMAIL, LPAD(EMAIL, 25)     -- 덧붙이고자하는 문자 생략시 공백으로 채워짐
  FROM EMPLOYEE;

SELECT EMP_NAME, EMAIL, LPAD(EMAIL, 25, '#') 
  FROM EMPLOYEE;

SELECT EMP_NAME, EMAIL, RPAD(EMAIL, 25, '#') 
  FROM EMPLOYEE;
  
-- EMPLOYEE에서 사번, 사원명, 주민번호(단, 123456-1******형식으로 출력) 조회
SELECT EMP_ID, EMP_NAME, RPAD(SUBSTR(EMP_NO, 1, 8), 14, '*') 주민번호
  FROM EMPLOYEE;
  
SELECT EMP_ID, EMP_NAME, SUBSTR(EMP_NO, 1, 8) || '******'
  FROM EMPLOYEE;
  
---------------------------------------------------------------------------  
/*
    * LTRIM/RTRIM : 문자열에서 특정문자를 제거한 나머지를 반환(반환형: CHARACTER )
    * TRIM : 문자열에서 앞/뒤 양쪽에 있는 특정문자를 제거한 나머지를 반환
        - 주의사항 : 제거할 문자 1글자만 가능
        
    [표현법]
    LTRIM / RTRIM('문자열',[제거하고자하는 문자들])
    TRIM([LEADING|TRAILING|BOTH]제거하고자하는 문자들 FROM  '문자열')
       
    문자열의 왼쪽 또는 오른쪽으로 제거하고자하는 문자들을 찾아서 제거한 나머지 문자열 반환
*/
-- 제거하고자하는 문자를 넣지않으면 공백 제거
SELECT LTRIM('     tjoeun     ')||'학원' FROM DUAL;
SELECT RTRIM('     tjoeun     ')||'학원' FROM DUAL;

SELECT LTRIM('JAVAJAVASCRIPT','JAVA') FROM DUAL;
SELECT LTRIM('BACACABCFIACB','ABC') FROM DUAL;
SELECT LTRIM('37284BAC38290','0123456789') FROM DUAL;

SELECT RTRIM('BACACABCFIACB','ABC') FROM DUAL;
SELECT RTRIM('37284BAC38290','0123456789') FROM DUAL;

-- BOTH가 기본값 : 양쪽제거
SELECT TRIM('     tjoeun     ')||'학원' FROM DUAL;
SELECT TRIM('A' FROM 'AAABKSLEIDKAAA') FROM DUAL;   -- 1글자만 가능
SELECT TRIM(BOTH 'A' FROM 'AAABKSLEIDKAAA') FROM DUAL;

SELECT TRIM(LEADING 'A' FROM 'AAABKSLEIDKAAA') FROM DUAL;
SELECT TRIM(TRAILING 'A' FROM 'AAABKSLEIDKAAA') FROM DUAL;

---------------------------------------------------------------------------  
/*
    * LOWER / UPPER / INITCAP : 문자열을 대소문자로 변환 및 단어의 앞글자만 대문자로 변환
    
    [표현법]
    LOWER('문자열')
*/
SELECT LOWER('Java JavaScript Oracle') from dual;
SELECT UPPER('Java JavaScript Oracle') from dual; 
SELECT INITCAP('java javaScript oracle') from dual;

-- EMPLOYEE에서 EMAIL 대문자로 출력
SELECT EMAIL, UPPER(EMAIL)
  FROM EMPLOYEE;
 
---------------------------------------------------------------------------  
/*
    * CONCAT : 문자열 두개를 하나로 합친 후 반환
    
    [표현법]
    CONCAT('문자열','문자열')
*/
SELECT CONCAT('Oracle','오라클') FROM DUAL;
SELECT 'Oracle'||'오라클' FROM DUAL;

-- SELECT CONCAT('Oracle','오라클','02-1234-5678') FROM DUAL;  -- 문자열 2개만 넣을 수 있음
SELECT 'Oracle'||'오라클'||'02-1234-5678' FROM DUAL;

---------------------------------------------------------------------------  
/*
    * REPLACE : 기존문자열을 새로운 문자열로 바꿈
    
    [표현법]
    REPLACE('문자열','기존문자열','바꿀문자열')
*/
-- EMPLOYEE에서 EMAIL의 문자를 tjoeun.or.kr -> naver.com으로 바꾸어 출력
SELECT REPLACE(EMAIL, 'tjoeun.or.kr', 'naver.com')
  FROM EMPLOYEE;
  
--=========================================================================
--                                  숫자처리 함수
--=========================================================================  

/*
    * ABS : 숫자의 절대값을 구하는 함수
    
    [표현법]
    ABS(NUMBER)
*/
SELECT ABS(-5) FROM DUAL;
SELECT ABS(-3.14) FROM DUAL;

---------------------------------------------------------------------------  
/*
    * MOD : 두 수를 나눈 나머지값 반환하는 함수
    
    [표현법]
    MOD(NUMBER, NUMBER)
*/
SELECT MOD(10,3) FROM DUAL;

---------------------------------------------------------------------------  
/*
    * ROUND : 반올림한 결과 반환
    
    [표현법]
    ROUND(NUMBER, [위치])
*/
SELECT ROUND(1234.567) FROM DUAL;
SELECT ROUND(1234.123) FROM DUAL;
SELECT ROUND(1234.123, 2) FROM DUAL;
SELECT ROUND(1234.127, 2) FROM DUAL;
SELECT ROUND(1234567, -2) FROM DUAL;

---------------------------------------------------------------------------  
/*
    * CEIL : 올림한 결과 반환
    
    [표현법]
    ROUND(NUMBER)
*/
SELECT CEIL(123.4566) FROM DUAL;
SELECT CEIL(-123.4566) FROM DUAL;

---------------------------------------------------------------------------  
/*
    * FLOOR : 내림한 결과 반환
    
    [표현법]
    FLOOR(NUMBER)
*/
SELECT FLOOR(123.987) FROM DUAL;
SELECT FLOOR(-123.987) FROM DUAL;

---------------------------------------------------------------------------  
/*
    * TRUNC : 위치 지정 가능한 버리처리 함수
    
    [표현법]
    TRUNC(NUMBER, [위치지정])
*/
SELECT TRUNC(123.789) FROM DUAL;
SELECT TRUNC(123.789, 1) FROM DUAL;
SELECT TRUNC(123.789, -1) FROM DUAL;

SELECT TRUNC(-123.789) FROM DUAL;
SELECT TRUNC(-123.789, -2) FROM DUAL;

--=========================================================================
--                                  날짜처리 함수
--=========================================================================  
/*
    * SYSDATE : 시스템 날짜 및 시간 반환
*/
SELECT SYSDATE FROM DUAL;

---------------------------------------------------------------------------  
/*
    * MONTHS_BETWEEN(DATE1, DATE2) : 두 날짜 사이의 개월수
    
    [표현법]
    MONTHS_BETWEEN(날짜, 날짜)
*/
SELECT EMP_NAME, HIRE_DATE, SYSDATE-HIRE_DATE "근무일수"
  FROM EMPLOYEE;

SELECT EMP_NAME, HIRE_DATE, CEIL(SYSDATE-HIRE_DATE) "근무일수"
  FROM EMPLOYEE;

SELECT EMP_NAME, HIRE_DATE, MONTHS_BETWEEN(SYSDATE, HIRE_DATE) "근무개월수"
  FROM EMPLOYEE;
  
SELECT EMP_NAME, HIRE_DATE, CEIL(MONTHS_BETWEEN(SYSDATE, HIRE_DATE)) "근무개월수"
  FROM EMPLOYEE;
  
SELECT EMP_NAME, HIRE_DATE, CEIL(MONTHS_BETWEEN(SYSDATE, HIRE_DATE)) || '개월차' "근무개월수"
  FROM EMPLOYEE;  
  
SELECT EMP_NAME, HIRE_DATE, CONCAT(CEIL(MONTHS_BETWEEN(SYSDATE, HIRE_DATE)), '개월차') "근무개월수"
  FROM EMPLOYEE;
  
---------------------------------------------------------------------------  
/*
    * ADD_MONTHS(DATE, NUMBER) : 특정날짜에 해당 숫자만큼 개월수르 더해  반환
*/

SELECT ADD_MONTHS(SYSDATE, 1) FROM DUAL;

-- EMPLOYEE에서 사원명, 입사일, 입사후 정직원된 날짜(입사후 6개월) 조회
SELECT EMP_NAME, HIRE_DATE, ADD_MONTHS(HIRE_DATE, 6) "정직원된 날짜"
  FROM EMPLOYEE;

---------------------------------------------------------------------------  
/*
    * NEXT_DAY(DATE, 요일[문자|숫자]) : 특정 날짜 이후에 가까운 해당 요일의 날짜를 반환해주는 함수
      - 1: 일요일
*/
SELECT SYSDATE, NEXT_DAY(SYSDATE, '금요일') FROM DUAL;
SELECT SYSDATE, NEXT_DAY(SYSDATE, '금') FROM DUAL;

SELECT SYSDATE, NEXT_DAY(SYSDATE, 6) FROM DUAL;
-- SELECT SYSDATE, NEXT_DAY(SYSDATE, 'FRIDAY') FROM DUAL;   -- 오류 : 현재언어가 KOREA아기 때문

-- 언어변경
ALTER SESSION SET NLS_LANGUAGE = AMERICAN;
SELECT SYSDATE, NEXT_DAY(SYSDATE, 'FRIDAY') FROM DUAL;
-- SELECT SYSDATE, NEXT_DAY(SYSDATE, '금요일') FROM DUAL;   -- 오류 

ALTER SESSION SET NLS_LANGUAGE = KOREAN;

---------------------------------------------------------------------------  
/*
    * LAST_DAY(DATE) : 해당월의 마지막 날짜를 반환해주는 함수
*/

SELECT LAST_DAY(SYSDATE) FROM DUAL;

-- EMPLOYEE에서 사원명, 입사일, 입사한 날의 마지막 날짜 조회




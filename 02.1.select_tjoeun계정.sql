/*
    (') 홑따옴표 : 문자열을 감싸주는 기호
    (") 쌍따옴표 : 컬럼명을 감싸주는 기호
*/
/*
    <SELECT>
    데이터를 조회할 때 사용하는 구문
    
    >> RESULT SET : SELECT문을 통해 조회된 결과물(조회된 행들의 집합)
    
    [표현법]
    SELECT 조회하고자하는 컬럼명, 컬럼명, ....
    FROM 테이블명;
*/

-- EMPLOYEE테이블에서 모든 컬럼(*) 조회
SELECT *
FROM employee;

-- EMPLOYEE테이블에서 사번, 이름, 급여만 조회
SELECT EMP_ID, EMP_NAME, SALARY
FROM EMPLOYEE;

-- JOB테이블 모두 컬럼 조회
SELECT *
FROM JOB;

--------------------------------- 실습문제 ---------------------------------
-- 1. JOB테이블에 직급명만 출력
SELECT JOB_NAME
FROM JOB;

-- 2. DEPARTMENT테이블의 모든 컬럼 조회
SELECT *
FROM DEPARTMENT;

-- 3. DEPARTMENT테이블의 부서코드, 부서명 조회
SELECT DEPT_ID, DEPT_TITLE
FROM DEPARTMENT;

-- 4. EMPLOYEE테이블에서 사원명, 이메일, 전화번호, 입사일, 급여 조회
SELECT EMP_NAME, EMAIL, PHONE, HIRE_DATE, SALARY
FROM EMPLOYEE;
-------------------------------------------------------------------------------
/*
    <컬럼값을 통한 산술연산>
    SELECT절 컬럼명 작성부부에 산술연산 기술할 수 있음(산술연산된 결과 조회)
*/
-- EMPLOYEE테이블에서 사원명, 사원의 연봉(급여*12) 조회
SELECT EMP_NAME, SALARY*12
FROM EMPLOYEE;

-- EMPLOYEE테이블에서 사원명, 급여, 보너스, 연봉, 보너스가포함된연봉 조회
SELECT EMP_NAME, SALARY, BONUS, SALARY*12, (SALARY*BONUS + SALARY)*12
FROM EMPLOYEE;
 -- > 산술연산 과정 중 NULL값이 존재할 경우 산술연산한 결과값도 무조건 NULL값으로 나옴
 
 -- EMPLOYEE테이블에서 사원명, 입사일, 근무일수 조회
 -- DATE형식도 연산가능 : 결과값 일 단위
 -- * 오늘 날짜 : SYSDATE
 SELECT EMP_NAME, HIRE_DATE, SYSDATE-HIRE_DATE
 FROM EMPLOYEE;
   -- > 근무일수에 소수점이하는 시분초 단위로 계산하기 때문
   
---------------------------------------------------------------------------------------------
/*
    <컬럼명에 별칭 지정하기>
    산술연산시 컬럼명이 산술에 들어간 수식 그대로 컬럼명이 됨. 이때 별칭을 부여할 수 있다
    
    [표현법]
    컬럼명 별칭  /  컬럼명 AS 별칭  /  컬럼명 "별칭"  /  컬럼명 AS "별칭"
    
    * 반드시 (" ")쌍따옴표가 들어가야 하는 경우
       별칭에 띄어쓰기가 있거나, 특수문자가 포함되어 있는 경우
*/

-- EMPLOYEE테이블에서 사원명, 급여, 보너스, 연봉, 보너스가포함된연봉 조회
SELECT EMP_NAME, SALARY, BONUS, SALARY*12 연봉, (SALARY*BONUS + SALARY)*12 "보너스포함 연봉"
FROM EMPLOYEE;

SELECT EMP_NAME, SALARY, BONUS, SALARY*12 "연봉(원)", (SALARY*BONUS + SALARY)*12 "보너스포함 연봉"
FROM EMPLOYEE;
---------------------------------------------------------------------------------------------
/*
    <리터럴>
    임의로 지정한 문자열을 컬럼처럼 넣을 수 있음
    
    SELECT절에 리터럴을 넣으면 마치 테이블상에 존재하는 데이터처럼 조회 가능
    조회된 RESULT SET의 모든 행에 반복적으로 같이 출력
*/

-- EMPLOYEE 테이블에서 사번, 사원명, 급여, 원 조회
SELECT EMP_ID, EMP_NAME, SALARY, '원' 단위
FROM EMPLOYEE;

-- EMPLOYEE 테이블에서 사번, 사원명, 급여, 원, 보너스, % 조회
SELECT EMP_ID, EMP_NAME, SALARY, '원' AS 단위, BONUS, '%' "단위(%)"
FROM EMPLOYEE;

---------------------------------------------------------------------------------------------
/*
    <연결 연산자 : || >
    여러 컬럼값들을 마치 하나의 컬럼인것처럼 연결하거나, 컬럼값과 리터럴을 연결할 수 있음
*/

-- EMPLOYEE테이블에서 사번, 사원명, 급여를 하나의 컬럼으로 조회
SELECT EMP_ID, EMP_NAME, SALARY
FROM EMPLOYEE;

SELECT EMP_ID || EMP_NAME || SALARY 종합정보
FROM EMPLOYEE;

-- EMPLOYEE테이블에서 ???의 월급은 ???원 입니다 1컬럼으로 조회
SELECT EMP_NAME || '의 월급은 ' || SALARY || '원 입니다'
FROM EMPLOYEE;

-- EMPLOYEE테이블에서 사원명, 급여원 으로 조회
-- ex) 김정보  |  8000000원
SELECT EMP_NAME, SALARY || '원' 급여
FROM EMPLOYEE;

---------------------------------------------------------------------------------------------
/*
    <DISTINCT>
    컬럼에 중복된 값들은 한번씩만 표시
*/
-- EMPLOYEE테이블에서 직급코드 조회
SELECT JOB_CODE
FROM EMPLOYEE;

-- EMPLOYEE테이블에서 직급코드의 중복제거한 데이터 조회
SELECT DISTINCT JOB_CODE
FROM EMPLOYEE;

-- EMPLOYEE테이블에서 부서코드의 중복제거한 데이터 조회
SELECT DISTINCT DEPT_CODE
FROM EMPLOYEE;

-- 유의사항 : DISTINCT는 SELECT절에서 딱 한번만 기술 가능
/*  오류
SELECT DISTINCT JOB_CODE,  DISTINCT DEPT_CODE
FROM EMPLOYEE;
*/

SELECT DISTINCT JOB_CODE,  DEPT_CODE
FROM EMPLOYEE;
-- 조합으로 겹치지 않는것 조회(J1-D1, J1-D2)

---------------------------------------------------------------------------------------------
/*
    <WHERE절>
    조회하고자하는 테이블에서 특정 조건에 맞는 데이터만 조회할 때
    WHERE절에 조건식을 제시함
    조건식에는 다양한 연산자들 사용 가능
    
    [표현법]
    SELECT 컬럼1, 컬럼2, ...
    FROM 테이블명
    WHERE 조건식;
    
    *  비교연산자
    대소비교 : >, <, >=, >=
    같은지 비교 : =
    같지 않은지 비교 : !=, ^=, <>
*/

-- EMPLOYEE테이블에서 부서코드가 'D9'인 사원들의 모든 컬럼 조회
SELECT *
FROM EMPLOYEE
WHERE DEPT_CODE = 'D9';

-- EMPLOYEE테이블에서 부서코드가 'D1'인 사원들의 사번, 사원명, 부서코드 조회
SELECT EMP_ID, EMP_NAME, DEPT_CODE
FROM EMPLOYEE
WHERE DEPT_CODE = 'D1';

-- EMPLOYEE테이블에서 부서코드가 'D1'이 아닌 사원들의 사번, 사원명, 부서코드 조회
SELECT EMP_ID, EMP_NAME, DEPT_CODE
FROM EMPLOYEE
-- WHERE DEPT_CODE != 'D1';
-- WHERE DEPT_CODE ^= 'D1';
WHERE DEPT_CODE <> 'D1';

-- EMPLOYEE테이블에서 급여가 400만원 이상인 사원들의 사원명, 부서코드, 급여 조회
SELECT EMP_NAME, DEPT_CODE, SALARY
FROM EMPLOYEE
WHERE SALARY >= 4000000;

-- EMPLOYEE테이블에서 재직중인 사원들의 사번, 사원명, 입사일, 퇴직여부 조회
SELECT EMP_ID, EMP_NAME, HIRE_DATE, ENT_YN
FROM EMPLOYEE
WHERE ENT_YN = 'N';

--------------------------------- 실습문제 ---------------------------------
-- EMPLOYEE테이블에서
--1. 급여가 300만원 이상인 사원들의 사원명, 급여, 입사일, 연봉 조회
SELECT EMP_NAME, SALARY, HIRE_DATE, SALARY*12 연봉
FROM EMPLOYEE
WHERE SALARY >= 3000000;

--2. 연봉이 5000만원 이상인 사원들의 사원명, 급여, 연봉, 부서코드 조회
SELECT EMP_NAME, SALARY, SALARY*12 연봉, DEPT_CODE
FROM EMPLOYEE
WHERE SALARY*12 >= 50000000;

--3. 직급코드가 'J3'이 아닌 사원들의 사번, 사원명, 직급코드, 퇴사여부 조회
SELECT EMP_ID, EMP_NAME, JOB_CODE, ENT_YN
FROM EMPLOYEE
WHERE JOB_CODE != 'J3';

---------------------------------------------------------------------------------------------
/*
    <논리 연산자>
    여러개의 조건을 묶어서 제시하고자 할 때
    
    AND (~이면서, 그리고)  
    OR (~이거나, 또는)     
*/

-- EMPLOYEE테이블에서 부서코드가 'D9'이면서 급여가 500만원 이상인 사원들의 사원명, 부서코드, 급여 조회
SELECT EMP_NAME, DEPT_CODE,  SALARY
FROM EMPLOYEE
WHERE DEPT_CODE = 'D9' AND SALARY >= 5000000;

-- EMPLOYEE테이블에서 부서코드가 'D6'이거나 급여가 300만원 이상인 사원들의 사원명, 부서코드, 급여 조회
SELECT EMP_NAME, DEPT_CODE, SALARY
FROM EMPLOYEE
WHERE DEPT_CODE = 'D6' OR SALARY >= 3000000;

-- EMPLOYEE테이블에서  급여가 350만원 이상 600만원 이하인 사원들의 사번, 사원명, 급여 조회
SELECT EMP_ID, EMP_NAME, SALARY
FROM EMPLOYEE
WHERE SALARY >= 3500000 AND SALARY <= 6000000;
-- WHERE 3500000 <= SALARY <= 6000000;  오류

---------------------------------------------------------------------------------------------
/*
    <BETWEEN AND>
    조건식에서 사용되는 구문
    ~ 이상 ~이하인 범위에 대한 조건 제시에 사용되는 연산자
    
    [표현법]
    비교대상컬럼 BETWEEN 하한값 AND 상한값
    -> 해당 컬럼값이 하한값 이상이고 상한값 이하인 데이터
*/

-- EMPLOYEE테이블에서  급여가 350만원 이상 600만원 이하인 사원들의 사번, 사원명, 급여 조회
SELECT EMP_ID, EMP_NAME, SALARY
FROM EMPLOYEE
WHERE SALARY BETWEEN 3500000 AND 6000000;

-- EMPLOYEE테이블에서  급여가 350만원 미만 600만원 초과인 사원들의 사번, 사원명, 급여 조회
SELECT EMP_ID, EMP_NAME, SALARY
FROM EMPLOYEE
-- WHERE SALARY < 3500000 OR SALARY > 6000000;
WHERE NOT SALARY BETWEEN 3500000 AND 6000000;
-- NOT : 논리부정 연산자
-- 컬럼명 앞 또는 BETWEEN앞에 기입

-- EMPLOYEE테이블에서 입사일이 '90/01/01 ~ 99/12/31' 인 사원들의 사번, 사원명, 입사일 조회
SELECT EMP_ID, EMP_NAME, HIRE_DATE
FROM EMPLOYEE
-- WHERE HIRE_DATE >= '90/01/01' AND HIRE_DATE <= '99/12/31';
WHERE HIRE_DATE BETWEEN '90/01/01' AND '99/12/31';

---------------------------------------------------------------------------------------------
/*
    <LIKE>
    비교하고자하는 컬럼값이 내가 제시한 특정패턴에 만족하는 경우 조회
    
    [표현법]
    비교대상컬럼 LIKE '특정패턴'
     -> 특정패턴 : '%', '_' 와일드카드로 사용할 수 있음
     
     >> '%' : 0글자 이상
       ex) 비교대상컬럼 LIKE '문자%' => 비교대상 컬럼값이 '문자'로 시작하는 데이터 조회
            비교대상컬럼 LIKE '%문자' => 비교대상 컬럼값이 '문자'로 끝나는 데이터 조회
            비교대상컬럼 LIKE '%문자%' => 비교대상 컬럼값이 '문자'가 포함된 데이터 조회
            
    >> '_' : 1글자
       ex) 비교대상컬럼 LIKE '_문자' => 비교대상 컬럼값이 '문자'앞에 무조건 한글자가 있는 데이터 조회
            비교대상컬럼 LIKE '__문자' => 비교대상 컬럼값이 '문자'앞에 무조건 두글자가 있는 데이터 조회
            비교대상컬럼 LIKE '_문자_' => 비교대상 컬럼값이 '문자'앞에 무조건 한글자, 뒤에도 무조건 한글자가 있는 데이터 조회
       
*/

-- EMPLOYEE테이블에서 사원들 성이 전씨인 사원들의 사원명, 급여, 입사일 조회
SELECT EMP_NAME, SALARY, HIRE_DATE
FROM EMPLOYEE
WHERE EMP_NAME LIKE '전%';

-- EMPLOYEE테이블에서 사원들 이름에 '하'가 포함되어 있는 사원들의 사원명, 주민번호, 전화번호 조회
SELECT EMP_NAME, EMP_NO, PHONE
FROM EMPLOYEE
WHERE EMP_NAME LIKE '%하%';

-- EMPLOYEE테이블에서 사원들 이름에 '하'가 중간에 들어있는 사원들의 사원명, 전화번호 조회
SELECT EMP_NAME, PHONE
FROM EMPLOYEE
WHERE EMP_NAME LIKE '_하_';

-- EMPLOYEE테이블에서 전화번호의 3번째 자리가 '1'인 사원의  사번, 사원명, 전화번호 조회
SELECT EMP_ID, EMP_NAME, PHONE
FROM EMPLOYEE
WHERE PHONE LIKE '__1%';

-- EMPLOYEE테이블에서 이메일에 _앞에 글자가 3글자인 사원의 사원명, 이메일 조회
SELECT EMP_NAME, EMAIL
FROM EMPLOYEE
WHERE EMAIL LIKE '____%';  -- 언더바 4개로 인식 글자가 4글자 이상을 가져옴. 원했던 결과가 아님
/*
    * '_'가 와일드카드 인지 데이터값인지 구분지어야 함
      -> 데이터값으로 취급하고자하는 값 앞에 나만의 와일드카드(아무거나 가능)를 제시하고 ESCAPE에 등록한다.
          *  특수기호 중 '&'를 쓰면 오라클에서는 사용자로부터 입력받는 키워드이므로 안쓰는 것이 좋다
*/

SELECT EMP_NAME, EMAIL
FROM EMPLOYEE
WHERE EMAIL LIKE '___$_%' ESCAPE '$';

-- 위 예제의 사원들을 제외한 다른 사원들 조회
SELECT EMP_NAME, EMAIL
FROM EMPLOYEE
WHERE NOT EMAIL LIKE '___w_%' ESCAPE 'w';

--------------------------------- 실습문제 ---------------------------------
--1. EMPLOYEE에서 이름이 '연'으로 끝나는 사원들의 사원명, 입사일 조회
SELECT EMP_NAME, HIRE_DATE
FROM EMPLOYEE
WHERE EMP_NAME LIKE '%연';

--2. EMPLOYEE에서 전화번호 처음 3자리가 010이 아닌 사원들의 사원명, 전화번호 조회
SELECT EMP_NAME, PHONE
FROM EMPLOYEE
WHERE NOT PHONE LIKE '010%';

--3. EMPLOYEE에서 이름에 '하'가 포함되어 있고 급여가 240만원 이상인 사원들의 사원명, 급여 조회
SELECT EMP_NAME, SALARY
FROM EMPLOYEE
WHERE EMP_NAME LIKE '%하%' AND SALARY >= 2400000;

--4. DEPARTMENT에서 해외영업부인 부서들의 부서코드, 부서명 조회
SELECT DEPT_ID, DEPT_TITLE
FROM DEPARTMENT
WHERE DEPT_TITLE LIKE '해외영업%';

---------------------------------------------------------------------------------------------
/*
    <IS NULL / IS NOT NULL>
    컬럼값이 NULL인 경우, NULL값 비교에 사용하는 연산자
*/

-- EMPLOYEE테이블에서 보너스를 받지 않는 사원들의 사번, 사원명, 급여, 보너스 조회
SELECT EMP_ID, EMP_NAME, SALARY, BONUS
FROM EMPLOYEE
-- WHERE BONUS = NULL;    --조회 안됨
WHERE BONUS IS NULL;

-- EMPLOYEE테이블에서 보너스를 받는 사원들의 사번, 사원명, 급여, 보너스 조회
SELECT EMP_ID, EMP_NAME, SALARY, BONUS
FROM EMPLOYEE
WHERE BONUS IS NOT NULL;
-- NOT은 컬럼명 앞에 넣어도 됨

-- EMPLOYEE테이블에서  사수가 없는 사원들의 사원명, 부서코드, 사수번호 조회
SELECT EMP_NAME, DEPT_CODE, MANAGER_ID
FROM EMPLOYEE
WHERE MANAGER_ID IS NULL;

-- EMPLOYEE테이블에서  부서배치를 받지 못했지만 보너스를 받는 사원들의 사번, 사원명, 부서코드, 보너스 조회
SELECT EMP_ID, EMP_NAME, DEPT_CODE, BONUS
FROM EMPLOYEE
WHERE DEPT_CODE IS NULL AND BONUS IS NOT NULL;

---------------------------------------------------------------------------------------------
/*
    <IN / NOT IN>
    IN : 컬럼값이 내가 제시한 목록중에 일치하는 값이 있는 데이터만 조회
    NOT IN : 컬럼값이 내가 제시한 목록중에 일치하는 값을 제외한 나머지 데이터만 조회
    
    [표현법]
    비교대상컬럼명 IN ('값1', '값2', ... )
*/

-- EMPLOYEE테이블에서  부서코드가 D6이거나 D8이거나 D9인 사원의 사원명, 부서코드, 급여조회
SELECT EMP_NAME, DEPT_CODE, SALARY
FROM EMPLOYEE
-- WHERE DEPT_CODE = 'D6' OR DEPT_CODE = 'D8' OR DEPT_CODE = 'D9';
WHERE DEPT_CODE IN ('D6', 'D8', 'D9');

-- EMPLOYEE테이블에서  부서코드가 D6이거나 D8이거나 D9인 사원을 제외한 나머지 사원들의 사원명, 부서코드, 급여조회
SELECT EMP_NAME, DEPT_CODE, SALARY
FROM EMPLOYEE
WHERE DEPT_CODE NOT IN ('D6', 'D8', 'D9');

---------------------------------------------------------------------------------------------
/*
    <연산자 우선순위>
    1. ()
    2. 산술연산자
    3. 연결연산자
    4. 비교연산자
    5. IS NULL / LIKE '특정패턴' / IN
    6. BETWEEN AND
    7. NOT(논리연산자)
    8. AND(논리연산자)
    9. OR(논리연산자)
    
    ** OR보다 AND가 먼저 연산됨
*/

-- EMPLOYEE 테이블에서 직급코드가 'J7'이거나 'J2' 직원들 중 급여가 200만원 이상인 사원들의  모든컬럼 조회
SELECT *
FROM EMPLOYEE
-- WHERE JOB_CODE = 'J7' OR JOB_CODE = 'J2' AND SALARY >= 2000000;
WHERE (JOB_CODE = 'J7' OR JOB_CODE = 'J2') AND SALARY >= 2000000;

---------------------------------------------------------------------------------------------
/*
    <ORDER BY 절>
    SELECT문 가장 마지막 줄에 작성. 실행순서 또한 마지막에 실행
    
    [표현법]
    SELECT 
    FROM
    WHERE
    ORDER BY 정렬기준의 컬럼명 | 별칭 | 컬럼순번 [ASC|DESC] [NULLS FIRST | NULL LAST];
    
    - ASC : 오름차순 정렬(생략시 기본값)
    - DESC : 내림차순 정렬
    
    - NULLS FIRST : 생략시 DESC일때의 기본값.  정렬하고자하는 컬럼값에 NULL이 있는 경우 데이터를 맨 앞에 배치
    - NULLS LAST : 생략시 ASC일때의 기본값. 정렬하고자하는 컬럼값에 NULL이 있는 경우 데이터를 맨 뒤에 배치
*/


SELECT *
FROM EMPLOYEE
-- ORDER BY BONUS;                         보너스의 오름차순 정렬(NULL값은 맨 마지막에 나옴)
-- ORDER BY BONUS ASC;                  보너스의 오름차순 정렬(NULL값은 맨 마지막에 나옴)
-- ORDER BY BONUS NULLS FIRST;      보너스의 오름차순 정렬. NULL값은 맨 앞에 배치

-- ORDER BY BONUS DESC;                 보너스의 내림차순 정렬(NULL값은 맨 앞에 나옴)
ORDER BY BONUS DESC, SALARY;       -- 보너스의 내림차순 정렬을 하고, 보너스가 같으면 급여의 오름차순 정렬


-- EMPLOYEE테이블에서 모든 사원의 사원명, 연봉 조회(이때 연봉의 내림차순 정렬 조회)
SELECT EMP_NAME, SALARY*12 연봉
FROM EMPLOYEE
-- ORDER BY SALARY*12 DESC;
-- ORDER BY 연봉  DESC;     -- 별칭 사용 가능
ORDER BY 2 DESC;            -- 2번째 컬럼

--------------------------------- 실습문제 ---------------------------------
--1. 사수가 없고 부서배치도 받지 않은 사원들의 사원명, 사수사번, 부서코드 조회
SELECT EMP_NAME, MANAGER_ID, DEPT_CODE
FROM EMPLOYEE
WHERE MANAGER_ID IS NULL AND DEPT_CODE IS NULL;

--2. 연봉(보너스포함X)이 3000만원 이상이고 보너스를 받지 않은 사원들의 사번, 사원명, 연봉, 보너스 조회
SELECT EMP_ID, EMP_NAME, SALARY*12 연봉, BONUS
FROM EMPLOYEE
WHERE SALARY*12 >= 30000000 AND BONUS IS NULL;

--3. 입사일이 95/01/01이상이고 부서배치를 받은 사원들의 사번, 사원명, 입사일, 부서코드 조회
SELECT EMP_ID, EMP_NAME, HIRE_DATE, DEPT_CODE
FROM EMPLOYEE
WHERE HIRE_DATE >= '95/01/01' AND DEPT_CODE IS NOT NULL;

--4. 급여가 200만원 이상 500만원 이하고 입사일이 01/01/01이상이고 보너스를 받지 않는 사원들의 
--   사번, 사원명, 급여, 입사일, 보너스 조회
SELECT EMP_ID, EMP_NAME, SALARY, HIRE_DATE, BONUS
FROM EMPLOYEE
WHERE SALARY BETWEEN 2000000 AND 5000000 
    AND HIRE_DATE >= '01/01/01' 
    AND BONUS IS NULL;

--5. 보너스포함 연봉이 NULL이 아니고 이름에 '하'가 포함되어 있는 사원들의 
--   사번, 사원명, 급여, 보너스포함연봉 조회 (별칭부여)
SELECT EMP_ID, EMP_NAME, SALARY, (SALARY*  BONUS + SALARY )*12 총소득
FROM EMPLOYEE
WHERE SALARY*(1+BONUS)*12 IS NOT NULL
    AND EMP_NAME LIKE '%하%';
/*
    * SEQUENCE
       자동으로 번호를 발생시키는 역할을 하는 객체
       정수값을 순차적으로 일정값씩 증가시키면서 생성해줌
       
       EX) 회원번호, 사원번호, 게시글번호 ....
*/
/*
    1. 시퀀스 객체생성 방법
      [표현식]
      CREATE SEQUENCE 시퀀스명
      [START WITH 시작숫자]               --> 처음 발생시킬 시작값 지정(기본값1)
      [INCREMENT BY 숫자]                 --> 몇씩 증가시킬 것인지 지정(기본값1)
      [MAXVALUE 숫자]                       --> 최대값 지정(기본값 엄청큼)
      [MINVALUE 숫자]                        --> 최소값 지정(기본값 1)
      [CYCLE | NOCYCLE]                      --> 값의 순환 여부 지정(기본값 NOCYCLE)
      [CACHE | NOCACHE]                    --> 캐시메모리 할당(기본값 CACHE 20)
      
      * 캐시메모리 : 미리 발생될 값들을 생성해서 저장해두는 공간
                          매번 호출될 때마다 새롭게 번호를 생성하는게 아니라
                          캐시메모리 공간에 미리 생성된 번호를 가져다 쓸수 있음(속도가 빨라짐)
                          접속해제하면 캐시메모리에 미리 만들어 둔 번호들은 다 날라감
                          
       테이블 : TB_
       뷰 : VW_
       시퀀스 : SEQ_
       트리거 : TRG_
*/
-- 시퀀스 생성
CREATE SEQUENCE SEQ_TEST;

SELECT * FROM USER_SEQUENCES;

-- 옵션을 넣은 시퀀스 생성
CREATE SEQUENCE SEQ_EMPNO
START WITH 500
INCREMENT BY 5
MAXVALUE 510
NOCYCLE
NOCACHE;

/*
    2. 시퀀스 사용
    
    시퀀스명.CURRVAL : 현재 시퀀스의 값(마지막으로 성공한 NEXTVAL의 값)
    시퀀스명.NEXTVAL : 시퀀스값에 일정한 값을 증가시켜서 발생된 값
                                현재시퀀스값에서 INCREMENT BY값만큼 증가한 값
                                == 시퀀스명.CURRVAL + INCREMENT BY값
*/
SELECT SEQ_EMPNO.CURRVAL FROM DUAL;
-- NEXTVAL를 단한번도 수행하지 않은 이상 CURRVAL 할수 없음
-- 마지막으로 성공적으로 수행된 NEXTVAL의 값을 저장해서 보여주는 임시값

SELECT SEQ_EMPNO.NEXTVAL FROM DUAL;   -- 500
SELECT SEQ_EMPNO.CURRVAL FROM DUAL;   -- 500
SELECT SEQ_EMPNO.NEXTVAL FROM DUAL;   -- 505
SELECT SEQ_EMPNO.NEXTVAL FROM DUAL;   -- 510

SELECT SEQ_EMPNO.NEXTVAL FROM DUAL;  -- 지정한 MAXVALUE를 초과했기 때문에 오류
SELECT SEQ_EMPNO.CURRVAL FROM DUAL;   -- 510

---------------------------------------------------------------------------------------------------
/*
    3. 시퀀스 구조 변경
     
     ALTER SEQUENCE 시퀀스명
     [INCREMENT BY  숫자]
     [MAXVALUE 숫자]
     [MINVALUE 숫자]
     [CYCLE | NOCYCLE]
     [CACHE 바이트크기 | NOCACHE]
     
     ** 주의 : START WITH는 변경 불가
*/

-- SEQ_EMPNO 변경
ALTER SEQUENCE SEQ_EMPNO
INCREMENT BY 10
MAXVALUE 600;

SELECT SEQ_EMPNO.NEXTVAL FROM DUAL;

---------------------------------------------------------------------------------------------------
/*
    4. 시퀀스 삭제
*/
DROP SEQUENCE SEQ_EMPNO;    
    
---------------------------------------------------------------------------------------------------
/*
    * 실제 적용
*/
CREATE SEQUENCE SEQ_EID
START WITH 401
NOCACHE;

INSERT INTO EMPLOYEE (EMP_ID, EMP_NAME, EMP_NO, JOB_CODE, HIRE_DATE)
                        VALUES (SEQ_EID.NEXTVAL, '우재남', '101001-1283948','J1',SYSDATE);

INSERT INTO EMPLOYEE (EMP_ID, EMP_NAME, EMP_NO, JOB_CODE, HIRE_DATE)
                        VALUES (SEQ_EID.NEXTVAL, '송미영', '171101-4283948','J2',SYSDATE);
/*
    <트리거 TRIGGER>
    내가 지정한 테이블에 INSERT, UPDATE, DELETE등의 DML문에 의해 변경사항이 생겼을 때(테이블에 이벤트가 발생했을 때)
    자동으로 매번 실행할 내용을 미리 정의해 둘수 있는 객체
    
    EX)
    회원탈퇴시 기존의 회원테이블에 데이터를 삭제 한 후 곧바로 탈퇴한 회원만 보관하는 테이블에 INSERT해야 될 때
    신고횟수가 일정 수를 넘었을 때 해당 회원을 블랙리스트로 처리
    입출고가 발생 했을 때 재고수량을 매번 UPDATE해야 될 때
    
    * 트리거의 종류
     - SQL문의 실행시기에 따른 분류
       > BEFORE TRIGGER : 명시한 테이블에 이벤트가 발생되기 전에 트리거 실행
       > AFTER TRIGGER : 명시한 테이블에 이벤트가 발생한 후에 트리거 실행
       
     - SQL문에 의해 영향을 받는 각 행에 따른 분류
        > STATEMENT TRIGGER(문장 트리거) : 이벤트가 발생하면 딱 한번만 트리거 실행
        > ROW TRIGGER(행 트리거) : 이벤트가 발생할때마다 트리거 실행
                                             ** FOR EACH ROW 옵션 기술해야됨
                                                - :OLD  -> 기존컬럼에 들어있던 데이터
                                                - :NEW -> 새로 들어온 데이터
                                                
    * 트리거의 생성 구문
      CREATE [OR REPLACE] TREGGER 트리거명
      BEFORE|AFTER  INSERT|UPDATE|DELETE  ON 테이블명
      [FOR EACH ROW]
      [DECLARE 
            변수 선언;]
      BEGIN
        실행내용(위의 지정된 이벤트 발생시 자동으로 실행할 구문)
      [EXCEPTION
            예외처리구문;]
      END;
      /
      
    * 트리거 삭제
      DROP TRIGGER 트리거명;
*/

-- 화면에 출력문을 보려면
SET SERVEROUTPUT ON;

-- EMPLOYEE테이블에 새로운 행이 INSERT될 때마다 자동으로 메세지 출력
CREATE OR REPLACE TRIGGER TRG_01
AFTER INSERT ON EMPLOYEE
BEGIN
    DBMS_OUTPUT.PUT_LINE('신입사원님 환영합니다');
END;
/

INSERT INTO EMPLOYEE (EMP_ID, EMP_NAME, EMP_NO, JOB_CODE, HIRE_DATE)
                    VALUES('600','김나래','201023-2938475', 'J3', SYSDATE);

INSERT INTO EMPLOYEE (EMP_ID, EMP_NAME, EMP_NO, JOB_CODE, HIRE_DATE)
                    VALUES('601','이나래','201023-2938475', 'J5', SYSDATE);

-- 상품 입고 및 출고가 되면 재고수량이 변경되도록 함
--  >> 필요한 테이블 및 시퀀스 생성
--   1. 상품 재고수량 테이블
CREATE TABLE TB_PRODUCT(
    PCODE NUMBER PRIMARY KEY,           --> 상품번호
    PNAME VARCHAR2(30) NOT NULL,
    BRAND VARCHAR2(30) NOT NULL,
    STOCK_QUANT NUMBER DEFAULT 0
);

--     상품번호에 넣을 시퀀스 생성  
CREATE SEQUENCE SEQ_PCODE
START WITH 200
NOCACHE;

--      샘플 데이터
INSERT INTO TB_PRODUCT VALUES(SEQ_PCODE.NEXTVAL, '갤럭시25', '삼성', DEFAULT);
INSERT INTO TB_PRODUCT VALUES(SEQ_PCODE.NEXTVAL, '아이폰17', 'apple', 10);
INSERT INTO TB_PRODUCT VALUES(SEQ_PCODE.NEXTVAL, '트리플 폴드', '샤오미', 20);

--   2. 입고 테이블(TB_PROSTOCK)
CREATE TABLE TB_PROSTOCK (
    TCODE NUMBER PRIMARY KEY,                       --> 입고번호 
    PCODE NUMBER REFERENCES TB_PRODUCT,     --> 상품번호
    TDATE DATE,
    STOCK_COUNT NUMBER NOT NULL,
    STOCK_PRICE NUMBER NOT NULL
);

--   입고번호에 넣을 시퀀스
CREATE SEQUENCE SEQ_TCODE
NOCACHE;


--   3. 출고 테이블(TB_PROSALE)
CREATE TABLE TB_PROSALE (
    SCODE NUMBER PRIMARY KEY,                       --> 판매번호 
    PCODE NUMBER REFERENCES TB_PRODUCT,     --> 상품번호
    TDATE DATE,
    STOCK_COUNT NUMBER NOT NULL,
    STOCK_PRICE NUMBER NOT NULL
);

--   판매번호에 넣을 시퀀스
CREATE SEQUENCE SEQ_SCODE
NOCACHE;


--   입고
INSERT INTO TB_PROSTOCK 
VALUES(SEQ_TCODE.NEXTVAL, 202, SYSDATE, 10, 3000000);
--   입고가 되면 재고수량을 증가
UPDATE TB_PRODUCT
    SET STOCK_QUANT = STOCK_QUANT + 10
  WHERE PCODE = 202;  
COMMIT;


--   202번 상품을 10개 출고
INSERT INTO TB_PROSALE
VALUES(SEQ_SCODE.NEXTVAL, 202, SYSDATE, 5, 3500000);
--   출고가 되면 재고수량을 감소
UPDATE TB_PRODUCT
    SET STOCK_QUANT = STOCK_QUANT - 5
  WHERE PCODE = 202; 
COMMIT;

--  위의 구문을 트리거 정의
-- 입고 테이블에 INSERT이벤트 발생시 트리거 정의
CREATE OR REPLACE TRIGGER TRG_STOCK
AFTER INSERT ON TB_PROSTOCK
FOR EACH ROW
BEGIN
    UPDATE TB_PRODUCT
    SET STOCK_QUANT = STOCK_QUANT + :NEW.STOCK_COUNT
    WHERE PCODE = :NEW.PCODE;
END;
/

INSERT INTO TB_PROSTOCK 
VALUES(SEQ_TCODE.NEXTVAL, 200, SYSDATE, 10, 2000000);

INSERT INTO TB_PROSTOCK 
VALUES(SEQ_TCODE.NEXTVAL, 201, SYSDATE, 50, 2500000);

-- 출고 테이블에 INSERT이벤트 발생시 트리거 정의
CREATE OR REPLACE TRIGGER TRG_SALE
AFTER INSERT ON TB_PROSALE
FOR EACH ROW
BEGIN
    UPDATE TB_PRODUCT
    SET STOCK_QUANT = STOCK_QUANT - :NEW.STOCK_COUNT
    WHERE PCODE = :NEW.PCODE;
END;
/

INSERT INTO TB_PROSALE
VALUES(SEQ_SCODE.NEXTVAL, 201, SYSDATE, 10, 3500000);


-- 출고시 수량이 부족하면 출고 안되게하는 트리거
/*
    * 사용자 함수 예외처리
      RAISE_APPLICATION_ERROR([에러코드], [에러메시지])
         - 에러코드 : - 20000 ~ -20999사이의 숫자
*/
CREATE OR REPLACE TRIGGER TRG_SALE
AFTER INSERT ON TB_PROSALE
FOR EACH ROW
DECLARE
    SCOUNT NUMBER;
BEGIN
    SELECT STOCK_QUANT
    INTO SCOUNT
    FROM TB_PRODUCT
    WHERE PCODE = :NEW.PCODE;
    
    IF (SCOUNT >= :NEW.STOCK_COUNT)
        THEN
            UPDATE TB_PRODUCT
            SET STOCK_QUANT = STOCK_QUANT - :NEW.STOCK_COUNT
            WHERE PCODE = :NEW.PCODE;
    ELSE
        RAISE_APPLICATION_ERROR(-20001, '재고수량 부족으로 판매할 수 없음');
    END IF;
END;
/

INSERT INTO TB_PROSALE
VALUES(SEQ_SCODE.NEXTVAL, 200, SYSDATE, 20, 3500000);

---------------------------------------------
-- 테이블
-- TB_PRODETAIL(입고, 출고)
CREATE TABLE TB_PRODETAIL (
    DCODE NUMBER PRIMARY KEY,
    PCODE NUMBER REFERENCES TB_PRODUCT,
    PDATE DATE,
    AMOUNT NUMBER,
    STATUS CHAR(6) CHECK(STATUS IN ('입고','출고'))
);

-- 시퀀스
CREATE SEQUENCE SEQ_DCODE
NOCACHE;

--  트리거생성
--  IF( :NEW.STATUS = '입고')

CREATE OR REPLACE TRIGGER TRG_FINAL
AFTER INSERT ON TB_PRODETAIL
FOR EACH ROW
BEGIN
    IF( :NEW.STATUS = '입고')
        THEN
            UPDATE TB_PRODUCT
            SET STOCK_QUANT = STOCK_QUANT + :NEW.AMOUNT
            WHERE PCODE = :NEW.PCODE;
    END IF;
    
    IF( :NEW.STATUS = '출고')
        THEN
            UPDATE TB_PRODUCT
            SET STOCK_QUANT = STOCK_QUANT - :NEW.AMOUNT
            WHERE PCODE = :NEW.PCODE;
    END IF;
END;
/

INSERT INTO TB_PRODETAIL
VALUES (SEQ_DCODE.NEXTVAL, 200, SYSDATE, 10, '입고');

INSERT INTO TB_PRODETAIL
VALUES (SEQ_DCODE.NEXTVAL, 201, SYSDATE, 10, '출고');
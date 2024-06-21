/*
    * TRIGGER
       : 테이블에서 DML문에 의해 변경사항이 생길때마다 자동으로 실행할 내용을 미리 정의해 둘 수 있는 객체
       
       EX)
       회원탈퇴시 회원테이블에서는 DELETE를 할 때, 탈퇴회원들만 보관하는 테이블에 자동으로 INSERT처리
       신고 횟수가 일정 수를 넘으면 자동으로 해당 회원을 블랙리스트로 처리하게
       입출고에서 INSERT될 때 마다 해당상품의 재고수량이 UPDATE를 해야될 때
       
       * 트리거의 종류
        - SQL문 실행시기에 따른 분류
          > BOFORE TRIGGER : 명시된 테이블에 이벤트가 발생되기 전에 트리거 실행
          > AFTER TRIGGER : 명시된 테이블에 이벤트가 발생되고 난 후 트리거 실행
          
        -  SQL문에 의해 영향을 받는 각 행에 따른 분류
          > STATEMENT TRIGGER(문장 트리거) : 이벤트가 발생한 SQL문에 대해 딱 한번만 트리거 실행
          > ROW TRIGGER(행 트리거) : 해당 SQL문 실행할 때 마다 트리거 실행
                                                    (FOR EACH ROW 옵션 기술해야됨)
                                                 > :OLD - 기존컬럼에 들어있던 값
                                                 > :NEW - 새로 들어온 값
                                                 
    * 트리거생성
    
      [표현법]
      CREATE [OR REPLACE] TRIGGER 트리거명
      BEFORE|AFTER  INSERT|UPDATE|DELETE ON 테이블명
      [FOR EACH ROW]
      [DECLARE
            변수선언;]
      BEGIN
        실행내용
      [EXCEPTION
            예외처리구문;]
      END;
      /
      
      * 트리거삭제
       DROP TRIGGER 트리거명;
*/

-- EMPLOYEE테이블에 INSERT발생하고 난 후 환영인사 트리거
SET SERVEROUTPUT ON;

CREATE OR REPLACE TRIGGER TRG_01
AFTER INSERT ON EMPLOYEE
BEGIN
    DBMS_OUTPUT.PUT_LINE('신입사원님 지옥에 오신걸 환영합니다');
END;
/

INSERT INTO EMPLOYEE (EMP_ID, EMP_NAME, EMP_NO, JOB_CODE)
        VALUES(223,'김새로','021010-3146758','J1');

INSERT INTO EMPLOYEE (EMP_ID, EMP_NAME, EMP_NO, JOB_CODE)
        VALUES(224,'우재남','071010-4146758','J2');

-- 상품 입고 및 출고시 재고수량이 변경되도록 트리거 생성
-- >> 필요한 테이블과 시퀀스 생성

-- 1. 상품을 보관할 테이블 생성 : 재고테이블
CREATE TABLE TB_PRODUCT (
    PCODE NUMBER PRIMARY KEY,    --- 상품번호
    PNAME VARCHAR2(30) NOT NULL,   -- 상품명
    BRAND VARCHAR2(30) NOT NULL,   -- 그랜드명
    STOCK_QUANT NUMBER DEFAULT 0  --- 재고수량
);

--  1.2 상품번호에 넣을 시퀀스 생성
CREATE SEQUENCE SEQ_PCODE
START WITH 200
INCREMENT BY 5;

--  1.3 상품 추가
INSERT INTO TB_PRODUCT VALUES(SEQ_PCODE.NEXTVAL, '갤럭시폴드4', '삼성', DEFAULT);
INSERT INTO TB_PRODUCT VALUES(SEQ_PCODE.NEXTVAL, '아이폰17', 'apple', 10);
INSERT INTO TB_PRODUCT VALUES(SEQ_PCODE.NEXTVAL, '홍미노트10', '샤오미', 20);

-- 2. 상품 입고 테이블 생성
CREATE TABLE TB_PROSTOCK (
    TCODE NUMBER PRIMARY KEY,                       -- 입고번호
    PCODE NUMBER REFERENCES TB_PRODUCT,     -- 상품번호
    TDATE DATE,                                                 -- 입고날짜
    STOCK_COUNT NUMBER NOT NULL,                -- 입고수량
    STOCK_PRICE NUMBER NOT NULL                     -- 입고단가
);

--  2.2 입고번호에 넣을 시퀀스 생성
CREATE SEQUENCE SEQ_TCODE;

-- 3. 상품 판매 테이블 생성
CREATE TABLE TB_PROSALE (
    SCODE NUMBER PRIMARY KEY,                       -- 판매번호
    PCODE NUMBER REFERENCES TB_PRODUCT,     -- 상품번호
    SDATE DATE,                                                 -- 판매날짜
    SALE_COUNT NUMBER NOT NULL,                -- 판매수량
    SALE_PRICE NUMBER NOT NULL                     -- 판매단가
);

--  2.2 판매번호에 넣을 시퀀스 생성
CREATE SEQUENCE SEQ_SCODE;


----------------------------------------- 입고
-- 상품번호 200번 상품 10개
INSERT INTO tb_prostock
VALUES(SEQ_TCODE.NEXTVAL, 200, SYSDATE, 10, 2100000);

-- 제품테이블에 재고수량 10개 UPDATE
UPDATE TB_PRODUCT
    SET stock_quant = stock_quant + 10
WHERE PCODE = 200;    

COMMIT;

-- 210번 제품이 5개 판매되었다
INSERT INTO TB_PROSALE
VALUES(SEQ_SCODE.NEXTVAL, 210, SYSDATE, 5, 350000);
-- 제품테이블에 재고수량 10개 UPDATE
UPDATE TB_PRODUCT
    SET stock_quant = stock_quant - 5
WHERE PCODE = 210; 
COMMIT;

-- TB_PRODUCT테이블에 매번 자동으로 재고수량 UPDATE하는 트리거 정의

-- TB_PROSTOCK 테이블에 INSERT이벤트 발생시
/*
UPDATE TB_PRODUCT
    SET STOCK_QUANT = STOCK_QUANT + 입고된 수량(INSERT된 자료의 STOCK_COUNT)
WHERE PCODE = 입고된상품번호(INSERT된 자료의 PCODE값)    
*/
CREATE OR REPLACE TRIGGER TRG_STOCK
AFTER INSERT ON TB_PROSTOCK
FOR EACH ROW
BEGIN
    UPDATE TB_PRODUCT
    SET STOCK_QUANT = STOCK_QUANT + :NEW.STOCK_COUNT
    WHERE PCODE = :NEW.PCODE;
END;
/

-- 205번 3개 입고
INSERT INTO TB_PROSTOCK
VALUES(SEQ_TCODE.NEXTVAL, 205, SYSDATE, 3, 1900000);

-- 210번 5개 입고
INSERT INTO TB_PROSTOCK
VALUES(SEQ_TCODE.NEXTVAL, 210, SYSDATE, 5, 350000);


-- TB_PROSALE 테이블에 INSERT이벤트 발생시

CREATE OR REPLACE TRIGGER TRG_SALE
AFTER INSERT ON TB_PROSALE
FOR EACH ROW
BEGIN
    UPDATE TB_PRODUCT
    SET STOCK_QUANT = STOCK_QUANT - :NEW.SALE_COUNT
    WHERE PCODE = :NEW.PCODE;
END;
/

-- 210번 10개 판매
INSERT INTO TB_PROSALE
VALUES(SEQ_SCODE.NEXTVAL, 210, SYSDATE, 10, 400000);

-- 200번 3개 판매
INSERT INTO TB_PROSALE
VALUES(SEQ_SCODE.NEXTVAL, 200, SYSDATE, 3, 2200000);

-- 판매시 재고수량보다 더 많이 판매하지 못하도록 하는 트리거 생성
-- 판매되기 전에 트리거 실행 되어야 함
/*
    * 사용자 정의  EXCEPTION
        RAISE_APPLICATION_ERROR([에러코드], [에러메시지])
        - 에러코드 : -20000 ~ -20999 사이의 코드
*/

CREATE OR REPLACE TRIGGER TRG_SALE
BEFORE INSERT ON TB_PROSALE
FOR EACH ROW
DECLARE
    SCOUNT NUMBER;
BEGIN
    SELECT STOCK_QUANT
      INTO SCOUNT
      FROM TB_PRODUCT
    WHERE PCODE = :NEW.PCODE;  

    IF(SCOUNT >= :NEW.SALE_COUNT)
        THEN
            UPDATE TB_PRODUCT
            SET STOCK_QUANT = STOCK_QUANT - :NEW.SALE_COUNT
            WHERE PCODE = :NEW.PCODE;
        ELSE
            RAISE_APPLICATION_ERROR(-20001, '재고수량 부족');
        END IF;
END;
/
            
-- 200번 5개 판매
INSERT INTO TB_PROSALE
VALUES(SEQ_SCODE.NEXTVAL, 200, SYSDATE, 5, 2200000);

-- 205번 15개 판매
INSERT INTO TB_PROSALE
VALUES(SEQ_SCODE.NEXTVAL, 205, SYSDATE, 15, 2100000);
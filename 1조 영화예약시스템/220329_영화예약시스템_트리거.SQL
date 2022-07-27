--트리거 1 시작
create or replace NONEDITIONABLE TRIGGER TRIG_INS_POINT_FROM_INS_RESERVATION 
AFTER INSERT ON RESERVATION_TBL
REFERENCING OLD AS O NEW AS N 
FOR EACH ROW
DECLARE
    V_NEW_ID              CHAR(5);
    V_MINUS_POINTS        NUMBER(6);
    V_POINTS              NUMBER(8);
BEGIN

/*
    작성일 : 20220329
    최초작성자 : 박진교
    업무설명 : RESERVATION에 예약 취소가 들어왔을 때,
               포인트 차감 내역을 POINT_TBL에 삽입
*/
  
  --RESERVATION_TBL 의 GUBUN이 C일때(예약 취소 일 때)
  IF :N.R_GUBUN = 'C' THEN
  
  --차감할 포인트 구하기
  SELECT POINTS
  INTO V_MINUS_POINTS
  FROM
  (
      SELECT R_ID, SUM(PAY_SAVE_POINT) AS POINTS
      FROM PAYMENT_INFO_TBL
      WHERE R_ID = :N.R_CANCELED_ID
      GROUP BY R_ID
  )
  ;
  
  --고객 포인트 찾아오기
  SELECT U_POINT
  INTO V_POINTS
  FROM USER_TBL
  WHERE U_ID = :N.U_ID
  ;
  
  V_POINTS := V_POINTS - V_MINUS_POINTS;
  
  --고객 테이블의 해당 고객 포인트 업데이트
  UPDATE USER_TBL
  SET U_POINT = V_POINTS
  WHERE U_ID = :N.U_ID
  ;
  
    --> (공통1) INSERT 시 POINT_TBL의 P_ID 자동생성.
    SELECT 'P' || TO_CHAR(TO_NUMBER(SUBSTR(NVL(MAX(P_ID),'P0000'),2,4)) + 1, 'FM0000')  
    INTO V_NEW_ID
    FROM POINT_TBL
    ; 
  
  --POINT_TBL에 해당 데이터 넣기
  INSERT INTO POINT_TBL(P_ID, R_ID, P_DATE, P_AMOUNT, P_GUBUN)
  VALUES(V_NEW_ID, :N.R_ID, :N.R_DATE, V_MINUS_POINTS, 'C')
  ;
  
  END IF;
 
END;

--트리거 1 끝


--트리거 2 시작
create or replace NONEDITIONABLE TRIGGER TRIG_INS_POINT_FROM_INS_PAYMENT
AFTER INSERT ON PAYMENT_INFO_TBL 
REFERENCING OLD AS O NEW AS N 
FOR EACH ROW
DECLARE
    V_NEW_ID            CHAR(5);
    V_U_ID              VARCHAR2(30);
    V_DATE              DATE;
BEGIN

/*
    작성일 : 20220329
    최초작성자 : 박진교
    업무설명 : PAYMENT에 데이터 삽입 시, 
               포인트 적립 또는 사용한 내역 POINT테이블에 삽입
*/

--포인트 적립
--0원 적립할때가 아닐 때만
IF :N.PAY_SAVE_POINT != 0 THEN
    --> (공통1) INSERT 시 POINT_TBL의 P_ID 자동생성.
    SELECT 'P' || TO_CHAR(TO_NUMBER(SUBSTR(NVL(MAX(P_ID),'P0000'),2,4)) + 1, 'FM0000')  
    INTO V_NEW_ID
    FROM POINT_TBL
    ; 
  
  --예약한 날짜(포인트 쌓을 날짜) 찾기
  SELECT R_DATE
  INTO V_DATE
  FROM RESERVATION_TBL
  WHERE R_ID = :N.R_ID
  ;
  
  INSERT INTO POINT_TBL(P_ID, R_ID, P_DATE, P_AMOUNT, P_GUBUN)
  VALUES(V_NEW_ID, :N.R_ID, V_DATE, :N.PAY_SAVE_POINT, 'P')
  ;
  
  --USER_TBL의 포인트 업데이트
  --U_ID 찾기
  SELECT U_ID
  INTO V_U_ID
  FROM RESERVATION_TBL
  WHERE R_ID = :N.R_ID
  ;
  
  UPDATE USER_TBL
  SET U_POINT = U_POINT + :N.PAY_SAVE_POINT
  WHERE U_ID = V_U_ID
  ;
  
END IF;
--포인트 적립 끝

--포인트 사용(사용한 포인트가 0이 아닐때만)
IF :N.PAY_METHOD = 'COM0003' AND :N.PAY_PRICE != 0
THEN

    --> (공통1) INSERT 시 POINT_TBL의 P_ID 자동생성.
    SELECT 'P' || TO_CHAR(TO_NUMBER(SUBSTR(NVL(MAX(P_ID),'P0000'),2,4)) + 1, 'FM0000')  
    INTO V_NEW_ID
    FROM POINT_TBL
    ; 
    
  --예약한 날짜(포인트 사용한 날짜) 찾기
  SELECT R_DATE
  INTO V_DATE
  FROM RESERVATION_TBL
  WHERE R_ID = :N.R_ID
  ;
  
  INSERT INTO POINT_TBL(P_ID, R_ID, P_DATE, P_AMOUNT, P_GUBUN)
  VALUES(V_NEW_ID, :N.R_ID, V_DATE, :N.PAY_PRICE, 'M')
  ;

END IF;
--포인트 사용 끝

  
END;

--트리거 2 끝
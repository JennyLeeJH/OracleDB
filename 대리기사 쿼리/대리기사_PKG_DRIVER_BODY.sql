create or replace NONEDITIONABLE PACKAGE BODY PKG_DRIVER AS

  --대리기사 등록
  PROCEDURE PROC_INS_DRIVERS
  (
        IN_DRIVER_NAME      IN      VARCHAR2,
        IN_DRIVER_TEL       IN      VARCHAR2,
        IN_DRIVER_GENDER    IN      VARCHAR2
  ) 
  AS
  
        V_NEW_DRIVER_ID     CHAR(5);
  
  BEGIN
        
        SELECT 'DR' || TO_CHAR(TO_NUMBER(SUBSTR(NVL(MAX(DR_ID), 'DR000'), 3, 3)) + 1, 'FM000') 
        INTO V_NEW_DRIVER_ID
        FROM DRIVERS_TBL
        ;
        
        INSERT INTO DRIVERS_TBL(DR_ID,DR_NAME, DR_TEL, DR_GENDER) 
        VALUES(V_NEW_DRIVER_ID, IN_DRIVER_NAME, IN_DRIVER_TEL, IN_DRIVER_GENDER);
        
  END PROC_INS_DRIVERS;
  
  
  --불특정 회원 포인트 적립
   PROCEDURE PROC_SAVE_POINTS
  (
        IN_R_ID             IN      VARCHAR2,
        O_ERRCODE           OUT     VARCHAR2,
        O_ERRMSG            OUT     VARCHAR2
    ) 
  AS
  
        V_CHK_F_DRIVE       VARCHAR2(2);
        V_R_PAY             NUMBER(6, 0);
        V_R_TEL             VARCHAR2(13);
        
        --예외
        EXCEP_F_DRIVE      EXCEPTION;
        
  BEGIN
    
        SELECT DECODE(MAX(R_ID), NULL, 'N', 'Y')
        INTO V_CHK_F_DRIVE
        FROM FINISH_DRIVE_TBL
        WHERE F_GUBUN = 1
        AND R_ID = IN_R_ID
        ;
        
        IF V_CHK_F_DRIVE = 'N' THEN
        
            RAISE EXCEP_F_DRIVE;
        
            
        ELSE
        
            SELECT R_TEL
            INTO V_R_TEL
            FROM RESERVATION_TBL
            WHERE R_ID = IN_R_ID
            ;
                
            SELECT R_PAY
            INTO V_R_PAY
            FROM RESERVATION_TBL
            WHERE R_ID = IN_R_ID
            ;
                
            UPDATE DR_MEMBER_TBL
            SET MEM_POINT = MEM_POINT + V_R_PAY * 0.03
            WHERE R_TEL = V_R_TEL
            ;
                  
            
        END IF;
        
        EXCEPTION
        WHEN EXCEP_F_DRIVE
        THEN O_ERRCODE := 'ERR-001';
             O_ERRMSG := '사용자의 이용 기록이 없습니다.';
             ROLLBACK;
             
        WHEN OTHERS
        THEN O_ERRCODE := SQLCODE;
             O_ERRMSG := SQLERRM;
             ROLLBACK;
          
  END PROC_SAVE_POINTS;
  
  --새로운 이용자 등록
  PROCEDURE PROC_INS_MEMBERS
  (
        IN_R_TEL            IN      VARCHAR2,
        O_ERRCODE           OUT     VARCHAR2,
        O_ERRMSG            OUT     VARCHAR2
  )
  AS
  
        V_CHK_MEM_TEL       VARCHAR2(2);
        
        --예외
        EXCEPT_MEMBER       EXCEPTION; 
      
  BEGIN
        
        --번호 유무 확인
        SELECT DECODE(MAX(R_TEL), NULL, 'N', 'Y')
        INTO V_CHK_MEM_TEL
        FROM DR_MEMBER_TBL
        WHERE R_TEL = IN_R_TEL
        ;
        
        IF V_CHK_MEM_TEL = 'N' THEN
            RAISE EXCEPT_MEMBER;
        END IF;
        
        --이용자 추가
        INSERT INTO DR_MEMBER_TBL(R_TEL, MEM_POINT)
        VALUES(IN_R_TEL, 0)
        ;
        
        EXCEPTION
        WHEN EXCEPT_MEMBER
        THEN O_ERRCODE := 'ERR-002';
             O_ERRMSG := '이미 존재하는 이용자입니다.';
             ROLLBACK;
        
        WHEN OTHERS
        THEN O_ERRCODE := SQLCODE;
             O_ERRMSG := SQLERRM;
             ROLLBACK;
    
  END PROC_INS_MEMBERS;
  
  --요일별 대리운전 총 매출액
  PROCEDURE PROC_TOTAL_DAY_PRICE
  (
        O_CUR               OUT     SYS_REFCURSOR
  )
  AS
  
  BEGIN
  
        OPEN O_CUR FOR
        SELECT TO_CHAR(T1.F_DATE) AS DAY, SUM(T2.R_PAY) AS TPAY
        FROM FINISH_DRIVE_TBL T1, RESERVATION_TBL T2
        WHERE T1.R_ID = T2.R_ID
        AND T1.F_GUBUN = 1
        GROUP BY TO_CHAR(T1.F_DATE)
        ;
  
  END PROC_TOTAL_DAY_PRICE;
  
  --매출에 대한 회사와 대리기사 수수료
  PROCEDURE PROC_SEPARATE_SALES
  (
        O_CUR               OUT     SYS_REFCURSOR
  )
  AS
              
  BEGIN
  
        OPEN O_CUR FOR
        SELECT B.DAY,
            SUM(A.D_SALES) AS DRIVER_SALES,
            SUM(A.C_SALES) AS COMPANY_SALES
        FROM
        (
            SELECT R_ID,
                CASE WHEN R_PAY >= 20000
                    THEN R_PAY * 0.8
                    ELSE R_PAY * 0.9 END AS D_SALES,
                CASE WHEN R_PAY >= 20000
                    THEN R_PAY * 0.2
                    ELSE R_PAY * 0.1 END AS C_SALES
            FROM RESERVATION_TBL 
        )A,
        (
            SELECT TO_CHAR(TO_DATE('2018-05-02', 'YYYY/MM/DD') + LEVEL - 1, 'YYYY/MM/DD') AS DAY
            FROM DUAL
            CONNECT BY LEVEL <= (TO_DATE('2018/05/05', 'YYYY/MM/DD') - TO_DATE('2018/05/02', 'YYYY/MM/DD') + 1)
        )B,
        (
            SELECT R_ID, F_DATE 
            FROM FINISH_DRIVE_TBL
            WHERE F_GUBUN = 1
        )C
        WHERE A.R_ID = C.R_ID
        AND B.DAY = TO_CHAR(C.F_DATE, 'YYYY/MM/DD')
        GROUP BY B.DAY
        ORDER BY B.DAY ASC
        ;
  
  END PROC_SEPARATE_SALES;

END PKG_DRIVER;
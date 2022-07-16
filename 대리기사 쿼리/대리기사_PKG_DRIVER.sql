create or replace NONEDITIONABLE PACKAGE PKG_DRIVER AS 

  --대리기사 등록
  PROCEDURE PROC_INS_DRIVERS
  (
        IN_DRIVER_NAME      IN      VARCHAR2,
        IN_DRIVER_TEL       IN      VARCHAR2,
        IN_DRIVER_GENDER    IN      VARCHAR2
  );
  
  --불특정 회원 포인트 적립
  PROCEDURE PROC_SAVE_POINTS
  (
        IN_R_ID             IN      VARCHAR2,
        O_ERRCODE           OUT     VARCHAR2,
        O_ERRMSG            OUT     VARCHAR2
  );
  

  --새로운 이용자 등록
  PROCEDURE PROC_INS_MEMBERS
  (
        IN_R_TEL            IN      VARCHAR2,
        O_ERRCODE           OUT     VARCHAR2,
        O_ERRMSG            OUT     VARCHAR2
  );
  
  --요일별 대리운전 총 매출액
  PROCEDURE PROC_TOTAL_DAY_PRICE
  (
        O_CUR               OUT     SYS_REFCURSOR
  );
  
  --매출에 대한 회사와 대리기사 수수료
  PROCEDURE PROC_SEPARATE_SALES
  (
        O_CUR               OUT     SYS_REFCURSOR
  );
     
END PKG_DRIVER;
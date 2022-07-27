--@@@
--COMMONS_TBL 헤드
create or replace NONEDITIONABLE PACKAGE PKG_COMMONS_TBL AS 

  --COMMONS_TBL 그룹 생성 INSERT
  PROCEDURE PROC_INS_GRP_COMMONS_TBL
  (
    IN_COM_NAME         IN  VARCHAR2,
    O_ERRCODE           OUT VARCHAR2,
    O_ERRMSG            OUT VARCHAR2
  )
  ;


  --COMMONS_TBL 공통 코드 생성 INSERT
  PROCEDURE PROC_INS_COM_COMMONS_TBL
  (
    IN_GRP_ID           IN  VARCHAR2,
    IN_COM_NAME         IN  VARCHAR2,
    IN_COM_LVL          IN  VARCHAR2,
    IN_PARENT_ID        IN  VARCHAR2,
    IN_EXTRA_INFO1      IN  VARCHAR2,
    IN_EXTRA_INFO2      IN  VARCHAR2,
    IN_EXTRA_INFO3      IN  VARCHAR2,
    IN_EXTRA_INFO4      IN  VARCHAR2,
    O_ERRCODE           OUT VARCHAR2,
    O_ERRMSG            OUT VARCHAR2
  )
  ;
 
  
  --COMMONS_TBL SELECT
  PROCEDURE PROC_SEL_COMMONS_TBL
  (
    IN_GRP_ID           IN  VARCHAR2,
    IN_COM_ID           IN  VARCHAR2,
    IN_COM_NAME         IN  VARCHAR2,
    IN_COM_LVL          IN  VARCHAR2,
    IN_PARENT_ID        IN  VARCHAR2,
    IN_INFO             IN  VARCHAR2,
    O_CUR               OUT SYS_REFCURSOR,
    O_ERRCODE           OUT VARCHAR2,
    O_ERRMSG            OUT VARCHAR2
  )
  ;
  

  --COMMONS_TBL UPDATE
  PROCEDURE PROC_UP_COMMONS_TBL
  (
    IN_GRP_ID           IN  VARCHAR2,
    IN_COM_ID           IN  VARCHAR2,
    IN_COM_NAME         IN  VARCHAR2,
    IN_COM_LVL          IN  VARCHAR2,
    IN_PARENT_ID        IN  VARCHAR2,
    IN_EXTRA_INFO1      IN  VARCHAR2,
    IN_EXTRA_INFO2      IN  VARCHAR2,
    IN_EXTRA_INFO3      IN  VARCHAR2,
    IN_EXTRA_INFO4      IN  VARCHAR2,
    O_ERRCODE           OUT VARCHAR2,
    O_ERRMSG            OUT VARCHAR2
  )
  ;
  
  
  --COMMONS_TBL DELETE
  PROCEDURE PROC_DELETE_COMMONS_TBL
  (
    IN_GRP_ID           IN  VARCHAR2,
    IN_COM_ID           IN  VARCHAR2,
    O_ERRCODE           OUT VARCHAR2,
    O_ERRMSG            OUT VARCHAR2
  )
  ;

END PKG_COMMONS_TBL;

--COMMONS_TBL 헤드 끝

--COMMONS_TBL 바디
CREATE OR REPLACE NONEDITIONABLE PACKAGE BODY PKG_COMMONS_TBL AS

  --COMMONS_TBL 그룹 생성 INSERT
  PROCEDURE PROC_INS_GRP_COMMONS_TBL
  (
    IN_COM_NAME         IN  VARCHAR2,
    O_ERRCODE           OUT VARCHAR2,
    O_ERRMSG            OUT VARCHAR2
  )
   AS
    V_NEW_GRP_ID        CHAR(6);
  BEGIN
  
    SELECT 'GRP' || TO_CHAR(TO_NUMBER(SUBSTR(NVL(MAX(GRP_ID),'GRP000'),4,3))+1,'FM000')
    INTO V_NEW_GRP_ID
    FROM COMMONS_TBL;
  
    INSERT INTO COMMONS_TBL(GRP_ID,COM_ID,COM_NAME,COM_LVL,PARENT_ID)
    VALUES(V_NEW_GRP_ID,'COM0000',IN_COM_NAME,0,'COM0000')
    ;
    
    EXCEPTION
    WHEN OTHERS
    THEN O_ERRCODE := SQLCODE;
         O_ERRMSG := SQLERRM;
         ROLLBACK;
    
  END PROC_INS_GRP_COMMONS_TBL;
  
  
  --COMMONS_TBL 공통 코드 생성 INSERT
  PROCEDURE PROC_INS_COM_COMMONS_TBL
  (
    IN_GRP_ID           IN  VARCHAR2,
    IN_COM_NAME         IN  VARCHAR2,
    IN_COM_LVL          IN  VARCHAR2,
    IN_PARENT_ID        IN  VARCHAR2,
    IN_EXTRA_INFO1      IN  VARCHAR2,
    IN_EXTRA_INFO2      IN  VARCHAR2,
    IN_EXTRA_INFO3      IN  VARCHAR2,
    IN_EXTRA_INFO4      IN  VARCHAR2,
    O_ERRCODE           OUT VARCHAR2,
    O_ERRMSG            OUT VARCHAR2
  )
   AS
    V_NEW_COM_ID        CHAR(7);
    V_NULL_PARAMS        VARCHAR2(150);
    EXCEPT_PARAM_IS_NULL EXCEPTION;
  BEGIN
  
    IF  (IN_COM_NAME IS NULL)
     OR (IN_COM_LVL  IS NULL)
     OR (IN_PARENT_ID IS NULL)
    THEN
        IF IN_COM_NAME IS NULL
        THEN V_NULL_PARAMS := V_NULL_PARAMS || 'COM_NAME ';
        END IF;
        
        IF IN_COM_LVL IS NULL
        THEN V_NULL_PARAMS := V_NULL_PARAMS || 'COM_LVL ';
        END IF;
        
        IF IN_PARENT_ID IS NULL
        THEN V_NULL_PARAMS := V_NULL_PARAMS || 'PARENT_ID';
        END IF;
        RAISE EXCEPT_PARAM_IS_NULL;
    ELSE
    
        SELECT 'COM' || TO_CHAR(TO_NUMBER(SUBSTR(NVL(MAX(COM_ID),'COM0000'),4,4)) + 1,'FM0000')
        INTO V_NEW_COM_ID
        FROM COMMONS_TBL
        WHERE GRP_ID = IN_GRP_ID
        ;
        
        INSERT INTO COMMONS_TBL(GRP_ID,COM_ID,COM_NAME,COM_LVL,PARENT_ID,EXTRA_INFO1,EXTRA_INFO2,EXTRA_INFO3,EXTRA_INFO4)
        VALUES(IN_GRP_ID,V_NEW_COM_ID,IN_COM_NAME,IN_COM_LVL,IN_PARENT_ID,IN_EXTRA_INFO1,IN_EXTRA_INFO2,IN_EXTRA_INFO3,IN_EXTRA_INFO4)
        ;
    
    END IF;
    
    EXCEPTION
    WHEN EXCEPT_PARAM_IS_NULL
    THEN O_ERRCODE := 'ERR001';
         O_ERRMSG := V_NULL_PARAMS || ' 값이 존재하지 않습니다.';
         ROLLBACK;
    WHEN OTHERS
    THEN O_ERRCODE := SQLCODE;
         O_ERRMSG := SQLERRM;
         ROLLBACK;
    
  END PROC_INS_COM_COMMONS_TBL;


  --COMMONS_TBL SELECT (EXTRA_INFO 검색 X)
  PROCEDURE PROC_SEL_COMMONS_TBL
  (
    IN_GRP_ID           IN  VARCHAR2,
    IN_COM_ID           IN  VARCHAR2,
    IN_COM_NAME         IN  VARCHAR2,
    IN_COM_LVL          IN  VARCHAR2,
    IN_PARENT_ID        IN  VARCHAR2,
    IN_INFO             IN  VARCHAR2,
    O_CUR               OUT SYS_REFCURSOR,
    O_ERRCODE           OUT VARCHAR2,
    O_ERRMSG            OUT VARCHAR2
  )
   AS
  BEGIN

    OPEN O_CUR FOR
    SELECT *
    FROM COMMONS_TBL
    WHERE GRP_ID LIKE '%'|| IN_GRP_ID || '%'
      AND COM_ID LIKE '%'|| IN_COM_ID || '%'
      AND COM_NAME LIKE '%'|| IN_COM_NAME || '%'
      AND COM_LVL LIKE '%'|| IN_COM_LVL || '%'
      AND PARENT_ID LIKE '%'|| IN_PARENT_ID || '%'
    ;
    
    EXCEPTION
    WHEN OTHERS
    THEN O_ERRCODE := SQLCODE;
         O_ERRMSG := SQLERRM;
         ROLLBACK;
  
  END PROC_SEL_COMMONS_TBL;


  --COMMONS_TBL UPDATE
  PROCEDURE PROC_UP_COMMONS_TBL
  (
    IN_GRP_ID           IN  VARCHAR2,
    IN_COM_ID           IN  VARCHAR2,
    IN_COM_NAME         IN  VARCHAR2,
    IN_COM_LVL          IN  VARCHAR2,
    IN_PARENT_ID        IN  VARCHAR2,
    IN_EXTRA_INFO1      IN  VARCHAR2,
    IN_EXTRA_INFO2      IN  VARCHAR2,
    IN_EXTRA_INFO3      IN  VARCHAR2,
    IN_EXTRA_INFO4      IN  VARCHAR2,
    O_ERRCODE           OUT VARCHAR2,
    O_ERRMSG            OUT VARCHAR2
  )
   AS
    V_NULL_PARAMS        VARCHAR2(150);
    EXCEPT_PARAM_IS_NULL EXCEPTION;
  BEGIN
  
  
    IF  (IN_COM_NAME IS NULL)
     OR (IN_COM_LVL  IS NULL)
     OR (IN_PARENT_ID IS NULL)
    THEN
        IF IN_COM_NAME IS NULL
        THEN V_NULL_PARAMS := V_NULL_PARAMS || 'COM_NAME ';
        END IF;
        
        IF IN_COM_LVL IS NULL
        THEN V_NULL_PARAMS := V_NULL_PARAMS || 'COM_LVL ';
        END IF;
        
        IF IN_PARENT_ID IS NULL
        THEN V_NULL_PARAMS := V_NULL_PARAMS || 'PARENT_ID';
        END IF;
        RAISE EXCEPT_PARAM_IS_NULL;
    ELSE
    
    UPDATE COMMONS_TBL
    SET COM_NAME = IN_COM_NAME,
        COM_LVL = IN_COM_LVL,
        PARENT_ID = IN_PARENT_ID,
        EXTRA_INFO1 = IN_EXTRA_INFO1,
        EXTRA_INFO2 = IN_EXTRA_INFO2,
        EXTRA_INFO3 = IN_EXTRA_INFO3,
        EXTRA_INFO4 = IN_EXTRA_INFO4
    WHERE GRP_ID = IN_GRP_ID AND COM_ID = IN_COM_ID
    ;
    
    END IF;


    EXCEPTION
    WHEN EXCEPT_PARAM_IS_NULL
    THEN O_ERRCODE := 'ERR001';
         O_ERRMSG := V_NULL_PARAMS || ' 값이 존재하지 않습니다.';
         ROLLBACK;
    WHEN OTHERS
    THEN O_ERRCODE := SQLCODE;
         O_ERRMSG := SQLERRM;
         ROLLBACK;
  
  END PROC_UP_COMMONS_TBL;


  --COMMONS_TBL DELETE
  PROCEDURE PROC_DELETE_COMMONS_TBL
  (
    IN_GRP_ID           IN  VARCHAR2,
    IN_COM_ID           IN  VARCHAR2,
    O_ERRCODE           OUT VARCHAR2,
    O_ERRMSG            OUT VARCHAR2
  )
   AS
  BEGIN

    DELETE COMMONS_TBL
    WHERE GRP_ID = IN_GRP_ID AND COM_ID = IN_COM_ID
    ;
  
    EXCEPTION
    WHEN OTHERS
    THEN O_ERRCODE := SQLCODE;
         O_ERRMSG := SQLERRM;
         ROLLBACK;
         
  END PROC_DELETE_COMMONS_TBL;

END PKG_COMMONS_TBL;

--COMMONS_TBL 바디 끝


--@@@
--USER_TBL 헤드
create or replace NONEDITIONABLE PACKAGE PKG_USER_TBL AS 

  --USER_TBL INSERT
  PROCEDURE PROC_INS_USER_TBL
  (
    IN_U_ID             IN  VARCHAR2,
    IN_U_NAME           IN  VARCHAR2,
    IN_U_AGE            IN  VARCHAR2,
    IN_U_TEL            IN  VARCHAR2,
    IN_U_GENDER         IN  VARCHAR2,
    IN_U_POINT          IN  VARCHAR2,
    IN_U_GUBUN          IN  VARCHAR2,
    IN_U_GRADE          IN  VARCHAR2,
    O_ERRCODE           OUT VARCHAR2,
    O_ERRMSG            OUT VARCHAR2
  )
  ;
  
  
  --USER_TBL SELECT
  PROCEDURE PROC_SEL_USER_TBL
  (
    IN_U_ID             IN  VARCHAR2,
    IN_U_NAME           IN  VARCHAR2,
    IN_U_AGE            IN  VARCHAR2,
    IN_U_TEL            IN  VARCHAR2,
    IN_U_GENDER         IN  VARCHAR2,
    IN_U_POINT          IN  VARCHAR2,
    IN_U_GUBUN          IN  VARCHAR2,
    IN_U_GRADE          IN  VARCHAR2,
    O_CUR               OUT SYS_REFCURSOR,
    O_ERRCODE           OUT VARCHAR2,
    O_ERRMSG            OUT VARCHAR2
  )
  ;
  
  
  --USER_TBL UPDATE
  PROCEDURE PROC_UP_USER_TBL
  (
    IN_U_ID             IN  VARCHAR2,
    IN_U_NAME           IN  VARCHAR2,
    IN_U_AGE            IN  VARCHAR2,
    IN_U_TEL            IN  VARCHAR2,
    IN_U_GENDER         IN  VARCHAR2,
    IN_U_POINT          IN  VARCHAR2,
    IN_U_GUBUN          IN  VARCHAR2,
    IN_U_GRADE          IN  VARCHAR2,
    O_ERRCODE           OUT VARCHAR2,
    O_ERRMSG            OUT VARCHAR2
  )
  ;
  
  
  --USER_TBL DELETE
  PROCEDURE PROC_DEL_USER_TBL
  (
    IN_U_ID             IN  VARCHAR2,
    O_ERRCODE           OUT VARCHAR2,
    O_ERRMSG            OUT VARCHAR2
  )
  ;

END PKG_USER_TBL;

--USER_TBL 헤드 끝

--USER_TBL 바디
create or replace NONEDITIONABLE PACKAGE BODY PKG_USER_TBL AS

  --USER_TBL INSERT
  PROCEDURE PROC_INS_USER_TBL
  (
    IN_U_ID             IN  VARCHAR2,
    IN_U_NAME           IN  VARCHAR2,
    IN_U_AGE            IN  VARCHAR2,
    IN_U_TEL            IN  VARCHAR2,
    IN_U_GENDER         IN  VARCHAR2,
    IN_U_POINT          IN  VARCHAR2,
    IN_U_GUBUN          IN  VARCHAR2,
    IN_U_GRADE          IN  VARCHAR2,
    O_ERRCODE           OUT VARCHAR2,
    O_ERRMSG            OUT VARCHAR2
  )
   AS

   V_CHECK_ID                   NUMBER(1);
   V_NEW_GUEST_ID               VARCHAR2(30);
   
   EXCEPT_ALEADY_EXIST_ID       EXCEPTION;
   EXCEPT_NOT_VALID_AGE         EXCEPTION;
   
  BEGIN
  
--회원일 때
IF IN_U_GUBUN = 1 THEN
    --아이디 중복 확인
    SELECT COUNT(U_ID)
    INTO V_CHECK_ID
    FROM USER_TBL
    WHERE U_ID = IN_U_ID
    ;
    
    IF V_CHECK_ID = 1
    THEN RAISE EXCEPT_ALEADY_EXIST_ID;
    END IF;
    
    --나이 양수인지 확인
    IF TO_NUMBER(IN_U_AGE) < 0
    THEN RAISE EXCEPT_NOT_VALID_AGE;
    END IF;
    
    
    INSERT INTO USER_TBL(U_ID,U_NAME,U_AGE,U_TEL,U_GENDER,U_POINT,U_GUBUN,U_GRADE_GRP,U_GRADE)
    VALUES(IN_U_ID,IN_U_NAME,TO_NUMBER(IN_U_AGE),IN_U_TEL,IN_U_GENDER,TO_NUMBER(IN_U_POINT),1,'GRP002',IN_U_GRADE)
    ;
ELSE
    --비회원일 때
    SELECT 'GUEST' || TO_CHAR(TO_NUMBER(SUBSTR(NVL(MAX(U_ID),'GUEST0000'),6,4)) + 1, 'FM0000')
    INTO V_NEW_GUEST_ID
    FROM USER_TBL
    WHERE U_ID LIKE 'GUEST%';
    
    INSERT INTO USER_TBL(U_ID,U_GUBUN)
    VALUES (V_NEW_GUEST_ID,2)
    ;
    
END IF;
    
  
    EXCEPTION
    WHEN EXCEPT_ALEADY_EXIST_ID
    THEN O_ERRCODE := 'ERR001';
         O_ERRMSG := '이미 존재하는 아이디입니다.';
         ROLLBACK;
    WHEN EXCEPT_NOT_VALID_AGE
    THEN O_ERRCODE := 'ERR002';
         O_ERRMSG := '유효하지 않은 나이값입니다.';
         ROLLBACK;
    WHEN OTHERS
    THEN O_ERRCODE := SQLCODE;
         O_ERRMSG := SQLERRM;
         ROLLBACK;
         
  END PROC_INS_USER_TBL;


  --USER_TBL SELECT  회원인 고객만 검색 가능
  PROCEDURE PROC_SEL_USER_TBL
  (
    IN_U_ID             IN  VARCHAR2,
    IN_U_NAME           IN  VARCHAR2,
    IN_U_AGE            IN  VARCHAR2,
    IN_U_TEL            IN  VARCHAR2,
    IN_U_GENDER         IN  VARCHAR2,
    IN_U_POINT          IN  VARCHAR2,
    IN_U_GUBUN          IN  VARCHAR2,
    IN_U_GRADE          IN  VARCHAR2,
    O_CUR               OUT SYS_REFCURSOR,
    O_ERRCODE           OUT VARCHAR2,
    O_ERRMSG            OUT VARCHAR2
  )
   AS
  BEGIN
  
    OPEN O_CUR FOR
    SELECT *
    FROM USER_TBL
    WHERE U_ID LIKE '%'|| IN_U_ID ||'%'
      AND U_NAME LIKE '%'|| IN_U_NAME ||'%'
      AND U_AGE LIKE '%'|| IN_U_AGE ||'%'
      AND U_TEL LIKE '%'|| IN_U_TEL ||'%'
      AND U_GENDER LIKE '%'|| IN_U_GENDER ||'%'
      AND U_POINT LIKE '%'|| IN_U_POINT ||'%'
      AND U_GUBUN LIKE '%'|| IN_U_GUBUN ||'%'
      AND U_GRADE LIKE '%'|| IN_U_GRADE ||'%'
    ;
  
    EXCEPTION
    WHEN OTHERS
    THEN O_ERRCODE := SQLCODE;
         O_ERRMSG := SQLERRM;
         ROLLBACK;
         
  END PROC_SEL_USER_TBL;


  --USER_TBL UPDATE
  PROCEDURE PROC_UP_USER_TBL
  (
    IN_U_ID             IN  VARCHAR2,
    IN_U_NAME           IN  VARCHAR2,
    IN_U_AGE            IN  VARCHAR2,
    IN_U_TEL            IN  VARCHAR2,
    IN_U_GENDER         IN  VARCHAR2,
    IN_U_POINT          IN  VARCHAR2,
    IN_U_GUBUN          IN  VARCHAR2,
    IN_U_GRADE          IN  VARCHAR2,
    O_ERRCODE           OUT VARCHAR2,
    O_ERRMSG            OUT VARCHAR2
  )
   AS
   
   V_CHECK_ID                NUMBER(1);
   
   EXCEPT_NOT_VALID_AGE      EXCEPTION;
   EXCEPT_NOT_EXIST_ID       EXCEPTION;
   
  BEGIN
  
    --아이디가 존재하는지 확인
    SELECT COUNT(U_ID)
    INTO V_CHECK_ID
    FROM USER_TBL
    WHERE U_ID = IN_U_ID;
    
    IF V_CHECK_ID = 0
    THEN RAISE EXCEPT_NOT_EXIST_ID;
    END IF;
    
    --나이 양수인지 확인
    IF TO_NUMBER(IN_U_AGE) < 0
    THEN RAISE EXCEPT_NOT_VALID_AGE;
    END IF;
    
    
    UPDATE USER_TBL
    SET U_NAME = IN_U_NAME,
        U_AGE = IN_U_AGE,
        U_TEL = IN_U_TEL,
        U_GENDER = IN_U_GENDER,
        U_POINT = IN_U_POINT,
        U_GUBUN = IN_U_GUBUN,
        U_GRADE = IN_U_GRADE
    WHERE U_ID = IN_U_ID
    ;
    
  
    EXCEPTION
    WHEN EXCEPT_NOT_EXIST_ID
    THEN O_ERRCODE := 'ERR001';
         O_ERRMSG := '존재하지 않는 아이디입니다.';
         ROLLBACK;    
    WHEN EXCEPT_NOT_VALID_AGE
    THEN O_ERRCODE := 'ERR002';
         O_ERRMSG := '유효하지 않은 나이값입니다.';
         ROLLBACK;
    WHEN OTHERS
    THEN O_ERRCODE := SQLCODE;
         O_ERRMSG := SQLERRM;
         ROLLBACK;
         
  END PROC_UP_USER_TBL;


  --USER_TBL DELETE
  PROCEDURE PROC_DEL_USER_TBL
  (
    IN_U_ID             IN  VARCHAR2,
    O_ERRCODE           OUT VARCHAR2,
    O_ERRMSG            OUT VARCHAR2
  )
   AS
      V_CHECK_ID                NUMBER(1);
      EXCEPT_NOT_EXIST_ID       EXCEPTION;
  BEGIN
  
    --아이디가 존재하는지 확인
    SELECT COUNT(U_ID)
    INTO V_CHECK_ID
    FROM USER_TBL
    WHERE U_ID = IN_U_ID;
    
    IF V_CHECK_ID = 0
    THEN RAISE EXCEPT_NOT_EXIST_ID;
    END IF;
    
    

    DELETE USER_TBL
    WHERE U_ID = IN_U_ID
    ;
  
  
    EXCEPTION
    WHEN EXCEPT_NOT_EXIST_ID
    THEN O_ERRCODE := 'ERR001';
         O_ERRMSG := '존재하지 않는 아이디입니다.';
         ROLLBACK;    
    WHEN OTHERS
    THEN O_ERRCODE := SQLCODE;
         O_ERRMSG := SQLERRM;
         ROLLBACK;
         
  END PROC_DEL_USER_TBL;

END PKG_USER_TBL;

--USER_TBL 바디 끝


--@@@
--THEATER_TBL 헤드
create or replace PACKAGE PKG_THEATER_TBL AS 

	  PROCEDURE PROC_INS_THEATER
    (
        IN_B_ID         IN VARCHAR2,
        IN_TH_SEATS     IN NUMBER,
        IN_TH_TYPE      IN VARCHAR2,
        O_ERRCODE       OUT VARCHAR2,
        O_ERRMSG        OUT VARCHAR2
    );
  
    PROCEDURE PROC_SEL_THEATER
    (
        IN_TH_ID        IN      VARCHAR2,
        O_CUR           OUT     SYS_REFCURSOR,
        O_ERRCODE       OUT     VARCHAR2,
        O_ERRMSG        OUT     VARCHAR2
    );

    PROCEDURE PROC_UP_THEATER
    (
        IN_TH_ID        IN VARCHAR2,
        IN_B_ID         IN VARCHAR2,
        IN_TH_SEATS     IN NUMBER,
        IN_TH_TYPE      IN VARCHAR2,
        O_ERRCODE       OUT VARCHAR2,
        O_ERRMSG        OUT VARCHAR2

    );
  
    PROCEDURE PROC_DEL_THEATER
    (
        IN_TH_ID        IN VARCHAR2,
        O_ERRCODE       OUT VARCHAR2,
        O_ERRMSG        OUT VARCHAR2
    );

END PKG_THEATER_TBL;

--THEATER_TBL 헤드 끝

--THEATER_TBL 바디
create or replace PACKAGE BODY PKG_THEATER_TBL AS

  PROCEDURE PROC_INS_THEATER
  (
        IN_B_ID         IN VARCHAR2,
        IN_TH_SEATS     IN NUMBER,
        IN_TH_TYPE      IN VARCHAR2,
        
        O_ERRCODE       OUT VARCHAR2,
        O_ERRMSG        OUT VARCHAR2
  )
  AS
    
    V_NEW_ID               CHAR(5);
    V_CHK_ID               CHAR(5);
      
  BEGIN
    
    SELECT 'TH' || TO_CHAR(NVL(TO_NUMBER(SUBSTR(MAX(TH_ID), 3, 3)), 0) + 1, 'FM000')
    INTO V_NEW_ID
    FROM THEATER_TBL
    ;
  
    INSERT INTO THEATER_TBL(TH_ID, B_ID, TH_SEATS, TH_TYPE_GRP, TH_TYPE)
    VALUES(V_NEW_ID, IN_B_ID, IN_TH_SEATS, 'GRP005', IN_TH_TYPE);
    
    EXCEPTION 
    WHEN OTHERS THEN
    
        O_ERRCODE := SQLCODE;
        O_ERRMSG := SQLERRM;
        ROLLBACK;
    
  
  END PROC_INS_THEATER;
  

  PROCEDURE PROC_SEL_THEATER
  (
        IN_TH_ID        IN      VARCHAR2,
        O_CUR           OUT     SYS_REFCURSOR,
        O_ERRCODE       OUT     VARCHAR2,
        O_ERRMSG        OUT     VARCHAR2
  ) 
  AS
        
  BEGIN
    
        OPEN O_CUR FOR
        SELECT T1.TH_ID, T3.B_NAME AS THEATER_NAME, T1.TH_SEATS, T2.COM_NAME AS THEATER_TYPE
        FROM THEATER_TBL T1, COMMONS_TBL T2, BRANCH_TBL T3
        WHERE T1.TH_TYPE_GRP = T2.GRP_ID
        AND T1.TH_TYPE = T2.COM_ID
        AND T1.B_ID = T3.B_ID 
        AND T1.TH_ID LIKE '%' || IN_TH_ID || '%'
        AND T2.GRP_ID = 'GRP005'
        ;
        
        EXCEPTION
        WHEN OTHERS
        THEN O_ERRCODE := SQLCODE;
             O_ERRMSG := SQLERRM;
    
  END PROC_SEL_THEATER;
  
  
  PROCEDURE PROC_UP_THEATER
  (
        IN_TH_ID        IN VARCHAR2,
        IN_B_ID         IN VARCHAR2,
        IN_TH_SEATS     IN NUMBER,
        IN_TH_TYPE      IN VARCHAR2,
        
        O_ERRCODE       OUT VARCHAR2,
        O_ERRMSG        OUT VARCHAR2
  ) 
  AS
  
    V_NEW_ID            CHAR(5);
    
    EXP_T_ERROR         EXCEPTION;
  
  BEGIN
  
    SELECT DECODE(MAX(TH_ID), NULL, 0, 1)
    INTO V_NEW_ID
    FROM THEATER_TBL
    WHERE TH_ID = IN_TH_ID
    ;
    
    IF V_NEW_ID = 0 THEN
    
        RAISE EXP_T_ERROR;
    
    ELSE
    
        UPDATE THEATER_TBL
        SET B_ID = IN_B_ID, TH_SEATS = IN_TH_SEATS, 
            TH_TYPE_GRP = 'GRP005', TH_TYPE = IN_TH_TYPE
        WHERE TH_ID = IN_TH_ID
        ;
        
    END IF;
    
    EXCEPTION 
    WHEN EXP_T_ERROR THEN
    
        O_ERRCODE := 'ERR006';
        O_ERRMSG := '존재하지 않는 아이디입니다';
        ROLLBACK;
        
    WHEN OTHERS THEN
    
        O_ERRCODE := SQLCODE;
        O_ERRMSG := SQLERRM; 
        ROLLBACK;
  
  END PROC_UP_THEATER;
  
  
  PROCEDURE PROC_DEL_THEATER
  (
        IN_TH_ID        IN VARCHAR2,
        
        O_ERRCODE       OUT VARCHAR2,
        O_ERRMSG        OUT VARCHAR2
  )
  AS
  
        V_NEW_ID            CHAR(5);
    
        EXP_T_ERROR         EXCEPTION;
  
  BEGIN
  
    SELECT DECODE(MAX(TH_ID), NULL, 0, 1)
    INTO V_NEW_ID
    FROM THEATER_TBL
    WHERE TH_ID = IN_TH_ID
    ;
    
    IF V_NEW_ID = 0 THEN
        
        RAISE EXP_T_ERROR;
    
    ELSE
  
    DELETE FROM THEATER_TBL
    WHERE TH_ID = IN_TH_ID;
    
    END IF;
    
    EXCEPTION
    WHEN EXP_T_ERROR THEN
        
        O_ERRCODE := 'ERR007';
        O_ERRMSG := '존재하지 않는 아이디입니다';
        ROLLBACK;
    
    WHEN OTHERS THEN
    
        O_ERRCODE := SQLCODE;
        O_ERRMSG := SQLERRM;
        ROLLBACK;
  
  END PROC_DEL_THEATER;
  
  

END PKG_THEATER_TBL;

--THEATER_TBL 바디 끝


--@@@
--BRANCH_TBL 헤드
create or replace PACKAGE PKG_BRANCH_TBL AS 

	  PROCEDURE PROC_INS_BRANCH
    (
        IN_B_NAME          IN VARCHAR2,
        IN_B_AREA          IN VARCHAR2,
        O_ERRCODE          OUT VARCHAR2,
        O_ERRMSG           OUT VARCHAR2
    );
  
    PROCEDURE PROC_SEL_BRANCH
    (
        IN_B_NAME          IN  VARCHAR2,
        O_CUR              OUT SYS_REFCURSOR
    );
  
    PROCEDURE PROC_UP_BRANCH
    (
        IN_B_ID            IN VARCHAR2,
        IN_B_NAME          IN VARCHAR2,
        IN_B_AREA          IN VARCHAR2,
        O_ERRCODE          OUT VARCHAR2,
        O_ERRMSG           OUT VARCHAR2
    );
  
    PROCEDURE PROC_DEL_BRANCH
    (
        IN_B_ID            IN VARCHAR2,
        IN_B_NAME          IN VARCHAR2,
        O_ERRCODE          OUT VARCHAR2,
        O_ERRMSG           OUT VARCHAR2
    );
  

END PKG_BRANCH_TBL;

--BRANCH_TBL 헤드 끝

--BRANCH_TBL 바디
create or replace PACKAGE BODY PKG_BRANCH_TBL AS
--INSERT
  PROCEDURE PROC_INS_BRANCH
  (
        IN_B_NAME          IN VARCHAR2,
        IN_B_AREA          IN VARCHAR2,
        
        O_ERRCODE          OUT VARCHAR2,
        O_ERRMSG          OUT VARCHAR2
  ) AS
    
    V_NEW_ID               CHAR(5);
    V_B_NAME               VARCHAR(100);
    
    EXP_B_ERROR            EXCEPTION;
    
  BEGIN
    
    SELECT DECODE(MAX(B_NAME), NULL, 0, 1)
    INTO V_B_NAME
    FROM BRANCH_TBL
    WHERE B_NAME = IN_B_NAME
    ;
    
    IF V_B_NAME = 1 THEN
    
        RAISE EXP_B_ERROR;
    
    ELSE
    
		    SELECT 'B' || TO_CHAR(NVL(TO_NUMBER(SUBSTR(MAX(B_ID), 2, 4)), 0) + 1, 'FM0000')
        INTO V_NEW_ID
        FROM BRANCH_TBL
        ;
        
        INSERT INTO BRANCH_TBL(B_ID, B_NAME, B_AREA_GRP, B_AREA)
        VALUES(V_NEW_ID, IN_B_NAME, 'GRP001', IN_B_AREA);
    
    END IF;
    
    EXCEPTION 
    WHEN EXP_B_ERROR THEN
        
        O_ERRCODE := 'ERR001';
        O_ERRMSG := '이미 존재하는 지점입니다';
        ROLLBACK;
        
    WHEN OTHERS THEN
    
        O_ERRCODE := SQLCODE;
        O_ERRMSG := SQLERRM;
				ROLLBACK;
    
  END PROC_INS_BRANCH;
  
--SELECT  
  PROCEDURE PROC_SEL_BRANCH
  (
        IN_B_NAME       IN VARCHAR2,
        O_CUR           OUT SYS_REFCURSOR
  )
  AS
  
  BEGIN
  
    OPEN O_CUR FOR
    SELECT *
    FROM BRANCH_TBL
    WHERE B_NAME LIKE '%' || IN_B_NAME || '%'
    ;
          
  END PROC_SEL_BRANCH;
  
--UPDATE
 PROCEDURE PROC_UP_BRANCH
  (
        IN_B_ID            IN VARCHAR2,
        IN_B_NAME          IN VARCHAR2,
        IN_B_AREA          IN VARCHAR2,
        
        O_ERRCODE          OUT VARCHAR2,
        O_ERRMSG           OUT VARCHAR2
  )
  AS
  
    V_B_ID                 CHAR(5);
    
    EXP_B_ERROR            EXCEPTION;
    
  BEGIN
    
    SELECT DECODE(MAX(B_ID), NULL, 0, 1)
    INTO V_B_ID
    FROM BRANCH_TBL
    WHERE B_ID = IN_B_ID
    ;
    
    IF V_B_ID = 0 THEN
        
        RAISE EXP_B_ERROR;
        
    ELSE
        
        UPDATE BRANCH_TBL
        SET B_NAME = IN_B_NAME, B_AREA_GRP = 'GRP001', B_AREA = IN_B_AREA
        WHERE B_ID = IN_B_ID
        ;
        
    END IF;
    
    EXCEPTION
    WHEN EXP_B_ERROR THEN
        
        O_ERRCODE := 'ERR002';
        O_ERRMSG := '존재하지 않는 지점입니다';
				ROLLBACK;
    
    WHEN OTHERS THEN
        
        O_ERRCODE := SQLCODE;
        O_ERRMSG := SQLERRM;
				ROLLBACK;
  
  END PROC_UP_BRANCH;
  
  PROCEDURE PROC_DEL_BRANCH
  (
        IN_B_ID            IN VARCHAR2,
        IN_B_NAME          IN VARCHAR2,
        
        O_ERRCODE          OUT VARCHAR2,
        O_ERRMSG           OUT VARCHAR2
  )
  AS
    
    V_B_ID                 CHAR(5);
    
    EXP_B_ERROR            EXCEPTION;
  
  BEGIN
    
    SELECT DECODE(MAX(B_ID), NULL, 0, 1)
    INTO V_B_ID
    FROM BRANCH_TBL
    WHERE B_ID = IN_B_ID
    ;
    
    IF V_B_ID = 0 THEN
    
        RAISE EXP_B_ERROR;
        
    ELSE
      
	      DELETE FROM BRANCH_TBL
	      WHERE B_ID = IN_B_ID AND B_NAME = IN_B_NAME
	      ;
      
    END IF;
    
    EXCEPTION
    WHEN EXP_B_ERROR THEN
    
        O_ERRCODE := 'ERR003';
        O_ERRMSG := '존재하지 않는 아이디입니다';
				ROLLBACK;
    
    WHEN OTHERS THEN
    
        O_ERRCODE := SQLCODE;
        O_ERRMSG := SQLERRM;
				ROLLBACK;
  
  END PROC_DEL_BRANCH;
    
 

END PKG_BRANCH_TBL;

--BRANCH_TBL 바디 끝


--@@@
--MOVIE_TBL 헤드
create or replace NONEDITIONABLE PACKAGE PKG_MOVIE_TBL AS 

/*
         작성일 : 20220328
         최초작성자: 전인호
         업무설명: MOVIE_TBL에 대한 CRUD 작성
 
         수정 사항
         ------------------------------------------------------------
         수정일             수정자                  수정내용
         --------------------------------------------------------------
         20220328           전인호                 데이터수정   
*/
 
   
  -- MOVIE_TBL INSERT
  --> M_ID 제외. 모든 데이터 삽입가능.
  --> GRP는 자동입력 되게끔
   PROCEDURE PROC_INS_MOVIE_TBL
   (
        IN_M_NAME                  IN          VARCHAR2,
        IN_M_COUNTRY               IN          VARCHAR2,
        IN_M_RELEASE               IN          VARCHAR2,
        IN_M_RUNTIME               IN          VARCHAR2,
        IN_M_AGE_LIMIT             IN          VARCHAR2,
        IN_M_AGENCY                IN          VARCHAR2,
        O_ERRCODE                  OUT         VARCHAR2,
        O_ERRMSG                   OUT         VARCHAR2        
   );
   
   
   
    -- MOVIE_TBL DELETE.
   --> ID와 NAME을 같이 입력해야 삭제되게끔
   PROCEDURE PROC_DEL_MOVIE_TBL
   ( 
       IN_M_ID                    IN          VARCHAR2,
       IN_M_NAME                  IN          VARCHAR2,
       O_ERRCODE                  OUT         VARCHAR2,
       O_ERRMSG                   OUT         VARCHAR2       
   );
   
   
    -- MOVIE_TBL UPDATE 
   -- 국적GRP,  배급사GRP 제외
   PROCEDURE PROC_UP_MOVIE_TBL
   (
        IN_M_ID                    IN          VARCHAR2,
        IN_M_NAME                  IN          VARCHAR2,
        IN_M_COUNTRY               IN          VARCHAR2,
        IN_M_RELEASE               IN          VARCHAR2,
        IN_M_RUNTIME               IN          VARCHAR2,
        IN_M_AGE_LIMIT             IN          VARCHAR2,
        IN_M_AGENCY                IN          VARCHAR2,
        O_ERRCODE                  OUT         VARCHAR2,
        O_ERRMSG                   OUT         VARCHAR2        
   );
   
   
   PROCEDURE PROC_SEL_MOVIE_TBL
   (
        IN_M_ID                    IN          VARCHAR2,
        IN_M_NAME                  IN          VARCHAR2,
        IN_M_COUNTRY               IN          VARCHAR2,
        IN_M_RELEASE               IN          VARCHAR2,
        IN_M_RUNTIME               IN          VARCHAR2,
        IN_M_AGE_LIMIT             IN          VARCHAR2,
        IN_M_AGENCY                IN          VARCHAR2,
        O_ERRCODE                  OUT         VARCHAR2,
        O_ERRMSG                   OUT         VARCHAR2,
        O_CUR                      OUT         SYS_REFCURSOR        
   );

END PKG_MOVIE_TBL;

--MOVIE_TBL 헤드 끝

--MOVIE_TBL 바디
create or replace NONEDITIONABLE PACKAGE BODY PKG_MOVIE_TBL AS
  -->MOVIE_TBL INSERT
  PROCEDURE PROC_INS_MOVIE_TBL
   (
        IN_M_NAME                  IN          VARCHAR2,
        IN_M_COUNTRY               IN          VARCHAR2,
        IN_M_RELEASE               IN          VARCHAR2,
        IN_M_RUNTIME               IN          VARCHAR2,
        IN_M_AGE_LIMIT             IN          VARCHAR2,
        IN_M_AGENCY                IN          VARCHAR2,
        O_ERRCODE                  OUT         VARCHAR2,
        O_ERRMSG                   OUT         VARCHAR2        
   ) 
   AS
            V_NEW_ID                CHAR(5);            
            V_CHK_NULL              NUMBER(1);
            
            
            ALREADY_EXIST_EXCEPT    EXCEPTION;   
  BEGIN
           
        --> M_ID 를 자동으로 채워주는 로직
        SELECT 'M' || TO_CHAR(TO_NUMBER(SUBSTR(NVL(MAX(M_ID) , 'M0000'),2,4)) + 1, 'FM0000')
        INTO V_NEW_ID
        FROM MOVIE_TBL;
        
        
        
        --> 영화이름 중복되는지 확인하기.
        --> 결과값(M_NAME)이 NULL이면 0 //중복 없으니, 삽입가능
        --> 결과값(M_NAME)이  1이면 중복이 있으니 예외처리
        SELECT DECODE( MAX(M_NAME), NULL, 0 , 1)  
        INTO V_CHK_NULL
        FROM MOVIE_TBL
        WHERE M_NAME = IN_M_NAME
        ;
        
        
        --> 만약 중복된 영화이름이 없다면 INSERT
        IF V_CHK_NULL = 0 THEN
            INSERT INTO MOVIE_TBL( M_ID , M_NAME, M_COUNTRY_GRP,  M_COUNTRY, M_RELEASE, M_RUNTIME, M_AGE_LIMIT, M_AGENCY_GRP, M_AGENCY)
            VALUES( V_NEW_ID, IN_M_NAME, 'GRP003', IN_M_COUNTRY, IN_M_RELEASE, IN_M_RUNTIME , IN_M_AGE_LIMIT, 'GRP004' , IN_M_AGENCY);
        ELSE 
            RAISE ALREADY_EXIST_EXCEPT;
        END IF;
        
 
 
 
        EXCEPTION
        WHEN ALREADY_EXIST_EXCEPT THEN
            O_ERRCODE := '100';
            O_ERRMSG := '입력하신 영화이름이 프로그램에 존재합니다';
            ROLLBACK;
        WHEN OTHERS THEN
            O_ERRCODE := SQLCODE;
            O_ERRMSG := SQLERRM;
            ROLLBACK;
 
  END PROC_INS_MOVIE_TBL;
  
  
  
  
  
   -- MOVIE_TBL DELETE.
   --> ID와 NAME을 같이 입력해야 삭제되게끔  
   PROCEDURE PROC_DEL_MOVIE_TBL
   ( 
       IN_M_ID                    IN          VARCHAR2,
       IN_M_NAME                  IN          VARCHAR2,
       O_ERRCODE                  OUT         VARCHAR2,
       O_ERRMSG                   OUT         VARCHAR2       
   )
   AS
        
            V_CHK_NULL          NUMBER(1);
            V_CHK_NULL2         NUMBER(1);
            
            
            NO_EXIST_EXCEPT     EXCEPTION;
   
   BEGIN
   
            --> 입력한 영화이름(M_NAME)의 정보가 존재하는지? --> 존재해야 삭제 
            SELECT DECODE(MAX(M_NAME), NULL, 0 , 1)
            INTO V_CHK_NULL
            FROM MOVIE_TBL
            WHERE M_NAME = IN_M_NAME
            ;
            SELECT DECODE(MAX(M_ID), NULL, 0 , 1)
            INTO V_CHK_NULL2
            FROM MOVIE_TBL
            WHERE M_ID = IN_M_ID
            ;
   
            
            --> 삭제할려는 영화이름이 존재한다면? 삭제
            --> 삭제하고자하는 영화아이디와 영화이름 2개를 정확히 입력하도록 유도
            IF V_CHK_NULL != 0 OR  V_CHK_NULL2 !=0 THEN
                DELETE FROM MOVIE_TBL
                WHERE M_ID = IN_M_ID AND M_NAME = IN_M_NAME
                ;
            ELSE
                RAISE NO_EXIST_EXCEPT;
            END IF;
            
            
            
            
            EXCEPTION
            WHEN NO_EXIST_EXCEPT THEN
                O_ERRCODE := '101';
                O_ERRMSG := '잘못 입력하셨습니다 정확하게 입력해주세요.';
                ROLLBACK;
                
            WHEN OTHERS THEN
                O_ERRCODE := SQLCODE;
                O_ERRMSG := SQLERRM;
                ROLLBACK;
   
   END PROC_DEL_MOVIE_TBL;
   
   
   
   
   
   -- MOVIE_TBL UPDATE 
   -- 국적GRP,  배급사GRP 제외
   PROCEDURE PROC_UP_MOVIE_TBL
   (
        IN_M_ID                    IN          VARCHAR2,
        IN_M_NAME                  IN          VARCHAR2,
        IN_M_COUNTRY               IN          VARCHAR2,
        IN_M_RELEASE               IN          VARCHAR2,
        IN_M_RUNTIME               IN          VARCHAR2,
        IN_M_AGE_LIMIT             IN          VARCHAR2,
        IN_M_AGENCY                IN          VARCHAR2,
        O_ERRCODE                  OUT         VARCHAR2,
        O_ERRMSG                   OUT         VARCHAR2        
   )
   AS
            V_CHK_NULL          NUMBER(1);
            
            
            NO_EXIST_EXCEPT     EXCEPTION;  
   
   BEGIN
            --> M_ID가 존재한다면 1, 존재안하면 0
            SELECT DECODE(MAX(M_ID), NULL, 0 , 1)
            INTO V_CHK_NULL
            FROM MOVIE_TBL
            WHERE M_ID = IN_M_ID
            ;
   
            --> M_ID가 존재할때만 UPDATE실시
            IF V_CHK_NULL != 0 THEN
                UPDATE MOVIE_TBL
                SET M_NAME = IN_M_NAME
                   ,M_COUNTRY = IN_M_COUNTRY
                   ,M_RELEASE = IN_M_RELEASE
                   ,M_RUNTIME = IN_M_RUNTIME
                   ,M_AGE_LIMIT = IN_M_AGE_LIMIT
                   ,M_AGENCY = IN_M_AGENCY
                WHERE M_ID = IN_M_ID
                ;
            ELSE
                 RAISE NO_EXIST_EXCEPT;
            END IF;
            
            
            
            
            EXCEPTION
            WHEN NO_EXIST_EXCEPT THEN
                O_ERRCODE := '102';
                O_ERRMSG := '삭제할려는 인덱스번호가 존재하지 않습니다.';
                ROLLBACK;            
            WHEN OTHERS THEN
                O_ERRCODE := SQLCODE;
                O_ERRMSG := SQLERRM;
                ROLLBACK;
   END PROC_UP_MOVIE_TBL;
   
   
   
   
   
   -->MOVIE_TBL SELECT
    PROCEDURE PROC_SEL_MOVIE_TBL
   (
        IN_M_ID                    IN          VARCHAR2,
        IN_M_NAME                  IN          VARCHAR2,
        IN_M_COUNTRY               IN          VARCHAR2,
        IN_M_RELEASE               IN          VARCHAR2,
        IN_M_RUNTIME               IN          VARCHAR2,
        IN_M_AGE_LIMIT             IN          VARCHAR2,
        IN_M_AGENCY                IN          VARCHAR2,
        O_ERRCODE                  OUT         VARCHAR2,
        O_ERRMSG                   OUT         VARCHAR2,
        O_CUR                      OUT         SYS_REFCURSOR
   )
   
   
   AS
        CHK_MOVIE_NAME                  NUMBER(1);
        CHK_MOVIE_NAME_EXCEPT           EXCEPTION;
   
   BEGIN
   
            --> 입력한 MID MNAME... 등등이 존재하는지? 
            -->RELEASE가 2022 아래인지? 최소 앞에자리가 2 이상이면안된다.
           SELECT DECODE(MAX(M_NAME), NULL, 0 , 1)
           INTO CHK_MOVIE_NAME
           FROM MOVIE_TBL
           WHERE M_NAME LIKE '%' || IN_M_NAME || '%'
           ;
           
            
            
            --> 조회하기
            IF CHK_MOVIE_NAME != 0 THEN
                OPEN O_CUR FOR
                SELECT * 
                FROM MOVIE_TBL
                WHERE M_ID LIKE '%' || IN_M_ID || '%'
                AND  M_NAME LIKE '%' || IN_M_NAME || '%'
                AND  M_COUNTRY LIKE '%' || IN_M_COUNTRY || '%'
                AND  M_RELEASE LIKE '%' || IN_M_RELEASE || '%'
                AND  M_RUNTIME LIKE '%' || IN_M_RUNTIME || '%'
                AND  M_AGE_LIMIT LIKE '%' || IN_M_AGE_LIMIT || '%'
                AND  M_AGENCY LIKE '%' || IN_M_AGENCY || '%'            
                ;
            ELSE
                    RAISE CHK_MOVIE_NAME_EXCEPT;
            END IF;
            
            EXCEPTION
            WHEN CHK_MOVIE_NAME_EXCEPT THEN
                O_ERRCODE := '103';
                O_ERRMSG := '해당 영화명이 없어서 조회가 불가능합니다';
                ROLLBACK;              
            WHEN OTHERS THEN
                O_ERRCODE := SQLCODE;
                O_ERRMSG := SQLERRM;
                ROLLBACK;   
   END PROC_SEL_MOVIE_TBL;

END PKG_MOVIE_TBL;

--MOVIE_TBL 바디 끝


--@@@
--GENRE_TBL 헤드
create or replace NONEDITIONABLE PACKAGE PKG_GENRE AS 

/*
         작성일 : 20220328
         최초작성자: 전인호
         업무설명: GENRE_TBL에 대한 CRUD 작성
 
         수정 사항
         ------------------------------------------------------------
         수정일             수정자                  수정내용
         --------------------------------------------------------------
         20220328           전인호                 데이터수정
         
*/


  --GENRE_TBL CRUD
  
  
  --GENRE_TBL SELECT
  --GRP는 고정이니깐 넣어두기.
  PROCEDURE PROC_SEL_GENRE
  (
     IN_M_ID            IN          VARCHAR2,
     IN_G_GENRE         IN          VARCHAR2,
     O_CUR              OUT         SYS_REFCURSOR,
     O_ERRCODE          OUT         VARCHAR2,
     O_ERRMSG           OUT         VARCHAR2
  );
  
  
  --GENRE TBL INSERT
  PROCEDURE PROC_INS_GENRE
  (
     IN_M_ID            IN          VARCHAR2,
     IN_G_GENRE_GRP     IN          VARCHAR2,
     IN_G_GENRE         IN          VARCHAR2,
     O_ERRCODE          OUT         VARCHAR2,
     O_ERRMSG           OUT         VARCHAR2     
  );
  
  --GENRE_TBL DELETE
  PROCEDURE PROC_DEL_GENRE
  (
     IN_IDX             IN          VARCHAR2,
     O_ERRCODE          OUT         VARCHAR2,
     O_ERRMSG           OUT         VARCHAR2          
  );
  
  --GENRE_TBL UPDATE
  --GRP는 고정이니깐 넣어두기.
  PROCEDURE PROC_UP_GENRE
  (
     IN_IDX             IN          VARCHAR2,  
     IN_M_ID            IN          VARCHAR2,
     IN_G_GENRE         IN          VARCHAR2,
     O_ERRCODE          OUT         VARCHAR2,
     O_ERRMSG           OUT         VARCHAR2 
  );

END PKG_GENRE;

--GENRE_TBL 헤드 끝

--GENRE_TBL 바디
create or replace NONEDITIONABLE PACKAGE BODY PKG_GENRE AS

    --GENRE_TBL SELECT
  PROCEDURE PROC_SEL_GENRE
  (
     IN_M_ID            IN          VARCHAR2,
     IN_G_GENRE         IN          VARCHAR2,
     O_CUR              OUT         SYS_REFCURSOR,
     O_ERRCODE          OUT         VARCHAR2,
     O_ERRMSG           OUT         VARCHAR2
  ) 
  AS
            V_CHK_NULL              NUMBER(1);
            
            
            NO_DATA_EXCEPT          EXCEPTION;
  BEGIN
        
        --> 입력한 M_ID가 실제 MOVIE_TBL에 있는지 확인
          SELECT DECODE(MAX(M_ID) , NULL, 0 , 1)
          INTO V_CHK_NULL
          FROM MOVIE_TBL
          WHERE M_ID = IN_M_ID
          ;
         
         --> 입력한 G_GENRE_GRP, G_GENRE가 존재하는지 확인?
          -- 
         
         
         
         
         
         
         
        --V_CHK_NULL 이 0이 아니라면 입력한 정보가 존재한다는 의미.
        IF V_CHK_NULL != 0 THEN
            OPEN O_CUR FOR
            SELECT *
            FROM GENRE_TBL
            WHERE M_ID LIKE '%' || IN_M_ID || '%'
            AND G_GENRE_GRP = 'GRP008'
            AND G_GENRE LIKE '%' || IN_G_GENRE || '%'
            ;
        ELSE
           RAISE NO_DATA_EXCEPT;
        END IF;
        
        
        EXCEPTION
        WHEN NO_DATA_EXCEPT THEN
            O_ERRCODE := '200';
            O_ERRMSG := '해당 영화 정보가 존재하지 않습니다';
            ROLLBACK;         
        WHEN OTHERS THEN
            O_ERRCODE := SQLCODE;
            O_ERRMSG := SQLERRM;
            ROLLBACK;  
            
            
  END PROC_SEL_GENRE;
  
  
  
    --GENRE TBL INSERT
  PROCEDURE PROC_INS_GENRE
  (
     IN_M_ID            IN          VARCHAR2,
     IN_G_GENRE_GRP     IN          VARCHAR2,
     IN_G_GENRE         IN          VARCHAR2,
     O_ERRCODE          OUT         VARCHAR2,
     O_ERRMSG           OUT         VARCHAR2     
  )
  AS
            V_NEW_IDX          NUMBER(8);
            CHK_M_ID           NUMBER(1);
            
            
            NO_DATA_EXCEPT     EXCEPTION;
  BEGIN
  
  
            --> 추가할려는 M_ID가 MOVIE_TBL에 있는 영화인지 확인.
           SELECT DECODE(MAX(M_ID), NULL, 0 , 1)
           INTO CHK_M_ID
           FROM MOVIE_TBL
           WHERE M_ID = IN_M_ID 
           ;
  
  
  
        --IDX 자동추가
        SELECT NVL(MAX(IDX), 0 ) + 1
        INTO V_NEW_IDX
        FROM GENRE_TBL;
    
        --> 0이 아닐때, 즉 영화가 존재하면 장르테이블에 정보 추가.
        IF CHK_M_ID != 0 THEN
            --INSERT문
            INSERT INTO GENRE_TBL ( IDX, M_ID, G_GENRE_GRP, G_GENRE)
            VALUES( V_NEW_IDX, IN_M_ID, IN_G_GENRE_GRP, IN_G_GENRE);
        ELSE
            RAISE NO_DATA_EXCEPT;
        END IF;
        
        
        
        EXCEPTION
        WHEN NO_DATA_EXCEPT THEN
            O_ERRCODE := '201';
            O_ERRMSG := '해당 영화가 존재하지 않아, 장르를 추가할 수 없습니다';
            ROLLBACK;        
        WHEN OTHERS THEN
            O_ERRCODE := SQLCODE;
            O_ERRMSG := SQLERRM;
            ROLLBACK;          
        
    
  END PROC_INS_GENRE;
  
   --GENRE_TBL DELETE 
    PROCEDURE PROC_DEL_GENRE
  (
     IN_IDX             IN          VARCHAR2,
     O_ERRCODE          OUT         VARCHAR2,
     O_ERRMSG           OUT         VARCHAR2          
  )
  AS
  
       CHK_DATA_EXIST           NUMBER(1);
    
       NO_DATA_EXCEPT           EXCEPTION;
  BEGIN
        
        
        -->예외 : 1. 삭제할려는 IDX가 존재?--> 삭제할려는 목적이 영화가 아니라, 그 영화의 장르 1개 일수도 있으니 IDX로 지우는게 맞다.
        -- 2. 해당 영화가 GENRE에서 다 삭제가 되면, MOVIE_TBL에서 해당 영화가 제거되도록 설정.
          -- 삭제할려는 IDX가 존재하는가?
        SELECT DECODE(MAX(IDX), NULL,0,1)
        INTO CHK_DATA_EXIST
        FROM GENRE_TBL
        WHERE IDX = IN_IDX
        ;
        
        
        IF CHK_DATA_EXIST != 0 THEN
            DELETE FROM GENRE_TBL
            WHERE IDX = IN_IDX
            ;
        ELSE
            RAISE NO_DATA_EXCEPT;
        END IF;
        
        
        EXCEPTION
        WHEN NO_DATA_EXCEPT THEN
            O_ERRCODE := '202';
            O_ERRMSG := '삭제할 대상이 존재하지 않습니다';
            ROLLBACK;         
        WHEN OTHERS THEN
            O_ERRCODE := SQLCODE;
            O_ERRMSG := SQLERRM;
            ROLLBACK;  
            
  END PROC_DEL_GENRE;





  --GENRE_TBL UPDATE
  PROCEDURE PROC_UP_GENRE
  (
     IN_IDX             IN          VARCHAR2,
     IN_M_ID            IN          VARCHAR2,
     IN_G_GENRE         IN          VARCHAR2,
     O_ERRCODE          OUT         VARCHAR2,
     O_ERRMSG           OUT         VARCHAR2 
  )
  AS
       CHK_DATA_EXIST           NUMBER(1);
       CHK_DATA_EXIST2          NUMBER(1);
       
       NO_DATA_EXCEPT           EXCEPTION;     
  BEGIN
  
             --> 예외 할 것: 1. 입력한 IDX가 존재하는지?
             -->  2. 바꿀려는 값(입력값)의 영화정보가 영화테이블에 존재하고 있는가?
             --> 3. GRP , 장르가 맞는지는 1,2번 해결 후 나중에
            
            --> 해당 IDX 정보가 있는지 확인.
            SELECT DECODE(MAX(IDX), NULL,0,1)
            INTO CHK_DATA_EXIST
            FROM GENRE_TBL
            WHERE IDX = IN_IDX
            ;
            SELECT DECODE(MAX(M_ID), NULL, 0 , 1)
            INTO CHK_DATA_EXIST2
            FROM MOVIE_TBL
            WHERE M_ID = IN_M_ID
            ;
          
        
            -->IDX정보가 있어야 정보수정 --> 없으면 경고문 나오도록 하기 위해서.
            --> 거기다가 수정하고자 입력한 M_ID가 영화테이블에 존재하는지 확인.
            IF CHK_DATA_EXIST != 0 AND CHK_DATA_EXIST2 != 0  THEN
                 UPDATE GENRE_TBL
                 SET M_ID = IN_M_ID,
                     G_GENRE = IN_G_GENRE
                  WHERE IDX = IN_IDX   
                  ;
            ELSE
                  RAISE NO_DATA_EXCEPT;
            END IF;
            
            
            
        EXCEPTION
        WHEN NO_DATA_EXCEPT THEN
            O_ERRCODE := '202';
            O_ERRMSG := '수정하고자 하는 대상이 존재하지 않습니다';
            ROLLBACK;         
        WHEN OTHERS THEN
            O_ERRCODE := SQLCODE;
            O_ERRMSG := SQLERRM;
            ROLLBACK;  
             
  END PROC_UP_GENRE;
END PKG_GENRE;

--GENRE_TBL 바디 끝


--@@@
--RESERVATION_TBL 헤드
create or replace NONEDITIONABLE PACKAGE PKG_RESERVATION_TBL AS 

/*
    작성일 : 20220329
    최초작성자 : 박진교
    업무설명 : RESERVATION_TBL에 대한 CRUD
*/
     
    --RESERVATION_TBL INSERT
    PROCEDURE PROC_INS_RESERVATION_TBL
    (
        IN_U_ID             IN  VARCHAR2,
        IN_TM_ID            IN  VARCHAR2,
        IN_R_QTY            IN  VARCHAR2,
        IN_R_DATE           IN  VARCHAR2,
        IN_R_GUBUN          IN  VARCHAR2,
        IN_R_CANCELED_ID    IN  VARCHAR2,
        O_ERRCODE           OUT VARCHAR2,
        O_ERRMSG            OUT VARCHAR2
    );

    --RESERVATION_TBL SELECT
    PROCEDURE PROC_SEL_RESERVATION_TBL
    (
        IN_R_ID             IN  VARCHAR2,
        IN_U_ID             IN  VARCHAR2,
        IN_TM_ID            IN  VARCHAR2,
        IN_R_QTY            IN  VARCHAR2,
        IN_R_STR_DATE       IN  VARCHAR2,
        IN_R_END_DATE       IN  VARCHAR2,
        IN_R_GUBUN          IN  VARCHAR2,
        IN_R_MIN_PRICE      IN  VARCHAR2,
        IN_R_MAX_PRICE      IN  VARCHAR2,
        O_CUR               OUT SYS_REFCURSOR,
        O_ERRCODE           OUT VARCHAR2,
        O_ERRMSG            OUT VARCHAR2
    );

    --RESERVATION_TBL UPDATE
    PROCEDURE PROC_UP_RESERVATION_TBL
    (
        IN_R_ID             IN  VARCHAR2,
        IN_U_ID             IN  VARCHAR2,
        IN_TM_ID            IN  VARCHAR2,
        IN_R_QTY            IN  VARCHAR2,
        IN_R_DATE           IN  VARCHAR2,
        IN_R_GUBUN          IN  VARCHAR2,
        O_ERRCODE           OUT VARCHAR2,
        O_ERRMSG            OUT VARCHAR2
    );

    --RESERVATION_TBL DELETE
    PROCEDURE PROC_DEL_RESERVATION_TBL
    (
        IN_R_ID             IN  VARCHAR2,
        O_ERRCODE           OUT VARCHAR2,
        O_ERRMSG            OUT VARCHAR2
    );

    
END PKG_RESERVATION_TBL;

--RESERVATION_TBL 헤드 끝

--RESERVATION_TBL 바디
create or replace NONEDITIONABLE PACKAGE BODY PKG_RESERVATION_TBL AS

/*
    작성일 : 20220329
    최초작성자 : 박진교
    업무설명 : RESERVATION_TBL에 대한 CRUD
*/

    --좌석 남아있는지 확인하는 함수
    FUNCTION CHECK_RAMAINING_SEATS
    (
        IN_TM_ID          IN  VARCHAR2,
        IN_QTY            IN  NUMBER
    ) RETURN NUMBER
    AS
        V_TH_ID                       CHAR(5);
        V_REMAINING_SEATS             NUMBER(3);
        V_ACCEPTABLE                  NUMBER(1) :=1 ;
    BEGIN
    
    --해당 시간표의 상영관 좌석 찾기
    SELECT A.TH_SEATS
    INTO V_REMAINING_SEATS
    FROM THEATER_TBL A, TIMETABLE_TBL B
    WHERE A.TH_ID = B.TH_ID
    AND   B.TM_ID = IN_TM_ID
    ;
    
    --해당 상영관 찾기
    SELECT A.TH_ID
    INTO V_TH_ID
    FROM THEATER_TBL A, TIMETABLE_TBL B
    WHERE A.TH_ID = B.TH_ID
    AND   B.TM_ID = IN_TM_ID
    ;
    
    --남은 좌석 수 확인
    SELECT V_REMAINING_SEATS - NVL(MAX(TLT_QTY),0)
    INTO V_REMAINING_SEATS
    FROM
    (
        SELECT B.TM_ID, C.TH_ID, SUM(NVL(A.R_QTY,0)) AS TLT_QTY
        FROM RESERVATION_TBL A, TIMETABLE_TBL B, THEATER_TBL C
        WHERE A.TM_ID = B.TM_ID
          AND B.TH_ID = C.TH_ID
          AND B.TM_ID = IN_TM_ID
          AND C.TH_ID = V_TH_ID
          GROUP BY B.TM_ID, C.TH_ID
    )
    ;
    
    IF V_REMAINING_SEATS >= IN_QTY
        THEN V_ACCEPTABLE := 1;
    ELSE
        V_ACCEPTABLE := 0;
    END IF;
    
    
    
        RETURN V_ACCEPTABLE;
    END CHECK_RAMAINING_SEATS
    ;
    

    --RESERVATION_TBL INSERT
  PROCEDURE PROC_INS_RESERVATION_TBL
    (
        IN_U_ID             IN  VARCHAR2,
        IN_TM_ID            IN  VARCHAR2,
        IN_R_QTY            IN  VARCHAR2,
        IN_R_DATE           IN  VARCHAR2,
        IN_R_GUBUN          IN  VARCHAR2,
        IN_R_CANCELED_ID    IN  VARCHAR2,
        O_ERRCODE           OUT VARCHAR2,
        O_ERRMSG            OUT VARCHAR2
    )
     AS
     
     V_MINUS_POINT               NUMBER(8);
     V_U_POINT                   NUMBER(8);
     V_NEW_R_ID                  CHAR(7);
     V_NEW_TLT_PRICE             NUMBER(7);
     V_ACCEPTABLE                NUMBER(1) :=  PKG_RESERVATION_TBL.CHECK_RAMAINING_SEATS(IN_TM_ID,IN_R_QTY);
     
     EXCEPT_NOT_ENOUGH_SEATS     EXCEPTION;
     EXCEPT_NOT_ENOUGH_POINT     EXCEPTION;
     EXCEPT_NOT_VALID_QTY        EXCEPTION;
     
  BEGIN
  
    --예약 취소 시 뱉어내야 하는 포인트 소유중인지 확인
    IF IN_R_CANCELED_ID IS NOT NULL
    THEN
    
    --고객 포인트 가져오기
    SELECT U_POINT
    INTO V_U_POINT
    FROM USER_TBL
    WHERE U_ID = IN_U_ID
    ;
    
    --뱉어내야 하는 포인트 가져오기
    SELECT SUM(P_AMOUNT)
    INTO V_MINUS_POINT
    FROM POINT_TBL
    WHERE R_ID = IN_R_CANCELED_ID
    ;
    
    IF V_U_POINT < V_MINUS_POINT
    THEN RAISE EXCEPT_NOT_ENOUGH_POINT;
    END IF;
    
    
    END IF;
  
    --좌석 남아있는지 확인

    IF V_ACCEPTABLE = 0
    THEN RAISE EXCEPT_NOT_ENOUGH_SEATS;
    END IF;

    
    --수량이 유효한지 확인
    IF TO_NUMBER(IN_R_QTY) < 1
    THEN RAISE EXCEPT_NOT_VALID_QTY;
    END IF;
  
    --R_ID 만들기
    SELECT 'R' || TO_CHAR(TO_NUMBER(SUBSTR(NVL(MAX(R_ID),'R000000'),2,6)) + 1,'FM000000')
    INTO V_NEW_R_ID
    FROM RESERVATION_TBL
    ;
    
    --총 가격 만들기
    SELECT TO_NUMBER(IN_R_QTY) * TM_PRICE
    INTO V_NEW_TLT_PRICE
    FROM TIMETABLE_TBL
    WHERE TM_ID = IN_TM_ID
    ;
    
    INSERT INTO RESERVATION_TBL(R_ID, U_ID, TM_ID, R_QTY, R_DATE, R_GUBUN, R_PRICE, R_CANCELED_ID)
    VALUES(V_NEW_R_ID, IN_U_ID, IN_TM_ID, TO_NUMBER(IN_R_QTY), TO_DATE(IN_R_DATE, 'YYYY-MM-DD'), IN_R_GUBUN, V_NEW_TLT_PRICE, IN_R_CANCELED_ID)
    ;
  
  
    EXCEPTION
    WHEN EXCEPT_NOT_VALID_QTY
    THEN O_ERRCODE := 'ERR002';
         O_ERRMSG := '유효하지 않은 수량입니다.';
         ROLLBACK;
    WHEN EXCEPT_NOT_ENOUGH_SEATS
    THEN O_ERRCODE := 'ERR003';
         O_ERRMSG := '좌석이 충분하지 않습니다.';
         ROLLBACK;
    WHEN EXCEPT_NOT_ENOUGH_POINT
    THEN O_ERRCODE := 'ERR004';
         O_ERRMSG := '취소할 포인트가 모자라 예약 취소를 할 수 없습니다.';
         ROLLBACK;
    WHEN OTHERS
    THEN O_ERRCODE := SQLCODE;
         O_ERRMSG := SQLERRM;
         ROLLBACK;
         
  END PROC_INS_RESERVATION_TBL;


    --RESERVATION_TBL SELECT
  PROCEDURE PROC_SEL_RESERVATION_TBL
    (
        IN_R_ID             IN  VARCHAR2,
        IN_U_ID             IN  VARCHAR2,
        IN_TM_ID            IN  VARCHAR2,
        IN_R_QTY            IN  VARCHAR2,
        IN_R_STR_DATE       IN  VARCHAR2,
        IN_R_END_DATE       IN  VARCHAR2,
        IN_R_GUBUN          IN  VARCHAR2,
        IN_R_MIN_PRICE      IN  VARCHAR2,
        IN_R_MAX_PRICE      IN  VARCHAR2,
        O_CUR               OUT SYS_REFCURSOR,
        O_ERRCODE           OUT VARCHAR2,
        O_ERRMSG            OUT VARCHAR2
    )
     AS
     V_GUBUN            CHAR(1);
     V_MIN_PRICE        NUMBER(7);
     V_MAX_PRICE        NUMBER(7);
     V_STR_DATE         CHAR(8);
     V_END_DATE         CHAR(8);
  BEGIN
  
    --구분이 A, 즉 예약과 취소 구분없이 보고싶다고 한다면
    --NULL을 넣어 모든 결과를 볼 수 있게끔 함
    IF IN_R_GUBUN = 'A' OR IN_R_GUBUN IS NULL
        THEN V_GUBUN := NULL;
    ELSE 
        V_GUBUN := IN_R_GUBUN;
    END IF;
    
    --IN_R_PRICE값이 NULL일 경우 기본값 설정
    IF IN_R_MIN_PRICE IS NULL
    THEN V_MIN_PRICE := 0;
    ELSE V_MIN_PRICE := IN_R_MIN_PRICE;
    END IF;
    
    IF IN_R_MAX_PRICE IS NULL
    THEN V_MAX_PRICE := 9999999;
    ELSE V_MAX_PRICE := IN_R_MAX_PRICE;
    END IF;
    
    --날짜 지정을 하지 않는다면 2022년 1월 1일 ~ 2999년 12월 31일까지 설정
    IF IN_R_STR_DATE IS NULL
    THEN V_STR_DATE := '20220101';
    ELSE V_STR_DATE := IN_R_STR_DATE;
    END IF;
    
    IF IN_R_END_DATE IS NULL
    THEN V_END_DATE := '29991231';
    ELSE V_END_DATE := IN_R_END_DATE;
    END IF;
        
    OPEN O_CUR FOR
    SELECT *
    FROM RESERVATION_TBL
    WHERE R_ID LIKE '%'|| IN_R_ID ||'%'
      AND U_ID LIKE '%'|| IN_U_ID ||'%'
      AND TM_ID LIKE '%'|| IN_TM_ID ||'%'
      AND R_QTY LIKE '%'|| IN_R_QTY ||'%'
      AND (TO_CHAR(R_DATE, 'YYYYMMDD') >= V_STR_DATE
      AND TO_CHAR(R_DATE, 'YYYYMMDD') <= V_END_DATE)
      AND R_GUBUN LIKE '%'|| V_GUBUN ||'%'
      AND R_PRICE >= TO_NUMBER(V_MIN_PRICE)
      AND R_PRICE <= TO_NUMBER(V_MAX_PRICE)
    ;

    EXCEPTION
    WHEN OTHERS
    THEN O_ERRCODE := SQLCODE;
         O_ERRMSG := SQLERRM;
         ROLLBACK;
         
  END PROC_SEL_RESERVATION_TBL;


    --RESERVATION_TBL UPDATE
  PROCEDURE PROC_UP_RESERVATION_TBL
    (
        IN_R_ID             IN  VARCHAR2,
        IN_U_ID             IN  VARCHAR2,
        IN_TM_ID            IN  VARCHAR2,
        IN_R_QTY            IN  VARCHAR2,
        IN_R_DATE           IN  VARCHAR2,
        IN_R_GUBUN          IN  VARCHAR2,
        O_ERRCODE           OUT VARCHAR2,
        O_ERRMSG            OUT VARCHAR2
    )
     AS
     V_CHECK_U_ID               NUMBER(1);
     V_NEW_TLT_PRICE            NUMBER(7);
     V_ACCEPTABLE               NUMBER(1) :=  PKG_RESERVATION_TBL.CHECK_RAMAINING_SEATS(IN_TM_ID,IN_R_QTY);
     
     EXCEPT_NOT_EXIST_USER      EXCEPTION;
     EXCEPT_NOT_VALID_QTY       EXCEPTION;
     EXCEPT_NOT_ENOUGH_SEATS    EXCEPTION;
  BEGIN
  
    --고객 아이디가 존재하는지 확인
    SELECT COUNT(U_ID)
    INTO V_CHECK_U_ID
    FROM USER_TBL
    WHERE U_ID = IN_U_ID
    ;
    IF V_CHECK_U_ID = 0
    THEN RAISE EXCEPT_NOT_EXIST_USER;
    END IF;
    
    --수량이 유효한지 확인
    IF TO_NUMBER(IN_R_QTY) < 1
    THEN RAISE EXCEPT_NOT_VALID_QTY;
    END IF;
    
    --좌석 남아있는지 확인
    IF V_ACCEPTABLE = 0
    THEN RAISE EXCEPT_NOT_ENOUGH_SEATS;
    END IF;
    
    --총 가격 만들기
    SELECT TO_NUMBER(IN_R_QTY) * TM_PRICE
    INTO V_NEW_TLT_PRICE
    FROM TIMETABLE_TBL
    WHERE TM_ID = IN_TM_ID
    ;
    

    UPDATE RESERVATION_TBL
    SET U_ID = IN_U_ID,
        TM_ID = IN_TM_ID,
        R_QTY = TO_NUMBER(IN_R_QTY),
        R_DATE = TO_DATE(IN_R_DATE,'YYYY-MM-DD'),
        R_GUBUN = IN_R_GUBUN,
        R_PRICE = V_NEW_TLT_PRICE
    WHERE R_ID = IN_R_ID
    ;

    EXCEPTION
    WHEN EXCEPT_NOT_EXIST_USER
    THEN O_ERRCODE := 'ERR001';
         O_ERRMSG := '존재하지 않는 고객 아이디입니다.';
         ROLLBACK;
    WHEN EXCEPT_NOT_VALID_QTY
    THEN O_ERRCODE := 'ERR002';
         O_ERRMSG := '유효하지 않은 수량입니다.';
         ROLLBACK;
    WHEN EXCEPT_NOT_ENOUGH_SEATS
    THEN O_ERRCODE := 'ERR003';
         O_ERRMSG := '좌석이 충분하지 않습니다.';
         ROLLBACK;
    WHEN OTHERS
    THEN O_ERRCODE := SQLCODE;
         O_ERRMSG := SQLERRM;
         ROLLBACK;
         
  END PROC_UP_RESERVATION_TBL;


    --RESERVATION_TBL DELETE
  PROCEDURE PROC_DEL_RESERVATION_TBL
    (
        IN_R_ID             IN  VARCHAR2,
        O_ERRCODE           OUT VARCHAR2,
        O_ERRMSG            OUT VARCHAR2
    )
     AS
  BEGIN
  
  DELETE RESERVATION_TBL
  WHERE R_ID = IN_R_ID
  ;

    EXCEPTION
    WHEN OTHERS
    THEN O_ERRCODE := SQLCODE;
         O_ERRMSG := SQLERRM;
         ROLLBACK;
         
  END PROC_DEL_RESERVATION_TBL;
 
 
    -- 프로시져: 영화별 예약횟수 (예약취소 제외)
    PROCEDURE PROC_RESERVATION_MOVIES
    (
         O_CUR              OUT SYS_REFCURSOR
    )
    AS
    BEGIN
        OPEN O_CUR FOR
        SELECT A.M_NAME, SUM(DECODE(R_ID, NULL, 0, 1)) AS RCNT
        FROM
        (
             SELECT T1.M_ID, T1.M_NAME, T2.TM_ID, T2.TH_ID  
            FROM MOVIE_TBL T1, TIMETABLE_TBL T2
            WHERE T1.M_ID = T2.M_ID(+)
        ) A,
        (
            --> 실제 예약을 진행한 경우만.
            SELECT *
            FROM RESERVATION_TBL
            WHERE R_GUBUN = 'R'
            AND R_ID NOT IN ( SELECT R_CANCELED_ID 
                              FROM RESERVATION_TBL
                              WHERE R_GUBUN = 'C'
                              )
        )B
        WHERE A.TM_ID = B.TM_ID(+)
        GROUP BY A.M_NAME
        ;
    END PROC_RESERVATION_MOVIES;
END PKG_RESERVATION_TBL;

--RESERVATION_TBL 바디 끝


--@@@
--PAYMENT 헤드
create or replace NONEDITIONABLE PACKAGE PKG_PAYMENT AS 

	PROCEDURE PROC_INS_PAYMENT
  (     
        IN_R_ID                 IN VARCHAR2,
        IN_POINT_PAY            IN VARCHAR2,
        IN_CASH_PAY             IN VARCHAR2,
        IN_CARD_PAY             IN VARCHAR2,
        IN_PAY_DC_TYPE          IN VARCHAR2,
        IN_WHERE_A_DC           IN VARCHAR2,
        
        O_ERRCODE       OUT VARCHAR2,
        O_ERRMSG        OUT VARCHAR2
  );

    PROCEDURE PROC_SEL_PAYMENT
    (
        IN_R_ID                 IN      VARCHAR2,
        O_ERRCODE               OUT     VARCHAR2,
        O_ERRMSG                OUT     VARCHAR2,
        O_CUR                   OUT     SYS_REFCURSOR
    );
    
    PROCEDURE PROC_UP_PAYMENT
    (
        IN_R_ID                 IN VARCHAR2,
        IN_PAY_METHOD_GRP       IN VARCHAR2,
        IN_PAY_METHOD           IN VARCHAR2,
        IN_PAY_DC_TYPE_GRP      IN VARCHAR2,
        IN_PAY_PRICE            IN VARCHAR2,
        IN_PAY_DC_TYPE          IN VARCHAR2,
        IN_PAY_DC_PRICE         IN VARCHAR2,
        IN_PAY_SAVE_POINT       IN VARCHAR2,
        
        O_ERRCODE               OUT VARCHAR2,
        O_ERRMSG                OUT VARCHAR2
    );
    
    PROCEDURE PROC_DEL_PAYMENT
    (
        IN_R_ID                 IN VARCHAR2,
        
        O_ERRCODE               OUT VARCHAR2,
        O_ERRMSG                OUT VARCHAR2
    );

END PKG_PAYMENT;

--PAYMENT 헤드 끝

--PAYMENT 바디
create or replace NONEDITIONABLE PACKAGE BODY PKG_PAYMENT AS

  /*
    
    작성일 : 20220328
    최초작성자 : 안선미
    업무설명 : 결제 CRUD
    
    수정사항
    ----------------------------------------------------------------
    수정일             수정자                 수정내용
    ----------------------------------------------------------------
	 20220329           박진교             INSERT 원단위 할인 적용



*/
PROCEDURE PROC_INS_PAYMENT
  (     
        IN_R_ID                 IN VARCHAR2,
        IN_POINT_PAY            IN VARCHAR2,
        IN_CASH_PAY             IN VARCHAR2,
        IN_CARD_PAY             IN VARCHAR2,
        IN_PAY_DC_TYPE          IN VARCHAR2,
        IN_WHERE_A_DC           IN VARCHAR2, -- 원단위 할인 시,'CASH' 현금에 할인할건지, 'CARD'카드에 할인할건지.
        
        O_ERRCODE       OUT VARCHAR2,
        O_ERRMSG        OUT VARCHAR2
  ) 
  AS
  
    V_NEW_IDX           INTEGER;        --IDX
    V_CHK_ID1           CHAR(1);        --ID가 예약 됐는지 확인
    V_CHK_ID2           CHAR(1);        --ID가 중복되는지 확인
    V_U_ID              VARCHAR2(30);
    V_USER_GUBUN        NUMBER(1);      --해당 유저 회원/비회원 구분
    V_DC_KIND           CHAR(1);        --할인 방법 P 퍼센트 할인, A 원단위 할인
    V_PAY_DC_TYPE       CHAR(7);        --할인 코드
    V_DC_RATE           NUMBER(9,2);    --할인율
    V_DCED_PRICE        NUMBER(6);      --할인된 금액
    V_SAVE_RATE         NUMBER(3,2);    --적립률
    V_SAVE_POINT        NUMBER(6);      --적립된 포인트
    V_POINT             NUMBER(8);      --POINT를 사용하지 않으면 NULL대신 0 사용
    V_HAVE_POINT        NUMBER(8);      --고객이 가지고 있는 포인트
    V_CASH_PAY          NUMBER(8);      --고객이 현금으로 지불하겠다 한 금액
    V_CARD_PAY          NUMBER(8);      --고객이 카드로 지불하겠다 한 금액
    
    EXP_C_ERROR              EXCEPTION;
    EXP_C_ERROR2             EXCEPTION;
    EXCEPT_NOT_ENOUGH_POINT  EXCEPTION;
    EXCEPT_IS_NOT_A_DC       EXCEPTION;
  BEGIN

    --IDX
    SELECT NVL(MAX(IDX), 0) + 1
    INTO V_NEW_IDX
    FROM PAYMENT_INFO_TBL;

    --예약테이블에 R_ID가 없으면 에러처리
    SELECT DECODE(MAX(R_ID), NULL, 'X', 'O')
    INTO V_CHK_ID1
    FROM RESERVATION_TBL
    WHERE R_ID = IN_R_ID
    ;
    
    IF V_CHK_ID1 = 'X' 
    THEN
     RAISE EXP_C_ERROR;
    END IF;
    
    --예약테이블에 R_ID가 있고 페이먼트 테이블에 R_ID가 있으면 중복 에러처리
    SELECT DECODE(MAX(R_ID), NULL, 'X', 'O')
    INTO V_CHK_ID2
    FROM PAYMENT_INFO_TBL
    WHERE R_ID = IN_R_ID
    ;
    
    IF V_CHK_ID2 = 'O'
    THEN
     RAISE EXP_C_ERROR2;
    END IF;
    
    --포인트를 사용하지 않으면 NULL 대신 0 입력
    IF IN_POINT_PAY IS NULL
    THEN 
        V_POINT := 0;
    ELSE
        V_POINT := IN_POINT_PAY;
    END IF;
    
    --현금을 사용하지 않으면(NULL) 0 입력
    IF IN_CASH_PAY IS NULL
    THEN
        V_CASH_PAY := 0;
    ELSE
        V_CASH_PAY := IN_CASH_PAY;
    END IF;
    
    --카드를 사용하지 않으면(NULL) 0 입력
    IF IN_CARD_PAY IS NULL
    THEN
        V_CARD_PAY := 0;
    ELSE
        V_CARD_PAY := IN_CARD_PAY;
    END IF;    
    
    --예약한 고객의 회원/비회원 구분값 찾아오기
    SELECT U_ID
    INTO V_U_ID
    FROM RESERVATION_TBL
    WHERE R_ID = IN_R_ID
    ;
    
    SELECT U_GUBUN
    INTO V_USER_GUBUN
    FROM USER_TBL
    WHERE U_ID = V_U_ID
    ;
    
    
     
    --할인을 했을 때, 선택한 할인방법의 할인율 가져오기
    IF IN_PAY_DC_TYPE = 'COM0025' OR IN_PAY_DC_TYPE IS NULL
    THEN
        V_DC_RATE := 0;
        V_PAY_DC_TYPE := 'COM0025';
    ELSE
        SELECT EXTRA_INFO1
        INTO V_DC_KIND
        FROM COMMONS_TBL
        WHERE GRP_ID = 'GRP007'
        AND   COM_ID = IN_PAY_DC_TYPE
        ;
        
        --할인 방법이 퍼센트 단위면...
        IF V_DC_KIND = 'P'
        THEN
            SELECT ROUND(TO_NUMBER(EXTRA_INFO2) / 100, 2)
            INTO V_DC_RATE
            FROM COMMONS_TBL
            WHERE GRP_ID = 'GRP007'
            AND   COM_ID = IN_PAY_DC_TYPE
            ;
        ELSE -- 원단위 할인이면...
            SELECT TO_NUMBER(EXTRA_INFO2)
            INTO V_DC_RATE
            FROM COMMONS_TBL
            WHERE GRP_ID = 'GRP007'
            AND   COM_ID = IN_PAY_DC_TYPE
            ;
        END IF;
        
        V_PAY_DC_TYPE := IN_PAY_DC_TYPE;
    END IF;
    
    --원단위 할인 방식이 아닌데 원단위 할인 받을 방식을 결정한 경우 예외처리
    IF V_DC_KIND != 'A' AND IN_WHERE_A_DC IS NOT NULL
    THEN
        RAISE   EXCEPT_IS_NOT_A_DC;
    END IF;
    
    --비회원이라면
    IF V_USER_GUBUN = 2
    THEN
        --1. 현금 결제
        --1-1. 할인율 계산
        IF V_DC_KIND = 'P'
            THEN
            V_DCED_PRICE := TRUNC(V_CASH_PAY * V_DC_RATE);
        ELSE
            V_DCED_PRICE := V_DC_RATE;
        END IF;
        
        --1-2. 카드 결제에 원단위 할인을 적용한다면, 현금 시엔 할인하지 말아야 함.
        IF IN_WHERE_A_DC = 'CARD'
        THEN V_DCED_PRICE := 0;
        END IF;
        
        INSERT INTO PAYMENT_INFO_TBL(IDX, R_ID, PAY_METHOD_GRP, PAY_METHOD, PAY_DC_TYPE_GRP, PAY_DC_TYPE, PAY_PRICE, PAY_DC_PRICE, PAY_SAVE_POINT)
        VALUES(V_NEW_IDX, IN_R_ID, 'GRP006', 'COM0001', 'GRP007', V_PAY_DC_TYPE, V_CASH_PAY, V_DCED_PRICE, 0)
        ;
        
        V_NEW_IDX := V_NEW_IDX + 1;
        
        --2. 카드 결제
        --2-1. 할인율 계산
        IF V_DC_KIND = 'P'
            THEN
            V_DCED_PRICE := TRUNC(V_CARD_PAY * V_DC_RATE);
        ELSE
            V_DCED_PRICE := V_DC_RATE;
        END IF;
        
        --2-2. 현금 결제에 원단위 할인을 적용한다면, 카드 시엔 할인하지 말아야 함.
        IF IN_WHERE_A_DC = 'CASH'
        THEN V_DCED_PRICE := 0;
        END IF;
        
        INSERT INTO PAYMENT_INFO_TBL(IDX, R_ID, PAY_METHOD_GRP, PAY_METHOD, PAY_DC_TYPE_GRP, PAY_DC_TYPE, PAY_PRICE, PAY_DC_PRICE, PAY_SAVE_POINT)
        VALUES(V_NEW_IDX, IN_R_ID, 'GRP006', 'COM0002', 'GRP007', V_PAY_DC_TYPE, V_CARD_PAY, V_DCED_PRICE, 0)
        ;
        
    --회원이라면    
    ELSE
        --적립률 가져오기
        SELECT ROUND(TO_NUMBER(A.EXTRA_INFO1) / 100 , 2)
        INTO V_SAVE_RATE
        FROM COMMONS_TBL A, USER_TBL B
        WHERE A.GRP_ID = B.U_GRADE_GRP
        AND   A.COM_ID = B.U_GRADE
        AND   B.U_ID = V_U_ID
        ;
    
        --1. 포인트 결제
        --1-1. 사용할 만큼 포인트를 소유중인지 확인
        --1-1-1. 고객의 소유중인 포인트 가져오기
        SELECT U_POINT
        INTO V_HAVE_POINT
        FROM USER_TBL
        WHERE U_ID = V_U_ID
        ;
        
        --1-2. 사용할 만큼의 포인트를 가지고 있지 않다면 예외처리
        IF V_HAVE_POINT < V_POINT
        THEN
        
            RAISE EXCEPT_NOT_ENOUGH_POINT;
        
        END IF;
        
        
        INSERT INTO PAYMENT_INFO_TBL(IDX, R_ID, PAY_METHOD_GRP, PAY_METHOD, PAY_DC_TYPE_GRP, PAY_DC_TYPE, PAY_PRICE, PAY_DC_PRICE, PAY_SAVE_POINT)
        VALUES(V_NEW_IDX, IN_R_ID, 'GRP006', 'COM0003', 'GRP007', V_PAY_DC_TYPE, V_POINT, 0, 0)
        ;
        
        V_NEW_IDX := V_NEW_IDX + 1;
        
        --2. 현금 결제
        --2-1. 할인율 계산
        IF V_DC_KIND = 'P'
            THEN
            V_DCED_PRICE := TRUNC(V_CASH_PAY * V_DC_RATE);
        ELSE
            V_DCED_PRICE := V_DC_RATE;
        END IF;
        
        --2-2. 카드 결제에 원단위 할인을 적용한다면, 현금 시엔 할인하지 말아야 함.
        IF IN_WHERE_A_DC = 'CARD'
        THEN V_DCED_PRICE := 0;
        END IF;
        
        --2-3.적립 포인트 계산
        V_SAVE_POINT := TRUNC((V_CASH_PAY - V_DCED_PRICE) * V_SAVE_RATE);
        
        INSERT INTO PAYMENT_INFO_TBL(IDX, R_ID, PAY_METHOD_GRP, PAY_METHOD, PAY_DC_TYPE_GRP, PAY_DC_TYPE, PAY_PRICE, PAY_DC_PRICE, PAY_SAVE_POINT)
        VALUES(V_NEW_IDX, IN_R_ID, 'GRP006', 'COM0001', 'GRP007', V_PAY_DC_TYPE, V_CASH_PAY, V_DCED_PRICE, V_SAVE_POINT)
        ;
        
        V_NEW_IDX := V_NEW_IDX + 1;
        
        --3. 카드 결제
        --3-1. 할인율 계산
        IF V_DC_KIND = 'P'
            THEN
            V_DCED_PRICE := TRUNC(V_CARD_PAY * V_DC_RATE);
        ELSE
            V_DCED_PRICE := V_DC_RATE;
        END IF;
        
        --3-2. 현금 결제에 원단위 할인을 적용한다면, 카드 시엔 할인하지 말아야 함.
        IF IN_WHERE_A_DC = 'CASH'
        THEN V_DCED_PRICE := 0;
        END IF;
        
        --3-3. 적립 포인트 계산
        V_SAVE_POINT := TRUNC((V_CARD_PAY - V_DCED_PRICE) * V_SAVE_RATE);
        
        INSERT INTO PAYMENT_INFO_TBL(IDX, R_ID, PAY_METHOD_GRP, PAY_METHOD, PAY_DC_TYPE_GRP, PAY_DC_TYPE, PAY_PRICE, PAY_DC_PRICE, PAY_SAVE_POINT)
        VALUES(V_NEW_IDX, IN_R_ID, 'GRP006', 'COM0002', 'GRP007', V_PAY_DC_TYPE, V_CARD_PAY, V_DCED_PRICE, V_SAVE_POINT)
        ;
    
    END IF;
    
    
    EXCEPTION
    WHEN EXCEPT_NOT_ENOUGH_POINT THEN
        O_ERRCODE := 'ERR012';
        O_ERRMSG := '사용할 포인트가 부족합니다.';
        ROLLBACK;
    WHEN EXP_C_ERROR THEN
        O_ERRCODE := 'ERR007';
        O_ERRMSG := '해당 예약이 존재하지 않습니다.';
        ROLLBACK;
    WHEN EXP_C_ERROR2 THEN
        O_ERRCODE := 'ERR008';
        O_ERRMSG := '이미 처리된 결제가 있습니다.';
        ROLLBACK;
    WHEN EXCEPT_IS_NOT_A_DC THEN
        O_ERRCODE := 'ERR012';
        O_ERRMSG := '원단위 할인 결제가 아닐 시 원단위 할인 방식을 선택할 수 없습니다.';
        ROLLBACK;
    WHEN OTHERS THEN
        O_ERRCODE := SQLCODE;
        O_ERRMSG := SQLERRM;
        ROLLBACK;
  END PROC_INS_PAYMENT;


PROCEDURE PROC_SEL_PAYMENT
  (
        IN_R_ID                 IN      VARCHAR2 ,
        O_ERRCODE               OUT     VARCHAR2,
        O_ERRMSG                OUT     VARCHAR2,
        O_CUR                   OUT     SYS_REFCURSOR
   )
   AS
   
        V_CHK_RID               CHAR(7);
        
        EXCEPT_RID_ERR          EXCEPTION;
   
   BEGIN
   
        SELECT DECODE(MAX(R_ID), NULL, 0, 1)
        INTO V_CHK_RID
        FROM PAYMENT_INFO_TBL
        WHERE R_ID = IN_R_ID
        ;
        
        IF V_CHK_RID = 0 THEN
            
            RAISE EXCEPT_RID_ERR;
            
        ELSE
        
            OPEN O_CUR FOR
            SELECT * 
            FROM PAYMENT_INFO_TBL
            WHERE R_ID LIKE '%' || R_ID || '%'
            AND R_ID = IN_R_ID
            ;
        
        END IF;
        
        EXCEPTION
        WHEN EXCEPT_RID_ERR
        THEN O_ERRCODE := 'ERR-004';
             O_ERRMSG := '존재하지 않는 아이디입니다.';
             ROLLBACK;     
        
        WHEN OTHERS
        THEN O_ERRCODE := SQLCODE;
             O_ERRMSG := SQLERRM;
             ROLLBACK;
        
   END PROC_SEL_PAYMENT;
   
       PROCEDURE PROC_UP_PAYMENT
    (
        IN_R_ID                 IN VARCHAR2,
        IN_PAY_METHOD_GRP       IN VARCHAR2,
        IN_PAY_METHOD           IN VARCHAR2,
        IN_PAY_DC_TYPE_GRP      IN VARCHAR2,
        IN_PAY_PRICE            IN VARCHAR2,
        IN_PAY_DC_TYPE          IN VARCHAR2,
        IN_PAY_DC_PRICE         IN VARCHAR2,
        IN_PAY_SAVE_POINT       IN VARCHAR2,
        
        O_ERRCODE               OUT VARCHAR2,
        O_ERRMSG                OUT VARCHAR2
    )
    AS
    
        V_CHK_ID                CHAR(7);
        
        EXP_N_ERROR             EXCEPTION;
        
    BEGIN
    
        SELECT DECODE(MAX(R_ID), NULL, 0, 1)
        INTO V_CHK_ID
        FROM PAYMENT_INFO_TBL
        WHERE R_ID = IN_R_ID
        ;
        
        IF V_CHK_ID = 0 THEN
        
            RAISE EXP_N_ERROR;
            
        ELSE
        
            UPDATE PAYMENT_INFO_TBL
            SET PAY_METHOD_GRP = IN_PAY_METHOD_GRP, PAY_METHOD = IN_PAY_METHOD,
                PAY_DC_TYPE_GRP = IN_PAY_DC_TYPE_GRP, PAY_PRICE = IN_PAY_PRICE, 
                PAY_DC_TYPE = IN_PAY_DC_TYPE, PAY_DC_PRICE = IN_PAY_DC_PRICE,
                PAY_SAVE_POINT = IN_PAY_SAVE_POINT
            WHERE R_ID = IN_R_ID
            ; 
            
        END IF;
    
        EXCEPTION 
        WHEN EXP_N_ERROR 
        THEN O_ERRCODE := 'ERROR010';
             O_ERRMSG := '예약하지 않는 아이디입니다.';
             ROLLBACK;
             
        WHEN OTHERS 
        THEN O_ERRCODE := SQLCODE;
             O_ERRMSG := SQLERRM;
             ROLLBACK;
         
    END PROC_UP_PAYMENT;
    
    PROCEDURE PROC_DEL_PAYMENT
    (
        IN_R_ID                 IN VARCHAR2,
        
        O_ERRCODE               OUT VARCHAR2,
        O_ERRMSG                OUT VARCHAR2
    )
    AS
    
        V_CHK_ID                CHAR(7);
        
        EXP_N_ERROR             EXCEPTION;
    
    BEGIN
    
    SELECT DECODE(MAX(R_ID), NULL, 0, 1)
    INTO V_CHK_ID
    FROM PAYMENT_INFO_TBL
    WHERE R_ID = IN_R_ID
    ;
    
    IF V_CHK_ID = 0 THEN
    
        RAISE EXP_N_ERROR;
        
    ELSE
        
        DELETE FROM PAYMENT_INFO_TBL
        WHERE R_ID = IN_R_ID;
    
    END IF;
    
    EXCEPTION 
    WHEN EXP_N_ERROR 
    THEN O_ERRCODE := 'ERR011';
         O_ERRMSG := '존재하지 않는 아이디입니다.';
         ROLLBACK;
        
    WHEN OTHERS 
    THEN O_ERRCODE := SQLCODE;
         O_ERRMSG := SQLERRM;
         ROLLBACK;
        
    END PROC_DEL_PAYMENT;

    PROCEDURE PROC_SALES_COMPARISON_PER_MOVIE
    (
        IN_M_ID                 IN  VARCHAR2,
        O_CUR                   OUT SYS_REFCURSOR,
        O_ERRCODE               OUT VARCHAR2,
        O_ERRMSG                OUT VARCHAR2
    )
    AS
    

    BEGIN
        
        IF IN_M_ID IS NULL THEN
            
            OPEN O_CUR FOR
            SELECT DENSE_RANK() OVER(ORDER BY NVL(B.SUMPRICE, 0) DESC) AS RNK,
                A.M_ID, A.M_NAME, NVL(B.SUMPRICE, 0)
            FROM MOVIE_TBL A,
            (
                SELECT T3.M_ID, SUM(T1.PAY_PRICE) AS SUMPRICE
                FROM PAYMENT_INFO_TBL T1, RESERVATION_TBL T2, TIMETABLE_TBL T3
                WHERE T1.R_ID = T2.R_ID
                AND T2.TM_ID = T3.TM_ID
                GROUP BY T3.M_ID
            )B
            WHERE A.M_ID = B.M_ID(+)
            ;
            
        END IF;
        
        EXCEPTION 
        WHEN OTHERS
        THEN O_ERRCODE := SQLCODE;
             O_ERRMSG := SQLERRM;
    
    END PROC_SALES_COMPARISON_PER_MOVIE;
        
END PKG_PAYMENT;

--PAYMENT 바디 끝


--@@@
--TIMETABLE_TBL 헤드
create or replace NONEDITIONABLE PACKAGE PKG_TIMETABLE_TBL AS 
		/*
        작성일 : 2022/03/28
        최초 작성사 : 이정화
        수정사항
        -----------------------------------------------------------------------
        수정일                 수정자                 수정내용
        -----------------------------------------------------------------------
    */

    --시간표 INSTERT 시작
    PROCEDURE PROC_INS_TIMETABLE_TBL
    (
        IN_M_ID         IN      VARCHAR2,
        IN_TH_ID        IN      VARCHAR2,
        IN_TM_DATE      IN      DATE,
        IN_TM_STR_TIME  IN      VARCHAR2,
        IN_TM_END_TIME  IN      VARCHAR2,
        IN_TM_PRICE     IN      VARCHAR2,
        O_ERRCODE       OUT     VARCHAR2,
        O_ERRMSG        OUT     VARCHAR2
    );
    --시간표 INSERT 끝
    
    --시간표 SELECT 시작
    PROCEDURE PROC_SEL_TIMETABLE_TBL
    (
        IN_M_ID         IN      VARCHAR2,
        O_ERRCODE       OUT     VARCHAR2,
        O_ERRMSG        OUT     VARCHAR2,
        O_CUR           OUT     SYS_REFCURSOR
    );
    --시간표 SELECT 끝

    --시간표 UPDATE 시작
    PROCEDURE PROC_UP_TIMETABLE_TBL
    (
        IN_TM_ID        IN      VARCHAR2,
        IN_M_ID         IN      VARCHAR2,
        IN_TH_ID        IN      VARCHAR2,
        IN_TM_DATE      IN      DATE,
        IN_TM_STR_TIME  IN      VARCHAR2,
        IN_TM_END_TIME  IN      VARCHAR2,
        IN_TM_PRICE     IN      VARCHAR2,
        O_ERRCODE       OUT     VARCHAR2,
        O_ERRMSG        OUT     VARCHAR2
    );
    --시간표 UPDATE 시작
    
    --시간표 DELETE 시작
    PROCEDURE PROC_DEL_TIMETABLE_TBL
    (
        IN_TM_ID        IN      VARCHAR2,
        O_ERRCODE       OUT     VARCHAR2,
        O_ERRMSG        OUT     VARCHAR2
    );
    --시간표 DELETE 끝

END PKG_TIMETABLE_TBL;

--TIMETABLE_TBL 헤드 끝

--TIMETABLE_TBL 바디
create or replace NONEDITIONABLE PACKAGE BODY PKG_TIMETABLE_TBL AS

  /*
        작성일 : 2022/03/28
        최초 작성사 : 이정화
        수정사항
        -----------------------------------------------------------------------
        수정일                 수정자                 수정내용
        -----------------------------------------------------------------------
  */

  --시간표 INSTERT 시작
  PROCEDURE PROC_INS_TIMETABLE_TBL
    (
        IN_M_ID         IN      VARCHAR2,
        IN_TH_ID        IN      VARCHAR2,
        IN_TM_DATE      IN      DATE,
        IN_TM_STR_TIME  IN      VARCHAR2,
        IN_TM_END_TIME  IN      VARCHAR2,
        IN_TM_PRICE     IN      VARCHAR2,
        O_ERRCODE       OUT     VARCHAR2,
        O_ERRMSG        OUT     VARCHAR2
    ) 
  AS
  
        V_TM_ID         VARCHAR2(6);
  
  BEGIN
        
        SELECT 'TM' || TO_CHAR(TO_NUMBER(NVL(SUBSTR(MAX(TM_ID), 3, 4), 0)) + 1, 'FM0000')
        INTO V_TM_ID
        FROM TIMETABLE_TBL
        ;
        
        INSERT INTO TIMETABLE_TBL(TM_ID, M_ID, TH_ID, TM_DATE, TM_STR_TIME, TM_END_TIME, TM_PRICE)
        VALUES(V_TM_ID, IN_M_ID, IN_TH_ID, IN_TM_DATE, IN_TM_STR_TIME, IN_TM_END_TIME, IN_TM_PRICE)
        ;
        
        EXCEPTION
        WHEN OTHERS
        THEN O_ERRCODE := SQLCODE;
             O_ERRMSG := SQLERRM;
             ROLLBACK;
        
  END PROC_INS_TIMETABLE_TBL;
  --시간표 INSERT 끝
  
  --시간표 SELECT 시작
  PROCEDURE PROC_SEL_TIMETABLE_TBL
    (
        IN_M_ID         IN      VARCHAR2,
        IN_TH_ID        IN      VARCHAR2,
        IN_TM_DATE      IN      DATE,
        IN_TM_PRICE     IN      NUMBER,
        O_ERRCODE       OUT     VARCHAR2,
        O_ERRMSG        OUT     VARCHAR2,
        O_CUR          OUT     SYS_REFCURSOR
    )
  AS
        
        V_CHK_MID               NUMBER(1);
        
        EXCEPT_MID_ERR          EXCEPTION;
  
  BEGIN
        
        --M_ID (영화 아이디)로 검색 할 경우
        SELECT DECODE(MAX(M_ID), NULL, 0, 1)
        INTO V_CHK_MID
        FROM TIMETABLE_TBL
        WHERE M_ID = IN_M_ID
        ;
        
        IF V_CHK_MID = 0 THEN
        
            RAISE EXCEPT_MID_ERR;
        
        ELSE
        
            OPEN O_CUR FOR
            SELECT B.TM_ID, B.M_ID, A.M_NAME, B.TH_ID, B.TM_DATE, B.TM_STR_TIME, B.TM_END_TIME, B.TM_PRICE
            FROM MOVIE_TBL A,
            (
                SELECT TM_ID, M_ID, TH_ID, TM_DATE, TM_STR_TIME, TM_END_TIME, TM_PRICE
                FROM TIMETABLE_TBL
                WHERE M_ID LIKE '%' || IN_M_ID || '%'
                AND TH_ID LIKE '%' || IN_TH_ID || '%'
                AND TM_DATE LIKE '%' || IN_TM_DATE || '%'
                AND TM_PRICE LIKE '%' || IN_TM_PRICE || '%'
            )B
            WHERE A.M_ID = B.M_ID
            ;
            
        END IF;
        
        
        EXCEPTION
        WHEN EXCEPT_MID_ERR
        THEN O_ERRCODE := 'ERR-101';
             O_ERRMSG := '존재하지 않는 값 입니다.';
    
        WHEN OTHERS
        THEN O_ERRCODE := SQLCODE;
             O_ERRMSG := SQLERRM;
        
  END PROC_SEL_TIMETABLE_TBL;
  --시간표 SELECT 끝

  --시간표 UPDATE 시작
  PROCEDURE PROC_UP_TIMETABLE_TBL
    (
        IN_TM_ID        IN      VARCHAR2,
        IN_M_ID         IN      VARCHAR2,
        IN_TH_ID        IN      VARCHAR2,
        IN_TM_DATE      IN      DATE,
        IN_TM_STR_TIME  IN      VARCHAR2,
        IN_TM_END_TIME  IN      VARCHAR2,
        IN_TM_PRICE     IN      VARCHAR2,
        O_ERRCODE       OUT     VARCHAR2,
        O_ERRMSG        OUT     VARCHAR2
    ) 
  AS
  
       V_CHK_TMID               NUMBER(1);
       V_CHK_MID                NUMBER(1);
       
       EXCEPT_TMID_ERR          EXCEPTION;
       EXCEPT_MID_ERR           EXCEPTION;
    
  BEGIN
        
        SELECT DECODE(MAX(TM_ID), NULL, 0, 1)
        INTO V_CHK_TMID
        FROM TIMETABLE_TBL
        WHERE TM_ID = IN_TM_ID
        ;
        
        SELECT DECODE(MAX(M_ID), NULL, 0, 1)
        INTO V_CHK_MID
        FROM TIMETABLE_TBL
        WHERE M_ID = IN_M_ID
        ;
        
        IF V_CHK_TMID = 0 THEN
        
            RAISE EXCEPT_TMID_ERR;
            
        ELSIF V_CHK_MID = 0 THEN
            
            RAISE EXCEPT_MID_ERR;
        
        ELSE
            
            UPDATE TIMETABLE_TBL
            SET M_ID  = IN_M_ID, TH_ID = IN_TH_ID,
                TM_DATE = IN_TM_DATE, TM_STR_TIME = IN_TM_STR_TIME,
                TM_END_TIME = IN_TM_END_TIME, TM_PRICE = IN_TM_PRICE
            WHERE TM_ID = IN_TM_ID
            ;
        
        END IF;
        
        EXCEPTION
        WHEN EXCEPT_TMID_ERR
        THEN O_ERRCODE := 'ERR-102';
             O_ERRMSG := '존재하지 않는 TM_ID 값 입니다.';
             ROLLBACK;
            
        WHEN EXCEPT_MID_ERR
        THEN O_ERRCODE := 'ERR-103';
             O_ERRMSG := '존재하지 않는 M_ID 값 입니다.';
             ROLLBACK;
        
        WHEN OTHERS
        THEN O_ERRCODE := SQLCODE;
             O_ERRMSG := SQLERRM;
             ROLLBACK;
        
        
  END PROC_UP_TIMETABLE_TBL;
  --시간표 UPDATE 끝

  --시간표 DELETE 시작
  PROCEDURE PROC_DEL_TIMETABLE_TBL
    (
        IN_TM_ID        IN      VARCHAR2,
        O_ERRCODE       OUT     VARCHAR2,
        O_ERRMSG        OUT     VARCHAR2
    ) 
  AS
  
        V_CHK_TMID              NUMBER(1);
        
        EXCEPT_TMID_ERR         EXCEPTION;
  
  BEGIN
        
        SELECT DECODE(MAX(TM_ID), NULL, 0, 1)
        INTO V_CHK_TMID
        FROM TIMETABLE_TBL
        WHERE TM_ID = IN_TM_ID
        ;
        
        IF V_CHK_TMID = 0 THEN
            
            RAISE EXCEPT_TMID_ERR;
            
        ELSE
        
            DELETE FROM TIMETABLE_TBL
            WHERE TM_ID = IN_TM_ID
            ;
        
        END IF;
        
        EXCEPTION
        WHEN EXCEPT_TMID_ERR
        THEN O_ERRCODE := 'ERR-106';
             O_ERRMSG := '존재하지 않는 아이디 입니다.';
             ROLLBACK;
        
        WHEN OTHERS
        THEN O_ERRCODE := SQLCODE;
             O_ERRMSG := SQLERRM;
             ROLLBACK;
        
  END PROC_DEL_TIMETABLE_TBL;
  --시간표 DELETE 끝

END PKG_TIMETABLE_TBL;

--TIMETABLE_TBL 바디 끝


--@@@
--POINT_TBL 헤드
create or replace NONEDITIONABLE PACKAGE PKG_POINT_TBL AS 

/*
         작성일 : 20220328
         최초작성자: 전인호
         업무설명: POINT_TBL에 대한 CRUD 작성
            -- 1. RESERVATION_TBL에서 예약을하고, 그 결과로 PAYMENT_INFO_TBL에서 데이터가 쌓이고, PAYMENT_INFO_TBL에서 쌓인 포인트가 POINT_TBL에 적립된다.
            -- 2. RESERVATION_TBL에서 예약을 취소하면, POINT_TBL에 적립(P)된 포인트가 취소(C) 된다.
            -- 3. POINT_TBL에서 POINT를 적립, 사용, 취소 할 수 있다. 
 
         수정 사항
         ------------------------------------------------------------
         수정일             수정자                  수정내용
         --------------------------------------------------------------
*/


    -- POINT_TBL의  INSERT
   PROCEDURE PROC_INS_POINT_TBL
   (
     IN_R_ID                IN              VARCHAR2, -- 예약 아이디
     IN_P_DATE              IN              VARCHAR2, -- 날짜
     IN_P_AMOUNT            IN              VARCHAR2, -- 포인트 양      
     IN_P_GUBUN             IN              VARCHAR2, -- P 적립 / M 사용 / C 취소
     O_ERRCODE              OUT             VARCHAR2,
     O_ERRMSG               OUT             VARCHAR2         
   );
   
   
   -- POINT_TBL의 DELETE
   PROCEDURE PROC_DEL_POINT_TBL
   (
     IN_P_ID                IN              VARCHAR2,
     O_ERRCODE              OUT             VARCHAR2,
     O_ERRMSG               OUT             VARCHAR2      
   );
   
   
   -- POINT_TBL의 UPDATE
   --> 특별한 경우가 아니라면, POINT_TBL의 UPDATE를 사용하지 않는다. 
   
   PROCEDURE PROC_UP_POINT_TBL
   (
     IN_P_ID                IN              VARCHAR2,
     IN_P_DATE              IN              VARCHAR2,
     IN_P_AMOUNT            IN              VARCHAR2,
     O_ERRCODE              OUT             VARCHAR2,
     O_ERRMSG               OUT             VARCHAR2 
   );
   
   

   -- POINT_TBL의 SELETE
   PROCEDURE PROC_SEL_POINT_TBL
   (
     IN_P_ID                IN              VARCHAR2,
     IN_R_ID                IN              VARCHAR2,
     IN_P_DATE              IN              VARCHAR2,
     IN_P_AMOUNT            IN              VARCHAR2,
     IN_P_GUBUN             IN              VARCHAR2,
     O_ERRCODE              OUT             VARCHAR2,
     O_ERRMSG               OUT             VARCHAR2,
     O_CUR                  OUT             SYS_REFCURSOR     
   );
   

END PKG_POINT_TBL;

--POINT_TBL 헤드 끝

--POINT_TBL 바디
create or replace NONEDITIONABLE PACKAGE BODY PKG_POINT_TBL AS
  
   -- POINT_TBL의 INSERT
  PROCEDURE PROC_INS_POINT_TBL
   (
     IN_R_ID                IN              VARCHAR2, -- 예약 아이디
     IN_P_DATE              IN              VARCHAR2, -- 날짜
     IN_P_AMOUNT            IN              VARCHAR2, -- 포인트 양 
     IN_P_GUBUN             IN              VARCHAR2, -- P 적립 / M 사용 / C 취소
     O_ERRCODE              OUT             VARCHAR2,
     O_ERRMSG               OUT             VARCHAR2    
   ) 
   AS
   
        V_NEW_ID                 CHAR(5);
        V_CHK_NULL               NUMBER(1);
        V_PAYPOINT               NUMBER(8);
        V_MEMBERSHIP_CHK         NUMBER(1);
        V_USER_POINT             NUMBER(8);
        V_CANCEL_CHK             NUMBER(1);
      
        NO_DATA_EXCEPT           EXCEPTION;
        NO_DATA2_EXCEPT          EXCEPTION;
        NOT_MATCHED_EXCEPT       EXCEPTION;
        NO_MEMBERSHIP_EXCEPT     EXCEPTION;
        NO_POINT_EXCEPT          EXCEPTION;
  BEGIN
  

        
      --> (공통1) INSERT 시 POINT_TBL의 P_ID 자동생성.
       SELECT 'P' || TO_CHAR(TO_NUMBER(SUBSTR(NVL(MAX(P_ID),'P0000'),2,4)) + 1, 'FM0000')  
       INTO V_NEW_ID
       FROM POINT_TBL
       ; 
       --> (공통2)INSERT 시 INSERT 하고자 하는 R_ID(예약번호)가 RESERVATION_TBL에 존재하는 데이터인지 확인.
       SELECT DECODE(MAX(R_ID), NULL , 0 , 1)
       INTO V_CHK_NULL
       FROM RESERVATION_TBL
       WHERE R_ID = IN_R_ID
       ;
       
        
        --  상황 1
        --> INSERT 시 POINT를 P(적립)하는 경우 일때, 
       --> 해당 R_ID의 USER가 회원일때만 POINT 등록.
       IF IN_P_GUBUN = 'P' THEN
                    
                   --> INSERT(포인트적립) 시 P_AMOUNT은 얼마나 적립될것인가 --> PAYMENT_INFO_TBL에 쌓인 포인트참고.
                   SELECT NVL(MAX(T3.PAY_SAVE_POINT), 0 )
                   INTO V_PAYPOINT
                   FROM POINT_TBL T1, RESERVATION_TBL T2, PAYMENT_INFO_TBL T3
                   WHERE T1.R_ID = T2.R_ID
                   AND T2.R_ID = T3.R_ID AND T1.R_ID = T3.R_ID
                   AND T3.R_ID = IN_R_ID
                   ; 
                                
                    
                    
                   SELECT T3.U_GUBUN 
                   INTO V_MEMBERSHIP_CHK
                   FROM POINT_TBL T1, RESERVATION_TBL T2, USER_TBL T3 
                   WHERE T1.R_ID = T2.R_ID AND T2.U_ID = T3.U_ID
                   AND T1.R_ID = IN_R_ID
                   ;
                   --> INSERT하려는 R_ID의 정보가 PAYMENT_INFO_TBL에 있는지 확인
                   IF V_CHK_NULL != 0 THEN
                       -- 만약 이 USER가 회원이라면? --> 비로소 POINT INSERT(적립)가능 
                       IF V_MEMBERSHIP_CHK = 1 THEN
                        -- PAYMENT_INFO_TBL에 쌓인 포인트와 입력한 포인트가 동일 할때, 적립 INSERT 실행.
                         IF V_PAYPOINT = IN_P_AMOUNT THEN 
                           INSERT INTO POINT_TBL( P_ID, R_ID, P_DATE, P_AMOUNT, P_GUBUN)
                           VALUES( V_NEW_ID, IN_R_ID, IN_P_DATE, IN_P_AMOUNT , IN_P_GUBUN)
                           ;
                          END IF;
                       ELSE 
                           RAISE NO_MEMBERSHIP_EXCEPT;
                       END IF;
                   ELSE
                       RAISE NO_DATA_EXCEPT;
                   END IF;   
                   -->POINT에 INSERT가 되고, 그 GUBUN 값이 P(적립)이라면,  P_AMOUNT(포인트 양)가 USER_TBL의 U_POINT에 쌓인다. 
                   UPDATE USER_TBL
                   SET U_POINT = U_POINT + IN_P_AMOUNT
                   WHERE U_ID IN (
                                 SELECT T2.U_ID
                                 FROM POINT_TBL T1, RESERVATION_TBL T2
                                 WHERE T1.R_ID = T2.R_ID
                                 AND T1.R_ID = IN_R_ID                     
                                 )
                                 ;
        ELSE
                     
      -- 상황 2 
      --> INSERT 시, 해당 P_GUBUN이 M(사용) 일때,
      --> 1.USER_TBL에서 해당 금액만큼 감액해야됨.
      --> 2.USER_TBL에 해당 R_ID에 해당하는 유저가 사용하려는 포인트를 가지고 있어야함.  
      --> 3.PAYMENT_INFO_TBL의 PAY_PRICE(결제금액)에서 해당 포인트만큼 감액해야됨. 
      
       
       --> 만약 P_GUBUN이 M(사용)이라면
        IF IN_P_GUBUN = 'M' THEN               
            
               --> 해당 USER가 사용하려고 하는 포인트만큼, 충분한 포인트를 가지고 있는지 확인.             
               SELECT T3.U_POINT
               INTO V_USER_POINT
               FROM POINT_TBL T1, RESERVATION_TBL T2, USER_TBL T3
               WHERE T1.R_ID = T2.R_ID AND T2.U_ID = T3.U_ID
               AND T1.R_ID = IN_R_ID
               ; 
            
            IF V_CHK_NULL != 0 THEN
               --> 만약 USER의 POINT가 충분하다면 INSERT 실시
               IF V_USER_POINT >= IN_P_AMOUNT THEN
                  INSERT INTO POINT_TBL( P_ID, R_ID, P_DATE, P_AMOUNT, P_GUBUN)
                  VALUES( V_NEW_ID, IN_R_ID, IN_P_DATE, IN_P_AMOUNT , IN_P_GUBUN)
                  ;
                  --> INSERT 후에, 바로 해당 포인트만큼 USER_TBL에서 감소
                   UPDATE USER_TBL
                   SET U_POINT = U_POINT - IN_P_AMOUNT
                   WHERE U_ID IN (
                                 SELECT T2.U_ID
                                 FROM POINT_TBL T1, RESERVATION_TBL T2
                                 WHERE T1.R_ID = T2.R_ID
                                 AND T1.R_ID = IN_R_ID                     
                                 )
                                 ; 
                  --> INSERT 후에, 바로 해당 포인트만큼 PAYMENT_TBL의 PAY_PRICE(결제금액)에서 감소
                       UPDATE PAYMENT_INFO_TBL
                       SET PAY_PRICE  = PAY_PRICE - IN_P_AMOUNT 
                       WHERE R_ID = IN_R_ID
                       ;
               ELSE   
                  -- 포인트가 부족하다는 메시지를 보여준다.
                  RAISE NO_POINT_EXCEPT;
               END IF;
            ELSE
               --IF V_CHK_NULL에 대한 예외.
               RAISE NO_DATA_EXCEPT;
            END IF;
        
        ELSE 
        -- 상황 3
        -- IN_P_GUBUN = 'C' 일 경우를 적는다. 
        -- P_GUBUN이 취소일 경우,
        -- 1. 해당 R_ID가 RESERVATION_TBL에서 R_GUBUN = C가 되어 있어야한다. --> 영화 예약이 취소되고나서, 포인트 취소
        -- 2. 해당 R_ID를 가진 U_ID의 포인트가 다시 감소되어야한다.     
                  
                  --> RESERVATION_TBL에 해당 R_ID가 R_GUBUN = C가 되어있는지 확인.
                  SELECT DECODE(MAX(R_ID), NULL, 0 , 1)
                  INTO V_CANCEL_CHK
                  FROM RESERVATION_TBL
                  WHERE R_ID = IN_R_ID 
                  AND R_GUBUN = 'C'
                  ;
                  --> 예약취소가 되어있다면, POINT_TBL에서 POINT 취소 INSERT 실행.
                  IF V_CANCEL_CHK != 0 THEN
                          INSERT INTO POINT_TBL( P_ID, R_ID, P_DATE, P_AMOUNT, P_GUBUN)
                          VALUES( V_NEW_ID, IN_R_ID, IN_P_DATE, IN_P_AMOUNT , IN_P_GUBUN)
                          ;
                          --INSERT 후에, 바로 USER 포인트 감소.
                          UPDATE USER_TBL
                          SET U_POINT = U_POINT - IN_P_AMOUNT
                          WHERE U_ID IN  (
                                         SELECT T2.U_ID
                                         FROM POINT_TBL T1, RESERVATION_TBL T2
                                         WHERE T1.R_ID = T2.R_ID
                                         AND T1.R_ID = IN_R_ID                     
                                         )
                                         ;
                  ELSE
                      --> RESERVATION_TBL에 취소된 예약이 없다.
                      RAISE NO_DATA2_EXCEPT;
                  END IF;     
        END IF;
        END IF;
    
                           
      
      
      
      
       EXCEPTION
       WHEN NOT_MATCHED_EXCEPT THEN
         O_ERRCODE := '109';
         O_ERRMSG := '입력하려는 포인트에 오류가 있습니다.';
         ROLLBACK;
       WHEN NO_DATA_EXCEPT THEN
         O_ERRCODE := '110';
         O_ERRMSG := '해당 예약 정보가 존재하지 않습니다.';
         ROLLBACK;
       WHEN NO_MEMBERSHIP_EXCEPT THEN
         O_ERRCODE := '111';
         O_ERRMSG := '해당 고객은 비회원입니다.';
         ROLLBACK;       
       WHEN NO_POINT_EXCEPT THEN
         O_ERRCODE := '112';
         O_ERRMSG := '해당 고객의 포인트가 부족하여, 사용할 수 없습니다.';
         ROLLBACK;             
       WHEN NO_DATA2_EXCEPT THEN
         O_ERRCODE := '113';
         O_ERRMSG := '해당 예약은 취소가 되지않아, 포인트를 취소할 수 없습니다.';
         ROLLBACK;         
       WHEN OTHERS THEN
        O_ERRCODE := SQLCODE;
        O_ERRMSG := SQLERRM;
        ROLLBACK;
    
  END PROC_INS_POINT_TBL;
  
  
   -- POINT_TBL의 DELETE  
     PROCEDURE PROC_DEL_POINT_TBL
   (
     IN_P_ID                IN              VARCHAR2,
     O_ERRCODE              OUT             VARCHAR2,
     O_ERRMSG               OUT             VARCHAR2      
   )
   AS
         V_CHK_NULL               NUMBER(1);
         
         
         NO_DATA_EXCEPT           EXCEPTION;
   BEGIN
            
      --> 데이터를 삭제하는건, POINT변화와 무방하다고 가정.
      --> POINT를 변화시킬려면 P_GUBUN이 변경되어야한다. 
      
   
         --삭제하려고 입력한 P_ID가 존재하는가? 
           SELECT DECODE(MAX(P_ID), NULL, 0 , 1)
           INTO V_CHK_NULL
           FROM POINT_TBL
           WHERE P_ID = IN_P_ID
           ;
       
       
        --삭제하려는 조건 P_ID가 존재하는 데이터라면 --> 삭제
         IF V_CHK_NULL != 0 THEN
             DELETE FROM POINT_TBL
             WHERE P_ID = IN_P_ID
             ;
         ELSE
             RAISE NO_DATA_EXCEPT;
         END IF;
       
       EXCEPTION
       WHEN NO_DATA_EXCEPT THEN
        O_ERRCODE := '1111';
        O_ERRMSG := '삭제하려는 정보가 존재하지 않습니다';
        ROLLBACK;            
       WHEN OTHERS THEN
        O_ERRCODE := SQLCODE;
        O_ERRMSG := SQLERRM;
        ROLLBACK;   
   END PROC_DEL_POINT_TBL;
   
   
   
      -- POINT_TBL의 UPDATE
   PROCEDURE PROC_UP_POINT_TBL
   (
     IN_P_ID                IN              VARCHAR2,
     IN_P_DATE              IN              VARCHAR2,
     IN_P_AMOUNT            IN              VARCHAR2,
     O_ERRCODE              OUT             VARCHAR2,
     O_ERRMSG               OUT             VARCHAR2 
   )
   AS
   
         V_CHK_NULL               NUMBER(1);
  
         NO_DATA_EXCEPT           EXCEPTION;
   
   BEGIN
   
            --> P_GUBUN과, R_ID는  UPDATE 하지 못하도록 설정.
            --> POINT_TBL의 변경된 P_AMOUNT에 따라서, U_POINT가 변경되어야한다.
            
           --1. UPDATE하려는 P_ID가 존재하는가?
           SELECT DECODE(MAX(P_ID), NULL, 0 , 1)
           INTO V_CHK_NULL
           FROM POINT_TBL
           WHERE P_ID = IN_P_ID
           ;
           

           
            --P_AMOUNT가 변경되었다면 PAYMENT_INFO_TBL의   PAY_SAVE_POINT도 같은 금액으로 변경
            --> USER 테이블에 변경된 만큼 적용.
                       
           --> UPDATE하려는 P_ID가 존재하는 데이터인지 체크. --> 존재한다면 UPDATE 실행
           IF V_CHK_NULL != 0 THEN
                   UPDATE POINT_TBL
                   SET P_DATE = TO_DATE(IN_P_DATE,'YYYY-MM-DD'),
                       P_AMOUNT = TO_NUMBER(IN_P_AMOUNT)
                   WHERE P_ID = IN_P_ID
                   ;
                   
                  --변경된 금액만큼 PAYMENT_INFO_TBL의 금액을 변경.
                  /*
                   UPDATE PAYMENT_INFO_TBL
                   SET PAY_SAVE_POINT = IN_P_AMOUNT
                   WHERE R_ID =  ( SELECT T3.R_ID
                                   FROM POINT_TBL T1, RESERVATION_TBL T2, PAYMENT_INFO_TBL T3
                                   WHERE T1.R_ID = T2.R_ID
                                   AND T2.R_ID = T3.R_ID
                                   AND P_ID = IN_P_ID    
                                   )
                                   ;
                    */
                  --USER_TBL에도, 변경된 금액만큼 U_POINT 변경.
                  /*
                  UPDATE USER_TBL -- 로직 에러!
                  SET U_POINT = IN_P_AMOUNT
                  WHERE U_ID IN ( SELECT T3.U_ID
                                   FROM POINT_TBL T1, RESERVATION_TBL T2, USER_TBL T3
                                   WHERE T1.R_ID = T2.R_ID AND T2.U_ID = T3.U_ID 
                                   AND P_ID = IN_P_ID
                                 )
                                 ;
                   */
           ELSE
                RAISE NO_DATA_EXCEPT;
           END IF; 
       EXCEPTION
       WHEN NO_DATA_EXCEPT THEN
        O_ERRCODE := '200';
        O_ERRMSG := '수정하고자 하는 데이터를 잘못 입력하였습니다. ';
        ROLLBACK;             
       WHEN OTHERS THEN
        O_ERRCODE := SQLCODE;
        O_ERRMSG := SQLERRM;
        ROLLBACK;            
           
   
   END PROC_UP_POINT_TBL;
   
   
   
   -- POINT_TBL의 SELETE
   PROCEDURE PROC_SEL_POINT_TBL
   (
     IN_P_ID                IN              VARCHAR2,
     IN_R_ID                IN              VARCHAR2,
     IN_P_DATE              IN              VARCHAR2,
     IN_P_AMOUNT            IN              VARCHAR2,
     IN_P_GUBUN             IN              VARCHAR2,
     O_ERRCODE              OUT             VARCHAR2,
     O_ERRMSG               OUT             VARCHAR2,
     O_CUR                  OUT             SYS_REFCURSOR
   )
   AS
        
        V_CHK_NULL                      NUMBER(1);
        
        NO_DATA_EXCEPT                  EXCEPTION;
   
   BEGIN
        
       --R_ID를 유효하게 입력하였는지 --> RESERVATION_TBL에 존재하는 R_ID인지 확인.
       SELECT DECODE(MAX(R_ID), NULL, 0, 1 )
       INTO V_CHK_NULL
       FROM RESERVATION_TBL 
       WHERE R_ID LIKE '%' || IN_R_ID  || '%'
       ;
       
       --> R_ID가 유효하다면, 조회실행
       IF V_CHK_NULL != 0 THEN
           OPEN O_CUR FOR
           SELECT T3.U_ID, T3.U_POINT, T1.P_ID, T1.R_ID, T1.P_DATE, T1.P_AMOUNT, T1.P_GUBUN
           FROM POINT_TBL T1, RESERVATION_TBL T2, USER_TBL T3
           WHERE T1.R_ID = T2.R_ID 
           AND T2.U_ID = T3.U_ID
           AND T1.R_ID LIKE '%' || IN_R_ID  || '%'
           AND TO_CHAR(T1.P_DATE,'YYYYMMDD') LIKE '%' || IN_P_DATE || '%'
           AND T1.P_AMOUNT LIKE '%' || IN_P_AMOUNT || '%'
           AND T1.P_GUBUN LIKE '%' || IN_P_GUBUN || '%'
           ;
        ELSE
            RAISE NO_DATA_EXCEPT;
        END IF;
   
       EXCEPTION
        WHEN NO_DATA_EXCEPT THEN
            O_ERRCODE := '300';
            O_ERRMSG := '입력하신 예약 정보가 존재하지 않습니다.';
            ROLLBACK;        
       WHEN OTHERS THEN
            O_ERRCODE := SQLCODE;
            O_ERRMSG := SQLERRM;
            ROLLBACK;          
   END PROC_SEL_POINT_TBL;
   
   
   

END PKG_POINT_TBL;

--POINT_TBL 바디 끝
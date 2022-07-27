--헤드
create or replace NONEDITIONABLE PACKAGE PKG_BUSINESS AS 

    --영화별 매출 비교
    PROCEDURE PROC_SALES_COMPARISON_PER_MOVIE
    (
        O_CUR                   OUT     SYS_REFCURSOR,
        O_ERRCODE               OUT     VARCHAR2,
        O_ERRMSG                OUT     VARCHAR2
    );
    
    --월별 지점별 매출액
    PROCEDURE PROC_SEL_MONTHLY_BRANCHES_SALES
    (
        O_CUR                   OUT     SYS_REFCURSOR
    );

    --영화별 예약 횟수 (예약 취소는 제외)
    PROCEDURE PROC_RESERVATION_MOVIES
    (
         O_CUR                  OUT     SYS_REFCURSOR
    );
    
    --각 할인 별 사용자 많은 순위
    PROCEDURE PROC_BEST_DC
    (
        IN_PCNT_RNK             IN      VARCHAR2,
        O_CUR                   OUT     SYS_REFCURSOR,
        O_ERRCODE               OUT     VARCHAR2,
        O_ERRMSG                OUT     VARCHAR2
    );
    
    --사용된 할인 중 원하는 할인 이름 검색해서 찾기
    PROCEDURE PROC_SEARCH_DC
    (
        IN_COM_NAME             IN      VARCHAR2,
        O_CUR                   OUT     SYS_REFCURSOR,
        O_ERRCODE               OUT     VARCHAR2,
        O_ERRMSG                OUT     VARCHAR2
    );
    
    --영화별 장르 조회
    PROCEDURE PROC_SEL_MOVIE_WITH_GENRE
    (
        O_CUR                   OUT     SYS_REFCURSOR,
        O_ERRCODE               OUT     VARCHAR2,
        O_ERRMSG                OUT     VARCHAR2
    );

END PKG_BUSINESS;

--헤드 끝

--바디
create or replace NONEDITIONABLE PACKAGE BODY PKG_BUSINESS AS
  
  --영화별 매출 비교
  PROCEDURE PROC_SALES_COMPARISON_PER_MOVIE
    (
        O_CUR                   OUT     SYS_REFCURSOR,
        O_ERRCODE               OUT     VARCHAR2,
        O_ERRMSG                OUT     VARCHAR2
    )
  AS
    
  BEGIN
        
            OPEN O_CUR FOR
            SELECT DENSE_RANK() OVER(ORDER BY NVL(B.SUMPRICE, 0) DESC) AS RNK,
                A.M_ID, A.M_NAME, NVL(B.SUMPRICE, 0) AS SALES
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

        EXCEPTION 
        WHEN OTHERS
        THEN O_ERRCODE := SQLCODE;
             O_ERRMSG := SQLERRM;
    
  END PROC_SALES_COMPARISON_PER_MOVIE;

  --월별 지점별 매출액
  PROCEDURE PROC_SEL_MONTHLY_BRANCHES_SALES
    (
        O_CUR                   OUT     SYS_REFCURSOR
    ) 
  AS 
  
  BEGIN    
    
         OPEN O_CUR FOR
         SELECT  B_NAME
            ,NVL(SUM(DECODE(TO_CHAR(R_DATE,'MM'),'01',실매출액)),0)  "01월"
            ,NVL(SUM(DECODE(TO_CHAR(R_DATE,'MM'),'02',실매출액)),0)  "02월"
            ,NVL(SUM(DECODE(TO_CHAR(R_DATE,'MM'),'03',실매출액)),0)  "03월"
            ,NVL(SUM(DECODE(TO_CHAR(R_DATE,'MM'),'04',실매출액)),0)  "04월"
            ,NVL(SUM(DECODE(TO_CHAR(R_DATE,'MM'),'05',실매출액)),0)  "05월"
            ,NVL(SUM(DECODE(TO_CHAR(R_DATE,'MM'),'06',실매출액)),0)  "06월"
            ,NVL(SUM(DECODE(TO_CHAR(R_DATE,'MM'),'07',실매출액)),0)  "07월"
            ,NVL(SUM(DECODE(TO_CHAR(R_DATE,'MM'),'08',실매출액)),0)  "08월"
            ,NVL(SUM(DECODE(TO_CHAR(R_DATE,'MM'),'09',실매출액)),0)  "09월"
            ,NVL(SUM(DECODE(TO_CHAR(R_DATE,'MM'),'10',실매출액)),0)  "10월"
            ,NVL(SUM(DECODE(TO_CHAR(R_DATE,'MM'),'11',실매출액)),0)  "11월"
            ,NVL(SUM(DECODE(TO_CHAR(R_DATE,'MM'),'12',실매출액)),0)  "12월"
        FROM
        (
            SELECT AA.R_ID, AA.TM_ID, AA.R_DATE, AA.실매출액, BB.B_ID, BB.B_NAME 
            FROM
            (
                --> 예약별 실 매출액
                SELECT A.R_ID, A.U_ID, A.TM_ID, A.R_DATE, B.PAY_PRICE - B.PAY_DC_PRICE AS 실매출액
                FROM
                (
                    --> 예약을 취소안한 경우만.
                    SELECT R_ID, U_ID, TM_ID, R_QTY, R_DATE, R_GUBUN, R_PRICE
                    FROM RESERVATION_TBL
                    WHERE R_GUBUN = 'R'
                    AND R_ID NOT IN (SELECT R_CANCELED_ID 
                                    FROM RESERVATION_TBL
                                    WHERE R_GUBUN = 'C'
                                    )
                ) A, PAYMENT_INFO_TBL B
                WHERE A.R_ID = B.R_ID
                AND (B.PAY_METHOD_GRP = 'GRP006' AND B.PAY_METHOD != 'COM0003')
            ) AA,
            (
               --> 지점 현황
              SELECT T3.B_ID, T3.B_NAME, T2.TM_ID 
              FROM THEATER_TBL T1, TIMETABLE_TBL T2, BRANCH_TBL T3
                WHERE T1.TH_ID = T2.TH_ID(+) 
                AND T1.B_ID(+) = T3.B_ID 
            ) BB
            WHERE AA.TM_ID(+) = BB.TM_ID
        )  
        GROUP BY B_NAME
        ;
        
  END PROC_SEL_MONTHLY_BRANCHES_SALES;

  --영화별 예약 횟수 (예약 취소는 제외)
  PROCEDURE PROC_RESERVATION_MOVIES
    (
         O_CUR                  OUT     SYS_REFCURSOR
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

  --각 할인 별 사용자 많은 순위
  PROCEDURE PROC_BEST_DC
  (
    IN_PCNT_RNK          IN VARCHAR2, --가장 많은 사람들이 사용한 혜택 ㅣ 1등 보고 싶으면 1, 2등 보고 싶으면 2, 'A'를 입력하면 전체 랭킹이 보인다
    O_CUR                OUT SYS_REFCURSOR,

    O_ERRCODE            OUT VARCHAR2,
    O_ERRMSG             OUT VARCHAR2
  ) 
  AS
    
    V_PCNT_RNK         NUMBER(30); --많은 사람 순위
    
    EXC_NO_RNK         EXCEPTION;
  
  BEGIN
  
    --랭킹 순위
    SELECT MAX(PRNK)
    INTO V_PCNT_RNK
    FROM(
            SELECT DENSE_RANK() OVER(ORDER BY COUNT(C.COM_NAME) DESC) AS PRNK, 
                C.COM_NAME, COUNT(C.COM_NAME) AS PCNT
            FROM
            (
                SELECT B.COM_NAME, COUNT(R_ID) AS PCNT, SUM(A.PAY_DC_PRICE)AS PSUM
                FROM PAYMENT_INFO_TBL A,
                (
                    SELECT T1.GRP_ID , T1.COM_ID, T1.COM_NAME
                    FROM COMMONS_TBL T1, COMMONS_TBL T2, COMMONS_TBL T3
                    WHERE T1.PARENT_ID = T2.COM_ID AND T1.GRP_ID = T2.GRP_ID
                    AND T2.PARENT_ID = T3.COM_ID AND T2.GRP_ID = T3.GRP_ID
                    AND T1.GRP_ID = 'GRP007'
                ) B
                WHERE A.PAY_DC_TYPE_GRP = B.GRP_ID AND A.PAY_DC_TYPE = B.COM_ID
                GROUP BY B.COM_NAME, A.R_ID
            ) C
            GROUP BY C.COM_NAME
        ) D
    ;
    
    --전체 순위를 보고 싶다
       IF IN_PCNT_RNK = 'A' THEN
       
            OPEN O_CUR FOR
            SELECT D.PRNK, D.COM_NAME, D.PCNT 
            FROM(
                SELECT DENSE_RANK() OVER(ORDER BY COUNT(C.COM_NAME) DESC) AS PRNK, 
                    C.COM_NAME, COUNT(C.COM_NAME) AS PCNT
                FROM
                (
                    SELECT B.COM_NAME, COUNT(R_ID) AS PCNT, SUM(A.PAY_DC_PRICE)AS PSUM
                    FROM PAYMENT_INFO_TBL A,
                    (
                        SELECT T1.GRP_ID , T1.COM_ID, T1.COM_NAME
                        FROM COMMONS_TBL T1, COMMONS_TBL T2, COMMONS_TBL T3
                        WHERE T1.PARENT_ID = T2.COM_ID AND T1.GRP_ID = T2.GRP_ID
                        AND T2.PARENT_ID = T3.COM_ID AND T2.GRP_ID = T3.GRP_ID
                        AND T1.GRP_ID = 'GRP007'
                    ) B
                    WHERE A.PAY_DC_TYPE_GRP = B.GRP_ID AND A.PAY_DC_TYPE = B.COM_ID
                    GROUP BY B.COM_NAME, A.R_ID
                ) C
                GROUP BY C.COM_NAME
            ) D
            ;
                    
            
        --입력 값과 순위가 동일하면 해당 순위의 혜택을 보여준다
        ELSE
        
            OPEN O_CUR FOR
            SELECT D.PRNK, D.COM_NAME, D.PCNT 
            FROM(
                SELECT DENSE_RANK() OVER(ORDER BY COUNT(C.COM_NAME) DESC) AS PRNK, 
                    C.COM_NAME, COUNT(C.COM_NAME) AS PCNT
                FROM
                (
                    SELECT B.COM_NAME, COUNT(R_ID) AS PCNT, SUM(A.PAY_DC_PRICE)AS PSUM
                    FROM PAYMENT_INFO_TBL A,
                    (
                        SELECT T1.GRP_ID , T1.COM_ID, T1.COM_NAME
                        FROM COMMONS_TBL T1, COMMONS_TBL T2, COMMONS_TBL T3
                        WHERE T1.PARENT_ID = T2.COM_ID AND T1.GRP_ID = T2.GRP_ID
                        AND T2.PARENT_ID = T3.COM_ID AND T2.GRP_ID = T3.GRP_ID
                        AND T1.GRP_ID = 'GRP007'
                    ) B
                    WHERE A.PAY_DC_TYPE_GRP = B.GRP_ID AND A.PAY_DC_TYPE = B.COM_ID
                    GROUP BY B.COM_NAME, A.R_ID
                ) C
                GROUP BY C.COM_NAME
            ) D
            WHERE D.PRNK = IN_PCNT_RNK
            ;
            
        END IF;
        
        IF IN_PCNT_RNK >  V_PCNT_RNK THEN
            
            RAISE EXC_NO_RNK;
        
        END IF;
        
    
    EXCEPTION
    WHEN EXC_NO_RNK THEN
    
        O_ERRCODE := 'ERROR005';
        O_ERRMSG := '없는 랭크입니다';
        ROLLBACK;
    
    WHEN OTHERS THEN
    
        O_ERRCODE := SQLCODE;
        O_ERRMSG := SQLERRM;
        ROLLBACK;
    
  END PROC_BEST_DC;
  
    --사용된 할인 중 원하는 할인 이름 검색해서 찾기
  PROCEDURE PROC_SEARCH_DC
  (
        IN_COM_NAME             IN      VARCHAR2,
        O_CUR                   OUT     SYS_REFCURSOR,
        O_ERRCODE               OUT     VARCHAR2,
        O_ERRMSG                OUT     VARCHAR2
  )
  AS
  
  BEGIN
  
        OPEN O_CUR FOR
        SELECT D.PRNK, D.COM_NAME, D.PCNT 
        FROM
        (
            SELECT DENSE_RANK() OVER(ORDER BY COUNT(C.COM_NAME) DESC) AS PRNK, 
                C.COM_NAME, COUNT(C.COM_NAME) AS PCNT
            FROM
            (
                SELECT B.COM_NAME, COUNT(R_ID) AS PCNT, SUM(A.PAY_DC_PRICE)AS PSUM
                FROM PAYMENT_INFO_TBL A,
                (
                    SELECT T1.GRP_ID , T1.COM_ID, T1.COM_NAME
                    FROM COMMONS_TBL T1, COMMONS_TBL T2, COMMONS_TBL T3
                    WHERE T1.PARENT_ID = T2.COM_ID AND T1.GRP_ID = T2.GRP_ID
                    AND T2.PARENT_ID = T3.COM_ID AND T2.GRP_ID = T3.GRP_ID
                    AND T1.GRP_ID = 'GRP007'
                ) B
                WHERE A.PAY_DC_TYPE_GRP = B.GRP_ID AND A.PAY_DC_TYPE = B.COM_ID
                GROUP BY B.COM_NAME, A.R_ID
            ) C 
            GROUP BY C.COM_NAME
        ) D
        WHERE D.COM_NAME LIKE '%' || IN_COM_NAME || '%'
        ;
    
        EXCEPTION
        WHEN OTHERS 
        THEN O_ERRCODE := SQLCODE;
             O_ERRMSG := SQLERRM;
    
  END PROC_SEARCH_DC;
  
      --영화별 장르 조회
    PROCEDURE PROC_SEL_MOVIE_WITH_GENRE
    (
        O_CUR                   OUT     SYS_REFCURSOR,
        O_ERRCODE               OUT     VARCHAR2,
        O_ERRMSG                OUT     VARCHAR2
    )
    AS
    BEGIN
    
    OPEN O_CUR FOR
    SELECT T1.M_ID, T1.M_NAME, LISTAGG(T3.COM_NAME , ',') WITHIN GROUP (ORDER BY T3.COM_NAME) AS GENRE
    FROM MOVIE_TBL T1, GENRE_TBL T2, COMMONS_TBL T3
    WHERE T1.M_ID = T2.M_ID
    AND T2.G_GENRE_GRP = T3.GRP_ID AND T2.G_GENRE = T3.COM_ID
    GROUP BY T1.M_ID, T1.M_NAME 
    ORDER BY M_ID
    ;
    
    EXCEPTION
    WHEN OTHERS
    THEN O_ERRCODE := SQLCODE;
         O_ERRMSG  := SQLERRM;
    
    END PROC_SEL_MOVIE_WITH_GENRE
    ;

END PKG_BUSINESS;

--바디 끝
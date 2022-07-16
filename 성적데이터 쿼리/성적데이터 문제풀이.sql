--1. 학생리스트 출력
-- 학생아이디, 학생이름,  학생주소,  학생학과
SELECT * FROM STUDENTS_TBL; --90
SELECT * FROM COMMONS_TBL; --주소, 학과

SELECT A.STU_ID, A.STU_NAME,
    C.COMVAL || ' ' || C.COMVAL3 || ' ' || C.COMVAL4 AS ADDR,
    B.COMVAL || ' ' || B.COM_VAL AS MAJOR
FROM STUDENTS_TBL A,
(
    SELECT T2.COM_ID, T2.GRP_ID, T1.COM_VAL AS COMVAL, T2.COM_VAL FROM COMMONS_TBL T1, COMMONS_TBL T2
    WHERE T1.GRP_ID = T2.GRP_ID AND T1.COM_ID = T2.PARENT_ID
    AND T1.GRP_ID = 'GRP002' AND T2.COM_LVL = 2
) B,
(
    SELECT T1.COM_VAL AS COMVAL, T1.COM_ID AS JICODE1,
        T2.PARENT_ID AS PCODE2, T2.COM_VAL AS COMVAL2, T2.COM_ID AS JICODE2,
        T3.PARENT_ID AS PCOD3, T3.COM_VAL AS COMVAL3, T3.COM_ID AS JICODE3,
        T4.PARENT_ID AS PCODE4, T4.COM_VAL AS COMVAL4, T4.COM_ID AS JICODE4
    FROM COMMONS_TBL T1, COMMONS_TBL T2, COMMONS_TBL T3, COMMONS_TBL T4
    WHERE T1.GRP_ID = T2.GRP_ID(+) AND T1.COM_ID = T2.PARENT_ID(+)
    AND T2.GRP_ID = T3.GRP_ID(+) AND T2.COM_ID = T3.PARENT_ID(+)
    AND T3.GRP_ID = T4.GRP_ID(+) AND T3.COM_ID = T4.PARENT_ID(+)
    AND T1.GRP_ID = 'GRP001' AND T2.COM_LVL = 2 AND T3.COM_LVL = 3
) C
WHERE A.STU_DEPT_GRP = B.GRP_ID AND A.STU_DEPT = B.COM_ID
AND A.STU_ADDR2 = C.JICODE1(+) AND A.STU_ADDR IN(C.JICODE3, C.JICODE4)
;


--2. 교수리스트 출력
--교수아이디   교수이름   교수주소   소속학과
SELECT * FROM PROFESSORS_TBL; --40
SELECT * FROM COMMONS_TBL; -- 주소, 학과

SELECT A.PRO_ID, A.PRO_NAME, 
    C.COMVAL1 || ' ' || C.COMVAL3 || ' ' || C.COMVAL4 AS ADDR,
    B.COLLEGE || ' ' || B.MAJOR AS MAJOR
FROM PROFESSORS_TBL A,
(
    SELECT T2.GRP_ID, T2.COM_ID, T1.COM_VAL AS COLLEGE, T2.COM_VAL AS MAJOR 
    FROM COMMONS_TBL T1, COMMONS_TBL T2
    WHERE T1.GRP_ID = T2.GRP_ID AND T1.COM_ID = T2.PARENT_ID
    AND T1.GRP_ID = 'GRP002' AND T2.COM_LVL = 2
) B,
(
    SELECT T1.COM_ID AS COMID1, T1.COM_VAL AS COMVAL1,
        T2.COM_ID AS COMID2, T2.COM_VAL AS COMVAL2,
        T3.COM_ID AS COMID3, T3.COM_VAL AS COMVAL3,
        T4.COM_ID AS COMID4, T4.COM_VAL AS COMVAL4
    FROM COMMONS_TBL T1, COMMONS_TBL T2, COMMONS_TBL T3, COMMONS_TBL T4
    WHERE T1.GRP_ID = T2.GRP_ID(+) AND T1.COM_ID = T2.PARENT_ID(+)
    AND T2.GRP_ID = T3.GRP_ID(+) AND T2.COM_ID = T3.PARENT_ID(+)
    AND T3.GRP_ID = T4.GRP_ID(+) AND T3.COM_ID = T4.PARENT_ID(+)
    AND T1.GRP_ID = 'GRP001' AND T2.COM_LVL = 2 AND T3.COM_LVL = 3
) C
WHERE A.PRO_DEPT_GRP = B.GRP_ID AND A.PRO_DEPT = B.COM_ID
AND A.PRO_ADDR2 = C.COMID1(+) AND A.PRO_ADDR IN(COMID3, COMID4)
;


--학과
SELECT T2.GRP_ID, T2.COM_ID, T1.COM_VAL AS COLLEGE, T2.COM_VAL AS MAJOR 
FROM COMMONS_TBL T1, COMMONS_TBL T2
WHERE T1.GRP_ID = T2.GRP_ID AND T1.COM_ID = T2.PARENT_ID
AND T1.GRP_ID = 'GRP002' AND T2.COM_LVL = 2
;

--주소
SELECT T1.COM_ID AS COMID1, T1.COM_VAL AS COMVAL1,
    T2.COM_ID AS COMID2, T2.COM_VAL AS COMVAL2,
    T3.COM_ID AS COMID3, T3.COM_VAL AS COMVAL3,
    T4.COM_ID AS COMID4, T4.COM_VAL AS COMVAL4
FROM COMMONS_TBL T1, COMMONS_TBL T2, COMMONS_TBL T3, COMMONS_TBL T4
WHERE T1.GRP_ID = T2.GRP_ID(+) AND T1.COM_ID = T2.PARENT_ID(+)
AND T2.GRP_ID = T3.GRP_ID(+) AND T2.COM_ID = T3.PARENT_ID(+)
AND T3.GRP_ID = T4.GRP_ID(+) AND T3.COM_ID = T4.PARENT_ID(+)
AND T1.GRP_ID = 'GRP001' AND T2.COM_LVL = 2 AND T3.COM_LVL = 3
;

--3. 과목리스트
-- 등록년도   등록학기   해당학과   과목    학점
SELECT * FROM SUBJECTS_TBL;
SELECT * FROM COMMONS_TBL;

SELECT A.DO_YEAR AS 등록년도, A.SEMESTER AS 학기, 
    B.COLLEGE || ' ' || B.MAJOR AS 해당학과, 
    A.SUB_NAME AS 과목, A.SUB_CREDIT AS 학점
FROM SUBJECTS_TBL A
,
(
SELECT T1.GRP_ID AS GRPID, T1.COM_ID AS COMID, T1.COM_VAL AS COLLEGE,
    T2.COM_VAL AS MAJOR, T2.GRP_ID, T2.COM_ID
FROM COMMONS_TBL T1, COMMONS_TBL T2
WHERE T1.GRP_ID = T2.GRP_ID AND T1.COM_ID = T2.PARENT_ID
AND T1.GRP_ID = 'GRP002' AND T2.COM_LVL = 2
) B
WHERE A.DEPT_GRP = B.GRP_ID AND A.DEPT_CODE = B.COM_ID
;

--5. 학생별 신청과목 리스트 
--학생아이디  학생이름  소속학과  신청과목아이디  신청과목  학점
SELECT * FROM STUDENTS_TBL;
SELECT * FROM COMMONS_TBL;
SELECT * FROM SUBJECTS_TBL;
SELECT * FROM STUDENTS_TIME_TBL;

SELECT A.STU_ID, A.STU_NAME, D.COLLEGE || ' ' || D.MAJOR AS MAJOR,
    C.SUB_ID, B.SUB_NAME, B.SUB_CREDIT
FROM STUDENTS_TBL A, SUBJECTS_TBL B, STUDENTS_TIME_TBL C,
(
    SELECT T1.GRP_ID AS GRPID, T1.COM_ID AS COMID, T1.COM_VAL AS COLLEGE
        , T2.COM_VAL AS MAJOR, T2.GRP_ID, T2.COM_ID
    FROM COMMONS_TBL T1, COMMONS_TBL T2
    WHERE T1.GRP_ID = T2.GRP_ID AND T1.COM_ID = T2.PARENT_ID
    AND T1.GRP_ID = 'GRP002' AND T2.COM_LVL = 2
) D
WHERE A.STU_ID = C.STU_ID AND B.SUB_ID = C.SUB_ID
AND B.DEPT_GRP = D.GRP_ID AND B.DEPT_CODE = D.COM_ID
;

--각 학생별 총신청 학점

SELECT A.STU_ID, A.STU_NAME, NVL(SUM(B.SUB_CREDIT), 0) AS TCREDIT
FROM STUDENTS_TBL A, SUBJECTS_TBL B, STUDENTS_TIME_TBL C
WHERE A.STU_ID = C.STU_ID(+) AND B.SUB_ID(+) = C.SUB_ID
GROUP BY A.STU_ID, A.STU_NAME
;

--6. 교수별 강의 리스트 
-- 교수아이디    교수명    소속학과    강의과목아이디    과목명
SELECT * FROM PROFESSORS_TBL
ORDER BY PRO_DEPT_GRP, PRO_DEPT ASC;
SELECT * FROM COMMONS_TBL;
SELECT * FROM SUBJECTS_TBL;

SELECT A.PRO_ID, A.PRO_NAME, C.COLLEGE || ' ' || C.MAJOR AS 소속학과, B.SUB_ID, B.SUB_NAME
FROM PROFESSORS_TBL A, SUBJECTS_TBL B
,
(
    SELECT T1.GRP_ID AS GRPID, T1.COM_ID AS COMID, T1.COM_VAL AS COLLEGE, T2.COM_VAL AS MAJOR, T2.GRP_ID, T2.COM_ID
    FROM COMMONS_TBL T1, COMMONS_TBL T2
    WHERE T1.GRP_ID = T2.GRP_ID AND T1.COM_ID = T2.PARENT_ID
    AND T1.GRP_ID = 'GRP002' AND T2.COM_LVL = 2
) C
WHERE A.PRO_DEPT_GRP = B.DEPT_GRP AND A.PRO_DEPT = B.DEPT_CODE AND A.PRO_ID = B.PRO_ID
AND B.DEPT_GRP = C.GRP_ID AND B.DEPT_CODE = C.COM_ID
;


--7. 각 학과별 학생숫자
--학과명    학생수
SELECT * FROM COMMONS_TBL;
SELECT * FROM STUDENTS_TBL;

SELECT B.COMVAL, B.COM_VAL, COUNT(A.STU_NAME)
FROM STUDENTS_TBL A
,
(
    SELECT T1.GRP_ID AS GRPID, T1.COM_ID AS COMID, T1.COM_VAL AS COMVAL, T2.COM_VAL, T2.GRP_ID, T2.COM_ID
    FROM COMMONS_TBL T1, COMMONS_TBL T2
    WHERE T1.GRP_ID = T2.GRP_ID AND T1.COM_ID = T2.PARENT_ID
    AND T1.GRP_ID = 'GRP002' AND T2.COM_LVL = 2
) B
WHERE A.STU_DEPT_GRP(+) = B.GRP_ID AND A.STU_DEPT(+) = B.COM_ID
GROUP BY B.GRP_ID, B.COMVAL, B.COM_VAL
ORDER BY COUNT(A.STU_NAME) DESC
;


--8. 각 학과별 교수숫자
--학과명    교수수
SELECT * FROM PROFESSORS_TBL;
SELECT * FROM COMMONS_TBL;

SELECT B.COMVAL, B.COM_VAL, COUNT(A.PRO_NAME)
FROM PROFESSORS_TBL A
,(
    SELECT T1.GRP_ID AS GRPID, T1.COM_ID AS COMID, T1.COM_VAL AS COMVAL, T2.COM_VAL, T2.GRP_ID, T2.COM_ID
    FROM COMMONS_TBL T1, COMMONS_TBL T2
    WHERE T1.GRP_ID = T2.GRP_ID AND T1.COM_ID = T2.PARENT_ID
    AND T1.GRP_ID = 'GRP002' AND T2.COM_LVL = 2
) B
WHERE B.GRP_ID = A.PRO_DEPT_GRP(+) AND B.COM_ID = A.PRO_DEPT(+)
GROUP BY B.COMVAL, B.COM_VAL
ORDER BY COUNT(A.PRO_NAME) DESC
;


--9. 각 학과별 학생숫자 , 소속교수숫자 
--학과명    학생수,   교수수
SELECT * FROM COMMONS_TBL;
SELECT * FROM STUDENTS_TBL;
SELECT * FROM PROFESSORS_TBL;

SELECT C.COMVAL, C.COM_VAL, C.STUCNT, D.PROCNT FROM
(
    SELECT B.GRP_ID, B.COM_ID, B.COMVAL, B.COM_VAL, COUNT(A.STU_NAME) AS STUCNT
    FROM STUDENTS_TBL A
    ,
    (
        SELECT T1.GRP_ID AS GRPID, T1.COM_ID AS COMID, T1.COM_VAL AS COMVAL, T2.COM_VAL, T2.GRP_ID, T2.COM_ID
        FROM COMMONS_TBL T1, COMMONS_TBL T2
        WHERE T1.GRP_ID = T2.GRP_ID AND T1.COM_ID = T2.PARENT_ID
        AND T1.GRP_ID = 'GRP002' AND T2.COM_LVL = 2
    ) B
    WHERE A.STU_DEPT_GRP(+) = B.GRP_ID AND A.STU_DEPT(+) = B.COM_ID
    GROUP BY B.GRP_ID, B.COM_ID, B.GRP_ID, B.COMVAL, B.COM_VAL
) C
,
(
    SELECT B.GRP_ID, B.COM_ID, B.COMVAL, B.COM_VAL, COUNT(A.PRO_NAME) AS PROCNT
    FROM PROFESSORS_TBL A
    ,(
        SELECT T1.GRP_ID AS GRPID, T1.COM_ID AS COMID, T1.COM_VAL AS COMVAL, T2.COM_VAL, T2.GRP_ID, T2.COM_ID
        FROM COMMONS_TBL T1, COMMONS_TBL T2
        WHERE T1.GRP_ID = T2.GRP_ID AND T1.COM_ID = T2.PARENT_ID
        AND T1.GRP_ID = 'GRP002' AND T2.COM_LVL = 2
    ) B
    WHERE B.GRP_ID = A.PRO_DEPT_GRP(+) AND B.COM_ID = A.PRO_DEPT(+)
    GROUP BY B.GRP_ID, B.COM_ID, B.COMVAL, B.COM_VAL
) D
WHERE C.GRP_ID = D.GRP_ID AND C.COM_ID = D.COM_ID
;


--10. 각 지역별 학생숫자 , 소속교수숫자
--지역명    학생수,   교수수
SELECT * FROM COMMONS_TBL;
SELECT * FROM STUDENTS_TBL;
SELECT * FROM PROFESSORS_TBL;

    -- 지역별 학생수
    SELECT B.COMVAL, COUNT(A.STU_NAME) AS STUCNT
    FROM STUDENTS_TBL A,
    (
        SELECT T1.COM_ID AS COMID1, T1.COM_VAL AS COMVAL1,
            T2.COM_ID AS COMID2, T2.COM_VAL AS COMVAL2,
            T3.COM_ID AS COMID3, T3.COM_VAL AS COMVAL3,
            T4.COM_ID AS COMID4, T4.COM_VAL AS COMVAL4,
            T1.COM_VAL || ' ' || T2.COM_VAL || ' ' || T3.COM_VAL || ' ' || T4.COM_VAL AS COMVAL
        FROM COMMONS_TBL T1, COMMONS_TBL T2, COMMONS_TBL T3, COMMONS_TBL T4
        WHERE T1.GRP_ID = T2.GRP_ID(+) AND T1.COM_ID = T2.PARENT_ID(+)
        AND T2.GRP_ID = T3.GRP_ID(+) AND T2.COM_ID = T3.PARENT_ID(+)
        AND T3.GRP_ID = T4.GRP_ID(+) AND T3.COM_ID = T4.PARENT_ID(+)
        AND T1.GRP_ID = 'GRP001' AND T2.COM_LVL = 2 AND T3.COM_LVL = 3
    ) B
    WHERE A.STU_ADDR2 = B.COMID1(+) AND A.STU_ADDR IN(B.COMID3, B.COMID4)
    GROUP BY B.COMVAL
    ;
    -- 지역벽 교수수
    SELECT B.COMVAL, COUNT(A.PRO_NAME) AS STUCNT
    FROM PROFESSORS_TBL A,
    (
        SELECT T1.COM_ID AS COMID1, T1.COM_VAL AS COMVAL1,
            T2.COM_ID AS COMID2, T2.COM_VAL AS COMVAL2,
            T3.COM_ID AS COMID3, T3.COM_VAL AS COMVAL3,
            T4.COM_ID AS COMID4, T4.COM_VAL AS COMVAL4,
            T1.COM_VAL || ' ' || T2.COM_VAL || ' ' || T3.COM_VAL || ' ' || T4.COM_VAL AS COMVAL
        FROM COMMONS_TBL T1, COMMONS_TBL T2, COMMONS_TBL T3, COMMONS_TBL T4
        WHERE T1.GRP_ID = T2.GRP_ID(+) AND T1.COM_ID = T2.PARENT_ID(+)
        AND T2.GRP_ID = T3.GRP_ID(+) AND T2.COM_ID = T3.PARENT_ID(+)
        AND T3.GRP_ID = T4.GRP_ID(+) AND T3.COM_ID = T4.PARENT_ID(+)
        AND T1.GRP_ID = 'GRP001' AND T2.COM_LVL = 2 AND T3.COM_LVL = 3
    ) B
    WHERE A.PRO_ADDR2 = B.COMID1(+) AND A.PRO_ADDR IN(B.COMID3, B.COMID4)
    GROUP BY B.COMVAL
    ;


--11. 가장많은 학점을 듣고 있는 학생을 찾아주세요 --DENSE_RANK() OVER() 
-- 여러명일수도 있어요
SELECT * FROM STUDENTS_TBL;
SELECT * FROM SUBJECTS_TBL;
SELECT * FROM STUDENTS_TIME_TBL;

SELECT * FROM
(
    SELECT T1.STU_ID, T1.STU_NAME, NVL(SUM(T3.SUB_CREDIT), 0) AS TCREDIT,
        DENSE_RANK() OVER(ORDER BY NVL(SUM(T3.SUB_CREDIT),0) DESC) AS RNK
    FROM STUDENTS_TBL T1, STUDENTS_TIME_TBL T2, SUBJECTS_TBL T3
    WHERE T1.STU_ID = T2.STU_ID(+) AND T2.SUB_ID = T3.SUB_ID(+)
    GROUP BY T1.STU_ID, T1.STU_NAME
) A
WHERE A.RNK = 1
;


--12. 가장많은 강의 시간을 가지고 있는 교수를 찾아주세요 
SELECT * FROM SUBJECTS_TBL;
SELECT * FROM PROFESSORS_TBL;
SELECT * FROM STUDENTS_TIME_TBL;

--교수별 강의 과목 리스트
SELECT T1.PRO_ID, T1.PRO_NAME, T2.SUB_ID, T2.SUB_NAME, T2.SUB_CREDIT
FROM PROFESSORS_TBL T1, SUBJECTS_TBL T2
WHERE T1.PRO_ID = T2.PRO_ID
;

--학생수 없어서 취소된 과목
SELECT * FROM SUBJECTS_TBL T1, STUDENTS_TIME_TBL T2
WHERE T1.SUB_ID = T2.SUB_ID(+)
AND T2.SUB_ID IS NULL
;

--교수별 강의를 맡은 과목 과 수강생이 없어서 취소된 강의과목 및 시수 리스트
SELECT A.PRO_ID, A.PRO_NAME, A.SUB_ID, A.SUB_NAME,
    A.SUB_CREDIT, NVL(B.SUB_CREDIT,0) AS CANCELED
FROM 
(
    SELECT T1.PRO_ID, T1.PRO_NAME, T2.SUB_ID, T2.SUB_NAME, T2.SUB_CREDIT
    FROM PROFESSORS_TBL T1, SUBJECTS_TBL T2
    WHERE T1.PRO_ID = T2.PRO_ID
) A,
(
    SELECT T1.SUB_ID,T1.SUB_NAME, T1.SUB_CREDIT 
    FROM SUBJECTS_TBL T1, STUDENTS_TIME_TBL T2
    WHERE T1.SUB_ID = T2.SUB_ID(+)
    AND T2.SUB_ID IS NULL
) B
WHERE A.SUB_ID = B.SUB_ID(+)
;

--실제로 가장 많은 강의를 맡은 교수 찾기
SELECT A.PRO_ID, A.PRO_NAME, SUM(A.CREDIT - A.CANCELED) AS TCREDIT,
    DENSE_RANK() OVER(ORDER BY SUM(A.CREDIT - A.CANCELED) DESC) AS RNK
FROM
(
    SELECT A.PRO_ID, A.PRO_NAME, A.SUB_ID, A.SUB_NAME,
        A.SUB_CREDIT AS CREDIT, NVL(B.SUB_CREDIT,0) AS CANCELED
    FROM 
    (
        SELECT T1.PRO_ID, T1.PRO_NAME, T2.SUB_ID, T2.SUB_NAME, T2.SUB_CREDIT
        FROM PROFESSORS_TBL T1, SUBJECTS_TBL T2
        WHERE T1.PRO_ID = T2.PRO_ID
    ) A,
    (
        SELECT T1.SUB_ID,T1.SUB_NAME, T1.SUB_CREDIT 
        FROM SUBJECTS_TBL T1, STUDENTS_TIME_TBL T2
        WHERE T1.SUB_ID = T2.SUB_ID(+)
        AND T2.SUB_ID IS NULL
    ) B
    WHERE A.SUB_ID = B.SUB_ID(+)
) A
GROUP BY A.PRO_ID, A.PRO_NAME
;


--13. 2018년 2월1일 부터 ~ 2월 28일까지 각 날짜별로 수강신청 현황을 보여주세요 
-- 날짜, 학생수, 수강신청 -> 날짜, 수강신청수
SELECT * FROM STUDENTS_TIME_TBL;

SELECT T1.REG_TIME, COUNT(T2.STU_ID)
FROM STUDENTS_TIME_TBL T1, STUDENTS_TBL T2
WHERE T1.STU_ID = T2.STU_ID
GROUP BY T1.REG_TIME
ORDER BY COUNT(T2.STU_ID) DESC
;


--14. 가장 수강신청이 많은 날짜를 찾아주세요 
SELECT * FROM STUDENTS_TIME_TBL;

SELECT * FROM
(
    SELECT REG_TIME, COUNT(REG_TIME), DENSE_RANK() OVER(ORDER BY COUNT(REG_TIME) DESC) AS RNK
    FROM STUDENTS_TIME_TBL
    GROUP BY REG_TIME
    ORDER BY COUNT(REG_TIME) DESC
) A
WHERE A.RNK = 1
;

--15. 가장 수강신청이 많은 과목 해당과목 교수님을 찾아주세요 
SELECT * FROM PROFESSORS_TBL;
SELECT * FROM STUDENTS_TIME_TBL;
SELECT * FROM SUBJECTS_TBL;
SELECT * FROM STUDENTS_TBL;

--수강신청이 많은 과목
SELECT A.SUB_ID, A.PRO_ID, A.SUB_NAME, B.CNT, B.RNK
FROM SUBJECTS_TBL A,
(
    SELECT SUB_ID, COUNT(*) AS CNT, DENSE_RANK() OVER(ORDER BY COUNT(*) DESC) AS RNK
    FROM STUDENTS_TIME_TBL
    GROUP BY SUB_ID
) B
WHERE A.SUB_ID = B.SUB_ID
AND B.RNK = 1
;

--최종
SELECT D.SUB_ID, D.SUB_NAME, C.PRO_ID, C.PRO_NAME
FROM PROFESSORS_TBL C,
(
    SELECT A.SUB_ID, A.PRO_ID, A.SUB_NAME, B.CNT, B.RNK
    FROM SUBJECTS_TBL A,
    (
        SELECT SUB_ID, COUNT(*) AS CNT, DENSE_RANK() OVER(ORDER BY COUNT(*) DESC) AS RNK
        FROM STUDENTS_TIME_TBL
        GROUP BY SUB_ID
    ) B
    WHERE A.SUB_ID = B.SUB_ID
    AND B.RNK = 1
) D
WHERE C.PRO_ID = D.PRO_ID 
;


--16. 학생이 한명도 없는 학과의 교수명단 리스트를 보여주세요
SELECT * FROM STUDENTS_TBL;
SELECT * FROM COMMONS_TBL;
SELECT * FROM PROFESSORS_TBL;

--학생이 한명도 없는 학과
SELECT * FROM STUDENTS_TBL A,
(
    SELECT T1.COM_VAL AS COMVAL, T2.COM_VAL, T2.GRP_ID, T2.COM_ID
    FROM COMMONS_TBL T1, COMMONS_TBL T2
    WHERE T1.GRP_ID = T2.GRP_ID AND T1.COM_ID = T2.PARENT_ID
    AND T1.GRP_ID = 'GRP002' AND T2.COM_LVL = 2
) B
WHERE A.STU_DEPT_GRP(+) = B.GRP_ID AND A.STU_DEPT(+) = B.COM_ID
AND A.STU_ID IS NULL
;

--최종
SELECT D.GRP_ID, D.COM_ID, D.COMVAL, D.COM_VAL, C.PRO_ID, C.PRO_NAME, NVL(D.STU_ID, 0) AS 학생수 
FROM PROFESSORS_TBL C,
(
    SELECT * FROM STUDENTS_TBL A,
    (
        SELECT T1.COM_VAL AS COMVAL, T2.COM_VAL, T2.GRP_ID, T2.COM_ID
        FROM COMMONS_TBL T1, COMMONS_TBL T2
        WHERE T1.GRP_ID = T2.GRP_ID AND T1.COM_ID = T2.PARENT_ID
        AND T1.GRP_ID = 'GRP002' AND T2.COM_LVL = 2
    ) B
    WHERE A.STU_DEPT_GRP(+) = B.GRP_ID AND A.STU_DEPT(+) = B.COM_ID
    AND A.STU_ID IS NULL
) D
WHERE C.PRO_DEPT_GRP(+) = D.GRP_ID AND C.PRO_DEPT(+) = D.COM_ID
;

--17. 각 학과별 학생들의 시험성적 평균과 합계를 보여주세요
-- 중간고사 (GUBUN 1)
SELECT * FROM STUDENTS_TBL;
SELECT * FROM SCORES_TBL;
SELECT * FROM COMMONS_TBL;

SELECT C.COMVAL || ' ' || C.COM_VAL AS MAJOR, A.STU_ID, A.STU_NAME, ROUND(AVG(B.SCORE), 1) AS AVGSCORE, SUM(B.SCORE) AS SUMSCORE
FROM STUDENTS_TBL A, SCORES_TBL B,
(
    SELECT T1.COM_VAL AS COMVAL, T2.COM_VAL, T2.GRP_ID, T2.COM_ID
    FROM COMMONS_TBL T1, COMMONS_TBL T2
    WHERE T1.GRP_ID = T2.GRP_ID AND T1.COM_ID = T2.PARENT_ID
    AND T1.GRP_ID = 'GRP002' AND T2.COM_LVL = 2
) C
WHERE A.STU_ID(+) = B.STU_ID AND A.STU_DEPT_GRP = C.GRP_ID AND A.STU_DEPT = C.COM_ID
AND B.GUBUN = 1
GROUP BY C.COMVAL || ' ' || C.COM_VAL, A.STU_ID, A.STU_NAME
ORDER BY A.STU_ID ASC
;

-- 기말고사 (GUBUN 2)

SELECT C.COMVAL || ' ' || C.COM_VAL AS MAJOR, A.STU_ID, A.STU_NAME, ROUND(AVG(B.SCORE), 1) AS AVGSCORE, SUM(B.SCORE) AS SUMSCORE
FROM STUDENTS_TBL A, SCORES_TBL B,
(
    SELECT T1.COM_VAL AS COMVAL, T2.COM_VAL, T2.GRP_ID, T2.COM_ID
    FROM COMMONS_TBL T1, COMMONS_TBL T2
    WHERE T1.GRP_ID = T2.GRP_ID AND T1.COM_ID = T2.PARENT_ID
    AND T1.GRP_ID = 'GRP002' AND T2.COM_LVL = 2
) C
WHERE A.STU_ID = B.STU_ID AND A.STU_DEPT_GRP = C.GRP_ID AND A.STU_DEPT = C.COM_ID
AND B.GUBUN = 2
GROUP BY C.COMVAL || ' ' || C.COM_VAL, A.STU_ID, A.STU_NAME
;

-- 중간, 기말고사
SELECT C.COMVAL || ' ' || C.COM_VAL AS MAJOR, A.STU_ID, A.STU_NAME, ROUND(AVG(B.SCORE), 1) AS AVGSCORE, SUM(B.SCORE) AS SUMSCORE
FROM STUDENTS_TBL A, SCORES_TBL B,
(
    SELECT T1.COM_VAL AS COMVAL, T2.COM_VAL, T2.GRP_ID, T2.COM_ID
    FROM COMMONS_TBL T1, COMMONS_TBL T2
    WHERE T1.GRP_ID = T2.GRP_ID AND T1.COM_ID = T2.PARENT_ID
    AND T1.GRP_ID = 'GRP002' AND T2.COM_LVL = 2
) C
WHERE A.STU_ID = B.STU_ID AND A.STU_DEPT_GRP = C.GRP_ID AND A.STU_DEPT = C.COM_ID
GROUP BY C.COMVAL || ' ' || C.COM_VAL, A.STU_ID, A.STU_NAME
;

--18. 전체 학생 성적리스트
     -- 소속학화  학생명  평균   총점  신청학점  순위 순으로 보여주세요 
SELECT * FROM SUBJECTS_TBL;
SELECT * FROM SCORES_TBL;
SELECT * FROM STUDENTS_TIME_TBL;
SELECT * FROM STUDENTS_TBL;


SELECT C.COMVAL || ' ' || C.COM_VAL AS MAJOR, A.STU_ID, A.STU_NAME, ROUND(AVG(B.SCORE), 1) AS AVGSCORE, SUM(B.SCORE) AS SUMSCORE,
    D.TCREDIT, DENSE_RANK() OVER(ORDER BY ROUND(AVG(B.SCORE), 1) DESC) AS RNK
FROM STUDENTS_TBL A, SCORES_TBL B,
(
    SELECT T1.COM_VAL AS COMVAL, T2.COM_VAL, T2.GRP_ID, T2.COM_ID
    FROM COMMONS_TBL T1, COMMONS_TBL T2
    WHERE T1.GRP_ID = T2.GRP_ID AND T1.COM_ID = T2.PARENT_ID
    AND T1.GRP_ID = 'GRP002' AND T2.COM_LVL = 2
) C,
(
    SELECT T1.STU_ID, T1.STU_NAME, NVL(SUM(T3.SUB_CREDIT), 0) AS TCREDIT
    FROM STUDENTS_TBL T1, STUDENTS_TIME_TBL T2, SUBJECTS_TBL T3
    WHERE T1.STU_ID = T2.STU_ID(+) AND T2.SUB_ID = T3.SUB_ID(+)
    GROUP BY T1.STU_ID, T1.STU_NAME
) D
WHERE A.STU_ID = B.STU_ID AND A.STU_DEPT_GRP = C.GRP_ID AND A.STU_DEPT = C.COM_ID
AND A.STU_ID = D.STU_ID 
GROUP BY C.COMVAL || ' ' || C.COM_VAL, A.STU_ID, A.STU_NAME, D.TCREDIT
;

--19. 출제한 교수 별 시험결과
    -- 소속학과  교수명  평균    총점 
SELECT * FROM COMMONS_TBL;
SELECT * FROM PROFESSORS_TBL;
SELECT * FROM SCORES_TBL;
SELECT * FROM SUBJECTS_TBL;

SELECT B.COMVAL || ' ' || B.COM_VAL AS MAJOR, A.PRO_NAME, 
    ROUND(AVG(C.SCORE), 1) AS AVGSCORE, SUM(C.SCORE) AS SUMSCORE 
FROM PROFESSORS_TBL A,
(
    SELECT T2.COM_ID, T2.GRP_ID, T1.COM_VAL AS COMVAL, T2.COM_VAL
    FROM COMMONS_TBL T1, COMMONS_TBL T2
    WHERE T1.GRP_ID = T2.GRP_ID AND T1.COM_ID = T2.PARENT_ID
    AND T1.GRP_ID = 'GRP002' AND T2.COM_LVL = 2
) B,
(
    SELECT T1.SUB_ID, T1.SCORE, T2.SUB_ID, T2.SUB_NAME, T2.PRO_ID
    FROM SCORES_TBL T1, SUBJECTS_TBL T2
    WHERE T1.SUB_ID = T2.SUB_ID
) C
WHERE A.PRO_DEPT_GRP = B.GRP_ID AND A.PRO_DEPT = B.COM_ID
AND A.PRO_ID(+) = C.PRO_ID
GROUP BY B.COMVAL || ' ' || B.COM_VAL, A.PRO_NAME
;
    
--20. 다음과 같은 룰로 학생들의 총 학점을 구해주세요
/*
    90점 이상               :  A     -  4.5
    80점 이상 90점미만       :  B     -  3.5
    70점 이상 80점미만       :  C     -  2.5
    60점 이상 70점미만       :  D     -  1.5
    60점 미만               :  F     -  1.0
    
    소속학과   학생명    총신청학점      총점    평균     학점     순위
*/

SELECT * FROM STUDENTS_TBL;
SELECT * FROM SUBJECTS_TBL;
SELECT * FROM STUDENTS_TIME_TBL;
SELECT * FROM SCORES_TBL;

SELECT D.COMVAL || ' ' || D.COM_VAL AS MAJOR, A.STU_NAME, 
    SUM(C.SUB_CREDIT) AS TCREDIT, SUM(NVL(B.SCORE, 0)) AS SUMSCORE, ROUND(AVG(NVL(B.SCORE, 0)), 1) AS AVGSCORE,
    DECODE(SUBSTR(ROUND(AVG(NVL(B.SCORE, 0)),1),1, 1), '9', 'A',
                                                    '8', 'B',
                                                    '7', 'C',
                                                    '6', 'D',
                                                    'F') AS GRADE,
    DENSE_RANK() OVER(ORDER BY ROUND(AVG(NVL(B.SCORE, 0)), 1) DESC) AS RNK
FROM STUDENTS_TBL A, SCORES_TBL B, SUBJECTS_TBL C,
(
    SELECT T2.GRP_ID, T2.COM_ID, T1.COM_VAL AS COMVAL, T2.COM_VAL 
    FROM COMMONS_TBL T1, COMMONS_TBL T2
    WHERE T1.GRP_ID = T2.GRP_ID(+) AND T1.COM_ID = T2.PARENT_ID(+)
    AND T1.GRP_ID = 'GRP002' AND T2.COM_LVL = 2
) D
WHERE A.STU_ID = B.STU_ID AND B.SUB_ID = C.SUB_ID
AND A.STU_DEPT_GRP(+) = D.GRP_ID AND A.STU_DEPT(+) = D.COM_ID
GROUP BY D.COMVAL || ' ' || D.COM_VAL, A.STU_NAME
;



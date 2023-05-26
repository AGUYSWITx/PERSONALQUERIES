---mgroup milan
 IF OBJECT_ID('TEMPDB..#MGROUP') is not null drop table #MGROUP

CREATE TABLE #MGROUP
(MGROUP VARCHAR(100),MCODE VARCHAR(100))
DECLARE GROUPCURSOR CURSOR FOR 
					SELECT MCODE FROM MENUITEM WHERE PARENT='PRG99999999'
					DECLARE @GROUPNAME VARCHAR(200)

					OPEN GROUPCURSOR
					FETCH NEXT FROM GROUPCURSOR INTO @GROUPNAME
					WHILE @@FETCH_STATUS=0
					BEGIN
					INSERT INTO #MGROUP
					SELECT  @GROUPNAME,MGCODE     FROM FN_ITEMHIERARCHY (@GROUPNAME,2)
					--SELECT @GROUPNAME
			 
					FETCH NEXT FROM GROUPCURSOR INTO @GROUPNAME
					END

					CLOSE GROUPCURSOR
					DEALLOCATE GROUPCURSOR


					SELECT B.MCODE,B.MGROUP OLD ,A.MGROUP NEW FROM #MGROUP A JOIN  MENUITEM B ON A.MCODE=B.MCODE   and a.MGROUP<>b.MGROUP 

					--update  b set b.mgroup=a.mgroup FROM #MGROUP A JOIN  MENUITEM B ON A.MCODE=B.MCODE   and a.MGROUP<>b.MGROUP 
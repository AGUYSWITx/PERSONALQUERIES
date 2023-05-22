CREATE OR ALTER PROCEDURE WSP_MONTHLY_SALESREPORT_SSI_SBL
	--DECLARE
	@DATE1 DATETIME,
	@DATE2 DATETIME,
	@SALESMANID NVARCHAR(MAX)='%',
	@CUSTOMERACID NVARCHAR(MAX)='%'


	AS
	--SELECT @DATE1='2022-05-01',@DATE2='2023-05-22',@SALESMANID='%'
	DECLARE @DynamicSQL NVARCHAR(MAX);
	DECLARE @Columns NVARCHAR(MAX);
	DECLARE @ColumnsSUM NVARCHAR(MAX);


        
  IF OBJECT_ID('TEMPDB..#DATA') is not null drop table #DATA
  
  IF OBJECT_ID('TEMPDB..#DATA2') is not null drop table #DATA2

	select   SSM.NAME AGENT, RA.ACNAME CUSTOMER, TR.salesmanid,TP.MCODE,ISNULL(NULLIF(B.mcat1,''),'N/A') MCAT1 ,TR.trnac ACID,TP.NETAMOUNT,SUM (TP.NETAMOUNT)  OVER (PARTITION BY TR.SALESMANID,TR.TRNAC ORDER BY TR.SALESMANID) GRANDTOTAL INTO #DATA from RMD_TRNPROD TP with (nolock) join menuitem b with (nolock) on TP.mcode=B.mcode
	JOIN TRNMAIN TR with (nolock) on TR.VCHRNO=TP.VCHRNO 
	LEFT JOIN RMD_ACLIST  RA with (nolock)  ON RA.ACID= TR.TRNAC
	LEFT JOIN SALESMAN SSM with (nolock) ON SSM.SALESMANID= TR.SALESMANID
	WHERE TR.TRNDATE BETWEEN @DATE1 AND @DATE2
	 AND	(@SALESMANID = '%' OR ( @SALESMANID <> '%' AND TR.SALESMANID  IN (SELECT * FROM DBO.SPLIT(@SALESMANID,',')))) 
	 AND	(@CUSTOMERACID = '%' OR ( @CUSTOMERACID <> '%' AND TR.TRNAC  IN (SELECT * FROM DBO.SPLIT(@CUSTOMERACID,','))))

  
-- Generate the column names dynamically based on distinct values of mcat1
	SET @Columns = NULL
	SET @Columns = STUFF(
		(
			SELECT DISTINCT ', ' + QUOTENAME(mcat1) AS [text()]
			FROM #DATA
        
			FOR XML PATH('')   
		)  ,1, 2, ''
	);
 
	 SET @ColumnsSUM = STUFF(
		(
			SELECT DISTINCT ', SUM('  + QUOTENAME(mcat1) +')  AS '+ QUOTENAME(mcat1)   
			FROM #DATA
        
			FOR XML PATH('')   
		)  ,1, 2, ''
	); 
 
 
	-- Build the dynamic SQL statement
	SET @DynamicSQL = '
	SELECT * INTO #DATA2
	FROM (
		SELECT AGENT,SALESMANID,CUSTOMER,NETAMOUNT, mcat1,GRANDTOTAL
		FROM #DATA
	) AS Source
	PIVOT (
		SUM(NETAMOUNT)
		FOR mcat1 IN (' + @Columns + ')
	) AS PivotTable


	 SELECT  * FROM (
	SELECT *,''A''FLG,''R''FFLG FROM #DATA2
	UNION ALL

	SELECT   AGENT	,   salesmanid , ''TOTAL>>''	CUSTOMER	,    SUM(GRANDTOTAL) AS SUMGRAND , '+@ColumnsSUM+' , ''B''FLG,''B''FFLG  FROM #DATA2 GROUP BY SALESMANID,AGENT
	)SUMM
	ORDER BY ISNULL(AGENT,''ZZZZZZZZ''),salesmanid ,FLG
	';

 
	-- Execute the dynamic SQL
	EXEC(@DynamicSQL);
 
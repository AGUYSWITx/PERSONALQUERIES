CREATE OR ALTER PROC WSP_DEPRECIATION_COMPANY_NORMS
	--DECLARE 
	@POOL VARCHAR(25) = '%', --POOL (ASSET_GROUP)
	@ITEM VARCHAR(50) = '%', --ASSET CODE (ASSET MENUITEM MCODE)
	@BLOCK VARCHAR(50) = '%', --BLOCK (RMD_ACLIST)
	@PHISCALID VARCHAR(25) = '%',
	@ASSETID VARCHAR(100) = '%', --ASSET ID(ASSET MASTER)
	@MODE TINYINT = 1 --1 : DEPRECIATION POOLWISE || 2 DEPN ACCOUNT HEADWISE || 3 DEPN ITEMWISE || 4 DEPN ASSETID WISE
AS
--SELECT @PHISCALID='80/81',@MODE=4
IF OBJECT_ID('tempdb..#DATA') IS NOT NULL
	DROP TABLE #DATA

SELECT AG.GROUPNAME [POOL],
	AM.AssetID,
	AD.BOOKVALUE,
	BMA.COSTPRICE ORIGNALCOST,
	AD.MON,
	DP.DEPRECIATION_VALUE,
	DP.PHISCALID,
	AD.MON ASSETMON, 
	RA.ACNAME ACCOUNTHEADING,
	AM.ACID,
	ASM.MENUCODE ASSETCODE,
	ASM.DESCA ASSET_NAME,
	ASM.DESCRIPTION DESCRIPTIONS,
	BMA.BATCHCREATEDATE PURCHASEDATE,
	DP.[ SHRAWAN],
	DP.[ BHADRA],
	DP.[ ASOJ],
	DP.[ KARTIK],
	DP.[ MANGSIR],
	DP.[ POUSH],
	DP.[ MAGH],
	DP.[ FAGUN],
	DP.[ CHAITRA],
	DP.[ BAISAKH],
	DP.[ JESTHA],
	DP.[ ASAR]

INTO #DATA
FROM 
  ASSETCODE_MASTER AM WITH (NOLOCK)  
	JOIN (SELECT ASSETID,MCODE,PHISCALID,SUM(DEPRECIATION_VALUE)DEPRECIATION_VALUE , SUM(CASE 
				WHEN MON = 1
					THEN DEPRECIATION_VALUE
				ELSE 0
				END)  [ SHRAWAN],
		 SUM(CASE 
				WHEN MON = 2
					THEN DEPRECIATION_VALUE
				ELSE 0
				END)  [ BHADRA],
		 SUM(CASE 
				WHEN MON = 3
					THEN DEPRECIATION_VALUE
				ELSE 0
				END)  [ ASOJ],
		 SUM(CASE 
				WHEN MON = 4
					THEN DEPRECIATION_VALUE
				ELSE 0
				END)  [ KARTIK],
		 SUM(CASE 
				WHEN MON = 5
					THEN DEPRECIATION_VALUE
				ELSE 0
				END)  [ MANGSIR],
		 SUM(CASE 
				WHEN MON = 6
					THEN DEPRECIATION_VALUE
				ELSE 0
				END)  [ POUSH],
		 SUM(CASE 
				WHEN MON = 7
					THEN DEPRECIATION_VALUE
				ELSE 0
				END)  [ MAGH],
		 SUM(CASE 
				WHEN MON = 8
					THEN DEPRECIATION_VALUE
				ELSE 0
				END)  [ FAGUN],
		 SUM(CASE 
				WHEN MON = 9
					THEN DEPRECIATION_VALUE
				ELSE 0
				END)  [ CHAITRA],
		 SUM(CASE 
				WHEN MON = 10
					THEN DEPRECIATION_VALUE
				ELSE 0
				END)  [ BAISAKH],
		 SUM(CASE 
				WHEN MON = 11
					THEN DEPRECIATION_VALUE
				ELSE 0
				END)  [ JESTHA],
		 SUM(CASE 
				WHEN MON = 12
					THEN DEPRECIATION_VALUE
				ELSE 0
				END)  [ ASAR]  FROM DEPRECIATION GROUP BY ASSETID,MCODE,PHISCALID ) DP ON AM.MCODE = DP.MCODE	AND AM.ASSETID = DP.ASSETID
LEFT JOIN ASSETCODE_DETAIL AD WITH (NOLOCK) ON AM.ASSETID = AD.ASSETID
	AND AM.BATCHCODE = AD.BATCHCODE 
LEFT JOIN ASSET_GROUP_LEDGER AGL WITH (NOLOCK) ON AGL.ACID = AM.ACID
LEFT JOIN ASSET_GROUP AG WITH (NOLOCK) ON AG.ASSETGROUPID = AGL.ASSETGROUPID

LEFT JOIN RMD_ACLIST RA WITH (NOLOCK) ON RA.ACID = AM.ACID
LEFT JOIN ASSET_MENUITEM ASM WITH (NOLOCK) ON ASM.MCODE = AM.MCODE
LEFT JOIN BATCHPRICE_MASTER_ASSET BMA WITH (NOLOCK) ON BMA.BATCHCODE = AM.BATCHCODE
	AND BMA.MCODE = DP.MCODE
WHERE DP.PHISCALID = @PHISCALID
	AND AGL.ASSETGROUPID LIKE @POOL
	AND AM.MCODE LIKE @ITEM
	AND AM.ACID LIKE @BLOCK
	AND AM.ASSETID LIKE @ASSETID

IF @MODE = 1
BEGIN  
   
	SELECT [POOL],
		FORMAT(SUM(CASE 
				WHEN ASSETMON = 0  
					THEN BOOKVALUE
				ELSE 0
				END)   ,'N2') [ OPENING],
		FORMAT(SUM(CASE 
				WHEN ASSETMON <> 0
					THEN BOOKVALUE
				ELSE 0
				END),'N2') [ ADDITION],
		FORMAT(SUM(BOOKVALUE),'N2') [ TOTALBOOKVALUE],
		FORMAT(SUM(   [ SHRAWAN]),'N2') [ SHRAWAN],
		FORMAT(SUM([ BHADRA]),'N2') [ BHADRA],
		FORMAT(SUM( [ ASOJ]),'N2') [ ASOJ],
		FORMAT(SUM([ KARTIK]) ,'N2')[ KARTIK],
		FORMAT(SUM([ MANGSIR]) ,'N2')[ MANGSIR],
		FORMAT(SUM([ POUSH]) ,'N2')[ POUSH],
		FORMAT(SUM([ MAGH]) ,'N2')[ MAGH],
		FORMAT(SUM([ FAGUN]),'N2') [ FAGUN],
		FORMAT(SUM([ CHAITRA]) ,'N2')[ CHAITRA],
		FORMAT(SUM([ BAISAKH]),'N2') [ BAISAKH],
		FORMAT(SUM([ JESTHA]),'N2') [ JESTHA],
		FORMAT(SUM([ ASAR]),'N2') [ ASAR],
		FORMAT(SUM(DEPRECIATION_VALUE),'N2') TOTAL_DEPRECIATION,
		FORMAT(SUM(BOOKVALUE- DEPRECIATION_VALUE),'N2') NETBOOKVALUE
	FROM #DATA
	GROUP BY [POOL]

		SELECT 'TOTAL' [POOL],
		FORMAT(SUM(CASE 
				WHEN ASSETMON = 0  
					THEN BOOKVALUE
				ELSE 0
				END)   ,'N2') [ OPENING],
		FORMAT(SUM(CASE 
				WHEN ASSETMON <> 0
					THEN BOOKVALUE
				ELSE 0
				END),'N2') [ ADDITION],
		FORMAT(SUM(BOOKVALUE),'N2') [ TOTALBOOKVALUE],
		FORMAT(SUM(   [ SHRAWAN]),'N2') [ SHRAWAN],
		FORMAT(SUM([ BHADRA]),'N2') [ BHADRA],
		FORMAT(SUM( [ ASOJ]),'N2') [ ASOJ],
		FORMAT(SUM([ KARTIK]) ,'N2')[ KARTIK],
		FORMAT(SUM([ MANGSIR]) ,'N2')[ MANGSIR],
		FORMAT(SUM([ POUSH]) ,'N2')[ POUSH],
		FORMAT(SUM([ MAGH]) ,'N2')[ MAGH],
		FORMAT(SUM([ FAGUN]),'N2') [ FAGUN],
		FORMAT(SUM([ CHAITRA]) ,'N2')[ CHAITRA],
		FORMAT(SUM([ BAISAKH]),'N2') [ BAISAKH],
		FORMAT(SUM([ JESTHA]),'N2') [ JESTHA],
		FORMAT(SUM([ ASAR]),'N2') [ ASAR],
		FORMAT(SUM(DEPRECIATION_VALUE),'N2') TOTAL_DEPRECIATION,
		FORMAT(SUM(BOOKVALUE- DEPRECIATION_VALUE),'N2') NETBOOKVALUE
	FROM #DATA
 

END

IF @MODE = 2
BEGIN
	SELECT [POOL],
		ACID,
		ACCOUNTHEADING,
		FORMAT(SUM(CASE 
				WHEN ASSETMON = 0
					THEN BOOKVALUE
				ELSE 0
				END),'N2') [ OPENING],
		FORMAT(SUM(CASE 
				WHEN ASSETMON <> 0
					THEN BOOKVALUE
				ELSE 0
				END),'N2') [ ADDITION],
		FORMAT(SUM(BOOKVALUE),'N2') [ TOTALBOOKVALUE],
		FORMAT(SUM(   [ SHRAWAN]),'N2') [ SHRAWAN],
		FORMAT(SUM([ BHADRA]),'N2') [ BHADRA],
		FORMAT(SUM( [ ASOJ]),'N2') [ ASOJ],
		FORMAT(SUM([ KARTIK]) ,'N2')[ KARTIK],
		FORMAT(SUM([ MANGSIR]) ,'N2')[ MANGSIR],
		FORMAT(SUM([ POUSH]) ,'N2')[ POUSH],
		FORMAT(SUM([ MAGH]) ,'N2')[ MAGH],
		FORMAT(SUM([ FAGUN]),'N2') [ FAGUN],
		FORMAT(SUM([ CHAITRA]) ,'N2')[ CHAITRA],
		FORMAT(SUM([ BAISAKH]),'N2') [ BAISAKH],
		FORMAT(SUM([ JESTHA]),'N2') [ JESTHA],
		FORMAT(SUM([ ASAR]),'N2') [ ASAR],
		FORMAT(SUM(DEPRECIATION_VALUE),'N2') TOTAL_DEPRECIATION,
		FORMAT(SUM(BOOKVALUE- DEPRECIATION_VALUE),'N2') NETBOOKVALUE
	FROM #DATA
	GROUP BY [POOL],
		ACID,
		ACCOUNTHEADING

		SELECT 'TOTAL' [POOL],
		NULL ACID,
		NULL  ACCOUNTHEADING,
		FORMAT(SUM(CASE 
				WHEN ASSETMON = 0
					THEN BOOKVALUE
				ELSE 0
				END),'N2') [ OPENING],
		FORMAT(SUM(CASE 
				WHEN ASSETMON <> 0
					THEN BOOKVALUE
				ELSE 0
				END),'N2') [ ADDITION],
		FORMAT(SUM(BOOKVALUE),'N2') [ TOTALBOOKVALUE],
		FORMAT(SUM(   [ SHRAWAN]),'N2') [ SHRAWAN],
		FORMAT(SUM([ BHADRA]),'N2') [ BHADRA],
		FORMAT(SUM( [ ASOJ]),'N2') [ ASOJ],
		FORMAT(SUM([ KARTIK]) ,'N2')[ KARTIK],
		FORMAT(SUM([ MANGSIR]) ,'N2')[ MANGSIR],
		FORMAT(SUM([ POUSH]) ,'N2')[ POUSH],
		FORMAT(SUM([ MAGH]) ,'N2')[ MAGH],
		FORMAT(SUM([ FAGUN]),'N2') [ FAGUN],
		FORMAT(SUM([ CHAITRA]) ,'N2')[ CHAITRA],
		FORMAT(SUM([ BAISAKH]),'N2') [ BAISAKH],
		FORMAT(SUM([ JESTHA]),'N2') [ JESTHA],
		FORMAT(SUM([ ASAR]),'N2') [ ASAR],
		FORMAT(SUM(DEPRECIATION_VALUE),'N2') TOTAL_DEPRECIATION,
		FORMAT(SUM(BOOKVALUE- DEPRECIATION_VALUE),'N2') NETBOOKVALUE
	FROM #DATA
	 
END

IF @MODE = 3
BEGIN
	SELECT [POOL],
		ACID,
		ACCOUNTHEADING,
		ASSETCODE,
		ASSET_NAME,
		FORMAT( SUM(CASE 
				WHEN ASSETMON = 0
					THEN BOOKVALUE
				ELSE 0
				END),'N2') [ OPENING],
		FORMAT(SUM(CASE 
				WHEN ASSETMON <> 0
					THEN BOOKVALUE
				ELSE 0
				END),'N2') [ ADDITION],
		FORMAT(SUM(BOOKVALUE),'N2') [ TOTALBOOKVALUE],
		FORMAT(SUM(   [ SHRAWAN]),'N2') [ SHRAWAN],
		FORMAT(SUM([ BHADRA]),'N2') [ BHADRA],
		FORMAT(SUM( [ ASOJ]),'N2') [ ASOJ],
		FORMAT(SUM([ KARTIK]) ,'N2')[ KARTIK],
		FORMAT(SUM([ MANGSIR]) ,'N2')[ MANGSIR],
		FORMAT(SUM([ POUSH]) ,'N2')[ POUSH],
		FORMAT(SUM([ MAGH]) ,'N2')[ MAGH],
		FORMAT(SUM([ FAGUN]),'N2') [ FAGUN],
		FORMAT(SUM([ CHAITRA]) ,'N2')[ CHAITRA],
		FORMAT(SUM([ BAISAKH]),'N2') [ BAISAKH],
		FORMAT(SUM([ JESTHA]),'N2') [ JESTHA],
		FORMAT(SUM([ ASAR]),'N2') [ ASAR],
		FORMAT(SUM(DEPRECIATION_VALUE),'N2') TOTAL_DEPRECIATION,
		FORMAT(SUM(BOOKVALUE- DEPRECIATION_VALUE),'N2') NETBOOKVALUE
	FROM #DATA
	GROUP BY [POOL],
		ACID,
		ACCOUNTHEADING,
		ASSETCODE,
		ASSET_NAME

		SELECT 'TOTAL'[POOL],
		NULL ACID,
		NULL ACCOUNTHEADING,
		NULL ASSETCODE,
		NULL ASSET_NAME,
		FORMAT( SUM(CASE 
				WHEN ASSETMON = 0
					THEN BOOKVALUE
				ELSE 0
				END),'N2') [ OPENING],
		FORMAT(SUM(CASE 
				WHEN ASSETMON <> 0
					THEN BOOKVALUE
				ELSE 0
				END),'N2') [ ADDITION],
		FORMAT(SUM(BOOKVALUE),'N2') [ TOTALBOOKVALUE],
		FORMAT(SUM(   [ SHRAWAN]),'N2') [ SHRAWAN],
		FORMAT(SUM([ BHADRA]),'N2') [ BHADRA],
		FORMAT(SUM( [ ASOJ]),'N2') [ ASOJ],
		FORMAT(SUM([ KARTIK]) ,'N2')[ KARTIK],
		FORMAT(SUM([ MANGSIR]) ,'N2')[ MANGSIR],
		FORMAT(SUM([ POUSH]) ,'N2')[ POUSH],
		FORMAT(SUM([ MAGH]) ,'N2')[ MAGH],
		FORMAT(SUM([ FAGUN]),'N2') [ FAGUN],
		FORMAT(SUM([ CHAITRA]) ,'N2')[ CHAITRA],
		FORMAT(SUM([ BAISAKH]),'N2') [ BAISAKH],
		FORMAT(SUM([ JESTHA]),'N2') [ JESTHA],
		FORMAT(SUM([ ASAR]),'N2') [ ASAR],
		FORMAT(SUM(DEPRECIATION_VALUE),'N2') TOTAL_DEPRECIATION,
		FORMAT(SUM(BOOKVALUE- DEPRECIATION_VALUE),'N2') NETBOOKVALUE
	FROM #DATA
 
END

IF @MODE = 4
BEGIN
	SELECT [POOL],
		ACID,
		ACCOUNTHEADING,
		ASSETCODE,
		ASSET_NAME,
		AssetID,
		PURCHASEDATE,
		DESCRIPTIONS,
		FORMAT(SUM(CASE 
				WHEN ASSETMON = 0
					THEN BOOKVALUE
				ELSE 0
				END),'N2') [ OPENING],
		FORMAT(SUM(CASE 
				WHEN ASSETMON <> 0
					THEN BOOKVALUE
				ELSE 0
				END),'N2') [ ADDITION],
		FORMAT(SUM(BOOKVALUE),'N2') [ TOTALBOOKVALUE],
		FORMAT(SUM(   [ SHRAWAN]),'N2') [ SHRAWAN],
		FORMAT(SUM([ BHADRA]),'N2') [ BHADRA],
		FORMAT(SUM( [ ASOJ]),'N2') [ ASOJ],
		FORMAT(SUM([ KARTIK]) ,'N2')[ KARTIK],
		FORMAT(SUM([ MANGSIR]) ,'N2')[ MANGSIR],
		FORMAT(SUM([ POUSH]) ,'N2')[ POUSH],
		FORMAT(SUM([ MAGH]) ,'N2')[ MAGH],
		FORMAT(SUM([ FAGUN]),'N2') [ FAGUN],
		FORMAT(SUM([ CHAITRA]) ,'N2')[ CHAITRA],
		FORMAT(SUM([ BAISAKH]),'N2') [ BAISAKH],
		FORMAT(SUM([ JESTHA]),'N2') [ JESTHA],
		FORMAT(SUM([ ASAR]),'N2') [ ASAR],
		FORMAT(SUM(DEPRECIATION_VALUE),'N2') TOTAL_DEPRECIATION,
		FORMAT(SUM(BOOKVALUE- DEPRECIATION_VALUE),'N2') NETBOOKVALUE
	FROM #DATA
	GROUP BY [POOL],
		ACID,
		ACCOUNTHEADING,
		ASSETCODE,
		ASSET_NAME,
		AssetID,
		PURCHASEDATE,
		DESCRIPTIONS




		SELECT 'Total' [POOL],
		NULL ACID,
		NULL ACCOUNTHEADING,
		NULL ASSETCODE,
		NULL ASSET_NAME,
		NULL AssetID,
		NULL PURCHASEDATE,
		NULL DESCRIPTIONS,
		FORMAT(SUM(CASE 
				WHEN ASSETMON = 0
					THEN BOOKVALUE
				ELSE 0
				END),'N2') [ OPENING],
		FORMAT(SUM(CASE 
				WHEN ASSETMON <> 0
					THEN BOOKVALUE
				ELSE 0
				END),'N2') [ ADDITION],
		FORMAT(SUM(BOOKVALUE),'N2') [ TOTALBOOKVALUE],
		FORMAT(SUM(   [ SHRAWAN]),'N2') [ SHRAWAN],
		FORMAT(SUM([ BHADRA]),'N2') [ BHADRA],
		FORMAT(SUM( [ ASOJ]),'N2') [ ASOJ],
		FORMAT(SUM([ KARTIK]) ,'N2')[ KARTIK],
		FORMAT(SUM([ MANGSIR]) ,'N2')[ MANGSIR],
		FORMAT(SUM([ POUSH]) ,'N2')[ POUSH],
		FORMAT(SUM([ MAGH]) ,'N2')[ MAGH],
		FORMAT(SUM([ FAGUN]),'N2') [ FAGUN],
		FORMAT(SUM([ CHAITRA]) ,'N2')[ CHAITRA],
		FORMAT(SUM([ BAISAKH]),'N2') [ BAISAKH],
		FORMAT(SUM([ JESTHA]),'N2') [ JESTHA],
		FORMAT(SUM([ ASAR]),'N2') [ ASAR],
		FORMAT(SUM(DEPRECIATION_VALUE),'N2') TOTAL_DEPRECIATION,
		FORMAT(SUM(BOOKVALUE- DEPRECIATION_VALUE),'N2') NETBOOKVALUE
	FROM #DATA
 
END

 
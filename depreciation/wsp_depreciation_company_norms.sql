CREATE OR ALTER PROC WSP_DEPRECIATION_COMPANY_NORMS

--DECLARE 
@POOL VARCHAR(25)='%', --POOL (ASSET_GROUP)
@ITEM VARCHAR(50)='%', --ASSET CODE (ASSET MENUITEM MCODE)
@BLOCK VARCHAR(50)='%', --BLOCK (RMD_ACLIST)
@PHISCALID VARCHAR(25)='%',
@ASSETID VARCHAR(100)='%',--ASSET ID(ASSET MASTER)
@MODE TINYINT =1  --1 : DEPRECIATION POOLWISE || 2 DEPN ACCOUNT HEADWISE || 3 DEPN ITEMWISE || 4 DEPN ASSETID WISE
AS
--SELECT @PHISCALID='80/81',@MODE=1
IF OBJECT_ID('tempdb..#DATA') is not null drop table #DATA
	SELECT AG.GROUPNAME [POOL],DP.AssetID ,DP.BOOKVALUE,DP.ORIGNALCOST,DP.MON,DP.DEPRECIATION_VALUE ,DP.PHISCALID ,AD.MON ASSETMON,DP.NETBOOKVALUE,RA.ACNAME ACCOUNTHEADING ,DP.ACID,ASM.MENUCODE ASSETCODE,ASM.DESCA ASSET_NAME,ASM.DESCRIPTION DESCRIPTIONS,BMA.BATCHCREATEDATE PURCHASEDATE
	INTO #DATA 
	FROM DEPRECIATION DP WITH (NOLOCK)
	LEFT JOIN ASSET_GROUP_LEDGER AGL WITH (NOLOCK) ON AGL.ACID=DP.ACID
	LEFT JOIN ASSET_GROUP AG WITH (NOLOCK) ON AG.ASSETGROUPID=  AGL.ASSETGROUPID
	LEFT JOIN ASSETCODE_MASTER AM  WITH (NOLOCK) ON AM.MCODE=DP.MCODE AND AM.ASSETID=DP.ASSETID  
	LEFT JOIN ASSETCODE_DETAIL AD  WITH (NOLOCK) ON AM.ASSETID= AD.ASSETID AND AM.BATCHCODE=AD.BATCHCODE
	LEFT JOIN RMD_ACLIST RA WITH (NOLOCK) ON RA.ACID=DP.ACID
	LEFT JOIN ASSET_MENUITEM ASM WITH (NOLOCK) ON ASM.MCODE=DP.MCODE
	LEFT JOIN BATCHPRICE_MASTER_ASSET BMA WITH (NOLOCK) ON BMA.BATCHCODE=DP.BATCHCODE AND BMA.MCODE=DP.MCODE
	WHERE DP.PHISCALID=@PHISCALID
	AND AGL.ASSETGROUPID LIKE @POOL 
	AND AM.MCODE LIKE @ITEM   
	AND DP.ACID LIKE @BLOCK
	AND DP.ASSETID LIKE @ASSETID
	 
	  
	 
	 IF @MODE=1 
	 BEGIN 
  
	 SELECT [POOL] ,SUM(CASE WHEN  ASSETMON=0 THEN BOOKVALUE  ELSE  0 END ) [ASSET~OPENING],
	 SUM(CASE WHEN  ASSETMON<>0 THEN BOOKVALUE  ELSE  0 END ) [ASSET~ADDITION],
	 SUM(BOOKVALUE) [ASSET~TOTALBOOKVALUE],
	 SUM(CASE WHEN MON=1 THEN DEPRECIATION_VALUE ELSE 0 END ) [DEPRECIATION FOR THE MONTH OF ~SHRAWAN],
	 SUM(CASE WHEN MON=2 THEN DEPRECIATION_VALUE ELSE 0 END ) [DEPRECIATION FOR THE MONTH OF ~BHADRA] ,
	 SUM(CASE WHEN MON=3 THEN DEPRECIATION_VALUE ELSE 0 END ) [DEPRECIATION FOR THE MONTH OF ~ASOJ],
	 SUM(CASE WHEN MON=4 THEN DEPRECIATION_VALUE ELSE 0 END ) [DEPRECIATION FOR THE MONTH OF ~KARTIK],
	 SUM(CASE WHEN MON=5 THEN DEPRECIATION_VALUE ELSE 0 END ) [DEPRECIATION FOR THE MONTH OF ~MANGSIR],
	 SUM(CASE WHEN MON=6 THEN DEPRECIATION_VALUE ELSE 0 END ) [DEPRECIATION FOR THE MONTH OF ~POUSH],
	 SUM(CASE WHEN MON=7 THEN DEPRECIATION_VALUE ELSE 0 END ) [DEPRECIATION FOR THE MONTH OF ~MAGH],
	 SUM(CASE WHEN MON=8 THEN DEPRECIATION_VALUE ELSE 0 END ) [DEPRECIATION FOR THE MONTH OF ~FAGUN],
	 SUM(CASE WHEN MON=9 THEN DEPRECIATION_VALUE ELSE 0 END ) [DEPRECIATION FOR THE MONTH OF ~CHAITRA],
	 SUM(CASE WHEN MON=10 THEN DEPRECIATION_VALUE ELSE 0 END ) [DEPRECIATION FOR THE MONTH OF ~BAISAKH],
	 SUM(CASE WHEN MON=11 THEN DEPRECIATION_VALUE ELSE 0 END ) [DEPRECIATION FOR THE MONTH OF ~JESTHA],
	 SUM(CASE WHEN MON=12 THEN DEPRECIATION_VALUE ELSE 0 END ) [DEPRECIATION FOR THE MONTH OF ~ASAR] ,
	 SUM(DEPRECIATION_VALUE) TOTAL_DEPRECIATION,
	 SUM(NETBOOKVALUE) NETBOOKVALUE

	 from #DATA group by [POOL]

	 END
  
	 IF @MODE=2 
	 BEGIN 
  
	 SELECT [POOL],ACID,ACCOUNTHEADING ,SUM(CASE WHEN  ASSETMON=0 THEN BOOKVALUE  ELSE  0 END ) [BOOKVALUE~OPENING],
	 SUM(CASE WHEN  ASSETMON<>0 THEN BOOKVALUE  ELSE  0 END ) [BOOKVALUE~ADDITION],
	 SUM(BOOKVALUE) [BOOKVALUE~TOTALBOOKVALUE],
	 SUM(CASE WHEN MON=1 THEN DEPRECIATION_VALUE ELSE 0 END ) [DEPRECIATION FOR THE MONTH OF ~SHRAWAN],
	 SUM(CASE WHEN MON=2 THEN DEPRECIATION_VALUE ELSE 0 END ) [DEPRECIATION FOR THE MONTH OF ~BHADRA] ,
	 SUM(CASE WHEN MON=3 THEN DEPRECIATION_VALUE ELSE 0 END ) [DEPRECIATION FOR THE MONTH OF ~ASOJ],
	 SUM(CASE WHEN MON=4 THEN DEPRECIATION_VALUE ELSE 0 END ) [DEPRECIATION FOR THE MONTH OF ~KARTIK],
	 SUM(CASE WHEN MON=5 THEN DEPRECIATION_VALUE ELSE 0 END ) [DEPRECIATION FOR THE MONTH OF ~MANGSIR],
	 SUM(CASE WHEN MON=6 THEN DEPRECIATION_VALUE ELSE 0 END ) [DEPRECIATION FOR THE MONTH OF ~POUSH],
	 SUM(CASE WHEN MON=7 THEN DEPRECIATION_VALUE ELSE 0 END ) [DEPRECIATION FOR THE MONTH OF ~MAGH],
	 SUM(CASE WHEN MON=8 THEN DEPRECIATION_VALUE ELSE 0 END ) [DEPRECIATION FOR THE MONTH OF ~FAGUN],
	 SUM(CASE WHEN MON=9 THEN DEPRECIATION_VALUE ELSE 0 END ) [DEPRECIATION FOR THE MONTH OF ~CHAITRA],
	 SUM(CASE WHEN MON=10 THEN DEPRECIATION_VALUE ELSE 0 END ) [DEPRECIATION FOR THE MONTH OF ~BAISAKH],
	 SUM(CASE WHEN MON=11 THEN DEPRECIATION_VALUE ELSE 0 END ) [DEPRECIATION FOR THE MONTH OF ~JESTHA],
	 SUM(CASE WHEN MON=12 THEN DEPRECIATION_VALUE ELSE 0 END ) [DEPRECIATION FOR THE MONTH OF ~ASAR] ,
	 SUM(DEPRECIATION_VALUE) TOTAL_DEPRECIATION,
	 SUM(NETBOOKVALUE) NETBOOKVALUE

	 from #DATA group by [POOL],ACID,ACCOUNTHEADING

	 END
	IF @MODE=3 
	BEGIN
	 SELECT [POOL],ACID,ACCOUNTHEADING,ASSETCODE,ASSET_NAME,SUM(CASE WHEN  ASSETMON=0 THEN BOOKVALUE  ELSE  0 END ) [BOOKVALUE~OPENING],
	 SUM(CASE WHEN  ASSETMON<>0 THEN BOOKVALUE  ELSE  0 END ) [BOOKVALUE~ADDITION],
	 SUM(BOOKVALUE) [BOOKVALUE~TOTALBOOKVALUE],
	 SUM(CASE WHEN MON=1 THEN DEPRECIATION_VALUE ELSE 0 END ) [DEPRECIATION FOR THE MONTH OF ~SHRAWAN],
	 SUM(CASE WHEN MON=2 THEN DEPRECIATION_VALUE ELSE 0 END ) [DEPRECIATION FOR THE MONTH OF ~BHADRA] ,
	 SUM(CASE WHEN MON=3 THEN DEPRECIATION_VALUE ELSE 0 END ) [DEPRECIATION FOR THE MONTH OF ~ASOJ],
	 SUM(CASE WHEN MON=4 THEN DEPRECIATION_VALUE ELSE 0 END ) [DEPRECIATION FOR THE MONTH OF ~KARTIK],
	 SUM(CASE WHEN MON=5 THEN DEPRECIATION_VALUE ELSE 0 END ) [DEPRECIATION FOR THE MONTH OF ~MANGSIR],
	 SUM(CASE WHEN MON=6 THEN DEPRECIATION_VALUE ELSE 0 END ) [DEPRECIATION FOR THE MONTH OF ~POUSH],
	 SUM(CASE WHEN MON=7 THEN DEPRECIATION_VALUE ELSE 0 END ) [DEPRECIATION FOR THE MONTH OF ~MAGH],
	 SUM(CASE WHEN MON=8 THEN DEPRECIATION_VALUE ELSE 0 END ) [DEPRECIATION FOR THE MONTH OF ~FAGUN],
	 SUM(CASE WHEN MON=9 THEN DEPRECIATION_VALUE ELSE 0 END ) [DEPRECIATION FOR THE MONTH OF ~CHAITRA],
	 SUM(CASE WHEN MON=10 THEN DEPRECIATION_VALUE ELSE 0 END ) [DEPRECIATION FOR THE MONTH OF ~BAISAKH],
	 SUM(CASE WHEN MON=11 THEN DEPRECIATION_VALUE ELSE 0 END ) [DEPRECIATION FOR THE MONTH OF ~JESTHA],
	 SUM(CASE WHEN MON=12 THEN DEPRECIATION_VALUE ELSE 0 END ) [DEPRECIATION FOR THE MONTH OF ~ASAR] ,
	 SUM(DEPRECIATION_VALUE) TOTAL_DEPRECIATION,
	 SUM(NETBOOKVALUE) NETBOOKVALUE

	 from #DATA group by [POOL],ACID,ACCOUNTHEADING,ASSETCODE,ASSET_NAME

	END

	IF @MODE=4
	BEGIN
	SELECT [POOL],ACID,ACCOUNTHEADING,ASSETCODE,ASSET_NAME,AssetID,PURCHASEDATE,DESCRIPTIONS,SUM(CASE WHEN  ASSETMON=0 THEN BOOKVALUE  ELSE  0 END ) [BOOKVALUE~OPENING],
	 SUM(CASE WHEN  ASSETMON<>0 THEN BOOKVALUE  ELSE  0 END ) [BOOKVALUE~ADDITION],
	 SUM(BOOKVALUE) [BOOKVALUE~TOTALBOOKVALUE], 
	 SUM(CASE WHEN MON=1 THEN DEPRECIATION_VALUE ELSE 0 END ) SHRAWAN,
	 SUM(CASE WHEN MON=2 THEN DEPRECIATION_VALUE ELSE 0 END ) BHADRA,
	 SUM(CASE WHEN MON=3 THEN DEPRECIATION_VALUE ELSE 0 END ) ASOJ,
	 SUM(CASE WHEN MON=4 THEN DEPRECIATION_VALUE ELSE 0 END ) KARTIK,
	 SUM(CASE WHEN MON=5 THEN DEPRECIATION_VALUE ELSE 0 END ) MANGSIR,
	 SUM(CASE WHEN MON=6 THEN DEPRECIATION_VALUE ELSE 0 END ) POUSH,
	 SUM(CASE WHEN MON=7 THEN DEPRECIATION_VALUE ELSE 0 END ) MAGH,
	 SUM(CASE WHEN MON=8 THEN DEPRECIATION_VALUE ELSE 0 END ) FAGUN,
	 SUM(CASE WHEN MON=9 THEN DEPRECIATION_VALUE ELSE 0 END ) CHAITRA,
	 SUM(CASE WHEN MON=10 THEN DEPRECIATION_VALUE ELSE 0 END ) BAISAKH,
	 SUM(CASE WHEN MON=11 THEN DEPRECIATION_VALUE ELSE 0 END ) JESTHA,
	 SUM(CASE WHEN MON=12 THEN DEPRECIATION_VALUE ELSE 0 END ) ASAR ,
	 SUM(DEPRECIATION_VALUE) TOTAL_DEPRECIATION,
	 SUM(NETBOOKVALUE) NETBOOKVALUE

	 from #DATA group by [POOL],ACID,ACCOUNTHEADING,ASSETCODE,ASSET_NAME,AssetID,PURCHASEDATE,DESCRIPTIONS
	END


	  SELECT NULL
  
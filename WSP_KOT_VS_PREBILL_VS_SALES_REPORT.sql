CREATE OR ALTER PROCEDURE WSP_KOT_VS_PREBILL_VS_SALES_REPORT
--DECLARE
@DATE1 DATETIME,
@DATE2 DATETIME
AS
DECLARE @RESULT TABLE (SNO  VARCHAR(100),	TRNDATE  VARCHAR(100),	 BSDATE	 VARCHAR(100),TABLENO VARCHAR(200),	KOTID  VARCHAR(100),	STATUS VARCHAR(100),	PREBILL1  VARCHAR(100),	PREBILL1_REMARKS VARCHAR(500),	PREBILL1_NETAMNT VARCHAR(100),	PREBILL2  VARCHAR(200),	PREBILL2_REMARKS  VARCHAR(500),	PREBILL_NETAMNT VARCHAR(100),	PREBILL3 VARCHAR(100),	PREBILL3_REMARKS	 VARCHAR(100),PREBILL3_NETAMNT	 VARCHAR(100), [BILL NO] VARCHAR(100),	[BILL AMOUNT]  VARCHAR(100))
--SELECT @DATE1='2023-01-01',@DATE2='2023-06-01'

INSERT INTO @RESULT
EXEC RSP_KOT_VS_PREBILL_VS_SALES_REPORT 
@DATE1=@DATE1,
@DATE2=@DATE2


SELECT * ,COUNT(*) OVER()ALLCOUNT FROM @RESULT

 
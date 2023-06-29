CREATE OR ALTER   PROC [dbo].[WSP_FoodCosting]
--DECLARE
@DATE1 DATE,
@DATE2 DATE,
@DIVISION VARCHAR(3) = '%' 
AS
DECLARE @RESULT TABLE (RECEIPEMCODE VARCHAR(200),MENUCODE VARCHAR(200),DESCA VARCHAR(1000),SOLDQTY VARCHAR(200),SOLDAMOUNT VARCHAR(200),IdealConsumption varchar(200),IdealFoodCost varchar(200),AdjAmount varchar(200),ActualFoodCost varchar(200))
--SELECT @DATE1='2023-04-01',@DATE2='2023-06-01'

insert @RESULT
EXEC RSP_FoodCosting
@DATE1=@DATE1,
@DATE2=@DATE2,
@DIVISION=@DIVISION
 

 select *,count(*) over() from @RESULT


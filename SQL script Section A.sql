
--enable CDC
USE   [Sales]
    GO   
    EXEC sys.sp_cdc_enable_db   
    GO

	USE  [Sales]
    GO   
    SELECT [name], is_tracked_by_cdc   
    FROM sys.tables   
    GO     

	 USE Sales
    GO   
    EXEC sys.sp_cdc_enable_table      
         @source_name = N'Customer', 
		 @source_schema = N'dbo',
         @role_name     = Null
    GO  

	
	--Select from both tables--

	USE Sales   
    GO   
    SELECT *   
    FROM dbo.Customer   
    GO   
    USE Sales   
    GO   
    SELECT *   
    FROM cdc.dbo_Customer_CT  
    GO
	
	--Insert--------------------------------------------------
	USE Sales   
    GO   
    INSERT INTO [dbo].[Customer]   
    ([CustID],[CustName],[RepCode],[Channel])   
    VALUES ('LN0146','Yapa Baker','1821','Craft')   
    GO  
	
	--USE Sales   
    --GO   
    --INSERT INTO [dbo].[Customer]   
    --([CustID],[CustName],[RepCode],[Channel])   
    --VALUES ('LN0301','Shades Baker','1891','Craft')   
    --GO  

	
	--SELECT from both tables-------------
	
	USE Sales   
    GO   
    SELECT *   
    FROM dbo.Customer   
    GO   
    USE Sales   
    GO   
    SELECT *   
    FROM cdc.dbo_Customer_CT   
    GO 
	
	
		--Update Operation

  USE Sales 
  GO  
  UPDATE dbo.Customer 
  SET CustName = ' New Yapa Bakers' , 
      Channel = 'Tier1'
  WHERE CustID = 'LN0146'
  GO    
  
  
  --SELECT from both tables -------------
	
	USE Sales   
    GO   
    SELECT *   
    FROM dbo.Customer   
    GO   
    USE Sales   
    GO   
    SELECT *   
    FROM cdc.dbo_Customer_CT   
    GO 


	--Delete Operation

	USE Sales   
    GO   
    DELETE   
    FROM [dbo].[Customer]   
    WHERE CustID = 'LN0146'  
    GO   
	    
	

--SELECT from both tables-------------
	
	USE Sales   
    GO   
    SELECT *   
    FROM dbo.Customer   
    GO   
    USE Sales   
    GO   
    SELECT *   
    FROM cdc.dbo_Customer_CT   
    GO 



-- all the data in the table cdc.lsn_time_mapping.

	USE Sales 
    GO   
    SELECT *   
    FROM cdc.lsn_time_mapping   
    GO   


 --Changing capture retention period --
USE Sales  
 GO   

SELECT ([retention])/((60*24)) AS Default_Retention_days ,*
FROM msdb.dbo.cdc_jobs
go

EXEC Sales.sys.sp_cdc_change_job 
@job_type=N'Cleanup'
,@retention=172800 -- <60 min *24 hrs * 120 days >
go

SELECT ([retention])/((60*24)) AS Default_Retention_days ,*
FROM msdb.dbo.cdc_jobs
Go


	--retrieve the data that was modified in past 1 month

    USE Sales  
    GO   
    DECLARE @begin_time DATETIME, @end_time DATETIME, @begin_lsn BINARY(10), @end_lsn BINARY(10);   
    SELECT @begin_time = GETDATE()-30,@end_time = GETDATE();   
    SELECT @begin_lsn = sys.fn_cdc_map_time_to_lsn('smallest greater than', @begin_time);   
    SELECT @end_lsn = sys.fn_cdc_map_time_to_lsn('largest less than or equal', @end_time);   
    SELECT *   
    FROM [cdc].[fn_cdc_get_all_changes_dbo_Customer](@begin_lsn,@end_lsn,'all')   
    GO   



	--insert new column 
	ALTER TABLE dbo.Customer	
    ADD CreditPeriod int

	--SELECT from both tables------------
	
	USE Sales   
    GO   
    SELECT *   
    FROM dbo.Customer   
    GO   
    USE Sales   
    GO   
    SELECT *   
    FROM cdc.dbo_Customer_CT   
    GO 
	

	--Creatinq a new capture instance

	EXEC sp_cdc_enable_table
    @source_schema = N'dbo',
    @source_name = N'Customer',
    @role_name = sa,
    @capture_instance = 'Customer_CT2'

	
	Select * from cdc.dbo_Customer_CT
	Select * from [cdc].[Customer_CT2_CT]

--insert data from 1st capture instance to second capture instance--

	INSERT INTO [cdc].[Customer_CT2_CT]
(__$start_lsn, __$end_lsn,__$seqval,__$operation,__$update_mask,CustID,CustName,RepCode,Channel)
SELECT
    __$start_lsn, 
    __$end_lsn,
    __$seqval,
    __$operation,
    __$update_mask,
    CustID,
    CustName,
	RepCode,
	Channel
FROM [cdc].[dbo_Customer_CT]

Select * from [cdc].[Customer_CT2_CT]

--insert a new recode 

INSERT INTO Customer 
    (CustID, CustName,RepCode,Channel,CreditPeriod) 
VALUES 
    ('LK0161','Kalbo Bakers','1240','Craft',30)


select * from [cdc].[dbo_Customer_CT]
Select * from [cdc].[Customer_CT2_CT]


	-- all the three required information for disabling CDC on a table. 

	USE Sales;   
    GO   
    EXEC sys.sp_cdc_help_change_data_capture   
    GO

	--disabling 1st capture instance


	USE Sales;  
    GO  
	EXEC sp_cdc_disable_table
    @source_schema = N'dbo',
    @source_name = N'Customer',
    @capture_instance = 'dbo_Customer'
	GO

	
   

--disable tracking of the table-- 

    USE Sales;  
    GO  
    EXECUTE sys.sp_cdc_disable_table  
    @source_schema = N'dbo',  
    @source_name = N'Customer',  
    @capture_instance = N'dbo_Customer';  
    GO   

	 -- disable CDC on the whole database--
 USE Sales  
 GO   
 EXEC sys.sp_cdc_disable_db   
 GO 
 
 

 

	

/*
==========================================================================
Stored Procedure: Load Bronze Layer (Source-> Bronze)
==========================================================================
Script Purpose: This stored procedure loads raw data into the bronze schema from external csv files.
  It performs the following actions:
    -Truncates the bronze table before loading the data
    -Uses the bulk insert command to load the data from csv files into the bronze tables

Parameters:
  None.
  This stored procedure does not accept any parameter or return any values.

Example usage
  EXEC bronze.load_bronze
===========================================================================
*/



--Doing  a bulk insert to load the csv files into the db

CREATE OR ALTER PROCEDURE bronze.load_bronze AS
BEGIN
	DECLARE @start_time DATETIME, @end_time DATETIME, @batch_start_time DATETIME, @batch_end_time DATETIME;
	BEGIN TRY
		SET @batch_start_time = GETDATE();
		PRINT'============================================================';
		PRINT'Loading the Bronze Layer';
		PRINT'============================================================';
	
	
	
		PRINT'============================================================';
		PRINT 'Loading the CRM Tables';
		PRINT'============================================================';
	
		SET @start_time = GETDATE();
		PRINT '>> Truncating Table: bronze.crm_cust_info';
		TRUNCATE TABLE bronze.crm_cust_info; --This ensures you do not have duplicates in your db if you run your script multiple times for the full load

	
		PRINT '>> Inserting Data Into: bronze.crm_cust_info';
		BULK INSERT bronze.crm_cust_info
		FROM 'C:\Users\yetty\OneDrive\Desktop\Personal Projects\CRM_ERP_MIGRATION\Source_Data\files\cust_info.csv'
		WITH (
		FIRSTROW = 2,
		FIELDTERMINATOR = ',',
		TABLOCK
		);
		SET @end_time = GETDATE();
		PRINT'>> Load Duration:' + CAST(DATEDIFF(second, @start_time,@end_time) AS NVARCHAR) + ' seconds';
		PRINT'>> -------------';


		SET @start_time = GETDATE();
		PRINT '>> Truncating Table: bronze.crm_sales_details';

		TRUNCATE TABLE bronze.crm_sales_details;

		PRINT '>> Inserting Data Into: bronze.crm_sales_details';

		BULK INSERT bronze.crm_sales_details
		FROM 'C:\Users\yetty\OneDrive\Desktop\Personal Projects\CRM_ERP_MIGRATION\Source_Data\files\sales_details.csv'
		WITH (
		FIRSTROW = 2,
		KEEPNULLS,
		FIELDTERMINATOR = ',',
		TABLOCK
		);
		SET @end_time = GETDATE();
		PRINT'>> Load Duration:' + CAST(DATEDIFF(second, @start_time,@end_time) AS NVARCHAR) + ' seconds';
		PRINT'>> -------------';



		SET @start_time = GETDATE();
		PRINT '>> Truncating Table: bronze.crm_prd_info';

		TRUNCATE TABLE bronze.crm_prd_info;

		PRINT '>> Inserting Data Into: bronze.crm_prd_info';

		BULK INSERT bronze.crm_prd_info
		FROM 'C:\Users\yetty\OneDrive\Desktop\Personal Projects\CRM_ERP_MIGRATION\Source_Data\files\prd_info.csv'
		WITH (
		FIRSTROW = 2,
		FIELDTERMINATOR = ',',
		TABLOCK
		);
		SET @end_time = GETDATE();
		PRINT'>> Load Duration:' + CAST(DATEDIFF(second, @start_time,@end_time) AS NVARCHAR) + ' seconds';
		PRINT'>> -------------';



		PRINT'============================================================';
		PRINT 'Loading the ERP Tables';
		PRINT'============================================================';

		SET @start_time = GETDATE();
		PRINT '>> Truncating Table: bronze.erp_cust_az12';
		TRUNCATE TABLE bronze.erp_cust_az12;

		PRINT '>> Inserting Data Into: bronze.erp_cust_az12';
		BULK INSERT bronze.erp_cust_az12
		FROM 'C:\Users\yetty\OneDrive\Desktop\Personal Projects\CRM_ERP_MIGRATION\Source_Data\files\CUST_AZ12.csv'
		WITH (
		FIRSTROW = 2,
		FIELDTERMINATOR = ',',
		TABLOCK
		);
		SET @end_time = GETDATE();
		PRINT'>> Load Duration:' + CAST(DATEDIFF(second, @start_time,@end_time) AS NVARCHAR) + ' seconds';
		PRINT'>> -------------';



		SET @start_time = GETDATE();
		PRINT '>> Truncating Table: bronze.erp_px_cat_g1v2';

		TRUNCATE TABLE bronze.erp_px_cat_g1v2;

		PRINT '>> Inserting Data Into: bronze.erp_px_cat_g1v2';

		BULK INSERT bronze.erp_px_cat_g1v2
		FROM 'C:\Users\yetty\OneDrive\Desktop\Personal Projects\CRM_ERP_MIGRATION\Source_Data\files\PX_CAT_G1V2.csv'
		WITH (
		FIRSTROW = 2,
		FIELDTERMINATOR = ',',
		TABLOCK
		);
		SET @end_time = GETDATE();
		PRINT'>> Load Duration:' + CAST(DATEDIFF(second, @start_time,@end_time) AS NVARCHAR) + ' seconds';
		PRINT'>> -------------';



		SET @start_time = GETDATE();
		PRINT '>> Truncating Table: bronze.erp_loc_a101';

		TRUNCATE TABLE bronze.erp_loc_a101;

		PRINT '>> Inserting Data Into: bronze.erp_loc_a101';

		BULK INSERT bronze.erp_loc_a101
		FROM 'C:\Users\yetty\OneDrive\Desktop\Personal Projects\CRM_ERP_MIGRATION\Source_Data\files\LOC_A101.csv'
		WITH (
		FIRSTROW = 2,
		FIELDTERMINATOR = ',',
		TABLOCK
		);
		SET @end_time = GETDATE();
		PRINT'>> Load Duration:' + CAST(DATEDIFF(second, @batch_start_time,@batch_end_time) AS NVARCHAR) + ' seconds';
		PRINT'>> -------------';


		SET @batch_end_time = GETDATE();
		PRINT'====================================='
		PRINT'Loading Bronze Layer Completed'
		PRINT'>> Total Load Duration:' + CAST(DATEDIFF(second, @start_time,@end_time) AS NVARCHAR) + ' seconds';
		PRINT'====================================='


	END TRY
	BEGIN CATCH 
		PRINT '===================================='
		PRINT 'Error occurred while loading the bronze layer'
		PRINT 'Error Message' + ERROR_MESSAGE();
		PRINT 'Error Message' + CAST (ERROR_NUMBER() AS NVARCHAR);
		PRINT 'Error Message' + CAST (ERROR_STATE() AS NVARCHAR);
		PRINT '===================================='
	END CATCH
END

/**
 * David Chamberlain
 * Searches for a word in all columns in all tables
 *
 * Date: 2022-12-07
 */

DECLARE @TableName nvarchar(max), 
        @ColumnName nvarchar(max), 
        @SQL nvarchar(max), 
        @Search nvarchar(max)
DECLARE	@RESULTS TABLE (
			TableName nvarchar(max), 
			ColumnName nvarchar(max), 
			ColumnVal nvarchar(max), 
			ValCount INT
        )
----------------------------------------------------------------------
SET 
    @Search = 'SEARCHTERM' --<-- enter value to be searched here
----------------------------------------------------------------------
SET
	@TableName = ''
SET
    @Search = '%' + @Search + '%'

-- Cycle tables ----------------------------------------------------------------------
WHILE @TableName IS NOT NULL BEGIN 
	SET 
		@ColumnName = '' 
	SET 
		@TableName = (
		SELECT 
			MIN(TABLE_NAME) 
		FROM 
			INFORMATION_SCHEMA.TABLES 
		WHERE 
			TABLE_TYPE = 'BASE TABLE' 
			AND TABLE_NAME > @TableName
	)

	--Cycle Columns ----------------------------------------------------------------------
	WHILE
		@TableName IS NOT NULL 
		AND @ColumnName IS NOT NULL
	BEGIN 
		SET @ColumnName = (
			SELECT 
				MIN(COLUMN_NAME) 
			FROM 
				INFORMATION_SCHEMA.COLUMNS 
			WHERE 
				TABLE_NAME = @TableName 
				AND DATA_TYPE IN (
				'char', 'varchar', 'nchar', 'nvarchar', 
				'int', 'decimal', 'datetime', 'numeric'
				) 
				AND COLUMN_NAME > @ColumnName
		)

		IF @ColumnName IS NOT NULL BEGIN
			-- Generate SQL Scripts ----------------------------------------------------------------------
			SET 
			@SQL = N'   
				SELECT ''' + @TableName + ''', ''' + @ColumnName + ''', [' + @ColumnName + '], COUNT([' + @ColumnName + '])
				FROM [' + @TableName + ']
				WHERE [' + @ColumnName + '] LIKE @Search
				GROUP BY [' + @ColumnName + ']'

			-- Execute SQL and Insert Data to Results ----------------------------------------------------------------------
			--PRINT @SQL
			INSERT INTO @RESULTS 
			EXEC sp_executeSQL @SQL, N'@Search nvarchar(max)', @Search
		END
	END
END

-- Display the results ----------------------------------------------------------------------
SELECT 
	R.* 
FROM 
	@RESULTS R
ORDER BY 
	R.TableName, 
	R.ColumnName, 
	R.ValCount DESC

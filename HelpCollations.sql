/**
 * 
 * Returns the current database collation
 * and lists other collations and the description.
 * Written on SQL Server 2019 (15.0.4261.1)
 * 
 * Date: 2023-08-16
 */
SELECT
	CASE
		WHEN CONVERT(VARCHAR(256), SERVERPROPERTY('COLLATION')) = [NAME] THEN 
		CONVERT(VARCHAR(256), SERVERPROPERTY('COLLATION')) 
	ELSE [NAME] END [NAME], 
	[DESCRIPTION]
FROM
	fn_HelpCollations()
ORDER BY
	CASE WHEN CONVERT(VARCHAR(256), SERVERPROPERTY('COLLATION')) = [NAME] THEN 0 ELSE 1 END, [NAME]

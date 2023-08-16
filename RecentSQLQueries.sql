/**
 * David Chamberlain
 * Returns recently run SQL queries.
 * You set the @DB variable to the database you want to see the queries against.
 * 
 * Date: 2022-12-12
 */
DECLARE @DB NVARCHAR(50) = 'DATABASE'

USE [MASTER]

SELECT 
TOP(100)
DB.NAME,
T.[TEXT], S.LAST_EXECUTION_TIME,
S.LAST_ELAPSED_TIME, S.LAST_ELAPSED_TIME/1000000.0 LAST_ELAPSED_TIME_IN_S, 
S.LAST_WORKER_TIME, S.LAST_WORKER_TIME/1000000.0 LAST_WORKER_TIME_IN_S,
S.MAX_WORKER_TIME, S.MAX_WORKER_TIME/1000000.0 MAX_WORKER_TIME_IN_S,
S.MAX_ELAPSED_TIME, S.MAX_ELAPSED_TIME/1000000.0 MAX_ELAPSED_TIME_IN_S,
S.LAST_ROWS, S.MAX_ROWS, S.MIN_ROWS, S.TOTAL_ROWS
FROM
	SYS.DM_EXEC_CACHED_PLANS AS P
INNER JOIN
	SYS.DM_EXEC_QUERY_STATS AS S ON P.PLAN_HANDLE = S.PLAN_HANDLE
CROSS APPLY
	SYS.DM_EXEC_SQL_TEXT(P.PLAN_HANDLE) AS T
INNER JOIN
	SYS.DATABASES DB ON DB.DATABASE_ID = T.DBID AND DB.NAME = @DB
ORDER BY
	S.LAST_ELAPSED_TIME DESC;
/**
 * David Chamberlain
 * This script will allow you to find a table, view, trigger or stored procedure anywhere on the entire SQL server.
 *
 * 2022-11-25
 */
USE [master]
GO

--Set the @FindThis variable to either a TABLE, VIEW, TRIGGER or STORED PROCEDURE
DECLARE @FindThis VARCHAR(100) = 'mobile_IssueStock'

DECLARE @SQL NVARCHAR(MAX) = 'IF EXISTS
    (
        SELECT  1 
        FROM    [?].SYS.OBJECTS 
        WHERE   NAME = '''+@FindThis+'''
    )
    SELECT 
        ''?''       AS DB, 
        NAME        AS NAME, 
        TYPE_DESC   AS TYPE 
    FROM [?].SYS.OBJECTS 
    WHERE NAME = '''+@FindThis+''''
EXEC sp_MSforeachdb @SQL


/*********************************************************************************

SQLHACK DB ENVIORNMENT RESET - MANAGED INSTANCE SCRIPT
======================================================

RUN AGAINST: SQL MI 

PURPOSE: 
1. Checks it's being run against the SQL Managed Instance 
2. Runs a test version of the DROP statement to make sure it drops the correct DBs
3. Commented out version of the DROP DBs statement that does actually drop all the DBs
4. Drop all TEAMXX sql logins so DMS doesn’t moan when you re-migrate DBs & logins

*********************************************************************************/

/* 
1. Check connected to the SQL Managed Instance 
*/
IF @@SERVERNAME NOT LIKE 'sqlhackmi-%.database.windows.net'
   RAISERROR('*** NOT CONNECTED TO SQL MANAGED INSTANCE ***', 20, 1) WITH LOG;


/*
2. Run a test version of the DROP statement to make sure it drops the correct DBs

RUN THIS TO MAKE SURE YOU'RE ONLY DROPPING THE CORRECT DATABASES:
*/

DECLARE @command nvarchar(max)
SET @command = ''

SELECT  @command = @command
+ 'DROP DATABASE [' + [name] +'];'+CHAR(13)+CHAR(10)
FROM  [master].[sys].[databases] 
WHERE [name]  NOT IN ('master','model','msdb','tempdb', 'SSISDB');

PRINT @COMMAND
GO

/*
3. Commented out version of the DROP DBs statement that drops all the DBs

ONLY RUN THIS ONCE YOU'VE TESTED USING ABOVE STATEMENT
*/
/*
DECLARE @command nvarchar(max)
SET @command = ''

SELECT  @command = @command
+ 'DROP DATABASE [' + [name] +'];'+CHAR(13)+CHAR(10)
FROM  [master].[sys].[databases] 
WHERE [name]  NOT IN ('master','model','msdb','tempdb', 'SSISDB');

EXECUTE sp_executesql @command
*/


/*
4. Drop all TEAMXX sql logins so DMS doens't moan when you re-migrate DBs & logins
*/
IF EXISTS (select loginname from master.dbo.syslogins where name = 'TEAM02') 
	DROP LOGIN TEAM02;
IF EXISTS (select loginname from master.dbo.syslogins where name = 'TEAM01') 
	DROP LOGIN TEAM01;
IF EXISTS (select loginname from master.dbo.syslogins where name = 'TEAM03') 
	DROP LOGIN TEAM03;
IF EXISTS (select loginname from master.dbo.syslogins where name = 'TEAM04') 
	DROP LOGIN TEAM04;
IF EXISTS (select loginname from master.dbo.syslogins where name = 'TEAM05') 
	DROP LOGIN TEAM05;
IF EXISTS (select loginname from master.dbo.syslogins where name = 'TEAM06') 
	DROP LOGIN TEAM06;
IF EXISTS (select loginname from master.dbo.syslogins where name = 'TEAM07') 
	DROP LOGIN TEAM07;
IF EXISTS (select loginname from master.dbo.syslogins where name = 'TEAM08') 
	DROP LOGIN TEAM08;
IF EXISTS (select loginname from master.dbo.syslogins where name = 'TEAM09') 
	DROP LOGIN TEAM09;
IF EXISTS (select loginname from master.dbo.syslogins where name = 'TEAM10') 
	DROP LOGIN TEAM10;
IF EXISTS (select loginname from master.dbo.syslogins where name = 'TEAM11') 
	DROP LOGIN TEAM11;
IF EXISTS (select loginname from master.dbo.syslogins where name = 'TEAM12') 
	DROP LOGIN TEAM12;
IF EXISTS (select loginname from master.dbo.syslogins where name = 'TEAM13') 
	DROP LOGIN TEAM13;
IF EXISTS (select loginname from master.dbo.syslogins where name = 'TEAM14') 
	DROP LOGIN TEAM14;
IF EXISTS (select loginname from master.dbo.syslogins where name = 'TEAM15') 
	DROP LOGIN TEAM15;
IF EXISTS (select loginname from master.dbo.syslogins where name = 'TEAM16') 
	DROP LOGIN TEAM16;
IF EXISTS (select loginname from master.dbo.syslogins where name = 'TEAM17') 
	DROP LOGIN TEAM17;
IF EXISTS (select loginname from master.dbo.syslogins where name = 'TEAM18') 
	DROP LOGIN TEAM18;
IF EXISTS (select loginname from master.dbo.syslogins where name = 'TEAM19') 
	DROP LOGIN TEAM19;
IF EXISTS (select loginname from master.dbo.syslogins where name = 'TEAM20') 
	DROP LOGIN TEAM20;

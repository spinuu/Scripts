DECLARE @name VARCHAR(50) -- database name  
DECLARE @path VARCHAR(256) -- path for backup files  
DECLARE @fileName VARCHAR(256) -- filename for backup  
DECLARE @fileDate VARCHAR(20) -- used for file name

 
-- specify database backup directory
SET @path = 'c:\backuplocation\'  

 
-- specify filename format
SELECT @fileDate = CONVERT(VARCHAR(20),GETDATE(),112) 

 
DECLARE db_cursor CURSOR FOR  
SELECT name 
FROM master.dbo.sysdatabases 
-- WHERE name NOT IN ('master','model','msdb','tempdb')  -- exclude these databases

 
OPEN db_cursor   
FETCH NEXT FROM db_cursor INTO @name   

 
WHILE @@FETCH_STATUS = 0   
BEGIN   
       SET @fileName = @path + @name + "_" + datename(dw, getdate()) + '.BAK'  
       BACKUP DATABASE @name TO DISK = @fileName  

 
       FETCH NEXT FROM db_cursor INTO @name   
END   

 
CLOSE db_cursor   
DEALLOCATE db_cursor

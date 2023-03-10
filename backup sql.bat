REM skrypt odpala skrypt sql backup_mssql_databases.sql w celu backupu
REM potem na podstawie dnia tygodnia przenosi do odpowiedniego katalogu

@echo off
del /F /Q "C:\backuplocatoion\*.bak"
sqlcmd -S SQLSERVER\SQL-i "C:\scriptslocation\backup_mssql_databases.sql" -o "c:\loglocation\output_Daily.txt"

for /F "skip=1" %%I in ('wmic path win32_localtime get dayofweek') do (set /a dow=%%I 2>NUL)
echo %dow%

if "%dow%"=="1" (
    echo Today is Monday.
    copy /y "C:\backuplocatoion\*" "\\remotebackuplocation\1.MONDAY"
) else if "%dow%"=="2" (
    echo Today is Tuesday.
    copy /y "C:\backuplocatoion\*" "\\remotebackuplocation\2.TUESDAY"
) else if "%dow%"=="3" (
    echo Today is Wednesday.
    copy /y "C:\backuplocatoion\*" "\\remotebackuplocation\3.WEDNESDAY"
) else if "%dow%"=="4" (
    echo Today is Thursday.
    copy /y "C:\backuplocatoion\*" "\\remotebackuplocation\4.THURSDAY"
) else if "%dow%"=="5" (
    echo Today is Friday.
    copy /y "C:\backuplocatoion\*" "\\remotebackuplocation\5.FRIDAY"
) else if "%dow%"=="6" (
    echo Today is Saturday.
    copy /y "C:\backuplocatoion\*" "\\remotebackuplocation\6.SATURDAY"
) else if "%dow%"=="0" (
    echo Today is Sunday.
    copy /y "C:\backuplocatoion\*" "\\remotebackuplocation\7.SUNDAY"
) else (
    goto end
)
:end

REM ze względów bezpieczeństwa nie zmieniam ustawień PS na stałe tylko odpalam skrypty tym batchem
@echo off
Powershell.exe -executionpolicy remotesigned -File "C:\script.ps1"
pause

@echo off
cls

rem make backup copy of file to be edited:
copy /Y csv-dataset-sources.csv csv-dataset-sources.backup.csv > nul

setlocal enabledelayedexpansion

set "search1=.xls.csv"
set "replace1=.xls"

set "search2=.xlsx.csv"
set "replace2=.xlsx"

set "search3=.xlsm.csv"
set "replace3=.xlsm"

set "textfile=csv-dataset-sources.csv"
set "newfile=csv-dataset-sources-edited.csv"

(for /f "delims=" %%i in (%textfile%) do (
    set "line=%%i"
    set "line=!line:%search1%=%replace1%!"
    set "line=!line:%search2%=%replace2%!"
    set "line=!line:%search3%=%replace3%!"
    echo(!line!
))>"%newfile%"

del %textfile%
rename %newfile% %textfile%

echo.
echo In file: csv-dataset-sources.csv
echo.
echo Renamed .xls.csv to .xls
echo Renamed .xlsx.csv to .xlsx
echo Renamed .xlsm.csv to .xlsm
echo.
echo Backup of original file saved as csv-dataset-sources.backup.csv

endlocal
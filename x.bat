@echo off
cls
setlocal EnableExtensions EnableDelayedExpansion

rem Set extension here:
set "extension=csv"
rem set "extension=json"
rem set "extension=xls"

rem Set starting folder number here (which corresponds to the line number in the *-dataset-sources.csv file):
set "starting_number=81"


set "file=master-!extension!.txt"
set /A i=0

echo Reading !file!...
for /F "usebackq delims=" %%a in ("%file%") do (
	set /A i+=1
	call set array[%%i%%]=%%a
	call set n=%%i%%
)

rem Create an array with filenames in right order
for /d %%f in ("sorted-!extension!/*") do (
   for /F "delims=-" %%n in ("%%f") do (
      set "number=00000%%n"
      set "file[!number:~-6!]=%%f"
   )
)

rem if exist !output_file! del /q !output_file!

set "chromepath=C:\Program Files (x86)\Google\Chrome\Application"
set "site=https://www.google.com"
set "command=search?q"

rem Process the filenames in right order
for /F "tokens=2 delims==" %%f in ('set file[') do (
	set subfolder=%%f
rem geq == greater than or equal to:
	if !subfolder! geq !starting_number! (
		echo --------------
		echo sorted-!extension!\!subfolder!
rem Capture first filename only (all files are identical, so only one is needed):
		for /f "delims=" %%g in ('dir "sorted-!extension!\!subfolder!\*.!extension!" /b /o-n') do set first_filename=%%g
rem Capture first line in file:
		set "first_line="
		set /p first_line=<"sorted-!extension!\!subfolder!\!first_filename!"
rem Capture second line in file:
		set "second_line="
		for /F "skip=1 delims=" %%i in (sorted-!extension!\!subfolder!\!first_filename!) do if not defined second_line set "second_line=%%i"

		set "query1=!first_line!"
		set "query1=!query1: =%%20!"
		set query1=!query1:"=!
		set query1="!query1!"

		set "query2=!second_line!"
		set "query2=!query2: =%%20!"
		set query2=!query2:"=!
		set query2="!query2!"

		echo !first_filename!
		echo.
		echo query1:
		echo !query1!
		echo.
		echo query2:
		echo !query2!
		echo.
pause

		taskkill /F /IM chrome.exe /T >nul
		taskkill /F /IM notepad++.exe /T >nul
rem		start "" "!chromepath!\chrome.exe" -incognito "!site!/!command!=!query1!
rem		start "" "!chromepath!\chrome.exe" -incognito "!site!/!command!=!query2!
		start "" "chrome.exe" -incognito "!site!/!command!=!query1!
		start "" "chrome.exe" -incognito "!site!/!command!=!query2!
		start notepad++ sorted-!extension!\!subfolder!\!first_filename!
		call start notepad++ dataset-sources\!extension!-dataset-sources.csv

rem		for /f "delims=" %%v IN (sorted-!extension!\!subfolder!\!first_filename! dataset-sources\!extension!-dataset-sources.csv) do call notepad++ "%%v"

pause
	)
)

endlocal

rem Format:
rem https://www.google.com/search?q=simon%27s+cat&iflsig=AINFCbYAAAAAYOPCSg9bEwO_2AXw_YBtbfC1G3nUaTdN


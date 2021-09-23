REM
REM IMPORTANT:
REM This batch file assumes that the master-* text files are in the current working directory, not in a subdirectory.
REM
REM Copy files from master-* text files into master-* folders.
REM The files will be prefixed by a number and a hyphen (e.g., 1-, 2-, 3-, etc.)
REM The number references the line number in the source master-* text file where
REM the source file is listed (which includes its full path location in the original repo).
REM 
@echo off
cls
setlocal

rem Set each folder/file name in a separate array variable (not true arrays, but just go with it for now...)
set target[0]=master-json
set target[1]=master-csv

if not exist master-json mkdir master-json
if not exist master-csv mkdir master-csv

rem Cycle through the target[*] settings:
for /F "tokens=2 delims==" %%t in ('set target[') do (

	set directory=%%t
	del /q %directory%\*.*

	setlocal EnableDelayedExpansion
	set /a Counter=0

	for /F "usebackq delims=" %%a in (`"findstr /b ^^ %%t.txt"`) do (

rem Write line text to tempfile:
		echo %%a> tempfile.txt
rem Capture line length from text file length in strlength variable:
		for %%? in (tempfile.txt) do ( set /A strlength=%%~z? - 2 )

		set /a Counter+=1
		set "source=%%a"
		set "source=!source:*:=!"

rem Ensure it's not an empty line or a line with a control character:
		if not "!strlength!"=="1" (
			if not "!strlength!"=="0" (
				for %%i in ("!source!") do (
					set filename=%%~ni
					set extension=%%~xi
					set destination=!directory!\!Counter!-!filename!!extension!
				)
				echo !destination!
rem Copy the source to the destination, which will be a file prefixed
rem by a number that corresponds to the line number in the master-* file
rem that references the original location of the file in the repo folder structure:
				copy "!source!" "!destination!" >nul
			)
		)
	)
	endlocal
)

endlocal
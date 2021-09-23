@echo off
cls

setlocal EnableDelayedExpansion

for %%x in (json csv) do (

	set extension=%%x

	set "file=master-!extension!.txt"
	set /A i=0
	set output_file=!extension!-dataset-sources.csv

	echo.
	echo Reading !file!...
	echo.

	for /F "usebackq delims=" %%a in ("!file!") do (
		set /A i+=1

rem Capture the part of the filename following github-repos\
		set "local_filename=%%a"
		set "repo_url=!local_filename:*github-repos\=!"

rem OLD: call set array[%%i%%]=%%a

		call set array[%%i%%]=!repo_url!
		call set n=%%i%%
	)

rem Create an array with filenames in right order
	for /d %%f in ("sorted-!extension!/*") do (
		for /F "delims=-" %%n in ("%%f") do (
			set "number=00000%%n"
			set "file[!number:~-6!]=%%f"
		)
	)

	if exist !output_file! del /q !output_file!

	rem Process the filenames in right order
	for /F "tokens=2 delims==" %%f in ('set file[') do (
		set subfolder=%%f
		echo --------------
		echo subfolder: !subfolder!
		for %%g in ("sorted-!extension!/!subfolder!/*") do (
			set filename=%%g
			echo !filename!

			for /f "tokens=1 delims=-" %%a in ("!filename!") do (
				echo | set /p dummyName=,!array[%%a]!>> !output_file!
			)
		)
		echo.>>!output_file!
	)

)

endlocal
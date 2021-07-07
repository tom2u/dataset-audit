@echo off
REM
REM Copy a file to a dedicated folder.
REM Compare it to all other files.
REM Copy all duplicate files to the same folder.
REM Remove all corresponding files from the source master-* folder so that the files are not 
REM used for redundant processing subsequently.
REM
rem How to free up extra disk space: 
rem https://techcommunity.microsoft.com/t5/windows-it-pro-blog/managing-reserved-storage-in-windows-10-environments/ba-p/1297070


cls

setlocal EnableDelayedExpansion

set DT=!DATE! !TIME!
set year=!DT:~10,4!
set day=!DT:~4,2!
set mth=!DT:~7,2!
set hour=!DT:~15,2!
set min=!DT:~18,2!
set sec=!DT:~21,2!
set hun=!DT:~24,2!

echo Start Time = !hour!:!min!:!sec!:!hun!

rem Set each folder/file name in a separate array variable (not true arrays, but just go with it for now...)
rem set target[0]=mXaster-json
rem set target[1]=mXaster-csv
set target[2]=master-xls


for /F "tokens=2 delims==" %%a in ('set target[') do (

	set folder=%%a
	set "extension=!folder:*-=!"
	set sorted_folder=sorted-!extension!
	set /a counter=0

	if exist !sorted_folder! (
		del /q !sorted_folder!\*
		FOR /D %%p IN ("!sorted_folder!\*.*") DO rmdir "%%p" /s /q
	)

	if not exist !sorted_folder! mkdir !sorted_folder!

	echo ^*^*^*^*^*^*^*^*^*^*^*^*^*^*
	echo FOLDER: !folder!
	echo EXTENSION: !extension!


	for /r %%i in (!folder!\*.!extension!) do (

		set subject_file=%%i
		if exist "!subject_file!" (

			set /a counter+=1
			echo ---------------------------
			echo Subfolder: !sorted_folder!\!counter!

			if exist !sorted_folder!\!counter! (
				del /q !sorted_folder!\!counter!\*
				FOR /D %%p IN ("!sorted_folder!\!counter!\*.*") DO rmdir "%%p" /s /q
			)

			if not exist !sorted_folder!\!counter! mkdir !sorted_folder!\!counter!

			copy "!subject_file!" !sorted_folder!\!counter!

			for %%S in (!subject_file!) do (
				set subject_size=%%~zS
			)

			echo Subject:
			echo !subject_file!

			for /r %%j in (!folder!\*.!extension!) do (

				set comparison_file=%%j
				echo ^* !comparison_file!

				for %%C in (!comparison_file!) do (
					set comparison_size=%%~zC
				)

				if exist "!comparison_file!" (
					if not "!comparison_file!"=="!subject_file!" (
						if "!comparison_size!"=="!subject_size!" (

							fc /B "!subject_file!" "!comparison_file!" > stats.txt
							findstr /m /c:"no differences encountered" stats.txt >nul

							if !errorlevel!==0 (
								echo Match:
								echo !comparison_file!
								copy "!comparison_file!" !sorted_folder!\!counter!
								del /q !comparison_file!
							)
						)
					)
				)
			)

			del /q "!subject_file!"

		)
	)
)


REM ***************************************
REM Get the hours/min/secs/hun, etc from current date and time
REM ***************************************
set EndTime=!TIME!
set EndHour=!EndTime:~0,2!
set EndMin=!EndTime:~3,2!
set EndSec=!EndTime:~6,2!
set EndHun=!EndTime:~9,2!

REM *******************************
REM Calculate the difference
REM Hours, Minutes, seconds, hundredths calculated separately
REM *******************************
set /a Hour_Diff=EndHour-hour
set /a Min_Diff=EndMin-min
set /a Sec_Diff=EndSec-sec
set /a Hun_Diff=EndHun-hun

REM *******************************
REM Carry any differences
REM *******************************

IF !Hun_Diff! LSS 0 (
	set /a Hun_Diff=Hun_Diff+100
	set /a Sec_Diff=Sec_Diff+1
)

IF !Sec_Diff! LSS 0 (
	set /a Sec_Diff=Sec_Diff+60
	set /a Min_Diff=Min_Diff+1
)

If !Min_Diff! LSS 0 (
	set /a Min_Diff=Min_Diff+60
	set /a Hour_Diff=Hour_Diff+1
)

echo Start Time = !hour!:!min!:!sec!:!hun!
echo End Time = !EndHour!:!EndMin!:!EndSec!:!EndHun!
echo.

endlocal



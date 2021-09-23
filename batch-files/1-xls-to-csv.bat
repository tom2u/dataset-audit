@echo off

rem Convert each .xls, .xlsx, .xlsm to .csv, 
rem saving the converted data variously to .xls.csv, .xlsx.csv, .xlsm.csv

cls

rem delete any holdovers from previous processing:

cd github-repos

del /S *.xls.csv
del /S *.xlsx.csv
del /S *.xlsm.csv

cd ..

for /d %%d in (github-repos/*.*) do (

	cd github-repos/%%d

	FOR /f "delims=" %%i IN ('DIR *.xls /b /s') DO (
		echo %%i
		cscript ../../xls-to-csv.vbs "%%i" "%%i.csv"
	)

	cd ../..
)
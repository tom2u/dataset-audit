@echo off

rem Create CSV.TXT and JSON.TXT in the root of each folder in github-repos

for /d %%d in (github-repos/*.*) do (
	cd github-repos/%%d
	echo Creating CSV.TXT and JSON.TXT in github-repos/%%d
	dir /b /s /n *.csv > csv.txt
	dir /b /s /n *.json > json.txt
	cd ../..
)

@echo off

rem Concatenate CSV and JSON listings into master files

cls

if exist master-csv.txt del master-csv.txt
if exist master-json.txt del master-json.txt

for /d %%d in (github-repos/*.*) do (
	echo github-repos/%%d
	type github-repos\%%d\csv.txt >> master-csv.txt
	type github-repos\%%d\json.txt >> master-json.txt
)
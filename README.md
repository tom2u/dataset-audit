# dataset-audit

The following documents the procedure used for auditing data sets in the 2U Data curriculum, performed in July, 2021. The routine is specific to Windows and assumes an OS of at least Windows 8.1

---

There are four repos containing unidentified data sets:

> DataViz-Lesson-Plans  
> DataViz-Lesson-Plans-v1.1  
> DataViz-Online  
> nflx-adv-data

There are 3 file types in the repos that will contain the data sets:

> \*.csv  
> \*.xls  
> \*.json

XLSs will have to be converted into CSVs in order to compare their contents with other files.

**Prep-Step A:**

Clone this repo, `dataset-audit`, locally, as the main folder. All subsequent work will be performed within it.

**Prep-Step B:**

Create a folder named `github-repos` in the main folder, and clone each repo to be researched into it. The result for the present project will be:

> github-repos\DataViz-Lesson-Plans  
> github-repos\DataViz-Lesson-Plans-v1.1  
> github-repos\DataViz-Online  
> github-repos\nflx-adv-data

**Prep-Step C:**

Edit the `.gitignore` file to contain this text:

> github-repos/  
> master-csv/  
> master-json/  
> sorted-csv/  
> sorted-json/

**Prep-Step D:**

Copy the `.bat` and `.vbs` files from the `batch-files` directory to the main folder.

**Step 1:**

IMPORTANT:
2021-09-24:
This routine works with Excel 2007 on a Windows 8.1 machine, but does not run in Excel 17 (Office 365) on Windows 10. A different solution is necessary for this step. 

Run batch file:

> 1-xls-to-csv

This uses the `xls-to-csv.vbs` script to create CSV versions of all XLS file. Each created CSV has the extension `*.xls?.csv`, where `?` is empty, `x`, or `m`, depending on the source file extension. Without conversion to CSV, the contents of XLS files cannot be automatically retrieved for researching with Chrome.

**Step 2:**

Run batch file:

> 2-create-directory-listings

This creates `csv.txt` and `json.txt` files in each repo. Each file contains a listing of each matching file type with its full path name. For example, the `csv.txt` created in `DataViz-Lesson-Plans` will contain:

> DataViz-Lesson-Plans\01-Lesson-Plans\01-Excel\1\Activities\01-Ins_GreatDebate\Resources\Census_Data.csv  
> DataViz-Lesson-Plans\01-Lesson-Plans\02-VBA-Scripting\3\Activities\07-Stu_WellsFargo_Pt1\Unsolved\RAW\Alabama_Wells_Fargo_Bank_Deposits.csv  
> DataViz-Lesson-Plans\01-Lesson-Plans\02-VBA-Scripting\3\Activities\07-Stu_WellsFargo_Pt1\Unsolved\RAW\Alaska_Wells_Fargo_Bank_Deposits.csv  
> etc.

We need to compare files to eliminate duplicates. Duplicates may exist across the repos.

**Step 3:**

Run batch file:

> 3-create-master-listing-files

This creates 2 new files in the main folder:

> master-csv.txt  
> master-json.txt

These are a concatenation of the files created in the previous step. The files will contain a listing of every file of the stated type, each listed on a separate line, with the full path information provided.

**Step 4:**

Run batch file:

> 4-copy-files-to-master-folders

It creates master-\* folders, one for each file type:

> master-csv  
> master-json

It copies the files from the `master-*.txt` files into the new folders and renames them. Each copied file will be prefixed by a number and a hyphen (e.g., `1-`, `2-`, `3-`, etc.) The number references the line number in the source `master-*.txt` file where the source file is listed, which includes its full path location in the original repo.

So, if the first three lines in `master-csv.txt` are:

> DataViz-Lesson-Plans\01-Lesson-Plans\01-Excel\1\Activities\01-Ins_GreatDebate\Resources\Census_Data.csv  
> DataViz-Lesson-Plans\01-Lesson-Plans\02-VBA-Scripting\3\Activities\07-Stu_WellsFargo_Pt1\Unsolved\RAW\Alabama_Wells_Fargo_Bank_Deposits.csv  
> DataViz-Lesson-Plans\01-Lesson-Plans\02-VBA-Scripting\3\Activities\07-Stu_WellsFargo_Pt1\Unsolved\RAW\Alaska_Wells_Fargo_Bank_Deposits.csv

...then the `master-csv` folder will contain those files renamed this way:

> 1-Census_Data.csv  
> 2-Alabama_Wells_Fargo_Bank_Deposits.csv  
> 3-Alaska_Wells_Fargo_Bank_Deposits.csv

The number at the beginning of the file name references the line number in `master-csv.txt` where the full file path of the original file can be located.

**Step 5:**

Next we'll create a filtered/sorted archive of the files, grouping all matching files into the same folder. If a file is distinct, i.e., it has no duplicates, it will be the only file in the folder. But if there are duplicate files, they will be grouped with it in the same folder.

IMPORTANT: This will take a lot of time to run depending on the number of files to be compared, perhaps hours.

Run batch file:

> 5-sort-files-into-dedicated-folders

When it's finished, we'll have these folders:

> sorted-json  
> sorted-csv

In each folder will be a series of consecutively numbered folders:

> sorted-csv/1  
> sorted-csv/2  
> sorted-csv/3

etc.

Each folder contains at least one data file. If there are multiple files, they are exact duplicates of each other. The numbers prefixing each file indicate on which line number in the corresponding `master-* text` file that the source file&mdash;with its original repo URL&mdash;is located.

For example:

> sorted-csv/4

...contains these files, each prefixed with a number. The numbers indicate on which line in the `master-*.txt` file the full filenames can be found:

> 101-used_cars.csv  
> 434-used_cars.csv  
> 534-used_cars.csv

So, in `master-csv.txt`, lines 101, 434, and 534 are respectively:

> DataViz-Lesson-Plans\01-Lesson-Plans\05-Matplotlib\2\Activities\04-Ins_GroupPlots\Resources\used_cars.csv
>
> DataViz-Online\03-Lesson-Plans\05-Lessons\2\Activities\04-Ins_GroupPlots\Resources\used_cars.csv
>
> nflx-adv-data\01-Lesson-Plans\03-Matplotlib\01-Day\Activities\11-Ins_GroupPlots\Resources\used_cars.csv

**Step 6:**

Run batch file:

> 6-create-dataset-sources-files

This will write this data to individual rows in these new CSV files:

> json-dataset-sources.csv  
> csv-dataset-sources.csv

The row numbers in these files will correspond to the subfolder numbers in `sorted-json` and `sorted-csv`.

The first cell of the CSV is always empty. It is where the URL of the data source will be recorded.

Each succeeding cell in the row will be each URL of the duplicate data set found by the previous routines.

For example, the 7th row of the newly created csv file might be:

> ,C:\dataset-process\github-repos\DataViz-Lesson-Plans\01-Lesson-Plans\03-Python\3\Activities\01-Stu_CerealCleaner\Resources\cereal.csv ,C:\dataset-process\github-repos\DataViz-Online\01-Assignments\06-WeatherPy\Unit-Assessment-Python\resources\cereal.csv

This corresponds to folder 7 in `sorted-csv`, which contains `104-cereal.csv` and `566-cereal.csv`. The complete URLs of those files are in turn found on lines 104 and 566 of the `master-csv.txt` file.

**Step 7:**

Next comes the real work. We'll use `auto-open-chrome.bat` repeatedly to automate searching the contents of the file. Before running the batch file, edit the batch file appropriately:

- Set the exact path of Chrome on your OS
- Set the extension variable at the top (=csv, json)
- Set the starting number to the first folder to open (so you can quit the process and return to start it at the line where you left off)

Additionally, the batch file assumes that you have notepad++ installed, and that it can be executed from the command line with `notepad++`. Set your `PATH` variable appropriately.

After editing the batch file appropriately, perhaps make a copy of it named `x.bat` for easy execution (`x` is quicker to type).

Run batch file:

> 7-auto-open-chrome

It will collect the first and second lines in the first file in each folder, and those lines will be used as search queries in Google. Those queries will be opened in two different tabs in Chrome.

The dataset file being searched will be opened in Notepad++, along with the `\*-dataset-sources.csv` file that is being edited as part of the work.

After identifying the likely source of the dataset, add the URL of the dataset to the **first column** in each row of `\*-dataset-sources.csv`

**Step 8:**

Finally, when finished with the search-engine research, run this batch file:

> 8-edit-csv-dataset-sources

This will restore the original file extensions in the `csv-dataset-sources.csv` file:

.xls.csv renamed to .xls  
.xlsm.csv renamed to .xlsm  
.xlsx.csv renamed to .xlsx

This is needed so that the CSV file represents the actual file names (we converted all XLS files to CSVs so that we could open their contents and shoot the contents into Chrome.) A backup of the original state of `csv-dataset-sources.csv` file is saved as `csv-dataset-sources.backup.csv`.

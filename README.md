# dataset-audit

There are 3 repos containing unidentified data sets:

> DataViz-Lesson-Plans  
> DataViz-Online  
> nflx-adv-data

There are 3 file types in the repos that will contain the data sets:

> *.csv  
> *.xls  
> *.json

Begin by cloning each repo locally in dedicated project folder.
Then, in the root of each repo, create a listing of each matching file type found in the repo:

> dir /b /s /n *.csv > csv.txt  
> dir /b /s /n *.xls > xls.txt  
> dir /b /s /n *.json > json.txt

This creates a listing with full file names:

> DataViz-Lesson-Plans\01-Lesson-Plans\01-Excel\1\Activities\01-Ins_GreatDebate\Resources\Census_Data.csv  
> DataViz-Lesson-Plans\01-Lesson-Plans\02-VBA-Scripting\3\Activities\07-Stu_WellsFargo_Pt1\Unsolved\RAW\Alabama_Wells_Fargo_Bank_Deposits.csv  
> DataViz-Lesson-Plans\01-Lesson-Plans\02-VBA-Scripting\3\Activities\07-Stu_WellsFargo_Pt1\Unsolved\RAW\Alaska_Wells_Fargo_Bank_Deposits.csv

We need to compare files to eliminate duplicates. Duplicates may exist across the repos.

So, concatenate the files into dedicated master-*.txt files in the main folder:

> copy dataviz-lesson-plans\csv.txt + dataviz-online\csv.txt + nflx-adv-data\csv.txt master-csv.txt  
> copy dataviz-lesson-plans\xls.txt + dataviz-online\xls.txt + nflx-adv-data\xls.txt master-xls.txt  
> copy dataviz-lesson-plans\json.txt + dataviz-online\json.txt + nflx-adv-data\json.txt master-json.txt

Run the following batch file (saved as copy-files-to-master-folders.bat). It copies each data file referenced in the *.txt files created in the steps above into folders with the same names as the *.txt files.

> copy-files-to-master-folders.bat 

Now we have these folders:

> master-json  
> master-csv  
> master-xls

Each has the corresponding file types within it, each file prefixed with the line number it was found on in the corresponding master-* file. 

For example, master-csv begins with these three files:

> 1-Census_Data.csv  
> 2-Alabama_Wells_Fargo_Bank_Deposits.csv  
> 3-Alaska_Wells_Fargo_Bank_Deposits.csv

Those are copies of the same files referenced in lines 1, 2, and 3 of the master-csv.txt file:

> DataViz-Lesson-Plans\01-Lesson-Plans\01-Excel\1\Activities\01-Ins_GreatDebate\Resources\Census_Data.csv  
> DataViz-Lesson-Plans\01-Lesson-Plans\02-VBA-Scripting\3\Activities\07-Stu_WellsFargo_Pt1\Unsolved\RAW\Alabama_Wells_Fargo_Bank_Deposits.csv  
> DataViz-Lesson-Plans\01-Lesson-Plans\02-VBA-Scripting\3\Activities\07-Stu_WellsFargo_Pt1\Unsolved\RAW\Alaska_Wells_Fargo_Bank_Deposits.csv

Next we'll create a filtered/sorted archive of the files, grouping all matching files into the same folder. If a file is distinct, i.e., it has no duplicates, it will be the only file in the folder. But if there are duplicate files, they will be grouped with it in the same folder:

> sort-files-into-dedicated-folders.bat

Now we have these folders:

> sorted-json  
> sorted-csv  
> sorted-xls

In each folder is a series of consecutively numbered folders:

> sorted-csv/1  
> sorted-csv/2  
> sorted-csv/3

etc.

Each folder contains at least one data file. If there are multiple files, they are exact duplicates of each other. The numbers prefixing each file indicate on which line number in the corresponding master-* text file that the source file--with its original repo URL--is located.

For example:

sorted-csv/4 contains these files.

> 101-used_cars.csv  
> 434-used_cars.csv  
> 534-used_cars.csv

In master-json.txt, lines 101, 434, and 534 are respectively:

> DataViz-Lesson-Plans\01-Lesson-Plans\05-Matplotlib\2\Activities\04-Ins_GroupPlots\Resources\used_cars.csv  
>  
> DataViz-Online\03-Lesson-Plans\05-Lessons\2\Activities\04-Ins_GroupPlots\Resources\used_cars.csv  
>  
> nflx-adv-data\01-Lesson-Plans\03-Matplotlib\01-Day\Activities\11-Ins_GroupPlots\Resources\used_cars.csv

Next, run create-dataset-sources-files.bat, which will write this data to individual rows in new CSV files. In the case of the previous example, the 4th row of the created file would be:

> ,DataViz-Lesson-Plans\01-Lesson-Plans\05-Matplotlib\2\Activities\04-Ins_GroupPlots\Resources\used_cars.csv,DataViz-Online\03-Lesson-Plans\05-Lessons\2\Activities\04-Ins_GroupPlots\Resources\used_cars.csv,nflx-adv-data\01-Lesson-Plans\03-Matplotlib\01-Day\Activities\11-Ins_GroupPlots\Resources\used_cars.csv

The first cell of the CSV is always empty. It is where the URL of the data source will be recorded. Each succeeding cell in the row will be each URL of the each duplicate data set found by the previous routines.

For example, the first 3 rows of the csv-dataset-sources.csv file are:

> ,DataViz-Lesson-Plans\01-Lesson-Plans\01-Excel\1\Activities\01-Ins_GreatDebate\Resources\Census_Data.csv  
>  
> ,DataViz-Lesson-Plans\01-Lesson-Plans\02-VBA-Scripting\3\Activities\07-Stu_WellsFargo_Pt1\Unsolved\RAW\Florida_Wells_Fargo__Bank_Deposits.csv  
>  
> ,DataViz-Lesson-Plans\01-Lesson-Plans\05-Matplotlib\2\Activities\03-Stu_BattlingKings-PlottingPandas\Unsolved\Resources\got.csv ,DataViz-Online\03-Lesson-Plans\05-Lessons\2\Activities\03-Stu_BattlingKings-PlottingPandas\Solved\Resources\got.csv ,DataViz-Online\03-Lesson-Plans\05-Lessons\2\Activities\03-Stu_BattlingKings-PlottingPandas\Unsolved\Resources\got.csv ,DataViz-Lesson-Plans\01-Lesson-Plans\05-Matplotlib\2\Activities\03-Stu_BattlingKings-PlottingPandas\Solved\Resources\got.csv  

These correspond to the files in the folders sorted-csv/1, sorted-csv/2, and sorted-csv/3.

Next, use auto-open-chrome.bat. 

* Set the extension variable at the top (=csv, xls, json)
* Set the starting number to the first folder to open (so you can quit the process and return to start it at the line where you left off)

It will collect the first and second lines in the first file in each folder.
Those lines will be used as search queries in Google
Add the URL of the dataset to the first column in each row of *-dataset-sources.csv
# MinION User Group

This repository currently only contains one script, which is used to generate summary graphs of the
generated QC statistics from MinION runs.

The template spreadsheet can be found here https://docs.google.com/spreadsheets/d/19Tl5Cv_SnQ4gA2zcGAMxmxqLz6lyGnSp0sG_r9h7z2E/edit#gid=0 

The script currently runs on the input data provided by Miriam Schalamun found here https://docs.google.com/spreadsheets/d/1480qh5zNRN5ghm0qWisfcf6pCLoPs4xuzs5aMSeK. 

To analyse your own dataset based on the filled in template spreadsheet point the assignment of line 10 to your own gsheet.

e.g. 
data.tbl <- gsheet2tbl("docs.google.com/spreadsheets/d/1480qh5zNRN5ghm0qWisfcf6pCLoPs4xuzs5aMSeKg5Q");

to 

data.tbl <- gsheet2tbl("MYGSHEET");

See the associated protocols.io page here:

https://www.protocols.io/groups/minion-user-group-with-fungi-and-plants-on-their-mind

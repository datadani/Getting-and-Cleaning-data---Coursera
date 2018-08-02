---
title: "Getting and Reading Data - Course Project"
output: html_document
---

The file run_analysis.R produces the data file tidy_data.txt. It documents the following steps of data cleaning:

1. Download the zip file with datasets if it does not already exist in the working directory.
2. Keep only those columns of training and test datasets which reflect means or standard deviations.
3. Merge training and test datasets and add information on activity and subject data
4. Convert activity and subject columns into factors.
5. Create a tidy dataset that consists of the average of each variable for each subject and activity pair.
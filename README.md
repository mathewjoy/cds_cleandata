# cds_cleandata

## The run_analysis.R program does the following:

1. check and download file using http url
2. unzip the file if previously not done already by check the folder
3. read list of lables and features into a table
4. Extract list of interesting measues related to mean and stdev from the data freatures
5. Load training data
6. Load test data
7. Merge training and test data
8. Create factors for activity and subject (which are the identifiers)
9. melt the wide data table into key value pairs on columns names and dcast to produce aggregated clean data
10. write the results out to file

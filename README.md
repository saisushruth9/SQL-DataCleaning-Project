# SQL-DataCleaning-Project
**What This Project Does**
1. Creates a Backup
  -Before touching the raw data, a backup table is created to ensure the original information stays safe.
  
2. Cleans Up Duplicates
  -Duplicates are identified and removed so that each entry is unique.

3. Fills in Missing Information
  -Missing values in key fields like industry are filled in using information already available elsewhere in the dataset.
  
4. Fixes Inconsistencies
  -Columns like country and industry are cleaned up and standardized (e.g., "CryptoCurrency" becomes "Crypto").
  
5. Standardizes Dates
  -Dates in inconsistent formats are converted into a proper, uniform DATE format.

6. Removes Irrelevant Data
  -Rows that don’t provide useful information are deleted to streamline the dataset.

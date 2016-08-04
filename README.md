# Introduction

The U.S. Department of Veterans Affairs' Office of Policy and Planning publishes y a report of expenditures by State and County. The Geographic Distribution of Expenditures or GDX has been published each fiscal year since 1996. [These reports/files are available on the National Center for Veteran Analysis and Statistics website.](http://www.va.gov/vetdata/Expenditures.asp)This repository contains two R programs that consolidate the GDX report data from 2007 to 2015 into one data set for State level expenditures and one for County level expenditures. The purpose of doing so is to be able to easily analyze the GDX data from the past nine years. I wrote these with the intent of full transparency and reproducible. However, I was obliged to make major compromises some because the structure of the files varies in some years and also the data itself. For example in fiscal years 2007 and 2008 there is no data for Guam. Similarly the county names are written differently in some years. All of these nuances are described in detail below to at least ensure transparency into my methods. 

# Using the Data

All the code and data files are freely available in Github for anyone to run on their own. Alternatively one can simply download the consolidated data file(s). The data files are provided in Rds and CSV format. The CSV files, however, don't preserve the FIPS codes and will need to modified upon reading because leading zeros are dropped. 

1. Github Repository: https://github.com/mihiriyer/gdxdata
2. State Level Expenditures from 2007 to 2015: ***gdxstate0715.Rds*** and ***gdxstate.csv***
3. County Level Expenditures from 2007 to 2015: ***gdxcty0715.Rds*** and ***gdxcty0715.csv***
4. County Level Expenditures for 2015: ***gdxcty15.Rds*** and ***gdxcty15.csv***

# Data Consolidation Programs

There are two programs that read and consolidate the data from the GDX reports. The [Code_GDX_Explore_DataPrep_State](https://github.com/mihiriyer/gdxdata/blob/master/Code_GDX_Explore_DataPrep_State.R) program is designed to read and consolidate the state level expenditures by reading the first worksheet of each GDX files. The second program, [Code_GDX_Explore_DataPrep_County](https://github.com/mihiriyer/gdxdata/blob/master/Code_GDX_Explore_DataPrep_County.R), reads and consolidates the county level data from each state worksheet (53 to 54 sheets depending on the year) from each GDX file. 

# GDX Report/File Structure

Each annual report is provided as an MS Excel workbook. The list below shows the breakdown of the worksheets in each workbook from FY07 to FY15:

1. 55 worksheets total for FY09 to FY15. 53 worksheets in FY07 and FY08 as there is no Guam or Data Description worksheet. 
2. Worksheet 1 is dedicated to listing State Level Expenditures. 
3. Worksheets 2 to 54  are assigned to each State along with DC, Puerto Rico, and Guam. Guam is not present in FY07 and FY08 file. 
5. Worksheet 55 is for the Data Description (Not present in FY07 and FY08)
6. On the State Level Expenditure worksheet the data starts on row 6 and ends on row 58. 
7. On the State worksheets the data starts on row 4. The row at which the data stops varies by state.

# File, Filename and Format Changes

The GDX report files are not named uniformly and it was a lot easier to rename the files rather than writing a program that was flexible enough to account for variation in the file names. Along with standardizing the file names I also converted the files that were in *xls* format to *xlsx*. This made using the read.xlsx function a lot more effective. The name and format changes are listed below: 

1. GX_FY12_V1.xlsx to GDX_FY12.xlsx
2. GDX_FY10V14.xls to GDX_FY10.xlsx
3. GDX_FY09_2.xls to GDX_FY09.xlsx
4. GDX_FY08_V2.xls to GDX_FY08.xlsx
5. GDX_FY07_V090401.xls to GDX_FY07.xlsx

Additionally in the FY09 file, on the Puerto Rico worksheet, the data starts in column D as opposed to column A - this was rectified by deleting columns A-C. In the FY07 file the Hawaii worksheet name was written as H1 - this was changed to HI. 

# County Name Standardization and Linkage to FIPS Code

While programmatically attempting to link the county names to their corresponding FIPS I discovered that county names were not written uniformly across the GDX files and that they differed from the way they written in the [2010 Census FIPS code file.](https://www.census.gov/geo/reference/codes/cou.html) Below are a few examples of how county names differ:

1. Alaska uses borough and census Areas in lieu of county.
2. Louisiana uses parish.
3. Census FIPS file lists a county as: *Name County*.
4. GDX files list a county as: *NAME*.
5. Census lists county names that include the word "city" as *Baltimore city*. GDX lists BALTIMORE (CITY).
7. GDX list counties that have a prefix of Saint/Sainte as St./Ste.
8. Census lists county names that start with Mc as one word e.g. McPherson. The GDX files 

Standardizing the county names is essential for pulling in the FIPS code so that the GDX data can ultimately be displayed on a map. It is also necessary to be able to make comparisons over time. I standardized the names in two ways - one by building a crosswalk and programmatically. I found that building a crosswalk was a lot easier because there were simply too many county name variants to address through programming. The below outlines the steps for building the crosswalk:

1. Read one GDX report and extract he unique county-state names.
2. Sort unique county-state names from GDX and also sort national_county.txt file.
3. Paste GDX names into national_county.txt file.
4. Perform counts of counties by each state to make each state has the right number of of counties.
5. Verify that first, last, and middle counties for each state match. 
6. Verify all county names that start with Mc, St., Ste. 
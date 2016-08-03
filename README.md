# Introduction

The U.S. Department of Veterans Affairs' Office of Policy and Planning publishes y a report of expenditures by State and County. The Geographic Distribution of Expenditures or GDX has been published each fiscal year since 1996. [These reports/files are available on the National Center for Veteran Analysis and Statistics website.](http://www.va.gov/vetdata/Expenditures.asp)This repository contains two R programs that consolidate the GDX report data from 2007 to 2015 into one data set for State level expenditures and one for County level expenditures. The purpose of doing so is to be able to easily analyze the GDX data from the past nine years. I wrote these with the intent of full transparency and reproducible. However, I was obliged to make major compromises some because the structure of the files varies in some years and also the data itself. For example in fiscal years 2007 and 2008 there is no data for Guam. Similarly the county names are written differently in some years. All of these nuances are described in detail below to at least ensure transparency into my methods. 

# How to use

1. download zip folder...

2. or download Rds files 

# GDX Report/File Structure

Each annual report is provided as an MS Excel workbook. The list below shows the breakdown of the worksheets in each workbook from FY07 to FY15:

1. 55 worksheets total for FY09 to FY15. 53 worksheets in FY07 and FY08 as there is no Guam or Data Description worksheet. 

2. Worksheet 1 is dedicated to listing State Level Expenditures. 

3. Worksheets 2 to 54  are assigned to each State along with DC, Puerto Rico, and Guam.
Guam not present in FY07 and FY08 file. 

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

# County Name Standardization and Linking to FIPS Code

While attempting to link the county names to their corresponding FIPS I discovered that county names were not written uniformly across the GDX files and also were different from the way the county names are written in the Census FIPS code files. Standardizing the county names is also essential to analyze the counties across the years. The county names changes were made in two ways - indirectly and directly. Before 


The list below highlights the county name changes that were made:

1. Alaska uses Bourough and Census Areas in lieu of County
2. Louisiana uses Parish
3. Counties that start with Saint/Sainte are some times written as St. or Saint

 - Census FIPS files lists a county as: Name County
 - GDX files lists a county as: NAME
 - Census: Baltimore city; GDX: BALTIMORE (CITY)

 Counties that have "Saint" in their names were changed to St.


 all the counties that start with "Mc" some with St. 


# Approach and Results

Since the files are in xlsx format I used the read.xlsx function.
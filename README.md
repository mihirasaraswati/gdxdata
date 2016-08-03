# gdxdata
R program to consolidate VA's Geographic Expenditure data from FY 2007 to 2015


File Name Changes:
1. GX_FY12_V1.xlsx TO GDX_FY12
2. GDX_FY10V14 to GDX_FY10
3. GDX_FY06_V090409 
4. GDX_FY07_V090401
5. GDX_FY08_V2
6. GDX_FY09_2


Workbook Setup:

1. 55 sheets total
2. 1 X State Level Expenditure
3. 50 X States
4. 1 X DC, 1 X PR, 1 X GU
5. 1 X Data Description


State Level Expenditure:
Start: Row 6
End: Row 58

State Sheets:
Start: Row 4:
End: Variable (first blank)

Used read.xlsx - formulae weren't being evaluated with readRows or xlsx2. Runtime 6:56 

Ubunutu need to libgeo-dev for rgeos package and then libgdal.dev for rgdal package

read.xlsx2 - runtime of over 10min, terminated without completion.


County Names that need to be corrected to match FIPS names:
1. All of Alaska
2. AR Saint Francis County (st. francis county)
3. DC 
4. LA
5. all the counties that start with "Mc" some with St. 

Remove AS, VI and ___ from the Census county file

converted all the xls to xlsx

fy07 Hawaii in tab was written as H1 manually changed to HI

fy09 PR tab starts at column D and not A.52 because 53rd is guam which is not present in FY08 & FY07

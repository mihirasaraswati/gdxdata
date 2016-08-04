#ATTENTION - this command should be run before loading xlsx library, i.e you should start a new session if already in one
options(java.parameters = "-Xmx8000m")

library(xlsx)
library(dplyr)

# Data Read & Consolidate -------------------------------------------------

#create empty dataframe to store data from xl files
gdxcty <- data.frame()

#read files that end with xlsx
gdxfiles = list.files(".", pattern="GDX_FY[0-1][0-9].xlsx", all.files = FALSE, full.names = FALSE)
#sort so that FY15 file is first
gdxfiles <-  sort(gdxfiles, decreasing = TRUE)

#prob - associating fys with data from files names. there are more than 3 variations of fys for 17 files. easier to rename the files manually
fys <- c(2015:2007)

#create a vector of state names by reading the worksheet names. exclude the first and sometomes last sheet
wb <- loadWorkbook(gdxfiles[1])
states <- names(getSheets(wb))
states <- states[2:54]
rm(wb)

#Read files from FY15 to FY09 since Guam is not FY08 & FY7=07
for(i in 1:7){
  #read up to 53, 50 state plus DC, PR, and GU
  for(j in 1:53){
    tmpdfCty <- read.xlsx(gdxfiles[i],
                          sheetName = states[j],
                          colIndex = c(1:11),
                          header=FALSE,
                          startRow = 4,
                          stringsAsFactors = FALSE)
    
    blankrows <- rownames(tmpdfCty[which(tmpdfCty$X1 %in% c("", NA)),])
    
    tmpdfCty <- tmpdfCty[c(1:blankrows[1]-1),]
    
    fy <- rep(fys[i], nrow(tmpdfCty))
    
    state <- rep(states[j], nrow(tmpdfCty))
    
    tmpdfCty <- cbind(fy, state, tmpdfCty, stringsAsFactors = FALSE)
    
    gdxcty <- rbind(gdxcty, tmpdfCty, stringsAsFactors = FALSE)
    
  }
  
}

#Read FY08 and FY07 files

for(i in 8:9){
  #read up to 52 because 53rd is guam
  for(j in 1:52){
    tmpdfCty <- read.xlsx(gdxfiles[i],
                          sheetName = states[j],
                          colIndex = c(1:11),
                          header=FALSE,
                          startRow = 4,
                          stringsAsFactors = FALSE)
    
    blankrows <- rownames(tmpdfCty[which(tmpdfCty$X1 %in% c("", NA)),])
    
    tmpdfCty <- tmpdfCty[c(1:blankrows[1]-1),]
    
    fy <- rep(fys[i], nrow(tmpdfCty))
    
    state <- rep(states[j], nrow(tmpdfCty))
    
    tmpdfCty <- cbind(fy, state, tmpdfCty, stringsAsFactors = FALSE)
    
    gdxcty <- rbind(gdxcty, tmpdfCty, stringsAsFactors = FALSE)
    
  }
  
}


#add shortened column names
names(gdxcty) <- c("FY", "State", "GDXCountyName", "VetPop", "TotX", "CP", "Cons", "EduVoc", "Loan", "GOE", "InsInd", "MedCare", "Uniques")

#convert FY to character
gdxcty$FY <- as.character(gdxcty$FY)
#convert to numeric
gdxcty$Uniques <- as.numeric(gdxcty$Uniques)
gdxcty$VetPop <- as.numeric(gdxcty$VetPop)
gdxcty$Cons <- as.numeric(gdxcty$Cons)

# Remove temp variables
rm(tmpdfCty,  blankrows, fy, fys, gdxfiles, i, j, state, states)

# GDX County Names nead moar work - Cleanup/Standardization --------

#some of the files use eg MCLEAN and some MC CLEAN and the crosswalk can't store two variations
#AK
gdxcty$GDXCountyName[gdxcty$GDXCountyName == "FAIRBANKS NORTH STAR"] <-  "FAIRBANKS N. STAR"
#GA 
gdxcty$GDXCountyName[gdxcty$GDXCountyName == "MCDUFFIE"] <-  "MC DUFFIE"
#IL
gdxcty$GDXCountyName[gdxcty$GDXCountyName == "MCDONOUGH"] <- "MC DONOUGH"
#IN
gdxcty$GDXCountyName[gdxcty$GDXCountyName == "ST JOSEPH"] <- "ST. JOSEPH"
#KS & NE & SD
gdxcty$GDXCountyName[gdxcty$GDXCountyName == "MCPHERSON"] <- "MC PHERSON"
#KY
gdxcty$GDXCountyName[gdxcty$GDXCountyName == "MCCRACKEN"] <- "MC CRACKEN"
gdxcty$GDXCountyName[gdxcty$GDXCountyName == "MCCREARY"] <- "MC CREARY"
#KY & ND
gdxcty$GDXCountyName[gdxcty$GDXCountyName == "MCLEAN"] <- "MC LEAN"
#MI
# gdxcty$GDXCountyName[gdxcty$GDXCountyName == "ST.  JOSEPH"] <- "ST. JOSEPH"
#MN
gdxcty$GDXCountyName[gdxcty$GDXCountyName == "MCLEOD"] <- "MC LEOD"
#MO
gdxcty$GDXCountyName[gdxcty$GDXCountyName == "MCDONALD"] <- "MC DONALD"
gdxcty$GDXCountyName[gdxcty$GDXCountyName == "SAINT LOUIS CITY (CITY)"] <- "ST. LOUIS (CITY)"
#MT
gdxcty$GDXCountyName[gdxcty$GDXCountyName == "MCCONE"] <- "MC CONE"
#NC & WV
gdxcty$GDXCountyName[gdxcty$GDXCountyName == "MCDOWELL"] <- "MC DOWELL"
#ND & IL 
gdxcty$GDXCountyName[gdxcty$GDXCountyName == "MCHENRY"] <- "MC HENRY"
#ND & GA & OK
gdxcty$GDXCountyName[gdxcty$GDXCountyName == "MCINTOSH"] <- "MC INTOSH"
#ND
gdxcty$GDXCountyName[gdxcty$GDXCountyName == "MCKENZIE"] <- "MC KENZIE"
#OK
gdxcty$GDXCountyName[gdxcty$GDXCountyName == "MCCLAIN"] <- "MC CLAIN"
gdxcty$GDXCountyName[gdxcty$GDXCountyName == "MCCURTAIN"] <- "MC CURTAIN"
#PA
gdxcty$GDXCountyName[gdxcty$GDXCountyName == "MCKEAN"] <- "MC KEAN"
#SC
gdxcty$GDXCountyName[gdxcty$GDXCountyName == "MCCORMICK"] <- "MC CORMICK"
#SD
gdxcty$GDXCountyName[gdxcty$GDXCountyName == "MCCOOK"] <- "MC COOK"
#TN
gdxcty$GDXCountyName[gdxcty$GDXCountyName == "MCMINN"] <- "MC MINN"
gdxcty$GDXCountyName[gdxcty$GDXCountyName == "MCNAIRY"] <- "MC NAIRY"
#TX
gdxcty$GDXCountyName[gdxcty$GDXCountyName == "MCCULLOCH"] <- "MC CULLOCH"
gdxcty$GDXCountyName[gdxcty$GDXCountyName == "MCLENNAN"] <- "MC LENNAN"
gdxcty$GDXCountyName[gdxcty$GDXCountyName == "MCMULLEN"] <- "MC MULLEN"
#VA
gdxcty$GDXCountyName[gdxcty$GDXCountyName == "CHESAPEAKE CITY (CITY)"] <- "CHESAPEAKE (CITY)"
gdxcty$GDXCountyName[gdxcty$GDXCountyName == "HAMPTON CITY (CITY)"] <- "HAMPTON (CITY)"


#  & Match to Census FIPS  ------------------------------------------------

#read county level FIPS code file downloaded from census website, edited to create crosswalk to GDX county names
cntyfips <- read.xlsx("national_county_edit.xlsx",
                      sheetIndex = 1,
                      header=TRUE,
                      stringsAsFactors = FALSE)


#make all county  names lower case to facilitate easier matching
cntyfips$CountyName <- toupper(cntyfips$CountyName)
cntyfips$GDXCountyName <- trimws(toupper(cntyfips$GDXCountyName))
gdxcty$GDXCountyName <- toupper(gdxcty$GDXCountyName)

#join gdxcty with fips codes
gdxcty <-  merge(gdxcty, cntyfips, by=c("GDXCountyName", "State"), all.x = TRUE)
rm(cntyfips)
#re-order columns
gdxcty <- gdxcty[, c(2,14,16,1,15,17,3:13)]
#sort by StateFP and CountyFP
gdxcty <- arrange(gdxcty, StateFP, CountyFP)

#SAVE County-FIPS data 
saveRDS(gdxcty, file="gdxcty0715.rds")
# SAVE as CSV (NOTE!!! csv doesn't preserve the FIPS codes that start with zero)
write.csv(gdxcty, file = "gdxcty.csv")


#SAVE just FY15 data
saveRDS(filter(gdxcty, FY == "2015"), file="gdxcty15.rds")
# SAVE FY15 as CSV (NOTE!!! csv doesn't preserve the FIPS codes that start with zero)
write.csv(filter(gdxcty, FY == "2015"), file="gdxcty15.csv")
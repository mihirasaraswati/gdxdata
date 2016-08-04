#ATTENTION - this command should be run before loading xlsx library
options(java.parameters = "-Xmx8000m")

library(xlsx)
library(dplyr)

# Data Read & Consolidate -------------------------------------------------

#create empty dataframe to store data from xl files
gdxstate0715 <- data.frame()
#setup vector of column classes
gdxclasses = c("character", "character", "numeric", "numeric", "numeric", "numeric", "numeric", "numeric", "numeric", "numeric", "numeric", "numeric")

#read files that end with xlsx
gdxfiles = list.files(".", pattern="GDX_FY[0-1][0-9].xlsx", all.files = FALSE, full.names = FALSE)

#prob - associating fys with data from files names. there are more than 3 variations of fys for 17 files. easier to rename the files manually
fys <- c(2007:2015)

#NOTE will read all files from 2007 to 2015 
for(i in 1:length(gdxfiles)){
  tmpdfState <-  read.xlsx(gdxfiles[i],
                           sheetIndex = 1,
                           colIndex = c(1:11),
                           header=FALSE,
                           startRow = 6,
                           endRow = 58,
                           stringsAsFactors = FALSE)
  
  #remove white spaces in State Column
  tmpdfState$X1 <- trimws(tmpdfState$X1)
  
  #create a column to store fiscal year; number of rows should match those of the dataframe
  fy <- rep(fys[i],nrow(tmpdfState))
  
  # attach fiscal year to the temporary dataframe - this represents all states for a fiscal year
  tmpdfState <- cbind(fy, tmpdfState, stringsAsFactors = FALSE)
  
  gdxstate0715 <- rbind(gdxstate0715, tmpdfState, stringsAsFactors = FALSE)
  
}

#add shortened column names
names(gdxstate0715) <- c("FY", "StateName", "VetPop", "TotX", "CP", "Cons", "EduVoc", "Loan", "GOE", "InsInd", "MedCare", "Uniques")

#convert FY to character
gdxstate0715$FY <- as.character(gdxstate0715$FY)

#convert to numeric
gdxstate0715$Uniques <- as.numeric(gdxstate0715$Uniques)

#add state abbreviations
st <- data.frame(state.abb, state.name, stringsAsFactors = FALSE)
st <- rbind(st,c("DC", "District of Columbia"))
st <- rbind(st,c("PR", "Puerto Rico"))
st <- rbind(st,c("GU", "Guam"))

gdxstate0715$State <- st$state.abb[match(gdxstate0715$State, st$state.name)]

#drop NA rows
gdxstate0715 <- filter(gdxstate0715,!is.na(State))

#reorder columns
gdxstate0715 <- gdxstate0715[, c(1,13,2:12)]

# Remove temp variables
rm( tmpdfState, fy, fys, gdxclasses, gdxfiles, i, st)

#SAVE State data
# as Rds (efficient)
saveRDS(gdxstate0715, file="gdxstate0715.rds")
#as CSV (broadly accepted)
write.csv(gdxstate0715, file="gdxstate0715.csv")


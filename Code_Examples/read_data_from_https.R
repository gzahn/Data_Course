
# How to read data straight from the web ####

# If it's https (what isn't, these days?) then you need the RCurl package

# Load package
library(RCurl)

# Use getURL() function to assign the link text to an object 
download <- getURL("https://raw.githubusercontent.com/gzahn/Data_Course/master/Data/BioLog_Plate_Data.csv")

# use that object and read it as a .csv file
df = read.csv(text = download)



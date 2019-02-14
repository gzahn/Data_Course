
# load data
df = read.csv("./Data/MLO_OTU_Table.csv", row.names = 1)
meta = read.csv("./Data/MLO_Metadata.csv")

#look at df
df

# looks sparse....how many columns (species) are simply not present in these samples?
which(colSums(df) == 0) # a bunch! could wrap this line in length() to get a count

# remove "empty" columns
df = (df[,which(colSums(df) > 0)]) 

# how about row sums (these would be samples with no observed species)
rowSums(df) # I see some 'zeroes'

# remove empty rows (samples)
df = df[rowSums(df) > 0,] # now have 306 rows and 46 columns ... should be no "empty" rows or columns


#compare the lengths
length(meta$SampleID)
length(row.names(df)) #there are samples in the metadata that aren't in the otu table

#define rows in meta that are ALSO in df
good.samples = which(meta$SampleID %in% row.names(df))

# remove rows from meta that aren't in df
meta = meta[good.samples,]

# are the rows in both data frames in the same order???
identical(meta$SampleID, row.names(df)) # nope

# put them into same orderorder
order(meta$SampleID) # this shows inherent order
order(row.names(df))

# BUT.... these names are actually dates. We want to put them into chronological order

#convert meta$SampleID to date format and save in new column (so as to keep in original order)
meta$Date = as.POSIXct(meta$SampleID, format = '%d-%m-%Y') # look up this function and POSIXct format!

# Check order of dates in meta
order(meta$Date) #looks good, but rearragne to make sure
meta = meta[order(meta$Date),]

# Make a similar column of dates for df
df$Date = as.POSIXct(row.names(df), format = '%d-%m-%Y') # this uses row names to generate POSIXct dates in a new column

# take a look at order
order(df$Date) # all over the place...that's not tidy

# Rearrange df to fit chronological order
df = df[order(df$Date),]

# Check if it is now in the same order as meta
identical(df$Date,meta$Date) # If this returns "FALSE" then something went wrong

# NOW WE CAN EASILY COMBINE THE TWO DATA FRAMES SINCE THEY'RE IN MATCHING ORDER AND HAVE THE EXACT SAME SAMPLES IN EACH GIVEN ROW
# bind them together, and save as new object called, simply, "data"
data = cbind(meta,df)



######

# Another way of doing this...

#Simply make a date column for each one, as above, and then "merge them"
data2 = merge(meta,df, by="Date")

# this still doesn't take care of inherent ordering issues, etc., 
# so it's not a one-step solution to tidy intuitive data, but it's a nice shortcut



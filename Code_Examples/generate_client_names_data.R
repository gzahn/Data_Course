# Kind of sloppy, but it works. This code generates all the directories and files
# for client names and price adjustments for the "find" BASH exercise

library(tidyverse)

# read data
nm <- read.csv("./Data/data-shell/client_names.txt",header = FALSE)

# clean up trailing spaces from each name - into a vector
nms = unlist(map(str_split(as.character(nm$V1),"  "),1))

# set up for-loop
t=list()
x=1

# for-loop to randomly sample names into a list
for(i in 1:100){
t[[x]] <- sample(nms,30,replace = FALSE)
x=x+1
}

# set up random price adjustment loop
p=list()
x=1

# for-loop for random numeric values to attach to names

for(i in 1:100){
  # random price adjustment values
  pa <- rnorm(30,1,.1)
  p[[x]] <- pa
  x=x+1
}

# combine the two lists into 100 new objects and write to new directory file
for(i in 1:100){
  comb <- as.data.frame(cbind(t[[i]],p[[i]],rep(i,30)))
  names(comb) <- c("ClientName","PriceAdjustment","TimePoint")
  assign(paste0("list_",i),comb)
}

comb# Write them to files ####

#get names of objects
obj <- ls(pattern = '_')

# Create new folders
nums = str_pad(unlist(map(str_split(obj,"_"),2)),side = "left",pad = "0",width = 3)

for(i in nums){
dir.create(path=paste0("./Data/data-shell/names/timepoint_",i))
}

# get folder paths
path <- list.dirs("./Data/data-shell/names",recursive = TRUE)

# remove parent directory
path <- path[-1]

# redo for-loop, but write files this time
i=1
x=1
for(i in as.numeric(nums)){
  comb <- as.data.frame(cbind(t[[i]],p[[i]],rep(i,30)))
  names(comb) <- c("ClientName","PriceAdjustment","TimePoint")
  write.csv(comb,paste0(path[i],"/price_adjustment_",nums[x],".csv"),quote = FALSE,row.names = FALSE)
  x=x+1
}


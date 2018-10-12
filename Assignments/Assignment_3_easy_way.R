# install.packages("dplyr")
library(dplyr) # install this package if you haven't already

# for loops on files and objects (instead of just vectors)

################# Make csv files to test function on ################

if(dir.exists("empty_directory") == FALSE){
  dir.create("empty_directory") # this will make a new directory in your file system named "empty_directory"
}
  
setwd("empty_directory/")

# define fake objects
dfs = c("df1","df2","df3","df4","df5","df6","df7","df8","df9","df10")

# assign patterned random data to objects
for(i in dfs){
  assign(i, 
         data.frame(Col1 = 1:100, 
                    Col2 = abs(rnorm(100)), 
                    Col3 = rbinom(100, size = 100, prob = sample(c(.25,.5,.75),1))),
         envir = .GlobalEnv)
}
rm(dfs, df) #cleanup

# write fake csv files
for(i in objects(pattern = "df")){
  write.csv(get(i), file = paste0(i,".csv"))

}

list.files() # check to see that they showed up in our new directory

#remove all those "df" objects from the environment

rm(list = ls(pattern = "df"))
rm(i)

############### Read in those csv files with function to compute values of each ###############

list.files(pattern = ".csv") # make sure R can see the files you want (and nothing more)

# set counter and empty vectors
mean_values = c()
names = c()
x=1
# read fake files, get mean value of column 3 and save into a vector


for(i in list.files(pattern = ".csv")){
  df = read.csv(i)
  names[x] = i
  mean_values[x] = mean(df[,3])
  x=x+1
}

data.frame(FILE = names, Mean_Col3 = mean_values)

# also:  
?eapply


############ Manipulating system files from R ####################

path = file.path("empty_directory/")
remove_these = paste0(path,list.files(path = path, pattern = "df"))
file.remove(remove_these)
file.remove(path)

##################################################################



############## Now, time for our first package ##############

# change working directory back to .../Data_Course/data/
setwd("~/Desktop/GIT_REPOSITORIES/Data_Course/data/")

# read in the thatch and csv file again
dat = read.csv("thatch_ant.csv", stringsAsFactors = FALSE)

# Clean it up just like previous class period
unique(dat$Headwidth)

mm = which(dat$Headwidth == "41mm")
empty = which(dat$Headwidth == "")

dat$Headwidth[mm] = "41.000"
dat$Headwidth[empty] = NA

unique(dat$Headwidth)

dat$Headwidth = as.numeric(dat$Headwidth)
dat = na.omit(dat)

##### Now that it's clean and tidy, summarize for each Size.class category #####

size.class.summary = dat %>%
  group_by(Size.class) %>%
  summarise(N = n(), Mean = mean(Headwidth), SD = sd(Headwidth))

size.class.summary

#### Our first groovy package ####
# dplyr (note that we called this library on the first line of the script)


# dplyr "verbs"
?select()
?filter()
?arrange()
?mutate()
?group_by()
?summarize()
# ....and the best of them all....
%>%  #no help file for this one. It's a "pipe" just like in Bash

# these next two lines are equivalent:  
select(dat, Colony)
dat %>% select(Colony)  
    

# select - selects COLUMNS
dat %>% select(-Colony) %>% head()

dat %>% select(starts_with("H")) %>% head()

# filter - selects ROWS
dat %>% filter(Headwidth > 40) %>% head()

# mutate - makes new columns out of existing columns
dat %>% mutate(New_Column = Mass*Headwidth) %>% head()

# group_by - makes artificial groups based on a column
dat %>% group_by(Size.class) %>% head()

# group_by is most useful when combined with summarize() / summarise()
dat %>% group_by(Size.class) %>%
  summarize(First_thing = mean(Mass)) #column name = function of other column

# you can split onto multiple lines to make it more readable
dat %>% group_by(Size.class) %>%
  summarize(MeanMass = mean(Mass), #separate each new summary with ","
            MeanHeadwidth = mean(Headwidth),
            MaxHeadwidth = max(Headwidth))
  
# to save our summary, assign the whole thing to a new object!
new_object = dat %>% 
  group_by(Size.class) %>%
  summarize(MeanMass = mean(Mass),
            MeanHeadwidth = mean(Headwidth),
            MaxHeadwidth = max(Headwidth))
# the functions we use inside "summarize()" must return a single value!




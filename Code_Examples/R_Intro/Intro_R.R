#######################
### THE VERY BASICS ###
#######################

# What is R?

# R is an open source programming language and software environment
# for statistical computing and graphics that is supported by the 
# R Foundation for Statistical Computing. The R language is widely 
# used among statisticians and data miners for developing statistical 
# software and data analysis.

# "COMMENTS"

# This hastag symbol "#" denotes a comment. That means the computer will ignore everything on a line after it
# That's why each of these lines begins with a "#"
# It's good practice to use these comments to help lay out your plan in a readable manner
# Or just to give some useful information

# "EXPRESSIONS"

# R can handle all sorts of mathematical and logical expressions. 
3+4 # Here, it will evaluate 3 + 4, but it ignores everything after the hashtag on this line
5*2 # This evaluates 5 times 2
10/3 # Can you figure out this one? ;)

# ASSIGNMENTS

# You can assign values, vectors, lists, or even data tables to an object for later use
# There are two main ways of doing this: an equal sign (=), or a directional arrow (<-)

bob = 3+4 # This assigns the evaluated function (3 + 4) to an object (like a variable) called "bob"
# bob should equal 7
jane <- 5*2 # This assigns the value of 5 times 2 to an object called "jane" - Either symbol works

# LOGICAL EVALUATIONS

# R can process a host of logical evaluations.  For example we can ask whether bob or jane is greater...
bob > jane # This gives us the value "FALSE" - bob is 7, jane is 10
bob < jane # This gives the value "TRUE"
bob %in% c(1,2,3,4,5,6,7)
c(1,2,3,4,5,6,7) %in% bob
bob >= jane
bob == jane
jane == 10
(jane == 10) + 1   #!???

# The values "TRUE" and "FALSE" are special reserved values. You should never use them as a name for an object!!!
# This goes for numbers as well. The number "3" cannot be assigned to any other value, for obvious reasons.



###############
#    INPUT    #
###############

# You can just sit around in R naming numbers and doing arithmetic, but a calculator is probably faster for that
# What you really want is to work on data, most likely

# You can input your data into R manually, or you can import it from something like a spreadsheet

# One way to manually enter data is with the command c() 
# That stands for "concatenate" and allows you to enter a series of values to be saved to a single object:
billy = c(2,3,4,5,6) # "billy" is now a NUMERIC VECTOR of 5 values
# c() requires you to separate the various elements with a comma

# This works for STRINGS as well. Strings are made up of characters
suzy = c("This","is","a","character","vector") # notice how each string is enclosed in quotes. That tells R it is a string

# Think of these values (billy and suzy) like lists.  They have inherent order, so we can access any part of them:

billy[1] # The brackets [] allow you to pick one or more elements from an object.  Here, we asked for the first element
# What value would billy[3] give you?

# If our vectors are the same lengths, we can easily combine them to form "2-dimensional" data. Most data you
# want to explore will probably be 2-dimensional. If you have a series of observations and measured several variables
# during each observation, that is 2-dimensional. Let's input some fake biological data to take a look:
# we can pretend that we collected 10 random fruit flies and measured their wingspan and mass

observation = c(1,2,3,4,5,6,7,8,9,10) # our vector of observations from a reeated experiment
wingspan = c(1.2,1.4,1.0,1.2,1.8,2.0,2.2,1.1,2.3,2.0) # our vector of wingspans
mass = c(0.43,0.44,0.32,0.44,0.52,0.55,0.56,0.42,0.51,0.57) # our vector of mass

# we now have three vectors that are the same length. We can stick them together into a "matrix"
# one way to do this is the cbind() function. It stands for "column bind"

cbind(observation,wingspan,mass) # this will show us our matrix, but we want to assign it to an object!

data = cbind(observation,wingspan,mass) # assigned to an object called "data"

data

# Accessing elements of 2-dimensional data

# Just like a 1-dimensional vector, we can access any part of our matrix, but we need to provide 2 locations.
# We need to give a row position and a column position
# in R, the brackets to access an element accept input as follows: [row,column]
# So to get the element in row 1, column 3 we write:

data[1,3]

# This kind of access is very useful. To add the mass of the first 5 flies we caught, you can write:

data[1,3] + data[2,3] + data[3,3] + data[4,3] + data[5,3]

# or you could use the "sum" function, which adds all the elements inside it, separated by commas

sum(data[1,3],data[2,3],data[3,3],data[4,3],data[5,3])

# But there's an easier way...

data[1:5,3] # This gives you ROWS 1 through 5, and COLUMN 3 - 1:5 means "1 through 5"

sum(data[1:5,3]) # All you have to do is enclose that in the "sum" function!

# With 2-dimensional data, if you want ALL of the rows or columns you just leave that index blank

data[,3] # This gives you ALL rows, but only column 3
data[3,] # This gives you ONLY row 3, but all columns

# With our fake flies, we are fake interested in seeing whether wingspan correlates with total mass
# Check out how easy it is to start plotting that!

plot(x=data[,2], y=data[,3]) # the plot() function wants you to give it the vector for the x and y axes. DONE!
# We told the plot function that our x axis should be column 2 (wingspan) and the y axis should be column 3 (mass)

# Want to see if that correlation we see is statistically significant?  R makes that very simple as long as you 
# know what tests to use!

summary(glm(data[,3] ~ data[,2])) # this gives a summary table of a general linear model test

#########################
#    IMPORTING DATA     #
#########################

# Odds are that you will have a lot more than 10 flies and two measurements each
# These data are usually entered into something like excel
# Excel is great, but it's actually a binary file type that can't be read by other programs
# What we want is called a "fixed-width" file
# These are most commonly comma-separated (.csv) or tab-separated (.tsv)
# Excel can export your data table in either of these formats

# A comma-separated version of our "data" object looks like this (without the hashtags, of course):

# "observation","wingspan","mass"
# 1,1.2,0.43
# 2,1.4,0.44
# 3,1,0.32
# 4,1.2,0.44
# 5,1.8,0.52
# 6,2,0.55
# 7,2.2,0.56
# 8,1.1,0.42
# 9,2.3,0.51
# 10,2,0.57

# This is easy for a computer or a human to read!

# We can directly import a csv file into R.  Let's test it with a rather large data table:
# we will use the function read.csv() to import a famous data set

# This famous (Fisher's or Anderson's) iris data set gives the measurements in centimeters 
# of the variables sepal length and width and petal length and width, respectively, for 50 
# flowers from each of 3 species of iris. The species are Iris setosa, versicolor, and virginica.

read.csv("Code_Examples/R_Intro/iris.csv") # this prints it directly to the screen. we want to save it to an object

iris = read.csv("Code_Examples/R_Intro/iris.csv")

# Since this data table has more than just one type of entry (numeric columns AND a character column), it isn't
# strictly a matrix, which consists of only numeric data
# this is called a "data frame" in R, and it is one of the most common data types you will work with

# take a look at the iris data frame by printing it's object to the screen
iris

# One advantage of a data frame over a matrix is that the columns (and rows) can have names

# Look at the names of the columns:
names(iris)

# This makes it much easier to access certain parts of the data set using a special character, "$"
# To just look at the data for the species, Iris virginica:

iris[iris$Species == "virginica",]

# There is a lot to unpack in that command...
# First, the "$" immediately after the data frame object allows you to pick a column by name
# Second, we are telling R to look at column "Species"
# Third, we are telling R that in that column select only the rows that match the name "virginica" 
# The quotes are essential, otherwise R will look for an object called virginica!
# Last, notice that comma... remember that R needs the rows AND the columns, in that order
#    we are telling R to give us ALL columns, but only the rows in which Species is equal to "virginica"
# == is the symbol for "is equal to" . . . = is the symbol to assign a value to an object!

# Write a command that will subset the iris data so that we get only the PETAL LENGTHS of the species "setosa"


iris[iris$Species == "setosa","Petal.Length"] # for the column, we can just put the name in quotes


# Let's look at the relationship between Sepal Length and Petal Length for each species
# We can use the basic plot() function

plot(x = iris$Sepal.Length, y = iris$Petal.Length) # using that handy "$" !!!

# okay, that's a confusing figure. All the different species are mixed together, so let's just look at one species
# going back to the other way of accessing subsets of your data, namely the brackets [,], use the plot function
# to look at the same relationship, but only for the species, "virginica"

# here's an ugly way of doing that:
plot(x = iris[iris$Species == "virginica","Sepal.Length"], y = iris[iris$Species == "virginica","Petal.Length"])

# one easy way is to subset your data frame into a new one that only contains "virginica"
virginica = iris[iris$Species == "virginica",]
# then plot it from that
plot(virginica$Sepal.Length, virginica$Petal.Length)


####################################
#  Messing around with data frames #
####################################

# Let's load a larger data set
# This data set is of fungal species abundances found in various sites in Hawaii, from both leaf surfaces 
# and deep mesophotic coral reef algae.  The "species" are actually just similar DNA reads so we call them 
# "operational taxonomic units" (OTUs), since they are only hypothesized to be species.
# This data set consists of 15,183 species observations from 132 sites.
# The first file is the species observation table
# The second file is information about each sampling site (metadata)

otus = read.csv("Code_Examples/R_Intro/otu_table.csv", as.is = TRUE, stringsAsFactors = FALSE,
         check.names = FALSE)
metadata = read.csv("Code_Examples/R_Intro/otu_mapping.csv", as.is = TRUE, stringsAsFactors = TRUE,
         check.names = FALSE)

# The object "otus" is a data frame with species as rows, and sites as columns
# The elements (each "cell") denote how many times a given species was observed in each site

# Let's look at some aspects of this large data frame
names(otus) # This gives a list of column (site, in this case) names
dim(otus) # This gives the count of rows and columns, in that order
head(otus) # This prints the first 6 rows, giving us a glimpse of the top of the data frame
class(otus) # This tells us what type of object we are looking at (this can be very useful down the road)
row.names(otus) # This lets us see the row names (species, in this case)
length(row.names(otus)) # This uses two functions. Read as: "give the length of the row names vector of the data frame, 'otus'"
# This last one should be the same as element 1 of the dim() function


# We can modify any aspect of our data frame to make it more useful.  For instance, our "species names"
# are just numbers. Let's change them to something more meaningful using a simple example:


species = c(paste("OTU_",1:length(row.names(otus)), sep = "")) # here we create an artificial list of species names
# this list is the same length as our number of species and are named "OTU_1", "OTU_2", etc
# the names don't really matter since these aren't named "species" at this point

# Now we can assign this vector of species names to the otu table
row.names(otus) = species # assign our new names to the row.names values
row.names(otus) # take another look and see how they changed. We can assign any vector of names here


# Let's do some simple exercises to explore our data further

# Which of our sites has the most total species observations?

colSums(otus) # gives the column sums. This is total abundance for each site
plot(colSums(otus)) # we can take a quick look at the distribution in a figure
min(colSums(otus)) # or we can look at things like minimum and maximum values
max(colSums(otus))
# Looks like the maximum site species abundance is 64596 total observations. Which site is this!?

# The which() function will give us the elements that match a logical expression (it will return the element numbers)
which(colSums(otus) == 64596) # we tell R to tell us which column has a sum exactly equal to 64596

# we can do this without knowing the value ahead of time, too
which(colSums(otus) == max(colSums(otus))) # we tell R to find which column has a sum equal to the maximum sum
# this could have been more than one column if there was a tie for maximum

# Let's count the number of missing species in the first column
otus$`3P.1` # this is column 1
otus[,1] # this is also column 1

which(otus[,1] == 0) # these are the positions of all the zeroes in column 1
length(which(otus[,1] == 0)) # this is the length of the positions of all the zeroes in column 1
# that length is the number of zeroes


# How many species (richness) were found in the site with the most species abundance (found in previous step)
# HINT: R can evaluate whether each element is greater than 0 with ">0"

length(which(otus[,which(colSums(otus) == max(colSums(otus)))] > 0)) # this is an ugly way to do it on one line

# Step 1 - find the site with maximum abundance, and assign it to an object
max.site = which(colSums(otus) == max(colSums(otus)))

# Step 2 - Subset your otu data frame to just look at this single column
site.vector = otus[,max.site]

# Step 3 - find which elements of this column are GREATER THAN 0 (meaning species were present)
positive.site.vector = which(site.vector > 0)

# Step 4 - find the length of this vector, giving you the count of species that had at least 1 observation
length(positive.site.vector)

################################################################################
#   We can combine simple tools like this to ask ANY question about our data!  #
################################################################################

# Which SPECIES (OTU) has the greatest abundance across the entire data set??
# HINT: rowSums()  will be a handy function, just like colSums() was for the previous question

which(rowSums(otus) == max(rowSums(otus)))


# Which OTU is present in more sites than any other?? (This one is much tougher to answer)
TF = otus > 0
sums = rowSums(TF)
maximum = max(sums)
which(rowSums(TF) == maximum)


# make backup copy of data frame ("pa" for "presence-absence")
otu_pa = otus

# Convert everything greater than 0 to 1
otu_pa[otu_pa>0] = 1







#######################
#      PACKAGES!      #
#######################

# One of the best things about R is that thousands of terribly smart people are constantly writing code for it
# that you can use for free.  This code usually comes in what are called "packages"

# It's (usually) easy to install a package, especially with R-Studio

# Here's an example of how useful many of these packages can be.  This one is called ggplot2 and it is amazing
# for making publication-quality figures, and for making them reproducible 
# We will save ggplot2 for a future workshop, but it's a great example of how R makes your data analyses simple
# and REPRODUCIBLE





library(ggplot2) # library() loads a given package
ggplot(iris, mapping = aes(x = Sepal.Length, y = Petal.Length, col = Species)) +
  geom_point() +
  geom_smooth(method = "lm", se = FALSE)


# Another handy package let's us combine two plots into one figure.
# In this case, it let's us look at the difference between length and width simultaneously

library(gridExtra)

length.figure = ggplot(iris, mapping = aes(x = Sepal.Length, y = Petal.Length, col = Species)) +
  geom_point() +
  geom_smooth(method = "lm", se = FALSE) +
  scale_y_continuous(limits = c(0,8)) +
  theme(legend.position = "none") +
  ggtitle("Sepal vs. Petal LENGTH")

width.figure = ggplot(iris, mapping = aes(x = Sepal.Width, y = Petal.Width, col = Species)) +
  geom_point() +
  geom_smooth(method = "lm", se = FALSE) +
  scale_y_continuous(limits = c(0,8)) +
  # theme(legend.position = c(.85,.75)) + 
  ggtitle("Sepal vs. Petal WIDTH")

grid.arrange(length.figure,width.figure, nrow = 1)


# You can include that code in your report so that anyone can reproduce your exact figure.  Also, as you add data,
# there is never a need to re-make your figures.  Just re-run your code!


# Back to our OTU table, there is a package called "vegan" which does a billizion useful things for community ecology

library(vegan)

?decostand

otus_pa = decostand(otus, method = "pa") # one function, decostand(), lets us standarize our data. In this case,
# we wanted presence/absence, since we are interested in which OTU is present in more sites than any other,
# not so much in overall abundance

# otus_pa is now a version of our data frame where all positive values have been changed to 1, and zeroes stayed 0

# now it's a simple exercise to find which OTU was present in the most sites

summary(rowSums(otus_pa)) # take a peek at the distribution of how many sites each OTU is found in
boxplot(rowSums(otus_pa)) # look at it graphically with a boxplot

# Most OTUs are found only in one or a few sites. The most common OTU is found in 98 sites

max.sites = max(rowSums(otus_pa))
which(rowSums(otus_pa) == max.sites) # We see that OTU_1236 is the most commonly encountered by site


#########################
#  A bit more advanced  #
#########################


# We can also easily create a heatmap to look at abundances broadly
# heatmap(as.matrix(otus)) # this will take some time to run...there are > 15000 species to compute

# That heatmap has some issues! It's impossible to read, the colors are ugly. I hate it.
# Let's subset our data so we're just looking at the most abundant species

abundant.otus = otus[rowSums(otus) > 10000,] # this tells R: pick only rows whose sums are greater than 10000, but show all columns
heatmap(as.matrix(abundant.otus)) # This is easier to read, but still ugly
?heatmap # take a look at the heatmap function and its options
heatmap(as.matrix(abundant.otus), col = gray.colors(100)) # we can change the colors to grayscale (with 100 possible values)

# We can also add color labels from our site metadata
names(metadata) # Look at what info we have about our sites
# This object links our sample names to which "Project" (ecosystem, in this case) and "HostTaxon" they are associated with

# First, we will want to convert our "Project" information into color names for R


unique(metadata$Project) # Find the possible values of "Project"
# We should see two options: "Snail" and "Meso_Algae" - These represent the ecosystem from which samples were taken

# We can convert these into colors using a handy function from the "plyr" package
library(plyr)
ecosys.colors = mapvalues(metadata$Project, from = c("Snail","Meso_Algae"), to = c("Green", "Blue"))


heatmap(as.matrix(t(abundant.otus)), col = gray.colors(100),
        Rowv = NA, distfun = vegdist)

# This heatmap makes me happy! Our heatmap columns are colored by habitat and it's much easier to read.
?dist



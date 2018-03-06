rm(list = ls())

# This tutorial will walk you through the basic R skills we cover in class:
#         1.  Overview of diversity and ordination with vegan
#         2.  Loading Data into R - Proper format
#         3.  Common analyses - Rarefactions, Normalization, Diversity Measures
#         4.  Visualizing your diversity metrics and ordinations

# First thing is to install and load the vegan package

# Install vegan, if you haven't already
# install.packages("vegan")

# Load the vegan package
library(vegan)


# Now, before we worry about loading our own data or making it look pretty, let's take a basic look
# at how ordinations work in vegan using some simple random data . . . 

################################################################################
#             An overview of metrics and ordination with vegan                 #
################################################################################

# Set random seed so results are reproducible
set.seed(55)

# Generate a random community matrix, similar to the type of data in an OTU Table
prob = c(0.99,rep(0.05,1000)) # sets probability of each number being randomly chosen

community_matrix=matrix(
  sample(0:1000,300,replace=T, prob = prob),nrow=10,
  dimnames=list(paste("Sample_",1:10,sep=""),paste("OTU_",1:30,sep="")))

# Add a treatment vector, assigning samples to one of two groups
treat=c(rep("Treatment_1",5),rep("Treatment_2",5))

# Take a quick look at your "OTU Table"
community_matrix  # should have 10 samples as rows, and 30 OTUs as columns

# Check to see how even your sampling effort for each community is
barchart(rowSums(community_matrix))
min_depth = min(rowSums(community_matrix)) # this gives us the minimum number of reads in a given sample

# Look at rarefaction (species accumulation) curve
rarecurve(community_matrix, step = 100, sample = min_depth) # vegan's built-in S.A.C. function

# We should normalize our data to account for variable sequencing depth.  One way is to rarefy...
set.seed(55) # set random seed so it's reproducible

rare_community_matrix = rrarefy(community_matrix, min_depth) # randomly subsamples data to given depth and makes new OTU table


# How many species were found in each sample?
specnumber(community_matrix)
specnumber(rare_community_matrix)

# How many species were found in each treatment group?
specnumber(community_matrix, groups = treat)
specnumber(rare_community_matrix, groups = treat)

# Calculate Shannon diversity for each sample
diversity(community_matrix, index = "shannon")
diversity(rare_community_matrix, index = "shannon")

# Beta diversity (basic Whittaker index)
beta_div = betadiver(community_matrix, method = "w")
beta_disp = betadisper(beta_div, treat)
plot(beta_disp)

# Run metaMDS(), which automatically calculates a community distance matrix, transforms it,
#                                               and calls monoMDS() which performs the NMDS

example_NMDS = metaMDS(rare_community_matrix, # Our community-by-species matrix
                     k=2) # The number of reduced dimensions

# Take a look at the distances between each pair of communities against their original dissimilarities
# This let's us see how well-preserved community distances are, given that they have been reduced to 2-D

stressplot(example_NMDS) # Lots of scatter means poor preservation


# Plot the ordination
ordiplot(example_NMDS, type = "n") # Sets up the plotting area
orditorp(example_NMDS,display="sites",col="red",air=0.01) # Adds the samples in ordination space
ordiellipse(example_NMDS, groups = treat, label = TRUE) # Calculates the centroid and 95% C.I. of each treatment group

# What you are looking at is a plot of community similarity between your samples that has been reduced to 2D
# Samples that are closer together in the plot have more similar community compositions
# The ellipses overlap, meaning there appears to be little to distinguish communities based on Treatment.
# This is not unexpected, given that our data are fake, and randomly drawn from the same distribution.





################################################################################
#                   Loading data into R - Proper Format                        #
################################################################################

# It is possible to directly import the biom file provided by QIIME, but this depends on the "biomformat" 
# and "Matrix" packages, and versions and dependencies can get confusing, so we will start with a tab-separated OTU table.


# To prepare your biom file you need to convert it to tab-separated format and clean up the first line
# On the command line, you can do the following:

# biom convert --to-tsv --table-type "OTU table" -i otu_table_mc2_w_tax.biom -o otu_table_mc2_w_tax.tsv
# tail -n +2 otu_table_mc2_w_tax.tsv | sed 's/^#OTU ID/OTU_ID/'| head -1 > otu_table.tsv

# those two lines will convert your biom to tsv and clean up the first 2 lines of the file so R can read it easily
# the other file you will need is the sample metadata.  Typically, you will make this in excel, and it has sample IDs as rows
# and information about each sample as columns.

# For this tutorial we're going to start with an example dataset


# To read a tsv file into R we can do the following:
otu_table = read.delim("~/Desktop/GIT_REPOSITORIES/Data_Course/code_examples/Vegan_Example/vegan_example_otu_table.tsv", sep = "\t", row.names = 1)
metadata = read.delim("~/Desktop/GIT_REPOSITORIES/Data_Course/code_examples/Vegan_Example/vegan_example_metadata.tsv", sep = "\t", row.names = 1)

# The OTU table from QIIME, by default, has samples/sites as columns and OTUs/Species as rows.
# This is fine, but we will need to transpose it in order to use vegan.
# First, look at the dimensions of the two tables:

dim(otu_table)
dim(metadata)

# There appears to be one additional Sample in the OTU table that isn't in the Metadata... this is the Taxonomic Assignment
# We can pull this off to save it for later:

# Look at the names of the columns in the OTU table (sample names)
names(otu_table) # that last one is the taxonomy from QIIME

# We can build a separate data frame to store our taxonomic assignments
Taxonomy = data.frame(Taxonomy = otu_table$Tax_Name, row.names = rownames(otu_table))

# And now, get rid of them from the otu table for now so we can use vegan
otu_table = otu_table[,which(colnames(otu_table) != "Tax_Name")]

# Now, transpose the otu table so rows are samples, and OTUs are columns
otu_table = as.data.frame(t(otu_table))

# Now, let's check the dimensions again
dim(otu_table)
dim(metadata)

# ...And make sure they're in the right order
identical(rownames(otu_table), rownames(metadata)) # if "TRUE", then they are exactly the same, and in the same order


################################################################################
#                Common Analyses - Diversity and Ordination                    #
################################################################################

# Just like the example with random data, we will first take a look at sampling effort
barchart(rowSums(otu_table))

# What is the minimum number of reads in a given sample?
min_depth2 = min(rowSums(otu_table)) # should be 2000 for this data set

# Look at rarefaction curves and draw vertical line at the minimum depth (our probable rarefication level)
rarecurve(otu_table, sample = 2000, step = 100, cex = .5)

# Normalize the data by rarefying
set.seed(1)
rare_otu_table = rrarefy(otu_table, min_depth2)

# How many OTUs are found in each sample?
specnumber(otu_table)
specnumber(rare_otu_table)

# compare before and after rarefication
plot(specnumber(otu_table),specnumber(rare_otu_table)) # there was some loss of species richness during rarification

# Look at it by groups (Ecosystem)
specnumber(otu_table, groups = metadata$Ecosystem) # refers to the metadata table
specnumber(rare_otu_table, groups = metadata$Ecosystem) # refers to the metadata table

# Look at Shannon Diversity
diversity(otu_table, "shannon")
diversity(rare_otu_table, "shannon")

# compare before and after rarefication
plot(diversity(otu_table, "shannon"),
     diversity(rare_otu_table, "shannon"))

# Find the number of samples in which each OTU is found
species_presence = apply(rare_otu_table > 0,2,sum)
barchart(species_presence)

# Calculate a distance matrix for your samples (determine dissimilarity)
# Which method to use?

# We can have some help deciding which distance index to use (Bray-Curtis is the default)
rank_otus = rankindex(metadata$Ecosystem, rare_otu_table, indices = 
            c("bray", "euclid", "manhattan", "horn"), method = "spearman")

print(paste("The highest rank was given by the", names(sort(rank_otus, decreasing = TRUE)[1]), "method."))

# Since rankindex() told us that "bray" is probably best, we will pass that method to the metaMDS command

# run NMDS (this calculates the distance using "horn" method, transforms the data, and runs isoMDS 20 times to find best
# solution)
MDS = metaMDS(rare_otu_table, distance = "bray", try = 50, trymax = 100)

# Check out the stress plot
stressplot(MDS)  # looks pretty good - has linear fit R2 of 0.946


# Plot it
ordiplot(MDS, type = "p")
ordiellipse(MDS, groups = metadata$Ecosystem, label = TRUE) # Calculates the centroid and 95% C.I. of each treatment group


# Beta Diversity

rare_otu_table.horn = vegdist(rare_otu_table, method = "horn") # Generates the distance matrix, as in metaMDS
beta_div = betadisper(rare_otu_table.horn, group = metadata$Ecosystem) # Calculate homogeneity of multivariate dispersions

boxplot(beta_div) # show boxplot of beta diversity by ecosystem



# Want to make it look pretty?

# We call pull out the cartesian coordinates and build a data frame that is easier to work with
MDS1 = MDS$points[,1] # gives vector of X coordinates
MDS2 = MDS$points[,2] # gives vector of Y coordinates


NMDS = data.frame(MDS1 = MDS1, MDS2 = MDS2, Ecosystem = metadata$Ecosystem, 
                  Lat = metadata$Latitude, Lon = metadata$Longitude, Host = metadata$Host)

# Load ggplot2, a package that allows much more flexible visualization of data
library(ggplot2)

# ggplot2 is its own can of worms, but it can label, color, and make a legend automatically, which is nice
ggplot(NMDS, mapping = aes(x = MDS1, y = MDS2, col = Ecosystem)) +
  geom_point() +
  stat_ellipse() +
  theme_bw() +
  ggtitle("NMDS")





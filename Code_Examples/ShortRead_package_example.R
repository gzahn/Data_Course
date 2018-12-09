rm(list = ls())

# only have to do this biocLite stuff once

source("http://bioconductor.org/biocLite.R")
biocLite()
biocLite("msa")
biocLite("S4Vectors")
biocLite("SummarizedExperiment")
biocLite("ShortRead")



# Load libraries

library(ShortRead)
library(tidyr)
library(stringr)
library(msa)


setwd("/home/gzahn/Desktop/GIT_REPOSITORIES/Data_Course/data/Fastq_16S/")
fq.files = dir(getwd(), full.names = TRUE, pattern = ".fastq")

fq.1 = readFastq(fq.files[1])
fq.2 = readFastq(fq.files[2])

fq.1
fq.2

# show reads
sread(fq.1)
reads.1 = sread(fq.1)

# show quality scores
quality(fq.1)
qual.1 = quality(fq.1)

# show read IDs
id(fq.1)
ids.1 = id(fq.1)


# get frequencies of nucleotides in fastq reads
nucl.freq = alphabetFrequency(sread(fq.1), as.prob = TRUE, collapse = TRUE)

# get quality scores as a matrix
qual = as(quality(fq.1), "matrix")

# plot mean quality scores by cycle
plot(colMeans(qual), type = "b")


# Convert fastq to fasta and write them to files in same directory
writeFasta(fq.1,"fq1.fasta")
writeFasta(fq.2,"fq2.fasta")

# Get fasta files (the ones you just wrote to disk)
fa.files = dir(getwd(), full.names = TRUE, pattern = ".fasta")


# import fasta files, formatted for sequence alignment
fa.1 = readDNAStringSet(fa.files[1])
fa.2 = readDNAStringSet(fa.files[2])




##### perform multiple sequence alignment with default settings #####
align1 = msa(fa.1)
align2 = msa(fa.2)




# if you want to print the full alignment and/or save as a text file
print(align1, show = "complete") # you could wrap this in sink() to save it

# if this is a phylogenetically informative region of DNA, you can build a tree from these alignments
# but first you need to decide what tree package you want and convert the alignment to that format


# we will use phangorn
library(phangorn)

# convert to seqinr format...
seq_align1 = msaConvert(align1, type="phangorn::phyDat")
seq_align2 = msaConvert(align2, type="phangorn::phyDat")

# explore the fasta alignment objects
summary(seq_align1)

# Build a distance-matrix (comparing "differences between each pair of sequences)
# several ways of doing this .. we will use "maximum likelihood"
dm1 = dist.ml(seq_align1)              
dm2 = dist.ml(seq_align2)
#check it out
head(dm1,20)
# each number is the "distance" between the sequences indicated in "rows" and "columns"


# We can use the values to compute a phylogenetic tree

# first, we will try a "Neighbor-Joining" tree method
NJ.1 = NJ(dm1)
NJ.1

NJ.2 = NJ(dm2)

# A quick way to plot a tree
plot(NJ.1)
plot(NJ.2)

# This distance matrix method is computationally cheap, but loses some information (i.e., the actual sequences)

# To keep the sequences under consideration...
# compute liklihood of a given tree
fit <- pml(NJ.1, seq_align1)

print(fit)

# find optimum...using Jukes-Cantor nucleotide model (way too many options to cover them all)
fitJC = optim.pml(fit, model = "JC", rearrangement = "stochastic")

# log-liklihood value
logLik(fitJC)

# Use that tree as a starting point, and randomly resample 100 times to compute bootstrap values
bs <- bootstrap.pml(fitJC, bs=100, optNni=TRUE, multicore=TRUE, control = pml.control(trace=0))
plotBS(midpoint(fitJC$tree), bs, p = 50, type="p")
  
# Best way to make a tree look pretty is with a specialized tree-editing program like "FigTree"
# Export this tree
write.tree(bs, file="seq_align1.tre")
  
#  
  
  
  
  
  
  
  
  














####  Try to use another package to quickly plot quality scores ####

source("https://bioconductor.org/biocLite.R")
biocLite("qrqc")


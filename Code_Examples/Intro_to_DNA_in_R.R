rm(list = ls())

# fasta, fastq
# command-line tools
# ncbi
# dealing with sequence data
# downloading sequence data

# only have to do this biocLite stuff once on your computer (hopefully)
# this downloads a series of packages that are for working with DNA data...
# source("http://bioconductor.org/biocLite.R")
# biocLite()
# biocLite("msa")
# biocLite("S4Vectors")
# biocLite("SummarizedExperiment")
# biocLite("ShortRead")



# Load libraries

library(ShortRead)
library(tidyr)
library(stringr)
library(msa)
library(seqinr)


setwd("/home/gzahn/Desktop/GIT_REPOSITORIES/Data_Course/data/Fastq_16S/")
fq.files = dir(path = getwd(), full.names = TRUE, pattern = ".fastq")
fq.files

fq.1 = readFastq(fq.files[9])
fq.2 = readFastq(fq.files[10])

# look at sequence IDs (names)
id(fq.1) 

# show reads
sread(fq.1)
reads.1 = sread(fq.1)
class(reads.1[1])


# show quality scores
quality(fq.1)
qual.1 = quality(fq.1)

# show read IDs
id(fq.1)
ids.1 = id(fq.1)


# Finding patterns (e.g., to remove primer sequences or whatever)
primer = "GTAGTCCACGCCGTAAA"
matches = vmatchPattern(pattern = primer, subject = reads.1, fixed=TRUE)
reads.1[matches]

# trimming low-quality reads from ends of ShortRead objects
quality(fq.1)
alphabet(quality(fq.1))
trimmed = trimEnds(fq.1, a = "H")
quality(trimmed)
sread(trimmed)


# get frequencies of nucleotides in fastq reads
nucl.freq = alphabetFrequency(sread(fq.1), as.prob = TRUE, collapse = TRUE)

# Look at most common reads in file
tables(fq.1)

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
View(as.matrix(dm1))
heatmap(as.matrix(dm1))
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
  


# If you want to change those tip labels....you'll need to assign taxonomy first (command line is probably best)
  # or you can do it in FigTree, etc.




# If you want to do this in R...you need to have local copies of databases you want to use

library(dada2)  

plotQualityProfile(fq.files[1])

# get filenames for files without path
filt.files = dir(path = getwd(), full.names = FALSE, pattern = ".fastq")

# make new directory
dir.create(file.path(getwd(),"filtered"))

# stringent quality filter to remove N's etc


for(i in filt.files){
  fastqFilter(fn = i,fout = paste0(getwd(),"/filtered/",i,".filt"),
              truncLen = 200, trimLeft = 20)
}


setwd(file.path(paste0(getwd(),"/filtered")))
filtered = dir(path = getwd(), pattern = ".filt")

dr = derepFastq(filtered)
dr$F3D0_S188_L001_R1_001.fastq.filt$uniques

err = learnErrors(dr)

plotErrors(err)

clean = dada(dr,err)

SeqTable = makeSequenceTable(clean)

taxonomy = assignTaxonomy(SeqTable, refFasta = "../rdp_train_set_16.fa.gz")

taxa.print <- taxonomy # Removing sequence rownames for display only
rownames(taxa.print) <- NULL
taxa.print

which(names(as.data.frame(SeqTable)) %in% row.names(as.data.frame(taxonomy)))
RSV = as.data.frame(SeqTable)

taxa = as.data.frame(taxonomy)
View(RSV)
names(RSV) <- paste0(taxa$Family,"_",taxa$Genus)
View(RSV)


write.csv(RSV,file = "RSV_Table_w_taxonomy.csv")


#


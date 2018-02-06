#rm(list = ls())

# This is part 1 - Filtration and trimming of fastq files. This sets up the exact sequence varients
# that will be used in all subsequent analyses.
# make sure all forward fastq files are in uncompressed (not .gz) format in the same directory to start with

library(dada2); packageVersion("dada2")

# File parsing - For this, we will use only the forward illumina reads - make sure to move fwd reads into their own directory for simplest processing
path <- "/home/gzahn/Desktop/GIT_REPOSITORIES/Data_Course/data" # CHANGE to the directory containing your demultiplexed fastq files
filtpath <- file.path(path, "filtered") # Filtered files go into the filtered/ subdirectory
if(!file_test("-d", filtpath)) dir.create(filtpath) # make directory for filtered fqs if not already present
fns <- list.files(path, pattern = ".fastq")
fastqs <- fns[grepl(".fastq", fns)] # CHANGE if different file extensions or to target only certain sequences
fnFs <- file.path(path, fastqs)


# Filtering
?fastqFilter # take a look at the documentation for fastqFilter and choose parameters carefully

# visualize a couple of fwd read quality profiles to help you decide reasonable filtration parameters
plotQualityProfile(fnFs[[1]])
plotQualityProfile(fnFs[[2]])

# Filter fastqs and store in new directory
for(i in seq_along(fastqs)) {
  fastq <- fastqs[[i]]
  fastqFilter(fn = file.path(path,fastq), fout = file.path(filtpath, fastq),
              trimLeft=12, truncLen=240,
              maxEE=1, truncQ=2, maxN=0, rm.phix=TRUE,
              compress=TRUE, verbose=TRUE)
}


#############################################################
# This is part 2 - after denoising and trimming             #
# point filtpath to the output from dada2 filtration        #
#############################################################

# File parsing
# filtpath <- "/home/gzahn/Desktop/Postdoc/Seq_Data/ALL_HAWAII_ITS/SUPER_SET/Fastqs/dada2_filtered/" # CHANGE to the directory containing your filtered fastq files
setwd(as.character(filtpath))

fns <- list.files(filtpath, full.names = TRUE)
filts <- fns[grepl("fastq$", fns)] # CHANGE if different file extensions
sample.names <- sapply(strsplit(basename(filts), "_"), `[`, 1) # Assumes filename = samplename_XXX.fastq.gz
names(filts) <- sample.names

# Learn error rates
drp.learn <- derepFastq(filts.learn, verbose = TRUE)
dd.learn <- dada(drp.learn, err=NULL, selfConsist=TRUE, multithread=TRUE)
err <- dd.learn[[1]]$err_out
rm(drp.learn);rm(dd.learn)

# Sample inference
derep <- derepFastq(filts)
dds <- dada(derep, err=err, multithread=TRUE)

# Construct sequence table and remove chimeras
seqtab <- makeSequenceTable(dds)
seqtab.nochimera <- removeBimeraDenovo(seqtab, multithread=TRUE)
saveRDS(seqtab.nochimera, "example.RDS") # CHANGE ME to where you want sequence table saved

# Distribution of sequence lengths
table(nchar(getSequences(seqtab)))

# fraction of chimeric sequences detected
1-(sum(seqtab.nochimera)/sum(seqtab))

# Make fasta containing all unique ribosomal sequence variants (RSVs) - useful for BLAST taxonomy assignment
seqIDs = paste("seq",(1:length(colnames(seqtab.nochimera))), sep = "_")
uniquesToFasta(seqtab.nochimera, ids = seqIDs, fout = "example_unique_fastas.fasta")
# This fasta can be used to assign taxonomy to RSVs however you choose

# Write traditional tab-separated table of RSVs to samples....if you want.  Probably best to use the .rds R object
write.table(seqtab.nochimera, "example_RSV_table.tsv", 
            sep = "\t", quote = FALSE)



######################################################################################
######                                                                          ######
###### Start here if you have already created and saved the DADA2 RDS object(s) ######
######                                                                          ######
######################################################################################

# to read dada2 sequence table back into R as a data frame if it has already been produced and saved
st1 = readRDS("example.RDS") # to read dada2 sequence table back into R
seq_df = as.data.frame(st1)

######################################################################################
# To combine multiple runs or add more runs to the super set:
# (note: to combine dada2 sequence tables, the fastq files must have gone through EXACTLY the
#  same filtration algorithm from step 1!)


st2 <- readRDS("/path/to/run2/output/NEW_RUN_seqtab.rds")
st3 <- readRDS("/path/to/run3/output/NEWER_RUN_seqtab.rds")
st <- mergeSequenceTables(st1, st2, st3)
saveRDS(st, "/path/to/study/output/combined_seqtab.rds")



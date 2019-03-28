# only have to do this biocLite stuff once on your computer (hopefully)
# this downloads a series of packages that are for working with DNA data...
# source("http://bioconductor.org/biocLite.R")
# biocLite()
# biocLite("msa")
# biocLite("S4Vectors")
# biocLite("SummarizedExperiment")
# biocLite("ShortRead")
# biocLite("Biostrings")

# some handy packages
library(dada2)
library(seqinr)
library(ShortRead)
library(msa)
library(Biostrings)
library(ape)
library(phangorn)


# point to some fastq files
files <- list.files("./Data/Fastq_16S/", pattern = "*.fastq$", full.names = TRUE)

# read them into memory with ShortRead package
fqs <- readFastq(files[1])

# access data
fqs@sread
fqs@quality
fqs@id

# another way to access data
sread(fqs)
quality(fqs)
id(fqs)

# look at full sequence as character string
as.character(fqs@sread[1])

# pull out one sequence to play with
fq.test <- fqs@sread[1]


# some stuff you can do
Biostrings::uniqueLetters(fq.test)
Biostrings::alphabetFrequency(fq.test)
Biostrings::AMINO_ACID_CODE
Biostrings::complement(fq.test)
Biostrings::reverseComplement(fq.test)

# convert to fasta and write to new file
ShortRead::writeFasta(fqs,"./test.fasta")


# quality control and error correction ####
plotQualityProfile(files[c(1,2)])

# get sample names
sample.names <- sapply(strsplit(basename(files), "_"), `[`, 1)

# make new filenames for filtered files
filts = file.path("./Data/Fastq_16S/", "filtered", paste0(sample.names,"_filt.fastq"))

# filter and trim
out = filterAndTrim(files,filts, truncLen = 200, maxEE = 2, truncQ = 2)

# learn error rates
errF <- learnErrors(filts)
plotErrors(errF, nominalQ = TRUE)


# dereplicate
derepFs <- derepFastq(filts, verbose=TRUE)
names(derepFs) <- sample.names

# make sequence table
seqtab = makeSequenceTable(derepFs)

# sample inferrence
dadaFs <- dada(derepFs, err=errF)

# inspect sequence lengths (should be 200)
table(nchar(getSequences(seqtab)))



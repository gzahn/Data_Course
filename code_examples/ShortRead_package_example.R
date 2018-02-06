# ShortRead example

library(ShortRead)
library(tidyr)

setwd("/home/gzahn/Desktop/Postdoc/MLO/Seq_Data/Seqs/MLO_Fastqs/PHY_RAW_SEQS")

# save full file paths and names into object
fq.files = dir(getwd(), full.names = TRUE)

# get actual reads from first file
fq.1 = readFastq(fq.files[1])

# show reads ... must use sread to access reads
sread(fq.1)

# vmatchPattern() let's you find and vcountPattern() lets you count matches in a DNA string
pattern = "CTTGGTCATTTAGAGGAAGTAAAAGTCGTAACAAGGTCTCCGTAG"
vmatchPattern(pattern, sread(fq.1), max.mismatch = 1)
vcountPattern(pattern, sread(fq.1), max.mismatch = 1)

# show quality scores
quality(fq.1)

# show read IDs
id(fq.1)

# get frequencies of nucleotides in fastq reads
nucl.freq = alphabetFrequency(sread(fq.1), as.prob = TRUE, collapse = TRUE)
barplot(nucl.freq[c("A","C","G","T")], ylim = c(0,1))


# get quality scores as a matrix
qual = as(quality(fq.1), "matrix")

# plot mean quality scores by cycle
plot(colMeans(qual), type = "b")

# Trim pattern off of front end
fq.1.Ltrim = trimLRPatterns(Lpattern = pattern, subject = sread(fq.1), max.Lmismatch = 2)

# Look at quality scores
qual <- as(quality(fq.1), "matrix")
plot(colMeans(qual), type="b", ylim = c(0,40))



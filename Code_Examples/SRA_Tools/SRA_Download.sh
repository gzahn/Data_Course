#!/bin/sh

############################
#SRA online search terms:
#ITS1
#
#SRA online filters:
#Platform = Illumina
############################
# This script takes the standard downloads from the SRA read selector (the table and accession list) 
# and uses them to download all the associated fastq files from the Sequence Read Archive.




#This script assumes the following: 
# 1.  You have SRATools installed on your machine. Make sure to check the verison and location and adjust line 29
# 2.  You have downloaded a table and list of accession numbers from the SRA read selector website.  Table contains metadata for each accession.

# usage: bash SRA_Download.sh /PATH/TO/SRA_RUN_TABLE.TXT /PATH/TO/SRA_ACCESSION_LIST.TXT /OUTPUT/DIRECTORY/PATH/FOR/READS_AND_MAPPING_FILES


# Determine total disk size of downloads based on metadata table (field 16) (this may not be robust...fix to use column name "Mbytes")
cut -f 16 $1 > file_sizes
paste <(awk '{sum += $1} END {print sum}' file_sizes) <(echo "Mbytes Total... Downloads will start in 10 seconds.")

#pause to sink in, give time to cancel
sleep 10

echo "Downloading fastq files associated with SRA accession numbers..."

# use SRA toolkit fastq-dump to download fastq files for each associated SRA accession (Fwd and Rev runs in separate reads, gzip compression, no technical reads)
cat $2 | xargs fastq-dump --split-files --gzip --skip-technical --readids --dumpbase --outdir $3


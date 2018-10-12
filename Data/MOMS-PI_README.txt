##############################
     # MOMS-PI Readme #
##############################
Vaginal samples from a first-trimester enrollment visit of 59 women enrolled in the MOMS-PI study were selected for the first proof-of-principle data snapshot for multi-omic data integration and analysis. Three omics are included in the dataset: cytokine profiles, 16S rRNA analyzed by STIRRUPS (Fettweis et.al.; PMID:23282177), and lipidomics profiles (i.e., eicosanoids and sphingolipids). The mapping file provides a link between subjectIDs and the sampleIDs to permit integration of omics datasets. We have also made available the protocols for this Proof-of-Principle dataset.


***this dataset was used for the 2016 POP1 manuscript***

76 subjects were originally selected for the POP1 cohort
65 cytokine profiles were prepared
the first 16S sequencing yielded data for 59 subjects
the final 16S sequencing yielded data for 69 subjects

***CHANGELOG***
Cytokines
---------
Cytokines profiles were genereated for 65 subjects. The original data release contains only 59 subjects to better correspond with the data available from 16S sequencing.
After resequencing all 65 subjects were re-normalized:
* samples where the protein concentration was too low to detect will be removed (3 samples from plate A)
* OOR</> values were replaced with upper or lower limit of detection for each cytokine. Imputed values are indicated in parentheses below.

Plate A
* Remove lab ID: 131, 227, 277 rows because protein concentration too low.
* Remove IL-2, IL-5 and IL-15 columns
* Eotaxin - set OOR< to 1.77 (4 samples)
* TNF-a - set OOR< to 3.88 (5 samples)

Plate B
* Remove IL-2, IL-5 and IL-15 columns
* IL-7 - set OOR< to 0.98 (1 sample)
* IL-8 - set OOR> to 9641.94 (2 samples)
* Eotaxin - set OOR< to 1.73 (14 samples)
* IFN-g - set OOR< to 7.26 (9 samples)
* IP-10 - set OOR< to 5.33 (2 samples)
* RANTES - set OOR< to 3.69 (3 samples)

16S
---
Re-sequenced POP1 cohort on Illumina platform using Phusion PCR protocol
higher success rate yielded data for 69 samples vs 59 samples the in original dataset

Lipids
------
The original dataset included only Eicosanoids for 59 subjects. 
Pulled available data for 70 subjects, including Sphingolipid data.


# Example Project Organization

## This demonstrates *one* proper method for organizing a project.

[Here's a link to an excellent overview of best-practices](https://www.britishecologicalsociety.org/wp-content/uploads/2017/12/guide-to-reproducible-code.pdf) 

### This example looks at some data from BioLog plates...

### Two water sources and two soil sources were diluted to varying degrees and tested 
### for their microbial ability to metabolize various carbon sources. The BioLog plate reader measures absorbance through different wells containing those carbon sources.
### Replicates of these plates were measured at 24, 48, and 144 hours.

## R scripts, run in order, generate cleaned data and figures
+ 01_clean_data.R
+ 02_explore_data.R
+ 03_make_figures.R


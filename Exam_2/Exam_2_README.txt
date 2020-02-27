SKILLS TEST 2
_____________


Do a fresh "git pull" to get the skills test files.
The files you just got from your "git pull" are:
  
  README.txt            # this file containing the test prompts
  
  landdata-states.csv   # Land and home price values over time, broken down into state and region
  
  unicef-u5mr.csv       # UNICEF data regarding child mortality rates for children under 5 years old
                        # This is a time series (by year)
                        # It covers 196 countries and 68 years
                        # The first column lists the country name, subsequent columns are each year
  
  fig1.png              # Need to recreate this figure (see instructions)
  fig2.png              # Need to recreate this figure (see instructions)
  fig3.png              # Need to recreate this figure (see instructions)
  fig4.png              # Need to recreate this figure (see instructions)


################################################################################
#   Create a new directory in YOUR data course repository called Exam_2        #       
#   Create a new Rproject in this new directory and copy all exam files to it  #
#   Complete the tasks below in a script called LASTNAME_Skills_Test_2.R       #
#   Be sure that your file paths are relative to your new Rproject             #
################################################################################


Tasks:

I.      Load the landdata-states.csv file into R
        Re-create the graph shown in "fig1.png"
        Export it to your Exam_2 folder as LASTNAME_Fig_1.jpg (note, that's a jpg, not a png)
        To change the y-axis values to plain numeric, add options(scipen = 999) to your script
        
II.     What is "NA Region???"
        Write some code to show which state(s) are found in the "NA" region          

III.    The rest of the test uses another data set. The unicef-u5mr.csv data. Get it loaded and take a look.
        It's not exactly tidy. You had better tidy it!
        
IV.     Re-create the graph shown in fig2.png
        Export it to your Exam_2 folder as LASTNAME_Fig_2.jpg (note, that's a jpg, not a png)

IV.     Re-create the graph shown in fig3.png
        Note: This is a line graph of average mortality rate over time for each continent 
        (i.e., all countries in each continent, yearly average), this is NOT a geom_smooth() 
        Export it to your Exam_2 folder as LASTNAME_Fig_3.jpg (note, that's a jpg, not a png)
        
V.      Re-create the graph shown in fig4.png
        Note: The y-axis shows proportions, not raw numbers
        This is a scatterplot, faceted by region
        Export it to your Exam_2 folder as LASTNAME_Fig_3.jpg (note, that's a jpg, not a png)

VI.		Commit and push all your code and files to GitHub. I'll pull your repository at 9:30pm sharp and grade what I find.


## Grading ##

Re-create fig1				20pts
What states are in region "NA"? 	10pts
Tidy the UNICEF data for plotting	10pts
Re-create fig2				20pts
Re-create fig3				20pts
Re-create fig4				20pts



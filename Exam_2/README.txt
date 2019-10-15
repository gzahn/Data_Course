SKILLS TEST 2
_____________


Do a fresh "git pull" to get the skills test files.
The files you will need are:

README.txt               This file
salaries.csv            Faculty Salaries from 1995 (not exactly clean and ready to go)
atmosphere.csv          Time series of fungal diversity from air samples with a few other variables
hyp_data.csv            Hypothetical data of atmosphere.csv that you will use models to predict Diversity from


########################
##### YOUR TASKS #######
########################

# Before anything else, make yourself a new directory in your personal Git Repository called "Exam_2"
# Start a new RProject in there called Exam_2.Rproj
# Copy the four files in MY Exam_2 directory into your own Exam_2 directory
# Create a new R script (this will have all your code for your exam) in YOUR Exam_2 directory
# Name it LASTNAME_Skills_Test_2.R
# This way, I can do a "git pull" in your repository and run your R script using your relative filepaths

There are 2 main tasks (I, and II) below:


I. 	Simple tidying exercise
    
    1.  Read in salaries.csv (needs some tidying)
    This is faculty salary information from 1995 - Split up by university, state, faculty rank, and university tier
    Faculty "Rank" progresses from "AssistProf" to "AssocProf" to "FullProf"

    2.  Convert to a usable tidy format so we can look at "Salary" as a dependent variable (10 points)

    3.  Using ggplot, create boxplot of salary (y-axis) by University Tier (x-axis), filled by Faculty Rank (10 points)
        x-axis = Tier
        y-axis = Salary
        Boxplot fill color = Rank
        Title = "Faculty Salaries - 1995"

    4.  Export this delightful boxplot to a file named "LASTNAME_exam2_plot1.jpeg" (10 points)


II. Linear modeling and predictions

    1.  Read in atmosphere.csv (pretty clean data set)
    These are observations of fungal diversity (number of different species) found in air samples along a time series
        SampleID - The unique sample ID for the observation (dd-mm-YYYY)
        Year - What do you think?
        Quarter - Q1 = Jan/Feb/Mar, Q2 = Apr/May/Jun, etc
        Month - This stands for "Magpie ovulation number..." no, it's just Month
        Mday - Day of the month
        BarcodeSequence - Not important
        Aerosol_Density - Number of detectable particles in the air sample per cubic cm
        CO2_Concentration - CO2 ppm on the day the sample was taken
        Diversity - Number of different fungal species found in the air sample
        Precip - Precipitation on the sampling day (mm)
   
    2.  Create three different linear models with Diversity as the dependent variable. The three models should have different
	predictors, or at least different numbers of predictors, with or without interaction terms. (10 points)
    
    3.  Compare the residuals of the three models and somehow document which has best explanatory power for the data (10 points)
    
    4.  Use all your models to predict Diversity values in the data set (10 points)

    5.  Make a plot showing actual Diversity values, along with the three models' predicted Diversity values.
    Use color or some other aesthetic to differentiate the actual values and all three predictions (20 points)
	Hint: gather_predictions()   ...wait, what is this magical function!? Maybe this hint should be for #4 ???
    
    6.  Write code to show the predicted values of Diversity for each model using the hypothetical new data 
    found in hyp_data.csv (10 points)
    
    7.  Export a text file that contains the summary output from *both* your models to "model_summaries.txt" (10 points)
        (Hint: use the sink() function)
        
    *Bonus*
    8.  Add these hypothetical predicted values (from hypothetical data - Part II, Step 6) to a plot of actual data 
    and differentiate them by color. (10 bonus points possible for a pretty graph)
    
    *Bonus*
    9.  Split the atmosphere.csv data into training and testing sets, randomly. Train your single best model on 50% of the data and 
    test it on the remaining 50% of the data. Find some way to show how well it fits the data.
	This is the only cross-validation part of the exam. (10 bonus points for proper code)
    
    
Push the following to your github web page in your new Exam_2 directory:
	1.  Your complete R script for ALL the above tasks, saved as LASTNAME_Skills_Test_2.R
	2.  Your plot from Part I
	3.  Any plots generated from Part II
	4.  model_summaries.txt



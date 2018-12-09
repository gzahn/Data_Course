# Code for assigning grades (this code will be used to assign your letter grade based on your scores)

setwd("~/Desktop/GIT_REPOSITORIES/Data_Course/") # set working director to course git repository

# load grades spreadsheet
grades = read.csv("./data/Fake_grade_data.csv", header = TRUE, stringsAsFactors = FALSE, row.names = 1)

data_course_letter_grades = function(x, a.cutoff = 700, b.cutoff = c(640,699), c.cutoff = c(560,639), d.cutoff = c(480,559)){   # give data frame object that has "Final.Points" column.
  Grade = c()
  
  for(i in 1:length(row.names(x))){
    
    if(x$Final.Points[i] >= a.cutoff){
      Grade[i] <- "A"
    }  
    if(x$Final.Points[i] %in% c(b.cutoff[1]:b.cutoff[2])){
      Grade[i] <- "B"
    }   
    if(x$Final.Points[i] %in% c(c.cutoff[1]:c.cutoff[2])){
      Grade[i] <- "C"
    } 
    if(x$Final.Points[i] %in% c(d.cutoff[1]:d.cutoff[2])){
      Grade[i] <- "D"    
    }
    if(x$Final.Points[i] < d.cutoff[1]){
      Grade[i] <- "E"    
    }   
  }  
  assign("letter.grades", Grade, envir = .GlobalEnv)
}

# Get total points earned
points = rowSums(grades[,c(2:length(names(grades)))]) # This works as long as the first column is student names and the rest are graded points earned
grades$Final.Points = points

# Use function defined above to define letter grades
data_course_letter_grades(grades)

#Assign letter grades to grading data frame
grades$Letter_Grade = letter.grades

# take a look at the assigned grades
grades
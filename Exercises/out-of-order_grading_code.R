############################################
##   Help! Everything is out of order!!   ##
############################################

# It's the end of the semester and I need to assign letter grades to all of you
# I've got your assignment, exam, and project scores in a .csv file
# I need to total up the points for each student
# I wrote code for this but my dog came along and mixed it all up...again.

# Please reorder the lines of code so it will run.

#################################################################################



# calculate class point totals
totals <- rowSums(df)


# Create new column of assigned letter grades
df$LetterGrade <- letter.grades


# Remove Student ID column
df$Student <- NULL


# Assign student IDs to row.names
row.names(df) <- df$Student


# load grade data
df = read.csv("Data/Fake_grade_data.csv")


# Look at letter grades
cbind(row.names(df),df$LetterGrade)


# new column of class point totals
df$Final.Points <- totals


# Run letter grade function on data frame
data_course_letter_grades(df)


# Define a grading function. Need to give it a data.frame object with "Final.Points" column
data_course_letter_grades = function(x, a.cutoff = 700, 
                                     b.cutoff = c(640,699), 
                                     c.cutoff = c(560,639), 
                                     d.cutoff = c(480,559)){   
  Grade = c()
  
  for(i in 1:length(row.names(x))){
    
    if(x$Final.Points[i] >= a.cutoff){Grade[i] <- "A"}  
    if(x$Final.Points[i] %in% c(b.cutoff[1]:b.cutoff[2])){Grade[i] <- "B"}   
    if(x$Final.Points[i] %in% c(c.cutoff[1]:c.cutoff[2])){Grade[i] <- "C"} 
    if(x$Final.Points[i] %in% c(d.cutoff[1]:d.cutoff[2])){Grade[i] <- "D"}
    if(x$Final.Points[i] < d.cutoff[1]){Grade[i] <- "E"}   
  }  
  assign("letter.grades", Grade, envir = .GlobalEnv)
}

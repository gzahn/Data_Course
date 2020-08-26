# this function's parts are below; put them into a logical and correct order to do the following:
# This function is supposed to: 
# 1. take a data.frame as input
# 2. check to make sure it meets certain critera
# 3. return summary information of each column, but with column class type appended to the summary headers



# here's the out of order code for the function:

my_function <- function(x){

  
  
  
  else if(dim(x)[2] < 2){stop("x must have 2 or more columns")}
  else{
    names(x_summaries) <- paste0(names(x_summaries),"_",x_classes)    
    return(x_summaries)x_names <- names(x)
    x_classes <- (lapply(x,class))
    x_summaries <- (lapply(x, summary))
  }
  if(!class(x) %in% c("tlb_df","data.frame","tbl")){stop("x must be a data frame or 'tibble'")}
  
  
}

















# test
data("iris")
my_function(iris)



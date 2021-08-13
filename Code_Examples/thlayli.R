thlayli <- function(x){
  if(!class(x) %in% c("tbl_df","tbl","data.frame")){
    stop("x must be a data frame or 'tibble'")
  }
  
  else if(dim(x)[2] < 2){
    stop("x has fewer than 2 columns")
  }
  
  else{
  names(x) <- sample(names(x),replace = FALSE,length(names(x)))
  names(x)[sample(1:length(names(x)),1)] <- "ThlayliWuzHere"
  x[] <- lapply(x, function(x) if(is.factor(x)) as.character(x) else x)
  x[] <- lapply(x, function(x) if(is.numeric(x)) as.character(x) else x)
  x[is.na(x)] <- "Thlayli"
  return(x)
  }
  
}


# tests 
x=data.frame(x=1:30,y=c(rep("A",20),rep("B",5),rep(NA,5)))
x$y <- as.factor(x$y)

glimpse(x)
glimpse(thlayli(x))


thlayli(x %>% select(1))
thlayli(t(x))


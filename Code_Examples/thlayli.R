thlayli <- function(x){
  names(x) <- sample(names(x),replace = FALSE,length(names(x)))
  names(x)[sample(1:length(names(x)),1)] <- "ThlayliWuzHere"
  x[] <- lapply(x, function(x) if(is.factor(x)) as.character(x) else x)
  x[] <- lapply(x, function(x) if(is.numeric(x)) as.factor(x) else x)
  x[is.na(x)] <- "Thlayli"
  return(x)
}


# test 
# x=data.frame(x=1:30,y=c(rep("A",25),rep(NA,5)))
# apply(thlayli(x),2,class)

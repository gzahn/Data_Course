# Functions for use in data exploration and figure generation


# requires input of a single character string, typically "Soil" or "Water"
getmax.byType = function(x){
  if(class(x) != "character"){
    stop("x must be a single character string.")
  }
  which(dat$Absorbance == max(dat[dat$SampleType == x,]$Absorbance))
}

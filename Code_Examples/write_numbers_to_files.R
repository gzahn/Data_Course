setwd("~/Desktop/GIT_REPOSITORIES/Data_Course/data/data-shell/many_files/")
list.files()

f = c(1:150000)

paths = file.path(getwd(),"/",list.files(),"/data/",list.files(),".txt", fsep = "")
t=1; r=300

for(i in paths){
  cat(paste(as.character(f[t:r])), sep = "\n", file = i)
  t=t+1
  r=r+1
}

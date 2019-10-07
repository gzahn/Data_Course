library(wakefield)
dir.create("./Data/Messy_Take2")

for(i in c("a","b","c","d","e","f","g")){
IQ_Male = round(rnorm(500,100,30))
DOB_Male = birth(500,start = as.POSIXct("1990-01-01"),by = 20000)
DaysAlive_Male = difftime(as.POSIXct(Sys.Date()),DOB_Male)
Pass_Male = answer(500)

IQ_Female = round(rnorm(500,100,30))
DOB_Female = birth(500,start = as.POSIXct("1990-01-01"),by = 20000)
DaysAlive_Female = difftime(as.POSIXct(Sys.Date()),DOB_Female)
Pass_Female = answer(500)



df = data.frame(DOB_Male,DaysAlive_Male,IQ_Male,Pass_Female,
           DOB_Female,DaysAlive_Female,IQ_Female,Pass_Female)

assign(x = paste0(i,"_df"),value = df,envir = .GlobalEnv)
}

dfs <- c("a_df","b_df","c_df","d_df","e_df","f_df","g_df")

for(i in dfs){
  write.csv(get(i),file = paste0("./Data/Messy_Take2/",i,".csv"),row.names = FALSE,quote = FALSE)  
}

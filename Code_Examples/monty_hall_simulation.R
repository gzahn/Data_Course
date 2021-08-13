doors <- c("A","B","C")
x=c()
y=c()
xdata = c()
z=1
for(j in 1:100){
for(i in 1:50){
  prize <- sample(doors)[1]
  pick <- sample(doors)[1]
  open <- sample(doors[which(doors != pick & doors != prize)])[1]
  switchyes <- doors[which(doors != pick & doors != open)]
  if(pick==prize){xdata=c(xdata,"noswitchwin")}
  if(switchyes==prize){xdata=c(xdata,"switchwin")}
}

x[z] <- length(which(xdata == "switchwin"))
y[z] <- length(which(xdata == "noswitchwin"))
z=z+1
rm(list = c("prize","pick","open","switchyes"))
}

df = data.frame(SwitchWin = x,NoSwitchWin=y)

advantage = (df$SwitchWin-df$NoSwitchWin) / rowSums(df)
df = as.data.frame(cbind(1:100,advantage))
ggplot(df) + geom_histogram(aes(x=V1,y=advantage), stat="identity")

regular=c()
montyhall=c()
x=1
for(i in 1:100){
regular[x] <- rbinom(1,50,.3)
montyhall[x] <- rbinom(1,50,.6)
x=x+1
}

plot(montyhall-regular)

pbinom(advantage,100,advantage)
dbinom(1:50,50,.6) - dbinom(1:50,50,.3)

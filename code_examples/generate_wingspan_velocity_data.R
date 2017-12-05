# Code used to generate fake wingspan, mass, and velocity data set for Week 1

observation = c(1:1000) # ordered numbers 1 to 1000

# define a random sampling function
samp = function(x){
  x+(1+(3*rnorm(1)))
}

# set variable vector
wings = c()

# run random sampling function 1000 times
for(i in 1:1000){
wings[i] = samp(5)  
}

# same as previous
velo = c()
for(i in 1:1000){
  velo[i] = samp(15)  
}

wingspan = wings
mass = (wingspan * (3+rnorm(1)))
velocity = velo

#ensure they are positive
wingspan = wingspan+22
mass=mass+41
velocity=velocity+5
df = as.data.frame(cbind(observation,wingspan,mass, velocity))

# look at fake data summary
summary(df)

#write file
write.csv(df, "~/Desktop/GIT_REPOSITORIES/Data_Course/data/wingspan_vs_mass.csv")



library(tidyverse)

# Data
a <- data.frame( x=rnorm(20000, 10, 1.9), y=rnorm(20000, 10, 1.2) )
b <- data.frame( x=rnorm(20000, 14.5, 1.9), y=rnorm(20000, 14.5, 1.9) )
c <- data.frame( x=rnorm(20000, 9.5, 1.9), y=rnorm(20000, 15.5, 1.9) )
data <- rbind(a,b,c)


# Basic scatterplot
ggplot(data, aes(x=x, y=y) ) +
  geom_point()

# Density plot, instead
ggplot(data, aes(x=x, y=y) ) +
  geom_bin2d() +
  theme_bw()

# Number of bins in each direction?
ggplot(data, aes(x=x, y=y) ) +
  geom_bin2d(bins = 70) +
  theme_bw()


###############################

# Correlation plot
# Data example
data=mtcars[ , c(1,3:6)]

#Make the plot
plot(data , pch=20 , cex=1.5 , col=rgb(0.5, 0.8, 0.9, 0.7))


# fancier version with "car" package
library(car)
library(RColorBrewer)

data=mtcars

# Make the plot
my_colors <- brewer.pal(nlevels(as.factor(data$cyl)), "Set2")
scatterplotMatrix(~mpg+disp+drat|cyl, data=data , reg.line="" , 
                  smoother="", col=my_colors , smoother.args=list(col="grey"), 
                  cex=1.5 , pch=c(15,16,17) , main="Scatter plot with Three Cylinder Options")



###############################
# Density plot...for when a histogram is too blah.

ggplot(data, aes(x=mpg,fill=factor(am))) +
  geom_density(alpha=.5)



###############################
# Network plots ... show connectivity between groups

library(igraph)

# Create data
data=matrix(sample(0:1, 400, replace=TRUE, prob=c(0.8,0.2)), nrow=20)
network=graph_from_adjacency_matrix(data , mode='undirected', diag=F )

# When ploting, we can use different layouts:
par(mfrow=c(2,2), mar=c(1,1,1,1))
plot(network, layout=layout.sphere, main="sphere")
plot(network, layout=layout.circle, main="circle")
plot(network, layout=layout.random, main="random")
plot(network, layout=layout.fruchterman.reingold, main="fruchterman.reingold")

###############################
# Spider charts ... compare multiple quantitative variables

# Library
library(fmsb)

# Create data: note in High school for several students
set.seed(99)
data=as.data.frame(matrix( sample( 0:20 , 15 , replace=F) , ncol=5))
colnames(data)=c("math" , "english" , "biology" , "music" , "R-coding" )
rownames(data)=paste("Student" , letters[1:3] , sep="-")

# To use the fmsb package, have to add 2 lines to the dataframe: the max and min of each topic to show on the plot!
data=rbind(rep(20,5) , rep(0,5) , data)

#==================
# Plot 1: Default radar chart proposed by the library:
radarchart(data)


#==================
# Plot 2: Same plot with custom features
colors_border=c( rgb(0.2,0.5,0.5,0.9), rgb(0.8,0.2,0.5,0.9) , rgb(0.7,0.5,0.1,0.9) )
colors_in=c( rgb(0.2,0.5,0.5,0.4), rgb(0.8,0.2,0.5,0.4) , rgb(0.7,0.5,0.1,0.4) )
radarchart( data  , axistype=1 , 
            #custom polygon
            pcol=colors_border , pfcol=colors_in , plwd=4 , plty=1,
            #custom the grid
            cglcol="grey", cglty=1, axislabcol="grey", caxislabels=seq(0,20,5), cglwd=0.8,
            #custom labels
            vlcex=0.8 
)
legend(x=1, y=1.1, legend = rownames(data[-c(1,2),]), bty = "n", pch=20 , col=colors_in , text.col = "grey", cex=1.2, pt.cex=3)

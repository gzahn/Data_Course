
library(tidyr)
library(ggplot2)
library(dplyr)
library(patchwork)
library(gganimate)

df = read.csv("Desktop/GIT_REPOSITORIES/Data_Course/data/landdata-states.csv")

head(df)
glimpse(df)

sub1 = subset(df, State %in% c("HI","UT","AL","NY"))

ggplot(sub1, aes(x=Home.Value,y=Structure.Cost)) +
  geom_point()

ggplot(sub1, aes(x=Home.Value,y=Structure.Cost,col=State)) +
  geom_point() 

ggplot(sub1, aes(x=Home.Value,y=Structure.Cost,col=State)) +
  geom_point(alpha=.2)

ggplot(sub1, aes(x=Home.Value,y=Structure.Cost,col=State)) +
  geom_point(alpha=.2) +
  facet_wrap(facets = ~ Year)

p = ggplot(sub1, aes(x=Home.Value,y=Structure.Cost)) +
  geom_point(alpha=.25) +
  geom_point(aes(col=sub1$State,frame=sub1$Year)) 

gganimate(p, interval=0.2)


violin = ggplot(df, aes(x=factor(Qrtr),y = Land.Value,fill = factor(Qrtr))) +
  geom_boxplot(aes(frame=factor(df$Year)))

gganimate(violin, interval = 0.2)

# A ggplot is made up of two main components – a ggplot() object and at least one geom layer.
ggplot() + geom_.....


# The ggplot() object acts as a storage facility for the data. 
# It is here where we define the data frame that houses the x and y coordinate values 
# themselves and instructions on how to split the data. 

# Aesthetics
#
    # The aes() aesthetic mapping function lives inside a ggplot object and is where we specify 
    # the set of plot attributes that remain constant throughout the subsequent layers 
    # (unless overwritten – more on this later).
    
    # We can consider the relationship between the aes() and geoms components as follows:
      
    # The aes() function is the “how” – how data is stored, how data is split
    # geoms are the “what”—what the data looks like. These are geometrical objects stored in subsequent layers.

p2 = ggplot(df, aes(x=Year,y=Land.Value))

p2 + geom_point()
p2 + geom_point(col="SteelBlue")
p2 + geom_point(aes(col=factor(Qrtr)))
p2 + geom_point(aes(size=Home.Value))
p2 + geom_point(aes(size=Home.Value,col=factor(Qrtr)))




# Layers
# 
# We use the + operator to construct new layers. By appending layers we can connect the “how” (aesthetics) 
# to the “what” (geometric objects). Adding geometric, scale, facet and statistic layers to a ggplot() 
# object is how to control virtually every visual aspect of the plot from the data contained in the object.

    # Adding a geometric object layer
    #   
    # A geometric object is used to define the style of the plot. Common geometric objects include:
    #   
    # geom_point() which is used to draw a dot plot
    # geom_line() used to draw a line plot
    # geom_bar() used to draw a bar chart.
    # 
    # 
    # A single plot can have numerous geom layers, and it is also possible to overlay results 
    # from multiple data frames in one plot. Overwriting the aesthetic mapping that was 
    # defined in the ggplot() object can be done inside a geom object function (more on this later!).
    # 

ggplot(data = df, mapping = aes(x = Home.Value, y = Structure.Cost))

ggplot(data = df, mapping = aes(x = Home.Value, y = Structure.Cost)) +
  geom_line() +
  geom_point() +
  geom_area() +
  geom_boxplot(aes(col=factor(Year), group = factor(Year))) +
  geom_violin(fill="green")


ggplot(df, aes(x=factor(Qrtr),y = Land.Value,fill = factor(Qrtr))) +
geom_violin()




# Notice how we can keep piling on geom layers as long as they are compatible with our aesthetics

plot = ggplot(data = df, mapping = aes(x = Home.Value, y = Structure.Cost))

plot + geom_point()  

# We can define different aesthetics within each geom we call (overwrites automatically if you define aesthetics that
# were defined globally in the ggplot() function)
plot + geom_point(aes(col=region))

plot + geom_point(aes(col=region, shape = factor(Qrtr)))



akmoky = subset(df, State %in% c("AK","MO","KY"))

ggplot(akmoky) +
  geom_point(aes(x=Year, y=Land.Value, col = State)) +
  geom_smooth(aes(x=Year, y=Land.Value, col = State))

ggplot(akmoky) +
  geom_point(aes(x=Year, y=Land.Value, col = State)) +
  geom_boxplot(aes(x=Year, y=Land.Value, fill = State),alpha=.1)


plot2 = ggplot(akmoky) +
  geom_point(aes(x=Year, y=Land.Value, col = State)) +
  geom_boxplot(aes(x=Year, y=Land.Value, fill = State),alpha=.1)


plot2 +
  labs(y = "Land Value, okay, like new Y-axis label or something",
       title = "Definitely the main plot title",
       subtitle = "This is, like, the subtitle. It's basically smaller text, okay?") +
  scale_fill_discrete(label = c("The cold place","The place with horse\nraces","The boring place")) +
  scale_color_discrete(name = "The new legend name")


xlim()
ylim()
coord_cartesian()
labs(x="...",y="...",title="...",subtitle="...",caption="...")


library(ggthemes)
plot2 + theme_fivethirtyeight()
plot2 + theme_few()
plot2 + theme_wsj()

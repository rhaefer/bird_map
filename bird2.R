library(ggplot2)
library(animation)
library(ggthemes)
library(maps)
library(mapdata)
library(ggmap)
library(data.table)
library(dplyr)
library(lubridate)


setwd("~/Documents/Data_Projects/birds")
bird<-read.csv("MyEBirdData.csv")
bird$Date<-as.Date(bird$Date, format="%m-%d-%Y")
bird$date.full<-format(bird$Date, "%B %d, %Y")
""


######
HoustonMap <- qmap("walla wall", zoom = 6 , maptype = "toner-lite", source = "stamen")
m<-HoustonMap + geom_point( data = bird,aes(x = Longitude, y = Latitude,size=Count,frame=date.full), colour="red") +
  scale_size_continuous(range = c(5,15), name="Number of Birds") +ggtitle("Recent Bird Observations:") +
  theme(plot.title=element_text(size=18, face="bold"), legend.background=element_rect(fill="white"), legend.position="right" )
library(gganimate)
gg_animate(m, "bird_animate1.html", convert = "gm convert" ,ani.width = 1000, ani.height = 500)



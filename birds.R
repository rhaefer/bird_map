setwd("~/Documents/Data Projects/birds")
unzip("ebird_1465662456449 (1).zip")
library(leaflet)
bird<- read.csv("MyEBirdData.csv")

bird$lat <- jitter(bird$Latitude, factor = .2)
bird$lon <- jitter(bird$Longitude, factor = .2)

base_map <- "https://api.mapbox.com/styles/v1/reidhaefer/cipbfjuiu001jbbnpuxfyc8eg/tiles/{z}/{x}/{y}?access_token=pk.eyJ1IjoicmVpZGhhZWZlciIsImEiOiJjaW9haGVvZGwwM3B0dzFrcTA5YmZuNXcwIn0.HKs4d8rgdIe8tdqcUqJMvw"
mb_attribution <- "© <a href='https://www.mapbox.com/map-feedback/'>Mapbox</a> © <a href='http://www.openstreetmap.org/copyright'>OpenStreetMap</a>"



leaflet () %>%
  addTiles(urlTemplate = base_map, attribution = mb_attribution)%>%
  addMarkers(bird$lon, bird$lat, 
             popup=paste(sep="","<b>", bird$Common.Name,"</b>",
                         "<br/>","Scientific Name: ", bird$Scientific.Name,
                         "<br/>","Number Observed: ", bird$Count,
                         "<br/>","Location: ", bird$Location,
                         "<br/>","Date: ", bird$Date), 
             clusterOptions = markerClusterOptions()) 
 
 


library(leaflet)
library(shiny)
library(rsconnect)


setwd("~/Documents/Data Projects/birds")
unzip("ebird_1465665909535.zip")
library(leaflet)
bird<- read.csv("MyEBirdData.csv")

bird$lat <- jitter(bird$Latitude, factor = .2)
bird$lon <- jitter(bird$Longitude, factor = .2)

base_map <- "https://api.mapbox.com/styles/v1/reidhaefer/cipbg5sqi000mb9m4nm5xs87e/tiles/{z}/{x}/{y}?access_token=pk.eyJ1IjoicmVpZGhhZWZlciIsImEiOiJjaW80bW92cGowMW8zdjRrcWlsMzg5dGVjIn0.TxdQscN__5Nlu_jSYxZplA"
mb_attribution <- "© <a href='https://www.mapbox.com/map-feedback/'>Mapbox</a> © <a href='http://www.openstreetmap.org/copyright'>OpenStreetMap</a>"


ui <-fluidPage (leafletOutput("mymap", width=900, height=900))
                                          


########################################################################################

server <- function(input, output, session) {
  
  
  output$mymap <- renderLeaflet({
    
  leaflet () %>%
      addTiles(urlTemplate = base_map, attribution = mb_attribution)%>%
      addMarkers(bird$lon, bird$lat, 
                 popup=paste(sep="","<b>", bird$Common.Name,"</b>",
                             "<br/>","<font size=2 color=#045FB4>","Scientific Name: ","</font>" ,bird$Scientific.Name,
                             "<br/>","<font size=2 color=#045FB4>","Number Observed: ","</font>", bird$Count,
                             "<br/>","<font size=2 color=#045FB4>","Location: ","</font>", bird$Location,
                             "<br/>","<font size=2 color=#045FB4>", "Date: ", "</font>", bird$Date), 
                 clusterOptions = markerClusterOptions()) 
    
  })
}
########################################################################################

shinyApp(ui, server)




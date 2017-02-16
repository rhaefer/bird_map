library(raster)
library(plyr)
library(leaflet)
library(dplyr)
library(shiny)
library(rsconnect)
library(rgdal)
library(datasets)
library(ggplot2)
library(ggthemes)
library(gtools)
library(scales)
library(DT)
library(htmltools)
library(leaflet)

bird<- read.csv("MyEBirdData 3.csv")

bird$Location<-as.character(bird$Location)
bird$Location[bird$Location=="US-WA-Renton-Cedar River Park - 47.4656x-122.1338"] <- "Cedar River Park"
bird$lat <- jitter(bird$Latitude, factor = .2)
bird$lon <- jitter(bird$Longitude, factor = .2)
bird$County<- paste(bird$County, "County")
bird$Area<- paste(sep="",bird$State.Province,"-", bird$County)
bird$Location[bird$Location=="US-WA-North Bend-Snoqualmie National Forest - 47.4352x-121.5129"] <- "Pratt Lake (Snoqualmie Pass)"
table<-bird %>% select(Common.Name, Count, Scientific.Name, Location, Area, Date)
bird$url <- paste0("https://www.allaboutbirds.org/guide/", gsub(" ","_",bird$Common.Name), "/id")
bird$html <- paste0("<a href=", "\"", bird$url, "\"", ">", "All About Birds", "</a>")

base_map <- "https://api.mapbox.com/styles/v1/reidhaefer/cipbjqldq0017cvnfmduk5unx/tiles/{z}/{x}/{y}?access_token=pk.eyJ1IjoicmVpZGhhZWZlciIsImEiOiJjaW80bW92cGowMW8zdjRrcWlsMzg5dGVjIn0.TxdQscN__5Nlu_jSYxZplA"
mb_attribution <- "© <a href='https://www.mapbox.com/map-feedback/'>Mapbox</a> © <a href='http://www.openstreetmap.org/copyright'>OpenStreetMap</a>"

summary<- bird %>%
summarise(Species_Observed=length(unique(bird$Common.Name)), Birds_Observed=length(bird$Common.Name),
        Observation_Sites=length(unique(bird$Location)), 
        Observation_Days=length(unique(bird$Date)))
colnames(summary) <- c("Species Observed", "Birds Observed", "Observation Sites","Observation Days")

#######################################################

ui <-fluidPage(titlePanel("Reid's Bird Observations1sadfasd"),tabsetPanel( type="pills",
                    tabPanel(strong("MAP"),leafletOutput("mymap", width=900, height=600)),
                    tabPanel(strong("SUMMARY"),
                             fluidRow(column(10,offset=2,DT:: dataTableOutput('mytable1'))),
                             fluidRow(column(10,plotOutput("graph", width="100%",height="600px")))),
                    tabPanel(strong("DATA"),DT:: dataTableOutput('mytable'))
                    
                    ))

########################################################################################
server <- function(input, output, session) {

output$mymap <- renderLeaflet({
  
  leaflet () %>%
    addTiles(urlTemplate = base_map, attribution = mb_attribution)%>%
    addMarkers(bird$lon, bird$lat, 
               popup=paste(sep="","<b>", bird$Common.Name,"</b>",
                           "<br/>","<font size=2 color=#B40404>","Scientific Name: ","</font>" ,bird$Scientific.Name,
                           "<br/>","<font size=2 color=#B40404>","Number Observed: ","</font>", bird$Count,
                           "<br/>","<font size=2 color=#B40404>","Location: ","</font>", bird$Location,
                           "<br/>","<font size=2 color=#B40404>","Region: ","</font>", bird$Area,
                           "<br/>","<font size=2 color=#B40404>", "Date: ", "</font>", bird$Date,
                           "<br/>", "<font size=2 color=#B40404>", "More Info About This Bird @ ", "</font>",bird$html),
               clusterOptions = markerClusterOptions()
               ) 

})
output$mytable <- DT::renderDataTable({
  DT::datatable(table,  options= list (
    paging=F,
    autoWidth=TRUE
  ))
  
})
output$mytable1 <- DT::renderDataTable({
  DT::datatable(summary,class = 'cell-border stripe',rownames = FALSE,options =  list(dom='t',
      autoWidth = TRUE, 
      columnDefs = list(list(width = '100px', targets = c(2,3)),list(className = 'dt-center', targets = c(2,3))),
      initComplete = JS(
      "function(settings, json) {",
      "$(this.api().table().header()).css({'background-color': '#000', 'color': '#fff'});",
      "}")
  ))
  
  
})

output$graph <- renderPlot({
  ggplot(bird, aes (reorder(Common.Name, -Count), Count)) + geom_bar(stat="identity") + theme_economist() +coord_flip() +
    theme(axis.title.y=element_blank(), axis.title.x=element_blank(),axis.text.y=element_text(hjust=1), 
        plot.title=element_text(hjust=.9,size=16, face="bold"), axis.text.x=element_text(face = "bold",size=14)) +
    ggtitle("Number of Observationsdfsgdfg")
})



}
########################################################################################

shinyApp(ui, server)



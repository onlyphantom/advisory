library(shiny)
library(plotly)
library(dplyr)
source("helpers/charts.R")

# Define server logic required to draw a histogram
shinyServer(function(input, output) {

  maxvi <- vids %>% 
    group_by(channel_title) %>% 
    tally() %>% 
    filter(n==max(n)) %>% 
    select(n) %>% 
    as.integer()
  
  output$maxvid <- renderInfoBox({
    infoBox(
      title = "Most Prolific", 
      value = maxvi, icon=icon("trophy"), 
      subtitle = "Unique videos on Trending by one producer.",
      color = "black"
    )
  })
    
    
  output$popvid1 <- renderPlotly({
    ggplotly(repline,originalData = F)
  })
  
  output$popvidtab <- renderDataTable(
    popular_cats
  )
  
  output$plot1 <- renderPlot({
    offsflip
  })
  
  output$offs1 <- renderPlot({
    if(input$offselect == "Columns"){
      offsflip
    }else offs
  })
  
})

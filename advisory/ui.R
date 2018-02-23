library(shiny)
library(shinydashboard)
library(plotly)

# Define UI for our dashboard

dashboardPage(
  skin = "red",
  dashboardHeader(
    title="Advisory",
    tags$li(a(href = 'https://www.linkedin.com/in/chansamuel/',
              icon("linkedin"),
              title = "About the Author"),
            class = "dropdown"),
    
              tags$li(a(href = 'https://algorit.ma',
                        img(src = 'logo.png',
                            title = "Company Home", height = "20px"),
                            style = "padding-top:14px; padding-bottom:10px;"),
                          class = "dropdown"),
    
    dropdownMenu(type="message", 
      messageItem(
        from="Advisory", 
        message="Your Advisory subscription is updated.",
        icon=icon("life-ring"),
        time=substr(Sys.time(),1,10)
      )
    )
  ),
  
  dashboardSidebar(
    sidebarMenu(
      id="sidebar",
      menuItem("Overview", tabName = "overview", icon=icon("youtube")),
      menuItem("Category Explorer", tabName = "category", icon=icon("ellipsis-v")),
      menuItem("Mute Explorer", tabName = "mute", icon=icon("eraser"),
               badgeLabel = "new", badgeColor = "red"),
      menuItem("Github Links", 
               icon=icon("github"), href="https://github.com/onlyphantom")
    )

  
  ),
  
  dashboardBody(
    tags$head(
      tags$link(rel = "stylesheet", type = "text/css", href = "custom.css")),
    
    tabItems(
      # Overview page
      tabItem("overview",
        fluidRow(
          infoBox("Popular Categories", value=8, 
                  subtitle="Accounted for 75% of all trending videos.",
                  icon=icon("youtube")),
          infoBox("Trending Days", value=4.6, 
                  subtitle="Average length of trending window.",
                  icon=icon("calendar"), color = "yellow"),
          infoBoxOutput("maxvid")
        ),
              
        fluidRow(
          box(
            title="Popular Video Categories", solidHeader=T,
            collapsible = T,
            width=12,
            plotlyOutput("popvid1", height = 300)
          ),
          box(
            title="Internal Memo",
            solidHeader = T,
            width=4,
            p("Entertainment is heavily represented among the top trending videos with 1,005 unique videos, close to twice the amount of its closest contender. In my opinion, it really is sad that we don't take a more proactive role in promoting Science and Technology, or content with a higher level of educational or artistic value. Time for a tweak of our trending algorithm?")
          ),
          box(
            title="Raw Data", width=8, dataTableOutput("popvidtab")
          )
        )
      ),
      
      tabItem("category",
        h2("Category Explorer")        
      ),
      
      tabItem("mute",
        h2("Mute Explorer"),
        
        fluidRow(
          box(
            title="Which Channels Mute?", solidHeader=T,
            collapsible = T,
            width=8,
            plotOutput("offs1", height = 500)
          ),
          box(
            title = "Controls",
            background = "black",
            width=4,
            selectInput("offselect", label = "Visual Type:",
                        choices = c("Columns", "Dot Plot"),
                        selected = "Dot Plot"
                        )
          ),
          box(
            title="Analysis",
            solidHeader = T,
            width=4,
            p("News and Politics category are heavily represented in the subset of trending videos that have the comments feature disabled (muted). NBC News and PBS NewsHour are the two leading video channels that have a higher-than-usual amount of their videos disabled for comment. However, an interesting observation is that the News and Politics videos that heavily mute their comment feature are among the least represented among videos that mute their ratings feature.")
          )
        )
        
        
      )
      
    )
    
  )


  
)
#Define the user interface

shinyUI( fluidPage(
  includeCSS("styles.css"),
  
  headerPanel("Explore the world with data from the WB"),
  
  # Sidebar layout with a input and output definitions
  sidebarLayout(
    
    # Inputs
    sidebarPanel(
      
      radioButtons(inputId = "idicatorsGroups",
                   label = "Select type of data you want to examine:",
                   choices = c("Economic", 
                               "Education", 
                               "Finance",
                               "Technology")
                   ,selected = "Economic"
                   
      ),
      
      uiOutput(
        "SelectWBData"
      ),
      
      # Select variable for y-axis
      
      uiOutput("SelectYear"),
      
      h4("Downloading data"),
      
      downloadButton("DownloadData","Download data"),
      
      br(),br(),
      
      h4("Thanks to", tags$img(src = "https://upload.wikimedia.org/wikipedia/commons/thumb/1/1b/R_logo.svg/991px-R_logo.svg.png", height = "25px"),
         "and", tags$img(src = "https://upload.wikimedia.org/wikipedia/commons/thumb/8/87/The_World_Bank_logo.svg/2000px-The_World_Bank_logo.svg.png", height = "25px"))),
    
    
    # Outputs
    mainPanel(
      tabsetPanel( type = "tabs",
                   id = "eurostatTabs",
                   tabPanel("Map Plot",span(textOutput(outputId = "MapTitle"),style = "font-size: 20px"),
                            htmlOutput("mapplot")
                   ),
                   tabPanel("Data", dataTableOutput(outputId = "mapdata"))
                   
      )
    )
  )
)
)
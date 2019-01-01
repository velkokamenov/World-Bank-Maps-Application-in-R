#Define the server logic

server <- function(input, output, session) {
  
  output$SelectWBData = renderUI({
    selectInput(inputId = "wbData",
                label = "Select world bank data to plot on a map:",
                choices = if (input$idicatorsGroups == "Economic"){
                  c("GDP % growth"
                    ,"GDP Per Capita, PPP(constant 2011 international $)"
                    ,"Unemployment Rate"
                    ,"Inflation"
                    ,"Lending Interest Rate"
                  )
                }
                
                else if (input$idicatorsGroups == "Education"){
                  c("Government expenditure on tertiary education - % of GDP"
                    ,"At least competed lower secondary education, % of population +25 years"
                    #,"Number of schools at Primary Level"
                    ,"Early school leavers from primary education"
                    )
                }
                
                else if (input$idicatorsGroups == "Finance"){
                  c("Foreign direct investment, net (BoP, current US$)"
                    ,"Central government debt, total (% of GDP)"
                    ,"Gross portfolio debt liabilities to GDP (%)"
                    ,"Gross portfolio equity liabilities to GDP (%)")
                }
                else if (input$idicatorsGroups == "Technology") {
                  c("Internet users %"
                    ,"Scientific and technical journal articles"
                    ,"High tech exports % of total exports"
                    ,"High tech imports % of total imports"
                    ,"Telephone subscribers per 1000 people"
                  )
                }
                
    )
    
    
    
  })
  
  # Define a dataset reactive handler
  datasetInput <- eventReactive(input$wbData,{
    
    switch(input$wbData,
           # Economy
           "GDP % growth" = gdpGrowth
           ,"GDP Per Capita, PPP(constant 2011 international $)" = gdpPerCapita
           ,"Unemployment Rate" = unempRate
           ,"Inflation" = inflation
           ,"Lending Interest Rate"= lendingInterestRate
           # Finance
           ,"Central government debt, total (% of GDP)" = governmentDebt
           ,"Foreign direct investment, net (BoP, current US$)" = fdi
           ,"Gross portfolio debt liabilities to GDP (%)" = grossPortfolioDebt
           ,"Gross portfolio equity liabilities to GDP (%)" = grossPortfolioEquity
           #"Financial literacy" = dataGDPperCapita,
           #"Financial inclusion" = dataFInIncl,
           # Technology
           ,"Internet users %" = percentInternetUsers
           ,"Scientific and technical journal articles" = technicalJournalArticles
           ,"High tech imports % of total imports" = highTechImports
           ,"High tech exports % of total exports" = highTechExports
           ,"Telephone subscribers per 1000 people" = telephoneSubscribers
           #Education
           ,"Government expenditure on tertiary education - % of GDP" = govExpTertiaryEducation
           ,"At least competed lower secondary education, % of population +25 years" = secondaryEducationPercent
           #,"Number of schools at Primary Level" = numberOfSchools
           ,"Early school leavers from primary education" = earlySchoolLeavers 
    )
    
  })
  
  # Output the year selection control
  output$SelectYear = renderUI({
    req(datasetInput())
    yearMin = min(as.integer(datasetInput()$date))
    yearMax = max(as.integer(datasetInput()$date))
    sliderInput(inputId = "YearSelection",
                label = "Select the year for which you want to plot the data:",
                min = yearMin,
                max = yearMax,
                value = yearMax - 1,
                step = 1,
                sep = "")
  })
  
  # Format a title for the map
  mapTitle = reactive({
    titleString = paste(input$wbData,"by country,",input$YearSelection)
    return(titleString)
  })
  
  # Format the data for plotting purposes and plot with googleViz
  dataToPlot = reactive({
    req(datasetInput())
    
    dataForPlot = datasetInput() %>%
      mutate(date = as.integer(date),
             value = round(value, digits = 2),
             country = case_when(.$country == "Russian Federation" ~ "Russia",
                                 .$country == "Egypt, Arab Rep." ~ "Egypt",
                                 .$country == "Venezuela, RB" ~ "Venezuela",
                                 .$country == "Cote d'Ivoire" ~ "Ivory Coast",
                                 .$country == "Congo, Rep." ~ "CG",
                                 .$country == "Congo, Dem. Rep." ~ "CD",
                                 .$country == "Yemen, Rep." ~ "Yemen",
                                 .$country == "Iran, Islamic Rep." ~ "Iran",
                                 .$country == "Kyrgyz Republic" ~ "Kyrgyzstan",
                                 .$country == "Korea, Rep." ~ "South Korea",
                                 .$country == "Lao PDR" ~ "Laos",
                                 .$country == "Macedonia, FYR" ~ "Macedonia",
                                 .$country == "Syrian Arab Republic" ~ "Syria",
                                 .$country == "Slovak Republic" ~ "Slovakia",
                                 TRUE ~ .$country)) %>%
      select(date, value, indicator, country) %>%
      plyr::rename(c("country"="Country","date"="Year")) %>%
      filter(Year == input$YearSelection) %>%
      filter(!Country %in% c("World",
                             "Low & middle income",
                             "Middle income",
                             "Upper middle income",
                             "East Asia & Pacific",
                             "East Asia & Pacific (excluding high income)"))
    
    googlePlot = gvisGeoChart(dataForPlot, locationvar="Country", colorvar="value",
                              options=list(width=680, height=330, colors = "blue"))
    
    return(googlePlot)
    
  })
  
  # Format the data in table form for visualization purposes
  dataToTable = reactive({
    req(datasetInput())
    dataForTable = datasetInput() %>%
      mutate(date = as.integer(date),
             value = round(value, digits = 2),
             country = case_when(.$country == "Russian Federation" ~ "Russia",
                                 .$country == "Egypt, Arab Rep." ~ "Egypt",
                                 .$country == "Venezuela, RB" ~ "Venezuela",
                                 .$country == "Cote d'Ivoire" ~ "Ivory Coast",
                                 .$country == "Congo, Rep." ~ "CG",
                                 .$country == "Congo, Dem. Rep." ~ "CD",
                                 .$country == "Yemen, Rep." ~ "Yemen",
                                 .$country == "Iran, Islamic Rep." ~ "Iran",
                                 .$country == "Kyrgyz Republic" ~ "Kyrgyzstan",
                                 .$country == "Korea, Rep." ~ "South Korea",
                                 .$country == "Lao PDR" ~ "Laos",
                                 .$country == "Macedonia, FYR" ~ "Macedonia",
                                 .$country == "Syrian Arab Republic" ~ "Syria",
                                 .$country == "Slovak Republic" ~ "Slovakia",
                                 TRUE ~ .$country)) %>%
      select(date, value, indicator, country) %>%
      plyr::rename(c("country"="Country","date"="Year"))
    
    return(dataForTable)
  })
  
  # Output the title of the map
  output$MapTitle = renderText({
    req(mapTitle())
    mapTitle()
  })
  
  # Output the world map with data to the canvas
  output$mapplot <- renderGvis({
    req(dataToPlot())
    dataToPlot()
    
  })
  
  # Output the data in table form on the canvas
  output$mapdata = renderDataTable({
    req(dataToTable())
    datatable(data = dataToTable(), 
              options = list(pageLength = 10), 
              rownames = FALSE)
  })
  
  
  # Create a download button for the data in table form in excel
  output$DownloadData = downloadHandler(
    filename = function() {paste(input$wbData,' by country ',min(as.integer(datasetInput()$date)),'-',
                                 max(as.integer(datasetInput()$date)), '.xlsx', sep='')},
    content = function(file) {
      write.xlsx(data.frame(dataToTable()),file,row.names=FALSE)
    }
    
  )
  
}
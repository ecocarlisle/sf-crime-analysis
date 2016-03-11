library(shiny)

# Define UI for application that draws a histogram
shinyUI(fluidPage(
  
  # Application title
  titlePanel("SF Crime Data - Number of Crimes Per Category"),
  
  # Sidebar with a slider input for the number of bins
  sidebarLayout(
    sidebarPanel(
      selectInput("myFill", 
                  label = h3("Choose a variable to display"), 
                  choices = c("PdDistrict", "DayOfWeek"),
                                 selected = "PdDistrict")
      
    ),
    
    # Show a plot of the generated distribution
    mainPanel(
      plotOutput("distPlot")
    )
  )
))
library(shiny)

# Define server logic required to draw a histogram
shinyServer(function(input, output) {
  
  # Expression that generates a histogram. The expression is
  # wrapped in a call to renderPlot to indicate that:
  #
  #  1) It is "reactive" and therefore should re-execute automatically
  #     when inputs change
  #  2) Its output type is a plot

  getTrainData <- function() {
    library(readr)
    x <- read_csv('train.csv', col_types='Tccccccdd')
    x <- x[ , which(names(x) %in% c('Dates','Category','DayOfWeek','X','Y','PdDistrict'))]
    x$DayOfWeek <- factor(x$DayOfWeek, levels=c('Sunday','Monday','Tuesday','Wednesday',
                                                'Thursday','Friday','Saturday'))
    x$Category <- factor(x$Category)
    library(lubridate)
    x$Year <- factor(year(x$Dates))
    x$Month <- factor(month(x$Dates))
    x$Hour <- factor(hour(x$Dates))
    x$Dates <- NULL
    return(x)
  }
  
  train <- getTrainData()
  
  output$distPlot <- renderPlot({
    
    library(ggplot2)

    print("Hello")
    myFill <- input$myFill
    print(myFill)
    #.e <- environment()
    
    ggplot(train, aes_string(x="Category", fill=input$myFill)) + geom_bar(colour="black") +
      theme(axis.text.x = element_text(angle = 45, hjust = 1))

    #paste("You have selected", input$var)
    
    
  })

  
})
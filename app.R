#
# This is a Shiny web application. You can run the application by clicking
# the 'Run App' button above.
#
# Find out more about building applications with Shiny here:
#
#    http://shiny.rstudio.com/
#

library(shiny)
library(tidyverse)

# Define UI for application that draws a histogram
ui <- fluidPage(
    
    # Application title
    titlePanel("Diamonds organized by Color"),
    
    # Sidebar with a slider input for the specific Diamond Color
    sidebarLayout(
        sidebarPanel(
            selectInput(inputId = "color", label = "color",
                        c(
                          unique(as.character(diamonds$color))
                        ),
                        tableOutput("diamonds")
            )
        ),
        
        
        # Showing two plots of the generated distribution
        mainPanel(
            plotOutput("distPlot"),
            plotOutput("distplot2")
        )
    )
)



# Define server logic required to draw a histogram
server <- function(input, output) {
    
    # Generating a plot for all colors displayed simultaneously  
    output$distPlot <- renderPlot({
    
        # Creating the plot and defining the desired aesthetics for all colors
        ggplot(diamonds, aes_string(x = "carat", y = "price", color = "color"))+
            geom_point()+
            ggtitle("Relationship between Carat and Price")+ theme(
                plot.title = element_text(color="red", size=20, face="bold.italic")
            )
    })
    
    # Organizing the data to allow each specific color to be displayed individually rather than as a bulk group.
    output$distplot2 <- renderPlot({
                diamonds <- diamonds[diamonds$color == input$color,]
            
            
            # Creating the plot and defining the desired aesthetics 
            ggplot(diamonds, aes_string(x = "carat", y = "price"))+
                geom_point()+
                ggtitle("Relationship between Carat and Price per Color", input$color)+ theme(
                    plot.title = element_text(color="red", size=20, face="bold.italic")
                ) 
    })
}

# Run the application 
shinyApp(ui = ui, server = server)
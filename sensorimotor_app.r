
library(shiny)

ui <- fluidPage(
    titlePanel("The Lancaster Sensorimotor Norms"),
    p("Explore 11 dimensions of perceptual and action strength ratings for 39,707 English words"),
    tabsetPanel(
        tabPanel("About", ""),
        tabPanel(
            "Calculate distances",
             sidebarPanel(
                 tabsetPanel(
                     tabPanel(
                         "One-to-one",
                         h3("Calculate the distance between concept pairs"),
                         selectInput(
                             "distance_select",
                             "Distance select",
                             choices = list(
                                 "Euclidean distance"   = "euclidean",
                                 "Minkowski-3 distance" = "minkowski3",
                                 "Cosine distance"      = "cosine",
                                 "Correlation distance" = "correlation"),
                             selected = 'minkowski3'))
                         
                     )
                 )
             )
    ),
)

server <- function(input, output) {
    
}

# Run the application 
shinyApp(ui = ui, server = server)

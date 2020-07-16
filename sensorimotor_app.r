
library(shiny)

distance_choices <-  list(
    "Euclidean distance"   = "euclidean",
    "Minkowski-3 distance" = "minkowski3",
    "Cosine distance"      = "cosine",
    "Correlation distance" = "correlation")
distance_default <- "minkowski3"

tab_about <- tabPanel(
    title = "About", "")

distance_select_with_id <- function(inputId) {
    return(selectInput(
        inputId = paste("distance_", inputId, sep=""),
        label = "Distance select",
        choices = distance_choices,
        selected = distance_default))
}

tab_one_to_one <- tabPanel(
    title = "One-to-one",
    h3("Calculate the distance between concept pairs"),
    distance_select_with_id("one_to_one"),
    helpText(
        "Enter pairs of concepts separated by colons, with each pair on a ",
        "separate line."),
    textAreaInput(
        inputId = "word_pairs",
        label = "Concept pairs",
        rows = 10),
    actionButton(
        inputId = "clear_button",
        label = "Clear"),
    textOutput("pair_count"),
    helpText(
        "Calculate distances between pairs of concepts' ",
        "vector representations. Select the distance ",
        "type from the drop-down, and enter pairs of ",
        "concepts in the text box. Click the 'show me' ",
        "button to start with random concepts.")
)

tab_distances <- tabPanel(
    title = "Calculate distances",
    sidebarPanel(
        tabsetPanel(
            tab_one_to_one,
            id = "distance_mode",
            type = "pills"
        )),
    mainPanel(
        tableOutput(outputId = "pairs_table"),
    ))

ui <- fluidPage(
    titlePanel("The Lancaster Sensorimotor Norms"),
    p("Explore 11 dimensions of perceptual and action strength ratings for 39,707 English words"),
    tabsetPanel(
        tab_about,
        tab_distances
    ),
)

server <- function(input, output) {
    
}

# Run the application 
shinyApp(ui = ui, server = server)

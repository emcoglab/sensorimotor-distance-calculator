library(magrittr)
library(readr)
library(shiny)
library(purrr)
library(stringr)
library(dplyr)
library(torch)

source("text.r")
source("norms.r")
source("ui_shared_elements.r")
source("ui_tab_about.r")
source("ui_tab_distances.r")
source("parse_input.r")
source("distance_tables.r")

ui <- fluidPage(
    titlePanel("Explore the Lancaster Sensorimotor Norms"),
    p("Explore 11 dimensions of perceptual and action strength ratings for 39,707 English words"),
    tabsetPanel(
        tab_about,
        tab_distances
    ),
)

server <- function(input, output, session) {
    
    # Wire distance_function
    distance_type <- reactive({ input$distance_one_to_one })
    
    word_pairs_list <- reactive({ get_word_pairs(input$word_pairs) })
    # unpack
    word_pairs         <- reactive({ word_pairs_list()$word_pairs })
    words_not_in_norms <- reactive({ word_pairs_list()$words_not_in_norms })
    malformed_lines    <- reactive({ word_pairs_list()$malformed_lines })
    
    pairs_box_is_empty <- reactive({ nchar(input$word_pairs) == 0 })
    
    # Wire clear button
    observeEvent(input$clear, {
        updateTextInput(session, "word_pairs", value = "")
    })
    
    # Wire show-me button
    observeEvent(input$show_me, {
        pairs = render_pairs(random_norm_pairs(10))
        updateTextInput(session, "word_pairs", value = pairs)
    })
    
    # Wire summary text
    output$summary_pairs <- renderText({summarise_pairs(word_pairs(), words_not_in_norms(), malformed_lines())})
    
    # Wire tables
    output$pairs_table <- renderTable({ distance_table_for_word_pairs(word_pairs(), distance_type()) })
    
}

# Run the application 
shinyApp(ui = ui, server = server)

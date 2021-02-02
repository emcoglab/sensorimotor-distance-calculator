library(magrittr)
library(readr)
library(shiny)
library(purrr)
library(stringr)
library(dplyr)
library(rdist)

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
    left_words         <- reactive({ word_pairs_list()$left_words })
    right_words        <- reactive({ word_pairs_list()$right_words })
    words_not_in_norms <- reactive({ word_pairs_list()$words_not_in_norms })
    malformed_lines    <- reactive({ word_pairs_list()$malformed_lines })
    
    updateTextInput(session, "word_pairs", value=render_pairs(random_norm_pairs(10)))
    
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
    output$summary_pairs <- renderText({
        summarise_pairs(left_words(), right_words(), words_not_in_norms(), malformed_lines())
    })
    
    # Wire tables
    pairs_table_data   <- reactive({ distance_table_for_word_pairs(left_words(), right_words(), distance_type()) })
    output$distances_table <- renderTable({ pairs_table_data() }, digits=6)
    # Download link
    output$distances_table_download <- downloadHandler(
        filename=function(){ "distance pairs list.csv" },
        content=function(file) {
            write.csv(pairs_table_data(), file)
        }
    )
    
}

# Run the application 
shinyApp(ui = ui, server = server)

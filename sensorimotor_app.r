library(magrittr)
library(readr)
library(shiny)
library(purrr)
library(tidyr)
library(stringr)
library(dplyr)
library(rdist)

source("text.r")
source("norms.r")
source("ui_shared_elements.r")
source("ui_page_about.r")
source("ui_page_distances.r")
source("parse_input.r")
source("summarise.r")
source("distance_tables.r")

ui <- navbarPage(
    "Explore the Lancaster Sensorimotor Norms",
    page_about,
    page_distances
)

precision <- 6

server <- function(input, output, session) {
    
    ## DISTANCES: One-to-one ##
    
    one_one_distance_type <- reactive({ input$one_one_distance })
    
    one_one_word_pairs_list <- reactive({ get_word_pairs(input$one_one_word_pairs) })
    one_one_left_words         <- reactive({ one_one_word_pairs_list()$left_words })
    one_one_right_words        <- reactive({ one_one_word_pairs_list()$right_words })
    one_one_words_not_in_norms <- reactive({ one_one_word_pairs_list()$words_not_in_norms })
    one_one_malformed_lines    <- reactive({ one_one_word_pairs_list()$malformed_lines })
    
    # Prefill pairs
    updateTextInput(session, "one_one_word_pairs", value=render_pairs(random_norm_pairs(10)))
    # Wire I/O
    observeEvent(input$one_one_button_clear, { updateTextInput(session, "one_one_word_pairs", value = "") })
    observeEvent(input$one_one_button_random_pairs, { updateTextInput(session, "one_one_word_pairs", value = render_pairs(random_norm_pairs(10))) })
    output$one_one_summary_pairs <- renderText({ summarise_pairs(one_one_left_words(), one_one_right_words(), one_one_words_not_in_norms(), one_one_malformed_lines()) })
    
    # Wire tables
    one_one_table_data <- reactive({ distance_table_for_word_pairs(one_one_left_words(), one_one_right_words(), one_one_distance_type()) })
    output$one_one_distances_table <- renderTable({ one_one_table_data() }, digits=precision)
    # Download link
    output$one_one_table_download <- downloadHandler(filename=function(){ "distance pairs list.csv" },
                                                     content=function(file) { write.csv(one_one_table_data(), file, row.names=FALSE) })
    
    ## DISTANCES: One-to-many ##
    
    one_many_distance_type <- reactive({ input$one_many_distance })
    
    one_many_left_word    <- reactive({ canonise_word(input$one_many_word_one) })
    
    one_many_words_many    <- reactive({ get_words(input$one_many_words_many) })
    one_many_right_words   <- reactive({ one_many_words_many()$words })
    one_many_right_missing <- reactive({ one_many_words_many()$missing })
    
    # Prefill words
    updateTextInput(session, "one_many_word_one",   value=random_norm())
    updateTextInput(session, "one_many_words_many", value=render_list(random_norms(10)))
    # Wire I/O
    observeEvent(input$one_many_button_clear_one,  { updateTextInput(session, "one_many_word_one", value = "") })
    observeEvent(input$one_many_button_clear_many, { updateTextInput(session, "one_many_words_many", value = "") })
    observeEvent(input$one_many_button_random_one,  { updateTextInput(session, "one_many_word_one", value = random_norm()) })
    observeEvent(input$one_many_button_random_many, { updateTextInput(session, "one_many_words_many", value = render_list(random_norms(10))) })
    output$one_many_summary_one  <- renderText({ summarise_word(one_many_left_word(), !(one_many_left_word() %in% norms$Word)) })
    output$one_many_summary_many <- renderText({ summarise_words(one_many_right_words(), one_many_right_missing()) })
    
    # Wire tables
    one_many_table_data <- reactive({ distance_table_for_one_many(one_many_left_word(), one_many_right_words(), one_many_distance_type()) })
    output$one_many_distances_table <- renderTable({ one_many_table_data() }, digits=precision)
    # Download link
    output$one_many_table_download <- downloadHandler(filename=function(){ "distance one-many list.csv" },
                                                      content=function(file) { write.csv(one_many_table_data(), file, row.names=FALSE) })
    
    ## DISTANCES: Many-to-many ##
    
    many_many_distance_type <- reactive({ input$many_many_distance })
    
    many_many_words_input_left <- reactive({ get_words(input$many_many_words_left) })
    many_many_left_words       <- reactive({ many_many_words_input_left()$words })
    many_many_left_missing     <- reactive({ many_many_words_input_left()$missing })
    
    many_many_words_input_right <- reactive({ get_words(input$many_many_words_right) })
    many_many_right_words       <- reactive({ many_many_words_input_right()$words })
    many_many_right_missing     <- reactive({ many_many_words_input_right()$missing })
    
    # Prefill words
    updateTextInput(session, "many_many_words_left",  value=render_list(random_norms(10)))
    updateTextInput(session, "many_many_words_right", value=render_list(random_norms(10)))
    # Wire I/O
    observeEvent(input$many_many_button_clear_left,  { updateTextInput(session, "many_many_words_left",  value = "") })
    observeEvent(input$many_many_button_clear_right, { updateTextInput(session, "many_many_words_right", value = "") })
    observeEvent(input$many_many_button_random_left,  { updateTextInput(session, "many_many_words_left",  value = render_list(random_norms(10))) })
    observeEvent(input$many_many_button_random_right, { updateTextInput(session, "many_many_words_right", value = render_list(random_norms(10))) })
    output$many_many_summary_left  <- renderText({ summarise_words(many_many_left_words(), many_many_left_missing()) })
    output$many_many_summary_right <- renderText({ summarise_words(many_many_right_words(), many_many_right_missing()) })
    
    # Wire tables
    many_many_matrix_data <- reactive({ distance_matrix_for_word_pairs(many_many_left_words(), many_many_right_words(), many_many_distance_type()) })
    many_many_list_data <- reactive({ distance_list_from_matrix(many_many_matrix_data(), many_many_distance_type()) })
    output$many_many_distances_table <- renderTable({ many_many_matrix_data() }, digits=precision, rownames=T)
    # Download links
    output$many_many_table_download <- downloadHandler(filename=function(){ "distance asymmetric list.csv" },
                                                       content=function(file) { write.csv(many_many_list_data(), file, row.names=FALSE) })
    output$many_many_matrix_download <- downloadHandler(filename=function(){ "distance matrix.csv" },
                                                        content=function(file) { write.csv(many_many_matrix_data(), file, row.names=TRUE) })
    
}

# Run the application 
shinyApp(ui = ui, server = server)

library(R.utils)
library(MASS)
library(dplyr)
library(magrittr)
library(markdown)
library(purrr)
library(readr)
library(rdist)
library(shiny)
library(shinythemes)
library(shinycssloaders)
library(stringr)
library(tidyr)
library(plotly)

source("meta.r")
source("calculate/norms.r")
source("calculate/neighbours.r")
source("calculate/distance_tables.r")
source("ui/text.r")
source("ui/summarise.r")
source("ui/plotting.r")
source("ui/shared_elements.r")
source("ui/pages/about.r")
source("ui/pages/distances.r")
source("ui/pages/neighbours.r")
source("ui/pages/visualise.r")
source("ui/pages/explore.r")
source("ui/parse_input.r")

ui <- navbarPage(
    "Sensorimotor distance calculator",
    page_about,
    page_distances,
    page_neighbours,
    page_visualise,
    page_explore,
    header=list(
        tags$head(
            includeCSS("www/styles.css")
        )
    ),
    footer=list(
        tags$div(
            includeMarkdown("ui/page_text/logos.md"),
            includeMarkdown("ui/page_text/footer.md"),
            HTML(paste0("Version ", meta_version, ".")),
            class="footer"
        )
    ),
    theme = shinytheme("united")
)

server <- function(input, output, session) {
    
    options(
        # Loading spinner appearance
        spinner.color = "#e95420", 
        spinner.type = 7  # 7: three dots
    )
    
    ## DISTANCES: One-to-one -----------------
    
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
    
    ## DISTANCES: One-to-many -----------------
    
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
    
    ## DISTANCES: Many-to-many  -----------------
    
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
    observeEvent(input$many_many_button_copy_right, { updateTextInput(session, "many_many_words_right", value = input$many_many_words_left) })
    output$many_many_summary_left  <- renderText({ summarise_words(many_many_left_words(), many_many_left_missing()) })
    output$many_many_summary_right <- renderText({ summarise_words(many_many_right_words(), many_many_right_missing()) })
    
    # Wire tables
    many_many_matrix_data <- reactive({ distance_matrix_for_word_pairs(many_many_left_words(), many_many_right_words(), many_many_distance_type()) })
    many_many_list_data <- reactive({ distance_list_from_matrix(many_many_matrix_data(), many_many_distance_type()) })
    output$many_many_distances_table <- renderTable({ many_many_matrix_data() }, digits=precision, rownames=TRUE)
    # Download links
    output$many_many_table_download <- downloadHandler(filename=function(){ "distance asymmetric list.csv" },
                                                       content=function(file) { write.csv(many_many_list_data(), file, row.names=FALSE) })
    output$many_many_matrix_download <- downloadHandler(filename=function(){ "distance matrix.csv" },
                                                        content=function(file) { write.csv(many_many_matrix_data(), file, row.names=TRUE) })
    
    ## NEIGHBOURS -----------------
    
    neighbours_distance_type <- reactive({ input$neighbours_distance })
    neighbours_source_word <- reactive({ canonise_word(input$neighbour_word) })
    neighbour_count <- reactive({ as.numeric(input$neighbours_count) })
    
    neighbour_distance_input    <- reactive({ try_parse_float(input$neighbour_radius, default_value=Inf, empty_to_default=TRUE) })
    
    # Prefill word
    updateTextInput(session, "neighbour_word",   value=random_norm())
    # Wire I/O
    observeEvent(input$neighbour_word_button_clear, { updateTextInput(session, "neighbour_word", value = "") })
    observeEvent(input$neighbour_word_button_random, { updateTextInput(session, "neighbour_word", value = random_norm()) })
    observeEvent(input$neighbour_button_any_distance, { updateTextInput(session, "neighbour_radius", value = "") })
    output$neighbour_word_summary <- renderText({ summarise_word(neighbours_source_word(), !(neighbours_source_word() %in% norms$Word)) })
    output$neighbour_radius_summary <- renderText({ summarise_positive_float(neighbour_distance_input()$value, neighbour_distance_input()$original, neighbour_distance_input()$success) })
    # Wure tabkes
    neighbours_table_data <- reactive({ neighbours_table(word=neighbours_source_word(), distance_type=neighbours_distance_type(), count=neighbour_count(), radius = neighbour_distance_input()$value) })
    output$neighbours_table <- renderTable({ neighbours_table_data() }, digits = precision)
    # Download link
    output$neighbour_table_download <- downloadHandler(filename=function() { paste0("neighbours of ", neighbour_word(), ".csv") },
                                                       content=function() { write.csv(neighbours_table_data(), file, row.names = FALSE) })
    
    
    ## VISUALISE -----------
    
    visualise_distance_type <- reactive({ input$visualise_distance })
    
    visualise_words_block <- reactive({ get_words(input$visualise_words) })
    visualise_words       <- reactive({ visualise_words_block()$words })
    visualise_missing     <- reactive({ visualise_words_block()$missing })
    
    visualise_show_lines <- reactive({ input$visualise_show_lines })
    
    # Prefill word
    updateTextInput(session, "visualise_words", value=render_list(random_norms(10)))
    # Wire I/O
    observeEvent(input$visualise_button_clear, { updateTextInput(session, "visualise_words", value = "") })
    observeEvent(input$visualise_button_random, { updateTextInput(session, "visualise_words", value = render_list(random_norms(10))) })
    output$visualise_words_summary <- renderText({ summarise_words_count_limit(visualise_words(), visualise_missing(), min=3, max=20, clip_max=TRUE) })
    
    # Wire scatterplot
    mds_positions <- reactive({ get_mds_positions_for_words(visualise_words(), visualise_distance_type()) })
    output$visualise_mds_plot <- renderPlotly({ mds_plot(mds_positions(), visualise_show_lines()) })
    
    ## EXPLORE --------
    
    explore_distance_type <- reactive({ input$explore_distance })
    explore_dominance <- reactive({ input$explore_dominance })
    
    # Wire scatterplot
    tsne_positions <- reactive({ get_tsne_positions(explore_distance_type(), dims=3) })
    output$explore_tsne_plot <- renderPlotly({ tsne_plot(tsne_positions(), explore_dominance(), dims=3) })
    
}

# Run the application 
shinyApp(ui = ui, server = server)

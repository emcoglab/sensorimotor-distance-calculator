library(magrittr)
library(readr)
library(shiny)
library(purrr)
library(stringr)
library(dplyr)

source("text.r")
source("norms.r")


distance_choices <-  list(
    "Euclidean distance"   = "euclidean",
    "Minkowski-3 distance" = "minkowski3",
    "Cosine distance"      = "cosine",
    "Correlation distance" = "correlation")
distance_default <- "minkowski3"

tab_about <- tabPanel(
    title = "About", "")

distance_select_with_id <- function(inputId) {
    return(
        selectInput(
            inputId = paste("distance_", inputId, sep=""),
            label = "Distance select",
            choices = distance_choices,
            selected = distance_default))
}

# parses a block of word pairs.
# returns 3 lists:
#  1. list of pairs of words
#  2. list of words not in norms
#  3. list of malformed lines
get_word_pairs <- function(word_pairs_block) {
    
    word_pairs         <- list()
    words_not_in_norms <- list()
    malformed_lines    <- list()
    
    if (nchar(word_pairs_block) == 0) {
        return(list(
            "word_pairs" = word_pairs, 
            "words_not_in_norms" = words_not_in_norms, 
            "malformed_lines" = malformed_lines))
    }
    
    lines <- word_pairs_block %>% strsplit("\n")
    lines <- lines[[1]]
    
    for (line in lines) {
        bare_line <- str_trim(line)
        
        # Skip empty lines
        if (nchar(bare_line) == 0) { next }
        
        pair = bare_line %>% strsplit(":")
        pair = pair[[1]]
        if (!length(pair) == 2) {
            malformed_lines[length(malformed_lines)+1] = bare_line
            next
        }
        w1 <- str_trim(pair[1])
        w2 <- str_trim(pair[2])
        
        if (! w1 %in% norms$Word) {
            words_not_in_norms[length(words_not_in_norms)+1] <- w1
        }
        if (! w2 %in% norms$Word) { 
            words_not_in_norms[length(words_not_in_norms)+1] <- w2
        }
        if ((w1 %in% norms$Word) && (w2 %in% norms$Word)) { 
            word_pairs[[length(word_pairs)+1]] <- list(w1, w2)
        }
    }
        
    return(list(
        "word_pairs" = word_pairs, 
        "words_not_in_norms" = words_not_in_norms, 
        "malformed_lines" = malformed_lines))
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
    conditionalPanel(
        condition = "input.word_pairs.length == 0",
        actionButton("show_me", label = "Random word pairs"),
    ),
    conditionalPanel(
        condition = "input.word_pairs.length > 0",
        actionButton("clear", label = "Clear"),
    ),
    textOutput("summary_pairs"),
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
    titlePanel("Explore the Lancaster Sensorimotor Norms"),
    p("Explore 11 dimensions of perceptual and action strength ratings for 39,707 English words"),
    tabsetPanel(
        tab_about,
        tab_distances
    ),
)

summarise_pairs <- function(word_pairs, words_not_in_norms, malformed_lines) {
    message = ""
    if (length(word_pairs) == 0) {
        return(message)
    }
    if (length(malformed_lines) > 0) {
        message = paste0(message, prettyNum(length(malformed_lines)), " invalid lines (including \"", malformed_lines[1], "\"). ")
    }
    if (length(words_not_in_norms) > 0) {
        message = paste0(message, prettyNum(length(words_not_in_norms)), " concepts not found (including \"", words_not_in_norms[1], "\"). ")
    }
    message = paste0(prettyNum(length(word_pairs)), " valid pairs entered. ", message)
    return(message)
}

server <- function(input, output, session) {
    
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
    
}

# Run the application 
shinyApp(ui = ui, server = server)

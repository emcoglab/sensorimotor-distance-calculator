library(magrittr)
library(readr)
library(shiny)
library(purrr)
library(stringr)

norms <- read.csv("/Users/cai/Box Sync/LANGBOOT Project/Model/FINAL_sensorimotor_norms_for_39707_words.csv",
                  header = TRUE)

random_norms <- function(n) {
    return(sample(norms$Word, n))
}

random_norm <- function() {
    return(random_norms(1)[1])
}

random_norm_pairs <- function(n) {
    pairs <- random_norms(2*n)
    dim(pairs) <- c(n, 2)
    # Convert matrix to list of rows
    return(split(pairs, rep(1:nrow(pairs), each = ncol(pairs))) %>% array)
}

render_pairs <- function(pairs, item_sep = " : ", pair_sep = "\n") {
    text_block <- pairs %>%
        map(paste, collapse = item_sep) %>%
        unlist %>%
        paste(collapse = pair_sep) %>%
        tolower
    return(text_block)
}

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
    word_pairs         <- vector(mode="list")
    words_not_in_norms <- vector(mode="list")
    malformed_lines    <- vector(mode="list")
    
    if (nchar(word_pairs_block) == 0) {
        return(word_pairs, words_not_in_norms, malformed_lines)
    }
    
    lines <- word_pairs_block %>% strsplit("\n")
    
    for (line in lines) {
        bare_line <- str_trim(line)
        
        # Skip empty lines
        if (nchar(bare_line) == 0) { next }
        
        pair = bare_line %>% strsplit(":")
        if (!length(pair) == 2) {
            malformed_lines %>% append(bare_line)
            next
        }
        w1 <- pair[1]
        w2 <- pair[2]
        if (! w1 %in% norms) { words_not_in_norms %>% append(w1) }
        if (! w2 %in% norms) { words_not_in_norms %>% append(w2) }
        if ((w1 %in% norms) && (w2 %in% norms)) { word_pairs %>% append(c(w1, w2))}
        
        return(list(
            word_pairs = word_pairs, 
            words_not_in_norms = words_not_in_norms, 
            malformed_lines = malformed_lines))
    }
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
        actionButton("show_me", label = "Show me"),
    ),
    conditionalPanel(
        condition = "input.word_pairs.length > 0",
        actionButton("clear", label = "Clear"),
    ),
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
    titlePanel("Explore the Lancaster Sensorimotor Norms"),
    p("Explore 11 dimensions of perceptual and action strength ratings for 39,707 English words"),
    tabsetPanel(
        tab_about,
        tab_distances
    ),
)

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
    
    output$pair_count <- renderText({length(word_pairs)})
}

# Run the application 
shinyApp(ui = ui, server = server)

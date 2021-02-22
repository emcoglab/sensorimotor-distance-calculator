source("ui/shared_elements.r")

tab_one_to_one <- tabPanel(
  title = "One-to-one",
  sidebarLayout(
    sidebarPanel(
      h3("Calculate distances between concepts"),
      h4("One-to-one"),
      helpText(includeMarkdown("ui/help_text/text_entry_pairs.md")),
      textAreaInput(
        inputId = "one_one_word_pairs",
        label = "Concept pairs",
        rows = 10
      ),
      conditionalPanel(
        condition = "input.one_one_word_pairs.length == 0",
        actionButton("one_one_button_random_pairs", label = "Random word pairs"),
      ),
      conditionalPanel(
        condition = "input.one_one_word_pairs.length > 0",
        actionButton("one_one_button_clear", label = "Clear"),
      ),
      textOutput("one_one_summary_pairs") %>% tagAppendAttributes(class = 'summary'),
      distance_select_with_id("one_one"),
      helpText(includeMarkdown("ui/help_text/distances_one_one.md"))
    ),
    mainPanel(
      checkboxInput("will_show_results_one_one", label="") %>% tagAppendAttributes(class = 'hidden'),
      conditionalPanel(
        condition = "input.will_show_results_one_one == 1",
        downloadButton(outputId = "one_one_table_download",
                       label = "Download distance list [.csv]"),
        tableOutput(outputId = "one_one_distances_table")
      )
    )
  )
)

tab_one_to_many <- tabPanel(
  title = "One-to-many",
  sidebarLayout(
    sidebarPanel(
      h3("Calculate distances between concepts"),
      h4("One-to-many"),
      helpText(includeMarkdown("ui/help_text/text_entry_word.md")),
      textInput(
        inputId = "one_many_word_one",
        label = "First concept",
      ),
      conditionalPanel(
        condition = "input.one_many_word_one.length == 0",
        actionButton("one_many_button_random_one", label = "Random word"),
      ),
      conditionalPanel(
        condition = "input.one_many_word_one.length > 0",
        actionButton("one_many_button_clear_one", label = "Clear"),
      ),
      textOutput("one_many_summary_one") %>% tagAppendAttributes(class = 'summary'),
      helpText(includeMarkdown("ui/help_text/text_entry_words.md")),
      textAreaInput(
        inputId = "one_many_words_many",
        label = "Other concepts",
        rows = 10
      ),
      conditionalPanel(
        condition = "input.one_many_words_many.length == 0",
        actionButton("one_many_button_random_many", label = "Random words"),
      ),
      conditionalPanel(
        condition = "input.one_many_words_many.length > 0",
        actionButton("one_many_button_clear_many", label = "Clear"),
      ),
      textOutput("one_many_summary_many") %>% tagAppendAttributes(class = 'summary'),
      distance_select_with_id("one_many"),
      helpText(includeMarkdown("ui/help_text/distances_one_many.md"))
    ),
    mainPanel(
      checkboxInput("will_show_results_one_many", label="") %>% tagAppendAttributes(class = 'hidden'),
      conditionalPanel(
        condition = "input.will_show_results_one_many",
        downloadButton(outputId = "one_many_table_download",
                       label = "Download distance list [.csv]"),
        tableOutput(outputId = "one_many_distances_table")
      )
    )
  )
)

tab_many_to_many <- tabPanel(
  title = "Many-to-many (matrix)",
  sidebarLayout(
    sidebarPanel(
      h3("Calculate distances between concepts"),
      h4("Many-to-many (disatnce matrix)"),
      helpText(includeMarkdown("ui/help_text/text_entry_words.md")),
      textAreaInput(
        inputId = "many_many_words_left",
        label = "Concepts",
        rows = 10
      ),
      conditionalPanel(
        condition = "input.many_many_words_left.length == 0",
        actionButton("many_many_button_random_left", label = "Random words"),
      ),
      conditionalPanel(
        condition = "input.many_many_words_left.length > 0",
        actionButton("many_many_button_clear_left", label = "Clear"),
      ),
      textOutput("many_many_summary_left") %>% tagAppendAttributes(class = 'summary'),
      checkboxInput(
        inputId = "many_many_symmetric",
        label = "Symmetric distance matrix",
        value = TRUE
      ),
      conditionalPanel(
        condition = "! input.many_many_symmetric",
        helpText(includeMarkdown("ui/help_text/text_entry_words.md")),
        textAreaInput(
          inputId = "many_many_words_right",
          label = "Other concepts",
          rows = 10
        ),
        conditionalPanel(
          condition = "input.many_many_words_right.length == 0",
          actionButton("many_many_button_random_right", label = "Random words"),
        ),
        conditionalPanel(
          condition = "input.many_many_words_right.length > 0",
          actionButton("many_many_button_clear_right", label = "Clear"),
        ),
        textOutput("many_many_summary_right") %>% tagAppendAttributes(class = 'summary'),
      ),
      distance_select_with_id("many_many"),
      helpText(includeMarkdown("ui/help_text/distances_many_many.md"))
    ),
    mainPanel(
      checkboxInput("will_show_results_many_many", label="") %>% tagAppendAttributes(class = 'hidden'),
      conditionalPanel(
        condition = "input.will_show_results_many_many",
        downloadButton(outputId = "many_many_matrix_download",
                       label = "Download distance matrix [.csv]"),
        downloadButton(outputId = "many_many_table_download",
                       label = "Download distance list [.csv]"),
        tableOutput(outputId = "many_many_distances_table")
      )
    )
  )
)

page_distances <- navbarMenu(
  "Calculate distances",
  tab_one_to_one,
  tab_one_to_many,
  tab_many_to_many
)

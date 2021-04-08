source("ui/shared_elements.r")

tab_one_to_one <- tabPanel(
  title = "One-to-one",
  sidebarLayout(
    sidebarPanel(
      h3("Calculate distances between concepts:"),
      h4("One-to-one"),
      aboutText(includeMarkdown("ui/page_text/distances_one_one.md")),
      textAreaInput(
        inputId = "one_one_word_pairs",
        label = "Concept pairs",
        rows = 10
      ),
      helpText(includeMarkdown("ui/help_text/text_entry_pairs.md")),
      conditionalPanel(
        condition = "input.one_one_word_pairs.length == 0",
        actionButton("one_one_button_random_pairs", label = "Random word pairs")
      ) %>% tagAppendAttributes(class = "inline"),
      conditionalPanel(
        condition = "input.one_one_word_pairs.length > 0",
        actionButton("one_one_button_clear", label = "Clear"),
      ) %>% tagAppendAttributes(class = "inline"),
      summaryText("one_one_summary_pairs"),
      distance_select_with_id("one_one")
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
      h3("Calculate distances between concepts:"),
      h4("One-to-many"),
      aboutText(includeMarkdown("ui/page_text/distances_one_many.md")),
      textInput(
        inputId = "one_many_word_one",
        label = "First concept",
      ),
      helpText(includeMarkdown("ui/help_text/text_entry_word.md")),
      conditionalPanel(
        condition = "input.one_many_word_one.length == 0",
        actionButton("one_many_button_random_one", label = "Random word"),
      ) %>% tagAppendAttributes(class = "inline"),
      conditionalPanel(
        condition = "input.one_many_word_one.length > 0",
        actionButton("one_many_button_clear_one", label = "Clear"),
      ) %>% tagAppendAttributes(class = "inline"),
      summaryText("one_many_summary_one"),
      textAreaInput(
        inputId = "one_many_words_many",
        label = "Other concepts",
        rows = 10
      ),
      helpText(includeMarkdown("ui/help_text/text_entry_words.md")),
      conditionalPanel(
        condition = "input.one_many_words_many.length == 0",
        actionButton("one_many_button_random_many", label = "Random words"),
      ) %>% tagAppendAttributes(class = "inline"),
      conditionalPanel(
        condition = "input.one_many_words_many.length > 0",
        actionButton("one_many_button_clear_many", label = "Clear"),
      ) %>% tagAppendAttributes(class = "inline"),
      summaryText("one_many_summary_many"),
      distance_select_with_id("one_many")
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
      h3("Calculate distances between concepts:"),
      h4("Many-to-many (disatnce matrix)"),
      aboutText(includeMarkdown("ui/page_text/distances_many_many.md")),
      textAreaInput(
        inputId = "many_many_words_left",
        label = "Concepts",
        rows = 10
      ),
      helpText(includeMarkdown("ui/help_text/text_entry_words.md")),
      conditionalPanel(
        condition = "input.many_many_words_left.length == 0",
        actionButton("many_many_button_random_left", label = "Random words"),
      ) %>% tagAppendAttributes(class = "inline"),
      conditionalPanel(
        condition = "input.many_many_words_left.length > 0",
        actionButton("many_many_button_clear_left", label = "Clear"),
      ) %>% tagAppendAttributes(class = "inline"),
      summaryText("many_many_summary_left"),
      checkboxInput(
        inputId = "many_many_symmetric",
        label = "Symmetric distance matrix",
        value = TRUE
      ),
      helpText(includeMarkdown("ui/help_text/distance_asymmetric.md")),
      conditionalPanel(
        condition = "! input.many_many_symmetric",
        textAreaInput(
          inputId = "many_many_words_right",
          label = "Other concepts",
          rows = 10
        ),
        helpText(includeMarkdown("ui/help_text/text_entry_words.md")),
        conditionalPanel(
          condition = "input.many_many_words_right.length == 0",
          actionButton("many_many_button_random_right", label = "Random words"),
        ) %>% tagAppendAttributes(class = "inline"),
        conditionalPanel(
          condition = "input.many_many_words_right.length > 0",
          actionButton("many_many_button_clear_right", label = "Clear"),
        ) %>% tagAppendAttributes(class = "inline"),
        summaryText("many_many_summary_right"),
      ),
      distance_select_with_id("many_many")
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

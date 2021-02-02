source("ui_shared_elements.r")

tab_one_to_one <- tabPanel(
  title = "One-to-one",
  sidebarLayout(
    sidebarPanel(
      h3("Calculate distances between concepts"),
      distance_select_with_id("one_one"),
      helpText(
        "Enter pairs of concepts separated by colons, with each pair on a ",
        "separate line."
      ),
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
      textOutput("one_one_summary_pairs"),
      helpText(
        "Calculate distances between pairs of concepts' ",
        "vector representations. Select the distance ",
        "type from the drop-down, and enter pairs of ",
        "concepts in the text box."
      )
    ),
    mainPanel(
      tableOutput(outputId = "one_one_distances_table"),
      conditionalPanel(
        # TODO: based on table output, not words input... or hidden shared input?
        condition = "input.one_one_word_pairs.length > 0",
        downloadButton(outputId = "one_one_table_download",
                       label = "Download distance list [.csv]")
      )
    )
  )
)

tab_one_to_many <- tabPanel(
  title = "One-to-many",
  sidebarLayout(
    sidebarPanel(
      h3("Calculate the distance between concepts"),
      distance_select_with_id("one_many"),
      helpText(
        "Enter concepts separated by colons, on separate lines."
      ),
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
      textOutput("one_many_summary_one"),
      textAreaInput(
        inputId = "one_many_words_many",
        label = "Other concepts",
        rows = 10
      ),
      conditionalPanel(
        condition = "input.one_many_words_many.length == 0",
        actionButton("one_many_button_random_many", label = "Randoms"),
      ),
      conditionalPanel(
        condition = "input.one_many_words_many.length > 0",
        actionButton("one_many_button_clear_many", label = "Clear"),
      ),
      textOutput("one_many_summary_many"),
      helpText(
        "Calculate distances between the vector ", 
        "representation of a concept and several ",
        "other concepts. Select the distance type ",
        "from the drop-down, and enter pairs of ",
        "concepts in the text box."
      )
    ),
    mainPanel(
      tableOutput(outputId = "one_many_distances_table"),
      conditionalPanel(
        # TODO: based on table output, not words input... or hidden shared input?
        condition = "(input.one_many_words_many.length > 0) && (input.one_many_word_one.length > 0)",
        downloadButton(outputId = "one_many_table_download",
                       label = "Download distance list [.csv]")
      )
    )
  )
)

tab_many_to_many <- tabPanel(
  title = "Many-to-many",
  sidebarLayout(
    sidebarPanel(
      h3("Calculate the distance between concepts"),
      distance_select_with_id("many_many"),
      helpText(
        "Enter pair concepts here, on separate lines."
      ),
      textAreaInput(
        inputId = "many_many_words_left",
        label = "First concepts",
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
      textOutput("many_many_summary_left"),
      textAreaInput(
        inputId = "many_many_words_right",
        label = "Second concepts",
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
      textOutput("many_many_summary_right"),
      helpText(
        "Calculate distances between the vector ", 
        "representation of different concepts. ",
        "Select the distance type from the drop-down, ",
        "and enter lists of concepts in the text boxes."
      )
    ),
    mainPanel(
      tableOutput(outputId = "many_many_distances_table"),
      conditionalPanel(
        # TODO: based on table output, not words input... or hidden shared input?
        condition = "(input.many_many_words_left.length > 0) && (input.many_many_words_right.length > 0)",
        downloadButton(outputId = "many_many_matrix_download",
                       label = "Download distance matrix [.csv]"),
        downloadButton(outputId = "many_many_table_download",
                       label = "Download distance list [.csv]")
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
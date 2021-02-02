source("meta.r")

page_about <- tabPanel(
  title = "About",
  includeMarkdown("about.md"),
  HTML("Version", meta_version)
)

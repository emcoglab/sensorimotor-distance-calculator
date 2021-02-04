source("meta.r")

page_about <- tabPanel(
  title = "About",
  includeMarkdown("about.md"),
  HTML(paste0("Version ", meta_version, "."))
)

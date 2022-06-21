tab_about <- tabPanel(
  title = "About",
  includeMarkdown("ui/page_text/about.md"),
)

tab_news <- tabPanel(
  title = "News and updates",
  includeMarkdown("ui/page_text/news.md")
)

page_about <- navbarMenu(
  "About",
  tab_about,
  tab_news
)

library(shiny)

sp_vars <- c(
  "SHINYPROXY_KTH_USERID",
  "SHINYPROXY_KTH_USERNAME",
  "SHINYPROXY_KTH_EMAIL",
  "SHINYPROXY_KTH_AFFILIATION",
  "SHINYPROXY_KTH_MEMBER_OF",
  "SHINYPROXY_CONTAINER_IMAGE",
  "SHINYPROXY_CONTAINER_INDEX",
  "SHINYPROXY_CREATED_TIMESTAMP",
  "SHINYPROXY_USERGROUPS"
)

ui <- fluidPage(
  titlePanel("ShinyProxy env-var demo"),
  p("Reads SHINYPROXY_* environment variables injected by ShinyProxy into the container at startup."),
  tableOutput("envtable")
)

server <- function(input, output, session) {
  output$envtable <- renderTable({
    vals <- Sys.getenv(sp_vars, unset = NA_character_)
    names(vals)[names(vals) == "SHINYPROXY_USERGROUPS"] <- "SHINYPROXY_KTH_USERGROUPS"
    data.frame(Variable = names(vals), Value = unname(vals), stringsAsFactors = FALSE)
  })
}

shinyApp(ui, server)

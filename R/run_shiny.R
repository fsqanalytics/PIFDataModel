#' Run JSON Schema Viewer App
#'
#' Launches a Shiny app to interactively view JSON schemas.
#' @export
run_schema_viewer <- function() {
#  library(shiny)
#  library(jsonlite)
  
  ui <- shiny::fluidPage(
    shiny::titlePanel("JSON Schema Viewer"),
    shiny::sidebarLayout(
      shiny::sidebarPanel(
        shiny::selectInput("schema", "Choose Schema:", 
                           choices = list.files(system.file("schemas", package = "PIFDataModel")))
      ),
      shiny::mainPanel(
        shiny::verbatimTextOutput("schema_view")
      )
    )
  )
  
  server <- function(input, output) {
    output$schema_view <- shiny::renderPrint({
      schema_file <- system.file("schemas", input$schema, package = "PIFDataModel")
      if (!file.exists(schema_file)) return("Select a schema to view.")
      cat(jsonlite::prettify(readLines(schema_file, warn = FALSE)))
    })
  }
  
  shiny::shinyApp(ui, server)
}

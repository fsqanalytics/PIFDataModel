#' Run JSON Schema Viewer App with Diagram Feature
#'
#' Launches a Shiny app to interactively view JSON schemas and generate diagrams.
#' @importFrom shiny fluidPage titlePanel sidebarLayout sidebarPanel selectInput actionButton 
#'   tabsetPanel tabPanel mainPanel verbatimTextOutput updateSelectInput observeEvent renderPrint 
#'   reactive downloadHandler shinyApp renderUI
#' @importFrom jsonlite fromJSON prettify
#' @importFrom DiagrammeR grViz grVizOutput renderGrViz export_graph
#' @importFrom rsvg rsvg_png
#' @export
shiny_schema_viewer <- function() {
  ui <- shiny::fluidPage(
    shiny::titlePanel("JSON Schema Viewer & Diagram Generator"),
    shiny::sidebarLayout(
      shiny::sidebarPanel(
        shiny::selectInput(
          "schema", "Choose Schema:",
          choices = list.files(system.file("schemas", package = "PIFDataModel")),
          selected = NULL
        ),
        shiny::actionButton("refresh", "Refresh List"),
        shiny::downloadButton("download_schema", "Download Schema"),
        shiny::downloadButton("download_diagram", "Download Diagram (PNG)")
      ),
      shiny::mainPanel(
        shiny::tabsetPanel(
          shiny::tabPanel(
            "View JSON",
            shiny::verbatimTextOutput("schema_view")
          ),
          shiny::tabPanel(
            "Generate Diagram",
            DiagrammeR::grVizOutput("diagram_view", height = "500px")
          )
        )
      )
    )
  )
  
  server <- function(input, output, session) {
    # Reactive schema list to update dynamically
    schema_list <- shiny::reactive({
      list.files(system.file("schemas", package = "PIFDataModel"))
    })
    
    # Refresh schema list
    shiny::observeEvent(input$refresh, {
      shiny::updateSelectInput(session, "schema", choices = schema_list())
    })
    
    # Render JSON schema
    output$schema_view <- shiny::renderPrint({
      schema_file <- system.file("schemas", input$schema, package = "PIFDataModel")
      if (is.null(input$schema) || !file.exists(schema_file)) {
        return("Select a schema to view.")
      }
      
      tryCatch({
        json_content <- readLines(schema_file, warn = FALSE)
        jsonlite::prettify(paste(json_content, collapse = "\n"))
      }, error = function(e) {
        paste("Error loading schema:", e$message)
      })
    })
    
    # Generate Diagram
    output$diagram_view <- DiagrammeR::renderGrViz({
      schema_file <- system.file("schemas", input$schema, package = "PIFDataModel")
      if (is.null(input$schema) || !file.exists(schema_file)) {
        return(DiagrammeR::grViz("digraph schema { rankdir=LR; node [shape=plaintext]; No_Schema_Selected; }"))
      }
      
      tryCatch({
        schema <- jsonlite::fromJSON(schema_file)
        generate_schema_diagram(schema)
      }, error = function(e) {
        DiagrammeR::grViz(paste0(
          "digraph error { node [shape=plaintext]; \"Error generating diagram: ", e$message, "\"; }"
        ))
      })
    })
    
    # Download JSON schema
    output$download_schema <- shiny::downloadHandler(
      filename = function() {
        paste0(input$schema)
      },
      content = function(file) {
        schema_file <- system.file("schemas", input$schema, package = "PIFDataModel")
        if (file.exists(schema_file)) {
          file.copy(schema_file, file)
        } else {
          writeLines("Error: File not found.", file)
        }
      }
    )
    
    # Download Diagram as PNG
    output$download_diagram <- shiny::downloadHandler(
      filename = function() {
        paste0(tools::file_path_sans_ext(input$schema), "_diagram.png")
      },
      content = function(file) {
        schema_file <- system.file("schemas", input$schema, package = "PIFDataModel")
        if (is.null(input$schema) || !file.exists(schema_file)) {
          stop("No schema selected or file not found.")
        }
        
        tryCatch({
          schema <- jsonlite::fromJSON(schema_file)
          graph <- generate_schema_diagram(schema, exportable = TRUE)
          svg_content <- DiagrammeR::export_graph(graph)  # Convert to SVG
          rsvg::rsvg_png(charToRaw(svg_content), file)       # Convert SVG to PNG
        }, error = function(e) {
          stop("Error generating or exporting diagram: ", e$message)
        })
      }
    )
  }
  
  # Function to generate a DiagrammeR diagram from a JSON schema
  generate_schema_diagram <- function(schema, exportable = FALSE) {
    nodes <- data.frame(id = character(), label = character(), stringsAsFactors = FALSE)
    edges <- data.frame(from = character(), to = character(), stringsAsFactors = FALSE)
    
    # Recursive function to parse schema
    parse_schema <- function(obj, parent_id = NULL) {
      for (name in names(obj)) {
        node_id <- gsub("[^a-zA-Z0-9]", "_", name)  # Sanitize node IDs
        label <- paste0(name, "\n(", class(obj[[name]]), ")")
        nodes <<- rbind(nodes, data.frame(id = node_id, label = label, stringsAsFactors = FALSE))
        
        if (!is.null(parent_id)) {
          edges <<- rbind(edges, data.frame(from = parent_id, to = node_id, stringsAsFactors = FALSE))
        }
        
        if (is.list(obj[[name]])) {
          parse_schema(obj[[name]], node_id)
        }
      }
    }
    
    parse_schema(schema)
    
    # Construct DiagrammeR graph with sky blue nodes
    dot_graph <- paste0(
                        "digraph schema {\n",
                        "rankdir=LR;\n",
                        "node [shape=box, style=filled, fillcolor=\"#87CEEB\"];\n",  # Sky Blue
      paste0(nodes$id, " [label=\"", nodes$label, "\"];\n", collapse = ""),
      paste0(edges$from, " -> ", edges$to, ";\n", collapse = ""),
      "}"
    )
    DiagrammeR::grViz(dot_graph)
  }
  
  shiny::shinyApp(ui, server)
}

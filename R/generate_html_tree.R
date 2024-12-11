#' Generate HTML Tree for JSON Schema
#'
#' Creates an HTML tree representation of a JSON schema.
#' @param schema_file Path to the JSON schema file.
#' @return An HTML representation of the schema.
#' @export
generate_html_tree <- function(schema_file) {
  # Read the schema JSON file
  schema <- jsonlite::fromJSON(schema_file, simplifyVector = FALSE)
  
  # Recursive function to create a tree structure
  create_tree <- function(node, name = NULL) {
    # Ensure name is provided for clarity
    if (is.null(name)) name <- "root"
    
    # Build the tree
    htmltools::tags$ul(
      htmltools::tags$li(
        htmltools::tags$b(name), # Display the name of the node
        if (is.list(node)) {
          # Recursively process child nodes if the current node is a list
          lapply(names(node), function(child_name) create_tree(node[[child_name]], child_name))
        } else {
          # Render atomic values as text
          htmltools::tags$span(as.character(node))
        }
      )
    )
  }
  
  # Build the entire HTML document
  htmltools::tags$html(
    htmltools::tags$head(
      htmltools::tags$title("JSON Schema Tree") # Add a title to the document
    ),
    htmltools::tags$body(
      create_tree(schema) # Insert the tree into the body
    )
  )
}

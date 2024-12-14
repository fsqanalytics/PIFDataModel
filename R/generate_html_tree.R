#' Generate HTML Tree for JSON Schema
#'
#' This function takes a JSON schema file as input and generates an HTML tree
#' representation of the schema.
#'
#' @param schema_file A file path to a JSON schema. If the file is part of a
#' package, use \code{system.file} to locate it.
#'
#' @return A character string containing the HTML tree.
#'
#' @examples
#' schema_file <- system.file("schemas/user_schema.json", package = "PIFDataModel")
#' html_representation <- generate_html_tree(schema_file)
#' cat(html_representation) # Output to console, or write to a file
#' # write(html_representation, file = "schema_tree.html")
#'
#' @importFrom jsonlite fromJSON validate
#' @importFrom htmltools tags tagList HTML
#'
#' @export
generate_html_tree <- function(schema_file) {
  # Check if the file exists
  if (!file.exists(schema_file)) {
    stop("File not found: ", schema_file, "\nEnsure the file path is correct.")
  }
  
  # Read and validate the JSON schema
  schema_text <- tryCatch(
    readLines(schema_file),
    error = function(e) {
      stop("Unable to read the file. Ensure it is accessible.\nError details: ", e$message)
    }
  )
  
  if (!jsonlite::validate(paste(schema_text, collapse = "\n"))) {
    stop("Invalid JSON schema: The file contains malformed JSON.")
  }
  
  # Parse the JSON schema
  schema <- tryCatch(
    jsonlite::fromJSON(schema_file),
    error = function(e) {
      stop("Error parsing JSON schema: ", e$message)
    }
  )
  
  # Recursive function to generate HTML elements
  build_tree <- function(obj, level = 0) {
    local_tags <- list()
    indent <- paste0("&nbsp;", strrep("&nbsp;", level * 2))
    
    if (is.list(obj) && !is.null(obj$type)) {
      if (obj$type == "object") {
        local_tags <- append(local_tags, htmltools::tags$p(htmltools::HTML(
          paste0(indent, "<b>Object:</b> ", ifelse(!is.null(names(obj)), names(obj)[1], "Unnamed"))
        )))
        if (!is.null(obj$properties)) {
          for (prop_name in names(obj$properties)) {
            local_tags <- append(local_tags, build_tree(obj$properties[[prop_name]], level + 1))
          }
        }
      } else if (obj$type == "array") {
        local_tags <- append(local_tags, htmltools::tags$p(htmltools::HTML(
          paste0(indent, "<b>Array:</b> ", ifelse(!is.null(names(obj)), names(obj)[1], "Unnamed"))
        )))
        if (!is.null(obj$items)) {
          local_tags <- append(local_tags, build_tree(obj$items, level + 1))
        }
      } else {
        local_tags <- append(local_tags, htmltools::tags$p(htmltools::HTML(
          paste0(indent, "<b>Type:</b> ", obj$type, " (", ifelse(!is.null(names(obj)), names(obj)[1], "Unnamed"), ")")
        )))
      }
    } else if (is.list(obj)) {
      for (name in names(obj)) {
        local_tags <- append(local_tags, htmltools::tags$p(htmltools::HTML(
          paste0(indent, "<b>", name, ":</b> ", obj[[name]])
        )))
      }
    } else {
      local_tags <- append(local_tags, htmltools::tags$p(htmltools::HTML(
        paste0(indent, obj)
      )))
    }
    
    return(local_tags)
  }
  
  # Generate the main HTML structure
  html_output <- htmltools::tagList(
    htmltools::tags$html(
      htmltools::tags$head(
        htmltools::tags$title("JSON Schema Tree")
      ),
      htmltools::tags$body(
        build_tree(schema)
      )
    )
  )
  
  # Return the complete HTML as a character string
  return(as.character(html_output))
}

#' Generate Diagram from JSON Schema
#'
#' Generates a graph representation of a JSON schema using the DiagrammeR package.
#' @param schema_file Path to the JSON schema file.
#' @param debug Logical, whether to print debug information.
#' @return A DiagrammeR graph object.
#' @examples
#' # Example usage:
#' # generate_schema_diagram("user_schema.json")
#' @export
generate_schema_diagram <- function(schema_file, debug = FALSE) {
  # Check if the file exists
  if (!file.exists(schema_file)) {
    stop("Schema file not found: ", schema_file)
  }
  
  # Read and parse the JSON schema
  schema <- tryCatch(
    jsonlite::fromJSON(schema_file, simplifyVector = FALSE),
    error = function(e) {
      stop("Failed to parse JSON schema: ", e$message)
    }
  )
  
  # Initialize nodes and edges
  nodes <- c()
  edges <- c()
  
  # Recursive function to traverse the JSON schema
  traverse <- function(node, parent = NULL, node_name = "root") {
    sanitized_name <- sanitize_label(node_name)
    node_id <- paste0(sanitized_name, "_", digest::digest(c(parent, sanitized_name)))
    
    cat("Adding node:", node_id, "\n")
    
    # Add the current node
    nodes <<- c(nodes, sprintf('"%s" [label="%s"]', node_id, sanitized_name))
    
    # Add edge to parent
    if (!is.null(parent)) {
      cat("Adding edge:", parent, "->", node_id, "\n")
      edges <<- c(edges, sprintf('"%s" -> "%s";', parent, node_id))
    }
    
    # Recursively process children
    if (is.list(node) && !is.null(names(node))) {
      for (child_name in names(node)) {
        traverse(node[[child_name]], node_id, child_name)
      }
    }
  }
  
  
  
  # Start the traversal with the root node
  traverse(schema)
  
  # Construct the Graphviz string
  graph_str <- paste0(
    "digraph json_schema {\n",
    paste(nodes, collapse = "\n"),
    "\n",
    paste(edges, collapse = "\n"),
    "\n}"
  )
  
  # Debugging: Print the Graphviz string if debug is TRUE
  if (debug) {
    cat("Generated Graphviz String:\n", graph_str, "\n")
  }
  
  # Create the DiagrammeR graph object
  tryCatch(
    DiagrammeR::grViz(graph_str),
    error = function(e) {
      stop("Failed to generate DiagrammeR graph: ", e$message)
    }
  )
}

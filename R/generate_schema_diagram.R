#' Generate Diagram from JSON Schema
#'
#' Generates a graph representation of a JSON schema using the DiagrammeR package.
#' @param schema_file Path to the JSON schema file.
#' @return A DiagrammeR graph object.
#' @examples
#' schema_file <- system.file("schemas", "person_schema.json", package = "PIFDataModel")
#' generate_schema_diagram(schema_file)
#' 
#' @export
generate_schema_diagram <- function(schema_file) {
  # Load the JSON schema
  schema <- jsonlite::fromJSON(schema_file)
  
  # Create lists to store nodes and edges
  nodes <- data.frame(id = character(), label = character(), shape = character(), stringsAsFactors = FALSE)
  edges <- data.frame(from = character(), to = character(), stringsAsFactors = FALSE)
  
  # Generate unique IDs for nodes
  generate_node_id <- function(prefix, name) {
    paste0(prefix, "_", gsub("[^a-zA-Z0-9]", "_", name))
  }
  
  # Recursive function to traverse the schema
  traverse_schema <- function(obj, parent_id = NULL, prefix = "node") {
    for (name in names(obj)) {
      node_id <- generate_node_id(prefix, name)
      label <- paste0(name, " (", class(obj[[name]]), ")")
      shape <- if (is.list(obj[[name]])) "box" else "ellipse"
      
      # Add the current node
      nodes <<- rbind(nodes, data.frame(id = node_id, label = label, shape = shape, stringsAsFactors = FALSE))
      
      # Add an edge from parent to current node
      if (!is.null(parent_id)) {
        edges <<- rbind(edges, data.frame(from = parent_id, to = node_id, stringsAsFactors = FALSE))
      }
      
      # Recursively traverse nested objects or arrays
      if (is.list(obj[[name]])) {
        traverse_schema(obj[[name]], parent_id = node_id, prefix = node_id)
      }
    }
  }
  
  # Start traversal from the root
  traverse_schema(schema)
  
  # Construct DOT syntax
  dot_nodes <- paste(sapply(1:nrow(nodes), function(i) {
    paste0(nodes$id[i], " [label=\"", nodes$label[i], "\", shape=", nodes$shape[i], "];")
  }), collapse = "\n")
  
  dot_edges <- paste(sapply(1:nrow(edges), function(i) {
    paste0(edges$from[i], " -> ", edges$to[i], ";")
  }), collapse = "\n")
  
  dot_graph <- paste0("digraph schema {\n",
                      "rankdir=LR;\n",
                      dot_nodes, "\n",
                      dot_edges, "\n}")
  
  # Generate the DiagrammeR graph
  DiagrammeR::grViz(dot_graph)
}

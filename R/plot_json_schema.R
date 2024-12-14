#' Generate HTML Tree for JSON Schema
#'
#' This function takes a JSON schema file as input and generates an interactive
#' HTML tree representation of the schema using a force-directed graph.
#'
#' @param schema_file A string representing the path to the JSON schema file.
#' @return An HTML widget containing the interactive graph.
#'
#' @examples
#' schema_file <- system.file("schemas", "user_schema.json", package = "PIFDataModel")
#' plot_json_schema(schema_file)
#'
#' @importFrom jsonlite fromJSON
#' @importFrom networkD3 forceNetwork
#' @export
plot_json_schema <- function(schema_file) {
  # Load the JSON schema
  schema <- jsonlite::fromJSON(schema_file)
  
  # Recursive function to extract nodes and links
  extract_nodes_links <- function(obj, parent_id = NULL, nodes = data.frame(name = character(), id = numeric(), group = numeric()), links = data.frame(source = numeric(), target = numeric(), value = numeric())) {
    current_id <- ifelse(nrow(nodes) == 0, 1, max(nodes$id) + 1)
    
    # Determine node name
    node_name <- if (!is.null(names(obj))) names(obj)[1] else "root"
    nodes <- rbind(nodes, data.frame(name = node_name, id = current_id, group = 1))
    
    if (!is.null(parent_id)) {
      links <- rbind(links, data.frame(source = parent_id, target = current_id, value = 1))
    }
    
    if (is.list(obj)) {
      for (i in seq_along(obj)) {
        res <- extract_nodes_links(obj[[i]], parent_id = current_id, nodes = nodes, links = links)
        nodes <- res$nodes
        links <- res$links
      }
    } else if (!is.null(obj)) {
      # Handle primitive values as leaf nodes
      leaf_id <- max(nodes$id) + 1
      nodes <- rbind(nodes, data.frame(name = as.character(obj), id = leaf_id, group = 2))
      links <- rbind(links, data.frame(source = current_id, target = leaf_id, value = 1))
    }
    
    return(list(nodes = nodes, links = links))
  }
  
  # Extract nodes and links from the schema
  extracted_data <- extract_nodes_links(schema)
  nodes <- extracted_data$nodes
  links <- extracted_data$links
  
  # Check for empty nodes or links
  if (nrow(nodes) == 0 || nrow(links) == 0) {
    stop("The JSON schema does not contain valid data to plot.")
  }
  
  # Adjust IDs for zero-based indexing
  nodes$id <- nodes$id - 1
  links$source <- links$source - 1
  links$target <- links$target - 1
  
  # Create the force-directed graph
  networkD3::forceNetwork(
    Links = links, Nodes = nodes, Source = "source", Target = "target",
    NodeID = "name", Group = "group", opacity = 0.8, zoom = TRUE,
    fontSize = 12, linkDistance = 25
  )
}

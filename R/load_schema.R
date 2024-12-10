#' Load a JSON Schema
#'
#' Loads a JSON schema from the package's `inst/schemas/` directory.
#'
#' @param schema_name A string representing the name of the JSON schema file (e.g., "user_schema.json").
#' @return A list representing the schema, with attributes `"schema_name"` and `"schema_path"` for metadata.
#' @source <https://github.com/fsqanalytics/PIFDataModel/blob/main/inst/schemas/user_schema.json>
#' @examplesIf interactive()
#' # View the contents of the schema file (if available)
#' cat(readLines(system.file("schemas", "user_schema.json", package = "PIFDataModel")), sep = "\n")
#' 
#' # Load the schema
#' schema <- load_schema("user_schema.json")
#' @export
load_schema <- function(schema_name) {
  # Validate input
  if (!is.character(schema_name) || length(schema_name) != 1) {
    stop("'schema_name' must be a single string.")
  }
  
  # Get the full path of the schema file
  schema_path <- system.file("schemas", schema_name, package = "PIFDataModel")
  
  # Check if the schema file exists
  if (schema_path == "") {
    available_schemas <- list.files(system.file("schemas", package = "PIFDataModel"), full.names = FALSE)
    stop("Schema '", schema_name, "' not found. Available schemas: ", 
         paste(available_schemas, collapse = ", "), ".")
  }
  
  # Load and return the schema as a list
  schema <- jsonlite::fromJSON(schema_path)
  attr(schema, "schema_name") <- schema_name  # Add metadata
  attr(schema, "schema_path") <- schema_path  # Add metadata
  return(schema)
}

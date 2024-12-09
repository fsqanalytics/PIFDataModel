#' Load a JSON Schema
#'
#' Loads a JSON schema from the package's `inst/schemas/` directory.
#'
#' @param schema_name The name of the JSON schema file (e.g., "user_schema.json").
#' @return A list representing the schema.
#' @examples
#' \dontrun{
#'   schema <- load_schema("user_schema.json")
#' }
#' @export
load_schema <- function(schema_name) {
  # Get the full path of the schema file
  schema_path <- system.file("schemas", schema_name, package = "PIFDataModel")
  
  # Check if the schema file exists
  if (schema_path == "") {
    stop("Schema not found: '", schema_name, "' in the 'PIFDataModel' package.")
  }
  
  # Load and return the schema as a list
  jsonlite::fromJSON(schema_path)
}

#' Display JSON Schema
#'
#' Loads and displays a JSON schema from the package in a readable format.
#' @param schema_file Path to the JSON schema file (relative or absolute path).
#' @return Prints the formatted JSON schema to the console.
#' @examples
#' schema_file <- system.file("schemas", "user_schema.json", package = "PIFDataModel")
#' display_json_schema(schema_file)
#' @importFrom jsonlite fromJSON toJSON
#' @export
display_json_schema <- function(schema_file) {
  # Validate file path
  if (!file.exists(schema_file)) {
    stop("The specified schema file does not exist: ", schema_file)
  }
  
  # Read the JSON schema from the file
  json_schema <- jsonlite::fromJSON(schema_file)
  
  # Display the schema in a readable format
  cat(jsonlite::toJSON(json_schema, pretty = TRUE))
}


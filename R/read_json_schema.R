#' Read JSON Schema
#'
#' Reads and parses a JSON schema from a file, returning it as a structured R list.
#'
#' @param schema_path A character string specifying the file path to the JSON schema.
#' @return A list representing the parsed JSON schema.
#' @examples
#' schema_path <- system.file("schemas/user_schema.json", package = "PIFDataModel")
#' schema <- read_json_schema(schema_path)
#' print(schema$title)  # Access the title of the schema
#' @export
read_json_schema <- function(schema_path) {
  # Check if the file exists
  if (!file.exists(schema_path)) {
    stop("Schema file not found: ", schema_path)
  }
  
  # Read and parse the JSON schema file
  schema <- jsonlite::fromJSON(schema_path, simplifyVector = FALSE)
  
  # Return the parsed schema
  return(schema)
}

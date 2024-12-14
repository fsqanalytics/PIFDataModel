#' Read JSON Schema
#'
#' Reads and parses a JSON schema from a file, returning it as a structured R list.
#'
#' @param schema_path A character string specifying the file path to the JSON schema.
#' @return A list representing the parsed JSON schema. Returns an error if the file is not found or contains invalid JSON.
#' @examples
#' schema_file <- system.file("schemas/user_schema.json", package = "PIFDataModel")
#' schema <- read_json_schema(schema_file)
#' # Print the schema (optional)
#' print(schema)
#' @importFrom jsonlite fromJSON validate
#' @export
read_json_schema <- function(schema_path) {
  # Check if the file exists
  if (!file.exists(schema_path)) {
    stop("File not found: ", schema_path, ". Ensure the file path is correct.")
  }
  
  # Validate and parse the JSON schema
  schema_text <- tryCatch(
    readLines(schema_path),
    error = function(e) {
      stop("Unable to read the file: ", schema_path, ". Error: ", e$message)
    }
  )
  
  if (!jsonlite::validate(paste(schema_text, collapse = "\n"))) {
    stop("Invalid JSON: The file contains malformed JSON.")
  }
  
  schema <- tryCatch(
    jsonlite::fromJSON(schema_path),
    error = function(e) {
      stop("Error parsing JSON: ", e$message)
    }
  )
  
  # Return the parsed schema
  return(schema)
}

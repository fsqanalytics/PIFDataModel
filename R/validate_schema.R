#' Validate JSON Data Against a Schema
#'
#' Validates a JSON object against a specified JSON schema.
#'
#' @param json_data A JSON string or an R object that can be serialized to JSON.
#' @param schema_name The name of the JSON schema file in `inst/schemas/`.
#' @return Logical `TRUE` if validation succeeds; otherwise, an error is thrown.
#' @examples
#' \dontrun{
#'   json_data <- '{"id": 1, "name": "Alice"}'
#'   validate_schema(json_data, "user_schema.json")
#' }
#' @export
validate_schema <- function(json_data, schema_name) {
  # Get the schema file path
  schema_path <- system.file("schemas", schema_name, package = "PIFDataModel")
  
  # Check if the schema file exists
  if (schema_path == "") {
    stop("Schema not found: '", schema_name, "' in the 'PIFDataModel' package.")
  }
  
  # Serialize json_data to JSON if it's not already a JSON string
  if (!is.character(json_data)) {
    json_data <- jsonlite::toJSON(json_data, auto_unbox = TRUE)
  }
  
  # Validate the JSON data against the schema file
  result <- jsonvalidate::json_validate(json_data, schema_path, verbose = TRUE)
  
  if (!result) {
    stop("Validation failed.")
  }
  
  return(TRUE)
}

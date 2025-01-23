#' Validate JSON Against a Schema
#'
#' Validates a JSON file against a given JSON schema.
#' @param schema_file Path to the JSON schema file.
#' @param json_file Path to the JSON file to validate.
#' @return Logical value indicating if the JSON is valid.
#' @importFrom jsonvalidate json_validator
#' @examples
#' #schema_file <- system.file("schemas", "bacteria_count_schema.json", package = "PIFDataModel")
#' #json_file <- system.file("data", "valid_sample_data.json", package = "PIFDataModel")
#' #validate_json_schema(schema_file, json_file)
#' #json_file <- system.file("data", "invalid_sample_data.json", package = "PIFDataModel")
#' #validate_json_schema(schema_file, json_file)
#' @export
validate_json_schema <- function(schema_file, json_file) {
  if (!file.exists(schema_file)) {
    stop("Schema file does not exist: ", schema_file)
  }
  if (!file.exists(json_file)) {
    stop("JSON file does not exist: ", json_file)
  }
  
  schema <- jsonvalidate::json_validator(schema_file, engine = "ajv")
  
  # Validate and return the result
  result <- schema(json_file, verbose = TRUE)
  if (!result) {
    FALSE
    stop("Schema validation failed")
  }
  
  TRUE
}
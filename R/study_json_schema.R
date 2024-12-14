#' Study Schema
#'
#' Reads and returns the Study JSON schema from the package.
#'
#' The schema defines a `Study` object.
#' It is stored in the `/inst/schemas` directory of the package.
#'
#' @return A character string containing the JSON schema.
#' @examples
#' # Access the schema
#' schema <- study_json_schema()
#' cat(schema)
#'
#' # Example validation (requires jsonvalidate package)
#' validator <- jsonvalidate::json_validator(schema)
#' validator('{"name": "Apple", "calories": 52}')
#' @export
study_json_schema <- function() {
  # Locate the schema file in the installed package
  schema_path <- system.file("schemas/study_schema.json", package = "PIFDataModel")
  
  # Check if the file exists
  if (schema_path == "") {
    stop("The study_schema.json file is not found in the package.")
  }
  
  # Read the schema as a JSON string
  schema <- paste(readLines(schema_path, warn = FALSE), collapse = "\n")
  
  # Return the schema
  return(schema)
}

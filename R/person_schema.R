#' Person Schema
#'
#' Reads and returns the Person JSON schema from the package.
#'
#' The schema defines a `Person` object with required fields for `name` and `age`.
#' It is stored in the `/inst/schemas` directory of the package.
#'
#' @return A character string containing the JSON schema.
#' @examples
#' # Access the schema
#' schema <- person_schema()
#' cat(schema)
#'
#' # Example validation (requires jsonvalidate package)
#' # library(jsonvalidate)
#' validator <- jsonvalidate::json_validator(schema)
#' validator('{"name": "Alice", "age": 30}')
#' @export
person_schema <- function() {
  # Locate the schema file in the installed package
  schema_path <- system.file("schemas/person_schema.json", package = "PIFDataModel")
  
  # Check if the file exists
  if (schema_path == "") {
    stop("The person_schema.json file is not found in the package.")
  }
  
  # Read the schema as a JSON string
  schema <- paste(readLines(schema_path, warn = FALSE), collapse = "\n")
  
  # Return the schema
  return(schema)
}

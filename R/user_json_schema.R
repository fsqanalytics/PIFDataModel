#' User Schema
#'
#' Reads and returns the User JSON schema from the package.
#'
#' The schema defines a `User` object with required fields for `id` and `name`, and an optional `email` field.
#' It is stored in the `/inst/schemas` directory of the package.
#'
#' @return A character string containing the JSON schema.
#' @examples
#' # Access the schema
#' schema <- user_json_schema()
#' cat(schema)
#'
#' # Example validation (requires jsonvalidate package)
#' # library(jsonvalidate)
#' validator <- jsonvalidate::json_validator(schema)
#' validator('{"id": 1, "name": "Alice", "email": "alice@example.com"}')
#' @export
user_json_schema <- function() {
  # Locate the schema file in the installed package
  schema_path <- system.file("schemas/user_schema.json", package = "PIFDataModel")
  
  # Check if the file exists
  if (schema_path == "") {
    stop("The user_schema.json file is not found in the package.")
  }
  
  # Read the schema as a JSON string
  schema <- paste(readLines(schema_path, warn = FALSE), collapse = "\n")
  
  # Return the schema
  return(schema)
}

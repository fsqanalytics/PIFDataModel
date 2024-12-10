#' Generate or Load a JSON Schema Document
#'
#' Generates a JSON schema document dynamically based on an R object
#' or loads a predefined schema template from the package.
#'
#' @param r_object (Optional) An R object to derive a JSON schema from. If `NULL`, a boilerplate schema is returned.
#' @param save_to (Optional) File path to save the generated schema. If `NULL`, the schema is returned as a list.
#' @return A JSON schema as a list if `save_to` is `NULL`; otherwise, saves the schema to the specified file.
#' @examples
#' \dontrun{
#'   # Generate a schema from an R object
#'   schema <- document_schema(list(id = 1, name = "Alice"))
#'   
#'   # Generate a boilerplate schema
#'   schema <- document_schema()
#'   
#'   # Save the schema to a file
#'   document_schema(list(id = 1, name = "Alice"), save_to = "user_schema.json")
#' }
#' @export
document_schema <- function(r_object = NULL, save_to = NULL) {
  # Generate a boilerplate schema template
  generate_boilerplate_schema <- function() {
    list(
      "$schema" = "http://json-schema.org/draft-07/schema#",
      "title" = "Example Schema",
      "type" = "object",
      "properties" = list(
        example_field = list(
          type = "string",
          description = "An example field"
        )
      ),
      "required" = c("example_field")
    )
  }
  
  # Derive schema from an R object
  derive_schema_from_object <- function(obj) {
    schema <- list(
      "$schema" = "http://json-schema.org/draft-07/schema#",
      "title" = "Generated Schema",
      "type" = "object",
      "properties" = list()
    )
    
    for (field in names(obj)) {
      value <- obj[[field]]
      field_type <- switch(
        class(value)[1],
        numeric = "number",
        integer = "integer",
        character = "string",
        logical = "boolean",
        list = "array",
        "object" # Default
      )
      schema$properties[[field]] <- list(type = field_type)
    }
    
    schema$required <- names(obj) # Mark all fields as required
    return(schema)
  }
  
  # Generate schema
  schema <- if (is.null(r_object)) {
    generate_boilerplate_schema()
  } else {
    derive_schema_from_object(r_object)
  }
  
  # Save to file if specified
  if (!is.null(save_to)) {
    jsonlite::write_json(schema, save_to, pretty = TRUE, auto_unbox = TRUE)
    message("Schema saved to: ", save_to)
    return(invisible(schema))
  }
  
  # Return the schema as a list
  return(schema)
}

#' Load a JSON Schema
#'
#' Loads a JSON schema from the package's `inst/schemas/` directory.
#'
#' @param schema_file_name A string representing the name of the JSON schema file (e.g., "user_schema.json").
#' @param package The name of the package containing the schema. Defaults to `"PIFDataModel"`.
#' @return A list representing the schema.
#' @source <https://github.com/fsqanalytics/PIFDataModel/blob/main/inst/schemas/user_schema.json>
#' @examples
#' library(PIFDataModel)
#' my_schema <- load_json_schema(schema_file_name = "user_schema.json")
#' print(my_schema)
#' @importFrom jsonlite fromJSON
#' @export
load_json_schema <- function(schema_file_name, package = "PIFDataModel") {
  # Construct the full path to the schema file within the package.
  schema_file_path <- system.file("schemas", schema_file_name, package = package)
  
  # Check if the file exists.
  if (!file.exists(schema_file_path)) {
    stop(paste("JSON schema file not found:", schema_file_path))
  }
  
  # Read the schema file using jsonlite::fromJSON.
  schema <- jsonlite::fromJSON(schema_file_path)
  
  # Add metadata as attributes (optional, but useful).
  attr(schema, "schema_name") <- schema_file_name
  attr(schema, "schema_path") <- schema_file_path
  
  return(schema)
}

#' Display JSON Schema
#'
#' Loads and displays a JSON schema from the package.
#' @param schema_file Path to the JSON schema file (relative to `inst/json_schemas`).
#' @return A character string with formatted JSON.
#' @export
display_json_schema <- function(schema_file) {
  schema_path <- system.file("schemas", schema_file, package = "PIFDataModel")
  if (!file.exists(schema_path)) {
    stop("Schema file not found: ", schema_file)
  }
  json <- jsonlite::prettify(readLines(schema_path, warn = FALSE))
  cat(json)
}

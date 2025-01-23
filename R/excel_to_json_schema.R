#' Generate a JSON Schema from an Excel File
#'
#' This function reads an Excel file and generates a JSON schema based on its structure.
#' The schema includes column names and inferred data types.
#'
#' @param excel_file A character string specifying the path to the Excel file.
#' @param sheet_name A character string or numeric value specifying the sheet to read.
#'  Defaults to `1` (the first sheet).
#' @param json_file An optional character string specifying the path to save the JSON schema file.
#'  If `NULL`, the schema is returned as a string. Defaults to `NULL`.
#'
#' @return If `json_file` is `NULL`, returns a JSON-formatted schema string. 
#' If `json_file` is provided, the schema is saved to the file, and a message is printed indicating the file location.
#' @importFrom readxl read_excel
#' @importFrom jsonlite toJSON
#' @examples
#' \dontrun{
#' # Generate a JSON schema from the first sheet of "my_excel_file.xlsx"
#' schema <- excel_to_json_schema("my_excel_file.xlsx")
#' print(schema)
#'
#' # Save the JSON schema to a file
#' excel_to_json_schema("my_excel_file.xlsx", json_file = "schema.json")
#' }
#' @export
excel_to_json_schema <- function(excel_file, sheet_name = 1, json_file = NULL) {
  # Read the Excel file to get column structure
  df <- read_excel(excel_file, sheet = sheet_name, n_max = 1)
  
  # Infer column data types
  types <- sapply(df, function(col) {
    if (is.numeric(col)) return("number")
    if (is.character(col)) return("string")
    if (is.logical(col)) return("boolean")
    if (inherits(col, "Date") || inherits(col, "POSIXt")) return("string") # Dates as ISO strings
    return("string") # Default to string for unsupported types
  })
  
  # Construct JSON schema
  schema <- list(
    title = "Excel Sheet Schema",
    type = "object",
    properties = lapply(names(types), function(name) {
      list(
        type = types[name],
        description = paste("Field for column:", name)
      )
    })
  )
  names(schema$properties) <- names(types)
  
  # Convert the schema to JSON
  json_schema <- toJSON(schema, pretty = TRUE, auto_unbox = TRUE)
  
  # If a JSON file name is provided, save the JSON schema to a file
  if (!is.null(json_file)) {
    write(json_schema, file = json_file)
    message(paste("JSON schema saved to:", json_file))
  } else {
    # Otherwise, return the JSON schema
    return(json_schema)
  }
}

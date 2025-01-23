#' Convert Excel Data to JSON
#'
#' This function reads data from an Excel file and converts it into a JSON format.
#' Optionally, the JSON can be saved to a file.
#'
#' @param excel_file A character string specifying the path to the Excel file.
#' @param sheet_name A character string or numeric value specifying the sheet to read. 
#' Defaults to `1` (the first sheet).
#' @param json_file An optional character string specifying the path to save the JSON file.
#'  If `NULL`, the function returns the JSON as a string. Defaults to `NULL`.
#'
#' @return If `json_file` is `NULL`, returns a JSON-formatted string. If `json_file` is provided, the JSON is saved to the file, and a message is printed indicating the file location.
#' @importFrom readxl read_excel
#' @importFrom jsonlite toJSON
#' @examples
#' \dontrun{
#' # Convert the first sheet of "my_excel_file.xlsx" and save to "output.json"
#' excel_to_json("my_excel_file.xlsx", json_file = "output.json")
#'
#' # Convert the first sheet of "my_excel_file.xlsx" to a JSON string
#' json_string <- excel_to_json("my_excel_file.xlsx")
#' print(json_string)
#'
#' # Convert the second sheet of "my_excel_file.xlsx" and save to "output2.json"
#' excel_to_json("my_excel_file.xlsx", sheet_name = "Sheet2", json_file = "output2.json")
#' }
#' @export
excel_to_json <- function(excel_file, sheet_name = 1, json_file = NULL) {
  # Read the Excel file into a data frame
  df <- read_excel(excel_file, sheet = sheet_name)
  
  # Convert the data frame to JSON
  json_data <- toJSON(df, pretty = TRUE)
  
  # If a JSON file name is provided, save the JSON data to a file
  if (!is.null(json_file)) {
    write(json_data, file = json_file)
    message(paste("JSON data saved to:", json_file))
  } else {
    # Otherwise, return the JSON data
    return(json_data)
  }
}

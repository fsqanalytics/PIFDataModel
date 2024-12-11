test_that("load_schema works correctly for valid schema", {
  # Load a valid schema
  schema <- load_schema("user_schema.json")
  
  # Ensure the schema is loaded as a non-null list
  expect_type(schema, "list")
  expect_true(!is.null(schema$title), "Schema should have a 'title' field.")
  
  # Check for the presence of expected keys
  expected_keys <- c("title", "type", "properties")
  missing_keys <- setdiff(expected_keys, names(schema))
  expect_true(length(missing_keys) == 0, paste("Missing keys:", paste(missing_keys, collapse = ", ")))
})

test_that("load_schema throws an error for a non-existent schema", {
  # Dynamically retrieve the available schemas
  schema_dir <- system.file("schemas", package = "PIFDataModel")
  available_schemas <- list.files(schema_dir)
  available_schemas_str <- paste(available_schemas, collapse = ", ")
  
  # Expected error message
  expected_message <- paste(
    "Schema 'non_existent_schema.json' not found.",
    "Available schemas:", available_schemas_str
  )
  
  # Ensure the correct error message is thrown
  expect_error(
    load_schema("non_existent_schema.json"),
    expected_message,
    fixed = TRUE # Ensures the error message is matched literally
  )
})

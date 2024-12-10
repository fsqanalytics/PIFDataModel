test_that("load_schema works correctly", {
  # Load a valid schema
  schema <- load_schema("user_schema.json")
  expect_true(!is.null(schema$title), "Schema should have a 'title' field.")
  
  # Ensure the schema is a list
  expect_type(schema, "list")
  
  # Ensure schema contains expected keys
  expect_true(all(c("title", "type", "properties") %in% names(schema)), "Schema should contain expected keys.")
})


test_that("load_schema throws an error for a non-existent schema", {
  # Match the specific error message
  expect_error(
    load_schema("non_existent_schema.json"),
    "Schema 'non_existent_schema.json' not found. Available schemas: user_schema.json.",
    fixed = TRUE # Use `fixed = TRUE` to match the error message literally
  )
})

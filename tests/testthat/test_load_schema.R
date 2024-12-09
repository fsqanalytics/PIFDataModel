test_that("load_schema works correctly", {
  # Load a valid schema
  schema <- load_schema("user_schema.json")
  expect_true(!is.null(schema$title))
  
  # Attempt to load a non-existent schema
  expect_error(load_schema("non_existent_schema.json"), "Schema not found")
})

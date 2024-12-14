test_that("Schema is loaded correctly", {
  schema <- load_json_schema(schema_file_name = "user_schema.json", package = "PIFDataModel")
  expect_true(is.list(schema)) # Check if the result is a list
  expect_equal(attr(schema, "schema_name"), "user_schema.json") # Check metadata
  expect_match(attr(schema, "schema_path"), "user_schema.json") # Check path
})

test_that("Missing schema file throws an error", {
  expect_error(load_json_schema(schema_file_name = "nonexistent.json", package = "PIFDataModel"))
})

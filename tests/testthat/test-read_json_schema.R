test_that("read_json_schema works correctly", {
  # Path to the test schema
  schema_path <- system.file("schemas/user_schema.json", package = "PIFDataModel")
  
  # Read the schema
  schema <- read_json_schema(schema_path)
  
  # Check if the schema is a list
  expect_true(is.list(schema))
  
  # Verify key elements in the schema
  expect_equal(schema$title, "User object")
  expect_equal(schema$type, "object")
  expect_true("properties" %in% names(schema))
})

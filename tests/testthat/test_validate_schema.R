# tests/testthat/test_validate_schema.R

test_that("Validation works correctly", {
  # JSON data as a string
  json_data <- '{"id": 1, "name": "Alice"}'
  expect_true(validate_schema(json_data, "user_schema.json"))
  
  # JSON data as an R object
  json_data_object <- list(id = 1, name = "Alice")
  expect_true(validate_schema(json_data_object, "user_schema.json"))
  
  # Invalid data
  invalid_json_data <- '{"id": "invalid", "name": "Alice"}'
  expect_error(validate_schema(invalid_json_data, "user_schema.json"), "Validation failed")
})

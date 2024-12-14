test_that("person_schema reads the schema correctly", {
  schema <- person_json_schema()
  
  # Check that the schema is a non-empty character string
  expect_type(schema, "character")
  expect_true(nchar(schema) > 0)
  
  # Verify some key elements in the schema
  expect_true(grepl('"name"', schema))
  expect_true(grepl('"age"', schema))
})

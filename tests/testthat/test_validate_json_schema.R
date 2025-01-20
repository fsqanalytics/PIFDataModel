library(testthat)
library(jsonlite)

test_that("validate_json_schema validates correctly", {
  # Define paths to the schema and JSON files
  schema_file <- tempfile(fileext = ".json")
  json_file_valid <- tempfile(fileext = ".json")
  json_file_invalid <- tempfile(fileext = ".json")
  
  # Write schema to a temporary file
  schema_content <- '{
    "$schema": "https://json-schema.org/draft/2020-12/schema",
    "$id": "https://github.com/fsqanalytics/PIFDataModel/docs/articles/schemas/bacteria_count_schema.json",
    "type": "object",
    "properties": {
        "SampleWEnum": { "type": "number" },
        "LoQ": { "type": "number" },
        "GreaterLoQ": { "type": "number" },
        "LowerLoQ": { "type": "number" },
        "MeanConc": { "type": "number" },
        "CountsModel": { 
            "type": "string",
            "enum": ["Impute", "PosCounts"]
        }
    },
    "additionalProperties": false,
    "required": ["SampleWEnum", "LoQ", "GreaterLoQ", "LowerLoQ"],
    "if": {
        "properties": {
            "MeanConc": { "type": "number" }
        },
        "required": ["MeanConc"]
    },
    "then": {
        "required": ["CountsModel"]
    },
    "else": {
        "not": { "required": ["CountsModel"] }
    }
  }'
  write(schema_content, schema_file)
  
  # Write valid JSON to a temporary file
  valid_json <- '{
    "SampleWEnum": 1,
    "LoQ": 2,
    "GreaterLoQ": 3,
    "LowerLoQ": 4,
    "MeanConc": 5,
    "CountsModel": "Impute"
  }'
  write(valid_json, json_file_valid)
  
  # Write invalid JSON to a temporary file
  invalid_json <- '{
    "SampleWEnum": 1,
    "LoQ": 2,
    "GreaterLoQ": 3,
    "LowerLoQ": 4,
    "CountsModel": "Impute"
  }'
  write(invalid_json, json_file_invalid)
  
  # Run validation on valid JSON (should return TRUE or pass)
  expect_silent({
    validate_json_schema(schema_file, json_file_valid)
  })
  
  # Run validation on invalid JSON (should return FALSE or throw an error)
  expect_error({
    validate_json_schema(schema_file, json_file_invalid)
  }, "Schema validation failed")
})
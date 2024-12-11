
<!-- README.md is generated from README.Rmd. Please edit that file -->

# PIFDataModel

The `PIFDataModel` package
(<https://github.com/fsqanalytics/PIFDataModel.git>) helps manage and
document JSON schemas in R. It supports loading, validating, and
generating documentation for JSON schemas.

## Installation

``` r
# Install development version
devtools::install_github("fsqanalytics/PIFDataModel")
```

## Usage

``` r
library(PIFDataModel)
```

### Load a schema

``` r
# Assuming the package is installed and `inst/schemas/` contains `user_schema.json`
schema <- load_schema("user_schema.json")
print(schema)
#> $`$schema`
#> [1] "http://json-schema.org/draft-07/schema#"
#> 
#> $`$id`
#> [1] "User"
#> 
#> $title
#> [1] "User object"
#> 
#> $description
#> [1] "A user object for demonstration purposes."
#> 
#> $type
#> [1] "object"
#> 
#> $properties
#> $properties$id
#> $properties$id$type
#> [1] "integer"
#> 
#> $properties$id$minimum
#> [1] 1
#> 
#> $properties$id$description
#> [1] "The unique identifier for a user."
#> 
#> 
#> $properties$name
#> $properties$name$type
#> [1] "string"
#> 
#> $properties$name$minLength
#> [1] 1
#> 
#> $properties$name$maxLength
#> [1] 255
#> 
#> $properties$name$description
#> [1] "The user's name."
#> 
#> 
#> $properties$email
#> $properties$email$type
#> [1] "string"
#> 
#> $properties$email$format
#> [1] "email"
#> 
#> $properties$email$description
#> [1] "The user's email address."
#> 
#> $properties$email$default
#> [1] ""
#> 
#> 
#> 
#> $required
#> [1] "id"   "name"
#> 
#> $additionalProperties
#> [1] FALSE
#> 
#> $examples
#>   id  name             email
#> 1  1 Alice alice@example.com
#> 2  2   Bob              <NA>
#> 
#> attr(,"schema_name")
#> [1] "user_schema.json"
#> attr(,"schema_path")
#> [1] "/home/vcadavez/R/x86_64-pc-linux-gnu-library/4.3/PIFDataModel/schemas/user_schema.json"
```

### Validate JSON data

- Success

``` r
json_data <- list(id = 1, name = "Alice")
validate_schema(json_data, "user_schema.json")
#> [1] TRUE
# [1] TRUE
```

- Failure

``` r
#json_data <- list(id = "not_numeric", name = "Alice")
#validate_schema(json_data, "user_schema.json", verbose = TRUE)
# Error: Validation failed. Check the JSON data and schema for compatibility.
```

### Generate documentation

``` r
schema <- document_schema()
print(schema)
#> $`$schema`
#> [1] "http://json-schema.org/draft-07/schema#"
#> 
#> $title
#> [1] "Example Schema"
#> 
#> $type
#> [1] "object"
#> 
#> $properties
#> $properties$example_field
#> $properties$example_field$type
#> [1] "string"
#> 
#> $properties$example_field$description
#> [1] "An example field"
#> 
#> 
#> 
#> $required
#> [1] "example_field"
```

### Table

# JSON Schemas

The following JSON schemas are available:

| Schema Name | Description | Link |
|----|----|----|
| Person Schema | Defines a person structure | [View Schema](schemas/person_schema.json) |
| User Schema | Defines an user structure | [View Schema](schemas/user_schema.json) |

You can click the links to view the raw JSON files.

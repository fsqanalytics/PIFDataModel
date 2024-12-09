
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
schema <- load_schema("user_schema.json")
```

### Validate JSON data

``` r
json_data <- '{"id": 1, "name": "Alice", "email": "alice@example.com"}'
validate_schema(json_data, "user_schema.json")

### Generate documentation
```

``` r
document_schema("user_schema.json")
```

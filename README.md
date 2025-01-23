
<!-- README.md is generated from README.Rmd. Please edit that file -->

# PIFDataModel: Simplifying Structured Data Management for Pathogens in Food Database

## Overview

The **PIFDataModel** R package is an integral component of the Pathogens
in Foods Database Project [(PIF:
https://pif.esa.ipb.pt/)](https://pif.esa.ipb.pt/), a comprehensive
initiative to facilitate the sharing, analysis, and usage of structured
data and JSON schemas related to the **PIF** Database. This package is
designed to support researchers, food safety professionals, and
decision-makers in accessing and working with well-structured datasets
and schemas for analyzing data on foodborne pathogens.

## Key Features

- **Access Predefined Schemas:** Includes predefined JSON schemas for
  organizing and validating data, such as bacteria count data.
- **Validation Tools:** Provides tools to validate JSON data against
  schemas (future development).
- **Data Management:** Simplifies the integration of structured data
  into R workflows.
- **Documentation and Resources:** Offers extensive documentation to
  facilitate the use of JSON schemas in research projects.

## Installation

Install the development version of **PIFDataModel** directly from
GitHub:

``` r
# Install the remotes package if not already installed
install.packages("remotes")

# Install the PIFDataModel package from GitHub
remotes::install_github("fsqanalytics/PIFDataModel")
```

## Usage Example

Here is a quick example of how to load and use a schema in the
**PIFDataModel** package:

``` r
# Load the PIFDataModel package
library(PIFDataModel)

# Load a predefined schema
bacteria_schema <- jsonlite::read_json("./schemas/bacteria_count_schema.json")

# Print the schema
print(bacteria_schema)
```

## Contributing

Contributions are welcome! If you’d like to contribute to the
development of this package, please visit the [GitHub
repository](https://github.com/fsqanalytics/PIFDataModel) to create
issues or submit pull requests.

## Acknowledgments

The [PIF Database](https://pif.esa.ipb.pt/) and the
[PIFDataModel](https://github.com/fsqanalytics/PIFDataModel) package are
developed as part of a research project funded by the [European Food
Safety Authority (EFSA)](https://www.efsa.europa.eu/en). We extend our
gratitude to all contributors and collaborators who have supported this
initiative.

For more information about the project, please read the paper:
<span style="color:blue">Gonzales-Barron et al.
([2025](#ref-Gonzales-BarronMRA2025))</span>.

## References

<div id="refs" class="references csl-bib-body hanging-indent"
entry-spacing="0" line-spacing="2">

<div id="ref-Gonzales-BarronMRA2025" class="csl-entry">

Gonzales-Barron, U., Faria, A. S., Thebault, A., Guillier, L., Mendes,
L. R., Silva, L. R., Messens, W., Kooh, P., & Cadavez, V. (2025).
[Pathogens-in-foods (PIF): An open-access european database of
occurrence data of biological hazards in foods](). *Microbial Risk
Analysis*, *Submited*.

</div>

</div>

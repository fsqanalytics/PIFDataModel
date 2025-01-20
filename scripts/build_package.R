# Automated R Package Development Script

# Load required libraries
if (!requireNamespace("devtools", quietly = TRUE)) install.packages("devtools")
if (!requireNamespace("pkgdown", quietly = TRUE)) install.packages("pkgdown")

library(devtools)
library(pkgdown)

# Main script
build_package <- function() {
  cat("Starting package development workflow...\n")
  
  tryCatch({
    cat("1. Loading all functions...\n")
    devtools::load_all()
    
    cat("2. Documenting functions...\n")
    devtools::document()
    
    cat("3. Running tests...\n")
    devtools::test()
    
    cat("4. Checking the package...\n")
    devtools::check()
    
    cat("5. Building the package...\n")
    devtools::build()
    
    cat("6. Installing the package...\n")
    devtools::install()
    
    cat("7. Building the manual...\n")
    devtools::build_manual()
    
    cat("8. Building vignettes...\n")
    devtools::build_vignettes()
    
    cat("9. Building the site with pkgdown...\n")
    pkgdown::build_site()
    
    cat("Package development workflow completed successfully.\n")
  }, error = function(e) {
    cat("An error occurred: ", e$message, "\n")
  })
}

# Run the workflow
build_package()
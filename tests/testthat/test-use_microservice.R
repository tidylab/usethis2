context("unit test for use_microservice")

# Setup -------------------------------------------------------------------
testthat::setup({
    assign("test_env", testthat::test_env(), envir = parent.frame())
    create_package(test_wd)
    withr::local_dir(test_wd, .local_envir = test_env)
    test_env$entrypoint <- "plumber"
    test_env$endpoint <- "RESTful-API"
})

# Tests -------------------------------------------------------------------
test_that("create an R script", {
    attach(test_env)

    expect_null(use_microservice(entrypoint, endpoint))

    file_path <- file.path(test_wd, "inst", "entrypoints", paste0(entrypoint, "-foreground.R"))
    expect_file_exists(file_path)
    file_content <- readLines(file_path)
    expect_match(file_content, endpoint)

    file_path <- file.path(test_wd, "inst", "entrypoints", paste0(entrypoint, "-background.R"))
    expect_file_exists(file_path)
    file_content <- readLines(file_path)
    expect_match(file_content, entrypoint)

    file_path <- file.path(test_wd, "inst", "endpoints", paste0(endpoint, ".R"))
    expect_file_exists(file_path)
    file_content <- readLines(file_path)
    expect_match(file_content, "healthcheck")
    expect_match(file_content, "class")
})

test_that("add suggested packages to DESCRIPTION", {
    attach(test_env)

    file_path <- file.path(test_wd, "DESCRIPTION")
    expect_file_exists(file_path)

    file_content <- readLines(file_path)
    expect_match(file_content, "plumber")
    expect_match(file_content, "httptest")
})

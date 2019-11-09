library(purrr)

# ------------------------------------------- REFERENCE
# functions
get_id <- function(x){
  gsub("\\.md", "", x)
}

get_name <- function(x){
  x <- gsub("\\_", " ", x)
  gsub("\\.md", "", x)
}

# directory of .Rd
dir <- "../man"

# read .Rd
files <- list.files(dir)
files <- files[grepl("\\.Rd", files)]

docs <- purrr::map(files, function(x){
  input <- paste0(dir, "/", x)
  nm <- gsub("\\.Rd", ".md", x)
  output <- paste0("./docs/", nm)
  Rd2md::Rd2markdown(input, output)
  list(name = nm, output = output)
})

# add yaml
purrr::map(docs, function(x){
  yaml <- c(
    "---",
    paste0("id: ", get_id(x$name)),
    paste0("title: ", tools::toTitleCase(get_name(x$name))),
    paste0("sidebar_label: ", tools::toTitleCase(get_name(x$name))),
    "---",
    ""
  )
  file <- readLines(x$output)
  file <- file[-c(1:5)]
  file <- gsub("Seealso", "See Also", file)
  file <- c(yaml, file)
  fileConn <- file(x$output)
  writeLines(file, fileConn)
  close(fileConn)
})

# sidebar json: add functions
fl <- "./website/sidebars.json"
json <- jsonlite::read_json(fl)

json_functions <- purrr::map(docs, "name") %>% 
  purrr::map(get_id) 

json$docs$Docs <- json_functions

jsonlite::write_json(json, path = fl, pretty = TRUE, auto_unbox = TRUE)

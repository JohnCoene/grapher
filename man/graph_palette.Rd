% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/scale.R
\name{graph_palette}
\alias{graph_palette}
\alias{graph_palette_light}
\title{Color Palettes}
\usage{
graph_palette()

graph_palette_light()
}
\value{
A vector of hex colors.
}
\description{
Bright and light color palettes for examples and defaults.
}
\examples{
# preview_palettes
graph_palette()
graph_palette_light()

graph_data <- make_data(200)

graph_data \%>\% 
  graph() \%>\% 
  graph_cluster() \%>\% 
  scale_link_color(cluster, palette = graph_palette_light())

}

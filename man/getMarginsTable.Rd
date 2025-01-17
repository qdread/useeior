% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/IOFunctions.R
\name{getMarginsTable}
\alias{getMarginsTable}
\title{Generate Margins table using either Industry Margins (BEA Margins) or Final Consumer Margins (BEA PCE and PEQ Bridge data).}
\usage{
getMarginsTable(specs, marginsource)
}
\arguments{
\item{specs}{Model specifications.}

\item{marginsource}{A character indicating the source of Margins, either "Industry" or "FinalConsumer".}
}
\value{
A dataframe containing PRO/PUR ratios for Detail BEA sectors.
}
\description{
Generate Margins table using either Industry Margins (BEA Margins) or Final Consumer Margins (BEA PCE and PEQ Bridge data).
}

#' Format a dataframe having IO table structure (with just sector code in row and column names) for IOMB process.
#' Change row and column names of the dataframe to "code/names/locationcode".
#' @param IOtable The dataframe, having IO table structure with just sector code, to be formatted.
#' @return A dataframe, having IO table structure, with row and column names from "code" to "code/names/locationcode".
formatIOTableforIOMB <- function (IOtable, model) {
  # Load pre-saved IndustryCodeName and CommodityCodeName tables
  IndustryCodeName <- get(paste(model$specs$BaseIOLevel, "IndustryCodeName", model$specs$BaseIOSchema), sep = "_")
  colnames(IndustryCodeName) <- c("Code", "Name")
  CommodityCodeName <- get(paste(model$specs$BaseIOLevel, "CommodityCodeName", model$specs$BaseIOSchema), sep = "_")
  colnames(CommodityCodeName) <- c("Code", "Name")
  # Modify IOtable row and column names based on table type
  # Use "S00401 Scrap" or "Used" to determine rowname is Commodity or Industry
  if ("S00401" %in% rownames(IOtable) == TRUE | "Used" %in% rownames(IOtable) == TRUE) {
    # Row name is Commodity
    CommodityCodeName <- CommodityCodeName[CommodityCodeName$Code%in%rownames(IOtable), ]
    CommodityCodeName <- CommodityCodeName[order(factor(CommodityCodeName$Code, levels = rownames(IOtable))), ]
    rownames(IOtable) <- tolower(paste(rownames(IOtable), CommodityCodeName[, 2], "US", sep = "/"))
    # Column name is Industry
    IndustryCodeName <- IndustryCodeName[IndustryCodeName$Code%in%colnames(IOtable), ]
    IndustryCodeName <- IndustryCodeName[order(factor(IndustryCodeName$Code, levels = colnames(IOtable))), ]
    colnames(IOtable) <- tolower(paste(colnames(IOtable), IndustryCodeName[, 2], "US", sep = "/"))
  } else {
    # Row name is Industry
    IndustryCodeName <- IndustryCodeName[IndustryCodeName$Code%in%rownames(IOtable), ]
    IndustryCodeName <- IndustryCodeName[order(factor(IndustryCodeName$Code, levels = rownames(IOtable))), ]
    rownames(IOtable) <- tolower(paste(rownames(IOtable), IndustryCodeName[, 2], "US", sep = "/"))
    # Column name is Commodity
    CommodityCodeName <- CommodityCodeName[CommodityCodeName$Code%in%colnames(IOtable), ]
    CommodityCodeName <- CommodityCodeName[order(factor(CommodityCodeName$Code, levels = colnames(IOtable))), ]
    colnames(IOtable) <- tolower(paste(colnames(IOtable), CommodityCodeName[, 2], "US", sep = "/"))
  }
  # Need code here to format state IO tables

  return(IOtable)
}

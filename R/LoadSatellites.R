#' Load satellite tables in a list based on model.
#' @param model Configuration of the model.
#' @return A list with satellite tables.
loadsattables <- function(model){
  sattables <- list()
  logging::loginfo("Initializing model satellite tables...")

  for (sat in model$specs$SatelliteTable) {
    logging::loginfo(paste("Adding model satellite tables..."))
    #Check if its the table uses a static file..if so proceed
    if(!is.null(sat$StaticFile)) {
      sattable <- utils::read.table(system.file("extdata", sat$StaticFile, package = "useeior"),
                                    sep = ",", header = TRUE, stringsAsFactors = FALSE)
      #If BEA based
      if (sat$SectorListSource == "BEA") {
        #If BEA years is not the same as model year, must perform allocation
        if (sat$SectorListYear == 2007 && model$specs$BaseIOSchema == 2012) {
          #apply allocation
        } else if (sat$SectorListLevel == "Detail" && model$specs$BaseIOLevel != "Detail") {
          sattable <- aggregateSatelliteTable(sattable, sat$SectorListLevel, model$specs$BaseIOLevel, model)
        }
      } else {
        #In NAICS #
      }
      #split table based on data years
      if (length(sat$DataYears)>1) {
        print("more than 1 data year")
      }
      #Split table based on regions
      sattablecoeffs <- data.frame()
      for (r in model$specs$ModelRegionAcronyms) {
        sattable_r <- sattable[sattable$Location==r, ]
        if (r=="RoUS") {
          IsRoUS <- TRUE
        } else {
          IsRoUS <- FALSE
          #Change label to location
          if (model$specs$ModelType=="state") {
            sattable_r[, "Location"] <- paste("US-", r, sep = "")
          }
        }
        sattablecoeffs_r <- generateFlowtoDollarCoefficient(sattable_r, sat$DataYears[1], model$specs$ReferenceCurrencyYear, r, IsRoUS=IsRoUS, model)
        sattablecoeffs <- rbind(sattablecoeffs,sattablecoeffs_r)
      }
      #Need to have sector name
      sattablecoeffs$SectorName <- NULL
      sattablecoeffs_withsectors <- merge(sattablecoeffs, model$SectorNames, by = "SectorCode")#, all.x = TRUE)
      #!temp set DQ technological
      sattablecoeffs_withsectors$DQTechnological <- 5

      sattablestandardized <- generateStandardSatelliteTable(sattablecoeffs_withsectors, mapbyname = TRUE, sat)
    } else {
      #Source is dynamic
      source(sat$ScriptSource)
      func_to_eval <- sat$ScriptFunctionCall
      satgenfunction <- as.name(func_to_eval)
      sattablestandardized <- do.call(eval(satgenfunction), sat$ScriptFunctionParameters)
    }
    #append it to list
    sattables[[sat$Abbreviation]] <- sattablestandardized
  }
  return(sattables)
}

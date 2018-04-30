library(ncdf4)
library(REddyProc)
library(httr)

#' Conversion Function - converts data in Tovi NetCDF file into dataframe for REddyProc
#' @param filePath is a character file path to a netcdf file
#' @return dataframe
#' @export

netCDFToREddyProcDF <- function(x) {
  if(!requireNamespace("ncdf4", quietly=TRUE)) {
    stop("Package 'ncdf4' required in this function.  Please install it.")
  }
  if(!requireNamespace("REddyProc", quietly=TRUE)) {
    stop("Package 'REddyProc' required in this function.  Please install it.")
  }
  reddyProcMap = list(
    H="H", LE="LE", FCO2="NEE", TA="Tair", USTAR="Ustar",
    RH="rH", SW_IN="Rg", TA="Tair", TS="Tsoil")

  if (is.character(x)) {
    df <- netCDFToDF(filePath)
  }
  if (is.data.frame(x)) {
    df <- x
  }
  # look for REddyProc variables in dataframe, build a list of those that are present
  # and rename them where needed, afterwards subset only the REddyProc variables
  reddyProcVariables = c()
  for (variable in names(df)) {
    if (variable == 'DateTime') {
      reddyProcVariables <- c(reddyProcVariables, variable)
    } else {
      variableName <- sub("(_\\d){3}$", "", variable)
      if (variableName %in% names(reddyProcMap)) {
        rEddyProcName <- reddyProcMap[[variableName]]
        reddyProcVariables <- c(reddyProcVariables, rEddyProcName)
        names(df)[names(df) == variable] <- rEddyProcName
      }
    }
  }

  df <- df[,reddyProcVariables]

  # if contains TA or TS convert from K to C
  hasTA <- 'Tair' %in% names(df)
  hasTS <- 'Tsoil' %in% names(df)

  if (hasTA) {
    df$Tair <- df$Tair - 273
  }

  if (hasTS) {
    df$Tsoil <- df$Tsoil - 273
  }

  #Check to see if VPD is in data
  hasRH <- 'rH' %in% names(df)
  hasVPD <- 'VPD' %in% names(df)
  if (!hasVPD && hasRH && hasTA) {
    df$VPD <- fCalcVPDfromRHandTair(df$rH, df$Tair)
  }

  return (df)
}


#' Conversion Function - converts data in Tovi NetCDF file into dataframe
#' @param filePath is a character file path to a netcdf file
#' @return dataframe
#' @export

netCDFToDF <- function(filePath) {
  if(!requireNamespace("ncdf4", quietly=TRUE)) {
    stop("Package 'ncdf4' required in this function.  Please install it.")
  }

  ncdata <- nc_open(filePath)
  ncVariables = list()
  for (variable in attributes(ncdata$var)$names) {
    nameParts <- unlist(strsplit(variable, '/'))
    if (length(nameParts) == 2) {
      variableName <- nameParts[length(nameParts)]
      ncVariables[[variableName]] <- ncvar_get(ncdata, variable)
    }
  }

  timeStep <- ncatt_get(ncdata, 0, "time_step")
  startDate <- ncatt_get(ncdata, 0, "full_output_start_date")
  if (!startDate$hasatt) {
    startDate <- ncatt_get(ncdata, 0, "biomet_start_date")
    if (!startDate$hasatt) {
      stop("NetCDF file is has neither full_output_start_date or biomet_start_date")
    }
  }

  if (!timeStep$hasatt) {
    stop("NetCDF file is does not indicate time_step")
  }

  df <- as.data.frame(ncVariables, stringsAsFactors=F)
  tsInSeconds <- as.numeric(timeStep$value) * 60
  df$DateTime <- as.POSIXct(startDate$value) + (tsInSeconds * (ncdata$dim$time$vals - 1))
  nc_close(ncdata)

  return(df)
}


#' Conversion Function - converts data in Tovi NetCDF file into dataframe for REddyProc
#' @param df a dataframe
#' @param siteName a site name
#' @return REddyProcClass
#' @export

dfToREddyProcClass <- function(df, siteName="US-LICOR") {
  columns <- names(df)[!names(df) %in% c('DateTime')]
  eddyProc <- sEddyProc$new(siteName, df, columns)
  return(eddyProc)
}


fetchToviDataFilePath <- function(dataFileId) {
  if(!requireNamespace("httr", quietly=TRUE)) {
    stop("Package 'httr' required in this function.  Please install it.")
  }
  url <- paste("http://localhost:8000/data_files/", dataFileId, "/?excludeData=true&includeAbsFiles=true", sep="")
  response <- GET(url)
  if (!status_code(response) == 200) {
    stop("Failed request for datafile")
  }
  data <- content(response)
  file <- data$absFile
  return(file)
}


getToviDataFrame <- function(dataFileId) {
  filePath <- fetchToviDataFilePath(dataFileId)
  df <- netCDFToDF(filePath)
  return(df)
}

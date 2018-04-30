library(jug)
library(rjson)
library(RTovi)

args <- commandArgs(trailingOnly=TRUE)
cat(args, sep = "\n")

if (print (length(args)) == 0) {
  stop("Need to pass a port argument")
}

port <- as.integer(args[1])

jug() %>%
  cors() %>%

  get("/test", function(req, res, err){
    toJSON(list(message="success"))
  }) %>%

  get("/echoname/(?<name>.*)", function(req, res, err){
    req$params$name
  }) %>%

  get("/netcdf", function(req, res, err){
    filePath <- req$params$filePath
    if (file.exists(filePath)) {
      #print(serializeJSON(netCDFToREddyProcDF(filePath)))
      toJSON(netCDFToREddyProcDF(filePath))
      #print(head(netCDFToREddyProcDF(filePath)))
    } else {
      toJSON(list(message=paste("File Does not Exist ", req$params$filePath)))
    }
  }) %>%

  simple_error_handler_json() %>%
  serve_it(verbose=TRUE, port=port)

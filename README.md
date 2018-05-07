# RTovi
R package for transforming and shuttling data between Tovi and other R packages

### Installation

RTovi does not reside on CRAN as of this writing.  It may in the future.  In order to install RTovi you need to install the source distribution [RTovi_0.1.0.tar.gz](https://github.com/LI-COR/RTovi/blob/master/RTovi/RTovi_0.1.0.tar.gz).  However, you must also install its dependencies before installing RTovi.

Example installation commands to be ran in R interpreter.

```
> install.packages(c('REddyProc', 'ncdf4', 'httr'))
> install.packages('path/to/RTovi_0.1.0.tar.gz', repos=NULL, type='source')
```

### Basic Usage

With RTovi installed you can view its functions and their documentation using the following.

```
> library(RTovi)
> ls("package:RTovi") # this shows all the functions in the package
[1] "dfToREddyProcClass"    "fetchToviDataFilePath" "getToviDataFrame"     
[4] "netCDFToDF"            "toviDataToREddyProcDF"
> ?netCDFToDF # this shows the documentation for the netCDFToDF function
```

### Examples

Here are some basic examples of using the functions of the RTovi package with data stored in a NetCDF [file](https://github.com/LI-COR/RTovi/blob/master/nc_data.nc).

A. To read the data in a netcdf into a generic dataframe

```
> df <- netCDFToDF("nc_data.nc")
```

B. To convert a generic dataframe into one suitable for usage with REddyProc

```
> rep_df <- toviDataToREddyProcDF(df)
```

C. To convert a generic dataframe to REddyProc class

```
> reddyProc <- dfToREddyProcClass(df)
```

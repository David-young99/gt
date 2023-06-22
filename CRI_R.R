## Load Google Traffic package
library(googletraffic)

## Load additional packages for working with and visualizing data
library(raster)
library(dplyr)
library(sf)



## Set Google API Key
google_key <- "AIzaSyDxJ0OUg3vzg1YakrbDVPJ7zDocoeztPDc"

#Temp folder for automatic temporally files elimination
#temp_folder <- paste0(tempdir(), "/cache_cri", Sys.getpid())
#options(googleAuthR.cache = temp_folder)


#Paths
in_path_shp = file.path("/home/dyoung/gitrepo/gt/Archivo_CA/adm_by_country/")
out_path_shp = file.path("/home/dyoung/outputs/")

country = "CRI"

#Paths
#in_path_shp = file.path("C:\\Users\\XPC\\Desktop\\a\\country_shp\\adm_by_country\\")
#out_path_shp = paste0("C:\\Users\\XPC\\OneDrive - Universidad de Costa Rica\\Personal\\Scripts\\R Studio\\gt\\Output_raster\\")

shp = st_read(paste(in_path_shp, country,".shp",sep = ""))
valid_shp = st_make_valid(shp)

#Internal loop for each adm of each country of the previous list.
for (j in 1:nrow(valid_shp)){
  adm = valid_shp[j, ]
  
  raster_gt <- gt_make_raster_from_polygon(polygon    = adm,
                                           zoom       = 18,
                                           google_key = google_key)
  adm_code = adm$ADM1_PCODE
  
  raster_path <- paste0(out_path_shp, rep(country, length(adm_code)), "//", country, "_", adm_code, ".tif")
  
      writeRaster(raster_gt, raster_path, overwrite=TRUE)
      
}



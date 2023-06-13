## Load Google Traffic package
library(googletraffic)

## Load additional packages for working with and visualizing data
library(raster)
library(dplyr)
library(sf)



## Set Google API Key
google_key <- "AIzaSyDxJ0OUg3vzg1YakrbDVPJ7zDocoeztPDc"

#Temp folder for automatic temporally files elimination
temp_folder = file.path("////tmp/RtmpPE6LtK/")

#Paths
in_path_shp = file.path("/home/dyoung/Github_Reps/googletraffic/Archivo_CA/adm_by_country/")
out_path_shp = file.path("///home/dyoung/outputs/")

country = "GTM"

shp = st_read(paste(in_path_shp, country,".shp",sep = ""))
valid_shp = st_make_valid(shp)

#Internal loop for each adm of each country of the previous list.
for (j in 1:nrow(valid_shp)){
  adm = valid_shp[j, ]
  
  raster_gt <- gt_make_raster_from_polygon(polygon    = adm,
                                           zoom       = 13,
                                           google_key = google_key)
  adm_code = adm$ADM1_PCODE
  
  raster_path <- paste0(out_path_shp, rep(country, length(adm_code)), "//", country, "_", adm_code, ".tif")
  
  tryCatch(
    {
      writeRaster(raster_gt, raster_path, overwrite=TRUE)
      
      # Verificar si el archivo se exportó correctamente
      if (file.exists(raster_path)) {
        cat("File", country,"exported done:", "\n")
        cat("")
        cat("")
        
        
        
        #Delete the files created temporally
        temp_files = list.files(temp_folder, full.names = TRUE, recursive = TRUE)
        file.remove(temp_files)
        unlink(temp_folder, recursive = TRUE)
        
        cat("Temporal files for", country, " was deleted sucessfully to save memory!", "\n")
        cat("")
        cat("")
      } else {
        cat("Error exporting the raster so we can't delete the temporal files", "\n")
        cat("")
        cat("")
      }
    },
    error = function(e)
      cat("Error writing the output raster", e$message, "\n") #Catching possible errors
    
    
  )
}



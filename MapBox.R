## Load packages
#Mapbox is for the API facilities and settings
#Library sf allow to edit, modify, export geospatial files, in this case a GeoJSON or Shapefile
library(mapboxapi)
library(dplyr)
library(sf)


#This sections get the day and time of the current code ejecution, this is for a custom name file save.
current_date = Sys.Date()
day = format(current_date, "%d")

month_num = format(current_date, "%m")
month = month.name[as.integer(month_num)]

year = format(current_date, "%Y")

da_te = paste0(day, "_", month)



## Set API key (This API key must be with the Mapbox account based on the GeoAdaptive google account)
mapbox_key <- "pk.eyJ1IjoiZHlvdW5nOTkiLCJhIjoiY2xqY3Zpaml6MjRsazNxcWcybGk3aGczdiJ9.30a_QLXc7Obxj3Ugx7lJAg"


##Un/comment this path if you are running the code in windows (please change the path for your computer)
  
#input_path = "C:\\Users\\David\\Dropbox (GeoAdaptive)\\2022_INI-04_DEVELOPMENT DASHBOARD\\DOCS\\Project development\\R code\\Traffic Congestion Indicator\\gt\\Archivo_CA\\"
#output_pathyear = paste0("C:\\Users\\David\\Desktop\\test\\", year)
#output_pathdate = paste0(output_pathyear, "\\", da_te)

#output_path = paste0("C:\\Users\\David\\Desktop\\test\\", year,"\\", da_te, "\\")



##Un/comment this path if you are running the code in VM (If you are using the GeoAdaptive GCP Instance do not change)

input_path = "/home/dyoung/gitrepo/gt/Archivo_CA/"
output_pathyear = paste0("/home/dyoung/gitrepo/gt/Ouputs/", year)
output_pathdate = paste0(output_pathyear, da_te)

  
output_path = paste0("/home/dyoung/gitrepo/gt/Ouputs/", year, "/", date, "/")


if (dir.exists(output_pathyear)){
  print("Folder Already exist, jumping creation of the year folder!")
}else{
  dir.create(output_pathyear)
  
  print("New year folder created, ¡Happy new year!")
}

dir.create(da_te)


## Grab shapefile, in this case I'm using just the Central America Shapefile
raw_polygon <- st_read(paste0(input_path, "CA.shp"))
ca_polygon <- st_make_valid(raw_polygon)

## Query traffic data using googletraffic library methods (pay attention to the zoom, this will be the road congestion data detail: more zoom more detail but more processing time)
ca_conf_poly <- get_vector_tiles(      # From here, the code gets the data in tiles for later vector exportation
  tileset_id = "mapbox.mapbox-traffic-v1",
  location = ca_polygon,
  zoom = 7,
  access_token = mapbox_key
)$traffic

## Get from mapbox the data based on the previous settings and the 4 different traffic levels
ca_conf_poly <- ca_conf_poly %>%
  mutate(congestion = congestion %>% 
           tools::toTitleCase() %>%
           factor(levels = c("Low", "Moderate", "Heavy", "Severe")))

## Export to GeoJSON (un-comment in case that you want export in this format)
#st_write(ca_conf_poly, output_path, geojson_test", driver = "GeoJSON", append = TRUE)

## Export to Shapefile
st_write(ca_conf_poly, output_path, paste0("CA_traffTiles_", da_te), driver = "ESRI Shapefile", append = TRUE)

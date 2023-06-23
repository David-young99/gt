## Load package
library(mapboxapi)
library(sf)

## Set API key
mapbox_key <- "pk.eyJ1IjoiZGF2aWR5b3VuZzk5IiwiYSI6ImNsaWFyeHdhMzA1amMzZm41YWVpYTYyemgifQ.NZPJzAEOskXC_UJiyxmosg"


## Grab shapefile of Manhattan
pol <- st_read("C:\\Users\\XPC\\OneDrive - Universidad de Costa Rica\\Personal\\Scripts\\R Studio\\gt\\Archivo_CA\\CA.shp")
ny_sf <- st_make_valid(pol)

## Query traffic data
nyc_cong_poly <- get_vector_tiles(
  tileset_id = "mapbox.mapbox-traffic-v1",
  location = ny_sf,
  zoom = 8,
  access_token = mapbox_key
)$traffic

## Map
nyc_cong_poly <- nyc_cong_poly %>%
  mutate(congestion = congestion %>% 
           tools::toTitleCase() %>%
           factor(levels = c("Low", "Moderate", "Heavy", "Severe")))

## Export to GeoJSON
st_write(nyc_cong_poly, "C:\\Users\\XPC\\OneDrive - Universidad de Costa Rica\\Personal\\Scripts\\R Studio\\gt\\Archivo_CA\\geojson_test", driver = "GeoJSON", append = TRUE)

## Export to Shapefile
st_write(nyc_cong_poly, "C:\\Users\\XPC\\OneDrive - Universidad de Costa Rica\\Personal\\Scripts\\R Studio\\gt\\Archivo_CA\\shp_test", driver = "ESRI Shapefile", append = TRUE)

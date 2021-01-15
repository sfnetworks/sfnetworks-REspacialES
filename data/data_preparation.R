library(dplyr)
library(osmdata)
library(sf)

# Obtain Cuenca city boundary from OSM
# Obtener el límite de la ciudad de Cuenca de OSM
bb = getbb('Cuenca, Ecuador', featuretype = 'city', format_out = 'sf_polygon')

# Download OSM data for Cuenca, with the key=highway
# Descargar datos de OSM para Cuenca con key=highway
cue = opq('Cuenca, Ecuador') %>%
  add_osm_feature(key = 'highway') %>%
  osmdata_sf() %>%
  trim_osmdata(bb)

# Create a LINESTRING sf object with selected columns and correct encoding
# Crear un objeto sf LINESTRINGS con una selección de columnas y corrección
# de codificación
cuenca = cue$osm_lines %>%
  select(name, 'type' = highway, lanes, oneway, sidewalk, surface) %>%
  mutate_if(is.character, .funs = function(x){return(`Encoding<-`(x, "UTF-8"))})

# Obtain example neighborhood polygons
# Obtener polígonos de vecindarios como ejemplos
sagrario = getbb("El Sagrario, Cuenca, Azuay, Ecuador", format_out = "sf_polygon")
sansebas = getbb("San Sebastian, Cuenca, Azuay, Ecuador", format_out = "sf_polygon")
gilramir = getbb("Gil Ramirez Davalos, Cuenca, Azuay, Ecuador", format_out = "sf_polygon")

# Save as .rda file
# Guardar datos como .rda
save(cuenca, gilramir, sagrario, sansebas, file = 'data/cuenca.rda')

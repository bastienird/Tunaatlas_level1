function_overlapped =function(dataset, con, rfmo_to_keep, rfmo_not_to_keep){
  
  overlapping_zone_request <- paste0("SELECT codesource_area,area,wkt from
(WITH rfmo_to_keep_area_of_competence AS (
  SELECT rfmos_convention_areas_fao.geom
  FROM area.rfmos_convention_areas_fao
  WHERE code::text = '",rfmo_to_keep,"'::text
), rfmo_not_to_keep_area_of_competence AS (
  SELECT rfmos_convention_areas_fao.geom
  FROM area.rfmos_convention_areas_fao
  WHERE code::text = '",rfmo_not_to_keep, "'::text
), geom_rfmo_to_keep_rfmo_not_to_keep_intersection AS (
  SELECT st_collectionextract(st_intersection(rfmo_to_keep_area_of_competence.geom, rfmo_not_to_keep_area_of_competence.geom), 3) AS geom
  FROM rfmo_to_keep_area_of_competence,
  rfmo_not_to_keep_area_of_competence
)
  SELECT area_labels.id_area,
  area_labels.codesource_area,
  area_labels.geom,
  st_astext(area_labels.geom) as wkt,
  st_area(area_labels.geom) as area
  FROM area.area_labels,
  geom_rfmo_to_keep_rfmo_not_to_keep_intersection
  WHERE area_labels.tablesource_area = 'cwp_grid'::text AND st_within(area_labels.geom, geom_rfmo_to_keep_rfmo_not_to_keep_intersection.geom))tab 
order by area desc")


overlapping_zone <- dbGetQuery(con, overlapping_zone_request)


assign("overlapping_ancient_method", 
       dataset[ which(!(dataset$geographic_identifier %in% overlapping_zone$codesource_area & 
                          dataset$source_authority == rfmo_not_to_keep)), ], envir = .GlobalEnv)
assign("reverse_overlapping", 
       dataset[ which(!(dataset$geographic_identifier %in% overlapping_zone$codesource_area & dataset$source_authority == rfmo_to_keep)), ],
       envir = .GlobalEnv)

georef_dataset <- dataset %>%
  select(c(-source_authority,-value)) %>%
  distinct() #checking if there are really duplicates for a same strate

if (nrow(georef_dataset)!= nrow(dataset)){
  georef_dataset <- dataset %>%
    group_by(across(c(-source_authority,-value))) %>%
    slice(which.max(value))
} 

# georef_dataset <- dataset %>%
#   group_by(across(c(-source_authority,-value))) %>%
#   arrange(desc(value)) %>%
#   filter(row_number() ==1)

georef_dataset
}

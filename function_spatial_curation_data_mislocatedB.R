spatial_curation_intersect_areasB = function (entity, config, df_input, df_spatial_code_list_name, intersection_spatial_code_list_name) 
{
  con <- config$software$output$dbi
  
  cat(paste0("Please ignore here-under warning messages 'unrecognized PostgreSQL field type unknown'"))
  inputAreas_forQuery <- paste(unique(df_input$geographic_identifier), 
                               collapse = "','")
  db_table_name_inputAreas <- dbGetQuery(con, paste0("SELECT identifier from metadata.metadata where identifier='", 
                                                     df_spatial_code_list_name, "'"))$table_name
  db_table_name_intersectionArea <- dbGetQuery(con, paste0("SELECT identifier from metadata.metadata where identifier='", 
                                                           intersection_spatial_code_list_name, "'"))$table_name
  query_data_inland <- paste("WITH \n                           source_layer AS (\n                           SELECT code, label, geom FROM area.", 
                             df_spatial_code_list_name, " WHERE code IN ('", inputAreas_forQuery, 
                             "')\n                           ),intersection_layer\n                           AS (\n                           SELECT code, label, geom FROM area.", 
                             intersection_spatial_code_list_name, "\n entity,config                          )\n                           SELECT \n                           source_layer.code as geographic_identifier_source_layer,\n                           intersection_layer.code as geographic_identifier_intersection_layer,\n                           '", 
                             df_spatial_code_list_name, "' as codelist_source_layer,\n                           '", 
                             intersection_spatial_code_list_name, "' as codelist_intersection_layer,\n                           ST_Area(ST_Intersection(source_layer.geom, intersection_layer.geom))/ST_Area(source_layer.geom) as proportion_source_area_intersection\n                           FROM \n                           source_layer,intersection_layer\n                           WHERE\n                           ST_Intersects(source_layer.geom, intersection_layer.geom)", 
                             sep = "")
  areas_intersected <- dbGetQuery(con, query_data_inland)
  areas_intersected$geographic_identifier_source_layer <- gsub(" ", 
                                                               "", areas_intersected$geographic_identifier_source_layer, 
                                                               fixed = TRUE)
  df_input <- left_join(df_input, areas_intersected, by = c(geographic_identifier = "geographic_identifier_source_layer"))
  df_input$codelist_source_layer <- NULL
  df_input$codelist_intersection_layer <- NULL
  df_input$proportion_source_area_intersection[which(is.na(df_input$proportion_source_area_intersection))] <- 0
  areas_not_intersected <- setdiff(df_input$geographic_identifier, 
                                   unique(areas_intersected$geographic_identifier_source_layer))
  if (!identical(areas_not_intersected, character(0))) {
    areas_not_intersected <- data.frame(areas_not_intersected)
    colnames(areas_not_intersected) <- "geographic_identifier_source_layer"
    areas_not_intersected$geographic_identifier_source_layer <- as.character(areas_not_intersected$geographic_identifier_source_layer)
    areas_not_intersected$geographic_identifier_intersection_layer <- NA
    areas_not_intersected$codelist_intersection_layer <- intersection_spatial_code_list_name
    areas_not_intersected$proportion_source_area_intersection <- 0
    areas_not_intersected$codelist_source_layer <- df_spatial_code_list_name
  }
  else {
    areas_not_intersected = NULL
  }
  df_input_areas_intersect_intersection_layer <- rbind(areas_intersected, 
                                                       areas_not_intersected)
  df_input_areas_intersect_intersection_layer$geographic_identifier_intersection_layer[which(df_input_areas_intersect_intersection_layer$proportion_intersection == 
                                                                                               0)] <- NA
  return(list(df = df_input, df_input_areas_intersect_intersection_layer = df_input_areas_intersect_intersection_layer))
}

############################

function_spatial_curation_data_mislocatedB = function(entity,config,df,spatial_curation_data_mislocated){
  con <- config$software$output$dbi
  config$logger.info("Reallocating data that are in land areas")
  
  #all the data that are inland or do not have any spatial stratification ("UNK/IND",NA) are dealt (either removed - spatial_curation_data_mislocated=="remove" - or reallocated - spatial_curation_data_mislocated=="reallocate" )
  config$logger.info("Executing rtunaatlas::spatial_curation_intersect_areas")
  #@juldebar => georef_dataset was not set
  georef_dataset <- df
  areas_in_land<-spatial_curation_intersect_areasB(con,georef_dataset,"areas_tuna_rfmos_task2","gshhs_world_coastlines")
  
  areas_in_land<-areas_in_land$df_input_areas_intersect_intersection_layer %>%
    group_by(geographic_identifier_source_layer) %>%
    summarise(percentage_intersection_total=sum(proportion_source_area_intersection))
  
  areas_in_land<-areas_in_land$geographic_identifier_source_layer[which(areas_in_land$percentage_intersection_total==1)]
  
  areas_with_no_spatial_information<-c("UNK/IND",NA)
  
  if (spatial_curation_data_mislocated=="remove"){ # We remove data that is mislocated
    cat("Removing data that are in land areas...\n")
    # remove rows with areas in land
    georef_dataset<-georef_dataset[ which(!(georef_dataset$geographic_identifier %in% c(areas_in_land,areas_with_no_spatial_information))), ]
    
    # fill metadata elements
    lineage<-paste0("Some data might be mislocated: either located on land areas or without any area information. These data were not kept.	Information regarding the reallocation of mislocated data for this dataset: The data that were mislocated represented percentage_of_total_catches_reallocated_weight % of the whole catches expressed in weight in the dataset and percentage_of_total_catches_reallocated_number % of the catches expressed in number. percentage_catches_on_land_reallocated % of the catches that were removed.")
    description<-"- Data located at land or without any spatial information were removed.\n"
    
    cat("Removing data that are in land areas OK\n")
  }
  
  if (spatial_curation_data_mislocated=="reallocate"){   # We reallocate data that ispatial_curation_intersect_areass mislocated (they will be equally distributed on areas with same reallocation_dimensions (month|year|gear|flag|species|schooltype).
    cat("Reallocating data that are in land areas...\n")
    catch_curate_data_mislocated<-rtunaatlas::spatial_curation_function_reallocate_data(df_input = georef_dataset,
                                                                                        dimension_reallocation = "geographic_identifier",
                                                                                        vector_to_reallocate = c(areas_in_land,areas_with_no_spatial_information),
                                                                                        reallocation_dimensions = setdiff(colnames(georef_dataset),c("value","geographic_identifier")))
    georef_dataset<-catch_curate_data_mislocated$df
    
    # fill metadata elements
    lineage<-paste0("Some data might be mislocated: either located on land areas or without any area information. These data were equally redistributed on data at sea on areas with same characteristics (same year, month, gear, flag, species, type of school).	Information regarding the reallocation of mislocated data for this dataset: The data that were mislocated represented percentage_of_total_catches_reallocated_weight % of the whole catches expressed in weight in the dataset and percentage_of_total_catches_reallocated_number % of the catches expressed in number. percentage_catches_on_land_reallocated % of the catches that were mislocated were reallocated on areas at sea.")
    description<-"- Data located at land or without any spatial information were equally redistributed on data at sea in areas described by the same stratification factors, i.e. year, month, gear, flag, species, and type of school.\n"
    
    cat("Reallocating data that are in land areas OK\n")
  }
  
  return(list(dataset=georef_dataset,lineage=lineage,description=description))
  
  
}


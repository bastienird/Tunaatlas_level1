get_rfmos_datasets_level0_B2 = function(rfmo, entity, config, options){
  
  variable <- options$fact
  columns_to_keep <- NULL
  if (variable == "catch"){
    columns_to_keep<-c("source_authority","species","gear","fishingfleet","schooltype","time_start","time_end","geographic_identifier","catchtype","unit","value")
  } else if (variable=="effort"){
    columns_to_keep<-c("source_authority","gear","fishingfleet","schooltype","time_start","time_end","geographic_identifier","unit","value")
  }
  
  #list of dataset files (from entity data sources)
  dataset_files <- sapply(entity$data$source[2:length(entity$data$source)], function(x){ entity$getJobDataResource(config, x) })
  names(dataset_files) <- entity$data$source[2:length(entity$data$source)]
  
  #georeferenced grid datasets
  dataset <- switch(rfmo,
                    #IOTC
                    #--------------------------------------------------------------------------------------
                    "IOTC" = {
                      #For IOTC, only data reading
                      iotc_data <- NULL
                      if(options$include_IOTC){
                        config$logger.info(sprintf("Get %s data", rfmo))
                        dataset_files_iotc <- dataset_files[regexpr("nominal", names(dataset_files)) < 0 & 
                                                              regexpr("iotc", names(dataset_files)) > 0]
                        iotc_data <- do.call("rbind", lapply(dataset_files_iotc, readr::read_csv, guess_max = 0))
                        iotc_data <- as.data.frame(iotc_data)
                        class(iotc_data$value) <- "numeric"
                      }else{
                        config$logger.warn(sprintf("Option include_%s = FALSE. Ignoring data...", rfmo))
                      }
                      iotc_data
                    },
                    #WCPFC
                    #--------------------------------------------------------------------------------------	
                    "WCPFC" = {
                      #For WCPFC, only data reading
                      wcpfc_data <- NULL
                      if(options$include_WCPFC){
                        config$logger.info(sprintf("Get %s data", rfmo))
                        dataset_files_wcpfc <- dataset_files[regexpr("nominal", names(dataset_files)) < 0 & 
                                                               regexpr("wcpfc", names(dataset_files)) > 0]
                        wcpfc_data <- do.call("rbind", lapply(dataset_files_wcpfc, readr::read_csv, guess_max = 0))
                        wcpfc_data <- as.data.frame(wcpfc_data)
                        class(wcpfc_data$value) <- "numeric"
                      }else{
                        config$logger.warn(sprintf("Option include_%s = FALSE. Ignoring data...", rfmo))
                      }
                      wcpfc_data
                    },
                    #CCSBT
                    #--------------------------------------------------------------------------------------
                    "CCSBT" = {
                      #For CCSBT, only data reading
                      ccsbt_data <- NULL
                      if(options$include_CCSBT){
                        config$logger.info(sprintf("Get %s data", rfmo))
                        dataset_files_ccsbt <- dataset_files[regexpr("nominal", names(dataset_files)) < 0 & 
                                                               regexpr("ccsbt", names(dataset_files)) > 0]
                        ccsbt_data <- do.call("rbind", lapply(dataset_files_ccsbt, readr::read_csv, guess_max = 0))
                        ccsbt_data <- as.data.frame(ccsbt_data)
                        class(ccsbt_data$value) <- "numeric"
                      }else{
                        config$logger.warn(sprintf("Option include_%s = FALSE. Ignoring data...", rfmo))
                      }
                      ccsbt_data
                    },
                    #ICCAT
                    #--------------------------------------------------------------------------------------
                    "ICCAT" = {
                      #For ICCAT, some special case, see below
                      iccat_data <- NULL
                      if(options$include_ICCAT){
                        config$logger.info(sprintf("Get %s data", rfmo))
                        dataset_files_iccat <- dataset_files[regexpr("nominal", names(dataset_files)) < 0 & 
                                                               regexpr("byschool", names(dataset_files)) < 0 &
                                                               regexpr("iccat", names(dataset_files)) > 0]
                        iccat_data <- do.call("rbind", lapply(dataset_files_iccat, readr::read_csv, guess_max = 0))
                        iccat_data <- as.data.frame(iccat_data)
                        iccat_data_before_treatment <<- iccat_data
                        
                        class(iccat_data$value) <- "numeric"
                        
                        # Deal with special case of ICCAT PS
                      }else{
                        config$logger.warn(sprintf("Option include_%s = FALSE. Ignoring data...", rfmo))
                      }
                      iccat_data
                      iccat_data_after_treatment <<- iccat_data
                      
                      
                    },
                    #IATTC
                    #--------------------------------------------------------------------------------------
                    "IATTC" = {
                      #For  IATTC, some special data procesings, see below
                      iattc_data <- NULL
                      if(options$include_IATTC){
                        config$logger.info(sprintf("Get %s data", rfmo))
                        dataset_files_iattc <- dataset_files[regexpr("nominal", names(dataset_files)) < 0 & 
                                                               regexpr("ps", names(dataset_files)) < 0 & 
                                                               regexpr("effort", names(dataset_files)) < 0 &
                                                               regexpr("iattc", names(dataset_files)) > 0]
                        iattc_data <- do.call("rbind", lapply(dataset_files_iattc, readr::read_csv, guess_max = 0))
                        iattc_data <- as.data.frame(iattc_data)
                        
                        # Deal with special case of IATTC PS
                        iattc_data <- unique(iattc_data)
                        
                        iattc_data_before_treatment <<- iattc_data
                        
                        
                        ## IATTC PS catch-and-effort are stratified as following:
                        # - 1 dataset for tunas, stratified by type of school (but not fishingfleet)
                        # - 1 dataset for tunas, stratified by fishingfleet (but not type of school)
                        # - 1 dataset for billfishes, stratified by type of school (but not fishingfleet)
                        # - 1 dataset for billfishes, stratified by fishingfleet (but not type of school)
                        # - 1 dataset for sharks, stratified by type of school (but not fishingfleet)
                        # - 1 dataset for sharks, stratified by fishingfleet (but not type of school)
                        ## So in total there are 6 datasets. 
                        
                        # Commentaire Emmanuel Chassot: L’effort est exprimé ici en nombre de calées. Cela signifie dans le cas de l’EPO que les efforts donnés dans certains jeux de données peuvent correspondre à une partie de l’effort total alloué à une strate puisqu’il s’agit de l’effort observé, cà-d. pour lequel il y avait un observateur à bord du senneur. De mon point de vue, (1) L’effort unique et homogène serait celui des thons tropicaux et (2) pour uniformiser le jeu de captures par strate, il faut calculer un ratio de captures de requins par calée (observée) et de porte-épées par calée (observée) et de les multiplier ensuite par l’effort reporté pour les thons tropicaux puisqu’on considère que c’est l’effort de la pêcherie (qui cible les thons). Le raising factor est effort thons / effort billfish et effort thons / effort sharks.
                        
                    
                      }else{
                        config$logger.warn(sprintf("Option include_%s = FALSE. Ignoring data...", rfmo))
                      }
                      iattc_data
                      iattc_data_after_treatment <<- iattc_data
                      
                    }
  )
  
  return(dataset)
}

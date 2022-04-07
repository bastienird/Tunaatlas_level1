require(remotes)
require(devtools)
# install_github("eblondel/geoflow", dependencies = c("Depends", "Imports"), force = TRUE)
library(geoflow)
library(RPostgreSQL)
library(RPostgres)
library(RSQLite)
library(gsheet)
library(rtunaatlas)
library(DBI)
library(readr)
library(data.table)
config <- initWorkflow("~/Documents/Tunaatlas_level1/level0_level2_changingorder.json")
entities <- config$metadata$content$entities
# entities <- config$getEntities()

contacts <- config$metadata$content$contacts 
# contacts <- config$getContacts()

entity <- config$metadata$content$entities[[1]]
# entity <- entities[[1]]

options <- entity$data$actions[[1]]$options
#options <-config$actions[[1]]$options


con <- config$software$output$dbi

#set parameterization
fact <- options$fact
raising_georef_to_nominal <- options$raising_georef_to_nominal
iattc_ps_raise_flags_to_schooltype <- options$iattc_ps_raise_flags_to_schooltype
iattc_ps_dimension_to_use_if_no_raising_flags_to_schooltype <- options$iattc_ps_dimension_to_use_if_no_raising_flags_to_schooltype
iattc_ps_catch_billfish_shark_raise_to_effort <- options$iattc_ps_catch_billfish_shark_raise_to_effort
iccat_ps_include_type_of_school <- options$iccat_ps_include_type_of_school
if(!require(rtunaatlas)){
  if(!require(devtools)){
    install.packages("devtools")
  }
  require(devtools)
  install_github("eblondel/rtunaatlas")
  require(rtunaatlas)
}

if(!require(dplyr)){
  install.packages("dplyr")
  require(dplyr)
}

if(!require(data.table)){
  install.packages("data.table")
  require(data.table)
}


if(!require(readr)){
  install.packages("readr")
  require(readr)
}
# mapping_map_code_lists <- options$mapping_map_code_lists
#scripts
url_scripts_create_own_tuna_atlas <- "https://raw.githubusercontent.com/eblondel/geoflow-tunaatlas/master/tunaatlas_scripts/generation"
source(file.path(url_scripts_create_own_tuna_atlas, "get_rfmos_datasets_level0.R")) #modified for geoflow
source(file.path(url_scripts_create_own_tuna_atlas, "retrieve_nominal_catch.R")) #modified for geoflow
source(file.path(url_scripts_create_own_tuna_atlas, "map_codelists.R")) #modified for geoflow
source(file.path(url_scripts_create_own_tuna_atlas, "convert_units.R")) #modified for geoflow
source("https://raw.githubusercontent.com/BastienIRD/Tunaatlas_level1/main/fonction_dossier.R")
source("https://raw.githubusercontent.com/BastienIRD/Tunaatlas_level1/main/fonction_overlap.R")
# source("~/Documents/Tunaatlas_level1/function_raising_georef_to_nominal_Bastien.R")
source(file.path(url_scripts_create_own_tuna_atlas, "disaggregate_on_resdeg_data_with_resolution_superior_to_resdeg.R"))
source("https://raw.githubusercontent.com/BastienIRD/Tunaatlas_level1/main/disagregate_on_resdeg_Bastien.R")


# connect to Tuna atlas database
con <- config$software$output$dbi

#set parameterization

j <- 1

list_options <-   data.frame(matrix(ncol =2 , nrow = 1))
colnames(list_options) <- c("Options", "Position")


for (i in names(options)){
  if (i != ""){
    
    assign(paste0("options_",i), paste0(options[[j]]))
    assign(i, paste0(options[[j]][1]))}
  if (options[[j]][1] == TRUE){
    assign(i, options[[j]])
  } else if (options[[j]][1] == FALSE){
    assign(i, options[[j]])
  } 
  data_i <-   data.frame(i, options[[j]])
  names(data_i) <- colnames(list_options)
  list_options <- rbind(list_options, data_i)
  
  
  # print(j)
  
  j <-  j+1 
}
list_options = list_options[-1,]
gear_filter <- options$gear_filter
# write_csv(list_options, "list_options.csv")
mapping_dataset <- read_csv("~/Documents/Tunaatlas_level1/jobs/the_one_with_desaggregation_level1/entities/global_catch_1deg_1m_ps_bb_ird_level1desagregation/data/codelist_mapping_rfmos_to_global.csv")
# georef_dataset <- readRDS("~/Documents/Tunaatlas_level1/jobs/20220404135716/entities/global_catch_1deg_1m_ps_bb_ird_level1/Markdown/level2_test_modifying_function_new_nominal_catch/rds.rds")

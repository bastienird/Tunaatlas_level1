# 
# getwd()
renv::restore()
# options(encoding = "UTF-8")
setwd("~/Documents/Tunaatlas_level1")
if(!require(remotes)){
  install.packages("remotes")
require(remotes)
  }
if(!require(devtools)){
  install.packages("devtools")
  require(devtools)
}
if(!require(tinytex)){
  install.packages("tinytex")
  require(tinytex)
}
if(!require(geoflow)){
   remotes::install_github("eblondel/geoflow")
    require(geoflow)
  }

if(!require(RSQLite)){
  install.packages("RSQLite")
  require(RSQLite)
}
if(!require(RPostgreSQL)){
  install.packages("RPostgreSQL")
  require(RPostgreSQL)
}
if(!require(RPostgres)){
  install.packages("RPostgres")
  require(RPostgres)
}

if(!require(googledrive)){
  install.packages("googledrive")
  require(googledrive)
}
if(!require(DBI)){
  install.packages("DBI")
  require(DBI)
}
if(!require(gsheet)){
  install.packages("gsheet")
  require(gsheet)
}
if(!require(data.table)){
  install.packages("data.table")
  require(data.table)
}
if(!require(plotrix)){
  install.packages("plotrix")
  require(plotrix)
}
if(!require(rgeos)){
  install.packages("rgeos")
  require(rgeos)
}


if(!require(rpostgis)){
  install_github("rpostgis")
  require(rpostgis)
}
if(!require(janitor)){
  install.packages("janitor")
  require(janitor)
}

if(!require(dotenv)){
install.packages("dotenv")
require(dotenv)
}
if(!require(bookdown)){
  install.packages("bookdown")
  require(bookdown)
}
if(!require(zen4R)){
  install.packages("zen4R")
  require(zen4R)
}
load_dot_env(file = "catch_local.env")

load_dot_env(file = "catch_server.env")


executeWorkflow("tunaatlas_qa_dbmodel+codelists.json")#works
executeWorkflow("tunaatlas_qa_mappings.json")

#to clean db if needed
# config <- initWorkflow("tunaatlas_qa_global_datasets_effort.json") #ok
# con <- config$software$output$dbi
# dbGetQuery(con, statement = read_file("cleaning_db.sql"))


executeWorkflow("tunaatlas_qa_datasets_iccat.json") # ok careful database only work in local

executeWorkflow("tunaatlas_qa_datasets_ccsbt.json") # ok
executeWorkflow("tunaatlas_qa_datasets_wcpfc.json") # ok 
executeWorkflow("tunaatlas_qa_datasets_iattc.json") # ok
executeWorkflow("tunaatlas_qa_datasets_iotc.json") # ok
executeWorkflow("tunaatlas_qa_global_datasets_catch.json")


load_dot_env(file = "effort_local.env")
load_dot_env(file = "effort_server.env")


executeWorkflow("tunaatlas_qa_datasets_ccsbt_effort.json") #ok
executeWorkflow("tunaatlas_qa_datasets_wcpfc_effort.json") #ok
executeWorkflow("tunaatlas_qa_datasets_iattc_effort.json") # ok
executeWorkflow("tunaatlas_qa_datasets_iotc_effort.json") # ok
executeWorkflow("tunaatlas_qa_datasets_iccat_effort.json") # ok

executeWorkflow("tunaatlas_qa_global_datasets_effort.json")


load_dot_env("~/Documents/Tunaatlas_level1/geoserver_julien.env")
executeWorkflow("~/Documents/geoflow-tunaatlas/tunaatlas_qa_services.json")
executeWorkflow("~/Documents/geoflow-tunaatlas/tunaatlas_qa_services.json")

config <- initWorkflow("tunaatlas_qa_global_datasets_effort.json") #ok
# initWorkflowJob(config)
jobdir <- initWorkflowJob(config)
jobdir <- "~/Documents/Tunaatlas_level1/jobs/20221017051232_glob_eff"
config$job <-"~/Documents/Tunaatlas_level1/jobs/20221017051232_glob_eff"
# config$job <- jobdir
entities <- config$metadata$content$entities
# entities <- config$getEntities()

contacts <- config$metadata$content$contacts 
# contacts <- config$getContacts()

entity <- config$metadata$content$entities[[1]]
action <- entity$data$actions[[1]]
config$metadata$content$entities[[1]] <- config$metadata$content$entities[[3]]
# entity$copyDataToJobDir(config, jobdir)
config$profile$options$skipFileDownload <- TRUE

# entity <- entities[[1]]
executeWorkflowJob(config)



# install_github("eblondel/geoflow", dependencies = c("Depends", "Imports"))
library(geoflow)
library(rtunaatlas)
library(DBI)
library(readr)
library(data.table)
library(rpostgis)
library(stringr)
library(sf)
library(googledrive)

use_github_file(
  "https://raw.githubusercontent.com/BastienIRD/Tunaatlas_level1/main/comp_sans_shiny.Rmd",
  path = NULL,
  save_as = "jobs/20220728154152/test.Rmd",
  ref = NULL,
  ignore = FALSE,
  open = TRUE,
  host = NULL
)

renderingigthub = function(file_path, saveas, params,output_file){
  require(stringr)
  use_github_file(
    file_path,
    path = NULL,
    save_as = saveas,
    ref = NULL,
    ignore = FALSE,
    open = FALSE,
    host = NULL
  )

  last_path = function(x){tail(str_split(x,"/")[[1]],n=1)}
  wd <- getwd()
  print(saveas)
  print(gsub(last_path(saveas),"",saveas))
  setwd(gsub(last_path(saveas),"",saveas))
  print(getwd())
  rmarkdown::render(last_path(saveas),
                    params,output_file = "")
  setwd(wd)
  
  
}

renderingigthub("https://raw.githubusercontent.com/BastienIRD/Tunaatlas_level1/main/comp_sans_shiny.Rmd",
                "jobs/20220728154152/entities/global_catch_1deg_level0/comp_sans_shiny.Rmd", 
                params = list(init = "Markdown/overlap_ccsbt_wcpfc", 
                     final = "Markdown/raising",
                     con = con))

rmarkdown::render(use_github_file(
  "https://raw.githubusercontent.com/BastienIRD/Tunaatlas_level1/main/comp_sans_shiny.Rmd",
  path = NULL,
  save_as = "jobs/20220728154152/test.Rmd",
  ref = NULL,
  ignore = FALSE,
  open = TRUE,
  host = NULL
), 
            params = list(init = "~/Documents/Tunaatlas_level1/jobs/20220719140637/entities/global_catch_1deg_1m_ps_bb_firms_Bastien_filtering_wcpfc_at_the_end_level0/Markdown/overlap_ccsbt_wcpfc", 
                          final = "~/Documents/Tunaatlas_level1/jobs/20220719140637/entities/global_catch_1deg_1m_ps_bb_firms_Bastien_filtering_wcpfc_at_the_end_level0/Markdown/raising",
con = con), output_file  = paste0("test"))


#effort https://docs.google.com/spreadsheets/d/1F7BgP4i_BClk2slgh3ziVedWEQ_ATaGsC51NkwiD-xY/edit#gid=1994835658
# executeWorkflow("~/Documents/Tunaatlas_level1/lancing_workflow_effort.json")
# executeWorkflow("Workflow_L0_json_files/tunaatlas_qa_dbmodel+codelists_d4science.json")
# executeWorkflow("tunaatlas_qa_dbmodel+codelists.json")
executeWorkflow("tunaatlas_qa_dbmodel+codelists.json")#works
executeWorkflow("tunaatlas_qa_mappings.json")


executeWorkflow("tunaatlas_qa_datasets_ccsbt_effort.json")
executeWorkflow("tunaatlas_qa_datasets_wcpfc_effort.json")

executeWorkflow("tunaatlas_qa_datasets_iattc_effort.json")
# initWorkflow("tunaatlas_qa_datasets_iattc.json")
# config <- initWorkflow("tunaatlas_qa_datasets_iattc.json")
executeWorkflow("tunaatlas_qa_datasets_iotc_effort.json")
executeWorkflow("tunaatlas_qa_datasets_iccat.json") #fais abort la session

executeWorkflow("tunaatlas_qa_global_datasets_catch.json")
config <- initWorkflow("tunaatlas_qa_global_datasets_catch.json")
# executeWorkflow("tunaatlas_qa_dbmodel+codelists.json")
# fonction_dossier("overlap_iotc_ccsbt",
#                  georef_dataset, 
#                  "Keeping data from CCSBT or IOTC ",
#                  "function_overlapped", 
#                  list( options_include_CCSBT  , 
#                     options_include_IOTC , options_overlapping_zone_iotc_ccsbt_data_to_keep, options_strata_overlap_sbf ))

executeWorkflow("~/Documents/Tunaatlas_level1/tunaatlas_qa_global_L0_datasets_catch_d4science_2022.json")

# executeWorkflow("~/Documents/Tunaatlas_level1/tunaatlas_qa_dbmodel+codelists_d4science.json")
# executeWorkflow("~/Documents/Tunaatlas_level1/tunaatlas_qa_global_L1_datasets_catch_d4science_firms.json")

config <- initWorkflow("~/Documents/Tunaatlas_level1/tunaatlas_qa_global_L1_datasets_catch_d4science_firms.json")





if(!require(rtunaatlas)) {
  install_github("eblondel/rtunaatlas", force=TRUE)
  library(rtunaatlas)           # fonction_dossier("overlap_iotc_ccsbt",
  #                  georef_dataset, 
  #                  "Keeping data from CCSBT or IOTC ",
  #                  "function_overlapped", 
  #                  list( options_include_CCSBT  , 
  #                     options_include_IOTC , options_overlapping_zone_iotc_ccsbt_data_to_keep, options_strata_overlap_sbf ))
  
  }
setwd("~/Documents/Tunaatlas_level1")
files <- "tunaatlas_qa_dbmodel+codelists.json"
config <- initWorkflow(files)

executeWorkflow("Workflow_L0_json_files/tunaatlas_qa_dbmodel+codelists_d4science.json")
executeWorkflow("Workflow_L0_json_files/tunaatlas_qa_mappings_d4science.json")
executeWorkflow("Workflow_L0_json_files/tunaatlas_qa_datasets_ccsbt.json")
executeWorkflow("Workflow_L0_json_files/tunaatlas_qa_datasets_iattc.json")
executeWorkflow("Workflow_L0_json_files/tunaatlas_qa_datasets_iotc.json")
executeWorkflow("Workflow_L0_json_files/tunaatlas_qa_datasets_wcpfc.json")
executeWorkflow("Workflow_L0_json_files/tunaatlas_qa_datasets_iccat.json") #fais abort la session

executeWorkflow("Workflow_L0_json_files/tunaatlas_qa_global_datasets_catch_d4science.json")


# config <- initWorkflow(files)
# jobdir <- "~/Documents/Analyse_des_scripts/Test01_02/lancement/jobs/20220303001750"
# config$job <- jobdir

# jobdir <- "~/Documents/Analyse_des_scripts/Test01_02/lancement/jobs/20220216161808/entities/global_catch_firms_steps_1_2_level0_"



config$job <- jobdir
# 
executeWorkflowJob(config)
# 


############
#1. Init the workflow based on configuration file
config <- initWorkflow("~/Documents/Tunaatlas_level1/tunaatlas_qa_global_L1_datasets_catch_d4science_firms.json")
#2. Inits workflow job (create directories)
initWorkflowJob(config)

jobdir <- initWorkflowJob(config)
# config$job <- "~/Documents/Tunaatlas_level1/jobs/all_new_reference"
# config$job <- "~/Documents/Tunaatlas_level1/jobs/20220601110916"
#3. le téléchargement de la donnée vers le dossier d'execution ne se fait  que lorsqu'on execute executeWorkflowJob. 
#Pour pouvoir travailler sur une action, il faut donc passer les principales actions une par une, initWorkflow, intWorkflowJob,
 # config$job <- "~/Documents/Tunaatlas_level1/jobs/20220616115652"
jobdir <- initWorkflowJob(config)
config$job <- jobdir
config$job <- "~/Documents/Tunaatlas_level1/jobs/20220811131625/entities/global_nominal_catch_firms_level0"
executeWorkflowJob(config)
# geoflow::debugWorkflow("~/Documents/Tunaatlas_level1/tunaatlas_qa_datasets_iattc.json")

config <- initWorkflow("tunaatlas_qa_global_datasets_catch.json")

entities <- config$metadata$content$entities
# entities <- config$getEntities()

contacts <- config$metadata$content$contacts 
# contacts <- config$getContacts()

entity <- config$metadata$content$entities[[1]]
# entity <- entities[[1]]
action <- entity$data$actions[[1]]
setwd("~/Documents/Tunaatlas_level1/jobs/Level2FAL/entities/global_catch_1deg_level2")
# opts <- entity$data$actions[[1]]$opts
#options <-config$actions[[1]]$options


con <- config$software$output$dbi

#set parameterization
fact <- options$fact
raising_georef_to_nominal <- options$raising_georef_to_nominal
iattc_ps_raise_flags_to_schooltype <- options$iattc_ps_raise_flags_to_schooltype
iattc_ps_dimension_to_use_if_no_raising_flags_to_schooltype <- options$iattc_ps_dimension_to_use_if_no_raising_flags_to_schooltype
iattc_ps_catch_billfish_shark_raise_to_effort <- options$iattc_ps_catch_billfish_shark_raise_to_effort
iccat_ps_include_type_of_school <- options$iccat_ps_include_type_of_school

# mapping_dataset <- read_csv("~/Documents/Tunaatlas_level1/jobs/All_without_Julien/entities/global_catch_firms_Old_with_step_rds_level0/data/codelist_mapping_rfmos_to_global.csv")

dir.create("Rds")

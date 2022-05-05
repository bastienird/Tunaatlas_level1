
getwd()
setwd("~/Documents/Tunaatlas_level1")
require(remotes)
require(devtools)
# install_github("eblondel/geoflow", dependencies = c("Depends", "Imports"))
library(geoflow)
library(RPostgreSQL)
library(RPostgres)
library(RSQLite)
library(gsheet)
library(rtunaatlas)
library(DBI)
library(readr)
library(data.table)
library(rpostgis)
library(stringr)
library(sf)
library(googledrive)
executeWorkflow("~/Documents/Tunaatlas_level1/tunaatlas_qa_global_L1_datasets_catch_d4science_firms.json")

config <- initWorkflow("~/Documents/Tunaatlas_level1/tunaatlas_qa_global_L1_datasets_catch_d4science_firms.json")





if(!require(rtunaatlas)) {
  install_github("eblondel/rtunaatlas", force=TRUE)
  library(rtunaatlas)
  }
setwd("~/Documents/Tunaatlas_level1")
files <- "~/Documents/Tunaatlas_level1/tunaatlas_qa_global_L1_datasets_catch_d4science.json"
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



# config$job <- jobdir
# 
executeWorkflowJob(config)
# 


############
#1. Init the workflow based on configuration file
config <- initWorkflow("~/Documents/Tunaatlas_level1/tunaatlas_qa_global_L1_datasets_catch_d4science.json")
#2. Inits workflow job (create directories)
jobdir <- initWorkflowJob(config)
# config$job <- "~/Documents/Tunaatlas_level1/jobs/20220428104014"
# config$job <- "~/Documents/Analyse_des_scripts/Test01_02/lancement/jobs/20220309152940"
#3. le téléchargement de la donnée vers le dossier d'execution ne se fait  que lorsqu'on execute executeWorkflowJob. 
#Pour pouvoir travailler sur une action, il faut donc passer les principales actions une par une, initWorkflow, intWorkflowJob,
# config$job <- "~/Documents/Tunaatlas_level1/jobs/20220504152124"
config$job <- jobdir
executeWorkflowJob(config)
executeWorkflow(files)


entities <- config$metadata$content$entities
# entities <- config$getEntities()

contacts <- config$metadata$content$contacts 
# contacts <- config$getContacts()

entity <- config$metadata$content$entities[[2]]
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

# mapping_dataset <- read_csv("~/Documents/Tunaatlas_level1/jobs/All_without_Julien/entities/global_catch_firms_Old_with_step_rds_level0/data/codelist_mapping_rfmos_to_global.csv")

dir.create("Rds")

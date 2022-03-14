
getwd()
require("remotes")
install_github("eblondel/geoflow", dependencies = c("Depends", "Imports"), force = TRUE)
library(geoflow)
library(RPostgreSQL)
library(RPostgres)
library(RSQLite)
library(gsheet)
library(rtunaatlas)
library(DBI)
if(require(rtunaatlas)) {
  remove.packages("rtunaatlas",
                  lib="~/Documents/Analyse_des_scripts/Test01_02/lancement/renv/library/R-4.1/x86_64-pc-linux-gnu")
  install_github("eblondel/rtunaatlas", force=TRUE)}
files <- "tunaatlas_qa_global_L1_datasets_catch_d4science.json"
executeWorkflow(files)


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
# executeWorkflowJob(config)
# 


############
#1. Init the workflow based on configuration file
config <- initWorkflow(files)
#2. Inits workflow job (create directories)
jobdir <- initWorkflowJob(config)
# config$job <- "~/Documents/Analyse_des_scripts/Test01_02/lancement/jobs/20220311165011"
# config$job <- "~/Documents/Analyse_des_scripts/Test01_02/lancement/jobs/20220309152940"
#3. le téléchargement de la donnée vers le dossier d'execution ne se fait  que lorsqu'on execute executeWorkflowJob. 
#Pour pouvoir travailler sur une action, il faut donc passer les principales actions une par une, initWorkflow, intWorkflowJob,
config$job <- jobdir
executeWorkflowJob(config)
executeWorkflow(file)


entities <- config$metadata$content$entities
entities <- config$getEntities()

contacts <- config$metadata$content$contacts 
contacts <- config$getContacts()

entity <- config$metadata$content$entities[[1]]
entity <- entities[[1]]

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

dir.create("Rds")

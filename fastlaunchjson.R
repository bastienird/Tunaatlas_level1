# 
# getwd()
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
  require(geoflow)}

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
if(!require(rtunaatlas)){
  install_github("eblondel/rtunaatlas")
  require(rtunaatlas)
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

load_dot_env(file = "effort_local.env")
config <- initWorkflow("~/Documents/Tunaatlas_level1/tunaatlas_qa_global_datasets_effort.json") #ok
# initWorkflowJob(config)
# jobdir <- initWorkflowJob(config)
jobdir <- "~/Documents/Tunaatlas_level1/jobs/20220926115816_global_effort"
config$job <-"~/Documents/Tunaatlas_level1/jobs/20220926115816_global_effort"
setwd("~/Documents/Tunaatlas_level1/jobs/20220926115816_global_effort/entities/global_catch_effort_test")
# config$job <- jobdir
entities <- config$metadata$content$entities
# entities <- config$getEntities()

contacts <- config$metadata$content$contacts 
# contacts <- config$getContacts()

entity <- config$metadata$content$entities[[1]]
action <- entity$data$actions[[1]]

comparison_each_step <- function(action, entity, config){
  if(!(require(here))){ 
    install.packages("here") 
    (require(here))} 
  if(!require(stringr)){
    install.packages("stringr")
    require(stringr)
  }
  if(!require(bookdown)){
    install.packages("bookdown")
    require(bookdown)
  }
  copyrmd <- function(x){
    last_path = function(y){tail(str_split(y,"/")[[1]],n=1)}
    use_github_file(repo_spec =x,
                    save_as = paste0(gsub(as.character(here::here()),"",as.character(getwd())), paste0("/", last_path(x))),
                    ref = NULL,
                    ignore = FALSE,
                    open = FALSE,
                    host = NULL
    ) }
  
  c <- c("https://raw.githubusercontent.com/BastienIRD/Tunaatlas_level1/main/tableau_recap_global_action_effort.Rmd", 
         "https://raw.githubusercontent.com/BastienIRD/Tunaatlas_level1/main/comp_sans_shiny_child_effort.Rmd")
  lapply(c,copyrmd)
  actionrmd <- action
  entityrmd <- entity
  configrmd <- config
  rmarkdown::render("tableau_recap_global_action_effort.Rmd"  , 
                    params = list(action = actionrmd,
                                  entity = entityrmd, config = configrmd))
}
comparison_each_step(action, entity, config)
rm(list = setdiff(ls(), c("config", "action", "options", "entity", "comparison_each_step")))

rmarkdown::render("tableau_recap_global_action_effort.Rmd", params = (list(config = config,action = action, entity =entity, fact = "effort", filtering = list(species = NULL))))


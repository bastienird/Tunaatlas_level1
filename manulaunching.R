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

executeWorkflow("manulaunching/tunaatlas_qa_dbmodel+codelists.json")#works
executeWorkflow("manulaunching/tunaatlas_qa_mappings.json")#works
executeWorkflow("manulaunching/tunaatlas_qa_datasets_iccat.json") #do not load in db



executeWorkflow("manulaunching/tunaatlas_qa_datasets_ccsbt.json")#works
executeWorkflow("manulaunching/tunaatlas_qa_datasets_iattc.json")#works
# initWorkflow("manulaunching/tunaatlas_qa_datasets_iattc.json")#works
# config <- initWorkflow("manulaunching/tunaatlas_qa_datasets_iattc.json")
executeWorkflow("manulaunching/tunaatlas_qa_datasets_iotc.json")#works
executeWorkflow("manulaunching/tunaatlas_qa_datasets_wcpfc.json")#works

executeWorkflow("manulaunching/tunaatlas_qa_global_datasets_catch.json")

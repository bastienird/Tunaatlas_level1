comparison_each_step <- function(action, entity, config, options, debugging = FALSE){
  if(!(require(here))){ 
    install.packages("here") 
    (require(here))} 
  if(!(require(dplyr))){ 
    install.packages("dplyr") 
    (require(dplyr))} 
  
  if(!require(stringr)){
    install.packages("stringr")
    require(stringr)
  }
  if(!require(tibble)){
    install.packages("tibble")
    require(tibble)
  }
  if(!require(bookdown)){
    install.packages("bookdown")
    require(bookdown)
  }

  
  if(debugging == TRUE){
    c <- c("~/Documents/Tunaatlas_level1/tableau_recap_global_action_effort.Rmd", 
           "~/Documents/Tunaatlas_level1/comparison.Rmd", 
           "~/Documents/Tunaatlas_level1/strata_conversion_factor_gihtub.Rmd", 
           "~/Documents/Tunaatlas_level1/potentially_mistaken_data.Rmd",
           "~/Documents/Tunaatlas_level1/template.tex",
           "~/Documents/Tunaatlas_level1/dmk-format.csl")
    copyfiles <- function(x){
      last_path = function(y){tail(str_split(y,"/")[[1]],n=1)}
      file.copy(from =x,
                    to = paste0(getwd(), paste0("/", last_path(x))), overwrite = TRUE
      )
     }
    lapply(c,copyfiles)
  } else {
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
           "https://raw.githubusercontent.com/BastienIRD/Tunaatlas_level1/main/comparison.Rmd", 
           "https://raw.githubusercontent.com/BastienIRD/Tunaatlas_level1/main/strata_conversion_factor_gihtub.Rmd", 
           "https://raw.githubusercontent.com/BastienIRD/Tunaatlas_level1/main/potentially_mistaken_data.Rmd",
           "https://raw.githubusercontent.com/BastienIRD/Tunaatlas_level1/main/template.tex",
           "https://raw.githubusercontent.com/BastienIRD/Tunaatlas_level1/main/dmk-format.csl")
    lapply(c,copyrmd)
  }
  parameters_child_global <- list(action = action,
                           entity = entity, config = config, debugging = debugging)
  child_env_global = new.env()
  list2env(parameters_child_global, env = child_env_global)
  
  rmarkdown::render("tableau_recap_global_action_effort.Rmd"  , 
                    envir =  parameters_child_global)
  if(dir.exists("Markdown/Realocating_removing_mislocated_data")){
    wd <- getwd()
    list_dir <- list.dirs(path =paste0(wd,"/Markdown"), full.names = TRUE, recursive = FALSE)
    details = file.info(list_dir)
    details = details[with(details, order(as.POSIXct(mtime))), ]
    details <- tibble::rownames_to_column(details, "dir_name")
    details <- tibble::rowid_to_column(details, "ID")
    Realocating_removing_mislocated_data_number <-details %>% filter(str_detect(dir_name,"Realocating_removing_mislocated")) %>% pull(ID)
    before_Realocating_removing_mislocated_data <- details %>% filter(ID == Realocating_removing_mislocated_data_number-1) %>% pull(dir_name)
    parameters_child_mistaken <- list(action = action,
                                    entity = entity, config = config, debugging = debugging, final = paste0(before_Realocating_removing_mislocated_data))
    child_env_mistaken = new.env()
    list2env(parameters_child_mistaken, env = child_env_mistaken)
    
    rmarkdown::render("potentially_mistaken_data.Rmd"  , envir =  parameters_child_mistaken, output_file = "Analyse_mislocated_before_treatment")
    
  }
  # if(dir.exists("Markdown/Removing_absurd_nomt")){
  #   wd <- getwd()
  #   list_dir <- list.dirs(path =paste0(wd,"/Markdown"), full.names = TRUE, recursive = FALSE)
  #   details = file.info(list_dir)
  #   details = details[with(details, order(as.POSIXct(mtime))), ]
  #   details <- tibble::rownames_to_column(details, "dir_name")
  #   details <- tibble::rowid_to_column(details, "ID")
  #   begin_conv_fact_handling_number <-details %>% filter(str_detect(dir_name,"Removing_absurd_nomt")) %>% pull(ID)
  #   before_begin_conv_fact_handling <- details %>% filter(ID == begin_conv_fact_handling_number-1) %>% pull(dir_name)
  #   rmarkdown::render("strata_conversion_factor_gihtub.Rmd"  , 
  #                     params = list(action = action,
  #                                   entity = entity, config = config,
  #                                   final = paste0(before_begin_conv_fact_handling)), envir =  new.env(), output_file = "Analyse_mislocated_before_treatment")
  #   
  # }
  
}



comparison_each_step <- function(action, entity, config, options){
  if(!(require(here))){ 
    install.packages("here") 
    (require(here))} 
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
         "https://raw.githubusercontent.com/BastienIRD/Tunaatlas_level1/main/Analyse_georeferenced_child.Rmd",
         "https://raw.githubusercontent.com/BastienIRD/Tunaatlas_level1/main/comp_sans_shiny_child_effort.Rmd")
  lapply(c,copyrmd)
  rmarkdown::render("tableau_recap_global_action.Rmd"  , 
  params = list(action = action,
                entity = entity, config = config))
}


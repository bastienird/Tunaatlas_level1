comparison_each_step <- function(action,entity, config, options){
  rmarkdown::render(use_github_file(
    "https://raw.githubusercontent.com/BastienIRD/Tunaatlas_level1/main/tableau_recap_global_action.Rmd",
    path = NULL,
    save_as = "recap_all.Rmd",
    ref = NULL,
    ignore = FALSE,
    open = TRUE,
    host = NULL
  ), 
  params = list(action = action,
                entity = entity, config = config))
}
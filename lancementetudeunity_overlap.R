#lancement detude unity 
last_path = function(x){tail(str_split(x,"/")[[1]],n=1)}
last_path_reduced = function(y){gsub("georef_dataset","",tail(str_split(y,"/")[[1]],n=1))}
library(stringr)
last_path_reduced("data/Les7entites_finies/entities/global_catch_1deg_1m_ps_bb_firms_level0/Rds/georef_dataset_level0_step11global_catch_1deg_1m_ps_bb_firms_level0.rds")
fonction_markdown_unity = function(chemin_dacces){
  
  
  rmarkdown::render("study_of_unity.Rmd", params = list(chemin_dacces = chemin_dacces), 
                    output_dir = "Markdown/",output_file = paste0("unity",
                                                                  
                                          last_path_reduced(chemin_dacces),".html"))
  
}

fonction_markdown_unity("data/Les7entites_finies/entities/global_catch_firms_level0/Rds/georef_dataset_level0_step11global_catch_firms_level0.rds")


fonction_markdown_overlap = function(chemin_dacces){
  
  
  rmarkdown::render("etude_overlap.Rmd", params = list(chemin_dacces = chemin_dacces), 
  output_dir = "Markdown/",output_file = paste0("overlap",last_path_reduced(chemin_dacces),".html"))
}

fonction_markdown_overlap("data/Les7entites_finies/entities/global_catch_1deg_1m_ps_bb_firms_level0/Rds/georef_dataset_level0_step11global_catch_1deg_1m_ps_bb_firms_level0.rds")

# for (i in ()
# 
# 
# 
# 
# 
# 
# 

#lancement detude overlap 


fonction_markdown_overlap = function(chemin_dacces, output = paste0("overlap",tail(str_split(chemin_dacces,"/")[[1]],n=1),".html")){

      
      rmarkdown::render("etude_overlap.Rmd", params = list(chemin_dacces = chemin_dacces), 
                    output_dir = "Markdown/",
                    output_file = output)
}

fonction_markdown_overlap("data/Les7entites_finies/entities/global_catch_firms_level0/Rds/georef_dataset_level0_step11global_catch_firms_level0.rds",
                          output = "level0_global_catch_study_mislocated")

fonction_markdown_overlap("~/Documents/Tunaatlas_level1/jobs/no_difference_L1_L2/entities/global_catch_ird_level2/Markdown/level1reallocation/rds.rds",
                          output = "level1_global_catch_study_mislocated")

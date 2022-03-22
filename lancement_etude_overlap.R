#lancement detude overlap 


fonction_markdown_overlap = function(chemin_dacces){

      
      rmarkdown::render("etude_overlap.Rmd", params = list(chemin_dacces = chemin_dacces), 
                    output_dir = "Markdown/",output_file = paste0("overlap",tail(str_split(chemin_dacces,"/")[[1]],n=1),".html"))
}

fonction_markdown_overlap("data/Les7entites_finies/entities/global_catch_firms_level0/Rds/georef_dataset_level0_step11global_catch_firms_level0.rds")

#lancement detude overlap 


fonction_markdown_overlap = function(chemin_dacces, output = paste0("overlap",tail(str_split(chemin_dacces,"/")[[1]],n=1),".html")){

      
      rmarkdown::render("etude_overlap.Rmd", params = list(chemin_dacces = chemin_dacces), 
                    output_dir = "Markdown/",
                    output_file = output)
}

fonction_markdown_overlap("~/Documents/Tunaatlas_level1/jobs/mycode_second/entities/global_catch_firms_Bastien_rds_level0/Markdown/mapping_codelist/rds.rds",
                          output = "level0_global_catch_study_mislocated_after_mapping")

fonction_markdown_overlap("~/Documents/Tunaatlas_level1/jobs/old_with_correction_maybe/entities/global_catch_firms_Old_with_step_rds_level0/Markdown/unit_harmonization/rds.rds",
                          output = "level0_global_catch_study_mislocated_at_the_end_old")

fonction_markdown_overlap("data/test_end_level0_after_function_realocate.rds",
                          output = "level0_global_catch_study_mislocated_afterrealocation")

fonction_markdown_overlap("data/test_end_level0_after_function_remove.rds",
                          output = "level0_global_catch_study_mislocated_after_remove")

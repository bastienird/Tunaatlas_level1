fonction_dossier=function(nom_dossier, nomrds, explication="",fonctions="", options=NULL) {
  dir.create("Markdown")
  dir.create(paste0("Markdown/",nom_dossier))
  nom_dossier <- paste0("Markdown/",nom_dossier)
  rds_t <- (nomrds %>% filter(unit %in% c("t", "MTNO","MT"))) 
  rds_no <- (nomrds %>% filter(unit %in% c("no", "NOMT","NO"))) 
  somme_t <- sum(rds_t$value, na.rm = TRUE)
  somme_no <- sum(rds_no$value, na.rm = TRUE)
  lines <- nrow(nomrds)
  write_csv(data.frame(somme_t, somme_no, lines), paste0(nom_dossier,"/sums.csv"))
  if (!is.null(options)){
    options_substi <- as.list(substitute(options))[-1]
    options_written <- ""
    for (i in 1:length(options_substi)){
      options_written <- paste0(options_written, (paste0(options_substi[i], " = ", options[i])), 
                               sep = " ; \n ")
      
      
    }
    write(options_written, paste0(nom_dossier,"/options.txt"))
    
    } else {options = "NONE"}
    
  saveRDS(nomrds,paste0(nom_dossier,"/rds.rds"))
  write(explication, paste0(nom_dossier,"/explication.txt")) 
  write(fonctions, paste0(nom_dossier,"/fonctions.txt"))
}



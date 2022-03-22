fonction_dossier=function(nom_dossier, nomrds, explication,fonctions, options) {
  dir.create(nom_dossier)
  saveRDS(nomrds,paste0(nom_dossier,"/rds.rds"))
  write(explication, paste0(nom_dossier,"/explication.txt")) 
  write(fonctions, paste0(nom_dossier,"/fonctions.txt"))
  write(options, paste0(nom_dossier,"/options.txt"))
  
}


fonction_option = function(x){
  name <- as.character(substitute(x))
  paste0(name, " = ", x)
}

function_option_assign = function(x){
  paste(paste0(lapply(x, fonction_option)), collapse = " ; ")
}

fonction_dossier=function(nom_dossier, nomrds, explication="",fonctions="", options=NULL) {
  dir.create("Markdown")
  dir.create(paste0("Markdown/",nom_dossier))
  nom_dossier <- paste0("Markdown/",nom_dossier)
  somme_t <- sum((nomrds %>% filter(unit %in% c("t", "MTNO","MT")))$value, na.rm = TRUE)
  somme_no <- sum((nomrds %>% filter(unit %in% c("no", "NOMT","NO")))$value, na.rm = TRUE)
  write_csv(data.frame(somme_t, somme_no), paste0(nom_dossier,"/sums.csv"))
  if (!is.null(options)){
  options <- function_option_assign(options)} else {options = "NONE"}
  saveRDS(nomrds,paste0(nom_dossier,"/rds.rds"))
  write(explication, paste0(nom_dossier,"/explication.txt")) 
  write(fonctions, paste0(nom_dossier,"/fonctions.txt"))
  write(options, paste0(nom_dossier,"/options.txt"))
  
}


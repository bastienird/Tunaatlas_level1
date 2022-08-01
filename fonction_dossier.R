# function_creation_options = function(){
# 
# j <- 1
# 
# list_options <-assign("list_options", data.frame(matrix(ncol =2 , nrow = 1)), envir= .GlobalEnv)
# colnames(list_options) <- c("Options", "Position")
# 
# 
# for (i in names(options)){
#   if (i != ""){
#     
#     assign(paste0("options_",i), paste(options[[j]], collapse = ' ; '), envir= .GlobalEnv)
#     assign(i, paste0(options[[j]]), envir= .GlobalEnv)}
#   if (options[[j]][1] == TRUE){
#     assign(i, options[[j]], envir= .GlobalEnv)
#   } else if (options[[j]][1] == FALSE){
#     assign(i, options[[j]], envir= .GlobalEnv)
#   } 
#   assign("data_i",  data.frame(i, paste(options[[j]], collapse = ' ; ')))
#   names(data_i) <- colnames(list_options)
#   assign("data_i",data_i, envir= .GlobalEnv)
#   list_options <- rbind(list_options, data_i)
#   
#   j <-  j+1 
# }
# list_options = list_options[-1,]
# }

fonction_dossier=function(nom_dossier, nomrds, explication="",fonctions="", option_list=NULL) {
  if(!exists("options_written_total")){assign("options_written_total", "", envir = .GlobalEnv)}
  if(!exists("explenation_total")){assign("explenation_total", "", envir = .GlobalEnv)}
  dir.create("Markdown")
  dir.create(paste0("Markdown/",nom_dossier))
  nom_dossier <- paste0("Markdown/",nom_dossier)
  rds_t <- (nomrds %>% filter(unit %in% c("t", "MTNO","MT"))) 
  rds_no <- (nomrds %>% filter(unit %in% c("no", "NOMT","NO"))) 
  somme_t <- sum(rds_t$value, na.rm = TRUE)
  somme_no <- sum(rds_no$value, na.rm = TRUE)
  lines <- nrow(nomrds)
  write_csv(data.frame(somme_t, somme_no, lines), paste0(nom_dossier,"/sums.csv"))
  if (!is.null(option_list)){
    options_substi <- as.list(substitute(option_list))[-1]
    print(options_substi)
    options_written <- ""
    for (i in 1:length(options_substi)){
      options_written <- paste0(options_written, (paste0(options_substi[i], " = ", option_list[i])), 
                                sep = " , \n ")
      
      
      
      
      
    }
    print(options_written)
  } else {options_written = "NONE"}
  options_written_total <- assign("options_written_total", paste0(options_written_total, options_written), envir = .GlobalEnv)
  explenation_total <- assign("explenation_total", paste0(explenation_total, explication), envir = .GlobalEnv)
  saveRDS(nomrds,paste0(nom_dossier,"/rds.rds"))
  write(explication, paste0(nom_dossier,"/explication.txt")) 
  write(explenation_total, paste0(nom_dossier,"/explenation_total.txt")) 
  write(fonctions, paste0(nom_dossier,"/fonctions.txt"))
  write(options_written_total, "options_total.txt")
  write(options_written_total, paste0(nom_dossier,"/options_total.txt"))
  write(options_written, paste0(nom_dossier,"/options_written.txt"))
  
}





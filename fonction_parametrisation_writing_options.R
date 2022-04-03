fonction_parametrisation_writing_options =function(options) {
  j <- 1
  
  list_options <-   data.frame(matrix(ncol =2 , nrow = 1))
  colnames(list_options) <- c("Options", "Position")
  
  
  for (i in names(options)){
    if (i != ""){
      
      assign(paste0("options_",i), paste0(options[[j]]))
      assign(i, paste0(options[[j]][1]))}
    if (options[[j]][1] == TRUE){
      assign(i, options[[j]])
    } else if (options[[j]][1] == FALSE){
      assign(i, options[[j]])
    } 
    data_i <-   data.frame(i, options[[j]])
    names(data_i) <- colnames(list_options)
    list_options <- rbind(list_options, data_i)
    
    
    # print(j)
    
    j <-  j+1 
  }
  list_options = list_options[-1,]
  write_csv(list_options, "list_options.csv")
  
}
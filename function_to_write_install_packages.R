pasting <- c()
for (i in b$pkgs){
  print(i)
  if(!is.na(i)){
  if(i == "ggplot"){i <- "ggplot2"}
  if(i != "(unknown)"){
  pasting <<- paste0(pasting, c(paste0("if(!(require(",i,"))){"," \n ", 
               "install.packages(",i,") \n ", 
               "(require(",i,"))} \n ")))}}

}

writeLines(pasting, "my_file1.txt")

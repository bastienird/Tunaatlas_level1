comparison_each_step <- function(entity, config, options){
  
  #create and load metadata table with entities as dataframe
  if(dir.exists("Markdown")){
    # Msg <- "Creating comparison for each step"
    # config$logger.info(Msg)

  nominal_dataset <- readr::read_csv("data/global_nominal_catch_firms_level0.csv")
  
  if(!require(readtext)){
    install.packages("readtext")
    require(readtext)
  }
  if(!require(ggplot2)){
    install.packages("ggplot2")
    require(ggplot2)
  }
  if(!require(patchwork)){
    install.packages("patchwork")
    require(patchwork)
  }
  if(!require(hrbrthemes)){
    install.packages("hrbrthemes")
    require(hrbrthemes)
  }
  
  if(!(is.null(options$species_filter))){nominal <- sum((nominal_dataset %>% 
                                                          filter(species %in% options$species_filter))$value)
  } else {nominal <- sum(nominal_dataset$value)}
  
  con_database <- config$software$output$dbi
  user_database <- config$software$output$dbi_config$parameters$user

  
    # list_dir <- list.dirs(path ="Markdown")
    # list <- c()
    # for (sub_list_dir in list_dir[-1]){
      # list_options <- read_csv(paste0(sub_list_dir,"/list_options.csv"))
      #     assign(paste0(tail(str_split(paste0(sub_list_dir),"/")[[1]],n=1), "list_options"), list_options, envir = .GlobalEnv)
      # print(sub_list_dir)
      sub_list_dir_2 <- list.dirs(path =paste0(getwd(),"/Markdown"), full.names = TRUE, recursive = FALSE)
      details = file.info(paste0(sub_list_dir_2,"/Markdown"))
      details = file.info(sub_list_dir_2)
      details = details[with(details, order(as.POSIXct(mtime))), ]
      sub_list_dir_2 = rownames(details)
      df <- data.frame(matrix(ncol =10, nrow = 1))
      colnames(df) <- c(paste0(tail(str_split(paste0(sub_list_dir_2),"/")[[1]],n=1)),
                        # "Explanation", "Fonctions", 
                        "Options", "Sum in tons", "Sum in number of fish", "Number of lines","Difference (in % of tons)","Difference in tons","Difference (in % of fish)", "Difference (in % of lines)", "Percentage of nominal"
      )
      if((!is.null(options$species_filter))){
        tons_init <- pull(read.csv(paste0(sub_list_dir_2[1],"/sums.csv"))[1])
        lines_init <- pull(read.csv(paste0(sub_list_dir_2[1],"/sums.csv"))[3])
        nofish_init <- pull(read.csv(paste0(sub_list_dir_2[1],"/sums.csv"))[2])} else{
          main <- readRDS(paste0(sub_list_dir_2[1],"/rds.rds")) %>% filter(species%in%options$species_filter)
          tons_init <- sum((main %>% filter(unit%in%c("MTNO", "MT")))$value)
          nofish_init <- sum((main %>% filter(unit%in%c("NOMT", "NO")))$value)
          lines_init <- nrow(main)
        }
      for (i in sub_list_dir_2){
        # sum((nominal_dataset %>% filter(year(time_start) > min(data$year)))$value) filtered only on species presented in georefdataset filte
        # nominal <- 211479421
        #this is not the complete sum o nominal, indeed it is the one between 1950 and 2020
        
        
        sums <- read.csv(paste0(i,"/sums.csv"))
        Explanation <- readtext(paste0(i,"/explication.txt"))[2]
        Fonctions <- pull(readtext(paste0(i,"/fonctions.txt"))[2])
        if (file.exists(paste0(i,"/options.txt"))){
          Options <- pull(readtext(paste0(i,"/options.txt"))[2])} else {Options <- "Aucune"}
        if(!is.null(options$species_filter)){
          main <- readRDS(paste0(i,"/rds.rds")) %>% filter(species%in%options$species_filter)
          sum_t <- sum((main %>% filter(unit%in%c("MTNO", "MT")))$value)
          sum_no <- sum((main %>% filter(unit%in%c("NOMT", "NO")))$value)
          nrow <- nrow(main)
          
        } else{sum_t <- pull(sums[1])
        sum_no <-  pull(sums[2])
        nrow <- pull(sums[3])}
        
        step <- tail(str_split(paste0(i),"/")[[1]],n=1)
        loss_percent <- 100*((tons_init - sum_t)/tons_init)
        loss_tons <- (tons_init - sum_t)
        loss_percent_lines <- 100*((lines_init - nrow)/lines_init)
        loss_percent_no <- 100*((nofish_init - sum_no)/nofish_init)
        percentage_of_nominal <- (sum_t*100)/nominal
        sums <- as.data.frame(data.frame(sum_t, sum_no, nrow))
        data_i <- cbind(step,
                        # Explanation, Fonctions, 
                        Options,
                        sums, loss_percent,loss_tons,loss_percent_no, loss_percent_lines, percentage_of_nominal)
        names(data_i) <- colnames(df)
        df <- rbind(df, data_i)
        tons_init <- sum_t
        nofish_init <- sum_no
        lines_init <- nrow
        
      }
      df = df[-1,]
      write_csv(df, paste0(getwd(),"/table.csv"))
      

      FitFlextableToPage <- function(ft, pgwidth = 6,options_format ="Rmd"){
        table <- flextable(ft) %>% autofit() %>% fit_to_width(30)
        
        table %>% 
          color(~ `Difference (in % of tons)` < 0, color = "green",~ `Difference (in % of tons)`) %>% 
          color(~ `Difference (in % of tons)` >0, color = "red",~ `Difference (in % of tons)`)%>% 
          colformat_num(col_keys = c("`Difference (in % of fish)`"), digits = 2) %>%   color(~ `Difference (in % of fish)` < 0, color = "green",~ `Difference (in % of fish)`) %>% 
          color(~ `Difference (in % of fish)` >0, color = "red",~ `Difference (in % of fish)`)%>% 
          colformat_num(col_keys = c("`Difference (in % of lines)`"), digits = 2) %>%color(~ `Difference (in % of lines)` < 0, color = "green",~ `Difference (in % of lines)`) %>% 
          color(~ `Difference (in % of lines)` >0, color = "red",~ `Difference (in % of lines)`)%>% 
          colformat_num(col_keys = c("`Difference (in % of lines)`"), digits = 2)
        if(options_format == "Rmd"){table%>% flextable_to_rmd()}else{table}
        
      }
      save_as_image(FitFlextableToPage(df), path = paste0(getwd(),"/table.png"), webshot = "webshot")
      # assign(paste0(tail(str_split(paste0(sub_list_dir),"/")[[1]],n=1)), df, envir = .GlobalEnv)
      # list <- append(list,tail(str_split(paste0(sub_list_dir),"/")[[1]],n=1))
      
      

      reduced <- df %>% select(Step = global_catch_1deg_1m_ps_bb_firms_Bastien_filtering_wcpfc_at_the_end_level0, `Sum in tons`, `Sum in number of fish`, `Number of lines`)%>% mutate(Step_number = as.numeric(row_number()))
      reduced$Step <- factor(reduced$Step, levels = (reduced %>% arrange(Step_number))$Step)
      

      coeff <- 3
      temperatureColor <- "#69b3a2"
      
      priceColor <- rgb(0.2, 0.6, 0.9, 1)
      ggplot(reduced,aes(x = Step,group = 1))+ 
        geom_line( aes(y=`Sum in tons` ,group = 1), size=0.5, color=priceColor)+geom_point( aes(y=`Sum in tons` ,group = 1)) +
        geom_line( aes(y=`Sum in number of fish`/ coeff,group = 1), size=0.5, color=temperatureColor)+geom_point( aes(y=`Sum in number of fish`/ coeff))  +
        
        scale_y_continuous(
          
          # Features of the first axis
          name = "Tons",
          
          # Add a second axis and specify its features
          sec.axis = sec_axis(~.*coeff, name="Number of fish")
        ) + 
        
        
        
        theme(
          axis.title.y = element_text(color = priceColor, size=8),
          axis.title.y.right = element_text(color = temperatureColor, size=8)
        ) +
        
        ggtitle("Evolution of the repartition of captures depending on units and Steps")+
        theme(axis.text.x = element_text(angle = 90))
      ggsave(paste0(getwd(),"/myplot.png"))
      no_fish <- ggplot(reduced,aes(x = Step,group = 1)) +
        geom_line( aes(y=`Sum in number of fish`,group = 1), size=0.5)+
        
        theme(axis.text.x = element_text(angle = 90))
      
      tons <- ggplot(reduced,aes(x = Step,group = 1)) +
        geom_line( aes(y=`Sum in tons`,group = 1), size=0.5)+
        
        
        theme(axis.text.x = element_text(angle = 90))
      library(cowplot)
      cowplot::plot_grid(tons, no_fish)
      ggsave(paste0(getwd(),"/myplot2.png"))
    }
    
# 
#   }
}
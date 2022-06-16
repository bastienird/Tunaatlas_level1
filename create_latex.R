# rmarkdown::pandoc_convert(
#   "~/Documents/Tunaatlas_level1/oitc_conversion_factors.knit.md",
#   to = "latex",
#   output = "out.tex",
#   options = "--standalone"
# )
create_latex <- function(x){
  wd <- getwd()
rmarkdown::render(paste0(wd,"/", x), output_format = "latex_document")
tex <- gsub(".Rmd", ".tex", x)
system(paste0( "cd ", wd, ";pdflatex ", tex), intern = FALSE,
       ignore.stdout = FALSE, ignore.stderr = FALSE,
       wait = TRUE, input = NULL, show.output.on.console = TRUE,
       minimized = FALSE, invisible = TRUE, timeout = 0)
}

create_latex("oitc_conversion_factors.Rmd")
create_latex("etude_overlap.Rmd")
create_latex("backupabsurd.Rmd")

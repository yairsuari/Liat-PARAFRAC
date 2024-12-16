
### EEM modifier script ###

# This script modify the csv files from the Jasco FP-8350 spectrofluorometer to a template that the function staRdom::eem_read demands.

library(tidyverse)

# Set the base directory where your files are located

setwd(dir = "C:/Users/lenovo/Documents/Phd/Chapter 3/FDOM/November2023_Red_sea/20241029/EEM")
base_dir = getwd()

# Import all file names into a list - make sure the pattern is: "\\.csv$"
file_list <- list.files(path = base_dir, pattern = "\\.csv$")

# Iterate through each file, skip the instrument header information, and write back to CSV
for (file in file_list) {
  # Read the CSV file, skipping the first 17 rows
  data <- read_csv(file.path(file), skip = 17, col_names = F)
  
  # Write the modified data back to a CSV file with "_modified" appended to the name
  write_csv(data, file.path(paste0(tools::file_path_sans_ext(file), ".csv")), col_names = F)
}




# get the name for each csv file created in the exportfolder
eemfiles1 <- list.files(path = exportfolder, pattern = '\\.csv$', full.names = F)

# loop to combine all eems in export folder into a single long-format df:
for (i in eemfiles1){
  eem_long<- read.csv(paste0(exportfolder,i), check.names = F)%>%
    pivot_longer(cols = -em, names_to = "ex",  values_to = gsub(pattern=".csv",replacement="", x=i))%>%
    mutate(ex=as.numeric(ex))
  if (i==eemfiles[1]){eemlist_df<-  eem_long }else{
    eemlist_df<- merge.data.frame(eemlist_df,eem_long, by=c("ex","em"))
  }
  if(i==eemfiles[length(eemfiles)]){ rm(eem_long,i,eemfiles)}
}
eemlist_df
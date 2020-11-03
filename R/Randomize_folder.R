## Randomizer of files in a folder
## Filenames are exchanged with random numbers, corresponding names are saved in a csv-File
## Original files are moved to "Originals" subfolder

## caution: randomizes all files in the specified folder, irrespective of file-type > clean up before use
## Version 0.2 : random name without replacement > no accidentally identical names


randomize_folder<- function() {
  # General settings & libraries
  rm(list = ls()) # Clear workspace
  library(tools)
  library(tcltk)
  
  setwd("~")
  dir <- tclvalue(tkchooseDirectory())
  
  setwd(dir)
  files <- data.frame(NA, list.files(dir))
  colnames(files) <- c("Random_Name", "Original_Name")
  dir.create("Originals")
  index <- sample(1:nrow(files), nrow(files), replace = F)
  
  for (i in 1:nrow(files)) {
    file.copy(paste(dir, "\\", files[i, 2], sep = ""), paste(dir, "\\Originals", sep = ""))
    ex <- file_ext(files[i, 2])
    temp <- paste(index[[i]], ex, sep = ".")
    file.rename(paste(dir, "\\", files[i, 2], sep = ""), paste(dir, "\\", temp, sep = ""))
    files[i, 1] <- temp
  }
  
  
  write.table(files, "Randomization.csv", row.names = F, quote = F, sep = ";", dec = ".")
}

File_randomizer()

## Standard import & preliminary analysis script for multiple results files from ImageJ
##
##
## Results in .csv-format, additional Group-identifying txt-file (Groups.txt)
##
## best used in an RStudio Project in the results-folder
##
##
## requires tidyverse, beeswarm and vroom packages
##
## example: Colocalization-results produced by EzColoc_SemiManual.ijm in this repo
##
## Oct 2020 Joachim Fuchs



library(tidyverse)
library(ggbeeswarm)
library(vroom)


my_theme <- function() {
  theme_minimal() + theme(legend.position = "none", plot.title.position = "plot")
}
theme_set(my_theme())


# Change pattern to file format of results files
# also make sure to be specific enough to exclude unrelated files of same file-format in the folder
dirlist <- list.files(pattern = ".csv$")

# loads all files at once
all_cells <- vroom::vroom(dirlist, id = "Image_ID")


groups <- read_delim("Groups.txt", delim = "\t") %>% 
  mutate(Group = fct_relevel(Group, labels = c("PRG2-Flag", "PRG2-dpE-Flag")))  


# combine Groups and Results-file and some data cleaning
all_cells_clean <- all_cells %>% 
  separate(Image_ID, sep = "_", into = c("Image", "Channel")) %>% 
  extract(Channel, regex = "(.+).csv$", into = "Comparison") %>% 
  dplyr::select(Image:Area & !Label) %>% 
  mutate(Comparison = fct_recode(Comparison, "DCC-Actin" = "1-2", "DCC-PRG2" = "1-4", "Actin-PRG2" = "2-4")) %>% 
  left_join(groups, by = "Image")


# Comparison stats graph TOS (more interesting: Mean and Error bars)
all_cells_clean %>% 
  ggplot(aes(x = Group, y = `TOS(linear)`, color = Group)) + 
  geom_quasirandom() + 
  facet_wrap(~ Comparison) +
  stat_summary(fun = mean, geom = "crossbar", color = "black", width = 0.6, size = 0.5) + 
  stat_summary(fun.data = "mean_se", geom = "errorbar", color = "black", width = 0.4, size = 0.3) + 
  labs(title = "Colocalization of DCC vs. F-actin vs. PRG2-Flag",
       subtitle = "TOS as a measure of fractional overlap") +
  scale_color_brewer(palette = "Set1")


# Signal intensities scatter plot
all_cells_clean %>% 
  ggplot(aes(x = Avg.Int.C1, y = Avg.Int.C2, color = Group)) + 
  geom_point() + 
  facet_wrap(~ Comparison) +
  stat_summary(fun = mean, geom = "crossbar", color = "black", width = 0.6, size = 0.5) + 
  stat_summary(fun.data = "mean_se", geom = "errorbar", color = "black", width = 0.4, size = 0.3) + 
  labs(title = "Colocalization of DCC vs. F-actin vs. PRG2-Flag",
       subtitle = "") +
  geom_smooth(method = "lm") +
  coord_fixed() +
  scale_color_brewer(palette = "Set1")

# Coloc as PCC
all_cells_clean %>% 
  ggplot(aes(x = Group, y = `PCC`, color = Group)) + 
  geom_quasirandom() + 
  facet_wrap(~ Comparison) +
  stat_summary(fun = mean, geom = "crossbar", color = "black", width = 0.6, size = 0.5) + 
  stat_summary(fun.data = "mean_se", geom = "errorbar", color = "black", width = 0.4, size = 0.3) + 
  labs(title = "Colocalization of DCC vs. F-actin vs. PRG2-Flag",
       subtitle = "PCC as a measure of signal correlation") +
  scale_color_brewer(palette = "Set1")


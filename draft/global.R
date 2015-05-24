require(shiny)
require(ggplot2)
require(scales)
require(gtable)
require(grid)

# set the working directory
# setwd("/Volumes/Data Science/Google Drive/learning_data_science/Coursera/developing_data_prodcts/draft/")

# load the life table 
df_life_male <- read.csv("data/life_table_aus_2013_male.csv")
df_life_male_bmi_40 <- read.csv("data/life_table_aus_male_bmi_40.csv")
df_life_male_bmi_18 <- read.csv("data/life_table_aus_male_bmi_18.csv")

df_life_female <- read.csv("data/life_table_aus_2013_female.csv")
df_life_female_bmi_40 <- read.csv("data/life_table_aus_female_bmi_40.csv")
df_life_female_bmi_18 <- read.csv("data/life_table_aus_female_bmi_18.csv")

# clean up the data
df_life_male <- data.frame(apply(df_life_male, 2, function (x) as.numeric(gsub(",", "", x))))
df_life_female <- data.frame(apply(df_life_female, 2, function (x) as.numeric(gsub(",", "", x))))

# add the mortality rate
df_life_male$mx <- round((df_life_male$lx * df_life_male$qx) / df_life_male$Lx, 5)
df_life_female$mx <- round((df_life_female$lx * df_life_female$qx) / df_life_female$Lx, 5)

# add gender into each df
df_life_male$gender <- factor("male")
df_life_male_bmi_40$gender <- factor("male")
df_life_male_bmi_18$gender <- factor("male")

df_life_female$gender <- factor("female")
df_life_female_bmi_40$gender <- factor("female")
df_life_female_bmi_18$gender <- factor("female")

# add bmi into each df
df_life_male$bmi <- factor("normal")
df_life_male_bmi_40$bmi <- factor("over")
df_life_male_bmi_18$bmi <- factor("short")

df_life_female$bmi <- factor("normal")
df_life_female_bmi_40$bmi <- factor("over")
df_life_female_bmi_18$bmi <- factor("short")

# combine them together
df_life <- rbind(df_life_female, df_life_male, df_life_male_bmi_40, df_life_male_bmi_18, df_life_female_bmi_40, df_life_female_bmi_18)

# if mx >= 1 then 1
df_life$mx <- ifelse(df_life$mx >= 1, 1, df_life$mx)

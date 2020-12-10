# In this file, write the R-code necessary to load your original data file
# (e.g., an SPSS, Excel, or SAS-file), and convert it to a data.frame. Then,
# use the function open_data(your_data_frame) or closed_data(your_data_frame)
# to store the data.

library(worcs)

# Load data

# df <- ...
source("fake_data.R")
# Recode missing data

# Missing Values 
# 
# 
# The dataset contains missing values for the following variables: 
#   ● wb_soc_3 995 missing (did not want to disclose) 
df$wb_soc_3[which(df$wb_soc_3 == 995)] <- NA
# ● age 27 missing 
df$age[which(df$age == 27)] <- NA
# ● ses 5 missing 
df$ses[which(df$ses == 5)] <- NA
# ● ethnicity 409 missing (in France, this question was not asked due to legal 
#                          restrictions; no missing values in other countries)  
df$ethnicity[which(df$ethnicity == 409)] <- NA
# ● denomination 5676 missing (this was only asked when participants indicated to 
#                              belong to a religious denomination [rel_4]) 
df$denomination[which(df$denomination == 5676)] <- NA
# There are no missing data for the remaining variables.  


# Not religious and atheist same for present purposes
df$rel_3[which(df$rel_3 %in% c(2, 3))] <- 0
# Recode to dummy
df$rel_4[which(df$rel_4 %in% c(2))] <- 0

# Set gender == other to NA, because number is likely to low to use as additional moderator
df$gender[which(df$gender == 3)] <- NA

# For each country, determine the majority ethnicity
majority <- tapply(df$ethnicity, df$country, function(x){
  tab <- table(x)
  names(tab)[which.max(tab)]
})
# Create variable to use in analysis: Is the participant part of the majority ethnicity in their country?
df$majority <- as.numeric(df$ethnicity == majority[df$country])

closed_data(df)
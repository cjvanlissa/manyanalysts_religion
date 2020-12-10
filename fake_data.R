set.seed(3634)
n <- 10535
countries <- 24

df <- data.frame(subject = 1:n)

coun <- as.numeric(substring(as.character(abs(rnorm(n))*100),1,2))
keep <- unique(coun)[1:countries]
df$country <- findInterval(coun, sort(keep)[-24]) + 1
table(df$country)


# Religiosity 
# Personal religiosity was measured with 9 items. All items have been reverse-coded and 
# transformed onto a 0-1 scale, with 0 indicating low religiosity to 1 indicating high religiosity. 
# Values in round brackets () give the original response scale, [R] indicates that the item was 
# originally contra-indicative and has been reverse-coded.  
# 3. rel_1 frequency of service attendance (1-7) [R] 
# 4. rel_2 frequency of prayer (1-8) [R] 
# 5. rel_3 self-identification (1= religious, 2= not religious, 3=atheist) [R] 
# 6. rel_4 belong to denomination (1=yes, 2=no) [R] 
# 7. rel_5 belief in God/Gods (1-7) 
# 8. rel_6 belief in afterlife (1-7) 
# 9. rel_7 spirituality (1-7) 
# 10. rel_8 importance of religious lifestyle (1-5) 
# 11. rel_9 importance of belief in God/Gods (1-5)

df$rel_1 <- scale(sample.int(7, n, replace = TRUE))
df$rel_2 <- scale(sample.int(8, n, replace = TRUE))
df$rel_3 <- scale(sample.int(3, n, replace = TRUE))
df$rel_4 <- scale(sample.int(2, n, replace = TRUE))
df$rel_5 <- scale(sample.int(7, n, replace = TRUE))
df$rel_6 <- scale(sample.int(7, n, replace = TRUE))
df$rel_7 <- scale(sample.int(7, n, replace = TRUE))
df$rel_8 <- scale(sample.int(5, n, replace = TRUE))
df$rel_9 <- scale(sample.int(5, n, replace = TRUE))


# Cultural Norms of Religiosity  
# Perceived cultural norms of religiosity were measured with 2 items. Both items are transformed 
# onto a 0-1 scale, with 0 indicating low perceived cultural importance of religiosity and 1 
# indicating high perceived cultural importance of religiosity. Values in round brackets () give the original response scale. 
# 12. cnorm_1  importance of religious lifestyle for average person in country (1-5) 
# 13. cnorm_2 importance of belief in God/Gods for average person in country (1-5) 
df$cnorm_1 <- scale(sample.int(5, n, replace = TRUE))
df$cnorm_2 <- scale(sample.int(5, n, replace = TRUE))



# Well-Being  
# Well-being was measured with 18 items using a 1-5 response scale, with 1 indicating low 
# well-being and 5 indicating high well-being. The scale consists of 2 general well-being items, 7 
# physical well-being items, 6 psychological well-being items, and 3 social well-being items. [R] 
# indicates that the item was originally contra-indicative and has been reverse-coded.  
df$wb_gen_1 <- sample.int(5, n, replace = TRUE) # 14.  wb_gen_1 quality of life general 
df$wb_gen_2 <- sample.int(5, n, replace = TRUE) # 15.  wb_gen_2 satisfaction with health 


df$wb_phys_1 <- sample.int(5, n, replace = TRUE) # 16.  wb_phys_1 pain [R] 
df$wb_phys_2 <- sample.int(5, n, replace = TRUE) # 17.  wb_phys_2 medical dependence [R] 
df$wb_phys_3 <- sample.int(5, n, replace = TRUE) # 18.  wb_phys_3 energy 
df$wb_phys_4 <- sample.int(5, n, replace = TRUE) # 19.  wb_phys_4 mobility 
df$wb_phys_5 <- sample.int(5, n, replace = TRUE) # 20.  wb_phys_5 sleep 
df$wb_phys_6 <- sample.int(5, n, replace = TRUE) # 21.  wb_phys_6 activities 
df$wb_phys_7 <- sample.int(5, n, replace = TRUE) # 22.  wb_phys_7 work ability 
df$wb_psych_1 <- sample.int(5, n, replace = TRUE) # 23.  wb_psych_1 enjoying life 
df$wb_psych_2 <- sample.int(5, n, replace = TRUE) # 24.  wb_psych_2 meaningfulness 
df$wb_psych_3 <- sample.int(5, n, replace = TRUE) # 25.  wb_psych_3 concentration 
df$wb_psych_4 <- sample.int(5, n, replace = TRUE) # 26.  wb_psych_4 satisfaction physical appearance 
df$wb_psych_5 <- sample.int(5, n, replace = TRUE) # 27.  wb_psych_5 self-esteem 
df$wb_psych_6 <- sample.int(5, n, replace = TRUE) # 28.  wb_psych_6 negative affect [R] 
df$wb_soc_1 <- sample.int(5, n, replace = TRUE) # 29.  wb_soc_1 personal relations 
df$wb_soc_2 <- sample.int(5, n, replace = TRUE) # 30.  wb_soc_2 social support 
df$wb_soc_3 <- sample.int(5, n, replace = TRUE) # 31.  wb_soc_3 sexual satisfaction (note: NA indicates not disclosed) 

# 32. wb_overall_mean average of all 18 well-being items 
# 33. wb_phys_mean average of physical well-being subscale 
# 34. wb_psych_mean average of psychological well-being subscale 
# 35. wb_soc_mean average of social well-being subscale 
# 


#Demographics  
df$age <- round(runif(n, 18, 80)) #36. age age in numbers
df$gender <- sample.int(3, n, replace= TRUE, prob = c(.495, .495, .01)) #36. age age in numbers 
#37. gender (1=man, 2=woman, 3=other) 
df$ses <- sample.int(10, n, replace = TRUE) #38. ses subjective socioeconomic status as ladder (1 = bottom, 10 = top) 
df$education <- sample.int(7, n, replace = TRUE)#39. education education in levels (largely equivalent across samples; 1-7, 1 indicating the lowest level of education, 7 indicting the highest level of education) 
df$ethnicity <- sample.int(17, n, replace = TRUE) #40. ethnicity ethnicity (different per sample; 17 categories) 
#41. denomination if indicated member of religious denomination (different per sample; 20 categories) 
df$denomination <- sample.int(40, n, replace = TRUE)



#Additional Study Details 
df$gdp <- runif(countries, 10000, 100000)[df$country]#42. gdp gross domestic product per capita (in US$, data from 2017; country-level) 
df$gdp_scaled <- scale(df$gdp) # 43. gdp_scaled GDP standardized across the 24 countries (country-level) 


df$sample_type <- sample(c("gp", "students", "online", "mixed"), n, replace = TRUE) # 44. sample_type type of sample (general public, students, online panel, mixed) 
df$sample_type <- sample(c("credit", "money", "none", "raffle", "mixed"), n, replace = TRUE) #45. compensation participant reward (course credit, money, no compensation, raffle, mixed) 
df$attention_check <- sample.int(2, n, prob = c(.9, .1), replace = TRUE)#46. attention_check attention check (1=passed) 


rm(coun, countries, keep, n)


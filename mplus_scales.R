# The models below are subject to changes - only when using the training data
library(tidySEM)
library(MplusAutomation)
run_scale_models <- TRUE
df_score <- df
dict <- tidy_sem(df)
dict$dictionary$scale[c(5:6, 32:47)] <- NA
dict$dictionary$scale <- gsub("^wb_(gen|phys|psych|soc)$", "well", dict$dictionary$scale)
scalescores <- tidySEM::create_scales(dict)
scalescores <- scale(scalescores$scores, scale = FALSE)
df_score <- cbind(df_score, scalescores)
df_score$int <- df_score$rel * df_score$cnorm

if(run_scale_models | !file.exists("m1_scale.out")){
  syn_m1_scale <- c(
    "%WITHIN%",
    "well ON age;",
    "well ON gender;",
    "well ON ses;",
    "well ON education;",
    "well ON majority;",
    "%BETWEEN%",
    "[well];"
  )
  #298705.124
  m1_scale <- mplusObject(TITLE = "M1_scale",
                          VARIABLE = paste0(c(
                            "WITHIN = age gender ses education majority",
                            ";",
                            "CLUSTER IS country;"
                          ), collapse = "\n"),
                          ANALYSIS = c("TYPE = TWOLEVEL RANDOM;"
                          ),
                          MODEL = syn_m1_scale,
                          #OUTPUT = "stdyx;",
                          rdata = df_score)
  res_m1_scale <- mplusModeler(m1_scale, modelout = "m1_scale.inp", run = 1L)$results
} else {
  res_m1_scale <- readModels("m1_scale.out")
}

if(run_scale_models | !file.exists("m2_scale.out")){
  syn_m2_scale <- c(
    "%WITHIN%",
    "sreli | well ON rel;",
    "snorm | well ON cnorm;",
    "well ON age;",
    "well ON gender;",
    "well ON ses;",
    "well ON education;",
    "well ON majority;",
    
    "%BETWEEN%",
    "[well];",
    "[sreli];",
    "[snorm];",
    "sreli;",
    "snorm;"
  )
  
  m2_scale <- mplusObject(TITLE = "M2_scale",
                          VARIABLE = paste0(c(
                            "WITHIN = age gender ses education majority",
                            "rel",
                            "cnorm",
                            ";",
                            "CLUSTER IS country;"
                          ), collapse = "\n"),
                          ANALYSIS = c("TYPE = TWOLEVEL RANDOM;"),
                          MODEL = syn_m2_scale,
                          rdata = df_score)
  
  res_m2_scale <- mplusModeler(m2_scale, modelout = "m2_scale.inp", run = 1L)$results
} else {
  res_m2_scale <- readModels("m2_scale.out")
}

if(run_scale_models | !file.exists("m2fx_scale.out")){
  syn_m2fx_scale <- c(
    "%WITHIN%",
    "sreli | well ON rel;",
    "snorm | well ON cnorm;",
    "well ON age;",
    "well ON gender;",
    "well ON ses;",
    "well ON education;",
    "well ON majority;",
    
    "%BETWEEN%",
    "[well];",
    "[sreli];",
    "[snorm];",
    "sreli@0;",
    "snorm@0;"
  )
  
  m2fx_scale <- mplusObject(TITLE = "M2fx_scale",
                            VARIABLE = paste0(c(
                              "WITHIN = age gender ses education majority",
                              "rel",
                              "cnorm",
                              ";",
                              "CLUSTER IS country;"), collapse = "\n"
                            ),
                            ANALYSIS = c("TYPE = TWOLEVEL RANDOM;"),
                            MODEL = syn_m2fx_scale,
                            rdata = df_score)
  
  res_m2fx_scale <- mplusModeler(m2fx_scale, modelout = "m2fx_scale.inp", run = 1L)$results
} else {
  res_m2fx_scale <- readModels("m2fx_scale.out")
}

if(run_scale_models | !file.exists("m3_scale.out")){
  syn_m3_scale <- c(
    "%WITHIN%",
    "sreli | well ON rel;",
    "snorm | well ON cnorm;",
    "sint | well ON int;",
    "well ON age;",
    "well ON gender;",
    "well ON ses;",
    "well ON education;",
    "well ON majority;",
    
    "%BETWEEN%",
    "[well];",
    "[sreli];",
    "[snorm];",
    "[sint];",
    "sreli;",
    "snorm;",
    "sint;"
  )
  
  m3_scale <- mplusObject(TITLE = "M3_scale",
                          VARIABLE = paste0(c(
                            "WITHIN = age gender ses education majority",
                            "rel",
                            "cnorm",
                            "int;",
                            "CLUSTER IS country;"), collapse = "\n"
                          ),
                          ANALYSIS = c("TYPE = TWOLEVEL RANDOM;"),
                          MODEL = syn_m3_scale,
                          OUTPUT = "TECH3;",
                          rdata = df_score)
  
  res_m3_scale <- mplusModeler(m3_scale, modelout = "m3_scale.inp", run = 1L)$results
} else {
  res_m3_scale <- readModels("m3_scale.out")
}

if(run_scale_models | !file.exists("m3fx_scale.out")){
  syn_m3fx_scale <- c(
    "%WITHIN%",
    "sreli | well ON rel;",
    "snorm | well ON cnorm;",
    "sint | well ON int;",
    "well ON age;",
    "well ON gender;",
    "well ON ses;",
    "well ON education;",
    "well ON majority;",
    
    "%BETWEEN%",
    "[well];",
    "[sreli];",
    "[snorm];",
    "[sint];",
    "sreli@0;",
    "snorm@0;",
    "sint@0;"
  )
  
  m3fx_scale <- mplusObject(TITLE = "M3fx_scale",
                            VARIABLE = paste0(c(
                              "WITHIN = age gender ses education majority",
                              "rel",
                              "cnorm",
                              "int;",
                              "CLUSTER IS country;"), collapse = "\n"
                            ),
                            ANALYSIS = c("TYPE = TWOLEVEL RANDOM;"),
                            
                            MODEL = syn_m3fx_scale,
                            rdata = df_score)
  
  res_m3fx_scale <- mplusModeler(m3fx_scale, modelout = "m3fx_scale.inp", run = 1L)$results
} else {
  res_m3fx_scale <- readModels("m3fx_scale.out")
}

results <- mget(grep("^res_.+scale", ls(), value = TRUE))

tmp <- MplusAutomation::SummaryTable(results, sortBy = "Title", keepCols = c("Title", "Parameters", "LL", "LLCorrectionFactor", "AIC", "BIC"), type = "none")

tmp$Title <- gsub("(\\d)_scale", "\\1 free", tmp$Title)
tmp$Title <- gsub("fx_scale", " fixed", tmp$Title)
tmp <- tmp[order(tmp$Parameters), ]
library(ggplot2)
p <- ggplot(data.frame(data.frame(Model = ordered(tmp$Title, levels = tmp$Title),
                                  BIC = tmp$BIC)),
            aes(x = Model, y = BIC)) + geom_path(group = 1) +
  geom_point()  + 
  geom_vline(xintercept = tmp$Title[which.min(tmp$BIC)], linetype = 2) +
  geom_hline(yintercept = tmp$BIC[which.min(tmp$BIC)], linetype = 2) +
  theme_bw()


m <- tmp[1:4, c("Parameters", "LL", "LLCorrectionFactor")]
mp1 <- tmp[2:5, c("Parameters", "LL", "LLCorrectionFactor")]

cd = ((m$Parameters*m$LLCorrectionFactor) - (mp1$Parameters*mp1$LLCorrectionFactor)) / (m$Parameters-mp1$Parameters)
degfree = mp1$Parameters - m$Parameters
TRd = -2*(m$LL - mp1$LL) / cd
tmp$LR_p <- c(NA, formatC(pchisq(TRd, degfree, lower.tail = FALSE), digits = 3, format = "f"))

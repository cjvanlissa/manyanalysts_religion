library(worcs)
library(missRanger)
library(MplusAutomation)
library(tidySEM)
library(tuneRanger)
library(ranger)
library(metaforest)
# Load data
load_data()

# Set aside testing sample for unbiased evaluation of model fit
set.seed(893)
train <- sample(1:nrow(df), size = floor(.70*nrow(df)))
df_test <- df[-train, ]
df <- df[train, ]

# Remove failed attention check
df <- df[df$attention_check == 1, ]

# Impute missings
df <- missRanger(df)

# The models below are subject to changes - only when using the training data
syn_m1 <- c(
  "%WITHIN%",
  "rel BY rel_1-rel_9;",
  "cnorm BY cnorm_1-cnorm_2;",
  "well BY wb_phys_1-wb_phys_7;",
  "well BY wb_psych_1-wb_psych_6;",
  "well BY wb_soc_1-wb_soc_3;",
  "well WITH rel@0;",
  "well WITH cnorm@0;",
  "well ON age;",
  "well ON gender;",
  "well ON ses;",
  "well ON education;",
  "well ON ethnicity;",
  "well ON majority;",
  
  "%BETWEEN%",
  "[sreli];",
  "[snorm];",
  "[sint];",
  "sreli;",
  "snorm;",
  "sint;",
  )

m1 <- mplusObject(TITLE = "M1",
                   VARIABLE = c(
                     "CATEGORICAL = rel_3 rel_4;",
                     "WITHIN = age gender ses education ethnicity majority",
                     "rel_1-rel_9",
                     "cnorm_1-cnorm_2",
                     "wb_phys_1-wb_phys_7",
                     "wb_psych_1-wb_psych_6",
                     "wb_soc_1-wb_soc_3;",
                     "CLUSTER IS clus;"
                   ),
                   ANALYSIS = c("TYPE = TWOLEVEL RANDOM;",
                                "ALGORITHM = INTEGRATION;",
                                "INTEGRATION = 10;"),
                   MODEL = syn_m1,
                   rdata = df)

syn_m1fx <- c(
  "%WITHIN%",
  "rel BY rel_1-rel_9;",
  "cnorm BY cnorm_1-cnorm_2;",
  "well BY wb_phys_1-wb_phys_7;",
  "well BY wb_psych_1-wb_psych_6;",
  "well BY wb_soc_1-wb_soc_3;",
  "well WITH rel@0;",
  "well WITH cnorm@0;",
  "well ON age;",
  "well ON gender;",
  "well ON ses;",
  "well ON education;",
  "well ON ethnicity;",
  "well ON majority;",
  
  "%BETWEEN%",
  "[sreli];",
  "[snorm];",
  "[sint];",
  "sreli@0;",
  "snorm@0;",
  "sint@0;",
)

m1fx <- mplusObject(TITLE = "M1fx",
                  VARIABLE = c(
                    "CATEGORICAL = rel_3 rel_4;",
                    "WITHIN = age gender ses education ethnicity majority",
                    "rel_1-rel_9",
                    "cnorm_1-cnorm_2",
                    "wb_phys_1-wb_phys_7",
                    "wb_psych_1-wb_psych_6",
                    "wb_soc_1-wb_soc_3;",
                    "CLUSTER IS clus;"
                  ),
                  ANALYSIS = c("TYPE = TWOLEVEL RANDOM;",
                               "ALGORITHM = INTEGRATION;",
                               "INTEGRATION = 10;"),
                  MODEL = syn_m1fx,
                  rdata = df)

syn_m2 <- c(
  "%WITHIN%",
  "rel BY rel_1-rel_9;",
  "cnorm BY cnorm_1-cnorm_2;",
  "well BY wb_phys_1-wb_phys_7;",
  "well BY wb_psych_1-wb_psych_6;",
  "well BY wb_soc_1-wb_soc_3;",
  "sreli | well ON rel;",
  "snorm | well ON cnorm;",
  "well ON age;",
  "well ON gender;",
  "well ON ses;",
  "well ON education;",
  "well ON ethnicity;",
  "well ON majority;",
  
  "%BETWEEN%",
  "[sreli];",
  "[snorm];",
  "sreli;",
  "snorm;"
)

m2 <- mplusObject(TITLE = "M2",
                  VARIABLE = c(
                    "CATEGORICAL = rel_3 rel_4;",
                    "WITHIN = age gender ses education ethnicity majority",
                    "rel_1-rel_9",
                    "cnorm_1-cnorm_2",
                    "wb_phys_1-wb_phys_7",
                    "wb_psych_1-wb_psych_6",
                    "wb_soc_1-wb_soc_3;",
                    "CLUSTER IS clus;"
                  ),
                  ANALYSIS = c("TYPE = TWOLEVEL RANDOM;",
                               "ALGORITHM = INTEGRATION;",
                               "INTEGRATION = 10;"),
                  MODEL = syn_m2,
                  rdata = df)

syn_m2fx <- c(
  "%WITHIN%",
  "rel BY rel_1-rel_9;",
  "cnorm BY cnorm_1-cnorm_2;",
  "well BY wb_phys_1-wb_phys_7;",
  "well BY wb_psych_1-wb_psych_6;",
  "well BY wb_soc_1-wb_soc_3;",
  "sreli | well ON rel;",
  "snorm | well ON cnorm;",
  "well ON age;",
  "well ON gender;",
  "well ON ses;",
  "well ON education;",
  "well ON ethnicity;",
  "well ON majority;",
  
  "%BETWEEN%",
  "[sreli];",
  "[snorm];",
  "sreli@0;",
  "snorm@0;"
)

m2fx <- mplusObject(TITLE = "M2fx",
                  VARIABLE = c(
                    "CATEGORICAL = rel_3 rel_4;",
                    "WITHIN = age gender ses education ethnicity majority",
                    "rel_1-rel_9",
                    "cnorm_1-cnorm_2",
                    "wb_phys_1-wb_phys_7",
                    "wb_psych_1-wb_psych_6",
                    "wb_soc_1-wb_soc_3;",
                    "CLUSTER IS clus;"
                  ),
                  ANALYSIS = c("TYPE = TWOLEVEL RANDOM;",
                               "ALGORITHM = INTEGRATION;",
                               "INTEGRATION = 10;"),
                  MODEL = syn_m2fx,
                  rdata = df)


syn_m3 <- c(
  "%WITHIN%",
  "rel BY rel_1-rel_9;",
  "cnorm BY cnorm_1-cnorm_2;",
  "well BY wb_phys_1-wb_phys_7;",
  "well BY wb_psych_1-wb_psych_6;",
  "well BY wb_soc_1-wb_soc_3;",
  "int | rel XWITH cnorm;",
  "sreli | well ON rel;",
  "snorm | well ON cnorm;",
  "sint | well ON int;",
  "well ON age;",
  "well ON gender;",
  "well ON ses;",
  "well ON education;",
  "well ON ethnicity;",
  "well ON majority;",
  
  "%BETWEEN%",
  "[sreli];",
  "[snorm];",
  "[sint];",
  "sreli;",
  "snorm;",
  "sint;",
)

m3 <- mplusObject(TITLE = "M3",
                  VARIABLE = c(
                    "CATEGORICAL = rel_3 rel_4;",
                    "WITHIN = age gender ses education ethnicity majority",
                    "rel_1-rel_9",
                    "cnorm_1-cnorm_2",
                    "wb_phys_1-wb_phys_7",
                    "wb_psych_1-wb_psych_6",
                    "wb_soc_1-wb_soc_3;",
                    "CLUSTER IS clus;"
                  ),
                  ANALYSIS = c("TYPE = TWOLEVEL RANDOM;",
                               "ALGORITHM = INTEGRATION;",
                               "INTEGRATION = 10;"),
                  MODEL = syn_m3,
                  rdata = df)

syn_m3fx <- c(
  "%WITHIN%",
  "rel BY rel_1-rel_9;",
  "cnorm BY cnorm_1-cnorm_2;",
  "well BY wb_phys_1-wb_phys_7;",
  "well BY wb_psych_1-wb_psych_6;",
  "well BY wb_soc_1-wb_soc_3;",
  "int | rel XWITH cnorm;",
  "sreli | well ON rel;",
  "snorm | well ON cnorm;",
  "sint | well ON int;",
  "well ON age;",
  "well ON gender;",
  "well ON ses;",
  "well ON education;",
  "well ON ethnicity;",
  "well ON majority;",
  
  "%BETWEEN%",
  "[sreli];",
  "[snorm];",
  "[sint];",
  "sreli@0;",
  "snorm@0;",
  "sint@0;",
)

m3fx <- mplusObject(TITLE = "M3fx",
                  VARIABLE = c(
                    "CATEGORICAL = rel_3 rel_4;",
                    "WITHIN = age gender ses education ethnicity majority",
                    "rel_1-rel_9",
                    "cnorm_1-cnorm_2",
                    "wb_phys_1-wb_phys_7",
                    "wb_psych_1-wb_psych_6",
                    "wb_soc_1-wb_soc_3;",
                    "CLUSTER IS clus;"
                  ),
                  ANALYSIS = c("TYPE = TWOLEVEL RANDOM;",
                               "ALGORITHM = INTEGRATION;",
                               "INTEGRATION = 10;"),
                  MODEL = syn_m3fx,
                  rdata = df)


# Once models are finalized, evaluate the set on only the testing data.
# Then, compute fit indices and likelihood ratio tests on the results of the
# testing data.
MplusAutomation::SummaryTable()
tidySEM:::SB_chisq_Pvalues()

# Select the definitive model, then evaluate that model on the full dataset
# and perform inference.

# Random forests ----------------------------------------------------------

df_rf <- df
names(df_rf) <- gsub("^([a-z]+)_([a-z]+)$", "\\1\\2", names(df_rf))
dict <- tidySEM::tidy_sem(df_rf)
dict$dictionary$scale <- gsub("^(wb)_.*$", "wb", dict$dictionary$scale)

scales <- create_scales(dict)
df_rf <- cbind(df_rf, scales$scores)
names(df_rf)
df_rf[grepl("((rel|wb|cnorm)_|gdp|attention|subject)", names(df_rf))] <- NULL
df_rf <- df_rf[c("wb", names(df_rf)[!names(df_rf) == "wb"])]
set.seed(6983)
conv <- ranger(as.formula(paste0("wb ~ ", paste0(names(df_rf)[!names(df_rf) == "wb"], collapse = " + "))),  df_rf, num.trees = 5000)
plot(conv, data = df_rf)
task <- makeRegrTask(data = df_rf, target = "wb")

# Tuning
tune <- tuneRanger(task, num.trees = 100, num.threads = 2, iters = 70, save.file.path = NULL, parameters = list(replace = FALSE, respect.unordered.factors = "order", importance = "permutation"))

final <- tune$model$learner.model
metaforest::VarImpPlot(final)
PartialDependence(final, data = df_rf)

PartialDependence(final, vars = "rel", moderator = "cnorm", data = df_rf)
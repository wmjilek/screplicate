#Replication of Bruhn et al. Estimating the population -level impact of vaccines using synthetic controls
#Summer 2018
#Wendy Jilek

setwd("~/Documents/Dissertation/Synthetic Controls")

#This is the analysis file. The functions are contained in synthetic_control_functions.R
#There are six model variants: 
# *_offset - Simple pre-post analysis using the specified variable (e.g., non-respiratory hospitalization or population size) as an offset term (denominator). This is Model 1 from the paper.
# *_full - This is the full synthetic control model with all covariates.
# *_noj - This is the synthetic control model with bronchitis/bronchiolitis removed.
# *_ach - This is similar to _offset, but the specified variable is used as the sole covariate.
# *_none - No covariate or offsest.
# *_time - Trend adjustment with the same denominator as used in the _offset model.

rm(list = ls(all = TRUE)) #Clear workspace
gc() #report on memory usage

install.packages('devtools')
library(devtools)
devtools::install_github('google/CausalImpact')

library('parallel', quietly = TRUE)
library('splines', quietly = TRUE)
library('lubridate', quietly = TRUE)
library('CausalImpact', quietly = TRUE)
source('synthetic_control_functions.R')

#Detects number of available cores on computers. Used for parallel processing to speed up analysis.
n_cores <- detectCores()
set.seed(1)
par_defaults <- par(no.readonly = TRUE)

#############################
#                           #
#User-initialized constants.#
#                           #
#############################

country <- 'Brazil'
factor_name <- 'age_group'
date_name <- 'date'
n_seasons <- NULL #12 for monthly, 4 for quarterly, 3 for trimester data.
do_weight_check <- FALSE

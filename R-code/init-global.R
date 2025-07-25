## ****************************************************************************/
##                    Set global configurations
## ****************************************************************************/
## Note: This part need to be checked by the user to ensure variables match with 
## indications mentioned in the Readme file.

## Do the scripts will be run in testing or in normal mode?
testing_mode <- FALSE

## Do the jobs should be run in interactive session?
interactive_session <- FALSE

## Set the main directory
if(!("this.path" %in% installed.packages())){
  install.packages("this.path")
}
proc_dir <- "~/projects/interconnect-publications/meta-lrnr-comp-study"
code_dir <- file.path(proc_dir, "R-code")

## Set your current working directory to "R-code" (setwd("path/to/R-code"))

## Note: If you are in interactive session, you are done with configuration. 
## Otherwise, configure your batchtools system.

## +++++++++++++++++++++++++++++++#
## batchtools' configurations     #
## +++++++++++++++++++++++++++++++#
##
if(!interactive_session){
  ## Provide a configuration and a template file
  ## Example: template <- file.path(code_dir, "batchtools-config/.batchtools.slurm.tmpl")
  config_file <- file.path(code_dir, "batchtools-config/batchtools.conf.R")
  template <- file.path(code_dir, "batchtools-config/.batchtools.slurm.tmpl")
  ##  (e.g. SLURM) Node, partition and account (See batchtools for details)
  nodename <- "login001"
  partition <- "batch"
  account <- "p23048"
} else {
  ## Do not modify this "else" block!
  config_file <- file.path(code_dir, "batchtools-config/batchtools.multicore.R")
  template <- nodename <- partition <- account <- NULL
}
## Batchtools wrapper. Do not motify this line
source(file.path(file.path(code_dir, "functions"),
                 "batchtoolswrapper.R"), chdir = TRUE)

## Set your current working directory to "R-code" and go back to the Readme.
## ********************** End of global configuration *************************/
# install.packages("fuseMLR")
# install.packages("data.table")
# install.packages("ggplot2")
# install.packages("batchtools")
# install.packages("InterSIM")
# install.packages("this.path")
# install.packages("mgcv")
# install.packages("MLmetrics")
# install.packages("prioritylasso")
# install.packages("Boruta")

# Install required package to estimate the empirical correlation matrices.
# install.packages(corpcor)
# if (!requireNamespace("BiocManager", quietly = TRUE))
#   install.packages("BiocManager")
# BiocManager::install("curatedTCGAData")
# BiocManager::install("rtracklayer", force = TRUE)
# BiocManager::install("GenomicFeatures", force = TRUE)
# BiocManager::install("TCGAbiolinks")
# BiocManager::install("GenomicRanges")
# BiocManager::install("TxDb.Hsapiens.UCSC.hg38.knownGene")
# install.packages("ggnewscale")
# BiocManager::install("enrichplot")
# BiocManager::install("ChIPseeker")
# BiocManager::install("org.Hs.eg.db")
# BiocManager::install(c("IlluminaHumanMethylation450kanno.ilmn12.hg19"))
# BiocManager::install("biomaRt")

library(fuseMLR)
library(data.table)
library(ggplot2)
library(batchtools)
library(InterSIM)
library(this.path)
library(MASS)
library(mgcv)
library(MLmetrics)
library(gridExtra)
library(grid)
library(prioritylasso)
library(Boruta)

# Load required package to estimate the empirical correlation matrices.
library(corpcor)
library(curatedTCGAData)
library(MultiAssayExperiment)
library(TCGAutils)
library(TCGAbiolinks)
library(GenomicRanges)
library(TxDb.Hsapiens.UCSC.hg38.knownGene)
library(ChIPseeker)
library(AnnotationDbi)
library(org.Hs.eg.db)
# library(IlluminaHumanMethylation450kanno.ilmn12.hg19)
library(biomaRt)

# The project directory is the absolute path to meta-lrnr-comp-study directory.
proc_dir <- "~/projects/interconnect-publications/meta-lrnr-comp-study"
working_dir <- "/imbs/projects/p23048/meta-lrnr-comp-study"
code_dir <- file.path(proc_dir, "R-code")
function_dir <- file.path(code_dir, "functions")
dir.create(function_dir, showWarnings = FALSE, recursive = TRUE)
data_dir <- file.path(working_dir, "data")
dir.create(data_dir, showWarnings = FALSE, recursive = TRUE)
data_tcga <- file.path(data_dir, "tcga")
dir.create(data_tcga, showWarnings = FALSE, recursive = TRUE)
result_dir <- file.path(working_dir, "results")
dir.create(result_dir, showWarnings = FALSE, recursive = TRUE)
image_dir <- file.path(working_dir, "images")


# Simulation directories

# Preprocessing: we first define low, moderate and strong effects
data_effect_def <- file.path(data_dir, "effect_def")
dir.create(data_effect_def, showWarnings = FALSE, recursive = TRUE)

# Processing: simulation
data_simulation <- file.path(data_dir, "simulation")
dir.create(data_simulation, showWarnings = FALSE, recursive = TRUE)

# Independent differentially expressed markers
data_independent_dir <- file.path(data_simulation, "independent")
dir.create(data_independent_dir, showWarnings = FALSE, recursive = TRUE)
indep_me_dir <- file.path(data_independent_dir, "me")
indep_mege_dir <- file.path(data_independent_dir, "mege")
indep_megepro_dir <- file.path(data_independent_dir,
                                       "megepro")
dir.create(indep_me_dir, showWarnings = FALSE, recursive = TRUE)
dir.create(indep_mege_dir, showWarnings = FALSE, recursive = TRUE)
dir.create(indep_megepro_dir, showWarnings = FALSE,
           recursive = TRUE)

# Dependent differentially expressed markers
data_dependent_dir <- file.path(data_simulation, "dependent")
dir.create(data_dependent_dir, showWarnings = FALSE, recursive = TRUE)
dep_me_dir <- file.path(data_dependent_dir, "me")
dep_mege_dir <- file.path(data_dependent_dir, "mege")
dep_megepro_dir <- file.path(data_dependent_dir,
                                            "megepro")
dir.create(dep_me_dir, showWarnings = FALSE, recursive = TRUE)
dir.create(dep_mege_dir, showWarnings = FALSE, recursive = TRUE)
dir.create(dep_megepro_dir, showWarnings = FALSE,
           recursive = TRUE)

# Registry dir
registry_dir <- file.path(working_dir, "registry")
dir.create(registry_dir, showWarnings = FALSE, recursive = TRUE)

# Registries for independently and differentially expressed markers
reg_independent_dir <- file.path(registry_dir, "independent")

# Registries for dependently and differentially expressed markers
reg_dependent_dir <- file.path(registry_dir, "dependent")
dir.create(reg_dependent_dir, showWarnings = FALSE, recursive = TRUE)


reg_dep_me <- file.path(reg_dependent_dir, "me")
reg_dep_mege <- file.path(reg_dependent_dir, "mege")
reg_dep_megepro <- file.path(reg_dependent_dir,
                                              "megepro")
dir.create(reg_dep_me, showWarnings = FALSE, recursive = TRUE)
dir.create(reg_dep_mege, showWarnings = FALSE, recursive = TRUE)
dir.create(reg_dep_megepro, showWarnings = FALSE,
           recursive = TRUE)
# Result dir
dir.create(result_dir, showWarnings = FALSE, recursive = TRUE)

# Registries for independent differentially expressed markers
res_independent_dir <- file.path(result_dir, "independent")
dir.create(res_independent_dir, showWarnings = FALSE, recursive = TRUE)
res_indep_me <- file.path(res_independent_dir, "me")
res_indep_mege <- file.path(res_independent_dir, "mege")
res_indep_megepro <- file.path(res_independent_dir,
                                              "megepro")
dir.create(res_indep_me, showWarnings = FALSE, recursive = TRUE)
dir.create(res_indep_mege, showWarnings = FALSE, recursive = TRUE)
dir.create(res_indep_megepro, showWarnings = FALSE,
           recursive = TRUE)
# Registries for dependent differentially expressed markers
res_dependent_dir <- file.path(result_dir, "dependent")
dir.create(res_dependent_dir, showWarnings = FALSE, recursive = TRUE)
res_dep_me <- file.path(res_dependent_dir, "me")
res_dep_mege <- file.path(reg_dependent_dir, "mege")
res_dep_megepro <- file.path(res_dependent_dir,
                                            "megepro")
dir.create(res_dep_me, showWarnings = FALSE, recursive = TRUE)
dir.create(res_dep_mege, showWarnings = FALSE, recursive = TRUE)
dir.create(res_dep_megepro, showWarnings = FALSE, recursive = TRUE)

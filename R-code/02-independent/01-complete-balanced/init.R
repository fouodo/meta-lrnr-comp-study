source("../init.R", chdir = TRUE)
# ==============================================================================
# Modality directories for the incomplete-case scenarios
# ==============================================================================
#
indep_combalanced_me_dir <- file.path(data_indep_combalanced_dir, "me")
indep_combalanced_mege_dir <- file.path(data_indep_combalanced_dir,
                                                    "mege")
indep_combalanced_megepro_dir <- file.path(
  data_indep_combalanced_dir,
  "megepro")
dir.create(indep_combalanced_me_dir,
           showWarnings = FALSE,
           recursive = TRUE)
dir.create(indep_combalanced_mege_dir,
           showWarnings = FALSE,
           recursive = TRUE)
dir.create(indep_combalanced_megepro_dir,
           showWarnings = FALSE,
           recursive = TRUE)

# ==============================================================================
# Registries for independent differentially expressed markers
# ==============================================================================
#
reg_indep_combalanced_me <- file.path(reg_indep_combalanced_dir, "me")
reg_indep_combalanced_mege <- file.path(reg_indep_combalanced_dir, "mege")
reg_indep_combalanced_megepro <- file.path(reg_indep_combalanced_dir, "megepro")
dir.create(reg_indep_combalanced_me, showWarnings = FALSE, recursive = TRUE)
dir.create(reg_indep_combalanced_mege, showWarnings = FALSE, 
           recursive = TRUE)
dir.create(reg_indep_combalanced_megepro, showWarnings = FALSE, 
           recursive = TRUE)

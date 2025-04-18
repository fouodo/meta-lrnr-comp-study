source("init.R", chdir = TRUE)
## Send jobs
no.threads <- 5
reg_methyl_train_lasso <- wrap_batchtools(reg_name = "02-train-lasso",
                                          work_dir = working_dir,
                                          reg_dir = reg_indep_methyl,
                                          r_function = single_run_lasso,
                                          vec_args = data.frame(
                                            data_file = indep_methyl_param_data$save_path,
                                            seed = indep_methyl_param_data$seed,
                                            delta.methyl = indep_methyl_param_data$delta.methyl,
                                            delta.expr = indep_methyl_param_data$delta.expr,
                                            delta.protein = indep_methyl_param_data$delta.protein,
                                            effect = indep_methyl_param_data$effect
                                          ),
                                          more_args = list(
                                            num.tree.meta = 1000L
                                          ),
                                          name = "me-lasso",
                                          overwrite = TRUE,
                                          memory = "25g",
                                          n_cpus = 5,
                                          walltime = "60",
                                          sleep = 5,
                                          partition = "prio", ## Set partition in init-global
                                          account = "p23048", ## Set account in init-global
                                          test_job = FALSE,
                                          wait_for_jobs = FALSE,
                                          packages = c(
                                            "devtools",
                                            "data.table",
                                            "glmnet",
                                            "fuseMLR"
                                          ),
                                          source = c(file.path(function_dir, 
                                                               "mylasso.R")),
                                          config_file = config_file,
                                          interactive_session = interactive_session)

## Run this after that your jobs are completed
## ----------------------------------------------
## Resume results
## ----------------------------------------------
##
reg_methyl_train_lasso <- batchtools::loadRegistry(
  file.dir = file.path(reg_indep_methyl, "02-train-lasso"), writeable = TRUE,
  conf.file = config_file)
reg_methyl_train_lasso <- batchtools::reduceResultsList(
  ids = batchtools::findDone(
    ids = 1:nrow(indep_methyl_param_data),
    reg = reg_methyl_train_lasso
  ),
  reg = reg_methyl_train_lasso)


## resume filtered results
indep_res_methyl_lasso <- data.table::rbindlist(reg_methyl_train_lasso)
indep_methyl_mean_perf_lasso <- indep_res_methyl_lasso[ , .(mean_perf = mean(meta_layer)), 
                                                        by = .(perf_measure, effect)]
print(indep_methyl_mean_perf_lasso)
indep_res_methyl_lasso$Setting <- "Independent"
indep_res_methyl_lasso$DE <- "DE: Me"
indep_res_methyl_lasso$Meta_learner <- "Lasso"
saveRDS(object = indep_res_methyl_lasso,
        file = file.path(res_indep_methyl, "indep_res_methyl_lasso.rds"))

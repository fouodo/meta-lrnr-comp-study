source(file.path(code_dir, "01-effect-definition/init.R"), chdir = TRUE)

# Prepare parameters
# param_df <- expand.grid(delta.methyl = c(0, 0.001, 0.01, 0.1), 
#                         delta.expr = c(0, 0.01, 0.1, 1), 
#                         delta.protein = c(0, 0.001, 0.01, 0.1))
param_df_genexpr <- expand.grid(delta.methyl = c(0, 0, 0, 0, 0), 
                        delta.expr = c(0, 0.01, 0.1, 1, 1.5), 
                        delta.protein = c(0, 0, 0, 0, 0))
# Add seeds
set.seed(123)
random_integers <- sample(1:2000, nrow(param_df_genexpr), replace = FALSE)
param_df_genexpr$seed <- random_integers
param_df_genexpr$save_path <- file.path(data_effect_def,
                                paste("genexpr",
                                      paste(param_df_genexpr$seed, "rds", sep = "."),
                                      sep = "/"))
## Send jobs
no.threads <- 5
run_boruta10 <- wrap_batchtools(reg_name = "01-effect-def-genexpr",
                                work_dir = working_dir,
                                reg_dir = registry_dir,
                                r_function = simuldata,
                                vec_args = param_df_genexpr,
                                more_args = list(
                                  empirical_param_prefix = data_tcga,
                                  n.sample = 300,
                                  cluster.sample.prop = c(0.5, 0.5),
                                  p.DMP = 0.2,
                                  p.DEG = NULL,
                                  p.DEP = NULL,
                                  do.plot = FALSE,
                                  sample.cluster = TRUE,
                                  feature.cluster = FALSE,
                                  training_prop = 2/3,
                                  prop_missing_train = 0,
                                  prop_missing_test = 0,
                                  function_dir = function_dir
                                ),
                                name = "genexpr-data",
                                overwrite = TRUE,
                                memory = "25g",
                                n_cpus = 5,
                                walltime = "60",
                                sleep = 5,
                                partition = "fast", ## Set partition in init-global
                                account = "imbs", ## Set account in init-global
                                test_job = FALSE,
                                wait_for_jobs = FALSE,
                                packages = c(
                                  "devtools",
                                  "data.table",
                                  "mgcv",
                                  "InterSIM"
                                ),
                                config_file = config_file,
                                interactive_session = interactive_session)

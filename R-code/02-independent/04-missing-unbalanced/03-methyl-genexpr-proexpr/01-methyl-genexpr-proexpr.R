source("init.R", chdir = TRUE)
## Send jobs
no.threads <- 5
prop_missing_train <- 0.05
indep_missunbalanced_megepro_param_data$effect <- NULL
megepro_data <- wrap_batchtools(reg_name = "01-data",
                               work_dir = working_dir,
                               reg_dir = reg_indep_missunbalanced_megepro,
                               r_function = simuldata,
                               vec_args = indep_missunbalanced_megepro_param_data,
                               more_args = list(
                                 empirical_param_prefix = data_tcga,
                                 n.sample = 300,
                                 cluster.sample.prop = c(0.5, 0.5),
                                 p.DMP = 0.2,
                                 p.DEG = 0.2,
                                 p.DEP = 0.2,
                                 do.plot = FALSE,
                                 sample.cluster = TRUE,
                                 feature.cluster = FALSE,
                                 training_prop = 2/3,
                                 prop_missing_train = prop_missing_train,
                                 prop_missing_test = prop_missing_train,
                                 function_dir = function_dir
                               ),
                               name = "indep-missunb-megepro-data",
                               overwrite = TRUE,
                               memory = "40g",
                               n_cpus = no.threads,
                               walltime = "0",
                               sleep = 5,
                               partition = "prio", ## Set partition in init-global
                               account = "dzhk-omics", ## Set account in init-global
                               test_job = FALSE,
                               wait_for_jobs = FALSE,
                               packages = c(
                                 "devtools",
                                 "data.table",
                                 "mgcv"
                               ),
                               config_file = config_file,
                               interactive_session = interactive_session)

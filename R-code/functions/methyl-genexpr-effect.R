# =======================================
# Methylation and gene expression effects
# =======================================
#
methyl_genexpr_effect <- function(n = 100L,
                                  save_dir = indep_methyl_genexpr_dir) {
  methyl_strong <- rnorm(n = n, mean = 0.2, sd = 0.05)
  methyl_moderate <- rnorm(n = n, mean = 0.15, sd = 0.05)
  methyl_low <- rnorm(n = n, mean = 0.1, sd = 0.05)
  genexpr_moderate <- rnorm(n = n, mean = 80, sd = 10)
  genexpr_low <- rnorm(n = n, mean = 60, sd = 10)
  effect_df <- data.frame(
    delta.methyl = c(methyl_strong,
                     methyl_strong,
                     methyl_moderate,
                     methyl_moderate,
                     methyl_low),
    delta.expr = c(genexpr_moderate,
                   genexpr_low,
                   genexpr_moderate,
                   genexpr_low,
                   genexpr_low),
    delta.protein = 0,
    effect = rep(c("strong_moderate",
                   "strong_low",
                   "moderate_moderate",
                   "moderate_low",
                   "low_low"), each = n)
  )
  random_integers <- sample(1:15000, nrow(effect_df), replace = FALSE)
  effect_df$seed <- random_integers
  effect_df$save_path <- file.path(save_dir,
                                   paste("data",
                                         paste(
                                           paste(effect_df$effect, 
                                                 effect_df$seed, sep = "_"),
                                           "rds",
                                           sep = "."),
                                         sep = "/"))
  return(effect_df)
}
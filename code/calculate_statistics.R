# This function compares tables with: (i) BPM with predicted phenotypes (1 and 0), (ii) summary of growth data (+, w, -)
# The function calculates the number of true positives, true negatives, false positives, and negatives
# Metrics are calculated for the whole dataset and within groups (structural types of glycans) specified in phenotype_metadata
# As input, it takes three tables: bpm, growth_summary, phenotype_metadata
calculate_metrics_within_groups <- function(table1, table2, phenotype_metadata) {
  # Ensure that both tables have the same dimensions
  if (any(dim(table1) != dim(table2))) {
    stop("Input tables must have the same dimensions.")
  }
  
  # Extract the relevant columns
  col_names <- names(table1)[-1]  # Exclude the genome name column
  
  # Filter phenotype_metadata to include only rows corresponding to existing columns
  phenotype_metadata_filtered <- phenotype_metadata %>%
    filter(phenotype %in% col_names) %>%
    # rearrange rows based on the order in input files
    mutate(order = match(phenotype, col_names)) %>%
    arrange(order) %>%
    select(-order)
  
  groups <- unique(phenotype_metadata_filtered$type_group)
  
  results <- list()  # Initialize a list to store results for each group
  
  for (group in groups) {
    group_indices <- which(phenotype_metadata_filtered$type_group == group)
    group_table1 <- table1[, c(1, group_indices + 1)]
    group_table2 <- table2[, c(1, group_indices + 1)]
    
    group_results <- calculate_group_metrics(group_table1, group_table2)
    results[[group]] <- group_results
  }
  
  # Calculate metrics for the whole dataset (all groups)
  all_results <- calculate_group_metrics(table1, table2)
  results$AllGroups <- all_results
  
  return(results)
}

calculate_group_metrics <- function(group_table1, group_table2) {
  col_names <- names(group_table1)[-1]  # Exclude the genome name column
  
  tp <- 0
  tn <- 0
  fp <- 0
  fn <- 0
  
  for (col_name in col_names) {
    values1 <- group_table1[[col_name]]
    values2 <- group_table2[[col_name]]
    
    for (i in 1:length(values1)) {
      value1 <- values1[i]
      value2 <- values2[i]
      
      if (value1 == "1" && (value2 == "+" || value2 == "w")) {
        tp <- tp + 1
      } else if (value1 == "0" && value2 == "-") {
        tn <- tn + 1
      } else if (value1 == "1" && value2 == "-") {
        fp <- fp + 1
      } else if (value1 == "0" && (value2 == "+" || value2 == "w")) {
        fn <- fn + 1
      }
    }
  }
  
  tested <- tp + tn + fp + fn
  
  group_results <- data.frame(
    Tested = tested,
    TruePositive = tp,
    TrueNegative = tn,
    FalsePositive = fp,
    FalseNegative = fn
  )
  
  return(group_results)
}
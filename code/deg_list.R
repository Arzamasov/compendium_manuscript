# this function accepts output from topTable (data frame), selects genes that pass logFC and FDR cut-offs, 
# annotates them, and saves the resulting list of differentially expressed genes (DEGs) to a tsv file
# input:
# (1) data frame from topTable
# (2) cut-off for logFC for downregulated genes
# (3) cut-off for logFC for upregulated genes
# (4) cut-off for adjusted p-value (FDR)
# (5) string with the name of the output file
# example: deg_list(myTopHits.COE2.30, -1, 1, 0.05, "results/tables/DEG_COE2vs0_30min.txt")

deg_list <- function(data, logFCmin, logFCmax, FDR, file_name){ 
  myTopHits.df <- data %>%
    as_tibble(rownames = "geneID")
  # select only genes that pass logFC and adj.P.Val cut-offs
  myTopHits.df.de <- subset(myTopHits.df, (logFC > logFCmax | logFC < logFCmin) & adj.P.Val < FDR)
  # annotate DEGs using the combined annotation table
  myTopHits.df.de <- right_join(final.ann, myTopHits.df.de, by = c('locus_tag' = 'geneID')) %>%
    arrange(desc(logFC))
  # save the DEG list to a text file
  write_tsv(myTopHits.df.de, file_name)
  # output the DEG table to the RMarkdown file
  gt(myTopHits.df.de) %>% 
    cols_align(
      align = "left",
      columns = everything()) %>%
      tab_options(., container.width = 1000, 
                  container.height = 500)
}

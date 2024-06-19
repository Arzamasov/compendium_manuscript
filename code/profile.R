# this function accepts count data from a DGElist object, calculates counts per million (CPM) for each gene,
# and plots the distribution of CPM values for each sample
# input:
# (1) count data from a DGElist object
# (2) vector with sample names
# (3) string that will be used as a subtitle
# example: profile(myDGEList, sampleLabels, "Unfiltered, non-normalized")

profile <- function(data, samples, subtitle){ 
# use the 'cpm' function from EdgeR to get CPM
log2.cpm <- cpm(data, log=TRUE)
log2.cpm.df <- as_tibble(log2.cpm, rownames = "geneID") # existing rownames are transferred to column geneID
colnames(log2.cpm.df) <- c("geneID", samples)
# pivot data
log2.cpm.df.pivot <- pivot_longer(log2.cpm.df, # dataframe to be pivoted
                                  cols = -1, # select all columns except the first one to be stored as a SINGLE variable
                                  names_to = "samples", # name of that new variable (column)
                                  values_to = "expression") # name of new variable (column) storing all the values (data)
# plot the distribution of CPM values
ggplot(log2.cpm.df.pivot) +
  aes(x=samples, y=expression, fill=samples) +
  geom_violin(trim = FALSE, show.legend = FALSE) +
  stat_summary(fun = "median", 
                geom = "point", 
                shape = 124, 
                size = 2.5, 
                color = "black", 
                show.legend = FALSE) +
  labs(y="log2 expression", x = "sample",
        title="Log2 Counts per Million (CPM)",
        subtitle=subtitle) +
  coord_flip() +
    theme_bw()
}
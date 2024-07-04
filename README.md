# Overview of the repository
This repository contains code and analyses conducted for the manuscript "Integrative genomic reconstruction of carbohydrate utilization networks in bifidobacteria: global trends, local variability, and dietary adaptation".

## Abstract
Bifidobacteria are among the earliest colonizers of the human gut, conferring numerous health benefits. While multiple *Bifidobacterium* strains are used as probiotics, accumulating evidence suggests that the individual responses to probiotic supplementation may vary, likely due to a variety of factors, including strain type(s), gut community composition, dietary habits of the consumer, and other health/lifestyle conditions. Given the saccharolytic nature of bifidobacteria, the carbohydrate composition of the diet is one of the primary factors dictating the colonization efficiency of *Bifidobacterium* strains. Therefore, a comprehensive understanding of bifidobacterial glycan metabolism at the strain level is necessary to rationally design probiotic or synbiotic formulations that combine bacterial strains with glycans that match their nutrient preferences. In this study, we systematically reconstructed 66 pathways involved in the utilization of mono-, di-, oligo-, and polysaccharides by analyzing the representation of 565 curated metabolic functional roles (catabolic enzymes, transporters, transcriptional regulators) in 2973 non-redundant cultured *Bifidobacterium* isolates and metagenome-assembled genomes (MAGs). Our analysis uncovered substantial heterogeneity in the predicted glycan utilization capabilities at the species and strain level and revealed the presence of a yet undescribed phenotypically distinct subspecies-level clade within the *Bifidobacterium longum* species. We also identified Bangladeshi isolates harboring unique gene clusters tentatively implicated in the breakdown of xyloglucan and human milk oligosaccharides. Predicted carbohydrate utilization phenotypes were experimentally characterized and validated. Our large-scale genomic analysis considerably expands the knowledge of carbohydrate metabolism in bifidobacteria and provides a foundation for rationally designing single- or multi-strain probiotic formulations of a given bifidobacterial species as well as synbiotic combinations of bifidobacterial strains matched with their preferred carbohydrate substrates.

## Directory structure
 - `code/` - bash scripts and R scripts with custom functions
 - `data/CAZyme` - CAZyme representation in 263 reference strains
 - `data/genomes/263_NR_ref_genomes` - FNA and FAA files of 263 reference genomes
 - `data/growth` - raw growth data
 - `data/hmo_consumption` - raw HMO consumption data
 - `data/phylogeny/` - phylogenetic trees and ANI matrices
 - `data/rnaseq/` - RNA-seq data: (i) Kallisto mapping output and log files, (ii) study design file, (iii) mcSEED genome annotation files
 - `data/tables/` - Binary Phenotype Matrices (BPMs), metadata tables
 - `results/` - figure and table drafts produced using the Rmarkdown file
 - `renv/` - a snapshot of the R environment captured via the renv package
 - `compendium_manuscript.Rproj` - RProject file
 - `Sup_code_file.Rmd` - Rmarkdown file that combines all code and outputs and was used to generate the supplementary code file included in the manuscript

## Reproducibility and accessibility
All code used in this analysis (including the Rmarkdown document used to compile this supplementary code file) is available on GitHub. Once the GitHub repo has been downloaded, navigate to `compendium_manuscript/` to find the Rmarkdown document as well as the RProject file. This should be your working directory for executing code.
1. To fully reproduce the phylogenetic analysis of 263 reference *Bifidobacterium* genomes, you will need to download FNA files from [Figshare](https://doi.org/10.6084/m9.figshare.26053936). Downloaded FNA files should be placed in `data/genomes/263_NR_ref_genomes/fna/`
2. To fully reproduce the analysis of the CAZyme representation in 263 reference *Bifidobacterium* genomes, you will need to download FAA files from [Figshare](https://doi.org/10.6084/m9.figshare.26053936). Downloaded FAA files should be placed in `data/genomes/263_NR_ref_genomes/faa/`
3. To fully reproduce the RNA-seq data analysis, you will need to download raw FASTQ files from Gene Expression Omnibus under accession [GSE239955](https://www.ncbi.nlm.nih.gov/geo/query/acc.cgi?acc=GSE239955). Downloaded FASTQ files should be placed in `data/rnaseq/fastq/`. Otherwise, `data/rnaseq/kallisto/` already contains Kallisto mapping outputs
4. To reproduce the R environment used in the analysis, use the [renv](https://rstudio.github.io/renv/articles/renv.html) package and `renv::restore()` to restore the environment from `renv.lock`

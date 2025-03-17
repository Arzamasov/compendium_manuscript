# Overview of the repository
This repository contains code and analyses conducted in the manuscript "Integrative genomic reconstruction of carbohydrate utilization networks in bifidobacteria: global trends, local variability, and dietary adaptation".

## Abstract
Bifidobacteria are among the earliest colonizers of the human gut, conferring numerous health benefits. While multiple *Bifidobacterium* strains are used as probiotics, accumulating evidence suggests that the individual responses to probiotic supplementation may vary, likely due to a variety of factors, including strain type(s), gut community composition, dietary habits of the consumer, and other health/lifestyle conditions. Given the saccharolytic nature of bifidobacteria, a comprehensive understanding of bifidobacterial glycan metabolism at the strain level is necessary to rationally design probiotic or synbiotic formulations that combine bacterial strains with glycans that match their nutrient preferences. In this study, we systematically reconstructed 68 pathways involved in the utilization of mono-, di-, oligo-, and polysaccharides by analyzing the representation of 589 curated metabolic functional roles (catabolic enzymes, transporters, transcriptional regulators) in 3083 non-redundant cultured *Bifidobacterium* isolates and metagenome-assembled genomes (MAGs) of human origin. Our analysis uncovered substantial interspecies and strain-level heterogeneity and identified a yet undescribed phenotypically distinct subspecies-level clade within the *Bifidobacterium longum* species. We also uncovered Bangladeshi isolates harboring unique gene clusters tentatively implicated in the breakdown of xyloglucan and human milk oligosaccharides. Thirty-eight predicted carbohydrate utilization phenotypes were experimentally validated in 30 geographically diverse *Bifidobacterium* isolates. Our large-scale genomic compendium considerably expands knowledge of bifidobacterial carbohydrate metabolism, providing a foundation for the rational design of probiotic and synbiotic formulations tailored to strain-specific nutrient preferences.

## Directory structure
 - `code/` - bash scripts and R scripts with custom functions
 - `data/CAZyme` - CAZyme representation in 263 reference strains
 - `data/genomes/263_NR_ref_genomes` - FASTA files of 263 reference genomes
 - `data/growth` - raw growth data
 - `data/hmo_consumption` - raw HMO consumption data
 - `data/phylogeny/` - phylogenetic trees and ANI matrices
 - `data/rnaseq/` - RNA-seq data: (i) Kallisto mapping output and log files, (ii) study design file, (iii) mcSEED genome annotation files
 - `data/tables/` - Binary Phenotype Matrices (BPMs), metadata tables
 - `results/` - figure and table drafts produced using the Rmarkdown file
 - `compendium_manuscript.Rproj` - RProject file
 - `Sup_code_file.Rmd` - Rmarkdown file that combines all code and outputs and was used to generate the supplementary code file included in the manuscript

## Reproducibility and accessibility
All code used in this analysis (including the Rmarkdown document used to compile this supplementary code file) is available on GitHub. Once the GitHub repo has been downloaded, navigate to `compendium_manuscript/` to find the Rmarkdown document as well as the RProject file. This should be your working directory for executing code.
1. To fully reproduce the phylogenetic analysis of 263 reference **Bifidobacterium** genomes, you will need to download FNA files from [Figshare](https://doi.org/10.6084/m9.figshare.26053936). Downloaded FNA files should be placed in `data/genomes/263_NR_ref_genomes/fna/`
2. Given the potential challenges with installing and running dbCAN, we provide processed dbCAN outputs in `data/CAZyme`
3. To fully reproduce the RNA-seq data analysis, you will need to download raw FASTQ files from Gene Expression Omnibus under accession [GSE239955](https://www.ncbi.nlm.nih.gov/geo/query/acc.cgi?acc=GSE239955). Downloaded FASTQ files should be placed in `data/rnaseq/fastq/`. Otherwise, `data/rnaseq/kallisto/` already contains Kallisto mapping outputs
4. The pathway prediction pipeline **glycobif** used for additional 2820 genomes and MAGs is available in another [repository](https://github.com/Arzamasov/glycobif)

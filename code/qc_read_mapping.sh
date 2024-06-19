#!/bin/bash
echo $BASH_VERSION
#set -ex

####################
## SOFTWARE SETUP ##
####################
# required tools: fastqc (v0.11.9), cutadapt (v4.1), bowtie2 (v2.4.5), kallisto (v0.48)
# multiqc (v1.13), and parallel (v20220722)
# set the name of the environment with the tools
environment_name="transcriptomics"
# activate conda environment with the required tools
eval "$(command conda 'shell.bash' 'hook' 2> /dev/null)" # initializes conda in sub-shell
conda activate ${environment_name}
conda info|egrep "conda version|active environment"

################
## USER INPUT ##
################
# fastq files should be in data/rnaseq/fastq/
# txt file containing names of fastq files (without the fastq.gz extension)
sample_names="data/rnaseq/runids.txt"
# fasta file containing sequences of rRNA and tRNA genes
rRNA_tRNA_fasta="data/rnaseq/refs/Bc_kashiwanohense_Bg42221_1E1_RNA.fasta"
# fasta file containing the whole transcriptome
transcriptome_fasta="data/rnaseq/refs/Bc_kashiwanohense_Bg42221_1E1.fasta"
# name of the bowtie2 index
bowtie2_index_name="data/rnaseq/refs/Bc_kashiwanohense_Bg42221_1E1_rRNA_tRNA"
# name of the kallisto index
kallisto_index_name="data/rnaseq/refs/Bc_kashiwanohense_Bg42221_1E1_transcriptome.index"

# create directories
echo "Creating directories"
mkdir -p data/rnaseq/qc1 # qc results for raw reads
mkdir -p data/rnaseq/qc2 # qc results for filtered reads
mkdir -p data/rnaseq/fq_trim # trimmed reads
mkdir -p data/rnaseq/fq_filt # filtered reads
mkdir -p data/rnaseq/sam # sam files produced during bowtie2 alignment; will be deleted
mkdir -p data/rnaseq/kallisto # kallisto mapping results

# run fastqc on raw reads
echo "Running FastQC on raw reads"
cat ${sample_names} | parallel "fastqc \
data/rnaseq/fastq/{}.fastq.gz \
--outdir data/rnaseq/qc1"

# trim adapters with cutadapt
echo "Trimming adapters with Cutadapt"
cat ${sample_names} | parallel "cutadapt \
--nextseq-trim=20 \
-m 20 \
-a AGATCGGAAGAGCACACGTCTGAACTCCAGTC \
-o data/rnaseq/fq_trim/{}.fastq.gz data/rnaseq/fastq/{}.fastq.gz \
&> data/rnaseq/fq_trim/{}.fastq.qz.log"

# filter reads mapped to rRNA and tRNA
echo "Filtering reads that map to rRNA and tRNA using Bowtie2"
## build bowtie2 index
bowtie2-build ${rRNA_tRNA_fasta} \
${bowtie2_index_name}
## align reads via bowtie2; save ones that did not align to a separate file
cat ${sample_names} | \
parallel "bowtie2 -x ${bowtie2_index_name} \
-U data/rnaseq/fq_trim/{}.fastq.gz \
-S data/rnaseq/sam/{}.sam \
--un data/rnaseq/fq_filt/{}.fastq \
&> data/rnaseq/fq_filt/{}_bowtie2.log"
cat ${sample_names} | parallel "gzip data/rnaseq/fq_filt/{}.fastq"

# run fastqc on filtered reads
echo "Running FastQC on filtered reads"
cat ${sample_names} | parallel "fastqc \
data/rnaseq/fq_filt/{}.fastq.gz \
--outdir data/rnaseq/qc2"

# pseudolalign reads to transcriptome
echo "Mapping reads to the transcriptome via Kallisto"
## build kallisto index
kallisto index -i ${kallisto_index_name} \
${transcriptome_fasta}
## map reads to indexed reference via kallisto
cat ${sample_names} | parallel "kallisto quant \
-i ${kallisto_index_name} \
-o data/rnaseq/kallisto/{} \
--single \
--rf-stranded \
-l 150 \
-s 20 \
data/rnaseq/fq_filt/{}.fastq.gz \
&> data/rnaseq/kallisto/{}_kallisto.log"

# run multiqc
echo "Running MultiQC"
export LC_ALL=en_US.utf-8
export LANG=en_US.utf-8
multiqc -d data/rnaseq -o data/rnaseq

# remove directories with intermediate files
echo "Removing directories"
rm -rf data/rnaseq/qc1
rm -rf data/rnaseq/qc2
rm -rf data/rnaseq/fq_trim
rm -rf data/rnaseq/fq_filt
rm -rf data/rnaseq/sam
#!/bin/bash
echo $BASH_VERSION
##set -ex

### SOFTWARE SETUP ##
####################
# required tools: prokka=v1.14.6, parallel>=v20210422
# set the name of the environment with installed tools
environment_name="prokka"
# activate selected conda environment
eval "$(command conda 'shell.bash' 'hook' 2> /dev/null)" # initializes conda in sub-shell
conda activate ${environment_name}
conda info|egrep "conda version|active environment"

################
## USER INPUT ##
################
# specify the directory containing fna files
dir="data/genomes/263_NR_ref_genomes/fna"
# specify the prokka output directory
dir_p="data/genomes/263_NR_ref_genomes/prokka"
# specify the base directory
dir_b="data/genomes/263_NR_ref_genomes/"
# specify the name of the file which will contain genome names
names="genome_list.txt"

## collect the names of FNA files to a file
echo "Creating genome_list.txt"
# create an empty file to store the names of the files
touch $dir/$names
# loop through all files in the directory and extract filenames without extension
for file in $dir/*; do
    if [[ $file != *$names* ]]; then
    filename=$(basename "$file")
        name="${filename%.*}"
        echo $name >> $dir/$names
    fi
done

## run prokka
echo "Running Prokka"
# annotate genomes using built-in prokka databases
cat $dir/$names | parallel "prokka \
$dir/{}.fna \
--outdir $dir_p/{} \
--prefix {} \
--genus Bifidobacterium \
--kingdom Bacteria \
--gram pos \
--cpus 1 \
--compliant"
#--metagenome
rm -f $dir/$names

## sort files into folders by type
echo "Sorting Prokka output"
# create respective folders
mkdir -p $dir_b/gff
#mkdir -p $dir_b/faa
#mkdir -p $dir_b/gbk
#mkdir -p $dir_b/txt
# collect all gff files
find $dir_p -type f -name "*.gff" -exec mv {} $dir_b/gff \;
# collect all faa files
#find $dir_p -type f -name "*.faa" -exec mv {} $dir_b/faa \;
# collect all gbk files
#find $dir_p -type f -name "*.gbk" -exec mv {} $dir_b/gbk \;
# collect all txt files
#find $dir_p -type f -name "*.txt" -exec mv {} $dir_b/txt \;
#!/bin/bash

# Super Easy Genome Workflow Script by Mbah
# This helps beginners build a genome step by step!
# Change these lines for your own genome:

# What to call your genome files (e.g., "mtb" for Mycobacterium tuberculosis)
MY_GENOME_NAME="mtb"

# Where you want to save everything (your folder)
MY_FOLDER="/mnt/c/Users/priest/OneDrive/Desktop/OMICS-LOGIC/"

# The names of your data files (change these if different)
DATA_FILE1="ERR12268341_1.fastq.gz"
DATA_FILE2="ERR12268341_2.fastq.gz"

# The species, genus, and strain (change for your genome)
MY_SPECIES="tuberculosis"
MY_GENUS="Mycobacterium"
MY_STRAIN="H37Rv"

# --- No need to change below this line unless you want to! ---

# Step 1: Get the tools ready
echo "Getting tools ready... (This might take a minute)"
# Install a fast tool manager and a workroom for tools
conda install -c conda-forge mamba --yes
mamba create -n de_novo_assembly -c bioconda -c conda-forge python=3.8 fastqc fastp spades megahit quast bwa-mem2 busco prokka --yes
conda activate de_novo_assembly

# Step 2: Make folders to keep things organized
echo "Making folders..."
mkdir -p "$MY_FOLDER/qc_reports" "$MY_FOLDER/fastq_files" "$MY_FOLDER/assembly_results"

# Step 3: Download your data (get it from the internet)
echo "Downloading your genome data..."
wget -P "$MY_FOLDER/fastq_files" "ftp://ftp.sra.ebi.ac.uk/vol1/fastq/ERR122/041/$DATA_FILE1"
wget -P "$MY_FOLDER/fastq_files" "ftp://ftp.sra.ebi.ac.uk/vol1/fastq/ERR122/041/$DATA_FILE2"

# Step 4: Check the data quality
echo "Checking data quality..."
fastqc "$MY_FOLDER/fastq_files/$DATA_FILE1" "$MY_FOLDER/fastq_files/$DATA_FILE2" -t 4 -o "$MY_FOLDER/qc_reports/"

# Step 5: Clean the data
echo "Cleaning the data..."
fastp -i "$MY_FOLDER/fastq_files/$DATA_FILE1" -I "$MY_FOLDER/fastq_files/$DATA_FILE2" -o "$MY_FOLDER/qc/clean_1.fastq" -O "$MY_FOLDER/qc/clean_2.fastq" --thread 4

# Step 6: Fix errors and build the genome with SPAdes
echo "Fixing errors and building with SPAdes..."
spades.py --only-error-correction -1 "$MY_FOLDER/qc/clean_1.fastq" -2 "$MY_FOLDER/qc/clean_2.fastq" -o "$MY_FOLDER/spades_fixed" -t 4
spades.py --only-assembler --careful -1 "$MY_FOLDER/spades_fixed/corrected/clean_100.0_0.cor.fastq.gz" -2 "$MY_FOLDER/spades_fixed/corrected/clean_200.0_0.cor.fastq.gz" -o "$MY_FOLDER/spades_${MY_GENOME_NAME}_assembly" -t 4

# Step 7: Build the genome with MEGAHIT
echo "Building with MEGAHIT..."
megahit -1 "$MY_FOLDER/spades_fixed/corrected/clean_100.0_0.cor.fastq.gz" -2 "$MY_FOLDER/spades_fixed/corrected/clean_200.0_0.cor.fastq.gz" -o "$MY_FOLDER/megahit_${MY_GENOME_NAME}_assembly" -t 4

# Step 8: Check the genome quality
echo "Checking genome quality..."
quast.py "$MY_FOLDER/spades_${MY_GENOME_NAME}assembly/contigs.fasta" -o "$MY_FOLDER/quast${MY_GENOME_NAME}_results"

# Step 9: Download a gene list and check your genome
echo "Downloading gene list and checking..."
wget -P "$MY_FOLDER/busco_downloads" https://busco-data.ezlab.org/v5/data/lineages/mycobacterium_odb12/mycobacterium_odb12.tar.gz
tar -xzf "$MY_FOLDER/busco_downloads/mycobacterium_odb12.tar.gz" -C "$MY_FOLDER/busco_downloads"
busco -i "$MY_FOLDER/spades_${MY_GENOME_NAME}assembly/contigs.fasta" -l "$MY_FOLDER/busco_downloads/mycobacterium_odb12" -o "$MY_FOLDER/busco${MY_GENOME_NAME}_output" -m genome -c 4

# Step 10: Name the genes
echo "Naming the genes..."
prokka "$MY_FOLDER/spades_${MY_GENOME_NAME}assembly/contigs.fasta" --outdir "$MY_FOLDER/prokka${MY_GENOME_NAME}_careful" --prefix "${MY_GENOME_NAME}_careful" --locustag "${MY_GENOME_NAME}_Careful" --kingdom Bacteria --genus "$MY_GENUS" --species "$MY_SPECIES" --strain "$MY_STRAIN" --gram pos --cpus 4

# Step 11: Match reads to the genome
echo "Matching reads to the genome..."
bwa index "$MY_FOLDER/spades_${MY_GENOME_NAME}_assembly/contigs.fasta"
bwa mem -t 4 "$MY_FOLDER/spades_${MY_GENOME_NAME}_assembly/contigs.fasta" "$MY_FOLDER/fastq_files/$DATA_FILE1" "$MY_FOLDER/fastq_files/$DATA_FILE2" > "$MY_FOLDER/aligned.sam"
samtools view -bS "$MY_FOLDER/aligned.sam" | samtools sort -@ 4 -o "$MY_FOLDER/aligned_sorted.bam"
samtools index "$MY_FOLDER/aligned_sorted.bam"
samtools stats "$MY_FOLDER/aligned_sorted.bam" > "$MY_FOLDER/mapping_stats.txt"

echo "Yay! Your genome work is done! Look in $MY_FOLDER for your files!"

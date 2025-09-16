#Installing the required Packages(Tools) in R ----
install.packages("")         #For Installing packages in R
library('')           #For loading packages into R

install.packages("R.utils")
library(R.utils)

if (!require("BiocManager", quietly = TRUE))
  install.packages("BiocManager")

# Install Rsubread using BiocManager
BiocManager::install("Rsubread")
library(Rsubread)

#Installing RUVSeq using BiocManager
BiocManager::install("RUVSeq")
library('RUVSeq')

# Install and load data.table package
install.packages("data.table")
library('data.table')

#Installing DESeq2 using BiocManager
BiocManager::install("DESeq2")
library('DESeq2')

#Install Enhancedvolcano using BiocManager
BiocManager::install('EnhancedVolcano')
library(EnhancedVolcano)

#install.packages("pheatmap")
library(pheatmap)


#install.packages("RColorBrewer")
library(RColorBrewer)




#Downloading the Fastq files from ENA Database ----
# Downloading FASTQ files for ERR12268342
url <- "ftp://ftp.sra.ebi.ac.uk/vol1/fastq/ERR122/042/ERR12268342/ERR12268342_1.fastq.gz"
destination <- "ERR12268342_1.fastq.gz"
download.file(url, destination)

url <- "ftp://ftp.sra.ebi.ac.uk/vol1/fastq/ERR122/042/ERR12268342/ERR12268342_2.fastq.gz"
destination <- "ERR12268342_2.fastq.gz"
download.file(url, destination)

#Downloading FASTQ files for ERR12268341
url <- "ftp://ftp.sra.ebi.ac.uk/vol1/run/ERR122/ERR12268341/2018_AM-7_S64_R1_001.fastq.gz"
destination <- "ERR12268341_1.fastq.gz"
download.file(url, destination)

url <- "ftp://ftp.sra.ebi.ac.uk/vol1/run/ERR122/ERR12268341/2018_AM-7_S64_R2_001.fastq.gz"
destination <- "ERR12268341_2.fastq.gz"
download.file(url, destination)
#Downloading Genome File ----
url <- "https://ftp.ncbi.nlm.nih.gov/genomes/all/GCF/000/195/955/GCF_000195955.2_ASM19595v2/GCF_000195955.2_ASM19595v2_genomic.fna.gz"
destination <- "Mycobacterium_tuberculosis_H37Rv_genome.fna.gz"
download.file(url, destination)

# Unzipping genome file
R.utils::gunzip(destination, overwrite = TRUE)

# Downloading Annotation file ----
url <- "https://ftp.ncbi.nlm.nih.gov/genomes/all/GCF/000/195/955/GCF_000195955.2_ASM19595v2/GCF_000195955.2_ASM19595v2_genomic.gff.gz"
destination <- "Mycobacterium_tuberculosis_H37Rv_annotation.gff.gz"
download.file(url, destination)

# Unzipping annotation file
R.utils::gunzip(destination, overwrite = TRUE)


# FASTQC Installation and QC Report----
install.packages("fastqcr")
#Your system should also have JAVA installed.
#visit www.java.com for installation
library(fastqcr)

#To run Fastqc: either use installed fastqc in linux or downloaded fastqc online tool 

#Linux:Go to Tools> Global Option> Terminal> select linux
#fastqc /mnt/c/Users/Admin/OneDrive/Desktop/OMICS-LOGIC/*.fastq -o /mnt/c/Users/Admin/OneDrive/Desktop/OMICS-LOGIC/result/

#For online tool: https://www.bioinformatics.babraham.ac.uk/projects/fastqc/

qc <- qc_aggregate("C:/Users/Admin/OneDrive/Desktop/OMICS-LOGIC/result/")
qc
  
#Visualize Quality metrics ----

zip_files <- list.files("C:/Users/Admin/OneDrive/Desktop/OMICS-LOGIC/result/", pattern = "*.zip", full.names = TRUE)
for (file in zip_files) {
  qc_single <- qc_read(file)
  qc_plot(qc_single, "Per base sequence quality")
}

save.image('C:/Users/Admin/OneDrive/Desktop/OMICS-LOGIC/omics_logic_workspace.RData')

write.csv(qc, 'C:/Users/Admin/OneDrive/Desktop/OMICS-LOGIC/result/qc_summary.csv', row.names = FALSE)


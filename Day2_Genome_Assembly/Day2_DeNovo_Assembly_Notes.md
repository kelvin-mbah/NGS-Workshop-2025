#### Day 2: De Novo Assembly vs Referenced-Based Mapping
- De Novo: Building a genome or transcriptome from raw seq (Like puzzle). Tools: SPAdes, Velvet.
- Reference-Based: Aligns read to a known reference genome (Using a map). Tools: Bowtie 2, BWA.

# What I Did
- Installed Mamba: conda install -c conda-forge mamba --yes (fast tool helper).
- Made a toolbox: mamba create -n de_novo_assembly ... (got tools like Fastp, quast, megahit, Busco, Prokka, Bwa, Samtools and SPAdes).
- Turned on toolbox: conda activate de_novo_assembly.
- Checked DNA: fastqc *.fastq -t 16 -o ./qc_reports/ and multiqc ./qc_reports/.
- Cleaned DNA: fastp ... (made clean files in qc/directory).
- Fixed DNA mistakes: spades.py --only-error-correction ... (in spades_error_corrected/directory).
- Assembled with SPAdes: spades.py --only-assembler ... (default and careful in spades_careful_assembly/directory).
- Added MEGAHIT: conda install bioconda::megahit.
- Assembled with MEGAHIT: megahit ... (in megahit_optimized_assembly/).

### Results
- SPAdes Careful & Default
- MEGAHIT Optimized

### Problems
- Errors on mounted windows C drive when running megahit, fixed by using home folder (~).

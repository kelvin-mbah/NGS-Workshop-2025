# Day 1: Quality Control with FastQC
Date: September 15, 2025
Workshop: OmicsLogic NGS Bacterial Genomics

### What I Did
- I downloaded two DNA fastQ sequence files (called ERR12268341 and ERR1226842) from a NCBI SRA Website.
- I saved them in a folder on my Desktop called OMICS-LOGIC.
- I used a program called FastQC to check if the DNA sequences are good quality.
- I wrote an R code to run FastQC and make a summary of my two samples.

### My Files
- R Script: Bacterial NGS-day 1.R (my code to run FastQC).
- Results: ERR12268341_R1_fastqc.html and ERR12268341_R2_fastqc.html (shows quality of my DNA). Similarly, it was done for ERR12268342
- Summary: qc_summary.csv (combines quality info for both samples).

### What I Learned
- FastQC tells me if my DNA sequences have problems, like low-quality parts.
- My Read 1 and Read 2 files are mostly good, but some parts need cleaning (like the Adapter sequence).
- I used RStudio to run my code and see cool graphs.

### Problems I Had
- I got an error saying “Unix system required.”
- I fixed it by using a Linux terminal (WSL) on my computer.

### Next
- Tomorrow (Day 2), I’ll learn how to put the DNA pieces together with tools like SPAdes.

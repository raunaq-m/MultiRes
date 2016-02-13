MultiRes: A frame based error correction module for detecting rare variants and removing sequencing errors from Next Generation Sequencing data
The software has been tested for error removal and rare variant detection on Illumina sequencing data from viral populations. The list of files and tools to use for error correction are mentioned below. 


Usage Example: 
For a fasta file : input.fasta
MultiRes uses a k-mer counter to count for the following kmer counts : k=35, 23, and 13
Run: 
perl MultiRes.pl -fas input.fasta -out input.EC.txt 

The input.EC.txt will contain error corrected 35-mers for the file input.txt 

Parameters:
	1. -t : threshold for k-mers that have high confidence of being error free. typically greater than average sequencing coverage



If any questions, contact raunaq@psu.edu


MultiRes: A frame based error correction module for detecting rare variants and removing sequencing errors from Next Generation Sequencing data
The software has been tested for error removal and rare variant detection on Illumina sequencing data from viral populations. The list of files and tools to use for error correction are mentioned below. 


Usage Example: 
For a fasta file : input.fasta
MultiRes uses a k-mer counter to count for the following kmer counts : k=35, 23, and 13
If the counts are stored in the files input.35, input.23, and input.13
1. Use featureset.pl to generate feature file for MultiRes error classifier :
perl featureset.pl -k1 input.35 -k2 input.23 -k3 input.13 -t 35 > input.features.txt 

2. Use the python script PredictErrorCorrection1.py to classify the 35-mers in the file input.features.txt 

python PredictErrorCorrection1.py ./train1_models_pkl/RandomForest.pkl input.features.txt input.classifier.output.txt

	train1_models_pkl/RandomForest.pkl : is the RandomForest classifier trained for viral population datasets that classifiers 35-mers as erroneous or rare variants using counts of 35-mers, 23-mers, and 13-mers. 

3. Use the final script parse_pred.pl to generate list of 35-mers that are error free

perl parse_pred.pl input.classifier.output.txt input.35 34 > output.errorfree.35 


Parameters:
	1. -t : threshold for k-mers that have high confidence of being error free. typically greater than average sequencing coverage
	3. last parameter for parse_pred.pl : has to be one less than the threshold (t) used in featureset.pl 


If any questions, contact raunaq@psu.edu

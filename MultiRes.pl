# Wrapper main file for Multi-Resolution of k-mers for error correction
# USAGE: perl MultiRes.pl -fas <fastafile> | -fq <fastqfile> -out <outputerrorcorrected k-mers> -k <35>
# The program takes as input a fasta or fastq file and outputs a collection of error corrected k-mers 
# that can be used for assembly/variant calling in the viral population. 
# k is the k-mer size (defaults to 35)

use Getopt::Long;

$fastafile = "";
$fastqfile = "";
$flag_fasta = 0;
$flag_fastq = 0;
$outputfile = "ECkmers.txt";
$kmerstart = 35;
$upper_threshold = 30;
GetOptions("fas:s",\$fastafile,"fq:s",\$fastqfile,"out:s",\$outputfile,"k:i",\$kmerstart);

main();

sub main
{
	parse_args();
	# Perform k-mer counting first
	if($flag_fasta ==1)
	{
		# Run multi-dsk with countslist.txt file, memory of 8gb and 10000 mb disk space
		system("multi-dsk/multi-dsk $fastafile countslist.txt -m 8192 -d 10000");
	}
	if($flag_fastq ==1)
	{
		system("multi-dsk/multi-dsk $fastqfile countslist.txt -m 8192 -d 10000");
	}
	# Convert solid k-mer counts to "kmer count" text files
	@kmerlists = `ls *solid_kmers_binary*`;
	@writefiles = ();
	for $k (@kmerlists)
	{
		$writefile = $k;
		$writefile =~ s/solid_kmers_binary.//;
		push @writefiles, $writefile;
		system("multi-dsk/parse_results $k > $writefile");
	}
	# Convert the k-mer counts into features that can be used by classifier
	system("perl featureset.pl -k1 $writefiles[2] -k2 $writefiles[1] -k3 $writefiles[0] -t $upper_threshold >featuresset.txt");
	
	# Classify k-mers as erroneous or rare variants 
	system("python PredictErrorCorrection1.py train1_models_pkl/RandomForset.pkl featuresset.txt errorcorrect.temp");
	
	# Combine all predicted rare variants and normal k-mers
	
	system("perl parse_pred.pl errorcorrect.temp $writefiles[2] $upper_threshold > $outputfile");

}


sub parse_args
{
	if($fastqfile eq "" && $fastafile eq "")
	{
		die("Enter at least one fasta or fastq file for error correction\n");
	}
	elsif($fastafile ne "" && $fastqfile eq "")
	{
		$flag_fasta = 1;
	}
	elsif($fastqfile ne "" && $fastafile ne "")
	{
		print "Entered both fasta or fastq file, Proceeding with fastq file\n";
		$flag_fastq = 1;
		$flag_fasta = 0;
	}
	else
	{
		$flag_fastq = 1;
	}
	# Setting k-mer max count to 35 and two lower counts to 23 and 13. Model needs to be trained for other parameters
	$kmerstart = 35;
	$subkmer1 = 23;
	$subkmer2 = 13;
	# Create a file that stores the values of the k-mer values for which the counting needs to be performed
	open(file,">countslist.txt");
	print file "$kmerstart\n$subkmer1\n$subkmer2\n";
	close file;
}

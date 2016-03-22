# Wrapper main file for Multi-Resolution of k-mers for error correction
# USAGE: perl MultiRes.pl -fas <fastafile> | -fq <fastqfile> -out <outputerrorcorrected k-mers> -k <35>
# The program takes as input a fasta or fastq file and outputs a collection of error corrected k-mers 
# that can be used for assembly/variant calling in the viral population. 
# k is the k-mer size (defaults to 35)

use Getopt::Long;
use File::Basename;

$fastafile = "";
$fastqfile = "";
$flag_fasta = 0;
$flag_fastq = 0;
$outputfile = "ECkmers.txt";
$kmerstart = 35;
$base_dir = "";
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
		print "Executing command :\nmulti-dsk/multi-dsk $fastafile countslist.txt -m 8192 -d 10000\n"; 
	}
	if($flag_fastq ==1)
	{
		system("multi-dsk/multi-dsk $fastqfile countslist.txt -m 8192 -d 10000");
		print "Executing comman:\nmulti-dsk/multi-dsk $fastqfile countslist.txt -m 8192 -d 10000\n";
	}
	# Convert solid k-mer counts to "kmer count" text files
	@kmerlists = `ls *solid_kmers_binary*`;
	@writefiles = ();
	for $k (@kmerlists)
	{
		chomp($k);
		print "$k\n";
		$writefile = $k;
		$writefile =~ s/solid_kmers_binary.//;
		print "Writing kmer counts of $k to $writefile\n";
		push @writefiles, $dirname."/".$writefile;
		$cmd = `python multi-dsk/parse_results.py $k > $dirname/$writefile`;
		$cmd = `rm $k`;
	}
	# Clean up temporary files from multi-dsk
	$cmd = `rm write_counts.txt`;
	$cmd = `rm *reads_binary`;
	
	# Convert the k-mer counts into features that can be used by classifier
	# $cmd  = `perl featureset.pl -k1 $writefiles[2] -k2 $writefiles[1] -k3 $writefiles[0] -t $upper_threshold >featuresset.txt`;
	$cmd  = `perl featureset.pl -k1 $writefiles[2] -k2 $writefiles[1] -k3 $writefiles[0] -t $upper_threshold >$dirname/featuresset.txt`;
	print "Executing command:\n$cmd\n";
	# Classify k-mers as erroneous or rare variants 
	system("python PredictErrorCorrection1.py train1_models_pkl/RandomForest.pkl $dirname/featuresset.txt $dirname/errorcorrect.temp");
	print "Running ErrorCorrection Prediction:\npython PredictErrorCorrection1.py train1_models_pkl/RandomForest.pkl $dirname/featuresset.txt $dirname/errorcorrect.temp\n";
	# Combine all predicted rare variants and normal k-mers
	
	system("perl parse_pred.pl $dirname/errorcorrect.temp $writefiles[2] $upper_threshold > $dirname/MultiResCorrected.35");
	# Use error-corrected 35-mers for predicting error correct \kmerstart 
 	system("perl computeTruesetFordifferentK.pl -kmerfile $writefiles[3] -multires $dirname/MultiResCorrected.35  -o $outputfile");
	print "Error correction completed successfully, results are stored in $outputfile\n";
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
		$dirname = dirname($fastafile);
		print "Dirname is $dirname\n";
	}
	elsif($fastqfile ne "" && $fastafile ne "")
	{
		print "Entered both fasta or fastq file, Proceeding with fastq file\n";
		$flag_fastq = 1;
		$flag_fasta = 0;
		$dirname = dirname($fastqfile);
		print "Dirname is $dirname\n";
	}
	else
	{
		$flag_fastq = 1;
		$dirname = dirname($fastqfile);
		print "Dirname is $dirname\n";
	}
	# Setting k-mer max count to 35 and two lower counts to 23 and 13. Model needs to be trained for other parameters
	# $kmerstart = 35; Set by the user, assumed for now to be greater than 35
	$subkmer0 = 35;
	$subkmer1 = 23;
	$subkmer2 = 13;
	# Create a file that stores the values of the k-mer values for which the counting needs to be performed
	open(file,">countslist.txt");
	if($kmerstart > $subkmer0)
	{
		print file "$kmerstart\n$subkmer0\n$subkmer1\n$subkmer2\n";
	}
	else
	{
		print file "$subkmer0\n$kmerstart\n$subkmer1\n$subkmer2\n";
	}
	close file;
}

# Wrapper main file for Multi-Resolution of k-mers for error correction
# USAGE: perl MultiRes.pl -fas <fastafile> | -fq <fastqfile> -out <outputerrorcorrected k-mers> -k <35>
# The program takes as input a fasta or fastq file and outputs a collection of error corrected k-mers 
# that can be used for assembly/variant calling in the viral population. 
# k is the k-mer size (defaults to 35)

use Getopt::Long;

$fastafile = "";
$fastqfile = "";
$outputfile = "ECkmers.txt";
$kmerstart = 35;
GetOptions("fas:s",\$fastafile,"fq:s",\$fastqfile,"out:s",\$outputfile,"k:i",\$kmerstart);

main();

sub main
{
	parse_args();
	# Perform k-mer counting first
	
	# Convert the k-mer counts into features that can be used by classifier
	
	# Classify k-mers as erroneous or rare variants 
	
	# Combine all predicted rare variants and normal k-mers
	

}
sub parse_args
{
	if($fastqfile eq "" && $fastafile eq "")
	{
		die("Enter at least one fasta or fastq file for error correction\n";
	}

	if($fastqfile ne "" && $fastafile ne "")
	{
		print "Entered both fasta or fastq file, Proceeding with fastq file\n";
	}
	# Setting k-mer max count to 35 and two lower counts to 23 and 13. Model needs to be trained for other parameters
	$kmerstart = 35;
	$subkmer1 = 23;
	$subkmer2 = 13;
}

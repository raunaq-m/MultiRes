# Script to predict error-free k-mers of a given size using the error-free k-mers from MultiRes' prediction
# USAGE:perl computeTruesetFordifferentK.pl -kmerfile <inputfile> -multires <MultiresoutputFile> -o <outputfile>

use Getopt::Long;

$inputfile = "";
$multiresfile = "";
$outputfile = "";
%add_true_kmer = ();
$K_size = 0;

GetOptions("kmerfile=s",\$inputfile,"multires=s",\$multiresfile, "o:s", \$outputfile) or die("Error in input arguments\nUSAGE:perl computeTruesetFordifferentK.pl -kmerfile <inputfile> -multires <MultiresoutputFile> -o <outputfile>\n");
die("Error in input arguments\nUSAGE:perl computeTruesetFordifferentK.pl -kmerfile <inputfile> -multires <MultiresoutputFile> -o <outputfile>\n") if $inputfile eq "";
die("Error in input arguments\nUSAGE:perl computeTruesetFordifferentK.pl -kmerfile <inputfile> -multires <MultiresoutputFile> -o <outputfile>\n") if $multiresfile eq "";
if($outputfile eq "")
{
	$outputfile = $inputfile."EC.txt";
}

main();

sub main
{
	loadMultiResKmers();
	ComputeErrorFreeKmers();
}

sub loadMultiResKmers
{
	open(file,$multiresfile) or die("Please enter a valid MultiRes file, $multiresfile did not open\n");
	while($l=<file>)
	{
		chomp($l);
		($kmer,$count) = split(/ /,$l);
		# Add True kmer to a hashtable
		$add_true_kmer{$kmer} = $count;
	}
	#Obtain an appropriate k-mer size
	$K_size = length($kmer);
	close file;
	print "Loaded ".scalar(keys %add_true_kmer)." total $K_size-mers into memory\n";
}

sub ComputeErrorFreeKmers
{
	open(file,$inputfile) or die("Error in input k-mer file, $inputfile did not open\n");
	$counter = 0;
	$start = time;
	open(wrfile, ">$outputfile");
	while($l=<file>)
	{
		chomp($l);
		($kmer,$count) = split(/ /,$l);
		$discard_kmer = 0;
		$discard_val = 0;
		# Assume kmer is correct
		$counter ++;
		for($i=0;$i<length($kmer); $i=$i+$K_size)
		{
			if((length($kmer)-$i)>=$K_size)
			{
				$temp_k = substr($kmer,$i,$K_size);
				$temp_rev_k = revcomplement($temp_k);
			}
			else
			{	
				$temp_k= substr($kmer,-$K_size);
				$temp_rev_k = revcomplement($temp_k);
			}
			# If neither the sub-kmer or its reverse complement are present in the multires output, then the outer kmer needs to be discarded. 
			if(!(exists($add_true_kmer{$temp_k}) or exists($add_true_kmer{$temp_rev_k})))
			{
				$discard_kmer = 1;
				$discard_val = $i;
			}
		}
		# Print a k-mer if it is okay. 
		if ($discard_kmer == 0 )
		{
			print wrfile "$l\n";
		}
		else
		{
			# DEBugging mode
			# print "$kmer $count $discard_val\n"
	
		}
		if (($counter % 1000000) ==0)
		{
			$update_timer = time - $start;
			$start= time;
			print "$counter k-mers read in $update_timer seconds\n";

		}
	}
	close file;
	close wrfile;
}

sub revcomplement
{
	my($str) = $_[0];
	$str = scalar reverse $str;
	$rev_str="";
	for (my($i)=0;$i<length($str);$i++) {
		if(substr($str,$i,1) eq "A") {$rev_str = $rev_str."T";} 
		elsif(substr($str,$i,1) eq "T") {$rev_str = $rev_str."A";}
		elsif(substr($str,$i,1) eq "C") {$rev_str = $rev_str."G";}
		elsif(substr($str,$i,1) eq "G") {$rev_str = $rev_str."C";}
		else	{$rev_str = $rev_str."N"; } 
		
	}
	return $rev_str;
}



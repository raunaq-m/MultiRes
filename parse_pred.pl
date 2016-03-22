#open the RandomForest predicted set of k-mers that are error free
#open the list of k-mers with their counts. 
#Generate a file that contains the error-free k-mers and their counts using the counts file 
#Also list the k-mers with counts greater than threshold

if(scalar(@ARGV)<2)
{
	print "USAGE: perl parse_pred.pl errorFreeKmers Allkmers UpperThreshold > OutPutFile \n";
	exit(0);
}
open(file,$ARGV[0]); # error-free k-mers
while($l=<file>)
{
	if(substr($l,0,1) ne "#")
	{
		chomp($l);
		$true_kmer{$l} = 1;
	}
}
close file;

$u_threshold = $ARGV[2]; #upper threshold 
$l_threshold = 2;	# threshold
open(file,$ARGV[1]); # all the k-mer counts
while($l=<file>)
{
	chomp($l);
	($kmer,$count) = split(/ /,$l);
	if($count>$u_threshold)
	{
		print $l."\n";
	}
	if(exists($true_kmer{$kmer})&& $count>$l_threshold)
	{
		print $l."\n";
	}
}
close file;


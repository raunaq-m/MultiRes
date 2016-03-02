# open the true k-mer's file and store them
# opwn the predicted set of k-mers from an algorithm
# compute measures like preicion, recall, false-positives for each 

open(file,$ARGV[0]); # true k-mers
while($l=<file>)
{
	chomp($l);
	($kmer,$count) = split(/ /,$l);
	$true_kmer{uc($kmer)} = 1;
}
close file;

$true_positive  =0;
$false_positive =0;
# open the EC file 
open(file,$ARGV[1]); # Error corrected file from an algorithm 
while($l=<file>)
{
	chomp($l);
	($kmer,$count) = split(/ /,$l);
	if(exists($true_kmer{$kmer}) || exists($true_kmer{revcomplement($kmer)}))
	{
		$true_positive++;
		if(exists($true_kmer{$kmer}))
		{
			$true_kmer{$kmer} = 5;
		}else
		{
			$true_kmer{revcomplement($kmer)} = 5;
		}
	}
	else 
	{
		$false_positive ++;
	}
}

$false_negative = 0;
for $k(sort {$true_kmer{$a} <=> $true_kmer{$b}  } keys %true_kmer)
{
	if($true_kmer{$k} ==1)
	{
		#print $k."\n";
		$false_negative++;
	}
}

$precision = $true_positive/($true_positive+$false_positive);
$recall = 1- $false_negative/scalar(keys %true_kmer); 
$fpr = $false_positive/$true_positive;
print "True positive:$true_positive\nFalse positive:$false_positive\nFalse negative:$false_negative\nPrecision:$precision\nRecall:$recall\nFPR:$fpr\n";

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



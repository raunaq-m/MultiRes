#Open the k-mer counts file and create a histogram output file, containing the k-mer counts and the number of k-mers at that count 
#USAGE : perl make_histogram.pl <kmercounts file>  

open(file,$ARGV[0]) or die("Enter kmer counts file\nUSAGE : perl make_histogram.pl <kmercounts file>\n");

%histogram = ();
while($l=<file>)
{
	chomp($l);
	($kmer,$count) = split(/ /,$l);
	$histogram{$count} ++;
}
close file;

for $k(sort {$a<=>$b} keys %histogram)
{
	print "$k\t$histogram{$k}\n";
}

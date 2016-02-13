# Use three k-mer values for computation of the features from the k-mer counts 
# Input parameters are k1, the largest k-mer's count file
# k2, second largest k-mer's count file
# k3 third largest k-mer's count file 
# t is the threshold below which all the k-mers are extracted
use Getopt::Long;


$k1 = "";
$k2 = "";
$k3 = "";
$k4 = "";
$k5 = "";
$truefile = "";
$threshold = 0;

GetOptions( "k1=s", \$k1, "k2=s", \$k2, "k3:s", \$k3, "t=i",\$threshold,"k4:s",\$k4,"k5:s",\$k5 , "true:s", \$truefile) or die ("ERROR IN INPUTS \n");

%hash = ();
$L1 = loadkmerhash($k2);
$L2 = loadkmerhash($k3) if $k3 ne "";
$L3 = loadkmerhash($k4) if $k4 ne "";
$L4 = loadkmerhash($k5) if $k5 ne "";

%truehash = ();
# Load status of kmers as true or false in the training mode. 
loadtruehash() if $truefile ne "";


#print "#$k1 $k2 $k3 $threshold\n";
#print "#$L1 $L2 \n";

featureset($k1,$L1,$L2,$threshold);
# featureset_5($k1,$L1,$L2,$L3,$L4, $threshold); 

sub loadtruehash
{
open(file,$truefile); # true kmers file
while($l=<file>)
{
	chomp($l);
	($km,$count) = split(/ /,$l);
	$truehash{$km} = 1;
}
close file;
}

sub loadkmerhash
{
	my($file) = shift;
	open(ff,$file);
	my($L) = 0; #Length of kmer
	while($l=<ff>)
	{
		chomp($l);
		($kmer,$count) =  split(/ /,$l);
		$hash{$kmer} = $count;
		$L = length($kmer);
	}
	close ff;
	return $L;
}

sub featureset 
{
	my($file) =$_[0];
	my($F1) = $_[1];
	my($F2) = $_[2];
	my($thresh) = $_[3];
#	print "#Processing $file for features\n";
	open(ff,$file);
	while($l=<ff>)
	{
		chomp($l);
		($kmer,$count) = split(/ /,$l);
		if($count < $threshold )
		{
			print "$kmer $count ";
			for(my($i) = 0;$i<length($kmer)-$F1+1;$i++)
			{
				print "$hash{substr($kmer,$i,$F1)} ";
			}
			if($F2>0) {
				for(my($i) = 0;$i<length($kmer)-$F2+1;$i++)
				{
					print "$hash{substr($kmer,$i,$F2)} ";
				}			
			}
			print "\n";
		}
	}
}

sub featureset_5 
{
	my($file) =$_[0];
	my($F1) = $_[1];
	my($F2) = $_[2];
	my($F3) = $_[3];
	my($F4) = $_[4];
	my($thresh) = $_[5];
#	print "#Processing $file for features\n";
	open(ff,$file);
	$feature = $file."fe";
	$label = $file."fe.txt";
	open(wr1,">$feature");
	open(wr2,">$label");
	while($l=<ff>)
	{
		chomp($l);
		($kmer,$count) = split(/ /,$l);
		if($count < $threshold )
		{
			print wr1 "$kmer $count ";
			if(exists($truehash{$kmer}))
			{
				print wr2 "1 $count ";
			}else
			{
				print wr2 "0 $count ";
			}
			for(my($i) = 0;$i<length($kmer)-$F1+1;$i++)
			{
				print wr1 "$hash{substr($kmer,$i,$F1)} ";
				print wr2 "$hash{substr($kmer,$i,$F1)} ";
			}
			if($F2>0) {
				for(my($i) = 0;$i<length($kmer)-$F2+1;$i++)
				{
					print wr1 "$hash{substr($kmer,$i,$F2)} ";
					print wr2 "$hash{substr($kmer,$i,$F2)} ";
				}	
			}
			if($F3>0) {
				for(my($i) = 0;$i<length($kmer)-$F3+1;$i++)
				{
					print wr1 "$hash{substr($kmer,$i,$F3)} ";
					print wr2 "$hash{substr($kmer,$i,$F3)} ";
				}			
			}
			if($F4>0) {
				for(my($i) = 0;$i<length($kmer)-$F4+1;$i++)
				{
					print wr1 "$hash{substr($kmer,$i,$F4)} ";
					print wr2 "$hash{substr($kmer,$i,$F4)} ";
				}			
			}		
			print wr1 "\n";
			print wr2 "\n";
		}
	}
	close ff;
	close wr1;
	close wr2;
}

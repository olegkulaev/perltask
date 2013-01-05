use utf8;

sub returnPrefix($$) {
	local ($first,$second) = @_;
	local $i=0,$result='',$flen = length $first,$slen = length $second;
	for ($i=0;$i<=$flen && $i<=$slen;$i++) {
		$fprefix = substr $first,0,$i;
		$sprefix = substr $second,$slen-$i,$i;
		if ($fprefix eq $sprefix && length $fprefix > length $result) {
			$result = $fprefix;
		}
	}
	return $result;
}
my %hash;
my @word;
print "enter name of file: \n";
my $name = <>;
open $F,"$name" or die $!;
binmode $F,':utf8';
binmode STDOUT,':utf8';
while (<$F>) {
	chomp;
	@word[$#word+1] = $_;
}
close $F;
print "Reading ended, counting\n";
$resultPrefix;
$resultFirst;
$resultSecond;
$i=0;
$all = $#word;
foreach $first (@word) {
	print $i++." from ".$all."\n";
	foreach $second (@word) {
		$prefix = returnPrefix($first,$second) if ($first ne $second);
		if (length $prefix > length $resultPrefix) {
			$resultPrefix = $prefix;
			$resultFirst = $first;
			$resultSecond = $second;
		}	
	}
}
print $resultPrefix."  ".$resultFirst."   ".$resultSecond;
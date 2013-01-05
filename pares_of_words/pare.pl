#!/usr/bin/perl -l

# must display the most frequence pares of words

use utf8;
use pare;
use Encode;

if ($ARGV[0]) {
	open $F,'<:utf8', "$ARGV[0]" or die $!;
} else {
	print "Please input correct name of file with text..";
	$argv = <>;
	chomp $argv;
	exit unless $argv;
	open $F,'<:utf8', "$argv" or die $!;
}
if ($ARGV[1]) {
	open $S,'<:utf8',"$ARGV[1]" or die $!;
} else {
	print "Please input correct name of dictionary of non-words..";
	$argv = <>;
	chomp $argv;
	exit unless $argv;
	open $S,'<:utf8',"$argv" or die $!;
}

{
	local $/;
	$str = <$F>;
	$str_rdc = <$S>;
	exit unless $str;
}
@sentence = split /[\!\.\?\n]/,$str;
map {
	print;
}@sentence;
$k=0;
$obj = pare->new();
$queue = $obj;
$start = $obj;
print 'Wait a while, a programm is counting frequensy of pairs in all sentensec';
$count = scalar $#sentence;
$how_many_strings=0;
foreach (@sentence) { 
	print $how_many_strings++," from $count..";
 	@a = split /\W/;
	$word[$k] = \@a;
	for ($i=0;$i<=$#{$word[$k]};$i++) {
		for ($j=$i;$j<=$#{$word[$k]};$j++) {
			$first = lc($word[$k]->[$i]);
			$second = lc($word[$k]->[$j]);
			chomp $first;
			chomp $second;
			if (($first =~ /\w/) && ($second =~ /\w/) && ($i != $j) && !($str_rdc=~/\W$first\W/i) && !($str_rdc=~/\W$second\W/i)) {
				$queue = $start;
				$Main::flag = 0;
				if (!$queue->{first}) {
					$queue->{first} = $first;
					$queue->{second} = $second;
					$queue->{freq} = 1;
				} else {
				while ($queue->{next}) {
if ((($first eq $queue->{first})&&($second eq $queue->{second}))||((($first eq $queue->{second})&&($second eq $queue->{first})))){
						$queue->{freq}++;
						$Main::flag=1;
						last;
					}
					$queue = $queue->{next};
				}	
				
				if (!$Main::flag) {
					$queue->{next} = pare->new($first,$second,1);
				}
				}
			}
	}
	}
	$k++;

}
$queue = $start;
$max = 0;
print 'counting is end, now choosing the most frequency pares ';
while ($queue) {
	if ($queue->{freq} > $max) {
		$max = $queue->{freq};
	}
	$queue = $queue->{next};
}
print "There is no any pares\n" and exit if !$max;
print "Answer is:";
binmode STDOUT,':utf8';
while ($obj) {
	if ($obj->{freq} == $max) {
	print "'$obj->{first}' - '$obj->{second}' - '$obj->{freq}' \n";
}
$obj = $obj->{next};
}
close $F;
close $S;

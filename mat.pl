use threads;
print getElement('1 2 3','3 2 1');
glob $input;

$n = <>;
chomp $n;

for ($i=0;$i<$n;$i++) {
		$line = <>;
		chomp $line;
		$line->[$i] = split / /,$line;
}

sub getElement {
	local ($first,$second) = @_;
	local $result;
	@first = split / /,$first;
	@second = split / /,$second;
	for ($i = 0;$i<$#first;$i++) {
		$result+=$first[$i]*$second[$j];
	}
	return $result;
}

sub getLine {
	local $i = shift;
	local $element;
	for ($j=0;defined $input->[$j]->[$i];$j++) {
		$element+=$input->[$i]->[$j];
	}
	return $element;
}

sub getColumn {
	local $i = shift;
	local $element;
	for ($j=0;defined $input->[$j]->[$i];$j++) {
		$element+=$input->[$j]->[$i];
	}
	return $element;
}

my @result;
for ($i = 0;$i<$n;$i++) {
	for ($j=0;$j<=$n;$j++) {
		$result->[$i]->[$j] = threads->create(getElement,getLine($i),getColumn($j));
	}
}


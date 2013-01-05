#TODO
#написать хэлп и документацию
#добавить обработу F<>
#разобратьс€ все таки с ссылками
sub getParagraph($) {
	local $F = shift;
	local $result,$line;

	while (($line = <$F>) !~ /^$/) {
		$result.=$line;
	}
	return $result;
}

sub isCommand($) {
	local $_ = $_[0];
	if ( (/^=back$/) || (/^=head.*$/) || (/^=item.*$/) || (/^=over *\d+$/)) {
		return 1;
	} else {
		return 0;
	}
	}

sub isVerbatim($) {
	return 1 if $_[0] =~ /^ /;
	return 0;
}

sub commandHandler($\@) {
	local ($_,$tab) = @_;
	if (/^=head/) {
		s/=head(\d) *(.*)/"<a name=\"$2\"><\/a><h$1 id='$2'>$2<\/h$1>"/e;
	} elsif (/^=item/) {
		s/=item +/<li>/;
	} elsif (s/^=over *+//) {
		local $buffer='';
		local $numb = $_;
		for (1 .. $numb) {
			$buffer.=" ";
		}
		push @{$tab}, $buffer;
		$_='';
	} elsif (s/=back *+//) {
		pop @{$tab};
	} else {
		return $& if $_ =~ s/(=pod)|(=cut)//;
	}
	return $_;
}

sub styleHandler($) {
	local ($_) = @_;
	local @input = split //;
	my @result,$char='',$buffer='',$res,$local_result,@local_result;
	for ($i=0;$i<=$#input;$i++) {
		$char = $input[$i];
		if ($char =~ /([IBCLEUF])/) {
			$buffer.=$1;
		} elsif ($buffer) {
			if ($char eq '<') {
				$buffer.=$char;
				push @result,$buffer;
				$buffer = '';
				$stack_with_bracket++;
			} else {
				push @result,$buffer;
				push @result,$char;
				$buffer = '';
			}
		} elsif ($char eq '>' && $stack_with_bracket) {
			local $start,$end,$j = $i;
			while ($j>=0 && $result[$j] !~ /^([IBCLEFU])<$/) {
				--$j;
			}
			$symb = $result[$j];
			$start = '<ins>' if $symb eq 'U<';
			$start = '<i>' if $symb eq 'I<';
			$start = '<b>' if $symb eq 'B<';
			$start = '&' if $symb eq 'E<';
			$start = '<code>' if $symb eq 'C<';
			$start = '<a>' if $symb eq 'F<';
			$start = '<a>' if $symb eq 'L<';
			($end = $start) =~ s/</<\// if $start!~ /<a>/;
			($end = '</a>') if $start =~ /<a>/;
			$result[$j] = $start;
			push @result,$end;
			
		} else {
			push @result,$char;
		}
	}
	local $paragraph = join('',@result);
	while ($paragraph =~ /(<a>(.*?)<\/a>)/) {
			$a = $1;
			@links = $2 =~ /(.*?)\|(.*)/;
			if (defined $links[1]) {
				$paragraph =~ s/<a>(.*?)<\/a>/<a href='$links[1]'>$links[0]<\/a>/;
			} else {
				$paragraph =~ s/<a>(.*?)<\/a>/<a href='$1'>$1<\/a>/;
			}
	}
	return $paragraph;
}

#открытие файла
if ( $ARGV[0] and -f $ARGV[0] ) { 
	open $F,"$ARGV[0]" or die $!;
	open $D,"> $ARGV[0].html" or die $!;
} else {
	print "PLease enter name of file, which would be formatted: ";
	local $a = <>;
	chomp $a;
	open $F,"$a" or die $!;
	open $D,"> $a.html" or die $!;
}

# алгоритм:
# считываем строку
# если пуста€ строка то ничего не делай
# если это управл€юща€ строка ex. =head
# 	обработка команды
# если это дословный параграф(начинаетс€ с пробела), тогда 
# 	считываем остаток текущего параграфа
#	и записываем строку+параграф в выходной файл без изменений
# если это не дословный параграф тогда производим замену
# 	и записываем строку+параграф в выходной файл бе изменений
my $paragraph='',$result,@tab = ('');
while ($paragraph = getParagraph($F)) {
	if (isCommand($paragraph)) {
		$result.=$tab[$#tab].commandHandler($paragraph,@tab);
	} elsif (isVerbatim($paragraph)) {
		$result = $result.$tab[$#tab].'<pre>'.$paragraph.'</pre>';
	} else {
		$paragraph = styleHandler($paragraph);
		$result .= '<pre>'.$tab[$#tab].$paragraph.'</pre>';
	}
	$result.="\n";
}
print $D $result;

close $D or die $!;
close $F or die $!;
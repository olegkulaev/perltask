use Test::More;

sub isCommand($) {
	local $_ = $_[0];
	if ( (/^=back$/) || (/^=head.*$/) || (/^=item.*$/) || (/^=over *\d+$/)) {
		return 1;
	} else {
		return 0;
	}
}

sub commandHandler($\@) {
	local ($_,$tab) = @_;
	if (/^=head/) {
		s/=head(\d) *(.*)/"<a name=\'$2\'><\/a><h$1 id='$2'>$2<\/h$1>"/e;
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
my @tab=('');

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
ok(isCommand('=head1') == 1,'testing sub "isCommand"');
ok(isCommand('=item') == 1);
ok(isCommand('=over 5') == 1);
ok(isCommand('=back') == 1);
ok(isCommand('=over') == 0);
ok(isCommand('=head') == 1);
ok(isCommand('') == 0);
ok(isCommand('=ololo') == 0);
ok(isCommand('==back') == 0);

ok(commandHandler('=over 3',@tab) eq '','testing sub commandHandler, over\back');
ok($tab[$#tab] eq '   ');
ok(commandHandler('=over 2',@tab) eq '');
ok($tab[$#tab] eq '  ');
ok(commandHandler('=back',@tab) eq '');
ok($tab[$#tab] eq '   ');
ok(commandHandler('=back',@tab) eq '');
ok($tab[$#tab] eq '');
ok(commandHandler('=head1 text',@tab) eq "<a name='text'></a><h1 id='text'>text</h1>",'testing sub commandHandler, head');
ok(commandHandler('=head2 text',@tab) eq "<a name='text'></a><h2 id='text'>text</h2>");
ok(commandHandler('=head3 text',@tab) eq "<a name='text'></a><h3 id='text'>text</h3>");
ok(commandHandler('=head4 text',@tab) eq "<a name='text'></a><h4 id='text'>text</h4>");
ok(commandHandler('=item text',@tab) eq "<li>text",'testing sub commandHandler, item');

ok(styleHandler('L<oleg|http://vk.com>') eq "<a href='http://vk.com'>oleg</a>",'testing sub styleHandler');
ok(styleHandler('L<http://vk.com>') eq "<a href='http://vk.com'>http://vk.com</a>");
ok(styleHandler('F<test.pl>') eq "<a href='test.pl'>test.pl</a>");
ok(styleHandler('U<oleg>') eq "<ins>oleg</ins>");
ok(styleHandler('B<oleg>') eq "<b>oleg</b>");
ok(styleHandler('C<oleg>') eq "<code>oleg</code>");
ok(styleHandler('I<Olololeg>') eq '<i>Olololeg</i>');
ok(styleHandler('I<1B<2>>') eq "<i>1<b>2</b></i>");
ok(styleHandler('I<1U<2>>') eq "<i>1<ins>2</ins></i>");
ok(styleHandler('I<1C<2>>') eq "<i>1<code>2</code></i>");
done_testing();
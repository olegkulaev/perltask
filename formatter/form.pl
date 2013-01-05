#
#����������� ������� � ���������� �� ������, ������ ��� � ������ ����, ��� ������� ������ ������ ("" ��� '',�� �� \"\" � �� \'\') ������ �������
#
#

sub spaceAvtomat($){
	local @table,$sost = 0,$char='',$result='',$i=0,$prev_sost=0;
	local $input = $_[0];
	if ($input !~ /['"]/) {
		$input =~ s/ +/ /g;
		return $input;
	}
	%table = (
			'"' => [2,0,6,2,4,4,2,2],
			"'" => [4,0,2,2,6,4,4,4],
			"\\\\" => [1,0,3,2,5,4,1,1],
			'\s' => [7,7,2,2,4,4,0,7],
			"[^\"'\\\\ ]" => [0,0,2,2,4,4,0,0]
	);
	local @input = split //,$input;
	local $buffer='';
	while ( defined($input[$i]) && ($char = $input[$i])) {
		foreach (keys %table) {
			if ($char =~ /$_/) {
				$sost = $table{$_}->[$prev_sost];
				#print "char: $char ; sost: $sost ; result : $result ; buff : $buffer\n";
				if ($sost == 6) {
					#print "writing\n";
					$buffer .=$char;
					$result .=$buffer;
					$buffer = '';
				} elsif (($sost != 7) && ($prev_sost == 7)) {
					 #print "subs\n";
					 $buffer =~ s/ ++/ /g;
					 $result .= $buffer;
					 $buffer = $char;
					
				} else {
					$buffer.=$char;
				}
				$prev_sost = $sost;
			}
			
		}
		++$i;
	}
	$result.=$input[$#input] if $input[$#input] !~ /["]/;
	#print "input : '$input' ; result = '$result'\n";
	return $result;
}
# a    =    "  sadasdasd sadas    s"    " sad"
# a    =    "  sadasdasd sadas    s"    '   sad'
# a    =    "  sadasdasd s\"adas    s"    " sad"
#
#
if ($ARGV[0] =~ /(--help)|(-help)|(-h)|(--h)/) {
	print "usage:\n";
	print "perl form.pl <name of file which would be formatted>\n";
	system('notepad readme.txt');
	exit;
}

#
#��������� ����� � ��������� �����
#

#�������� ����� � ��������� �����
if (!-e 'description') {
	print "If you want correct work, please, add in this directory file description, format of file you may find in readme";
	exec('notepad readme.txt');
} else {
	open $D,'description' or die $!;
}

my $d;
{
	local $/;
	$d = <$D>;
}

my %comment;
#������ ������ �������� �� ����� � ��������� �����
if ( $d =~ /comment\n-start\ *\"(.+?)\"\n-end\ *\"(.+?)\"\n-inline\ +\"(.+?)\"/) {
	$comment{'start'} = $1;
	$comment{'end'} = $2;
	$comment{'inline'} = $3;
}

my @commands;
#���������� ������ �� ����� � ��������� �����
while ( $d =~ /command\ +?\"(.*?)\"\n*/g) {
		push @commands,$1;
}
#���������� ������������ ������
my $commandBreaker = $1 if ($d =~ /commandbreaker\n\"(.*?)\"/);

my %codeBrackets;
#���������� ����������� ������ �� ����� � ��������� �����
if ( $d =~ /codebracket\n-start\ *\"(.+?)\"\n-end\ *\"(.+?)\"/) {
	$codeBrackets{'start'} = $1;
	$codeBrackets{'end'} = $2;
}
close $D or die $!;
#
#��������� ����� � �����
#

#�������� �����
if ( $ARGV[0] and -f $ARGV[0] ) { 
	open $F,"$ARGV[0]" or die $!;
} else {
	print "PLease enter name of file, which would be formatted: ";
	local $a = <>;
	chomp $a;
	open $F,"$a" or die $!;
}
#������ �� �����
{
	local $/;
	$code = <$F>;
}
#����� ���� �� ������������
$code =~ s/($comment{inline})/\n$1/g if $comment{inline};
$code =~ s/($comment{start})/\n$1\n/g if $comment{start};
$code =~ s/($comment{end})/\n$1\n/g if $comment{end};
@code = split /\n/,$code;

my $result = '';
my $comment_flag=0;

#����� ���� �� ������������ � ������� ����
#
#{} => {
#		}
#
#/*{}*/ => /*
#			{}
#			*/
#
#� ��, ��� ��������� ��� ��������� ��� ������ �� ������
foreach $line (@code) {
	next if ($line =~ /^[\t\s\b]*$/);
	$line =~ s/^[\t\s\b]*+//;
	if (($line =~ /$comment{inline}/)) {
	} elsif ($line =~ /^$comment{start}/) {
		$comment_flag = 1; 
	} elsif (($line =~ /$comment{end}/)) {
		$comment_flag = 0;
	} elsif ($comment_flag){
	} else {
		$line =~ s/($commandBreaker)/$1\n/g;
		$line =~ s/(?=[^\n])($codeBrackets{start}|$codeBrackets{end})(?=[^\n])/\n$1\n/g;
	}
	$result.="$line\n";
}


#����� ����������� ���� �� �������
$result =~ s/(\n+)/\n/g;
$result =~ s/(\n[\s\t]*)/\n/g;
@code = split /\n/,$result;

my $out;
$tab = '';
close $F or die $!;
open $R,'>',"formatted_$ARGV[0]" or die $!;
#���������� �������� ��������� ���, ��� ��� �����
#� ����� ������������������ ���� �� ��������� � � ����
map {
	if (/$codeBrackets{start}/) {
		$tab.="\t";
	}
	local $subs = spaceAvtomat($_);
	$_ =  $subs if $subs !~ /^$/;
	$_ = $tab.$_."\n";
	print $_;
	print $R $_;
	if (/$codeBrackets{end}/) {
		$tab =~ s/\t//;
	}
	print $1 if $line =~ //g;
}@code;

#
#SELECT column1 column2 WHERE (column1) OR (column2)
#SELECT column1 column2 WHERE (column1) AND (column2)
#
sub select($\%){
	local $query = shift;
	local $table = shift;
	$columns = $1 if $query =~ /SELECT(.*?)WHERE/;
	@columns = split /[\s\t]/,$columns;
}
#открытие файла с описанием отчёта
if (!-e 'description') {
	print "If you want correct work, please, add file description, format of file you may find in readme";
	exec('notepad readme.txt');
} else {
	open $D,'description' or die $!;
}
close $d;
my $description;
{
	local $/;
	$description = <$D>;
}

@header = split /[\'\s\t\n]/,$description;

#открытие файла с таблицей
my $F;
if ($ARGV[0] && -e $ARGV[0]) {
	open $F,$ARGV[0] or die $!;
} else {
	print "Enter name of file with table:\n";
	$name = <>;
	chomp $name;
	open $F,$name or die $!;
}
my $i = 0,$j=0;
my %table;

# Заполнение таблицы

while (<$F>) {
	@a = split /[ \t]/;
	$,="\n";
	foreach ($i=0;$i<=$#header;$i++) {
		push @{$table{$header[$i]}},$a[$i];
	}
}

print @{$table{$_}} for keys %table;

close $F or die $!;
print "\nprint 'q' if you want to exit\n";
while (<STDIN>) {
	exit if /^q$/;
	print "\nresult:\n".queryHandler($_,%table);
	print "\ntype your query: \n";
}
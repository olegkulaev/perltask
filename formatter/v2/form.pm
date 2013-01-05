package form;
#
#расставляет пробелы в переданной ей строке, делает это с учетом того, что пробелы внутри строки ("" или '',но не \"\" и не \'\') нельзя портить
#делает это с помощью автомата - подстановщика (оО), не понмю точное название
#с плюсами или джавой работает

sub spaceAvtomat($){
	local @table,$sost = 0,$char='',$result='',$i=0,$prev_sost=0;
	local $input = $_[0];
	if ($input !~ /['"]/) {
		$input =~ s/ +/ /g;
		return $input;
	}
	#табличка переходов, если автомат выходит из 7 состояния то он пишет в result один пробел
	#если автомат выходит из 6 состояния, то он пишет в result свой buffer
	#во всех остальных случаях добавляет к буфферу текущий символ, и проходит по табличке
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
	#print "input : '$input' ; result = '$result'\n";
	return $result;
}
1;
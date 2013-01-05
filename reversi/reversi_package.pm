package reversi_package;


sub look_around_cell { # (1or2),$i,$j
	local ($identifier,$i,$j) = @_;
	$direction='';
	if (defined $identifier) {
		if (defined $Main::true[$i-1][$j-1] && (($identifier==1 && $Main::true[$i-1][$j-1]==2) || ($identifier==2 && $Main::true[$i-1][$j-1]==1))){
			$direction = $direction.'1';
		}
		if (defined $Main::true[$i][$j-1] && (($identifier==1 && $Main::true[$i][$j-1]==2) || ($identifier==2 && $Main::true[$i][$j-1]==1))){
			$direction = $direction.'2';
		}
		if (defined $Main::true[$i+1][$j-1] && (($identifier==1 && $Main::true[$i+1][$j-1]==2) || ($identifier==2 && $Main::true[$i+1][$j-1]==1))){
			$direction = $direction.'3';
		}
		if (defined $Main::true[$i+1][$j] && (($identifier==1 && $Main::true[$i+1][$j]==2) || ($identifier==2 && $Main::true[$i+1][$j]==1))){
			$direction = $direction.'4';
		}
		if (defined $Main::true[$i+1][$j+1] && (($identifier==1 && $Main::true[$i+1][$j+1]==2) || ($identifier==2 && $Main::true[$i+1][$j+1]==1))){
			$direction = $direction.'5';
		}
		if (defined $Main::true[$i][$j+1] && (($identifier==1 && $Main::true[$i][$j+1]==2) || ($identifier==2 && $Main::true[$i][$j+1]==1))){
			$direction = $direction.'6';
		}
		if (defined $Main::true[$i-1][$j+1] && (($identifier==1 && $Main::true[$i-1][$j+1]==2) || ($identifier==2 && $Main::true[$i-1][$j+1]==1))){
			$direction = $direction.'7';
		}
		if (defined $Main::true[$i-1][$j] && (($identifier==1 && $Main::true[$i-1][$j]==2) || ($identifier==2 && $Main::true[$i-1][$j]==1))){
			$direction = $direction.'8';
		}
	} else {
		return 0;
	}		
	if ($direction) {
		return "$direction";
	} else {
		return 0;
	}
}
1;

#!/usr/bin/perl

no warnings;

use Gtk2 '-init';
use Glib qw(TRUE FALSE);
use reversi_package;

$|++;
my $quadr = Gtk2::Image->new_from_file('green.png');
#making new image, which is default for the revers pole
my $window = Gtk2::Window->new('toplevel');
#making new main window
$window->signal_connect('delete_event' => sub {Gtk2->main_quit;});
$window->set_icon_from_file('sasha.jpg');
#no comments
$window->set_resizable(0);
$window->set_title('Reversi');
$count = Gtk2::Label->new();
$count->set_text("white-2:2-black");
$table = Gtk2::Table->new(9,11,FALSE);
$table->attach_defaults($count,0,9,10,11);
#making table 9columns and 10 rows which is not homogeneous
$window->add($table);
for ($i=1;$i<=8;$i++)  { #filling the table with default images(green.png)
	$a='a';
	for ($j=1;$j<=8;$j++) {
		$image[$i][$j] = Gtk2::Image->new_from_file('green.png');	
		$table->attach_defaults($image[$i][$j],$i,$i+1,$j,$j+1);
	}
	$a++;
}

for ($i=0;$i<8;$i++) {  #filling in first row with 1,2,3..
	$table->attach_defaults($label[$i] = Gtk2::Label->new("$i"),$i+1,$i+2,0,1);
}

for ($i=0;$i<8;$i++) {  #filling in first column with 1,2,3..
	$table->attach_defaults($label[$i] = Gtk2::Label->new("$i"),0,1,$i+1,$i+2,);
}

$en_one_button = Gtk2::Button->new('Push'); #making and filling last row with input area and button
$en_one = Gtk2::Entry->new();
$en_one->set_max_length(3);
$en_one_button->signal_connect('clicked'=>sub {
	
	my ($event,$widget) = @_;
	user_input($event,$widget,\$counter);
	}
	
	);
$table->attach_defaults($en_one,0,7,9,10);
$table->attach_defaults($en_one_button,7,10,9,10);
$window->set_position('center');
$window->show_all();
set_black(3,4); #setting starting position and filling associated array 'true'
set_black(4,3);
set_white(3,3);
set_white(4,4);
sub user_input{ #function wich works with users input
	local ($event,$widget,$counter) = @_;
	$_ = $en_one->get_text;
	@a = /(\d)[^\d](\d)/;
	if (!$Main::true[$1][$2] && defined $1 && defined $2 && $1<=7 && $1>=0 && $2<=7 && $2>=0) {
	if ($p%2) {
			$Main::true[$1][$2]=1;
			$ident = 1;
			$p++;
		} else {
			$Main::true[$1][$2]=2;
			$ident = 2;
			$p++;
		}

	$list_of_direction = reversi_package::look_around_cell($ident,$1,$2);
	$Main::global_flag = 0;
	direction_handler_user($ident,$1,$2,$list_of_direction);
	if (defined shift @a && defined shift @a && $Main::global_flag) {
		$en_one->set_text('');
		if ($ident == 1) {
			set_black($1,$2);
		} else {
			set_white($1,$2);
		}
	$black = 0;
	$white = 0;
	for ($i=0;$i<8;$i++) {
		for ($j=0;$j<8;$j++) {
			if ($Main::true[$i][$j]==1) {
				$black++;
			} else {
				if ($Main::true[$i][$j]==2) {
					$white++;
				}
			}
		}
	}
	$count->set_text("white-$white:$black-black");
	} 	
	else {
		$p--;
		$Main::true[$1][$2]=0;
		$en_one->set_text('no!');
	}
	if ($p==59) {
		$window1 = Gtk2::Window->new('toplevel');
		$window1->signal_connect('delete_event' => sub {Gtk2->main_quit;});
		$window1->set_position('mouse');
		$window1->maximize();
		$button1 = Gtk2::Button->new('Press to finish');
		$label1 = Gtk2::Label->new;
		$label1->set_text(who_win_at_this_time());
		$vbox = Gtk2::VBox->new(0,0);
		$vbox->pack_start($label1,TRUE,TRUE,0);
		$vbox->pack_end($button1,TRUE,TRUE,0);
		$button1->signal_connect(clicked => sub {Gtk2->main_quit;});
		$window1->add($vbox);
		$window1->show_all();
		$window1->set_title('Who win');
}
} else {
$en_one>set_text('no1');
}
}

sub who_win_at_this_time {
	local ($white,$black) = (0,0);
	for ($i=0;$i<8;$i++) {
		for ($j=0;$j<8;$j++) {
			if ($Main::true[$i][$j]==1) {
				$black++;
			} else {
				if ($Main::true[$i][$j]==2) {
					$white++;
				}
			}
		}
	}
if ($black>$white) {
	return "Black win, with $black:$white";
} else {
	if ($black<$white) {
		return "White win, with $white:$black";
	} else {
		return "Draw on this time!";
	}
} 

}

sub set_black { #it's setting black chess on the i coumn and j row
	local ($i,$j) = (@_);
	$Main::true[$i][$j]=1;
	$i++;
	$j++;
	$image[$i][$j]->set_from_file('bk.png');
	$table->attach_defaults($image[$i][$j],$i,$i+1,$j,$j+1);

}

sub set_white { #it's setting white chess on the i column and j row
	local ($i,$j) = (@_);
	$Main::true[$i][$j]=2;
	$i++;
	$j++;
	$image[$i][$j]->set_from_file('wh.png');
	$table->attach_defaults($image[$i][$j],$i,$i+1,$j,$j+1);
}

sub direction_handler_user { #it's getting (1or2),$i,$j and list of direction this function returns nothing
			#and change colour of chesses on the table correctly
	local ($identifier,$i,$j,$list) = @_;
	@list = split //, $list;	
	local $flag = 0;
	foreach $direct (@list) {
		$ie = $i;
		$je = $j;
		$flag = 0;
	if ($identifier==1) {	
		if ($direct==1) {
			while ($ie>=0 && $je>=0 && $Main::true[$ie][$je] && !$flag) {
				$ie--;
				$je--;
				if ($Main::true[$ie][$je]==1) {
					$Main::global_flag=1; $flag++;
				}
			}
			if ($flag) {
				while ($ie!=$i) {
				$ie++;
				$je++;
				set_black($ie,$je);	
				}
			}
		}
		if ($direct==2) {
			while ($je>=0 && $Main::true[$ie][$je] && !$flag) {
				$je--;
				if ($Main::true[$ie][$je]==1) {
					$Main::global_flag=1; $flag++;
				}
			}
			if ($flag) {
				while ($je!=$j) {
				$je++;
				set_black($ie,$je);	
				}
			}
		}
		if ($direct==3) {
			while ($ie>=0 && $je>=0 && $Main::true[$ie][$je] && !$flag) {
				$ie++;
				$je--;
				if ($Main::true[$ie][$je]==1) {
					$Main::global_flag=1; $flag++;
				}
			}
			if ($flag) {
				while ($ie!=$i) {
				$ie--;
				$je++;
				set_black($ie,$je);	
				}
			}

		}
		if ($direct==4) {
			while ($ie<=7 && $Main::true[$ie][$je] && !$flag) {
				$ie++;
				if ($Main::true[$ie][$je]==1) {
					$Main::global_flag=1; $flag++;
				}
			}
			if ($flag) {
				while ($ie!=$i) {
				$ie--;
				set_black($ie,$je);	
				}
			}

		}
		if ($direct==5) {
			while ($ie>=0 && $je>=0 && $Main::true[$ie][$je] && !$flag) {
				$ie++;
				$je++;
				if ($Main::true[$ie][$je]==1) {
					$Main::global_flag=1; $flag++;
				}
			}
				if ($flag) {
				while ($je!=$j) {
				$ie--;
				$je--;
				set_black($ie,$je);	
				}
			}	
		}
		if ($direct==6) {
			while ($je>=0 && $Main::true[$ie][$je] && !$flag) {
				$je++;
				if ($Main::true[$ie][$je]==1) {
					$Main::global_flag=1; $flag++;
				}
			}
			if ($flag) {
				while ($je!=$j) {
				$je--;
				set_black($ie,$je);	
				}
			}
	
		}
		if ($direct==7) {
			while ($ie>=0 && $je>=0 && $Main::true[$ie][$je] && !$flag) {
				$ie--;
				$je++;
				if ($Main::true[$ie][$je]==1) {
					$Main::global_flag=1; $flag++;
				}
			}
			if ($flag) {
				while ($ie!=$i) {
				$ie++;
				$je--;
				set_black($ie,$je);	
				}
			}
		}
		if ($direct==8) {
			while ($ie<=7 && $Main::true[$ie][$je] && !$flag) {
				$ie--;
				if ($Main::true[$ie][$je]==1) {
					print 1;
					$Main::global_flag=1; $flag++;
				}
			}
			if ($flag) {
				while ($ie!=$i) {
				$ie++;
				set_black($ie,$je);	
				}
			}

		
		}
	} else {  $ie = $i;
		$je = $j;
		$flag = 0;
		print "identifier: $identifier : direction : $direct \n";
		if ($direct==1) {
			while ($ie>=0 && $je>=0 && $Main::true[$ie][$je] && !$flag) {
				$ie--;
				$je--;
				if ($Main::true[$ie][$je]==2) {
					$Main::global_flag=1; $flag++;
				}
			}
			if ($flag) {
				while ($ie!=$i) {
				$ie++;
				$je++;
				set_white($ie,$je);	
				}
			}
		}
		if ($direct==2) {
			while ($je>=0 && $Main::true[$ie][$je] && !$flag) {
				$je--;
				if ($Main::true[$ie][$je]==2) {
					$Main::global_flag=1; $flag++;
				}
			}
			if ($flag) {
				while ($je!=$j) {
				$je++;
				set_white($ie,$je);	
				}
			}
		}
		if ($direct==3) {
			while ($ie>=0 && $je>=0 && $Main::true[$ie][$je] && !$flag) {
				$ie++;
				$je--;
				if ($Main::true[$ie][$je]==2) {
					$Main::global_flag=1; $flag++;
				}
			}
			if ($flag) {
				while ($ie!=$i) {
				$ie--;
				$je++;
				set_white($ie,$je);	
				}
			}

		}
		if ($direct==4) {
			while ($ie<=7 && $Main::true[$ie][$je] && !$flag) {
				$ie++;
				if ($Main::true[$ie][$je]==2) {
					$Main::global_flag=1; $flag++;
				}
			}
			if ($flag) {
				while ($ie!=$i) {
				$ie--;
				set_white($ie,$je);	
				}
			}

		}
		if ($direct==5) {
			while ($ie>=0 && $je>=0 && $Main::true[$ie][$je] && !$flag) {
				$ie++;
				$je++;
				if ($Main::true[$ie][$je]==2) {
					$Main::global_flag=1; $flag++;
				}
			}
			if ($flag) {
				while ($ie!=$i) {
				$ie--;
				$je--;
				set_white($ie,$je);	
				}
			}
		}
		if ($direct==6) {
			while ($je>=0 && $Main::true[$ie][$je] && !$flag) {
				$je++;
				if ($Main::true[$ie][$je]==2) {
					$Main::global_flag=1; $flag++;
				}
			}
			if ($flag) {
				while ($je!=$j) {
				$je--;
				set_white($ie,$je);	
				}
			}
	
		}
		if ($direct==7) {
			while ($ie>=0 && $je>=0 && $Main::true[$ie][$je] && !$flag) {
				$ie--;
				$je++;
				if ($Main::true[$ie][$je]==2) {
					$Main::global_flag=1; $flag++;
				}
			}
			if ($flag) {
				while ($ie!=$i) {
				$ie++;
				$je--;
				set_white($ie,$je);	
				}
			}
		}
		if ($direct==8) {
			while ($ie<=7 && $Main::true[$ie][$je] && !$flag) {
				$ie--;
				if ($Main::true[$ie][$je]==2) {
					$Main::global_flag=1; $flag++;
				}
			}
			if ($flag) {
				while ($ie!=$i) {
				$ie++;
				set_white($ie,$je);	
				}
			}
		}
	}
}
}
Gtk2->main;
1;

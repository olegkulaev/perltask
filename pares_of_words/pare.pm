package pare;
sub new {
$class = shift;
$hash = {first => "$_[0]",second =>"$_[1]",freq => "$_[2]",next => 0};
bless $hash,$class;
return $hash;
}
1;

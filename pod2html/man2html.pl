#!/usr/bin/perl -l

local $/;
open F, $ARGV[0] or die "The file $ARGV[0] doesn't exist";
open(G,"> $ARGV[1]") or die "You should enter the name of output file";
$schref = 'aaaa';

sub th 							#функция для ТН
{
	local $str = $_[0];
	($name) = $str =~ /(\w+)/;
	($date) = $str =~ /(\w+\s\d{4})/;
	($sect) = $str =~ /([A-Z]\w+\s[A-Z]\w+)/;
	return "<H1>$name</H1>"."Updated: $date"."<BR>"."Section: $sect"."<BR>"."<A HREF='\#index'>Index</A><HR>";
}

sub bi 							#функция для тега BI
{
	local @strs = split(/\s+/,$_[0]);
	for (0..$#strs)
	{
		if (!$_%2)
		{
			$strs[$_];
			$strs[$_] = "<B>".$strs[$_]."</B>";
		}
		else
		{
			$strs[$_] = "<I>".$strs[$_]."</I>";
		}
	}
	return join(' ',@strs);
}

sub rb 							#функция для тега RB
{
	local @strs = split(/\s+/,$_[0]);
	for (0..$#strs)
	{
		if ($_%2)
		{
			$strs[$_] = "<B>".$strs[$_]."</B>";
		}
	}
	return join(' ',@strs);
}

sub ir 							#функция для тега IR
{
	local @strs = split(/\s+/,$_[0]);
	for (0..$#strs)
	{
		if (!$_%2)
		{
			$strs[$_] = "<I>".$strs[$_]."</I>";
		}
	}
	return join(' ',@strs);
}

sub br 							#функция для тега BR
{
	local @strs = split(/\s+/,$_[0]);
	for (0..$#strs)
	{
		if (!$_%2)
		{
			$strs[$_] = "<B>".$strs[$_]."</B>";
		}
	}
	return join(' ',@strs);
}

sub h2
{
	$ref[$i] = $schref++;
	#print "i: "."$i-1"."ref: ".$ref[$i-1]."str: ".$str;
	$names[$i] = $_[0];
	return "<A NAME='$ref[$i++]'>&nbsp;</A><H2>$_[0]</H2>"
}

sub index
{
	print $#ref;
	print (G "<HR><A NAME='index'>&nbsp;</A><H2>Index</H2><DL>");
	for (0..$#ref)
	{
		print (G "<DT><A HREF='\#$ref[$_]'>$names[$_]</A><DD>");
	}
	print (G "</DL>");
}

$all = <F>;
($title) = $all =~ /\.TH\s(\w+)/;
print (G "<HTML><HEAD><TITLE>Man page of $title</TITLE></HEAD><BODY>");

$all =~ s/\.\\*\"[^\n]*\n//g;
#убираем комментарии

$all =~ s/\"//g;
#убираем кавычки

$all =~ s/\.TH\s([^\n]+)/th($1)/e;
#раскрываем ТН

$all =~ s/\\\-/-/g;
#деэкранируем минусы

$all =~ s/(\.br|\.TP)/\<BR\>/g;
#перенос строки

$all =~ s/\.B\s([^\n]+)/\<B\>$1\<\/B\>/g;
#меняем тег bold

$all =~ s/\.I\s([^\n]+)/\<I\>$1\<\/I\>/g;
#меняем тег italic

$all =~ s/\.PP/<P>/g;

$all =~ s/\.SH\s\"*([^\n]+)\"*/h2($1)/ge;
#меняем заголовки

$all =~ s/\.BI\s([^\n]+)/bi($1)/ge;
#меняем тег BI

$all =~ s/\.RB\s([^\n]+)/rb($1)/ge;
#меняем тег RB

$all =~ s/\.BR\s([^\n]+)/br($1)/ge;
#меняем тег BR

$all =~ s/\.IR\s([^\n]+)/ir($1)/ge;
#меняем тег IR

$all =~ s/(ftp\:\/\/[^\s]+|http\:\/\/[^\s]+)/\<A\ HREF\=\"$1\"\>$1\<\/A\>/g;
#создаем внешние ссылки

print (G $all);
&index

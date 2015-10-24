 #!/usr/bin/perl

package server_response_color;

my $color_start = "\e[0;34m";
my $color_end = "\e[0m";

#Subroutine to process data
sub turn_color{
	my $data = shift;

	if ($data eq "off"){
		$color_start = "";
		$color_end = "";
	}elsif($data eq "on"){
		$color_start = "\e[0;34m";
		$color_end = "\e[0m";
	}
	return;
}

sub get_color_start{
	return $color_start;
}

sub get_color_end{
	return $color_end;
}

1127;

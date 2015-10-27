 #!/usr/bin/perl

package server_response_victim;

my $computer_os = "linux";

#Subroutine to process data
sub change_os{
	my $data = shift;
	my @avialable_os = <linux windows>;

	if (lc $data ~~ @avialable_os){
		$computer_os = lc $data;
	}
	return;
}

sub get_os_options{
	return "linux/windows";
}

sub get_os{
	return $computer_os;
}

1127;

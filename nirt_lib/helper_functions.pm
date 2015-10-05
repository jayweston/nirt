 #!/usr/bin/perl
package helper_functions;
use Cwd;

my $base_directory = getcwd;
my $current_directory = "";

#Subroutine to get secondary connection
sub create_secondary_connection{
	my $command = shift;

	#build the netcat command and run it
	my $cmd = server_response_netcat::get_netcat_name();
	$cmd .= " -l";
	$cmd .= " -p 1128";
	$cmd .= " >";
	$cmd .= " '$current_directory/$command'";
	system($cmd);
	return;
}

sub set_base_directory{
	$base_directory = shift;
	return;
}

sub get_base_directory{
	return $base_directory;
}

sub set_current_directory{
	$current_directory = shift;
	return;
}

sub get_current_directory{
	return $current_directory;
}

1127;

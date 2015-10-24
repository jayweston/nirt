 #!/usr/bin/perl

package server_response_netcat;

my $netcat_name = "nc";

#Subroutine to process Help
sub set_netcat_name{
	#Change the netcal call to the remaining data
	$netcat_name = shift;

	#Reply that command was enter successfully
	my $reply = server_response_color::get_color_start()."NetCat command call changed to '$netcat_name'\n".server_response_color::get_color_end();
	server_connection::send_message($reply);
	return;
}

sub get_netcat_name{
	return $netcat_name;
}

1127;
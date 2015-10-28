 #!/usr/bin/perl
package process_argv;

#Subroutine to process data
sub process_argv{

	my $flag = shift;
	my $flag_data = shift;

	if (lc $flag eq "-color"){
		server_response_color::turn_color($flag_data);
	}elsif (lc $flag eq "-device"){
		server_response_device::setup_device($flag_data);
	}elsif(lc $flag eq "-help"){
		print_help();
		exit;
	}elsif(lc $flag eq "-port"){
		server_connection::set_port_number($flag_data);
	}elsif(lc $flag eq "-user"){
		server_response_user::set_user($flag_data);
	}elsif(lc $flag eq "-os"){
		server_response_victim::change_os($flag_data);
	}else{
		print "Illegal use of flags.  Please use -help.";
		exit;
	}
	return;
}

sub print_help{
	print "\tcolor [on/off]\t\tStart with a given working directory (no spaces).\n";
	print "\tdevice [word]\t\tStart with a given working directory (no spaces).\n";
	print "\tport [1000 - 65535]\tChange the port number to start on (default is 1127).\n";
	print "\tuser [word]\t\tStart with a given username (no spaces).\n";
	print "\tos [".server_response_victim::get_os_options()."]\tSet starting OS for victim.\n";
	return;
}

1127;

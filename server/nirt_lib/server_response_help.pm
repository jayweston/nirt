 #!/usr/bin/perl

package server_response_help;

#Subroutine to process Help
sub display_help{
	my $reply =	"\tcommand [string -args] - Send a command output to the logging system.\n".
			"\tcomment [delimiter] - Send a comment to the loggins system.\n".
			"\tdevice [string] - Set the victim's device name (working directory).\n".
			"\texit - Stop or suspend the investigation.\n".
			"\tfile [string] - Senf a file to the logging system.\n".
			"\thelp - Your looking at it.\n".
			"\tcolor [on/off] - Turn the color on or off.\n".
			"\tuser [username] - Change the username that is displayed in the log file (currently ".server_response_user::get_user().").\n".
			"\tvictim [".server_response_victim::get_os_options()."] - Change the OS of the victim's computer (currently ".server_response_victim::get_os().").\n";
	server_connection::send_message($reply);
	return;
}

1127;

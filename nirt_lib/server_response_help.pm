 #!/usr/bin/perl

package server_response_help;

#Subroutine to process Help
sub display_help{
	my $reply =	server_response_color::get_color_start().	
			"\tcommand [string -args] - Send a command output to the logging system.\n".
			"\tcomment [delimiter] - Send a comment to the loggins system.\n".
			"\tdevice [string] - Set the victim's device name (working directory).\n".
			"\texit - Stop or suspend the investigation.\n".
			"\tfile [string] - Senf a file to the logging system.\n".
			"\thelp - Your looking at it.\n".
			"\tcolor [on/off] - Turn the color on or off.\n".
			"\tnetcat [string] - Change the command name used to call netcat.\n".
			server_response_color::get_color_end();
	server_connection::send_message($reply);

	return;
}

1127;

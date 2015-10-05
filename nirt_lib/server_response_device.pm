 #!/usr/bin/perl

package server_response_device;
use File::Path qw(make_path);
use Time::Piece;

my $device = "";

#Subroutine to process the device command
sub set_device{
	my $data = shift;

	if ($data eq ""){
		#request what to change the device to
		my $reply = server_response_color::get_color_start()."Device is currently set to: $device\nEnter new device: ".server_response_color::get_color_end();
		server_connection::send_message($reply);

		#get device name and set working directory
		$device = helper_functions::get_secondary_command("\n");
	}else{
		$device = $data;
	}

	helper_functions::set_current_directory( helper_functions::get_base_directory()."/".$device);

	#display working directory to user
	my $reply = server_response_color::get_color_start()."Working directory set to: ".helper_functions::get_current_directory()."\n".server_response_color::get_color_end();
	server_connection::send_message($reply);

	#make files folder
	eval { make_path(helper_functions::get_current_directory()."/files") };
	if ($@) {
		print "Couldn't create ".helper_functions::get_current_directory().": $@";
	}

	#make commands directory
	eval { make_path(helper_functions::get_current_directory()."/commands") };
	if ($@) {
		print "Couldn't create ".helper_functions::get_current_directory().": $@";
	}

	#make log file and input start time
	my $currentDateTime = localtime->strftime('%F %T');
	my $filename = helper_functions::get_current_directory()."/log.txt";
	open(my $fh, '>>', $filename) or die "Could not open file '$filename' $!";
	say $fh "Invstigation started at $currentDateTime";
	close $fh;

	return;
}

sub get_device{
	return $device;
}

1127;

 #!/usr/bin/perl

package server_response_device;
use File::Path qw(make_path);
use Time::Piece;

my $device = "not_set";

#Subroutine to process the device command
sub set_device{
	my $data = shift;
	my $reply = "";

	$device = $data;

	helper_functions::set_current_directory( helper_functions::get_base_directory()."/".$device);

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
	say $fh "Invstigation started at $currentDateTime\nby: ".server_response_user::get_user()."\n";
	close $fh;

	return;
}

sub get_device{
	return $device;
}

sub setup_device{
	$device = shift;
	return;
}

1127;

 #!/usr/bin/perl
package server_response_user;
use Time::Piece;

my $current_user = "unknown";

#Subroutine to process data
sub change_user{
	my $old_user = $current_user;
	$current_user = shift;

	#make log file and input start time
	my $currentDateTime = localtime->strftime('%F %T');
	my $filename = helper_functions::get_current_directory()."/log.txt";
	open(my $fh, '>>', $filename) or die "Could not open file '$filename' $!";
	say $fh "Username changed from $old_user to $current_user at $currentDateTime.\n";
	close $fh;

	return;
}

sub get_user{
	return $current_user;
}

sub set_user{
	$current_user = shift;
	return;
}

1127;


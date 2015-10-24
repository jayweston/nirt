 #!/usr/bin/perl
package server_response_file;
use Digest::MD5;
use Digest::SHA1;
use Time::Piece;

#Subroutine to process the file command
sub send_file{

	#get device name and set working directory
	my $command = shift;
	my $command_spaceless = $command;
	$command_spaceless =~ s/\s/_/g;
	$command_spaceless =~ s/\//-/g;
	$command_spaceless =~ s/\\/-/g;
	$command_spaceless = "files/$command_spaceless";

	#establish connection
	my $reply = server_response_color::get_color_start()."Please run: ".server_response_netcat::get_netcat_name()." ".server_connection::get_local_IP_address()." 1128 < [full path to $command]\n".server_response_color::get_color_end();
	server_connection::send_message($reply);
	helper_functions::create_secondary_connection($command_spaceless);

	#request what to change the device to
	$reply = server_response_color::get_color_start()."Transfer complete.\n".server_response_color::get_color_end();
	server_connection::send_message($reply);

	#Get hash for MD5
	my $md5_digest = Digest::MD5->new;
	open(my $fh, helper_functions::get_current_directory()."/$command_spaceless") or die "Could not open file '".helper_functions::get_current_directory()."/$command_spaceless' $!";	
		$md5_digest->addfile( $fh );
	close $fh;
	my $md5 = $md5_digest->hexdigest;

	#Get hashes for SHA1
	my $sha1_digest = Digest::SHA1->new;
	open($fh, helper_functions::get_current_directory()."/$command_spaceless") or die "Could not open file '".helper_functions::get_current_directory()."/$command_spaceless' $!";
		$sha1_digest->addfile( $fh );
	close $fh;
	my $sha1 = $sha1_digest->hexdigest;

	#Create log entry
	my $currentDateTime = localtime->strftime('%F %T');
	my $filename = helper_functions::get_current_directory().'/log.txt';
	open($fh, '>>', $filename) or die "Could not open file '$filename' $!";
	say $fh "\nfile: $command\nAccepted at: $currentDateTime\nMD5: $md5\nSHA1: $sha1\n";
	close $fh;

	return;
}

1127;
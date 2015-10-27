 #!/usr/bin/perl
package server_response_file;
use Digest::MD5;
use Digest::SHA1;
use Time::Piece;

#Subroutine to process the file command
sub send_file{
	
	#get device name and set working directory
	my $command = shift;
	my $last_char = substr $command, -1;
	if ($last_char eq " "){
		$command = substr $command, 0, -1;
	}
	if ($command =~ /^'/ || $command =~ /^"/){
		$command = substr $command, 1, -1;
	}
	my $command_spaceless = $command;
	$command_spaceless =~ s/\s/_/g;
	$command_spaceless =~ s/\//-/g;
	$command_spaceless =~ s/\\/-/g;
	$command_spaceless = "files/$command_spaceless";

	my $file_contents = server_connection::get_secondary_command("`~`");

	#create file with output
	my $filename = helper_functions::get_current_directory()."/$command_spaceless";
	open(my $fh, '>>', $filename) or die "Could not open file '$filename' $!";
		say $fh $file_contents;
	close $fh;

	#Get hash for MD5
	my $md5_digest = Digest::MD5->new;
	$md5_digest->add( $file_contents );
	my $md5 = $md5_digest->hexdigest;

	#Get hashes for SHA1
	my $sha1_digest = Digest::SHA1->new;
	$sha1_digest->add( $file_contents );
	my $sha1 = $sha1_digest->hexdigest;

	#Create log entry
	my $currentDateTime = localtime->strftime('%F %T');
	$filename = helper_functions::get_current_directory().'/log.txt';
	open($fh, '>>', $filename) or die "Could not open file '$filename' $!";
		say $fh "File: $command\nAccepted at: $currentDateTime\nby: ".server_response_user::get_user()."\nMD5: $md5\nSHA1: $sha1\n";
	close $fh;
	return;
}

1127;

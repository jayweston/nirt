 #!/usr/bin/perl

package server_response_comment;
use Digest::MD5;
use Digest::SHA1;
use Time::Piece;

#Subroutine to process the comment command
sub send_comment{

	my $delimiter = shift;

	#Get comment	
	my $reply = "$delimiter ";
	server_connection::send_message($reply);

	my $comment = server_connection::get_secondary_command($delimiter);

	#Get hashes for the file
	my $md5_digest = Digest::MD5->new;
	my $sha1_digest = Digest::SHA1->new;
	$sha1_digest->add($comment);
	$md5_digest->add($comment);
	my $sha1 = $sha1_digest->hexdigest;
	my $md5 = $md5_digest->hexdigest;

	#Create log entry
	my $currentDateTime = localtime->strftime('%F %T');
	my $filename = helper_functions::get_current_directory().'/log.txt';
	open(my $fh, '>>', $filename) or die "Could not open file '$filename' $!";
	say $fh "comment: $comment\nAccepted at: $currentDateTime\nby: ".server_response_user::get_user()."\nMD5: $md5\nSHA1: $sha1\n";
	close $fh;

	return;
}

1127;

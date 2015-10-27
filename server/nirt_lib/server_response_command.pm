 #!/usr/bin/perl
package server_response_command;
use Digest::MD5;
use Digest::SHA1;
use Time::Piece;

#Subroutine to process the command command
sub send_command{
	#get device name and set working directory
	$command = shift;
	$command_spaceless = $command;
	$command_spaceless =~ s/\s/_/g;
	$command_spaceless =~ s/\//-/g;
	$command_spaceless =~ s/\\/-/g;
	$command_spaceless = "commands/$command_spaceless";

	my $os_version = server_response_victim::get_os();
	my $command_2_use = "";

	if ($os_version eq "linux"){ 
		$command_2_use = builtin_linux_commands($command);
	}elsif($os_version eq "windows"){
		$command_2_use = builtin_windows_commands($command);
	}else{
		$command_2_use = $command; 
	}

	server_connection::send_message($command_2_use, "off");

	my $command_output = server_connection::get_secondary_command("`~`");

	#create file with output
	my $filename = helper_functions::get_current_directory()."/$command_spaceless";
	open(my $fh, '>>', $filename) or die "Could not open file '$filename' $!";
		say $fh $command_output;
	close $fh;

	#Get hash for MD5
	my $md5_digest = Digest::MD5->new;
	$md5_digest->add( $command_output );
	my $md5 = $md5_digest->hexdigest;

	#Get hashes for SHA1
	my $sha1_digest = Digest::SHA1->new;
	$sha1_digest->add( $command_output );
	my $sha1 = $sha1_digest->hexdigest;

	#Create log entry
	my $currentDateTime = localtime->strftime('%F %T');
	$filename = helper_functions::get_current_directory().'/log.txt';
	open($fh, '>>', $filename) or die "Could not open file '$filename' $!";
	say $fh "Command: $command\nAccepted at: $currentDateTime\nby: ".server_response_user::get_user()."\nMD5: $md5\nSHA1: $sha1\n";
	close $fh;
	return;
}

sub builtin_linux_commands{
	my $command = shift;
	if ($command =~ /^find/){$command = "./programs/linux/internal/".$command;}
	elsif ($command =~ /^date/){$command = "./programs/linux/internal/".$command;}
	return $command;
}

sub builtin_windows_commands{
	my $command = shift;
	if ($command =~ /^nbtstat/){$command = "./programs/windows/internal/".$command;}
	elsif ($command =~ /^whoami/){$command = "./programs/windows/internal/".$command;}
	elsif ($command =~ /^fport/){$command = "./programs/windows/fport/".$command;}
	return $command;
}

sub builtin_windows_commands{
	my $command = shift;

	return $command;
}

1127;

#!/usr/bin/perl
use strict;
use warnings;
use IO::Socket;

my $server_ip = "127.11.27.10";
my $server_port = 1127;

my $total_argv = $#ARGV;
for (my $i = 0; $i <= $total_argv; $i=$i+2){
	process_argv($ARGV[$i], $ARGV[$i+1]);
}

#use input parameters to set socket.
my $socket = new IO::Socket::INET (
    PeerAddr  => $server_ip,
    PeerPort  =>  $server_port,
    Proto => 'tcp',
)
or die "Could not connect to server. Try nirt_client [ip_address] [port]\n";
$socket->autoflush(1);

#upon connecting recieve initial data and print it to screen.
my $recv_data = "";
$socket->recv($recv_data,1024);
print $recv_data;

#run loop until you recieve 'exiting...\n' from server.
my $x=1;
my $send_data = "";
while ($x==1) {
	$send_data = <STDIN>;

	#Send message to server.
	$socket->send($send_data);

	if($send_data eq "exit\n"){
		$socket->close();
		$x=2;
		last;
	}elsif ($send_data =~ /^command /){
		my $sent_command = "";
		$socket->recv($sent_command,1024);
		my $command_output = `$sent_command`;
		$socket->send($command_output."`~`");
	}elsif ($send_data =~ /^file /){
		$send_data =~ s/^\S+\s*//;
		chomp($send_data);
		my $last_char = substr $send_data, -1;
		if ($last_char eq " "){
			$send_data = substr $send_data, 0, -1;
		}
		if ($send_data =~ /^'/ || $send_data =~ /^"/){
			$send_data = substr $send_data, 1, -1;
		}
		my $file_2_read = $send_data;
		if (-f $file_2_read){
			open my $fh, '<', $file_2_read or die "error opening $file_2_read: $!";
			my $file_content = do { local $/; <$fh> };
			$socket->send($file_content."`~`");
		}else{
			$socket->send("File not found.`~`");
		}
		
	}elsif ($send_data =~ /^comment /){
		$socket->recv($recv_data,1024);
		print $recv_data;
		$send_data =~ s/^\S+\s*//;
		my $delimiter = $send_data;
		my $secondaryData = "";
		while (1){
			my $recieved_data = <STDIN>;
			$secondaryData = $secondaryData.$recieved_data;
			if ($secondaryData =~ /$delimiter/) {
				$secondaryData =~ s/$delimiter.*//;
				chomp($secondaryData);
				$secondaryData = $secondaryData.$delimiter;
				$socket->send($secondaryData);
				last;
			}
		}
	}
	$socket->recv($recv_data,1024);
	print $recv_data;
}

sub process_argv{
	my $flag = shift;
	my $flag_data = shift;

	if (lc $flag eq "-ip"){
		$server_ip = $flag_data;
	}elsif(lc $flag eq "-help"){
		print_help();
		exit;
	}elsif(lc $flag eq "-port"){
		if ($flag_data < 1000 || $flag_data > 65535){
			die "Invalid port.";
		}
		$server_port = $flag_data;
	}else{
		print "Illegal use of flags.  Please use -help.";
		exit;
	}
	return;
}

sub print_help{
	print "\tip [IP Address]\tUse the given IP address to connect to the logging system (default 127.0.0.1).\n";
	print "\tport [1000 - 65535]\tChange the port number to start on (default is 1127).\n";
	return;
}

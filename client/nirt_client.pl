#!/usr/bin/perl
use strict;
use warnings;
use 5.010;
use IO::Socket;

#command line input parameter <ip address> <port>
#if their is no 1st input parameter set it to local host.
if ($ARGV[0] eq ""){
	$ARGV[0] = "localhost";
}

#if their is no 2nd input parameter set it to 1127.
if ($ARGV[1] eq ""){
	$ARGV[1] = "1127";
}

#use input parameters to set socket.
my $socket = new IO::Socket::INET (
    PeerAddr  => $ARGV[0],
    PeerPort  =>  $ARGV[1],
    Proto => 'tcp',
)
or die "Couldn't connect to Server\n";

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
		
	}
	$socket->recv($recv_data,1024);
	print $recv_data;
}

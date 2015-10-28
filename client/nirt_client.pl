#!/usr/bin/perl
use strict;
use warnings;
use IO::Socket;

my ($server_ip, $server_port) = @ARGV;
if (not defined $server_ip){$server_ip = "localhost";}
if (not defined $server_port){$server_port = "1127";}

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
		print "sss\n";
		$socket->send($command_output."`~`");
		print "ttt\n";
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

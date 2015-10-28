 #!/usr/bin/perl

package server_connection;
use IO::Socket;
use Time::Piece;

my $client_socket;
my $socket;
my $local_ip_address = "127.0.0.1";
my $port_number = "1127";

#define new socket and initialize it.
sub create_socket(){
	$socket = new IO::Socket::INET (
		LocalPort => $port_number,
		Proto => "tcp",
		Listen => 1,
		Reuse => 1,
		type => SOCK_STREAM,
	);die "Coudn't open socket" unless $socket;
	$socket->autoflush(1);
}

#Subroutine to get secondary command
sub get_secondary_command{
	my $delimiter = shift;
	my $secondaryData = "";
	while (1){
		#Wait for message from client
		$client_socket->recv($recieved_data,106496);

		#Append received content to the end of data.  If data does not end with the set delimiter then rerun loop to get more data.
		$secondaryData = $secondaryData.$recieved_data;

		#make sure it is a complete command and then process it.
		if ($secondaryData =~ /$delimiter/) {
			#remove delimiter and everything after it.
			$secondaryData =~ s/$delimiter.*//;
			chomp($secondaryData);
			#Process data and set it back to blank.
			return ($secondaryData);
		}
	}
	return;
}

sub start_listening{
	$client_socket = $socket->accept();
	$client_socket->autoflush(1);

	#Declare variables that will be used.
	my $user_command="";
	my $recieved_data = "";

	#Print welcome message.
	print "Connected to client.\n";
	my $user_message = "Victim's OS is set to ".server_response_victim::get_os().".\nType 'help' for a command list.\nCommand: ";
	send_message($user_message);

	#Run until exit is typed.
	while (1){
		#Wait for a message from the client.
		$client_socket->recv($recieved_data,1024);

		#Append received content to the end of current command.  If data does not end with \n, then rerun loop to get more data.
		$user_command = $user_command.$recieved_data;

		#Make sure it is a complete command and then process it.
		if ($user_command eq "exit\n"){
			$user_message = "Exiting\n";
			send_message($user_message);
			last;
		}elsif (substr($user_command, -1) eq "\n"){

			#remove the \n and pass the command to be processed.
			chop($user_command);

			#Process data and set it back to blank.
			$user_message="";			
			$user_message= process_response::process_command($user_command);
			$user_command="";

			#Send output message for next command.
			$user_message = $user_message."Command: ";
			send_message($user_message);
		}
	}

	#Add exiting time to log file.
	my $current_date_time = localtime->strftime("%F %T");
	my $filename = helper_functions::get_current_directory()."/log.txt";
	open(my $fh, ">>", $filename) or die "Could not open file '$filename': $!";
	say $fh "Invstigation ended at $current_date_time\n";
	close $fh;
	return;
}

sub send_message{
	$message = shift;
	$show_color = shift;
	if ($show_color eq "off"){
		$client_socket->send($message);
	}else{
		$message = server_response_color::get_color_start()."$message".server_response_color::get_color_end();
		$client_socket->send($message);
	}
	return;
}

#Suberoutine to get locap ip address
sub find_local_IP_address {
	my $socket_ip = IO::Socket::INET->new(
		Proto       => 'udp',
		PeerAddr    => '198.41.0.4', # a.root-servers.net
		PeerPort    => '53', # DNS
	);

	#A side-effect of making a socket connection is that our IP address is available from the 'sockhost' method
	$local_ip_address = $socket_ip->sockhost;
	return;
}


#Suberoutine to get locap ip address
sub get_local_IP_address {
	return $local_ip_address;
}

sub get_port_number{
	return $port_number;
}

sub set_port_number{
	$port_number = shift;
	return;
}

1127;

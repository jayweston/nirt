 #!/usr/bin/perl

package server_connection;
use IO::Socket;
use Time::Piece;

#define new socket and initialize it.
my $socket = new IO::Socket::INET (
	LocalPort => "1127",
	Proto => "tcp",
	Listen => 1,
	Reuse => 1,
);die "Coudn't open socket" unless $socket;

my $client_socket;

my $local_ip_address = "127.0.0.1";

#Subroutine to get secondary command
sub get_secondary_command{
	my $delimiter = shift;
	my $secondaryData = "";
	while (1){

		#Wait for message from client
		$client_socket->recv($recieved_data,1024);

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
	$socket->autoflush(1);
	$client_socket->autoflush(1);

	#Declare variables that will be used.
	my $user_command="";
	my $recieved_data = "";

	#Get device name and create working directory for the invstigation.
	server_response_device::get_device();

	#Print welcome message.
	my $user_message = server_response_color::get_color_start()."Type 'help' for a command list.\n".server_response_color::get_color_end();
	send_message($user_message);

	$user_message = server_response_color::get_color_start()."Command: ".server_response_color::get_color_end();
	send_message($user_message);

	#Run until exit is typed.
	while (1){
		#Wait for a message from the client.
		$client_socket->recv($recieved_data,1024);

		#Append received content to the end of current command.  If data does not end with \n, then rerun loop to get more data.
		$user_command = $user_command.$recieved_data;

		#Make sure it is a complete command and then process it.
		if ($user_command eq "exit\n"){
			$user_message = server_response_color::get_color_start()."Exiting\n".server_response_color::get_color_end();
			send_message($user_message);
			last;
		}elsif (substr($user_command, -1) eq "\n"){

			#remove the \n and pass the command to be processed.
			chop($user_command);

			#Process data and set it back to blank.
			process_response::process_command($user_command);
			$user_command="";

			#Send output message for next command.
			$user_message = server_response_color::get_color_start()."Command: ".server_response_color::get_color_end();
			send_message($user_message);

		#If user wants to exit.
		}
	}

	#Add exiting time to log file.
	my $current_date_time = localtime->strftime("%F %T");
	my $filename = helper_functions::get_current_directory()."/log.txt";
	open(my $fh, ">>", $filename) or die "Could not open file '$filename': $!";
	say $fh "Invstigation ended at $current_date_time";
	close $fh;
	return;
}

sub send_message{
	$message = shift;
	$client_socket->send($message);
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

1127;
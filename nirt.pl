 #!/usr/bin/perl
use strict;
use warnings;
use 5.010;

use nirt_lib::helper_functions;
use nirt_lib::process_responses;
use nirt_lib::server_connection;
use nirt_lib::server_response_color;
use nirt_lib::server_response_command;
use nirt_lib::server_response_comment;
use nirt_lib::server_response_device;
use nirt_lib::server_response_file;
use nirt_lib::server_response_help;
use nirt_lib::server_response_netcat;

server_connection::find_local_IP_address();
print "Waiting for netcat connection: ".server_response_netcat::get_netcat_name()." ".server_connection::get_local_IP_address()." 1127\n";
server_connection::start_listening();

#test

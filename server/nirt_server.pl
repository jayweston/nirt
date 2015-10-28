 #!/usr/bin/perl
use strict;
use warnings;

if (defined $ARGV[0]){server_connection::set_port_number($ARGV[0]);}
if (defined $ARGV[1]){server_response_device::setup_device($ARGV[1]);}

use nirt_lib::helper_functions;
use nirt_lib::process_responses;
use nirt_lib::server_connection;
use nirt_lib::server_response_color;
use nirt_lib::server_response_command;
use nirt_lib::server_response_comment;
use nirt_lib::server_response_device;
use nirt_lib::server_response_file;
use nirt_lib::server_response_help;
use nirt_lib::server_response_victim;
use nirt_lib::server_response_user;

server_response_device::set_device(server_response_device::get_device());
server_connection::create_socket();
server_connection::find_local_IP_address();
print "Waiting for connection: ".server_connection::get_local_IP_address()." ".server_connection::get_port_number()."\n";
server_connection::start_listening();

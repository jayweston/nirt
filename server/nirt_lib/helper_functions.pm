 #!/usr/bin/perl
package helper_functions;
use Cwd;

my $base_directory = getcwd;
my $current_directory = "";

sub set_base_directory{
	$base_directory = shift;
	return;
}

sub get_base_directory{
	return $base_directory;
}

sub set_current_directory{
	$current_directory = shift;
	return;
}

sub get_current_directory{
	return $current_directory;
}

1127;

package Nagios::Plugin::ServiceStatus;

use warnings;
use strict;
use English qw(-no_match_vars);
use Carp;

use version; our $VERSION = qv('0.0.1');

use File::Basename qw(basename);
use Nagios::Plugin;

our @EXPORT_OK = qw(invoke);

sub _create_plugin {
    my $plugin
        = Nagios::Plugin->new( usage => 'Usage: %s -s <service_name>' );
    $plugin->add_arg(
        spec => 'service|s=s',
        help => '-s, --service=STRING:STRING . The name of the service',
    );
    return $plugin;
}

sub _validate_service_name {
    my ($plugin) = @_;

    # The service name must be specified.
    my $service = $plugin->opts->service;
    if ( !defined $service || $service =~ m/ \A \s* \z /xms ) {
        $plugin->nagios_die(' a service name must be specified');
    }

    return;
}

sub _check_status {
    my ($plugin) = @_;

    # Open subprocess.
    my $service    = $plugin->opts->service;
    my $executable = '/sbin/service';
    open my $in, q{-|}, $executable, $service, 'status'
        or $plugin->nagios_die(" unable to execute $executable: $ERRNO");

    # Slurp the output.
    my $output = do { local $RS = undef; <$in> };

    # Close the subrpocess.
    close $in
        or $plugin->nagios_die(" $executable returned: $CHILD_ERROR");

    return $output;
}

sub _determine_exit_code {
    my ($status) = @_;

    # The exit code is determined based on the status message.
    my $exit_code
        = $status =~ m/running/xms     ? OK
        : $status =~ m/dead/xms        ? CRITICAL
        : $status =~ m/ \A \s* \z /xms ? CRITICAL
        :                                UNKNOWN;

    return $exit_code;
}

sub invoke {
    my @args = @_;

    # Use the arguments passed to us.
    local @ARGV = @args;

    # Build the Nagios::Plugin instance.
    my $plugin = _create_plugin();

    # Parse and validate the command-line options.
    $plugin->getopts();
    _validate_service_name($plugin);

    # Check the service status.
    my $status = _check_status($plugin);

    # Exit with the appropriate status code and message.
    $plugin->nagios_exit(
        return_code => _determine_exit_code($status),
        message     => $status,
    );

    return;
}

1;    # Magic true value required at end of module
__END__

=head1 NAME

Nagios::Plugin::ServiceStatus - Nagios plugin to check initd services.


=head1 VERSION

This document describes Nagios::Plugin::ServiceStatus version 0.0.1


=head1 SYNOPSIS

    use Nagios::Plugin::ServiceStatus qw(invoke);

    # Use arguments from the command line.
    invoke(@ARGV);

    # Use specific arguments.
    invoke( "-s", "some-service" );
    invoke("--service=some-service");

For direct use from within Nagios, try the check_service script.

=head1 DESCRIPTION

This module uses /sbin/service to check the status of an initd service. The
returned status is OK (0) if the service is running, CRITICAL (2) if the
service is not running and UNKNOWN (4) if the status of the service can't be
determined.

=head1 SUBROUTINES/METHODS

=head2 invoke

The arguments that are passed to this subroutine are treated as command-line
arguments because this module is intended to be used from within a script. The
important argument to this script is --service (which can be abbreviated, -s).
This argument is used to specify the name of the service to check.

Arguments:

=over

=item --service -s

The name of the service to check. This is the only required argument.

=item --host -H

The name of the host being checked.

=item --verbose -v

Display verbose output. This option is currently ignored because there's
generally only one line to be displayed.

=item --help

Display a help message and exit.

=item --usage

Display a brief usage message and exit.

=item --timeout

Set a timeout for the check. This option is currently ignored.

=back

=head1 DIAGNOSTICS

=over

=item C<< a service name must be specified >>

The --service or -s argument was not specified on the command line.

=item C<< unable to execute /sbin/service: %s >>

The command, /sbin/service, could not be executed. Verify that the command is
present and that the user has permission to read and execute it.

=item C<< /sbin/service returned %s >>

The command, /sbin/service, could be executed, but it returned an error status
code. Try running the command manually to determine the cause of the error.

=back


=head1 CONFIGURATION AND ENVIRONMENT

Nagios::Plugin::ServiceStatus requires no configuration files or environment
variables.


=head1 DEPENDENCIES

=over

=item Nagios::Plugin

Used to make it a little easier to satisfy all of the requirements for Nagios
plugins.

=item Test::More

Used to run unit tests.

=item version

Used to specify the module version number.

=back

=head1 INCOMPATIBILITIES

None reported.


=head1 BUGS AND LIMITATIONS

No bugs have been reported.

Please report any bugs or feature requests to the Core Software team.


=head1 AUTHOR

Dennis Roberts  C<< <dennis@iplantcollaborative.org> >>


=head1 LICENSE AND COPYRIGHT

L<http://www.iplantcollaborative.org/sites/default/files/iPLANT-LICENSE.txt>

use strict;
use warnings;
use Module::Build;

my $builder = Module::Build->new(
    module_name        => 'Nagios::Plugin::ServiceStatus',
    license            => 'bsd',
    configure_requires => { 'Module::Build' => 0.42 },
    dist_author        => 'Dennis Roberts <dennis@iplantcollaborative.org>',
    dist_version_from  => 'lib/Nagios/Plugin/ServiceStatus.pm',
    requires           => {
        'Nagios::Plugin' => 0,
        'Test::More'     => 0,
        'version'        => 0,
    },
    add_to_cleanup => ['Nagios-Plugin-ServiceStatus-*'],
    script_files   => ['script/check_service'],
);

$builder->create_build_script();

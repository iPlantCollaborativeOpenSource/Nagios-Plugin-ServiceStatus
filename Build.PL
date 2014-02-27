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
        'IPC::Run'          => 0,
        'Math::Calc::Units' => 0,
        'Nagios::Plugin'    => 0,
        'Readonly'          => 0,
        'Readonly::XS'      => 0,
        'version'           => 0,
    },
    test_requires  => {
        'File::Which'         => 0,
        'Perl::Critic'        => 0,
        'Pod::Coverage'       => 0,
        'Pod::Spell'          => 0,
        'Test::More'          => 0,
        'Test::Perl::Critic'  => 0,
        'Test::Pod::Coverage' => 0,
        'Test::Pod'           => 0,
        'YAML'                => 0,
    },
    add_to_cleanup => ['Nagios-Plugin-ServiceStatus-*'],
    script_files   => ['script/check_service'],
);

$builder->create_build_script();

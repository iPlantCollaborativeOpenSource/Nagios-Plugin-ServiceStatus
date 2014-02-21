# Nagios-Plugin-ServiceStatus

A Nagios plugin for systems that use `initd` to manage running services. The
plugin script runs `/sbin/service <service-name> status` to determine the status
of the service and returns an error status if the service isn't running.

INSTALLATION

To install this module, run the following commands:

```
Perl Build.PL
./Build
./Build test
./Build install
```

DEPENDENCIES

* Nagios::Plugin
* Test::More
* version

COPYRIGHT AND LICENCE

http://www.iplantcollaborative.org/sites/default/files/iPLANT-LICENSE.txt

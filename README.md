puppet-ipt-toolkit
===================

Puppet modules for deployment of ipt-toolkit

Parameters
-------------
All parameters are read from hiera but the defaults should also generate a clean working ipt-toolkit

Classes
-------------
- ipt-toolkit
- ipt-toolkit::backup
- ipt-toolkit::restore
- ipt-toolkit::proxy

Dependencies
-------------
- apache2 module from puppetlabs version 0.8.1
- tomcat module from example42 version 2.1.3
- puppi module from example42 version 2.0.8 
- concat module
- stlib module
- duplicity module

Examples
-------------
Hiera yaml
dest_id and dest_key are API keys for amazon s3 account
almost all values in the example except backup and restore are also the default values found in init.pp
```
ipt-toolkit::sitename: 'develop.cloud.naturalis.nl',
ipt-toolkit::proxyvhostpriority: 10,
ipt-toolkit::proxysite: true,
ipt-toolkit::proxyport: 80,
ipt-toolkit::datadir: '/data/ipt',
ipt-toolkit::datarootdirs: ['/data'],
ipt-toolkit::iptsource: 'https://gbif-providertoolkit.googlecode.com/files/ipt-2.0.5-security-update-1.war',
ipt-toolkit::iptname: 'ipt-2.0.5-security-update-1',  
ipt-toolkit::deployroot: '/var/lib/tomcat6/webapps',
ipt-toolkit::tomcatuser: 'tomcat6',
ipt-toolkit::tomcatgroup: 'tomcat6',
ipt-toolkit::JAVA_OPTS: '-Djava.awt.headless=true -Xmx256m -XX:+UseConcMarkSweepGC',
ipt-toolkit::backup: true,
ipt-toolkit::restore: true,
ipt-toolkit::filetorestore: 'data/ipt',
ipt-toolkit::backup: true
ipt-toolkit::backuphour: 3
ipt-toolkit::backupminute: 3
ipt-toolkit::backupdir: '/tmp/backups'
ipt-toolkit::dest_id: 'provider_id'
ipt-toolkit::dest_key: 'provider_key'
ipt-toolkit::bucket: 'ipt-toolkit'
```
Puppet code
```
class { ipt-toolkit: }
```
Result
-------------
Tomcat6 instance with ipt toolkit installed and configured data directory. 
backup: true then with duplicity daily backup of the data directory
restore: true then with duplicity restore of the data directory during installation
proxy: true then with apache proxy configuration for the ipt-toolkit 

Limitations
-------------
This module has been built on and tested against Puppet 3 and higher.

The module has been tested on:
- Ubuntu 12.04LTS


Authors
-------------
Author Name <hugo.vanduijn@naturalis.nl>


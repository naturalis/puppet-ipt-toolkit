# == Class: ipt-toolkit
#
# Full description of class ipt-toolkit here.
#
# === Parameters
#
# Document parameters here.
#
# [*sample_parameter*]
#   Explanation of what this parameter affects and what it defaults to.
#   e.g. "Specify one or more upstream ntp servers as an array."
#
# === Variables
#
# Here you should define a list of variables that this module would require.
#
# [*sample_variable*]
#   Explanation of how this variable affects the funtion of this class and if
#   it has a default. e.g. "The parameter enc_ntp_servers must be set by the
#   External Node Classifier as a comma separated list of hostnames." (Note,
#   global variables should be avoided in favor of class parameters as
#   of Puppet 2.6.)
#
# === Examples
#
#  class { ipt-toolkit:
#    servers => [ 'pool.ntp.org', 'ntp.local.company.com' ],
#  }
#
# === Authors
#
# Author Name <author@domain.com>
#
# === Copyright
#
# Copyright 2013 Your name here, unless otherwise noted.
#
class ipt-toolkit (
  $datadir 		= '/data/ipt',
  $datarootdirs 	= ['/data'],
  $iptsource 		= 'https://gbif-providertoolkit.googlecode.com/files/ipt-2.0.5-security-update-1.war',
  $iptname		= 'ipt-2.0.5-security-update-1',  
  $deployroot		= '/var/lib/tomcat6/webapps',
  )
{
  file { $datarootdirs:
    ensure         => 'directory',
    mode           => '0755',
  }

  file { $datadir:
    ensure         => 'directory',
    mode           => '0777',
    require	   => File[$datarootdirs],
  }
  class { "tomcat": 
    puppi    => true,
  }

  puppi::project::war { "ipt-toolkit":
    source           => $iptsource,
    deploy_root      => $deployroot,
    enable	     => true,
    auto_deploy	     => true,
    always_deploy    => true,
    clean_deploy     => true,
    require	     => Class['tomcat'],

  }

  file { "${deployroot}/${iptname}/datadir.location":
    content 	     => template('ipt-toolkit/datadir.location.erb'),
    mode             => '0600',
    require          => Exec['Run_Puppi_ipt-toolkit'],
 }   
}

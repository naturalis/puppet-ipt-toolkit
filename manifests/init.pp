# == Class: ipt-toolkit
#
# ipt-toolkit puppet manifest
#
# === Authors
#
# Author Name <hugo.vanduijn@naturalis.nl>
#
#
class ipt-toolkit (
  $sitename             = 'develop.cloud.naturalis.nl',
  $proxyvhostpriority   = 10,
  $proxysite            = true,
  $proxyport            = 80,
  $datadir              = '/data/ipt',
  $datarootdirs         = ['/data'],
  $iptsource            = 'https://gbif-providertoolkit.googlecode.com/files/ipt-2.0.5-security-update-1.war',
  $iptname              = 'ipt-2.0.5-security-update-1',  
  $deployroot           = '/var/lib/tomcat6/webapps',
  $tomcatuser           = 'tomcat6',
  $tomcatgroup          = 'tomcat6',
  $JAVA_OPTS            = '-Djava.awt.headless=true -Xmx256m -XX:+UseConcMarkSweepGC',
  $backup               = false,
  $restore              = false,
  $filetorestore        = 'data/ipt',
  $backuphour           = 2,
  $backupminute         = 15,
  $version              = 'latest',
  $bucket               = 'ipt',
  $bucketfolder         = 'backups',
  $dest_id              = undef,
  $dest_key             = undef,
  $cloud                = 's3',
  $pubkey_id            = undef,
  $full_if_older_than   = undef,
  $remove_older_than    = undef,
  $timeout              = 300,
  )
{
  file { $datarootdirs:
    ensure             => 'directory',
    mode               => '0755',
  }

  file { $datadir:
    ensure             => 'directory',
    mode               => '0700',
    owner              => $tomcatuser,
    group              => $tomcatgroup,
    require            => [File[$datarootdirs],Class['tomcat']],
  }
  
  class { "tomcat": 
    puppi              => true,
  }
 
  
  class {"ipt-toolkit::puppideploy":
    source             => $iptsource,
    deploy_root        => $deployroot,
    require            => Class['tomcat'],
  }

  exec { "Run_Puppi_ipt":
    command            => 'puppi deploy ipt-toolkit',
    path               => '/bin:/sbin:/usr/sbin:/usr/bin',
    timeout            => $timeout,
    require            => Class['ipt-toolkit::puppideploy'],
  }

  file { "${deployroot}/${iptname}/WEB-INF/datadir.location":
    content            => template('ipt-toolkit/datadir.location.erb'),
    mode               => '0644',
    owner              => $tomcatuser,
    group              => $tomcatgroup,
    require            => Exec['Run_Puppi_ipt'],
  }

  file { "/etc/default/tomcat6":
    content            => template('ipt-toolkit/tomcat6.erb'),
    mode               => '0644',
    require            => Class['tomcat'],
  }

  exec { "restart_tomcat6":
    command            => 'service tomcat6 restart',
    path               => '/bin:/sbin:/usr/sbin:/usr/bin',
    timeout            => $timeout,
    require            => File['/etc/default/tomcat6'],
  }

# Add hostname to /etc/hosts, svn checkout requires a resolvable hostname
  host { 'localhost':
    ip => '127.0.0.1',
    host_aliases => [ $hostname ],
  }

 if $backup == true {
    class { 'ipt-toolkit::backup':
      backuphour         => $backuphour,
      backupminute       => $backupminute,
      backupdir          => $datadir,
      bucket             => $bucket,
      folder             => $bucketfolder,   
      dest_id            => $dest_id,
      dest_key           => $dest_key,
      cloud              => $cloud,
      pubkey_id          => $pubkey_id,
      full_if_older_than => $full_if_older_than,
      remove_older_than  => $remove_older_than,
    }
  }

  if $restore == true {
    class { 'ipt-toolkit::restore':
      version            => $restoreversion,
      filetorestore      => $filetorestore,
      datadir            => $datadir,
      restore_directory  => $datadir,
      bucket             => $bucket,
      folder             => $bucketfolder,   
      dest_id            => $dest_id,
      dest_key           => $dest_key,
      cloud              => $cloud,
      pubkey_id          => $pubkey_id,
    }
  }

  if $proxysite == true {
    class { 'ipt-toolkit::proxy':
      proxy_pass                        => [{ 'path' => '/', 'url' => "http://localhost:8080/${iptname}/" }],
      proxy_pass_preserve_host          => true,
      proxy_pass_reverse_cookie_path    => [{ 'path' => '/', 'url' => "/${iptname}" }],
      priority                          => $proxyvhostpriority,
      port                              => $proxyport,
      name                              => $sitename,
    }
  }

}
